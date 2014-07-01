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
	generic(
		-- ADD USER GENERICS BELOW THIS LINE ---------------
		version : std_logic_vector(31 downto 0) := x"12052500";
		
		clk_freq : integer := 100000000;
		ref_clk_freq : integer := 19;
		discr_qnt : integer := 65536;
		array_stat : integer := 16;
		-- ADD USER GENERICS ABOVE THIS LINE ---------------

		-- DO NOT EDIT BELOW THIS LINE ---------------------
		-- Bus protocol parameters, do not add to or delete
		C_DWIDTH                       : integer              := 32;
		C_NUM_CE                       : integer              := 7
		-- DO NOT EDIT ABOVE THIS LINE ---------------------
	);
  port(
		-- ADD USER PORTS BELOW THIS LINE ------------------
		ref_clk : in std_logic;
		ref_clk_present : in std_logic;

		tact_clk : out std_logic;
		discr_clk : out std_logic;
		edge_tact_clk : out std_logic;
		edge_discr_clk : out std_logic;
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


architecture IMP of user_logic is

	component regenerator is
		generic(
			version : std_logic_vector(31 downto 0) := x"12041100";
			
			clk_freq : integer := 100000000;
			ref_clk_freq : integer := 19;
			discr_qnt : integer := 65536;
			array_stat : integer := 16
		);
		port(
			-- for ip-regs --------------
			state_cnt_int : out integer;
			state_calc_int : out integer;
			ready : out std_logic;
			tact_source : in std_logic; -- 0=ext, 1=int
			stat_cnt : out integer;
			-----------------------------
			
			rst : in std_logic;
			clk : in std_logic;

			ref_clk : in std_logic;
			ref_clk_present : in std_logic;

			tact_clk : out std_logic;
			discr_clk : out std_logic;
			edge_tact_clk : out std_logic;
			edge_discr_clk : out std_logic
		);
	end component;

	signal state_cnt_int : integer range 0 to 10 := 0;
	signal state_calc_int : integer range 0 to 10 := 0;
	signal ready : std_logic := '0';
	signal tact_source : std_logic := '0'; -- 0=ext, 1=int
	signal stat_cnt : integer range 0 to 32 := 0;
	signal rst : std_logic := '0';

	------------------------------------------
	-- Signals for user logic slave model s/w accessible register example
	------------------------------------------
	signal slv_reg0                       : std_logic_vector(0 to C_DWIDTH-1);	-- version
	signal slv_reg1                       : std_logic_vector(0 to C_DWIDTH-1);	-- rst
	signal slv_reg2                       : std_logic_vector(0 to C_DWIDTH-1);	-- ready
	signal slv_reg3                       : std_logic_vector(0 to C_DWIDTH-1);	-- tact_source
	signal slv_reg4                       : std_logic_vector(0 to C_DWIDTH-1);	-- state_cnt
	signal slv_reg5                       : std_logic_vector(0 to C_DWIDTH-1);	--	state_calc
	signal slv_reg6                       : std_logic_vector(0 to C_DWIDTH-1);	-- stat_cnt
	signal slv_reg_write_select           : std_logic_vector(0 to 6);
	signal slv_reg_read_select            : std_logic_vector(0 to 6);
	signal slv_ip2bus_data                : std_logic_vector(0 to C_DWIDTH-1);
	signal slv_read_ack                   : std_logic;
	signal slv_write_ack                  : std_logic;

begin

	regen: regenerator
		generic map(
--			version : std_logic_vector(31 downto 0) := x"12041100";
			clk_freq => clk_freq,
			ref_clk_freq => ref_clk_freq,
			discr_qnt => discr_qnt,
			array_stat => array_stat
		)
		port map(
			-- for ip-regs --------------
			state_cnt_int => state_cnt_int,
			state_calc_int => state_calc_int,
			ready => ready,
			tact_source => tact_source, -- 0=ext, 1=int
			stat_cnt => stat_cnt,
			-----------------------------
			
			rst => rst,
			clk => Bus2IP_Clk,

			ref_clk => ref_clk,
			ref_clk_present => ref_clk_present,

			tact_clk => tact_clk,
			discr_clk => discr_clk,
			edge_tact_clk => edge_tact_clk,
			edge_discr_clk => edge_discr_clk
		);

	rst <= Bus2IP_Reset or Bus2IP_WrCE(1);
	slv_reg4 <= conv_std_logic_vector(state_cnt_int,C_DWIDTH);
	slv_reg5 <= conv_std_logic_vector(state_calc_int,C_DWIDTH);
	ready <= slv_reg2(0);
	tact_source <= slv_reg3(0); -- 0=ext, 1=int
	slv_reg6 <= conv_std_logic_vector(stat_cnt,C_DWIDTH);
	
	slv_reg0 <= version;

  ------------------------------------------
  --    Bus2IP_WrCE or   Memory Mapped
  --       Bus2IP_RdCE   Register
  --            "1000"   C_BASEADDR + 0x0
  --            "0100"   C_BASEADDR + 0x4
  --            "0010"   C_BASEADDR + 0x8
  --            "0001"   C_BASEADDR + 0xC
  -- 
  ------------------------------------------
  slv_reg_write_select <= Bus2IP_WrCE(0 to 6);
  slv_reg_read_select  <= Bus2IP_RdCE(0 to 6);
  slv_write_ack        <= Bus2IP_WrCE(0) or Bus2IP_WrCE(1) or Bus2IP_WrCE(2) or Bus2IP_WrCE(3) or Bus2IP_WrCE(4) or Bus2IP_WrCE(5) or Bus2IP_WrCE(6);
  slv_read_ack         <= Bus2IP_RdCE(0) or Bus2IP_RdCE(1) or Bus2IP_RdCE(2) or Bus2IP_RdCE(3) or Bus2IP_RdCE(4) or Bus2IP_RdCE(5) or Bus2IP_RdCE(6);

  -- implement slave model register(s)
  SLAVE_REG_WRITE_PROC : process( Bus2IP_Clk ) is
  begin

    if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
      if Bus2IP_Reset = '1' then
--        slv_reg0 <= (others => '0');
        slv_reg1 <= (others => '0');
--        slv_reg2 <= (others => '0');
        slv_reg3 <= (others => '0');
--        slv_reg4 <= (others => '0');
--        slv_reg5 <= (others => '0');
--        slv_reg6 <= (others => '0');
      else
        case slv_reg_write_select is
--          when "1000000" =>
--            for byte_index in 0 to (C_DWIDTH/8)-1 loop
--              if ( Bus2IP_BE(byte_index) = '1' ) then
--                slv_reg0(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
--              end if;
--            end loop;
          when "0100000" =>
            for byte_index in 0 to (C_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg1(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
--          when "0010000" =>
--            for byte_index in 0 to (C_DWIDTH/8)-1 loop
--              if ( Bus2IP_BE(byte_index) = '1' ) then
--                slv_reg2(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
--              end if;
--            end loop;
          when "0001000" =>
            for byte_index in 0 to (C_DWIDTH/8)-1 loop
              if ( Bus2IP_BE(byte_index) = '1' ) then
                slv_reg3(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
              end if;
            end loop;
--          when "0000100" =>
--            for byte_index in 0 to (C_DWIDTH/8)-1 loop
--              if ( Bus2IP_BE(byte_index) = '1' ) then
--                slv_reg4(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
--              end if;
--            end loop;
--          when "0000010" =>
--            for byte_index in 0 to (C_DWIDTH/8)-1 loop
--              if ( Bus2IP_BE(byte_index) = '1' ) then
--                slv_reg5(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
--              end if;
--            end loop;
--          when "0000001" =>
--            for byte_index in 0 to (C_DWIDTH/8)-1 loop
--              if ( Bus2IP_BE(byte_index) = '1' ) then
--                slv_reg6(byte_index*8 to byte_index*8+7) <= Bus2IP_Data(byte_index*8 to byte_index*8+7);
--              end if;
--            end loop;
          when others => null;
        end case;
      end if;
    end if;

  end process SLAVE_REG_WRITE_PROC;

  -- implement slave model register read mux
  SLAVE_REG_READ_PROC : process( slv_reg_read_select, slv_reg0, slv_reg1, slv_reg2, slv_reg3, slv_reg4, slv_reg5, slv_reg6 ) is
  begin

    case slv_reg_read_select is
      when "1000000" => slv_ip2bus_data <= slv_reg0;
      when "0100000" => slv_ip2bus_data <= slv_reg1;
      when "0010000" => slv_ip2bus_data <= slv_reg2;
      when "0001000" => slv_ip2bus_data <= slv_reg3;
      when "0000100" => slv_ip2bus_data <= slv_reg4;
      when "0000010" => slv_ip2bus_data <= slv_reg5;
      when "0000001" => slv_ip2bus_data <= slv_reg6;
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

end IMP;
