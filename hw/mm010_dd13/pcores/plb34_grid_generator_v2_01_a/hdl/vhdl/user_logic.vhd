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
-- Version:           2.01.a
-- Description:       User logic.
-- Date:              Mon Mar 29 18:03:43 2010 (by Create and Import Peripheral Wizard)
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
    --USER generics added here
		DISCRETE_NUMBER_SHIFT			:  std_logic_vector:= x"00030030"; --48;
		SIMULATION : boolean := false;
--		SIMULATION : boolean := true       -- for TIMESIM
    -- ADD USER GENERICS ABOVE THIS LINE ---------------

    -- DO NOT EDIT BELOW THIS LINE ---------------------
    -- Bus protocol parameters, do not add to or delete
    C_DWIDTH                       : integer              := 32;
    C_NUM_CE                       : integer              := 4
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------
		CLK_EXT_19Hz				:in  std_logic;   
		CLK_EXT0_40MHz				:in  std_logic;
		CLK_EXT1_40MHz				:in  std_logic;
		TAKT_NUMBER 				:out std_logic_vector(15 downto 0);
		DISCRETE_NUMBER 			:out std_logic_vector(15 downto 0);
		SYNC_CLK_50kHz 			:out std_logic;
		CLK_40MHz_GClk 			:out std_logic;
		CLK_40MHz_GLogic 			:out std_logic;
		SYNC_CLK_1_25MHz 			:out std_logic;
		CLK_19Hz_internal			:out std_logic;
		test_sig						:out std_logic;
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

  --USER signal declarations added here, as needed for user logic
component Grid_Gen
generic (
--				SIMULATION : boolean := false
				SIMULATION : boolean := true       -- for TIMESIM
         ); 
	Port (
			DISCRETE_NUMBER_SHIFT  	:in  std_logic_vector(15 downto 0); --48;
			SHIFT_SYNC_CLK_50kHz  	:in  std_logic_vector(2 downto 0); 
			INDEPENDET_WORK_EN		:in  std_logic;
			CLK_EXT0_OR_EXT1			:in  std_logic;
			Bus2IP_Reset				:in  std_logic;
			Bus2IP_Clk					:in  std_logic;
			CLK_EXT_19Hz				:in  std_logic;
			CLK_EXT0_40MHz				:in  std_logic;
			CLK_EXT1_40MHz				:in  std_logic;
			TAKT_NUMBER_UPDATE		:in  std_logic;
			Bus2IP_TAKT_NUMBER 	 	:in  std_logic_vector(15 downto 0);
			TAKT_NUMBER 				:out std_logic_vector(15 downto 0);
			DISCRETE_NUMBER 			:out std_logic_vector(15 downto 0);
			CLK_40MHz_GClk				:out std_logic;
			CLK_40MHz_GLogic			:out std_logic;
			SYNC_CLK_50kHz 			:out std_logic;
			SYNC_CLK_1_25MHz 			:out std_logic;
			CLK_19Hz_internal			:out std_logic
			);
end component;
  ------------------------------------------
  -- Signals for user logic slave model s/w accessible register example
  ------------------------------------------
  signal REG_DISCRETE_NUMBER_SHIFT     : std_logic_vector(C_DWIDTH-1 downto 0);
  signal REG_TAKT_NUMBER			   : std_logic_vector(C_DWIDTH-1 downto 0);
  signal TAKT_NUMBER_UPDATE			   : std_logic:= '0';
  signal iTAKT_NUMBER			   	   : std_logic_vector(31 downto 0):= (others => '0');
  signal slv_reg_write_select          : std_logic_vector(0 to 3);
  signal slv_reg_read_select           : std_logic_vector(0 to 3);
  signal slv_ip2bus_data               : std_logic_vector(0 to C_DWIDTH-1);
  signal slv_read_ack                  : std_logic;
  signal slv_write_ack                 : std_logic;
  signal Delta_NUMBER_SHIFT			   : std_logic_vector(15 downto 0);

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
  slv_reg_write_select <= Bus2IP_WrCE(0 to 3);
  slv_reg_read_select  <= Bus2IP_RdCE(0 to 3);
  slv_write_ack        <= Bus2IP_WrCE(0) or Bus2IP_WrCE(1) or Bus2IP_WrCE(2) or Bus2IP_WrCE(3);
  slv_read_ack         <= Bus2IP_RdCE(0) or Bus2IP_RdCE(1) or Bus2IP_RdCE(2) or Bus2IP_RdCE(3);

  -- implement slave model register(s)
  SLAVE_REG_WRITE_PROC : process( Bus2IP_Clk ) is
  begin

    if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
			if Bus2IP_Reset = '1' then
			  REG_DISCRETE_NUMBER_SHIFT <= DISCRETE_NUMBER_SHIFT;
			  REG_TAKT_NUMBER <= (others => '0');
			  TAKT_NUMBER_UPDATE<= '1';
			  
			else
			  case slv_reg_write_select is
				 when "0100" =>
						 REG_DISCRETE_NUMBER_SHIFT <= Bus2IP_Data;
				 when "0010" =>
						 REG_TAKT_NUMBER <= Bus2IP_Data;
						 TAKT_NUMBER_UPDATE <= '1';
				 when others => 
						 TAKT_NUMBER_UPDATE <= '0';
			  end case;
			end if;
    end if;

test_sig <= TAKT_NUMBER_UPDATE;

  end process SLAVE_REG_WRITE_PROC;

  -- implement slave model register read mux
  SLAVE_REG_READ_PROC : process( slv_reg_read_select, REG_DISCRETE_NUMBER_SHIFT,REG_TAKT_NUMBER,iTAKT_NUMBER ) is
  begin

    case slv_reg_read_select is
      when "1000" => slv_ip2bus_data <= x"10032201";
      when "0100" => slv_ip2bus_data <= REG_DISCRETE_NUMBER_SHIFT;
      when "0010" => slv_ip2bus_data <= REG_TAKT_NUMBER;
      when "0001" => slv_ip2bus_data <= iTAKT_NUMBER;
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

Grid_Gen_inst: Grid_Gen
			generic map(
							SIMULATION => SIMULATION
							) 
				Port Map(
							DISCRETE_NUMBER_SHIFT => REG_DISCRETE_NUMBER_SHIFT(15 downto 0),
							SHIFT_SYNC_CLK_50kHz	 => REG_DISCRETE_NUMBER_SHIFT(18 downto 16),
							INDEPENDET_WORK_EN	 => REG_DISCRETE_NUMBER_SHIFT(28),
							CLK_EXT0_OR_EXT1	 	 => REG_DISCRETE_NUMBER_SHIFT(24),
							Bus2IP_Reset			 => Bus2IP_Reset,
							Bus2IP_Clk				 => Bus2IP_Clk,
							CLK_EXT_19Hz			 => CLK_EXT_19Hz,
							CLK_EXT0_40MHz			 => CLK_EXT0_40MHz,
							CLK_EXT1_40MHz			 => CLK_EXT1_40MHz,
							TAKT_NUMBER_UPDATE	 => TAKT_NUMBER_UPDATE,
							Bus2IP_TAKT_NUMBER 	 => REG_TAKT_NUMBER(15 downto 0),
							TAKT_NUMBER 			 => iTAKT_NUMBER(15 downto 0), 		
							DISCRETE_NUMBER 		 => DISCRETE_NUMBER,
							CLK_40MHz_GClk			 => CLK_40MHz_GClk,
							CLK_40MHz_GLogic		 => CLK_40MHz_GLogic,
							SYNC_CLK_50kHz 		 => SYNC_CLK_50kHz,
							SYNC_CLK_1_25MHz 		 => SYNC_CLK_1_25MHz,
							CLK_19Hz_internal		 => CLK_19Hz_internal
							);

iTAKT_NUMBER(31 downto 16)	<= (others => '0');
TAKT_NUMBER <= iTAKT_NUMBER(15 downto 0);
end IMP;
