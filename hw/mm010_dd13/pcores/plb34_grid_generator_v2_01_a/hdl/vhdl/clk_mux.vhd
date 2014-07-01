----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    14:53:15 02/27/2010 
-- Design Name: 
-- Module Name:    clk_mux - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
library UNISIM;
use UNISIM.VComponents.all;

entity clk_mux is
generic (
--				SIMULATION : boolean := false
				SIMULATION : boolean := true       -- for TIMESIM
         ); 
    Port ( Bus2IP_Clk 					: in  STD_LOGIC:= '0';
           Bus2IP_Reset 				: in  STD_LOGIC:= '0';
           CLK_EXT_19Hz 				: in  STD_LOGIC:= '0';
           CLK_EXT0_40MHz 				: in  STD_LOGIC:= '0';
           CLK_EXT1_40MHz 				: in  STD_LOGIC:= '0';
           INDEPENDET_WORK_EN 		: in  STD_LOGIC:= '0';
           CLK_EXT0_OR_EXT1	 		: in  STD_LOGIC:= '0';
           CLK_40MHz_Global_Clk 		: out  STD_LOGIC;
           CLK_40MHz_Global_Logic 	: out  STD_LOGIC;
           CLK_19Hz 						: out  STD_LOGIC);
end clk_mux;

architecture Behavioral of clk_mux is

signal Clk0								: std_logic:= '0';
signal CLK_40MHz_internal			: std_logic:= '0';
signal CLK_40MHz_Global_Clk_temp	: std_logic:= '0';
signal CLK_19Hz_Shift_Reg			: std_logic_vector(16 downto 0):= (others => '0');
signal CLK_19Hz_internal			: std_logic:= '0';
signal CLK_DIVIDE_Counter			: std_logic_vector (21 downto 0):= (others => '0');
signal RST_DCM							: std_logic:='0';

begin
   DCM_inst : DCM
   generic map (
      CLKDV_DIVIDE 			=> 2.0, 				--  Divide by: 1.5,2.0,2.5,3.0,3.5,4.0,4.5,5.0,5.5,6.0,6.5
															--     7.0,7.5,8.0,9.0,10.0,11.0,12.0,13.0,14.0,15.0 or 16.0
      CLKFX_DIVIDE 				=> 5,   			--  Can be any interger from 1 to 32
      CLKFX_MULTIPLY 			=> 2, 			--  Can be any integer from 1 to 32
      CLKIN_DIVIDE_BY_2 		=> FALSE, 		--  TRUE/FALSE to enable CLKIN divide by two feature
      CLKIN_PERIOD 				=> 10.0,       --  Specify period of input clock
      CLKOUT_PHASE_SHIFT 		=> "NONE", 		--  Specify phase shift of NONE, FIXED or VARIABLE
      CLK_FEEDBACK 				=> "1X",       --  Specify clock feedback of NONE, 1X or 2X
      DESKEW_ADJUST 				=> "SYSTEM_SYNCHRONOUS", --  SOURCE_SYNCHRONOUS, SYSTEM_SYNCHRONOUS or
                                             --     an integer from 0 to 15
      DFS_FREQUENCY_MODE 		=> "LOW",  		--  HIGH or LOW frequency mode for frequency synthesis
      DLL_FREQUENCY_MODE 		=> "LOW",  		--  HIGH or LOW frequency mode for DLL
      DUTY_CYCLE_CORRECTION 	=> TRUE,			--  Duty cycle correction, TRUE or FALSE
      FACTORY_JF 					=> X"C080",    --  FACTORY JF Values
      PHASE_SHIFT 				=> 0,       	--  Amount of fixed phase shift from -255 to 255
      SIM_MODE 					=> "SAFE", 		-- Simulation: "SAFE" vs "FAST", see "Synthesis and Simulation Design Guide" for details
      STARTUP_WAIT 				=> FALSE) 		--  Delay configuration DONE until DCM LOCK, TRUE/FALSE
   port map (
      CLK0 		=> CLK0,   	-- 0 degree DCM CLK ouptput
      CLK180 	=> open, 	-- 180 degree DCM CLK output
      CLK270 	=> open, 	-- 270 degree DCM CLK output
      CLK2X 	=> open,   	-- 2X DCM CLK output
      CLK2X180 => open, 	-- 2X, 180 degree DCM CLK out
      CLK90 	=> open,   	-- 90 degree DCM CLK output
      CLKDV 	=> open,   	-- Divided DCM CLK out (CLKDV_DIVIDE)
      CLKFX 	=> CLK_40MHz_internal,   -- DCM CLK synthesis out (M/D)
      CLKFX180 => open, 	-- 180 degree CLK synthesis out
      LOCKED 	=> open, 	-- DCM LOCK status output
      PSDONE 	=> open, 	-- Dynamic phase adjust done output
      STATUS 	=> open, 	-- 8-bit DCM status bits output
      CLKFB 	=> CLK0,   	-- DCM clock feedback
      CLKIN 	=> Bus2IP_Clk,   -- Clock input (from IBUFG, BUFG or DCM)
      PSCLK 	=> '0',   	-- Dynamic phase adjust clock input
      PSEN 		=> '0',     -- Dynamic phase adjust enable input
      PSINCDEC => '0', 		-- Dynamic phase adjust increment/decrement
      RST 		=> RST_DCM  -- DCM asynchronous reset input
   );


SRL16_inst : SRL16
generic map (
	INIT => X"FFFF")
port map (
	Q => RST_DCM, -- SRL data output
	A0 => '1',      -- Select[0] input
	A1 => '1',      -- Select[1] input
	A2 => '1',      -- Select[2] input
	A3 => '1',      -- Select[3] input
	CLK => Bus2IP_Clk,     -- Clock input
	D => '0'        -- SRL data input
);


CLK_40MHz_Global_CLK_BUFG : BUFG
					Port Map(I => CLK_40MHz_Global_Clk_temp,
								O => CLK_40MHz_Global_Clk);
CLK_40MHz_Global_Logic_BUFG : BUFG
					Port Map(I => CLK_40MHz_Global_Clk_temp,
								O => CLK_40MHz_Global_Logic);


GEN_SIMULATION_NONE_2: if (not SIMULATION) generate

							process (CLK_40MHz_internal)
							begin
							if (CLK_40MHz_internal'event and CLK_40MHz_internal ='1') then 

									if INDEPENDET_WORK_EN ='1' then
										CLK_DIVIDE_Counter<= CLK_DIVIDE_Counter + '1'; 
									else 
										CLK_DIVIDE_Counter<= (others => '0');
									end if;
									CLK_19Hz_Shift_Reg<= CLK_19Hz_Shift_Reg(15 downto 0) & CLK_DIVIDE_Counter(20); 
									CLK_19Hz_internal<= CLK_19Hz_Shift_Reg(0) and not CLK_19Hz_Shift_Reg(16);
							end if;
							end process;

end generate GEN_SIMULATION_NONE_2;


GEN_SIMULATION_2: if (SIMULATION) generate

							process (CLK_40MHz_internal)
							begin
							if (CLK_40MHz_internal'event and CLK_40MHz_internal ='1') then

									if INDEPENDET_WORK_EN ='1' then
										CLK_DIVIDE_Counter<= CLK_DIVIDE_Counter + '1';
									else 
										CLK_DIVIDE_Counter<= (others => '0');
									end if;
									CLK_19Hz_Shift_Reg<= CLK_19Hz_Shift_Reg(15 downto 0) & CLK_DIVIDE_Counter(11); --Sim
									CLK_19Hz_internal<= CLK_19Hz_Shift_Reg(0) and not CLK_19Hz_Shift_Reg(16);
							end if;
							end process;

end generate GEN_SIMULATION_2;


	CLK_19Hz <= CLK_19Hz_internal when INDEPENDET_WORK_EN = '1' else CLK_EXT_19Hz;

   CLK_40MHz_Global_Clk_temp <= CLK_40MHz_internal when (INDEPENDET_WORK_EN ='1') else
												CLK_EXT1_40MHz when (INDEPENDET_WORK_EN ='0' and CLK_EXT0_OR_EXT1 ='1') else
												CLK_EXT0_40MHz;

end Behavioral;

