library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--library UNISIM;
--use UNISIM.VComponents.all;

entity vco is
	generic(
		div_range : integer := 31
	);
	port(
		rst : in std_logic;
		clk : in std_logic;
		clk_div : in integer;
		
		clk_out : out std_logic
	);
end vco;

architecture Behavioral of vco is

	signal clk_count : integer range 0 to div_range := 0;
	signal clk_out_int : std_logic := '0';

begin

	vco_process: process(clk)
	begin
		if (clk'event and clk = '1') then
			if (rst = '1') then
				clk_count <= 0;
				clk_out_int <= '0';
			else
				if (clk_count >= clk_div-1) then
					clk_count <= 0;
				else
					clk_count <= clk_count + 1;
				end if;
			  
				if (clk_count = 0) then
					clk_out_int <= '1';
				elsif (clk_count >= clk_div/2) then
					clk_out_int <= '0';
				else
					clk_out_int <= clk_out_int;
--				else
--					clk_out_int <= '0';
				end if;
			end if;
	end if;
	end process;
	
	clk_out <= clk_out_int;

end Behavioral;

