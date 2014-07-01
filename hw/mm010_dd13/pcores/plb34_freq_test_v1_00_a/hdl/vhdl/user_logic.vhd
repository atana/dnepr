------------------------------------------------------------------------------
-- user_logic.vhd - entity/architecture pair
------------------------------------------------------------------------------
--
-- ***************************************************************************
-- ** Copyright (c) 1995-2008 Xilinx, Inc.  All rights reserved.            **
-- **                                                                       **
-- ** Xilinx, Inc.                                                          **
-- ** XILINX IS PROVIDING THIS DESIGN, CODE, OR INFORMATION "AS IS"         **
-- ** AS A COURTESY TO YOU, SOLELY FOR USE IN DEVELOPING PROGRAMS AND       **
-- ** SOLUTIONS FOR XILINX DEVICES.  BY PROVIDING THIS DESIGN, CODE,        **
-- ** OR INFORMATION AS ONE POSSIBLE IMPLEMENTATION OF THIS FEATURE,        **
-- ** APPLICATION OR STANDARD, XILINX IS MAKING NO REPRESENTATION           **
-- ** THAT THIS IMPLEMENTATION IS FREE FROM ANY CLAIMS OF INFRINGEMENT,     **
-- ** AND YOU ARE RESPONSIBLE FOR OBTAINING ANY RIGHTS YOU MAY REQUIRE      **
-- ** FOR YOUR IMPLEMENTATION.  XILINX EXPRESSLY DISCLAIMS ANY              **
-- ** WARRANTY WHATSOEVER WITH RESPECT TO THE ADEQUACY OF THE               **
-- ** IMPLEMENTATION, INCLUDING BUT NOT LIMITED TO ANY WARRANTIES OR        **
-- ** REPRESENTATIONS THAT THIS IMPLEMENTATION IS FREE FROM CLAIMS OF       **
-- ** INFRINGEMENT, IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS       **
-- ** FOR A PARTICULAR PURPOSE.                                             **
-- **                                                                       **
-- ***************************************************************************
--
------------------------------------------------------------------------------
-- Filename:          user_logic.vhd
-- Version:           1.00.a
-- Description:       User logic.
-- Date:              Sat Mar 06 13:02:01 2010 (by Create and Import Peripheral Wizard)
-- VHDL Standard:     VHDL'93
------------------------------------------------------------------------------
-- Naming Conventions:
--   active low signals:                    "*_n"
--   clock signals:                         "clk", "clk_div#", "clk_#x"
--   reset signals:                         "rst", "rst_n"
--   generics:                              "C_*"
--   user defined types:                    "*_TYPE"
--   state machine next state:              "*_ns"
--   state machine current state:           "*_cs"
--   combinatorial signals:                 "*_com"
--   pipelined or register delay signals:   "*_d#"
--   counter signals:                       "*cnt*"
--   clock enable signals:                  "*_ce"
--   internal version of output port:       "*_i"
--   device pins:                           "*_pin"
--   ports:                                 "- Names begin with Uppercase"
--   processes:                             "*_PROCESS"
--   component instantiations:              "<ENTITY_>I_<#|FUNC>"
------------------------------------------------------------------------------

-- DO NOT EDIT BELOW THIS LINE --------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library proc_common_v2_00_a;
use proc_common_v2_00_a.proc_common_pkg.all;
-- DO NOT EDIT ABOVE THIS LINE --------------------

--USER libraries added here

------------------------------------------------------------------------------
-- Entity section
------------------------------------------------------------------------------
-- Definition of Generics:
--   C_DWIDTH                     -- User logic data bus width
--   C_NUM_CE                     -- User logic chip enable bus width
--
-- Definition of Ports:
--   Bus2IP_Clk                   -- Bus to IP clock
--   Bus2IP_Reset                 -- Bus to IP reset
--   Bus2IP_Data                  -- Bus to IP data bus for user logic
--   Bus2IP_BE                    -- Bus to IP byte enables for user logic
--   Bus2IP_RdCE                  -- Bus to IP read chip enable for user logic
--   Bus2IP_WrCE                  -- Bus to IP write chip enable for user logic
--   Bus2IP_RdReq                 -- Bus to IP read request
--   Bus2IP_WrReq                 -- Bus to IP write request
--   IP2Bus_Data                  -- IP to Bus data bus for user logic
--   IP2Bus_Retry                 -- IP to Bus retry response
--   IP2Bus_Error                 -- IP to Bus error response
--   IP2Bus_ToutSup               -- IP to Bus timeout suppress
--   IP2Bus_Busy                  -- IP to Bus busy response
--   IP2Bus_RdAck                 -- IP to Bus read transfer acknowledgement
--   IP2Bus_WrAck                 -- IP to Bus write transfer acknowledgement
------------------------------------------------------------------------------

entity user_logic is
  generic
  (
    -- ADD USER GENERICS BELOW THIS LINE ---------------
			  UP_LIMIT   		: std_logic_vector(31 downto 0);
			  DOWN_LIMIT 		: std_logic_vector(31 downto 0);
			  START_FRAME		: std_logic_vector(31 downto 0);
			  END_FRAME  		: std_logic_vector(31 downto 0);
			  RESET_FRAME_CLK	: std_logic_vector(31 downto 0);
			  C_AUTOSET 		: integer := 08;
    -- ADD USER GENERICS ABOVE THIS LINE ---------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
    C_DWIDTH                       : integer              := 32;
    C_NUM_CE                       : integer              := 5
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------
	 
			  IN_CLK  				: in std_logic;   		-- Входнаq частота 
			  REF_CLK 				: in std_logic;   		-- Опорнаq частота
			  CLK_ERROR_COUNTER 	: out std_logic_vector(31 downto 0); --Кол-во пропаданий/изменений входной частоты
			  CLK_GOOD 				: out std_logic; 			-- Состояние частоты ('1'- в норме)
			  DCM_RST 				: out std_logic; 			-- импульс сброса DCM длительностью 200ms	
    -- ADD USER PORTS ABOVE THIS LINE ------------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol ports, do not add to or delete
    Bus2IP_Clk                     : in  std_logic;
    Bus2IP_Reset                   : in  std_logic;
    Bus2IP_Data                    : in  std_logic_vector(0 to C_DWIDTH-1);
    Bus2IP_BE                      : in  std_logic_vector(0 to C_DWIDTH/8-1);
    Bus2IP_RdCE                    : in  std_logic_vector(0 to C_NUM_CE-1);
    Bus2IP_WrCE                    : in  std_logic_vector(0 to C_NUM_CE-1);
    Bus2IP_RdReq                   : in  std_logic;
    Bus2IP_WrReq                   : in  std_logic;
    IP2Bus_Data                    : out std_logic_vector(0 to C_DWIDTH-1);
    IP2Bus_Retry                   : out std_logic;
    IP2Bus_Error                   : out std_logic;
    IP2Bus_ToutSup                 : out std_logic;
    IP2Bus_Busy                    : out std_logic;
    IP2Bus_RdAck                   : out std_logic;
    IP2Bus_WrAck                   : out std_logic
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );

  attribute SIGIS : string;
  attribute SIGIS of Bus2IP_Clk    : signal is "CLK";
  attribute SIGIS of Bus2IP_Reset  : signal is "RST";

end entity user_logic;

------------------------------------------------------------------------------
-- Architecture section
------------------------------------------------------------------------------

architecture IMP of user_logic is

-- Функция возвращает один из параметров в зависимости от значения frequency_code
	subtype reg32 is std_logic_vector(31 downto 0);
	function select_parameters (frequency_code : integer; -- Код выбранный из раскрывающегося списка (manual или конкретная частота)
								manual_code 		: std_logic_vector(31 downto 0); -- значение указанное в параметрах компонента
								Constant_Code_1	: std_logic_vector(31 downto 0); -- значение параметра для конкретной частоты
								Constant_Code_2	: std_logic_vector(31 downto 0);
								Constant_Code_3	: std_logic_vector(31 downto 0);
								Constant_Code_4	: std_logic_vector(31 downto 0); 
								Constant_Code_5	: std_logic_vector(31 downto 0); 
								Constant_Code_6	: std_logic_vector(31 downto 0); 
								Constant_Code_7	: std_logic_vector(31 downto 0); 
								Constant_Code_8	: std_logic_vector(31 downto 0)) 
								return reg32 is
	begin
		case frequency_code is
			when 0 => 	return  manual_code;
			when 1 =>	return  Constant_Code_1;
			when 2 => 	return  Constant_Code_2;
			when 3 => 	return  Constant_Code_3;
			when 4 => 	return  Constant_Code_4;				
			when 5 =>	return  Constant_Code_5;
			when 6 =>	return  Constant_Code_6;
			when 7 =>	return  Constant_Code_7;				
			when 8 =>	return  Constant_Code_8;				
			when others => 	return  manual_code;
		end case;
		return manual_code;
	end select_parameters;
---------------------------------------------------------------------------------	
 
 component freq_test
	PORT(
			--PARAMETRS
			  UP_LIMIT   		: std_logic_vector(31 downto 0);
			  DOWN_LIMIT 		: std_logic_vector(31 downto 0);
			  START_FRAME		: std_logic_vector(31 downto 0);
			  END_FRAME  		: std_logic_vector(31 downto 0);
			  RESET_FRAME_CLK	: std_logic_vector(31 downto 0);
				-----------		  
				  IN_CLK  				: in std_logic;   		-- Входнаq частота 
				  REF_CLK 				: in std_logic;   		-- Опорнаq частота
				  CLK_ERROR_COUNTER 	: out std_logic_vector(31 downto 0); --Кол-во пропаданий/изменений входной частоты
				  CLK_GOOD 				: out std_logic; 			-- Состояние частоты ('1'- в норме)
				  DCM_RST 				: out std_logic 			-- импульс сброса DCM длительностью 200ms	           
		);
		end component;
  --USER signal declarations added here, as needed for user logic

  ------------------------------------------
  -- Signals for user logic slave model s/w accessible register example
  ------------------------------------------
	signal REG_UP_LIMIT             : std_logic_vector(0 to C_DWIDTH-1);
	signal REG_DOWN_LIMIT           : std_logic_vector(0 to C_DWIDTH-1);
	signal REG_START_FRAME          : std_logic_vector(0 to C_DWIDTH-1);
	signal REG_END_FRAME            : std_logic_vector(0 to C_DWIDTH-1);
	signal REG_RESET_FRAME_CLK      : std_logic_vector(0 to C_DWIDTH-1);
  
	constant CLK_40MHz_UP_LIMIT 	: std_logic_vector:= x"0271_9c70";
	constant CLK_40MHz_DOWN_LIMIT 	: std_logic_vector:= x"0253_17c0";

	constant CLK_0_76Hz_UP_LIMIT 	: std_logic_vector:= x"0000_0004";
	constant CLK_0_76Hz_DOWN_LIMIT	: std_logic_vector:= x"0000_0003";

	constant CLK_1Hz_UP_LIMIT 		: std_logic_vector:= x"0000_0006";
	constant CLK_1Hz_DOWN_LIMIT 	: std_logic_vector:= x"0000_0004";

	constant CLK_19Hz_UP_LIMIT 		: std_logic_vector:= x"0000_0014";
	constant CLK_19Hz_DOWN_LIMIT 	: std_logic_vector:= x"0000_0012";

	constant CLK_195Hz_UP_LIMIT 	: std_logic_vector:= x"0000_00C4";
	constant CLK_195Hz_DOWN_LIMIT 	: std_logic_vector:= x"0000_00C3";

	constant CLK_1_25MHz_UP_LIMIT 	: std_logic_vector:= x"0014_0714";
	constant CLK_1_25MHz_DOWN_LIMIT : std_logic_vector:= x"0012_1EAC";

	constant CLK_9_6MHz_UP_LIMIT 	: std_logic_vector:= x"0092_8400";
	constant CLK_9_6MHz_DOWN_LIMIT 	: std_logic_vector:= x"0092_7300";

	constant CLK_10MHz_UP_LIMIT 	: std_logic_vector:= x"0098_A000";
	constant CLK_10MHz_DOWN_LIMIT 	: std_logic_vector:= x"0098_8E00";

	constant DEFAULT_START_FRAME 	: std_logic_vector:= x"0000_0020";
	constant ONE_SECOND_FRAME_END 	: std_logic_vector:= x"05F5_E120";
	constant ONE_SECOND_FRAME_RESET	: std_logic_vector:= x"05F5_E170";
	constant FIVE_SECOND_FRAME_END 	 : std_logic_vector:= x"1DCD_6520";
	constant FIVE_SECOND_FRAME_RESET : std_logic_vector:= x"1DCD_6570";
	
--************ Определение значений параметров для детектора ***************
	constant SET_UP_LIMIT                 : std_logic_vector(0 to C_DWIDTH-1):= select_parameters(frequency_code 	=> C_AUTOSET, 
																																manual_code 	=> UP_LIMIT,
																																Constant_Code_1	=> CLK_0_76Hz_UP_LIMIT,
																																Constant_Code_2	=> CLK_1Hz_UP_LIMIT,
																																Constant_Code_3	=> CLK_19Hz_UP_LIMIT,
																																Constant_Code_4	=> CLK_195Hz_UP_LIMIT,   
																																Constant_Code_5	=> CLK_1_25MHz_UP_LIMIT,   
																																Constant_Code_6	=> CLK_9_6MHz_UP_LIMIT,   
																																Constant_Code_7	=> CLK_10MHz_UP_LIMIT,
																																Constant_Code_8	=> CLK_40MHz_UP_LIMIT);   

	constant SET_DOWN_LIMIT               : std_logic_vector(0 to C_DWIDTH-1):= select_parameters(frequency_code 	=> C_AUTOSET, 
																																manual_code 	=> DOWN_LIMIT,
																																Constant_Code_1	=> CLK_0_76Hz_DOWN_LIMIT,
																																Constant_Code_2	=> CLK_1Hz_DOWN_LIMIT,
																																Constant_Code_3	=> CLK_19Hz_DOWN_LIMIT,
																																Constant_Code_4	=> CLK_195Hz_DOWN_LIMIT,
																																Constant_Code_5	=> CLK_1_25MHz_DOWN_LIMIT,
																																Constant_Code_6	=> CLK_9_6MHz_DOWN_LIMIT,
																																Constant_Code_7	=> CLK_10MHz_DOWN_LIMIT,
																																Constant_Code_8	=> CLK_40MHz_DOWN_LIMIT);

	constant SET_START_FRAME              : std_logic_vector(0 to C_DWIDTH-1):= DEFAULT_START_FRAME;


	constant SET_END_FRAME                : std_logic_vector(0 to C_DWIDTH-1):= select_parameters(frequency_code 	=> C_AUTOSET, 
																																manual_code 		=> END_FRAME,
																																Constant_Code_1	=> FIVE_SECOND_FRAME_END,
																																Constant_Code_2	=> FIVE_SECOND_FRAME_END,
																																Constant_Code_3	=> ONE_SECOND_FRAME_END,
																																Constant_Code_4	=> ONE_SECOND_FRAME_END,
																																Constant_Code_5	=> ONE_SECOND_FRAME_END,
																																Constant_Code_6	=> ONE_SECOND_FRAME_END,
																																Constant_Code_7	=> ONE_SECOND_FRAME_END,
																																Constant_Code_8	=> ONE_SECOND_FRAME_END);

	constant SET_RESET_FRAME_CLK          : std_logic_vector(0 to C_DWIDTH-1):= select_parameters(frequency_code 	=> C_AUTOSET, 
																																manual_code 		=> RESET_FRAME_CLK,
																																Constant_Code_1	=> FIVE_SECOND_FRAME_RESET,
																																Constant_Code_2	=> FIVE_SECOND_FRAME_RESET,
																																Constant_Code_3	=> ONE_SECOND_FRAME_RESET,
																																Constant_Code_4	=> ONE_SECOND_FRAME_RESET,
																																Constant_Code_5	=> ONE_SECOND_FRAME_RESET,
																																Constant_Code_6	=> ONE_SECOND_FRAME_RESET,
																																Constant_Code_7	=> ONE_SECOND_FRAME_RESET,
																																Constant_Code_8	=> ONE_SECOND_FRAME_RESET);
  signal slv_reg_write_select           : std_logic_vector(0 to 4);
  signal slv_reg_read_select            : std_logic_vector(0 to 4);
  signal slv_ip2bus_data                : std_logic_vector(0 to C_DWIDTH-1);
  signal slv_read_ack                   : std_logic;
  signal slv_write_ack                  : std_logic;

begin

  --USER logic implementation added here

  ------------------------------------------
  -- Example code to read/write user logic slave model s/w accessible registers
  -- 
  -- Note:
  -- The example code presented here is to show you one way of reading/writing
  -- software accessible registers implemented in the user logic slave model.
  -- Each bit of the Bus2IP_WrCE/Bus2IP_RdCE signals is configured to correspond
  -- to one software accessible register by the top level template. For example,
  -- if you have four 32 bit software accessible registers in the user logic, you
  -- are basically operating on the following memory mapped registers:
  -- 
  --    Bus2IP_WrCE or   Memory Mapped
  --       Bus2IP_RdCE   Register
  --            "1000"   C_BASEADDR + 0x0
  --            "0100"   C_BASEADDR + 0x4
  --            "0010"   C_BASEADDR + 0x8
  --            "0001"   C_BASEADDR + 0xC
  -- 
  ------------------------------------------
  slv_reg_write_select <= Bus2IP_WrCE(0 to 4);
  slv_reg_read_select  <= Bus2IP_RdCE(0 to 4);
  slv_write_ack        <= Bus2IP_WrCE(0) or Bus2IP_WrCE(1) or Bus2IP_WrCE(2) or Bus2IP_WrCE(3) or Bus2IP_WrCE(4);
  slv_read_ack         <= Bus2IP_RdCE(0) or Bus2IP_RdCE(1) or Bus2IP_RdCE(2) or Bus2IP_RdCE(3) or Bus2IP_RdCE(4);

  -- implement slave model register(s)
  SLAVE_REG_WRITE_PROC : process( Bus2IP_Clk ) is
  begin

    if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
      if Bus2IP_Reset = '1' then
        REG_UP_LIMIT 			<= SET_UP_LIMIT; 		
        REG_DOWN_LIMIT 			<= SET_DOWN_LIMIT;      	
        REG_START_FRAME 		<= SET_START_FRAME;       
        REG_END_FRAME 			<= SET_END_FRAME;         
        REG_RESET_FRAME_CLK 	<= SET_RESET_FRAME_CLK;   
      else
        case slv_reg_write_select is
          when "10000" =>
            for byte_index in 0 to (C_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                REG_UP_LIMIT(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "01000" =>
            for byte_index in 0 to (C_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                REG_DOWN_LIMIT(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00100" =>
            for byte_index in 0 to (C_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                REG_START_FRAME(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00010" =>
            for byte_index in 0 to (C_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                REG_END_FRAME(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00001" =>
            for byte_index in 0 to (C_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                REG_RESET_FRAME_CLK(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when others => null;
        end case;
      end if;
    end if;

  end process SLAVE_REG_WRITE_PROC;

  -- implement slave model register read mux
  SLAVE_REG_READ_PROC : process( slv_reg_read_select, REG_UP_LIMIT, REG_DOWN_LIMIT, REG_START_FRAME, REG_END_FRAME, REG_RESET_FRAME_CLK ) is
  begin

    case slv_reg_read_select is
      when "10000" => slv_ip2bus_data <= REG_UP_LIMIT;       
      when "01000" => slv_ip2bus_data <= REG_DOWN_LIMIT;     
      when "00100" => slv_ip2bus_data <= REG_START_FRAME;    
      when "00010" => slv_ip2bus_data <= REG_END_FRAME;      
      when "00001" => slv_ip2bus_data <= REG_RESET_FRAME_CLK;
      when others => slv_ip2bus_data <= (others => '0');
    end case;

  end process SLAVE_REG_READ_PROC;

  ------------------------------------------
  -- Example code to drive IP to Bus signals
  ------------------------------------------
  IP2Bus_Data        <= slv_ip2bus_data;

  IP2Bus_WrAck       <= slv_write_ack;
  IP2Bus_RdAck       <= slv_read_ack;
  IP2Bus_Busy        <= '0';
  IP2Bus_Error       <= '0';
  IP2Bus_Retry       <= '0';
  IP2Bus_ToutSup     <= '0';

freq_test_inst: freq_test
	PORT MAP(
			  UP_LIMIT   			=> REG_UP_LIMIT,		
			  DOWN_LIMIT 			=> REG_DOWN_LIMIT,	
			  START_FRAME			=> REG_START_FRAME,
			  END_FRAME  			=> REG_END_FRAME,
			  RESET_FRAME_CLK		=> REG_RESET_FRAME_CLK,
		     -----------		  
			  IN_CLK  				=> IN_CLK,					-- Входнаq частота 
			  REF_CLK 				=>	REF_CLK, 				-- Опорнаq частота
			  CLK_ERROR_COUNTER 	=> CLK_ERROR_COUNTER, 		-- Кол-во пропаданий/изменений входной частоты
			  CLK_GOOD 				=> CLK_GOOD, 				-- Состояние частоты ('1'- в норме)
			  DCM_RST 				=> DCM_RST 					-- импульс сброса DCM длительностью 200ms	           
		);
end IMP;
