--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   16:12:30 03/24/2010
-- Design Name:   
-- Module Name:   C:/active_work/ise/sim/sym_plb34_plb_ps34_sim/pcores/plb34_ps_119_v1_00_a/devl/projnav/tb_PS_isp_avt.vhd
-- Project Name:  plb34_ps_119
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: PS_isp_avt
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
 
ENTITY tb_PS_isp_avt IS
END tb_PS_isp_avt;
 
ARCHITECTURE behavior OF tb_PS_isp_avt IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT PS_isp_avt
    PORT(
         rst_sys : IN  std_logic;
         clk_sys : IN  std_logic;
         clk_d : IN  std_logic;
         takt_number : IN  std_logic_vector(15 downto 0);
         discr_number : IN  std_logic_vector(15 downto 0);
         Ntakt_reg : IN  std_logic_vector(31 downto 0);
         Nach_isp_d_reg : IN  std_logic_vector(31 downto 0);
         Dlit_isp_d_reg : IN  std_logic_vector(31 downto 0);
         Control_reg : IN  std_logic_vector(31 downto 0);
         Status_reg : OUT  std_logic_vector(31 downto 0);
         PS_isp : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal rst_sys : std_logic := '0';
   signal clk_sys : std_logic := '0';
   signal clk_d : std_logic := '0';
   signal takt_number : std_logic_vector(15 downto 0) := (others => '0');
   signal discr_number : std_logic_vector(15 downto 0) := (others => '0');
   signal Ntakt_reg : std_logic_vector(31 downto 0) := (others => '0');
   signal Nach_isp_d_reg : std_logic_vector(31 downto 0) := (others => '0');
   signal Dlit_isp_d_reg : std_logic_vector(31 downto 0) := (others => '0');
   signal Control_reg : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal Status_reg : std_logic_vector(31 downto 0);
   signal PS_isp : std_logic;

   -- Clock period definitions
   constant clk_sys_period : time := 1us;
   constant clk_d_period : time := 1us;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: PS_isp_avt PORT MAP (
          rst_sys => rst_sys,
          clk_sys => clk_sys,
          clk_d => clk_d,
          takt_number => takt_number,
          discr_number => discr_number,
          Ntakt_reg => Ntakt_reg,
          Nach_isp_d_reg => Nach_isp_d_reg,
          Dlit_isp_d_reg => Dlit_isp_d_reg,
          Control_reg => Control_reg,
          Status_reg => Status_reg,
          PS_isp => PS_isp
        );

   -- Clock process definitions
   clk_sys_process :process
   begin
		clk_sys <= '0';
		wait for clk_sys_period/2;
		clk_sys <= '1';
		wait for clk_sys_period/2;
   end process;
 
   clk_d_process :process
   begin
		clk_d <= '0';
		wait for clk_d_period/2;
		clk_d <= '1';
		wait for clk_d_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100ms.
      wait for 100ms;	

      wait for clk_sys_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
