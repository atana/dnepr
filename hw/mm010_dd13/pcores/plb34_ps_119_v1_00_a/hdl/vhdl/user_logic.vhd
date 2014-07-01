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
-- Date:              Wed Mar 24 11:21:26 2010 (by Create and Import Peripheral Wizard)
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
    -- ADD USER PORTS ABOVE THIS LINE ------------------
		clk_40								: in  STD_LOGIC;
		clk_d									: in 	STD_LOGIC;
		takt_number							: in STD_LOGIC_VECTOR(15 downto 0);
		discr_number						: in STD_LOGIC_VECTOR(15 downto 0);
		test_sig								: out STD_LOGIC;							-- тестовый сигнал
		PS_out								: out STD_LOGIC_VECTOR(1 to 16);
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
  signal clk_sys								: std_logic;
  signal	rst_sys								: std_logic;
  signal	Control_reg_IMP					: std_logic_vector(31 downto 0);
  signal	PS_isp								: std_logic;
  signal	PS_isp_Control_reg_23			: std_logic;
  signal count_clk100						: std_logic_vector(0 downto 0);
  
  signal REG_D0_CE_4_shift_L       		: std_logic_vector(2 downto 0);
  signal REG_RST_CE_6_shift_L       		: std_logic_vector(2 downto 0);
  signal REG_D0_CE_4_L                 : std_logic;
  signal REG_RST_CE_6_L                 : std_logic;
  signal REG_D0_CE_4                   : std_logic;
  signal REG_RST_CE_6			   			: std_logic;
  ------------------------------------------
  -- Signals for user logic slave model s/w accessible register example
  ------------------------------------------

  signal Ntakt_reg                      : std_logic_vector(0 to C_DWIDTH-1);
  signal Nach_isp_d_reg                 : std_logic_vector(0 to C_DWIDTH-1);
  signal Dlit_isp_d_reg                 : std_logic_vector(0 to C_DWIDTH-1);
  signal Control_reg                    : std_logic_vector(0 to C_DWIDTH-1);
  signal Status_reg                     : std_logic_vector(0 to C_DWIDTH-1);
  signal RST_reg								 : std_logic_vector(0 to C_DWIDTH-1);
  signal count_isp							 : std_logic_vector(31 downto 0);
  signal count_fall_preload				 : std_logic_vector(31 downto 0);
  signal count_fall_wait					 : std_logic_vector(31 downto 0);
  signal slv_reg_write_select           : std_logic_vector(0 to 7);
  signal slv_reg_read_select            : std_logic_vector(0 to 7);
  signal slv_ip2bus_data                : std_logic_vector(0 to C_DWIDTH-1);
  signal slv_read_ack                   : std_logic;
  signal slv_write_ack                  : std_logic;

	component PS_isp_avt is
		Port ( 
				rst_sys				: in std_logic;
				clk_sys				: in std_logic;
				clk_d					: in std_logic;
				takt_number			: in STD_LOGIC_VECTOR(15 downto 0);
				discr_number		: in STD_LOGIC_VECTOR(15 downto 0);
				
				Ntakt_reg			: in  STD_LOGIC_VECTOR (31 downto 0);
				Nach_isp_d_reg		: in  STD_LOGIC_VECTOR (31 downto 0);
				Dlit_isp_d_reg		: in  STD_LOGIC_VECTOR (31 downto 0);

				Control_reg			: in  STD_LOGIC_VECTOR (31 downto 0);
				Status_reg			: out STD_LOGIC_VECTOR (31 downto 0);
				
				test_sig				: out STD_LOGIC;								-- тестовый сигнал
				count_isp			: out STD_LOGIC_VECTOR (31 downto 0);	-- счётчик исполненных импульсов
				count_fall_preload : out STD_LOGIC_VECTOR(31 downto 0);	-- счётчик заданий, отброшеных при загрузке 
				count_fall_wait	: out STD_LOGIC_VECTOR(31 downto 0);	-- счётчик заданий, отброшеных при ожидании
				PS_isp				: out STD_LOGIC
			);	
	end component;

	component pulse_fr_form is	
    Port ( 
	        FRONT : in std_logic;
           CLK : in std_logic;
           OUT_PULSE : inout std_logic
			 );
	end component;

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
      if (Bus2IP_Reset = '1' or REG_RST_CE_6 = '1') then
        Ntakt_reg <= (others => '0');
        Nach_isp_d_reg <= (others => '0');
        Dlit_isp_d_reg <= (others => '0');
        Control_reg <= (others => '0');
		  RST_reg			<=  (others => '0');
--		  T2_reg				<=  (others => '0');
      else
        case slv_reg_write_select is
          when "01000000" =>
            for byte_index in 0 to (C_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                Ntakt_reg(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00100000" =>
            for byte_index in 0 to (C_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                Nach_isp_d_reg(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00010000" =>
            for byte_index in 0 to (C_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                Dlit_isp_d_reg(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00001000" =>
            for byte_index in 0 to (C_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                Control_reg(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "00000010" =>
            for byte_index in 0 to (C_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                RST_reg(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
--          when "00000001" =>
--            for byte_index in 0 to (C_DWIDTH/8)-1 loop
--              if ( Bus2IP_BE(byte_index) = '1' ) then
--                T2_reg(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
--              end if;
--            end loop;				
          when others => null;
        end case;
      end if;
    end if;

  end process SLAVE_REG_WRITE_PROC;

	REG_D0_CE_4 <= Bus2IP_Data(31) and slv_reg_write_select(4);
	
	REG_RST_CE_6 <= slv_reg_write_select(6);
	
	Control_reg0_waitrun_en_bit:process(rst_sys, Bus2IP_Clk)
		begin
			if (rst_sys = '1') then
				REG_D0_CE_4_shift_L <= b"000";
				REG_D0_CE_4_L <= '0';
			elsif (Bus2IP_Clk'event and Bus2IP_Clk = '1') then
				REG_D0_CE_4_shift_L <= REG_D0_CE_4_shift_L(1 downto 0) &  REG_D0_CE_4;
				REG_D0_CE_4_L <= REG_D0_CE_4_shift_L(0) or REG_D0_CE_4_shift_L(1) or REG_D0_CE_4_shift_L(2);
			end if;
		end process;
			
	Control_reg0_IMP_inst: pulse_fr_form
			port map ( 
				  FRONT 			=> REG_D0_CE_4_L,
				  CLK 			=> clk_sys,
				  OUT_PULSE 	=> Control_reg_IMP(0)
				  );
				  
	Control_reg4_clean_bit:process(rst_sys, Bus2IP_Clk)
		begin
			if (rst_sys = '1') then
				REG_RST_CE_6_shift_L <= b"000";
				REG_RST_CE_6_L <= '0';
			elsif (Bus2IP_Clk'event and Bus2IP_Clk = '1') then
				REG_RST_CE_6_shift_L <= REG_RST_CE_6_shift_L(1 downto 0) &  REG_RST_CE_6;
				REG_RST_CE_6_L <= REG_RST_CE_6_shift_L(0) or REG_RST_CE_6_shift_L(1) or REG_RST_CE_6_shift_L(2);
			end if;
		end process;
			
	Control_reg4_IMP_inst: pulse_fr_form
			port map ( 
				  FRONT 			=> REG_RST_CE_6_L,
				  CLK 			=> clk_sys,
				  OUT_PULSE 	=> Control_reg_IMP(4)
				  );
	
	Control_reg_IMP(31 downto 5) <= b"000000000000000000000000000";
	Control_reg_IMP(3 downto 1) <= b"000";
  -- implement slave model register read mux
 SLAVE_REG_READ_PROC : process( slv_reg_read_select, Ntakt_reg, Nach_isp_d_reg, Dlit_isp_d_reg, Control_reg, Status_reg ) is
  begin

    case slv_reg_read_select is
      when "10000000" => slv_ip2bus_data <= x"10042001";		-- +0	0
--                                             | | | |
--                                            ggmmddvv
      when "01000000" => slv_ip2bus_data <= Ntakt_reg;		-- +1	4
      when "00100000" => slv_ip2bus_data <= Nach_isp_d_reg;	-- +2	8
      when "00010000" => slv_ip2bus_data <= Dlit_isp_d_reg;	-- +3	C
      when "00001000" => slv_ip2bus_data <= Control_reg;		-- +4	10
      when "00000100" => slv_ip2bus_data <= Status_reg;		-- +5	14
      when "00000010" => slv_ip2bus_data <= RST_reg;			-- +6	18
      when "00000001" => slv_ip2bus_data <= count_fall_preload(7 downto 0) & count_fall_wait(7 downto 0) & count_isp(15 downto 0);		-- +7	1C

      when others => slv_ip2bus_data <= (others => '0');          
    end case;

  end process SLAVE_REG_READ_PROC;

	rst_sys <= '1' when Bus2IP_Reset = '1' else '0';
	clk_sys <= clk_40;

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

	PS_isp_avt_inst: PS_isp_avt
		port map(
					rst_sys				=> rst_sys,				
					clk_sys				=> clk_sys,			
					clk_d					=> clk_d,
					takt_number			=> takt_number,
					discr_number		=> discr_number,
					
					Ntakt_reg			=> Ntakt_reg,		
					Nach_isp_d_reg		=> Nach_isp_d_reg,
					Dlit_isp_d_reg		=> Dlit_isp_d_reg,	
					
					Control_reg			=> Control_reg_IMP,		
					Status_reg			=> Status_reg,	
					
					test_sig				=> test_sig,
					count_isp			=> count_isp,
					count_fall_preload => count_fall_preload,
					count_fall_wait	=>  count_fall_wait,	
					PS_isp				=> PS_isp
					);
	
	PS_isp_Control_reg_23	<= Control_reg(23) or PS_isp;

	PS_gen:   for i in 1 to 16 generate
		begin
			process (rst_sys, clk_sys)
				begin
					if (rst_sys = '1') then
						PS_out(i) <= '0';
					elsif (clk_sys'event and clk_sys = '1') then
						PS_out(i) <= PS_isp_Control_reg_23;
					end if;
				end process;
		end generate;
		
	end IMP;

