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
-- Date:              Thu Mar 11 09:40:20 2010 (by Create and Import Peripheral Wizard)
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
			-- Параметры длительности импульса
        Pulse_UP_LIMIT   	: std_logic_vector(31 downto 0); 
        Pulse_DOWN_LIMIT 	: std_logic_vector(31 downto 0);
		  Pulse_RESET_FRAME 	: std_logic_vector(31 downto 0);
			-- Параметры периода
	     Period_UP_LIMIT   	: std_logic_vector(31 downto 0); 
        Period_DOWN_LIMIT 	: std_logic_vector(31 downto 0);
		  Period_RESET_FRAME  	: std_logic_vector(31 downto 0);  

		  C_AUTOSET			: integer := 03; -- выбор из известных частот
    -- ADD USER GENERICS ABOVE THIS LINE ---------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
    C_DWIDTH                       : integer              := 32;
    C_NUM_CE                       : integer              := 8
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------
    --USER ports added here
			  IN_CLK  				: in std_logic;   		-- Входнаq частота 
			  REF_CLK 				: in std_logic;   		-- Опорнаq частота
			  CLK_GOOD 				: out std_logic; 	
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
								Constant_Code_4	: std_logic_vector(31 downto 0)) 
								return reg32 is
	begin
		case frequency_code is
			when 0 =>
				return  manual_code;
			when 1 => return  Constant_Code_1; 	-- 0.76Hz 
			when 2 => return  Constant_Code_2; 	--    1Hz 
			when 3 => return  Constant_Code_3; 	--   19Hz 
			when 4 => return  Constant_Code_4; 	--  195Hz 				
			when others => return  manual_code;
		end case;
		return manual_code;
	end select_parameters;
---------------------------------------------------------------------------------	
 
 component period_test
	PORT(
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
		  IN_CLK  				: in std_logic;   -- Входнаq частота 
		  REF_CLK 				: in std_logic;   -- Опорнаq частота
		  CLK_GOOD 				: out std_logic 	-- Состояние частоты ('1'- в норме)
		);
	end component;

  ------------------------------------------
  -- Signals for user logic slave model s/w accessible register example
  ------------------------------------------
	signal REG_Pulse_UP_LIMIT       		: std_logic_vector(C_DWIDTH-1 downto 0);
	signal REG_Pulse_DOWN_LIMIT     		: std_logic_vector(C_DWIDTH-1 downto 0);
	signal REG_Pulse_RESET_FRAME    		: std_logic_vector(C_DWIDTH-1 downto 0);
	signal REG_Period_UP_LIMIT       	: std_logic_vector(C_DWIDTH-1 downto 0);
	signal REG_Period_DOWN_LIMIT     	: std_logic_vector(C_DWIDTH-1 downto 0);
	signal REG_Period_RESET_FRAME    	: std_logic_vector(C_DWIDTH-1 downto 0);
	-- Статус счетчиков для анализа
   signal Pulse_Status 						: std_logic_vector(C_DWIDTH-1 downto 0); 	
   signal Period_Status 					: std_logic_vector(C_DWIDTH-1 downto 0); 	
		
	constant Pulse_390_410ns_UP_LIMIT 			: std_logic_vector:= x"0000_0030";
	constant Pulse_390_410ns_DOWN_LIMIT 		: std_logic_vector:= x"0000_0026";
	constant Pulse_390_410ns_RESET_FRAME 		: std_logic_vector:= x"0000_0031";

	constant Pulse_180_300ns_UP_LIMIT 			: std_logic_vector:= x"0000_001F";
	constant Pulse_180_300ns_DOWN_LIMIT 		: std_logic_vector:= x"0000_0011";
	constant Pulse_180_300ns_RESET_FRAME 		: std_logic_vector:= x"0000_0020";
	
	constant Period_0_76Hz_UP_LIMIT 		: std_logic_vector:= x"0839_4355";
	constant Period_0_76Hz_DOWN_LIMIT	: std_logic_vector:= x"0770_C304";
	constant Period_0_76Hz_RESET_FRAME	: std_logic_vector:= x"0839_5000";
                                   
	constant Period_1Hz_UP_LIMIT 			: std_logic_vector:= x"0646_3035";
	constant Period_1Hz_DOWN_LIMIT 		: std_logic_vector:= x"05AD_37CF";
	constant Period_1Hz_RESET_FRAME 		: std_logic_vector:= x"0646_4000";
                                   
	constant Period_19Hz_UP_LIMIT 		: std_logic_vector:= x"0054_8946";
	constant Period_19Hz_DOWN_LIMIT 		: std_logic_vector:= x"004C_7C33";
	constant Period_19Hz_RESET_FRAME 	: std_logic_vector:= x"0054_9000";
                                   
	constant Period_195Hz_UP_LIMIT 		: std_logic_vector:= x"0008_3CA3";
	constant Period_195Hz_DOWN_LIMIT 	: std_logic_vector:= x"0007_73D0";
	constant Period_195Hz_RESET_FRAME 	: std_logic_vector:= x"0008_3D00";
                                   
	
--************ Определение значений параметров для детектора ***************
	constant SET_Pulse_UP_LIMIT          : std_logic_vector(0 to C_DWIDTH-1):= select_parameters(frequency_code 	=> C_AUTOSET, 
																																manual_code 		=> Pulse_UP_LIMIT,								
																																Constant_Code_1	=> Pulse_180_300ns_UP_LIMIT,		-- 0.76Hz 
																																Constant_Code_2	=> Pulse_390_410ns_UP_LIMIT,     --    1Hz 
																																Constant_Code_3	=> Pulse_390_410ns_UP_LIMIT,     --   19Hz 
																																Constant_Code_4	=> Pulse_180_300ns_UP_LIMIT);    --  195Hz

	constant SET_Pulse_DOWN_LIMIT        : std_logic_vector(0 to C_DWIDTH-1):= select_parameters(frequency_code 	=> C_AUTOSET, 
																																manual_code 		=> Pulse_DOWN_LIMIT,
																																Constant_Code_1	=> Pulse_180_300ns_DOWN_LIMIT,	-- 0.76Hz 
																																Constant_Code_2	=> Pulse_390_410ns_DOWN_LIMIT,   --    1Hz 
																																Constant_Code_3	=> Pulse_390_410ns_DOWN_LIMIT,   --   19Hz 
																																Constant_Code_4	=> Pulse_180_300ns_DOWN_LIMIT);  --  195Hz 

	constant SET_Pulse_RESET_FRAME	    : std_logic_vector(0 to C_DWIDTH-1):= select_parameters(frequency_code 	=> C_AUTOSET, 
																																manual_code 		=> Pulse_DOWN_LIMIT,
																																Constant_Code_1	=> Pulse_180_300ns_RESET_FRAME,	 -- 0.76Hz 
																																Constant_Code_2	=> Pulse_390_410ns_RESET_FRAME,   --    1Hz 
																																Constant_Code_3	=> Pulse_390_410ns_RESET_FRAME,   --   19Hz 
																																Constant_Code_4	=> Pulse_180_300ns_RESET_FRAME);  --  195Hz 

	constant SET_Period_UP_LIMIT         : std_logic_vector(0 to C_DWIDTH-1):= select_parameters(frequency_code 	=> C_AUTOSET, 
																																manual_code 		=> Period_UP_LIMIT,								
																																Constant_Code_1	=> Period_0_76Hz_UP_LIMIT,			-- 0.76Hz 
																																Constant_Code_2	=> Period_1Hz_UP_LIMIT,     		--    1Hz 
																																Constant_Code_3	=> Period_19Hz_UP_LIMIT,    	 	--   19Hz 
																																Constant_Code_4	=> Period_195Hz_UP_LIMIT);  	   --  195Hz 

	constant SET_Period_DOWN_LIMIT      : std_logic_vector(0 to C_DWIDTH-1):= select_parameters(frequency_code 	=> C_AUTOSET, 
																																manual_code 		=> Period_DOWN_LIMIT,							
																																Constant_Code_1	=> Period_0_76Hz_DOWN_LIMIT,		-- 0.76Hz 
																																Constant_Code_2	=> Period_1Hz_DOWN_LIMIT,     	--    1Hz 
																																Constant_Code_3	=> Period_19Hz_DOWN_LIMIT,     	--   19Hz 
																																Constant_Code_4	=> Period_195Hz_DOWN_LIMIT);     	--  195Hz 

	constant SET_Period_RESET_FRAME  : std_logic_vector(0 to C_DWIDTH-1):= select_parameters(frequency_code 	=> C_AUTOSET, 
																																manual_code 		=> Period_RESET_FRAME,							
																																Constant_Code_1	=> Period_0_76Hz_RESET_FRAME,		-- 0.76Hz 
																																Constant_Code_2	=> Period_1Hz_RESET_FRAME,     	--    1Hz 
																																Constant_Code_3	=> Period_19Hz_RESET_FRAME,     	--   19Hz 
																																Constant_Code_4	=> Period_195Hz_RESET_FRAME);    --  195Hz 

  signal slv_reg_write_select           : std_logic_vector(0 to 7);
  signal slv_reg_read_select            : std_logic_vector(0 to 7);
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
  slv_reg_write_select <= Bus2IP_WrCE(0 to 7);
  slv_reg_read_select  <= Bus2IP_RdCE(0 to 7);
  slv_write_ack        <= Bus2IP_WrCE(0) or Bus2IP_WrCE(1) or Bus2IP_WrCE(2) or Bus2IP_WrCE(3) or Bus2IP_WrCE(4) or Bus2IP_WrCE(5) or Bus2IP_WrCE(6) or Bus2IP_WrCE(7);
  slv_read_ack         <= Bus2IP_RdCE(0) or Bus2IP_RdCE(1) or Bus2IP_RdCE(2) or Bus2IP_RdCE(3) or Bus2IP_RdCE(4) or Bus2IP_RdCE(5) or Bus2IP_RdCE(6) or Bus2IP_RdCE(7);

  -- implement slave model register(s)
  SLAVE_REG_WRITE_PROC : process( Bus2IP_Clk ) is
  begin

    if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
      if Bus2IP_Reset = '1' then
        REG_Pulse_UP_LIMIT    	<= SET_Pulse_UP_LIMIT; 		
        REG_Pulse_DOWN_LIMIT  	<= SET_Pulse_DOWN_LIMIT;      	
        REG_Pulse_RESET_FRAME  	<= SET_Pulse_RESET_FRAME;  
        REG_Period_UP_LIMIT   	<= SET_Period_UP_LIMIT; 		
        REG_Period_DOWN_LIMIT    <= SET_Period_DOWN_LIMIT;     
        REG_Period_RESET_FRAME   <= SET_Period_RESET_FRAME;
		  
      else
        case slv_reg_write_select is
          when "10000000" =>
                REG_Pulse_UP_LIMIT(C_DWIDTH-1 downto 0) <= Bus2IP_Data(0 to C_DWIDTH-1);
          when "01000000" =>
                REG_Pulse_DOWN_LIMIT(C_DWIDTH-1 downto 0) <= Bus2IP_Data(0 to C_DWIDTH-1);
          when "00100000" =>
                REG_Pulse_RESET_FRAME(C_DWIDTH-1 downto 0) <= Bus2IP_Data(0 to C_DWIDTH-1);
          when "00001000" =>
                REG_Period_UP_LIMIT(C_DWIDTH-1 downto 0) <= Bus2IP_Data(0 to C_DWIDTH-1);
          when "00000100" =>
                REG_Period_DOWN_LIMIT(C_DWIDTH-1 downto 0) <= Bus2IP_Data(0 to C_DWIDTH-1);
          when "00000010" =>
                REG_Period_RESET_FRAME(C_DWIDTH-1 downto 0) <= Bus2IP_Data(0 to C_DWIDTH-1);
          when others => null;
        end case;
      end if;
    end if;

  end process SLAVE_REG_WRITE_PROC;

  -- implement slave model register read mux
  SLAVE_REG_READ_PROC : process( slv_reg_read_select, REG_Pulse_UP_LIMIT, REG_Pulse_DOWN_LIMIT, REG_Pulse_RESET_FRAME, REG_Period_UP_LIMIT, REG_Period_DOWN_LIMIT, REG_Period_RESET_FRAME ) is
  begin

    case slv_reg_read_select is
      when "10000000" => slv_ip2bus_data <= REG_Pulse_UP_LIMIT;   
      when "01000000" => slv_ip2bus_data <= REG_Pulse_DOWN_LIMIT;  
      when "00100000" => slv_ip2bus_data <= REG_Pulse_RESET_FRAME; 
      when "00010000" => slv_ip2bus_data <= Pulse_Status;   
      when "00001000" => slv_ip2bus_data <= REG_Period_UP_LIMIT;
      when "00000100" => slv_ip2bus_data <= REG_Period_DOWN_LIMIT; 
      when "00000010" => slv_ip2bus_data <= REG_Period_RESET_FRAME;
      when "00000001" => slv_ip2bus_data <= Period_Status;
      when others => slv_ip2bus_data <= (others => '0');
    end case;

  end process SLAVE_REG_READ_PROC;

Pulse_Status(31 downto 12) <= (others => '0');
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

period_test_inst: period_test
	PORT MAP(
				Pulse_Lenght_UP_LIMIT   	=>	REG_Pulse_UP_LIMIT(11 downto 0),    	  
				Pulse_Lenght_DOWN_LIMIT 	=>	REG_Pulse_DOWN_LIMIT(11 downto 0),  		  
				Pulse_Lenght_RESET_FRAME   => REG_Pulse_RESET_FRAME(11 downto 0), 
				Period_Lenght_UP_LIMIT   	=> REG_Period_UP_LIMIT,   
				Period_Lenght_DOWN_LIMIT 	=> REG_Period_DOWN_LIMIT, 
				Period_Lenght_RESET_FRAME	=>	REG_Period_RESET_FRAME,	     
				Pulse_Status 	=>	Pulse_Status(11 downto 0),	     
				Period_Status	=>	Period_Status,	     

				IN_CLK  			=> IN_CLK,	-- Входная частота 
				REF_CLK 			=>	REF_CLK, -- Опорная частота
				CLK_GOOD 		=> CLK_GOOD -- Состояние частоты ('1'- в норме)
		);
end IMP;
