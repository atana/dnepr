  -- reg0 0x0  --  ID
  -- reg1 0x4  --  Version
  -- reg2 0x8  --  RST
  -- reg3 0xC  --  write tr
  -- reg4 0x10 --  write rc
  -- reg5 0x14 --  outrun
  -- reg6 0x18 --  optical line delay
  -- reg7 0x1C --  tr start
  -- reg8 0x20 --  tr stop
  -- reg9 0x24 --  rc start
  -- reg10 0x28 -- rc stop


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
    C_NUM_CE                       : integer              := 15
    -- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
  port
  (
    -- ADD USER PORTS BELOW THIS LINE ------------------
    tact : in std_logic_vector(15 downto 0);
    discr : in std_logic_vector(15 downto 0);

    TR_start : out std_logic;
    TR_stop : out std_logic;
    RC_start : out std_logic;
    RC_stop : out std_logic;

    dTR_start : out std_logic;
    dTR_stop : out std_logic;
    dRC_start : out std_logic;
    dRC_stop : out std_logic;
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

component core
  Port(
    clk : in std_logic;
    rst : in std_logic;

    tact : in std_logic_vector(15 downto 0);
    discr : in std_logic_vector(15 downto 0);
    optical_line_delay : in std_logic_vector(15 downto 0);
    outrun : in std_logic_vector(15 downto 0);

    TstartTR : in std_logic_vector(15 downto 0);
    DstartTR : in std_logic_vector(15 downto 0);
    TstopTR : in std_logic_vector(15 downto 0);
    DstopTR : in std_logic_vector(15 downto 0);
    WTR : in std_logic;

    TstartRC : in std_logic_vector(15 downto 0);
    DstartRC : in std_logic_vector(15 downto 0);
    TstopRC : in std_logic_vector(15 downto 0);
    DstopRC : in std_logic_vector(15 downto 0);
    WRC : in std_logic;

    TR_start : out std_logic;
    TR_stop : out std_logic;
    RC_start : out std_logic;
    RC_stop : out std_logic;

    dTR_start : out std_logic;
    dTR_stop : out std_logic;
    dRC_start : out std_logic;
    dRC_stop : out std_logic
  );
end component;

signal rst : std_logic := '0';

  --USER signal declarations added here, as needed for user logic

  ------------------------------------------
  -- Signals for user logic slave model s/w accessible register example
  ------------------------------------------
  signal slv_reg0                       : std_logic_vector(0 to C_DWIDTH-1); -- ID
  signal slv_reg1                       : std_logic_vector(0 to C_DWIDTH-1); -- Version
  signal slv_reg2                       : std_logic_vector(0 to C_DWIDTH-1); -- RST
  signal slv_reg3                       : std_logic_vector(0 to C_DWIDTH-1); -- write tr
  signal slv_reg4                       : std_logic_vector(0 to C_DWIDTH-1); -- write rc
  signal slv_reg5                       : std_logic_vector(0 to C_DWIDTH-1); -- outrun
  signal slv_reg6                       : std_logic_vector(0 to C_DWIDTH-1); -- optical line delay
  signal slv_reg7                       : std_logic_vector(0 to C_DWIDTH-1); -- tr start
  signal slv_reg8                       : std_logic_vector(0 to C_DWIDTH-1); -- tr stop
  signal slv_reg9                       : std_logic_vector(0 to C_DWIDTH-1); -- rc start
  signal slv_reg10                      : std_logic_vector(0 to C_DWIDTH-1); -- rc stop
  signal slv_reg11                      : std_logic_vector(0 to C_DWIDTH-1);
  signal slv_reg12                      : std_logic_vector(0 to C_DWIDTH-1);
  signal slv_reg13                      : std_logic_vector(0 to C_DWIDTH-1);
  signal slv_reg14                      : std_logic_vector(0 to C_DWIDTH-1);
  signal slv_reg_write_select           : std_logic_vector(0 to 14);
  signal slv_reg_read_select            : std_logic_vector(0 to 14);
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
  slv_reg_write_select <= Bus2IP_WrCE(0 to 14);
  slv_reg_read_select  <= Bus2IP_RdCE(0 to 14);
  slv_write_ack        <= Bus2IP_WrCE(0) or Bus2IP_WrCE(1) or Bus2IP_WrCE(2) or Bus2IP_WrCE(3) or Bus2IP_WrCE(4) or Bus2IP_WrCE(5) or Bus2IP_WrCE(6) or Bus2IP_WrCE(7) or Bus2IP_WrCE(8) or Bus2IP_WrCE(9) or Bus2IP_WrCE(10) or Bus2IP_WrCE(11) or Bus2IP_WrCE(12) or Bus2IP_WrCE(13) or Bus2IP_WrCE(14);
  slv_read_ack         <= Bus2IP_RdCE(0) or Bus2IP_RdCE(1) or Bus2IP_RdCE(2) or Bus2IP_RdCE(3) or Bus2IP_RdCE(4) or Bus2IP_RdCE(5) or Bus2IP_RdCE(6) or Bus2IP_RdCE(7) or Bus2IP_RdCE(8) or Bus2IP_RdCE(9) or Bus2IP_RdCE(10) or Bus2IP_RdCE(11) or Bus2IP_RdCE(12) or Bus2IP_RdCE(13) or Bus2IP_RdCE(14);

  -- implement slave model register(s)
  SLAVE_REG_WRITE_PROC : process( Bus2IP_Clk ) is
  begin

    if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
      if Bus2IP_Reset = '1' then
        -- slv_reg0 <= (others => '0');
        -- slv_reg1 <= (others => '0');
        slv_reg2 <= (others => '0');
        slv_reg3 <= (others => '0');
        slv_reg4 <= (others => '0');
        slv_reg5 <= (others => '0');
        slv_reg6 <= (others => '0');
        slv_reg7 <= (others => '0');
        slv_reg8 <= (others => '0');
        slv_reg9 <= (others => '0');
        slv_reg10 <= (others => '0');
        slv_reg11 <= (others => '0');
        slv_reg12 <= (others => '0');
        slv_reg13 <= (others => '0');
        slv_reg14 <= (others => '0');
      else
        case slv_reg_write_select is
          -- when "100000000000000" =>
          --   for byte_index in 0 to (C_DWIDTH/8)-1 loop
          --     if ( Bus2IP_BE(byte_index) = '1' ) then
          --       slv_reg0(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
          --     end if;
          --   end loop;
          -- when "010000000000000" =>
          --   for byte_index in 0 to (C_DWIDTH/8)-1 loop
          --     if ( Bus2IP_BE(byte_index) = '1' ) then
          --       slv_reg1(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
          --     end if;
          --   end loop;
          when "001000000000000" =>
            for byte_index in 0 to (C_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg2(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "000100000000000" =>
            for byte_index in 0 to (C_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg3(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "000010000000000" =>
            for byte_index in 0 to (C_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg4(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "000001000000000" =>
            for byte_index in 0 to (C_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg5(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "000000100000000" =>
            for byte_index in 0 to (C_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg6(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "000000010000000" =>
            for byte_index in 0 to (C_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg7(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "000000001000000" =>
            for byte_index in 0 to (C_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg8(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "000000000100000" =>
            for byte_index in 0 to (C_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg9(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "000000000010000" =>
            for byte_index in 0 to (C_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg10(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "000000000001000" =>
            for byte_index in 0 to (C_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg11(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "000000000000100" =>
            for byte_index in 0 to (C_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg12(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "000000000000010" =>
            for byte_index in 0 to (C_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg13(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when "000000000000001" =>
            for byte_index in 0 to (C_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg14(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
          when others => null;
        end case;
      end if;
    end if;

  end process SLAVE_REG_WRITE_PROC;

  -- implement slave model register read mux
  SLAVE_REG_READ_PROC : process( slv_reg_read_select, slv_reg0, slv_reg1, slv_reg2, slv_reg3, slv_reg4, slv_reg5, slv_reg6, slv_reg7, slv_reg8, slv_reg9, slv_reg10, slv_reg11, slv_reg12, slv_reg13, slv_reg14 ) is
  begin

    case slv_reg_read_select is
      when "100000000000000" => slv_ip2bus_data <= x"95954655";--slv_reg0; -- ASCII "  FU"
      when "010000000000000" => slv_ip2bus_data <= x"14060300";--slv_reg1;
      when "001000000000000" => slv_ip2bus_data <= slv_reg2;
      when "000100000000000" => slv_ip2bus_data <= slv_reg3;
      when "000010000000000" => slv_ip2bus_data <= slv_reg4;
      when "000001000000000" => slv_ip2bus_data <= slv_reg5;
      when "000000100000000" => slv_ip2bus_data <= slv_reg6;
      when "000000010000000" => slv_ip2bus_data <= slv_reg7;
      when "000000001000000" => slv_ip2bus_data <= slv_reg8;
      when "000000000100000" => slv_ip2bus_data <= slv_reg9;
      when "000000000010000" => slv_ip2bus_data <= slv_reg10;
      when "000000000001000" => slv_ip2bus_data <= slv_reg11;
      when "000000000000100" => slv_ip2bus_data <= slv_reg12;
      when "000000000000010" => slv_ip2bus_data <= slv_reg13;
      when "000000000000001" => slv_ip2bus_data <= slv_reg14;
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

rst <= Bus2IP_Reset or slv_reg_write_select(2);

core_inst: core
  Port map(
    clk => Bus2IP_Clk,
    rst => rst,

    tact => tact,
    discr => discr,
    optical_line_delay => slv_reg6(16 to 31),
    outrun => slv_reg5(16 to 31),

    TstartTR  => slv_reg7(0 to 15),
    DstartTR  => slv_reg7(16 to 31),
    TstopTR   => slv_reg8(0 to 15),
    DstopTR   => slv_reg8(16 to 31),
    WTR       => slv_reg_write_select(3),

    TstartRC  => slv_reg9(0 to 15),
    DstartRC  => slv_reg9(16 to 31),
    TstopRC   => slv_reg10(0 to 15),
    DstopRC   => slv_reg10(16 to 31),
    WRC       => slv_reg_write_select(4),

    TR_start    => TR_start,
    TR_stop     => TR_stop,
    RC_start    => RC_start,
    RC_stop     => RC_stop,

    dTR_start   => dTR_start,
    dTR_stop    => dTR_stop,
    dRC_start   => dRC_start,
    dRC_stop    => dRC_stop
  );

end IMP;