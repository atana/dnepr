library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--  Uncomment the following lines to use the declarations that are
--  provided for instantiating Xilinx primitive components.
library UNISIM;
use UNISIM.VComponents.all;

entity pulse_fr_form is
    Port ( 
	        FRONT : in std_logic;
           CLK : in std_logic;
           OUT_PULSE : inout std_logic
			 );

end pulse_fr_form;

architecture struct of pulse_fr_form is


signal FRONT_STATE : std_logic := '0';
signal GSR : std_logic := '0';

begin
----------------------------------------------------------------------------------------------------------
-- Перенос импульса FRONT на частоту CLK
process (FRONT, GSR, OUT_PULSE) 
begin    
    if GSR = '1' or OUT_PULSE ='1' then
       FRONT_STATE <= '0';
    elsif (FRONT'event and FRONT = '1') then
       FRONT_STATE <= '1';
    end if;
end process;

process (CLK, GSR) 
begin    
    if GSR = '1' then
       OUT_PULSE <= '0';
    elsif (CLK'event and CLK = '1') then
	    if OUT_PULSE = '1' then
          OUT_PULSE <= '0';
	    elsif FRONT_STATE = '1' then
          OUT_PULSE <= '1';
       end if;
    end if;
end process;
----------------------------------------------------------------------------------------------------------
-- ROC
roc_inst: ROC port map (O => GSR);

end struct;
