library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library UNISIM;
use UNISIM.VComponents.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity fu2_119 is
	port (
			--CLK_40M: in std_logic;
--LEDS		
		   REDGREEN_D1_OK: out std_logic;
			REDGREEN_D2_PT: out std_logic;

--УПР1 X8
			fu1_01: out std_logic;
			fu1_02: out std_logic;
			fu1_03: out std_logic;
			fu1_04: out std_logic;
			fu1_05: out std_logic;
			fu1_06: out std_logic;
			fu1_07: out std_logic;
			fu1_08: out std_logic;
				
--УПР2 X8
			fu1_09: out std_logic;
			fu1_10: out std_logic;
			fu1_11: out std_logic;
			fu1_12: out std_logic;
			fu1_13: out std_logic;
			fu1_14: out std_logic;
			fu1_15: out std_logic;
			fu1_16: out std_logic;

--УПР3 X10
			fu2_01: out std_logic;
			fu2_02: out std_logic;
			fu2_03: out std_logic;
			fu2_04: out std_logic;
			fu2_05: out std_logic;
			fu2_06: out std_logic;
			fu2_07: out std_logic;
			fu2_08: out std_logic;
				
--УПР4 X10
			fu2_09: out std_logic;
			fu2_10: out std_logic;
			fu2_11: out std_logic;
			fu2_12: out std_logic;
			fu2_13: out std_logic;
			fu2_14: out std_logic;
			fu2_15: out std_logic;
			fu2_16: out std_logic;

			
--PMC	

			
			pmc_tc: out std_logic;-- сигнал 40МГц от соеденителя Xw2 к PMC XS3
			
			pmc_fu1_01: in std_logic;
			pmc_fu1_02: in std_logic;
			pmc_fu1_03: in std_logic;
			pmc_fu1_04: in std_logic;
			pmc_fu1_05: in std_logic;
			pmc_fu1_06: in std_logic;
			pmc_fu1_07: in std_logic;
			pmc_fu1_08: in std_logic;
			pmc_fu1_09: in std_logic;
			pmc_fu1_10: in std_logic;
			pmc_fu1_11: in std_logic;
			pmc_fu1_12: in std_logic;
			pmc_fu1_13: in std_logic;
			pmc_fu1_14: in std_logic;
			pmc_fu1_15: in std_logic;
			pmc_fu1_16: in std_logic;
			
			pmc_fu2_01: in std_logic;
			pmc_fu2_02: in std_logic;
			pmc_fu2_03: in std_logic;
			pmc_fu2_04: in std_logic;
			pmc_fu2_05: in std_logic;
			pmc_fu2_06: in std_logic;
			pmc_fu2_07: in std_logic;
			pmc_fu2_08: in std_logic;
			pmc_fu2_09: in std_logic;
			pmc_fu2_10: in std_logic;
			pmc_fu2_11: in std_logic;
			pmc_fu2_12: in std_logic;
			pmc_fu2_13: in std_logic;
			pmc_fu2_14: in std_logic;
			pmc_fu2_15: in std_logic;
			pmc_fu2_16: in std_logic;
			
			pmc_ok: in std_logic;
			pmc_pt: in std_logic;
			
			
			
			
			XW2: in std_logic 
			
			);
			
			
end fu2_119;

architecture Behavioral of fu2_119 is


	
	signal clk_tc: std_logic;
	signal clk: std_logic;
	

begin


			
fu1_01<=pmc_fu1_01;
fu1_02<=pmc_fu1_02;
fu1_03<=pmc_fu1_03;
fu1_04<=pmc_fu1_04;
fu1_05<=pmc_fu1_05;
fu1_06<=pmc_fu1_06;
fu1_07<=pmc_fu1_07;
fu1_08<=pmc_fu1_08;
fu1_09<=pmc_fu1_09;
fu1_10<=pmc_fu1_10;
fu1_11<=pmc_fu1_11;
fu1_12<=pmc_fu1_12;
fu1_13<=pmc_fu1_13;
fu1_14<=pmc_fu1_14;
fu1_15<=pmc_fu1_15;
fu1_16<=pmc_fu1_16;

fu2_01<=pmc_fu2_01;
fu2_02<=pmc_fu2_02;
fu2_03<=pmc_fu2_03;
fu2_04<=pmc_fu2_04;
fu2_05<=pmc_fu2_05;
fu2_06<=pmc_fu2_06;
fu2_07<=pmc_fu2_07;
fu2_08<=pmc_fu2_08;
fu2_09<=pmc_fu2_09;
fu2_10<=pmc_fu2_10;
fu2_11<=pmc_fu2_11;
fu2_12<=pmc_fu2_12;
fu2_13<=pmc_fu2_13;
fu2_14<=pmc_fu2_14;
fu2_15<=pmc_fu2_15;
fu2_16<=pmc_fu2_16;			
			

REDGREEN_D1_OK<=pmc_ok;
REDGREEN_D2_PT<=pmc_pt;


clk_tc<=XW2;
pmc_tc<=clk_tc;



end Behavioral;

