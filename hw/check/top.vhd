library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity top is
	port(
		clk : in std_logic;
		rst : in std_logic;

		dnepr_tr_start : in std_logic;
		dnepr_tr_stop : in std_logic;
		dnepr_rc_start : in std_logic;
		dnepr_rc_stop : in std_logic;

		voronej_fu1 : in std_logic;
		voronej_fu2 : in std_logic;

		err : out std_logic
	);
end top;

architecture Behavioral of top is

	signal err_overlay : std_logic := '0';
	signal err_sequence : std_logic := '0';

	type state_type is (st1_wait_tr_start, st2_wait_tr_stop, st3_wait_rc_start, st4_wait_rc_stop, st5_error_sequence);
	signal state, next_state : state_type;
	attribute FSM_ENCODING : string;
	attribute FSM_ENCODING of state: signal is "USER";
	attribute ENUM_ENCODING: STRING;
	attribute ENUM_ENCODING of state_type : type is "001 010 011 100 101";

	signal dnepr_tr_start_t : std_logic := '0';
	signal dnepr_tr_stop_t : std_logic := '0';
	signal dnepr_rc_start_t : std_logic := '0';
	signal dnepr_rc_stop_t : std_logic := '0';
	signal tr_start : std_logic := '0';
	signal tr_stop : std_logic := '0';
	signal rc_start : std_logic := '0';
	signal rc_stop : std_logic := '0';

	signal err_cnt : std_logic_vector(26 downto 0) := (others => '1');

begin
	edges: process(clk)
	begin
		if (clk'event and clk = '1') then
			dnepr_tr_start_t <= dnepr_tr_start;
			dnepr_tr_stop_t <= dnepr_tr_stop;
			dnepr_rc_start_t <= dnepr_rc_start;
			dnepr_rc_stop_t <= dnepr_rc_stop;

			tr_start <= dnepr_tr_start and not dnepr_tr_start_t;
			tr_stop <= dnepr_tr_stop and not dnepr_tr_stop_t;
			rc_start <= dnepr_rc_start and not dnepr_rc_start_t;
			rc_stop <= dnepr_rc_stop and not dnepr_rc_stop_t;
		end if ;
	end process ;

	SYNC_PROC: process (clk)
	begin
		if (clk'event and clk = '1') then
			if (rst = '1') then
				state <= st1_wait_tr_start;
			else
				state <= next_state;
			end if;
		end if;
	end process;

	NEXT_STATE_DECODE: process (state, tr_start, tr_stop, rc_start, rc_stop)
	begin
		next_state <= state;
		
		case (state) is
			when st1_wait_tr_start=>
				if (tr_start = '1') then
					next_state <= st2_wait_tr_stop;
				elsif (tr_stop = '1' or rc_start = '1' or rc_stop = '1') then
					next_state <= st5_error_sequence;
				end if;
			when st2_wait_tr_stop =>
				if (tr_stop = '1') then
					next_state <= st3_wait_rc_start;
				elsif (tr_start = '1' or rc_start = '1' or rc_stop = '1') then
					next_state <= st5_error_sequence;
				end if;
			when st3_wait_rc_start =>
				if (rc_start = '1') then
					next_state <= st4_wait_rc_stop;
				elsif (tr_start = '1' or tr_stop = '1' or rc_stop = '1') then
					next_state <= st5_error_sequence;
				end if ;
			when st4_wait_rc_stop =>
				if (rc_stop = '1') then
					next_state <= st1_wait_tr_start;
				elsif (tr_start = '1' or tr_stop = '1' or rc_start = '1') then
					next_state <= st5_error_sequence;
				end if ;
			when st5_error_sequence =>
				next_state <= st1_wait_tr_start;
			when others =>
				next_state <= st1_wait_tr_start;
		end case;      
	end process;

	err_sequence <= '1' when state = st5_error_sequence else '0';

	overlay : process(clk)
	begin
		if (clk'event and clk = '1') then
			if (voronej_fu1 = '1' and (rc_start = '1' or rc_stop = '1')) then
				err_overlay <= '1';
			elsif (voronej_fu2 = '1' and (tr_start = '1' or tr_stop = '1')) then
				err_overlay <= '1';
			else
				err_overlay <= '0';
			end if ;
		end if;
	end process;

	counting : process(clk)
	begin
		if (clk'event and clk = '1') then
			if (rst = '1') then
				err_cnt <= (others => '1');
			else
				if (err_overlay = '1' or err_sequence = '1') then
					err_cnt <= (others => '0');
				elsif (err_cnt(26) = '1') then
					err_cnt <= err_cnt;
				else
					err_cnt <= err_cnt + '1';
				end if;
			end if;
		end if;
	end process;

	err <= not err_cnt(26);


end Behavioral;

