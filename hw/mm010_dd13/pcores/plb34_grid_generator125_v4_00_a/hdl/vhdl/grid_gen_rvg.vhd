library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--library UNISIM;
--use UNISIM.VComponents.all;

entity grid_gen_rvg is
	port(
		rst : in  STD_LOGIC;
		clk : in  STD_LOGIC;
		clk_19 : in  STD_LOGIC;
		clk_1_25 : in  STD_LOGIC;
		tact_ppc_en : in  STD_LOGIC;
		tact_ppc : in  STD_LOGIC_VECTOR (15 downto 0);
		tact : out  STD_LOGIC_VECTOR (15 downto 0);
		discr : out  STD_LOGIC_VECTOR (15 downto 0)
	);
end grid_gen_rvg;

architecture Behavioral of grid_gen_rvg is

	signal tact_int : integer range 0 to 65535 := 0;
	signal discr_int : integer range 0 to 65535 := 0;
	signal tact_ppc_load_en : std_logic := '0';
	signal tact_write_en : std_logic := '0';
	signal tact_arm_cnt : integer range 0 to 256 := 0; -- 9-bit counter, higher bit as enable

begin

	tact <= conv_std_logic_vector(tact_int, 16);

	tact_write_en <= conv_std_logic_vector(tact_arm_cnt, 9)(8);

	debounce_19: process(clk)
	begin
		if (clk'event and clk = '1') then
			if (rst = '1') then
				tact_arm_cnt <= 0;
			else
				if (conv_std_logic_vector(tact_arm_cnt, 9)(8) = '1') then
					tact_arm_cnt <= tact_arm_cnt;
				elsif (clk_19 = '1') then
					tact_arm_cnt <= 0;
				elsif (clk_1_25 = '1') then
					tact_arm_cnt <= tact_arm_cnt + 1;
				else
					tact_arm_cnt <= tact_arm_cnt;
				end if;
			end if;
		end if;
	end process;

	tact_ppc_load_en_proc: process(clk)
	begin
		if (clk'event and clk = '1') then
			if (rst = '1') then
				tact_ppc_load_en <= '0';
			elsif (conv_std_logic_vector(discr_int,16)(15 downto 13) = "111" or
					conv_std_logic_vector(discr_int,16)(15 downto 6) = "0000000000") then
				tact_ppc_load_en <= '0';
			else
				tact_ppc_load_en <= '1';
			end if;
		end if;
	end process;

	tact_proc: process(clk)
	begin
		if (clk'event and clk = '1') then
			if (rst = '1') then
				tact_int <= 0;
			else
				if (tact_ppc_en = '1' and tact_ppc_load_en = '1') then
					tact_int <= conv_integer(tact_ppc);
				elsif (clk_19 = '1' and tact_write_en = '1') then
					tact_int <= tact_int + 1;
				end if;
			end if;
		end if;
	end process;
	
	discr <= conv_std_logic_vector(discr_int, 16);
	
	discr_proc: process(clk)
	begin
		if (clk'event and clk  = '1') then
			if (rst = '1') then
				discr_int <= 0;
			else
				if (clk_19 = '1') then
					discr_int <= 0;
				elsif (clk_1_25 = '1') then
					discr_int <= discr_int + 1;
				else
					discr_int <= discr_int;
				end if;
			end if;
		end if;
	end process;
	
end Behavioral;

