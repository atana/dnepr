
--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:22:17 08/31/2009
-- Design Name:   m_119_fu
-- Module Name:   D:/vadim/projects/6ma_119_fu2/fu2_119_tb.vhd
-- Project Name:  6ma_119_fu2
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: m_119_fu
--
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends 
-- that these types always be used for the top-level I/O of a design in order 
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;

ENTITY fu2_119_tb_vhd IS
END fu2_119_tb_vhd;

ARCHITECTURE behavior OF fu2_119_tb_vhd IS 

	-- Component Declaration for the Unit Under Test (UUT)
	COMPONENT fu2_119
	PORT(
		CLK_10M : IN std_logic;
		RX1 : IN std_logic;
		DSR1 : IN std_logic;
		CTS1 : IN std_logic;
		RX2 : IN std_logic;
		DSR2 : IN std_logic;
		CTS2 : IN std_logic;
		RX3 : IN std_logic;
		DSR3 : IN std_logic;
		CTS3 : IN std_logic;
		RX4 : IN std_logic;
		DSR4 : IN std_logic;
		CTS4 : IN std_logic;
		pmc_tx1 : IN std_logic;
		pmc_tx2 : IN std_logic;
		pmc_tx3 : IN std_logic;
		pmc_tx4 : IN std_logic;
		XW2 : IN std_logic;          
		REDGREEN_D1 : OUT std_logic;
		REDGREEN_D2 : OUT std_logic;
		TX1 : OUT std_logic;
		DTR1 : OUT std_logic;
		RTS1 : OUT std_logic;
		TX2 : OUT std_logic;
		DTR2 : OUT std_logic;
		RTS2 : OUT std_logic;
		TX3 : OUT std_logic;
		DTR3 : OUT std_logic;
		RTS3 : OUT std_logic;
		TX4 : OUT std_logic;
		DTR4 : OUT std_logic;
		RTS4 : OUT std_logic;
		pmc_rx1 : OUT std_logic;
		pmc_rx2 : OUT std_logic;
		pmc_rx3 : OUT std_logic;
		pmc_rx4 : OUT std_logic
		);
	END COMPONENT;

	--Inputs
	SIGNAL CLK_10M :  std_logic := '0';
	SIGNAL RX1 :  std_logic := '0';
	SIGNAL DSR1 :  std_logic := '0';
	SIGNAL CTS1 :  std_logic := '0';
	SIGNAL RX2 :  std_logic := '0';
	SIGNAL DSR2 :  std_logic := '0';
	SIGNAL CTS2 :  std_logic := '0';
	SIGNAL RX3 :  std_logic := '0';
	SIGNAL DSR3 :  std_logic := '0';
	SIGNAL CTS3 :  std_logic := '0';
	SIGNAL RX4 :  std_logic := '0';
	SIGNAL DSR4 :  std_logic := '0';
	SIGNAL CTS4 :  std_logic := '0';
	SIGNAL pmc_tx1 :  std_logic := '0';
	SIGNAL pmc_tx2 :  std_logic := '0';
	SIGNAL pmc_tx3 :  std_logic := '0';
	SIGNAL pmc_tx4 :  std_logic := '0';
	SIGNAL XW2 :  std_logic := '0';

	--Outputs
	SIGNAL REDGREEN_D1 :  std_logic;
	SIGNAL REDGREEN_D2 :  std_logic;
	SIGNAL TX1 :  std_logic;
	SIGNAL DTR1 :  std_logic;
	SIGNAL RTS1 :  std_logic;
	SIGNAL TX2 :  std_logic;
	SIGNAL DTR2 :  std_logic;
	SIGNAL RTS2 :  std_logic;
	SIGNAL TX3 :  std_logic;
	SIGNAL DTR3 :  std_logic;
	SIGNAL RTS3 :  std_logic;
	SIGNAL TX4 :  std_logic;
	SIGNAL DTR4 :  std_logic;
	SIGNAL RTS4 :  std_logic;
	SIGNAL pmc_rx1 :  std_logic;
	SIGNAL pmc_rx2 :  std_logic;
	SIGNAL pmc_rx3 :  std_logic;
	SIGNAL pmc_rx4 :  std_logic;

BEGIN

clk_proc: process
begin
CLK_10M <='0';
wait for 50 ns;
CLK_10M <='1';
wait for 50 ns;
end process;

tc_proc: process
begin
XW2<='0';
wait for 500 ns;
XW2<='1';
wait for 50 ns;
XW2<='0';
wait for 50 ns;
XW2<='1';
wait for 50 ns;
XW2<='0';
wait for 50 ns;
XW2<='1';
wait for 50 ns;
XW2<='0';
wait for 50 ns;
XW2<='1';
wait for 50 ns;
XW2<='0';
wait for 5000 ns;
XW2<='1';
wait for 50 ns;
XW2<='0';
wait for 50 ns;
XW2<='1';
wait for 50 ns;
XW2<='0';
wait for 50 ns;
XW2<='1';
wait for 50 ns;
XW2<='0';
wait for 50 ns;
XW2<='1';
wait for 50 ns;
XW2<='0';
wait;
end process;	

	-- Instantiate the Unit Under Test (UUT)
	uut: fu2_119 PORT MAP(
		CLK_10M => CLK_10M,
		REDGREEN_D1 => REDGREEN_D1,
		REDGREEN_D2 => REDGREEN_D2,
		RX1 => RX1,
		TX1 => TX1,
		DTR1 => DTR1,
		DSR1 => DSR1,
		RTS1 => RTS1,
		CTS1 => CTS1,
		RX2 => RX2,
		TX2 => TX2,
		DTR2 => DTR2,
		DSR2 => DSR2,
		RTS2 => RTS2,
		CTS2 => CTS2,
		RX3 => RX3,
		TX3 => TX3,
		DTR3 => DTR3,
		DSR3 => DSR3,
		RTS3 => RTS3,
		CTS3 => CTS3,
		RX4 => RX4,
		TX4 => TX4,
		DTR4 => DTR4,
		DSR4 => DSR4,
		RTS4 => RTS4,
		CTS4 => CTS4,
		pmc_rx1 => pmc_rx1,
		pmc_rx2 => pmc_rx2,
		pmc_rx3 => pmc_rx3,
		pmc_rx4 => pmc_rx4,
		pmc_tx1 => pmc_tx1,
		pmc_tx2 => pmc_tx2,
		pmc_tx3 => pmc_tx3,
		pmc_tx4 => pmc_tx4,
		XW2 => XW2
	);

	

END;
