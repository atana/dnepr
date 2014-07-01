--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   13:22:45 04/05/2010
-- Design Name:   
-- Module Name:   C:/active_work/ise/mpgf13_6ma119_7m010_HW/6MPGM_6MPS5_6B261_6A119_7M010_DD13/system/pcores/plb34_ps_119_v1_00_a/devl/projnav/tb_fifo_secure_uc.vhd
-- Project Name:  plb34_ps_119
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: FIFO_secure_uc
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
 
ENTITY tb_fifo_secure_uc IS
END tb_fifo_secure_uc;
 
ARCHITECTURE behavior OF tb_fifo_secure_uc IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT FIFO_secure_uc
    PORT(
         CLK : IN  std_logic;
         RST : IN  std_logic;
         FIFO_ENABLE : IN  std_logic;
         DIN : IN  std_logic_vector(47 downto 0);
         WE : IN  std_logic;
         wr_ack : OUT  std_logic;
         DOUT : OUT  std_logic_vector(47 downto 0);
         RE : IN  std_logic;
         valid : OUT  std_logic;
         FIFO_USE : OUT  std_logic_vector(5 downto 0);
         FULL : OUT  std_logic;
         EMPTY : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal CLK : std_logic := '0';
   signal RST : std_logic := '0';
   signal FIFO_ENABLE : std_logic := '0';
   signal DIN : std_logic_vector(47 downto 0) := (others => '0');
   signal WE : std_logic := '0';
   signal RE : std_logic := '0';

 	--Outputs
   signal wr_ack : std_logic;
   signal DOUT : std_logic_vector(47 downto 0);
   signal valid : std_logic;
   signal FIFO_USE : std_logic_vector(5 downto 0);
   signal FULL : std_logic;
   signal EMPTY : std_logic;

   constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: FIFO_secure_uc PORT MAP (
          CLK => CLK,
          RST => RST,
          FIFO_ENABLE => FIFO_ENABLE,
          DIN => DIN,
          WE => WE,
          wr_ack => wr_ack,
          DOUT => DOUT,
          RE => RE,
          valid => valid,
          FIFO_USE => FIFO_USE,
          FULL => FULL,
          EMPTY => EMPTY
        );
 
   -- No clocks detected in port list. Replace CLK below with 
   -- appropriate port name 
 
   CLK_process :process
   begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100ms.
			DIN <= (others => '0'); 
			WE <= '0';
			RE <= '0';			
			FIFO_ENABLE <= '1';
			RST <= '1';
      wait for 1 ms;	
			RST <= '0';
      -- insert stimulus here 
			DIN <= x"AAAA_AAAA_AAAA"; 
		wait until (clk'event and clk = '1');
			WE <= '1';
		wait until (clk'event and clk = '1');
			WE <= '0';
		
		-------------------------------
		wait until (clk'event and clk = '1');
			RE <= '1';
		wait until (clk'event and clk = '1');
			RE <= '0';
			
		wait until (clk'event and clk = '1');
			RE <= '1';
		wait until (clk'event and clk = '1');
			RE <= '0';		
      wait;
   end process;

END;
