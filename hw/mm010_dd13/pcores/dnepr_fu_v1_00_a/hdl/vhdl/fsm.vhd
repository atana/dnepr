library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fsm is
	Port(
		clk : in std_logic;
		rst : in std_logic;

		tact : in std_logic_vector(15 downto 0);
		discr : in std_logic_vector(15 downto 0);
		optical_line_delay : in std_logic_vector(15 downto 0);
		outrun : in std_logic_vector(15 downto 0);

		Tstart : in std_logic_vector(15 downto 0);
		Dstart : in std_logic_vector(15 downto 0);
		Tstop : in std_logic_vector(15 downto 0);
		Dstop : in std_logic_vector(15 downto 0);
		EMPTY : in std_logic;
		RE : out std_logic;

		start_pulse : out std_logic;
		stop_pulse : out std_logic
	);
end fsm;

architecture Behavioral of fsm is

	type state_type is (st1_wait_data, st2_read_data, st3_calc_delay_time, st4_calc_operative_time, st5_validate, st6_wait_stop); 
	signal state, next_state : state_type;

	signal end_strob : std_logic := '0';
	signal data_valid : std_logic := '0';

	signal current_time : std_logic_vector(31 downto 0) := (others => '0');
	signal delay_time : std_logic_vector(31 downto 0) := (others => '0');
	signal operative_time : std_logic_vector(31 downto 0) := (others => '0');
	--signal operative_tact : std_logic_vector(15 downto 0) := (others => '0');
	--signal operative_discr : std_logic_vector(15 downto 0) := (others => '0');
	signal start_time : std_logic_vector(31 downto 0) := (others => '0');
	signal stop_time : std_logic_vector(31 downto 0) := (others => '0');
	signal reserv_time : std_logic_vector(31 downto 0) := (others => '0');
	signal strob_length : std_logic_vector(31 downto 0) := (others => '0');

	signal stop_pulse_internal : std_logic := '0';
	signal stop_pulse_internal_t : std_logic := '0';

begin

	SYNC_PROC: process(clk)
	begin
	if (clk'event and clk = '1') then
		if (rst = '1') then
			state <= st1_wait_data;
		else
			state <= next_state;
		end if;
	end if;
	end process;

	NEXT_STATE_DECODE: process(state, EMPTY, data_valid, end_strob)
	begin
		next_state <= state;
		case (state) is
			when st1_wait_data =>
				if (EMPTY = '0') then
					next_state <= st2_read_data;
				end if;
			when st2_read_data =>
				next_state <= st3_calc_delay_time;
			when st3_calc_delay_time =>
				next_state <= st4_calc_operative_time;
			when st4_calc_operative_time =>
				next_state <= st5_validate;
			when st5_validate =>
				if (data_valid = '1') then
					next_state <= st6_wait_stop;
				else
					next_state <= st1_wait_data;
				end if ;
			when st6_wait_stop =>
				if (end_strob = '1') then
					next_state <= st1_wait_data;
				end if ;
			when others =>
				next_state <= st1_wait_data;
		end case;
	end process;

	read_data : process(clk)
	begin
		if (clk'event and clk = '1') then
			if (state = st2_read_data) then
				RE <= '1';
			else
				RE <= '0';
			end if ;
		end if ;
	end process ;

	current_time <= tact & discr;
	operative : process(clk)
	begin
		if (clk'event and clk = '1') then
			delay_time <= current_time + optical_line_delay;
			operative_time <= delay_time + outrun;
		end if ;
	end process ;
	--operative_tact <= operative_time(31 downto 16);
	--operative_discr <= operative_time(15 downto 0);

	start_time <= Tstart & Dstart;
	stop_time <= Tstop & Dstop;

	validate : process(clk)
	begin
		if (clk'event and clk = '1') then
			reserv_time <= start_time - operative_time;
			strob_length <= stop_time - start_time;
			-- reserv Tact < 8 and Discr > 10 and length < 1tact
			if ((reserv_time(31 downto 16) < x"0008") and (reserv_time(19 downto 0) > x"0000A") and (strob_length < x"00010000")) then
				data_valid <= '1';
			else
				data_valid <= '0';
			end if ;
		end if ;
	end process ;

	fu_gen : process(clk)
	begin
		if (clk'event and clk = '1') then
			if (rst = '1') then
				start_pulse <= '0';
				stop_pulse_internal <= '0';
			else
				if (start_time = operative_time) then
					start_pulse <= '1';
				else
					start_pulse <= '0';
				end if ;

				if (stop_time = operative_time) then
					stop_pulse_internal <= '1';
				else
					stop_pulse_internal <= '0';
				end if ;
			end if ;
		end if ;
	end process ;
	stop_pulse <= stop_pulse_internal;

	negedge_stop_pulse : process(clk)
	begin
		if (clk'event and clk = '1') then
			stop_pulse_internal_t <= stop_pulse_internal;
		end if ;
	end process ; -- negedge_stop_pulse

	end_fu : process(clk)
	begin
		if (clk'event and clk = '1') then
			if (state = st6_wait_stop) then
				if (stop_pulse_internal = '0' and stop_pulse_internal_t = '1') then
					end_strob <= '1';
				else
					end_strob <= '0';
				end if ;
			end if ;
		end if ;
	end process ;


end Behavioral;

