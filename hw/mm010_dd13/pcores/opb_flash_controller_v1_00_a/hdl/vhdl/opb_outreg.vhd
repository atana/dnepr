--------------------------------------------------------------------------------
-- This VHDL file is generated by EASE/HDL from HDL Works B.V.,
-- the 'Graphical Systems Design Tool'.
--
-- Ease 5.2 Revision 5.
-- Design library : design.
-- Host name      : ILYA.
-- User name      : .
-- Time stamp     : Thu Oct 21 23:32:52 2004.
--
-- Designed by    : 
-- Company        : HDL Works.
-- Design info    : 
--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
-- Entity declaration of 'OPB_OUTREG'.
-- Last modified : Wed Apr 20 02:31:20 2005.
--------------------------------------------------------------------------------


library ieee ;
use ieee.std_logic_1164.all ;

entity OPB_OUTREG is
  port(
    IP2Bus_DBus      : in     std_logic_vector(0 to 31);
    Sl_DBus          : out    std_logic_vector(0 to 31);
    Sl_xferAck       : out    std_logic;
    OPB_Clk          : in     std_logic;
    OPB_Rst          : in     std_logic;
    IP2xferAck       : in     std_logic;
    Bus2IP_AddrValid : in     std_logic;
    Bus2IP_RNW       : in     std_logic;
    Sl_toutSup       : out    std_logic;
    IP2toutSup       : in     std_logic);
end entity OPB_OUTREG ;

--------------------------------------------------------------------------------
-- Architecture 'rtl' of 'OPB_OUTREG'
-- Last modified : Wed Apr 20 02:31:20 2005.
--------------------------------------------------------------------------------

architecture rtl of OPB_OUTREG is

signal xferAck : std_logic;

begin

process(OPB_Clk)
begin
	if (OPB_Clk'event and OPB_Clk = '1') then
    	if (OPB_Rst = '1' or xferAck = '1') then
    		Sl_DBus		<= (others =>'0');
    	elsif (IP2xferAck = '1' and Bus2IP_RNW = '1') then                         
    		Sl_DBus		<= IP2Bus_DBus;
    			
        end if;
    end if;
end process;

process(OPB_Clk)
begin
	if OPB_Clk'event and OPB_Clk = '1' then
    	if (OPB_Rst = '1') then
    		xferAck	<= '0';
    		Sl_toutSup	<= '0'; 
    	else                            
    		xferAck	<= IP2xferAck;
    		Sl_toutSup	<= IP2toutSup;
    	end if;
    end if;
end process;

Sl_xferAck <= xferAck;

end architecture rtl ; -- of OPB_OUTREG
