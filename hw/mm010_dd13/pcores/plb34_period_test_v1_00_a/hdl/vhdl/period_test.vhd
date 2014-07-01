library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity period_test is
    Port ( 
			-- Параметры длительности импульса
			  Pulse_Lenght_UP_LIMIT   		: std_logic_vector(11 downto 0); 
			  Pulse_Lenght_DOWN_LIMIT 		: std_logic_vector(11 downto 0);
			  Pulse_Lenght_RESET_FRAME 	: std_logic_vector(11 downto 0);
			-- Параметры периода
			  Period_Lenght_UP_LIMIT   	: std_logic_vector(31 downto 0); 
			  Period_Lenght_DOWN_LIMIT 	: std_logic_vector(31 downto 0);
			  Period_Lenght_RESET_FRAME  	: std_logic_vector(31 downto 0);
			-- Статус счетчиков для анализа
			  Pulse_Status 	: out std_logic_vector(11 downto 0); 	
			  Period_Status 	: out std_logic_vector(31 downto 0); 	
			-- Внешние выходы
			  IN_CLK  			:  in std_logic;  -- Входнаq частота 
           REF_CLK 			: in std_logic;   -- Опорнаq частота
           CLK_GOOD 			: out std_logic 	-- Состояние частоты ('1'- в норме)         
          );
end period_test;

architecture struct of period_test is

----------------------------------------------------------------------------------------------------------
   -- сигналы для длительности импульса
   signal   GSR						: std_logic := '0'; 
   signal   Pulse_IN_CLK 			: std_logic := '0'; 
	signal   Pulse_FRAME 			: std_logic_vector (11 downto 0) := (others => '0') ;
	signal   Pulse_RESET_FRAME 	: std_logic := '0';	 
   signal   Pulse_COUNTER_REG 	: std_logic_vector(11 downto 0):= (others => '0') ; 
   signal   IN_CLK_r 				: std_logic := '0';
   signal   IN_CLK_rr 				: std_logic := '0';
   signal   IN_CLK_rrr 				: std_logic := '0';
   signal   not_IN_CLK_r	 		: std_logic := '0';

   -- сигналы для периода
--   signal   Period_IN_CLK 			: std_logic := '0'; 
	signal   Period_FRAME 			: std_logic_vector (31 downto 0) := (others => '0') ;
   signal   Period_RESET_FRAME 	: std_logic := '0';	
   signal   Period_COUNTER_REG 	: std_logic_vector(31 downto 0):= (others => '0') ; 
	signal   Period_Good				: std_logic := '0';	 	

begin
-------------------------------------------------------------------------------------------------------
-------------------------------- Проверка длительности импульса ---------------------------------------
-------------------------------------------------------------------------------------------------------
Pulse_Status<= Pulse_COUNTER_REG;

process(REF_CLK, GSR)
	begin
      if GSR = '1' then
         IN_CLK_r 		<= '0';
         IN_CLK_rr 		<= '0';
         IN_CLK_rrr 		<= '0';
         not_IN_CLK_r 	<= '0';
         Pulse_IN_CLK 	<= '0';
		elsif (REF_CLK'event and REF_CLK ='1') then
			IN_CLK_r <= IN_CLK;
			IN_CLK_rr <= IN_CLK_r;
			IN_CLK_rrr <= IN_CLK_rr;
			not_IN_CLK_r <= not IN_CLK_r;
			Pulse_IN_CLK <= not_IN_CLK_r and IN_CLK_rrr;
		end if;
end process;

--Счётчик количества импульсов за период
process(REF_CLK, Period_GOOD, GSR)
	begin
      if GSR = '1' then
         Pulse_FRAME <= (others => '0');
		elsif (REF_CLK'event and REF_CLK ='1') then
		   if (IN_CLK_rrr = '0') or Pulse_RESET_FRAME = '1' then
            Pulse_FRAME <= (others => '0');
			else
            Pulse_FRAME <= Pulse_FRAME + 1;
			end if;
		end if;
end process;

--Защёлкивание значения счётчика импульсов в регистр 
process(REF_CLK, GSR)
	begin
      if GSR = '1' then
				Pulse_COUNTER_REG <= (others => '0');
		elsif (REF_CLK'event and REF_CLK ='1') then
		   if Pulse_IN_CLK = '1' then
				Pulse_COUNTER_REG <= Pulse_FRAME;
			elsif Pulse_RESET_FRAME = '1' then	 		
				Pulse_COUNTER_REG <= (others => '0');
			end if;
		end if;
end process;

--RESET по таймауту,если частота пропала
process(REF_CLK, GSR)
	begin
      if GSR = '1' then
            Pulse_RESET_FRAME <= '0';
		elsif (REF_CLK'event and REF_CLK ='1') then
		   if Pulse_FRAME = Pulse_Lenght_RESET_FRAME or Period_GOOD = '0' then
            Pulse_RESET_FRAME <= '1';
			else
			   Pulse_RESET_FRAME <= '0';			
			end if;
		end if;
end process;


--Проверка попадания частоты в требуемые рамки точности
process(REF_CLK, GSR)
	begin
      if GSR = '1' then
            CLK_Good <= '0';
		elsif (REF_CLK'event and REF_CLK ='1') then
		   if (Pulse_COUNTER_REG <= Pulse_Lenght_UP_LIMIT) and (Pulse_COUNTER_REG >= Pulse_Lenght_DOWN_LIMIT) then
            CLK_Good <= '1';
			else
			   CLK_Good <= '0';			
			end if;
		end if;
end process;
-------------------------------------------------------------------------------------------------------
---------------------------------------- Проверка периода частоты -------------------------------------
-------------------------------------------------------------------------------------------------------
Period_Status <= Period_COUNTER_REG;

--Счётчик количества импульсов за период
process(REF_CLK, GSR)
	begin
      if GSR = '1' then
         Period_FRAME <= (others => '0');
		elsif (REF_CLK'event and REF_CLK ='1') then
--		   if (Period_IN_CLK = '1') or Period_RESET_FRAME = '1' then
		   if (Pulse_IN_CLK = '1') or Period_RESET_FRAME = '1' then
            Period_FRAME <= (others => '0');
			else
            Period_FRAME <= Period_FRAME + 1;
			end if;
		end if;
end process;

--Защёлкивание значения счётчика импульсов в регистр 
process(REF_CLK, GSR)
	begin
      if GSR = '1' then
				Period_COUNTER_REG <= (others => '0');
		elsif (REF_CLK'event and REF_CLK ='1') then
--		   if Period_IN_CLK = '1' then
		   if Pulse_IN_CLK = '1' then
				Period_COUNTER_REG <= Period_FRAME;
			elsif Period_RESET_FRAME = '1' then	 		
				Period_COUNTER_REG <= (others => '0');
			end if;
		end if;
end process;


--RESET по таймауту,если частота пропала
process(REF_CLK, GSR)
	begin
      if GSR = '1' then
            Period_RESET_FRAME <= '0';
		elsif (REF_CLK'event and REF_CLK ='1') then
		   if Period_FRAME = Period_Lenght_RESET_FRAME(31 downto 0) then
            Period_RESET_FRAME <= '1';
			else
			   Period_RESET_FRAME <= '0';			
			end if;
		end if;
end process;


--Проверка попадания частоты в требуемые рамки точности
process(REF_CLK, GSR)
	begin
      if GSR = '1' then
            Period_GOOD <= '0';
		elsif (REF_CLK'event and REF_CLK ='1') then
			if (Period_COUNTER_REG <= Period_Lenght_UP_LIMIT(31 downto 0)) and (Period_COUNTER_REG >= Period_Lenght_DOWN_LIMIT(31 downto 0)) then
            Period_GOOD <= '1';
			else
			   Period_GOOD <= '0';			
			end if;
		end if;
end process;

------------------------------------------------------------------------
-- ROC
roc_inst: ROC port map (O => GSR);

end struct;
