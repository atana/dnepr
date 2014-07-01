library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity freq_test is
	PORT(
--PARAMETRS
        UP_LIMIT   : std_logic_vector(31 downto 0);
        DOWN_LIMIT : std_logic_vector(31 downto 0);
		  START_FRAME: std_logic_vector(31 downto 0);
		  END_FRAME  : std_logic_vector(31 downto 0);
		  RESET_FRAME_CLK: std_logic_vector(31 downto 0);
-----------		  
			  IN_CLK  :  in std_logic;   -- Входнаq частота 
           REF_CLK : in std_logic;   -- Опорнаq частота
			  CLK_ERROR_COUNTER : out std_logic_vector(31 downto 0); --Кол-во пропаданий/изменений входной частоты
           CLK_GOOD : inout std_logic; -- Состояние частоты ('1'- в норме)
			  DCM_RST : inout std_logic -- импульс сброса DCM длительностью 200ms	           
          );
end freq_test;

architecture struct of freq_test is


----------------------------------------------------------------------------------------------------------
-- Signal declaration
       --
   signal   GSR : std_logic; 
	signal   FRAME_FOR_CLK_COUNTER : std_logic_vector (31 downto 0);
	signal   CLK_COUNTER : std_logic_vector (31 downto 0);
	 
	signal   RESET_CNT_CLK : std_logic;
   signal   RESET_CNT_CLK_L : std_logic;	 
   signal   BGN_FRAME_CLK_L : std_logic;

   signal   END_FRAME_CLK_L : std_logic;
   signal   END_FRAME_CLK : std_logic;
   signal   END_FRAME_CLK_R : std_logic;
   signal   END_FRAME_CLK_RR : std_logic;
   signal   FRAME_FOR_CLK : std_logic;
	signal   iDCM_RST : std_logic;
	signal   iCLK_GOOD : std_logic;
	signal   CLK_NO_GOOD : std_logic;
   signal   CLK_NO_GOOD_L : std_logic;
   signal   CLK_COUNTER_REG : std_logic_vector(31 downto 0); 
   signal   CLK_NO_GOOD_COUNTER : std_logic_vector(31 downto 0); 
	signal   END_OF_STARTUP_PERIOD : std_logic;
   signal   ENABLE_STARTUP_RST : std_logic;
	
--   signal   STARTUP_TIME_COUNTER : std_logic_vector(3 downto 0);
signal   STARTUP_TIME_COUNTER : std_logic_vector(24 downto 0);

begin
----------------------------------------------------------------------------------------------------------

process (REF_CLK, GSR) 
begin    
    if GSR = '1' then
	     ENABLE_STARTUP_RST <= '1';
		  STARTUP_TIME_COUNTER <= (others => '0');	     
    elsif (REF_CLK'event and REF_CLK = '1') then
		     if CLK_NO_GOOD = '1' then
               ENABLE_STARTUP_RST <= '1';
		     elsif END_OF_STARTUP_PERIOD = '1' then
               ENABLE_STARTUP_RST <= '0';
		     end if;
			  if ENABLE_STARTUP_RST = '0' then
               STARTUP_TIME_COUNTER <= (others => '0');
           else
               STARTUP_TIME_COUNTER <= STARTUP_TIME_COUNTER + 1;
		     end if;		        
    end if;
end process;

--END_OF_STARTUP_PERIOD <= '1' when STARTUP_TIME_COUNTER = x"C" else '0';
END_OF_STARTUP_PERIOD <= '1' when STARTUP_TIME_COUNTER = x"1_31_2E_00" else '0';  -- длительность импульса сброса DCM (около 200мс)

DCM_RST<= iDCM_RST;
iDCM_RST <= ENABLE_STARTUP_RST;

----------------------------------------------------------------------------------------------------------
--Проверка частоты
process(REF_CLK, GSR)
	begin
      if GSR = '1' then
         FRAME_FOR_CLK_COUNTER <= x"00000000";
		elsif (REF_CLK'event and REF_CLK ='1') then
		   if RESET_CNT_CLK = '1' then
            FRAME_FOR_CLK_COUNTER <= x"00000000";
			else
            FRAME_FOR_CLK_COUNTER <= FRAME_FOR_CLK_COUNTER + 1;
			end if;
		end if;
end process;

BGN_FRAME_CLK_L <= '1' when FRAME_FOR_CLK_COUNTER = START_FRAME else '0';
END_FRAME_CLK_L <= '1' when FRAME_FOR_CLK_COUNTER = END_FRAME else '0';
RESET_CNT_CLK_L <= '1' when FRAME_FOR_CLK_COUNTER = RESET_FRAME_CLK else '0';

process(REF_CLK, GSR)
	begin
      if GSR = '1' then
         FRAME_FOR_CLK <= '0';
         END_FRAME_CLK <= '0';
         END_FRAME_CLK_R <= '0';
         END_FRAME_CLK_RR <= '0';
			RESET_CNT_CLK <= '0';
			CLK_COUNTER_REG <= x"00000000";

		elsif (REF_CLK'event and REF_CLK ='1') then
         END_FRAME_CLK <= END_FRAME_CLK_L;
         END_FRAME_CLK_R <= END_FRAME_CLK;
         END_FRAME_CLK_RR <= END_FRAME_CLK_R;

         RESET_CNT_CLK <= RESET_CNT_CLK_L;

		   if END_FRAME_CLK_L = '1' then
            FRAME_FOR_CLK <= '0';
			elsif BGN_FRAME_CLK_L = '1' then
            FRAME_FOR_CLK <= '1';
			end if;
		   if END_FRAME_CLK_R = '1' then
			   CLK_COUNTER_REG <= CLK_COUNTER;
         end if;
		end if;
end process;

------------------------------------------------
process (IN_CLK, GSR, END_FRAME_CLK_RR) 
begin    
    if GSR = '1' or END_FRAME_CLK_RR = '1' then
	     CLK_COUNTER <= x"00000000";
    elsif (IN_CLK'event and IN_CLK = '1') then
		  if FRAME_FOR_CLK = '1' then
		     CLK_COUNTER <= CLK_COUNTER + 1;
        end if;
    end if;
end process;

CLK_GOOD<= iCLK_GOOD;
iCLK_GOOD <= '1' when CLK_COUNTER_REG <= UP_LIMIT and 
                     CLK_COUNTER_REG >= DOWN_LIMIT else '0';

CLK_NO_GOOD_L <= '1' when END_FRAME_CLK_RR = '1' and iCLK_GOOD = '0' else '0';

process (REF_CLK, GSR) 
begin    
    if GSR = '1' then
	     CLK_NO_GOOD <= '0';
    elsif (REF_CLK'event and REF_CLK = '1') then
	     CLK_NO_GOOD <= CLK_NO_GOOD_L;
    end if;
end process;

process (REF_CLK, GSR) 
begin    
    if GSR = '1' then
		  CLK_NO_GOOD_COUNTER <= (others => '0');
    elsif (REF_CLK'event and REF_CLK = '1') then
		  if CLK_NO_GOOD = '1' then 
		     CLK_NO_GOOD_COUNTER <= CLK_NO_GOOD_COUNTER + 1;
		  end if;
    end if;
end process;
CLK_ERROR_COUNTER <= CLK_NO_GOOD_COUNTER; 

-- ROC
roc_inst: ROC port map (O => GSR);

end struct;
