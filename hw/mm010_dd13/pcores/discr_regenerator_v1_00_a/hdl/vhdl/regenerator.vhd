library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--library UNISIM;
--use UNISIM.VComponents.all;

entity regenerator is
	generic(
		version : std_logic_vector(31 downto 0) := x"12041100";
		
		clk_freq : integer := 100000000;
		ref_clk_freq : integer := 19;
		discr_qnt : integer := 65536;
		array_stat : integer := 16
	);
	port(
		-- for ip-regs --------------
		state_cnt_int : out integer;
		state_calc_int : out integer;
		ready : out std_logic;
		tact_source : in std_logic; -- 0=ext, 1=int
		stat_cnt : out integer;
		-----------------------------
		
		rst : in std_logic;
		clk : in std_logic;

		ref_clk : in std_logic;
		ref_clk_present : in std_logic;

		tact_clk : out std_logic;
		discr_clk : out std_logic;
		edge_tact_clk : out std_logic;
		edge_discr_clk : out std_logic
	);
end regenerator;

architecture Behavioral of regenerator is

	function log2roundup (data_value : integer) return integer is
		variable width       : integer := 0;
		variable cnt         : integer := 1;
		constant lower_limit : integer := 1;
		constant upper_limit : integer := 32;
	begin
		if (data_value <= 1) then
			width := 0;
		else
			while (cnt < data_value) loop
				width := width + 1;
				cnt   := cnt *2;
			end loop;
		end if;
		return width;
	end log2roundup;

	component vco is
		generic(
			div_range : integer := 31
		);
		port(
			rst : in std_logic;
			clk : in std_logic;
			clk_div : in integer;
			
			clk_out : out std_logic
		);
	end component;

	constant discr_depth : integer := log2roundup(discr_qnt);
	constant array_depth : integer := log2roundup(array_stat);
	
	constant clk_cnt_tact_range : integer := clk_freq/ref_clk_freq + clk_freq/(10*ref_clk_freq); -- 10% zapas
	constant clk_cnt_discr_range : integer := clk_freq/(ref_clk_freq*discr_qnt) + clk_freq/(10*ref_clk_freq*discr_qnt); -- 10% zapas
	constant clk_cnt_discr_min : integer := clk_freq/(ref_clk_freq*discr_qnt) - clk_freq/(10*ref_clk_freq*discr_qnt); -- 10% zapas
	constant div_def : integer := clk_freq/(ref_clk_freq*discr_qnt);

	signal ref_clk_t : std_logic := '0';
	signal ref_clk_tt : std_logic := '0';
	signal edge_ref_clk : std_logic := '0';

	type state_counter is (st1_wait_edge, st1_wait_2_edge, st2_counting);
	signal state_cnt, next_state_cnt : state_counter;
--	signal state_cnt_int : integer range 0 to 7;

	signal clk_cnt : integer range 0 to clk_cnt_tact_range;
	signal cnt_error : std_logic := '0'; -- propal ref_clk ili slishkom malenkaya chastota
	type int_m is array (array_stat downto 1) of integer range 0 to clk_cnt_discr_range;
	type vec_m is array (array_stat downto 1) of std_logic_vector(16 downto 0);
	signal z0 : int_m;
	signal p0 : vec_m;
	signal index_wr : integer range 0 to array_stat := 0;
	signal index_rd : integer range 0 to array_stat := 0;
	signal index_cnt : integer range 0 to array_stat := 0;
	signal ready_int : std_logic := '0';

	type state_calculator is (st1_wait_ready, st2_init, st3_inc_p, st4_calc_z, st5_wait_edge_discr);
	signal state_calc, next_state_calc : state_calculator;
--	signal state_calc_int : integer range 0 to 7;

	signal discr_clk_in : std_logic := '0';
	signal discr_clk_t : std_logic := '0';
	signal edge_discr : std_logic := '0';
	signal discr : integer range 0 to discr_qnt+4 := 0;
	signal discr_over: std_logic := '0';
	signal z0_curr : integer range 0 to clk_cnt_discr_range := 0;
	signal p0_curr : std_logic_vector(16 downto 0) := (others => '0');
	signal z : integer range 0 to clk_cnt_discr_range := 0;
	signal p : std_logic_vector(16 downto 0) := (others => '0');
	signal div : integer range 0 to clk_cnt_discr_range;
	
	signal tact_clk_i : std_logic := '0';
	signal tact_clk_t : std_logic := '0';
	signal tact_clk_tt : std_logic := '0';
	signal tact_clk_stat : std_logic := '0';
	signal tact_clk_not_stat : std_logic := '0';
	signal discr_cnt : integer range 0 to discr_qnt+4 := 0;
	signal mux_source : std_logic_vector(1 downto 0) := "00";

begin

	edges : process(clk)
	begin
		if (clk'event and clk = '1') then
			if (rst = '1') then
				ref_clk_t <= '0';
				ref_clk_tt <= '0';
				edge_ref_clk <= '0';
			else
				ref_clk_t <= ref_clk;
				ref_clk_tt <= ref_clk_t;
				edge_ref_clk <= ref_clk_t and not ref_clk_tt;
			end if;
		end if;
	end process;

--###################### counting #######################################################################	
	num_state_cnt: process(state_cnt)
	begin
		case (state_cnt) is
			when st1_wait_edge => state_cnt_int <= 1;
			when st1_wait_2_edge => state_cnt_int <= 2;
			when st2_counting => state_cnt_int <= 3;
			when others => state_cnt_int <= 7;
		end case;
	end process;

	SYNC_PROC_cnt: process (clk)
   begin
      if (clk'event and clk = '1') then
         if (rst = '1' or ref_clk_present = '0' or cnt_error = '1') then --  or cnt_error = '1' -- dobavit' esli nujno
            state_cnt <= st1_wait_edge;
         else
            state_cnt <= next_state_cnt;
         end if;        
      end if;
   end process;

	NEXT_STATE_DECODE_cnt: process (state_cnt, edge_ref_clk)
   begin
      next_state_cnt <= state_cnt;
      case (state_cnt) is
         when st1_wait_edge =>
            if (edge_ref_clk = '1') then
               next_state_cnt <= st1_wait_2_edge;
            end if;
         
         when st1_wait_2_edge =>
            if (edge_ref_clk = '1') then
               next_state_cnt <= st2_counting;
            end if;
         
			when st2_counting =>
					next_state_cnt <= st2_counting;

			when others =>
            next_state_cnt <= st1_wait_edge;
      end case;      
   end process;

	count_proc: process(clk)
	begin
		if (clk'event and clk = '1') then
			if (rst = '1') then
				clk_cnt <= 0;
				ready_int <= '0';
				index_wr <= 1;
				clean: for i in 1 to 4 loop
					z0(i) <= div_def;
					p0(i) <= (others => '0');
				end loop;
				index_cnt <= 0;
				cnt_error <= '0';
			else
				if (state_cnt = st2_counting) then
					if (edge_ref_clk = '1') then
						if (conv_integer(conv_std_logic_vector(clk_cnt, 32)(31 downto 16)) > clk_cnt_discr_min) then -- zashita ot drebezga
							clk_cnt <= 0;
							ready_int <= '1';
							if (conv_std_logic_vector(index_wr, array_depth+1)(array_depth) = '1') then -- equivalent index_wr = 16
								index_wr <= 1;
							else
								index_wr <= index_wr + 1;
							end if;
							if (conv_std_logic_vector(index_cnt, array_depth+1)(array_depth) = '1') then -- equivalent index_cnt = 16
								index_cnt <= array_stat;
							else
								index_cnt <= index_cnt + 1;
							end if;
							z0(index_wr) <= conv_integer(conv_std_logic_vector(clk_cnt, 32)(31 downto 16)); -- equivalent clk_cnt/65536
							p0(index_wr) <= '0' & conv_std_logic_vector(clk_cnt, 32)(15 downto 0); -- equivalent clk_cnt % 65536
							cnt_error <= '0';
						else
							cnt_error <= '1';
						end if;
					else
						if (clk_cnt >= clk_cnt_tact_range) then
							clk_cnt <= clk_cnt;
							clk_cnt <= clk_cnt;
							cnt_error <= '1';
						else
							clk_cnt <= clk_cnt + 1;
							cnt_error <= '0';
						end if;
--						clk_cnt <= clk_cnt + 1;
						ready_int <= ready_int;
						index_wr <= index_wr;
					end if;
				else
					clk_cnt <= 0;
					ready_int <= ready_int;
					index_wr <= index_wr;
					cnt_error <= '0';
				end if;
			end if;
		end if;
	end process;
	
	ready <= ready_int;
	stat_cnt <= index_cnt;
--########################################################################################################################

--######################################### calculating ##################################################################

	process(state_calc)
	begin
		case (state_calc) is
			when st1_wait_ready => state_calc_int <= 1;
			when st2_init => state_calc_int <= 2;
			when st3_inc_p => state_calc_int <= 3;
			when st4_calc_z => state_calc_int <= 4;
			when st5_wait_edge_discr => state_calc_int <= 5;
			when others => state_calc_int <= 6;
		end case;
	end process;

	SYNC_PROC: process (clk)
   begin
      if (clk'event and clk = '1') then
         if (rst = '1' or ready_int = '0') then
            state_calc <= st1_wait_ready;
         else
            state_calc <= next_state_calc;
         end if;        
      end if;
   end process;

	NEXT_STATE_DECODE: process (state_calc, edge_ref_clk, edge_discr, discr_over)
   begin
      next_state_calc <= state_calc;
      case (state_calc) is
         when st1_wait_ready =>
				if (edge_ref_clk = '1') then	
					next_state_calc <= st2_init;
				end if;
         
			when st2_init =>
				if (edge_discr = '1') then -------------?
               next_state_calc <= st3_inc_p;
            end if;---------------------------------?
         
			when st3_inc_p =>
				next_state_calc <= st4_calc_z;

			when st4_calc_z =>
				next_state_calc <= st5_wait_edge_discr;
				
			when st5_wait_edge_discr =>
				if (edge_discr = '1') then
					if (discr_over = '1') then
						next_state_calc <= st2_init;
					else
						next_state_calc <= st3_inc_p;
					end if;
				end if;
         
			when others =>
            next_state_calc <= st1_wait_ready;
      end case;      
   end process;

	discr_over <= conv_std_logic_vector(discr,17)(16);

	index_rd_proc: process(clk)
	begin
		if (clk'event and clk = '1') then
			if (rst = '1') then
				index_rd <= 1;
			else
				if (discr_over = '1') then
						if (index_rd = index_cnt) then
							index_rd <= 1;
						else
							index_rd <= index_rd + 1;
						end if;
				end if;
			end if;
		end if;
	end process;
	
	process(clk)
	begin
		if (clk'event and clk = '1') then
			if (state_calc = st1_wait_ready) then
				p0_curr <= (others => '0');
--				z0_curr <= 0;
				z0_curr <= div_def;
				p <= (others => '0');
				z <= div_def;
				discr <= 0;
			elsif (state_calc = st2_init) then
				p0_curr <= p0(index_rd);
				z0_curr <= z0(index_rd);
--				p <= (others => '0');
				p <= p0(index_rd);
				z <= z0(index_rd);
--				discr <= 0;
				discr <= 1;
			elsif (state_calc = st3_inc_p) then
				p <= p + p0_curr;
				z <= z;
				discr <= discr + 1;
			elsif (state_calc = st4_calc_z) then
				if (p(16) = '1') then -- >= 65536
					p(16) <= '0';
					z <= z0_curr + 1;
				else
					p <= p;
					z <= z0_curr;
				end if;
			elsif (state_calc = st5_wait_edge_discr) then
				p <= p;
				z <= z;
			else
				p <= (others => '0');
--				z <= 0;
				z <= div_def;
			end if;
		end if;
	end process;
	
	div <= z;
--########################################################################################################################

	vco_inst: vco
	generic map(
		div_range => clk_cnt_discr_range
	)
	port map(
		rst => rst,
		clk => clk,
		clk_div => div,
		
		clk_out => discr_clk_in
	);

	process(clk)
	begin
		if (clk'event and clk =  '1') then
			if (rst = '1') then
				discr_clk_t <= '0';
				edge_discr <= '0';
			else
				discr_clk_t <= discr_clk_in;
				edge_discr <= discr_clk_in and not discr_clk_t;
			end if;
		end if;
	end process;
	discr_clk <= discr_clk_in;
	tact_clk_stat <= not conv_std_logic_vector(discr,17)(15);
	
	process(clk)
	begin
		if (clk'event and clk =  '1') then
			if (rst = '1') then
				discr_cnt <= 1;
			else
				if (edge_discr = '1') then
					if (conv_std_logic_vector(discr_cnt,17)(16) = '1') then
						discr_cnt <= 1;
					else
						discr_cnt <= discr_cnt + 1;
					end if;
				end if;
			end if;
		end if;
	end process;
	tact_clk_not_stat <= not conv_std_logic_vector(discr_cnt,17)(15);

--	mux_source <= tact_source & ready_int;
--	tact_clk_mux: process(mux_source, ref_clk, tact_clk_not_stat, tact_clk_stat)
--	begin
--		case(mux_source) is
--			when "00" => tact_clk_i <= ref_clk;
--			when "01" => tact_clk_i <= ref_clk;
--			when "10" => tact_clk_i <= tact_clk_not_stat;
--			when "11" => tact_clk_i <= tact_clk_stat;
--			when others => tact_clk_i <= ref_clk;
--		end case;
--	end process;
	mux_source <= ref_clk_present & ready_int;
	tact_clk_mux: process(mux_source, ref_clk, tact_clk_not_stat, tact_clk_stat)
	begin
		case(mux_source) is
			when "00" => tact_clk_i <= tact_clk_not_stat;
			when "01" => tact_clk_i <= tact_clk_stat;
			when "10" => tact_clk_i <= ref_clk;
			when "11" => tact_clk_i <= ref_clk;
			when others => tact_clk_i <= ref_clk;
		end case;
	end process;

	tact_clk <= tact_clk_i;
	
	edge_out: process(clk)
	begin
		if (clk'event and clk = '1') then
			if (rst = '1') then
			else
				tact_clk_t <= tact_clk_i;
				tact_clk_tt <= tact_clk_t;
				edge_tact_clk <= tact_clk_t and not tact_clk_tt;
			end if;
		end if;
	end process;
	edge_discr_clk <= edge_discr;

end Behavioral;

