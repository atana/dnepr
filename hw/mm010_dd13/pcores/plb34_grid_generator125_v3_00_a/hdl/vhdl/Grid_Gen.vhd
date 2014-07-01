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
			DISCRETE_NUMBER_SHIFT  		:in  std_logic_vector(15 downto 0):= x"0000"; --48;
			SYNC_CLK_50kHz_SHIFT  		:in  std_logic_vector(6 downto 0):= "0000000"; -- плавный сдвиг импульса 50кГц (1 шаг 10нс)
			Bus2IP_Reset					:in  std_logic:= '0';
			Bus2IP_Clk						:in  std_logic:= '0';
			CLK_EXT_19Hz					:in  std_logic:= '0';
			CLK_EXT_1_25MHz				:in  std_logic:= '0';
			TAKT_NUMBER_UPDATE			:in  std_logic:= '0';
			Bus2IP_TAKT_NUMBER 	 		:in  std_logic_vector(15 downto 0):= (others => '0');
			TAKT_NUMBER 					:out std_logic_vector(15 downto 0);
			DISCRETE_NUMBER 				:out std_logic_vector(15 downto 0);
			SYNC_CLK_50kHz 				:out std_logic
			);
end Grid_Gen;

architecture Behavioral of Grid_Gen is

signal	TAKT_Counter						: std_logic_vector (15 downto 0):= (others => '0');
signal	DISCRETE_Counter					: std_logic_vector (15 downto 0):= (others => '0');
signal	DISCRETE_Counter_Sim				: std_logic_vector (6 downto 0):= (others => '0'); --Sim
signal	DISCRETE_Number_temp				: std_logic_vector (15 downto 0):= (others => '0'); --(6 downto 0) SIM
signal	TAKT_Number_UPLOAD				: std_logic_vector (15 downto 0):= (others => '0');
signal	TAKT_Number_UPLOAD_Sim			: std_logic_vector (6 downto 0):= (others => '0');
signal	TAKT_NUMBER_UPDATE_Pulse		: std_logic:= '0'; 
signal	TAKT_NUMBER_Load_EN				: std_logic:= '0'; 								
signal	DISCRETE_Counter_EN				: std_logic:= '0'; 														--1.25MHz
signal	DISCRETE_Counter_EN_Shift_REG	: std_logic_vector(79 downto 0):= (others => '0'); --1.25MHz
signal	SYNC_CLK_50kHz_Counter			: std_logic_vector(5 downto 0):=(others => '0');
signal	SYNC_CLK_50kHz_EN					: std_logic:= '0'; 								
signal	SYNC_CLK_50kHz_temp				: std_logic:= '0'; 								

begin
DISCRETE_Counter_EN <= CLK_EXT_1_25MHz;
			
--*********************************************************************************************
--**												NO SIMULATION														**
--*********************************************************************************************

GEN_SIMULATION_NONE_1: if (not SIMULATION) generate
					-- Вычисление номера дискрета с учетом сдвига
					DISCRETE_Number_temp <= DISCRETE_Counter+DISCRETE_NUMBER_SHIFT(15 downto 0);
					DISCRETE_NUMBER(15 downto 0) <= DISCRETE_Number_temp; 
					TAKT_Number_UPLOAD <= x"FFFF" - DISCRETE_NUMBER_SHIFT;
					-- Счетчик дискретов
					DISCRETE_Counter_process: Process (Bus2IP_Clk, CLK_EXT_19Hz)
									begin
											if (CLK_EXT_19Hz = '1') then 
													DISCRETE_Counter <= (others => '0');
											elsif (Bus2IP_Clk'event and Bus2IP_Clk = '1') then
												
												if (DISCRETE_Counter_EN_Shift_REG(79) = '1') then
													DISCRETE_Counter <= DISCRETE_Counter + '1';
												end if;
											end if;
									end process;	

					-- Присвоение номера тактов
					TAKT_Number_process: Process (Bus2IP_Clk,DISCRETE_Counter,TAKT_NUMBER_Load_EN,DISCRETE_Counter_EN_Shift_REG)
										begin
												if (Bus2IP_Clk'event and Bus2IP_Clk = '1') then
													if (DISCRETE_Counter = TAKT_Number_UPLOAD(15 downto 0)) then 
														TAKT_NUMBER_Load_EN <= '1';
													else
														TAKT_NUMBER_Load_EN <= '0';
													end if;
													
													if (TAKT_NUMBER_Load_EN = '1' and DISCRETE_Counter_EN_Shift_REG(79) = '1') then 
														TAKT_Number <= TAKT_Counter+1;
													end if;
													
												end if;
										end process;
end generate GEN_SIMULATION_NONE_1;

--*********************************************************************************************
--**												SIMULATION															**
--*********************************************************************************************
-- В режиме симуляции в одном такте 19Гц содержится 128 дискретов, каждый по 8 тактов 10МГц  
-- соответственно размер счетчика дискретов (DISCRETE_Counter_Sim) 7 бит 

GEN_SIMULATION_1: if (SIMULATION) generate
					--вычисление номера дискрета с учетом сдвига
					DISCRETE_Number_temp(6 downto 0) <= DISCRETE_Counter_Sim+DISCRETE_NUMBER_SHIFT(6 downto 0);
					DISCRETE_NUMBER(15 downto 7) <= (others => '0'); 					--Sim
					DISCRETE_NUMBER(6 downto 0) <= DISCRETE_Number_temp(6 downto 0); 
					TAKT_Number_UPLOAD_Sim <= ("1111111" - DISCRETE_NUMBER_SHIFT(6 downto 0)); 			--Sim
					--счетчик дискретов
					DISCRETE_Counter_sim_process: Process (Bus2IP_Clk, CLK_EXT_19Hz)
									begin
											if (CLK_EXT_19Hz = '1') then 
												DISCRETE_Counter_Sim <= (others => '0');
											elsif (Bus2IP_Clk'event and Bus2IP_Clk = '1') then
												
	   											   if (DISCRETE_Counter_EN_Shift_REG(79) = '1') then
													     DISCRETE_Counter_Sim <= DISCRETE_Counter_Sim + '1';
												   end if;
											end if;
									end process;
							-- присвоения номера такта
							TAKT_Number_process: Process (Bus2IP_Clk,DISCRETE_Counter_Sim,TAKT_NUMBER_Load_EN,DISCRETE_Counter_EN_Shift_REG)
												begin
														if (Bus2IP_Clk'event and Bus2IP_Clk = '1') then
															if (DISCRETE_Counter_Sim = TAKT_Number_UPLOAD_Sim) then
																TAKT_NUMBER_Load_EN <= '1';
															else
																TAKT_NUMBER_Load_EN <= '0';
															end if;
															
															if (TAKT_NUMBER_Load_EN = '1' and DISCRETE_Counter_EN_Shift_REG(79) = '1') then 
																TAKT_Number <= TAKT_Counter+1;
															end if;
															
														end if;
												end process;
end generate GEN_SIMULATION_1;
--**********************************************************************************************

-- разрешение счетчика дискретов
DISCRETE_Counter_EN_process: Process (Bus2IP_Clk)
					begin
							if (Bus2IP_Clk'event and Bus2IP_Clk = '1') then
								DISCRETE_Counter_EN_Shift_REG<= DISCRETE_Counter_EN_Shift_REG(78 downto 0) & DISCRETE_Counter_EN;
							end if;
					end process;

--формирование сигналов разрешения обновления номера тактов
TAKT_NUMBER_UPDATE_proc: Process (Bus2IP_Clk)
					begin
							if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
									if Bus2IP_Reset = '1' then
										TAKT_NUMBER_UPDATE_Pulse <= '0';
									else
										TAKT_NUMBER_UPDATE_Pulse <= TAKT_NUMBER_UPDATE;
									end if;
							end if;
					end process;	

-- счетчик Тактов
TAKT_Counter_process: Process (Bus2IP_Clk, CLK_EXT_19Hz, TAKT_NUMBER_UPDATE_Pulse)
					begin
							if (Bus2IP_Clk'event and Bus2IP_Clk = '1') then
--								if (TAKT_NUMBER_UPDATE = '1') then
								if (TAKT_NUMBER_UPDATE_Pulse = '1') then
									TAKT_Counter <= Bus2IP_TAKT_NUMBER;
								elsif (CLK_EXT_19Hz = '1') then 
									TAKT_Counter <= TAKT_Counter + '1';
								end if;
							end if;
					end process;

-- формирование импульса 50кГц, в качестве синхроимпульса посылок MIL
FORM_SYNC_CLK_50kHz_process: Process (Bus2IP_Clk)
					begin
							if (Bus2IP_Clk'event and Bus2IP_Clk = '1') then
								if (SYNC_CLK_50kHz_Counter = "11001") then
									SYNC_CLK_50kHz_Counter <= (others => '0');
								else
									if (DISCRETE_Counter_EN = '1') then
										SYNC_CLK_50kHz_Counter <= SYNC_CLK_50kHz_Counter + '1';
									end if;
								end if;
								
								--регулировка задержки выдачи синхроимпульса
								SYNC_CLK_50kHz_EN <= DISCRETE_Counter_EN_Shift_REG(conv_integer(SYNC_CLK_50kHz_SHIFT));
																
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

