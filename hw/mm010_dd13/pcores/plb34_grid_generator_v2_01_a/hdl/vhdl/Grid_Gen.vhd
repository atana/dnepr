----------------------------------------------------------------------------------
----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    12:50:51 02/25/2010 
-- Design Name: 
-- Module Name:    Grid_Gen - Behavioral 
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

entity Grid_Gen is
generic (
				SIMULATION : boolean := false
--				SIMULATION : boolean := true       -- for TIMESIM
         ); 
	Port (
			DISCRETE_NUMBER_SHIFT  	:in  std_logic_vector(15 downto 0):= x"0030"; --48;
			SHIFT_SYNC_CLK_50kHz  	:in  std_logic_vector(2 downto 0):= "011";
			INDEPENDET_WORK_EN		:in  std_logic:= '0';
			CLK_EXT0_OR_EXT1			:in  std_logic:= '0';
			Bus2IP_Reset				:in  std_logic:= '0';
			Bus2IP_Clk					:in  std_logic:= '0';
			CLK_EXT_19Hz				:in  std_logic:= '0';
			CLK_EXT0_40MHz				:in  std_logic:= '0';
			CLK_EXT1_40MHz				:in  std_logic:= '0';
			TAKT_NUMBER_UPDATE		:in  std_logic:= '0';
			Bus2IP_TAKT_NUMBER 	 	:in  std_logic_vector(15 downto 0):= (others => '0');
			TAKT_NUMBER 				:out std_logic_vector(15 downto 0);
			DISCRETE_NUMBER 			:out std_logic_vector(15 downto 0);
			CLK_40MHz_GClk				:out std_logic;
			CLK_40MHz_GLogic			:out std_logic;
			SYNC_CLK_50kHz 			:out std_logic;
			SYNC_CLK_1_25MHz 			:out std_logic;
			CLK_19Hz_internal			:out std_logic
			);
end Grid_Gen;

architecture Behavioral of Grid_Gen is

component pulse_fr_form
    Port ( 
	        FRONT 		: in std_logic:= '0';
           CLK 		: in std_logic:= '0';
           OUT_PULSE : inout std_logic
			 );
end component;


component clk_mux
generic (
				SIMULATION : boolean := false
--				SIMULATION : boolean := true       -- for TIMESIM
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
end component;


signal	TAKT_Counter					: std_logic_vector (15 downto 0):= (others => '0');
signal	DISCRETE_Counter				: std_logic_vector (15 downto 0):= (others => '0');
signal	DISCRETE_Counter_Sim			: std_logic_vector (6 downto 0):= (others => '0'); --Sim
signal	DISCRETE_Number_temp			: std_logic_vector (15 downto 0):= (others => '0'); --(6 downto 0) SIM
signal	TAKT_Number_UPLOAD			: std_logic_vector (15 downto 0):= (others => '0');
signal	TAKT_Number_UPLOAD_Sim		: std_logic_vector (6 downto 0):= (others => '0');
signal	CLK_40MHz_Counter				: std_logic_vector (4 downto 0):= (others => '0');
signal	TAKT_NUMBER_UPDATE_Shift_L	: std_logic_vector (4 downto 0):= (others => '0');
signal	TAKT_NUMBER_UPDATE_L			: std_logic:= '0'; 
signal	TAKT_NUMBER_UPDATE_Pulse	: std_logic:= '0'; 
signal	TAKT_NUMBER_Load_EN			: std_logic:= '0'; 								
signal	DISCRETE_Counter_EN			: std_logic:= '0'; 														--1.25MHz
signal	DISCRETE_Counter_EN_Shift_REG			: std_logic_vector(31 downto 0):= (others => '0'); --1.25MHz
signal	CLK_40MHz_Global_Clk			: std_logic:= '0'; 								
signal	CLK_40MHz_Global_Logic		: std_logic:= '0'; 								
signal	CLK_19Hz_Pulse					: std_logic:= '0'; 								
signal	CLK_19Hz							: std_logic:= '0'; 								
signal	SYNC_CLK_50kHz_Counter		: std_logic_vector(5 downto 0):=(others => '0');
signal	SYNC_CLK_50kHz_Counter_EN	: std_logic:= '0'; 								
signal	SYNC_CLK_50kHz_EN				: std_logic:= '0'; 								
signal	SYNC_CLK_50kHz_temp			: std_logic:= '0'; 								

begin

CLK_40MHz_GClk		<= CLK_40MHz_Global_Clk;
CLK_40MHz_GLogic	<= CLK_40MHz_Global_Logic;
CLK_19Hz_internal <= CLK_19Hz;

CLK_MUX_inst: clk_mux
generic map(
				SIMULATION => SIMULATION
			)
Port map(
				Bus2IP_Clk 					=> Bus2IP_Clk, 				
				Bus2IP_Reset 				=> Bus2IP_Reset, 				
				CLK_EXT_19Hz 				=> CLK_EXT_19Hz, 			
				CLK_EXT0_40MHz 			=> CLK_EXT0_40MHz, 			
				CLK_EXT1_40MHz 			=> CLK_EXT1_40MHz, 			
				INDEPENDET_WORK_EN 		=> INDEPENDET_WORK_EN, 	
				CLK_EXT0_OR_EXT1 			=> CLK_EXT0_OR_EXT1, 	
				CLK_40MHz_Global_Clk 	=> CLK_40MHz_Global_Clk, 	
				CLK_40MHz_Global_Logic	=> CLK_40MHz_Global_Logic,
				CLK_19Hz 					=> CLK_19Hz 					
);

CLK_19Hz_Pulse_inst: pulse_fr_form
port map(FRONT 		=> CLK_19Hz,
			CLK 			=> CLK_40MHz_Global_Clk,		
			OUT_PULSE	=>	CLK_19Hz_Pulse
			);


TAKT_NUMBER_UPDATE_proc: Process (Bus2IP_Clk)
					begin
							if (Bus2IP_Clk'event and Bus2IP_Clk = '1') then
								TAKT_NUMBER_UPDATE_Shift_L <= TAKT_NUMBER_UPDATE_Shift_L (3 downto 0) & TAKT_NUMBER_UPDATE;
								TAKT_NUMBER_UPDATE_L <= TAKT_NUMBER_UPDATE_Shift_L(0) or TAKT_NUMBER_UPDATE_Shift_L(1) or TAKT_NUMBER_UPDATE_Shift_L(2) or TAKT_NUMBER_UPDATE_Shift_L(3) or TAKT_NUMBER_UPDATE_Shift_L(4);
							end if;
					end process;	


TAKT_NUMBER_UPDATE_Pulse_inst: pulse_fr_form
port map(FRONT 		=> TAKT_NUMBER_UPDATE_L,
			CLK 			=> CLK_40MHz_Global_Clk,		
			OUT_PULSE	=>	TAKT_NUMBER_UPDATE_Pulse
			);
			
--*********************************************************************************************
--**												NO SIMULATION														**
--*********************************************************************************************

GEN_SIMULATION_NONE_1: if (not SIMULATION) generate

					DISCRETE_Number_temp <= DISCRETE_Counter+DISCRETE_NUMBER_SHIFT(15 downto 0);
					DISCRETE_NUMBER(15 downto 0) <= DISCRETE_Number_temp; 
					TAKT_Number_UPLOAD <= x"FFFF" - DISCRETE_NUMBER_SHIFT;
					
				DISCRETE_Counter_process: Process (CLK_40MHz_Global_Clk, CLK_19Hz_Pulse, DISCRETE_Counter_EN)
									begin
											if (CLK_19Hz_Pulse = '1') then 
													DISCRETE_Counter <= (others => '0');
											elsif (CLK_40MHz_Global_Clk'event and CLK_40MHz_Global_Clk = '1') then
												
												--elsif (DISCRETE_Counter_EN = '1') then
												if (DISCRETE_Counter_EN_Shift_REG(30) = '1') then
													DISCRETE_Counter <= DISCRETE_Counter + '1';
												end if;
											end if;
									end process;	


					TAKT_Number_process: Process (CLK_40MHz_Global_Clk,DISCRETE_Counter,TAKT_NUMBER_Load_EN,TAKT_Counter)
										begin
												if (CLK_40MHz_Global_Clk'event and CLK_40MHz_Global_Clk = '1') then
													if (DISCRETE_Counter = TAKT_Number_UPLOAD(15 downto 0)) then 
														TAKT_NUMBER_Load_EN <= '1';
													else
														TAKT_NUMBER_Load_EN <= '0';
													end if;
													
--													if (TAKT_NUMBER_Load_EN = '1') then 
													if (TAKT_NUMBER_Load_EN = '1' and DISCRETE_Counter_EN_Shift_REG(30) = '1') then 
														TAKT_Number <= TAKT_Counter+1;
													end if;
													
												end if;
										end process;
end generate GEN_SIMULATION_NONE_1;

--*********************************************************************************************
--**												SIMULATION															**
--*********************************************************************************************
-- ¬ режиме симул€ции в одном такте 19√ц содержитс€ 128 дискретов, каждый по 32 такта 40ћ√ц  
-- соответственно размер счетчика дискретов (DISCRETE_Counter_Sim) 7 бит 

GEN_SIMULATION_1: if (SIMULATION) generate

					DISCRETE_Number_temp(6 downto 0) <= DISCRETE_Counter_Sim+DISCRETE_NUMBER_SHIFT(6 downto 0);
					DISCRETE_NUMBER(15 downto 7) <= (others => '0'); 					--Sim
					DISCRETE_NUMBER(6 downto 0) <= DISCRETE_Number_temp(6 downto 0); 
					TAKT_Number_UPLOAD_Sim <= ("1111111" - DISCRETE_NUMBER_SHIFT(6 downto 0)); 			--Sim

				DISCRETE_Counter_sim_process: Process (CLK_40MHz_Global_Clk, CLK_19Hz_Pulse, DISCRETE_Counter_EN)
									begin
											if (CLK_19Hz_Pulse = '1') then 
												DISCRETE_Counter_Sim <= (others => '0');
											elsif (CLK_40MHz_Global_Clk'event and CLK_40MHz_Global_Clk = '1') then
												
	   											   if (DISCRETE_Counter_EN_Shift_REG(30) = '1') then
													     DISCRETE_Counter_Sim <= DISCRETE_Counter_Sim + '1';
												   end if;
											end if;
									end process;


							TAKT_Number_process: Process (CLK_40MHz_Global_Clk,DISCRETE_Counter_Sim,TAKT_NUMBER_Load_EN,TAKT_Counter)
												begin
														if (CLK_40MHz_Global_Clk'event and CLK_40MHz_Global_Clk = '1') then
															if (DISCRETE_Counter_Sim = TAKT_Number_UPLOAD_Sim) then
																TAKT_NUMBER_Load_EN <= '1';
															else
																TAKT_NUMBER_Load_EN <= '0';
															end if;
															
--															if (TAKT_NUMBER_Load_EN = '1') then 
															if (TAKT_NUMBER_Load_EN = '1' and DISCRETE_Counter_EN_Shift_REG(30) = '1') then 
																TAKT_Number <= TAKT_Counter+1;
															end if;
															
														end if;
												end process;
end generate GEN_SIMULATION_1;
--**********************************************************************************************

CLK_40MHz_Counter_process: Process (CLK_40MHz_Global_Clk, CLK_19Hz_Pulse)
					begin
							if (CLK_40MHz_Global_Clk'event and CLK_40MHz_Global_Clk = '1') then
								if (CLK_19Hz_Pulse = '1') then
									CLK_40MHz_Counter <= (others => '0');
								else
									CLK_40MHz_Counter <= CLK_40MHz_Counter + '1';
								end if;
							end if;
					end process;


DISCRETE_Counter_EN_process: Process (CLK_40MHz_Global_Clk, CLK_19Hz_Pulse, CLK_40MHz_Counter)
					begin
							if (CLK_40MHz_Global_Clk'event and CLK_40MHz_Global_Clk = '1') then
								DISCRETE_Counter_EN_Shift_REG<= DISCRETE_Counter_EN_Shift_REG(30 downto 0) & DISCRETE_Counter_EN;
								SYNC_CLK_1_25MHz<= DISCRETE_Counter_EN_Shift_REG(30);
								
								if (CLK_40MHz_Counter = "11110") then
									DISCRETE_Counter_EN <= '1';
								else
									DISCRETE_Counter_EN <= '0';
								end if;
							end if;
					end process;


TAKT_Counter_process: Process (CLK_40MHz_Global_Clk, CLK_19Hz_Pulse, TAKT_NUMBER_UPDATE)
					begin
							if (CLK_40MHz_Global_Clk'event and CLK_40MHz_Global_Clk = '1') then
								if (TAKT_NUMBER_UPDATE_Pulse = '1') then
									TAKT_Counter <= Bus2IP_TAKT_NUMBER;
								elsif (CLK_19Hz_Pulse = '1') then 
									TAKT_Counter <= TAKT_Counter + '1';
								end if;
							end if;
					end process;


FORM_SYNC_CLK_50kHz_process: Process (CLK_40MHz_Global_Clk,CLK_19Hz_Pulse,DISCRETE_Counter_EN,DISCRETE_Counter_EN_Shift_REG,SYNC_CLK_50kHz_Counter,SYNC_CLK_50kHz_EN,SHIFT_SYNC_CLK_50kHz)
					begin
							if (CLK_40MHz_Global_Clk'event and CLK_40MHz_Global_Clk = '1') then
								if (SYNC_CLK_50kHz_Counter = "11001") then
									SYNC_CLK_50kHz_Counter <= (others => '0');
								else
									if (DISCRETE_Counter_EN = '1') then
										SYNC_CLK_50kHz_Counter <= SYNC_CLK_50kHz_Counter + '1';
									end if;
								end if;

								case SHIFT_SYNC_CLK_50kHz is
									when "000" => SYNC_CLK_50kHz_EN  <= DISCRETE_Counter_EN_Shift_REG(20);
									when "001" => SYNC_CLK_50kHz_EN  <= DISCRETE_Counter_EN_Shift_REG(21);
									when "010" => SYNC_CLK_50kHz_EN  <= DISCRETE_Counter_EN_Shift_REG(22);
									when "011" => SYNC_CLK_50kHz_EN  <= DISCRETE_Counter_EN_Shift_REG(23);
									when "100" => SYNC_CLK_50kHz_EN  <= DISCRETE_Counter_EN_Shift_REG(24);
									when "101" => SYNC_CLK_50kHz_EN  <= DISCRETE_Counter_EN_Shift_REG(25);
									when "110" => SYNC_CLK_50kHz_EN  <= DISCRETE_Counter_EN_Shift_REG(26);
									when "111" => SYNC_CLK_50kHz_EN  <= DISCRETE_Counter_EN_Shift_REG(27);
									when others => null;
								end case;
								
								if SYNC_CLK_50kHz_Counter = "10111" then
									if (SYNC_CLK_50kHz_EN = '1') then
										SYNC_CLK_50kHz_temp <= '1';
									else 
										SYNC_CLK_50kHz_temp <= '0';
									end if;
								end if;
							
							SYNC_CLK_50kHz<=SYNC_CLK_50kHz_temp;

							end if;
					end process;

end Behavioral;

