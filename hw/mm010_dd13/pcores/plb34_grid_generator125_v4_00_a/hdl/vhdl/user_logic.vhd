--regs
-- 0x0 - version
-- 0x4 - ID
-- 0x8 - REG_TAKT_NUMBER
-- 0xC - iTAKT_NUMBER

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

library proc_common_v2_00_a;
use proc_common_v2_00_a.proc_common_pkg.all;

entity user_logic is
	generic(
		-- Bus protocol parameters, do not add to or delete
		C_DWIDTH                       : integer              := 32;
		C_NUM_CE                       : integer              := 4
		-- DO NOT EDIT ABOVE THIS LINE ---------------------
  );
	port(
		-- ADD USER PORTS BELOW THIS LINE ------------------
		clk_19					:in  std_logic;   
		clk_1_25				:in  std_logic;
		tact						:out std_logic_vector(15 downto 0);
		discr						:out std_logic_vector(15 downto 0);
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
  );

  attribute SIGIS : string;
  attribute SIGIS of Bus2IP_Clk    : signal is "CLK";
  attribute SIGIS of Bus2IP_Reset  : signal is "RST";

end entity user_logic;

architecture IMP of user_logic is

  --USER signal declarations added here, as needed for user logic
component grid_gen_rvg
	Port (
		rst						: in  STD_LOGIC;
		clk						: in  STD_LOGIC;
		clk_19				: in  STD_LOGIC;
		clk_1_25			: in  STD_LOGIC;
		tact_ppc_en		: in  STD_LOGIC;
		tact_ppc			: in  STD_LOGIC_VECTOR (15 downto 0);
		tact					: out  STD_LOGIC_VECTOR (15 downto 0);
		discr					: out  STD_LOGIC_VECTOR (15 downto 0)
	);
end component;
  ------------------------------------------
  -- Signals for user logic slave model s/w accessible register example
  ------------------------------------------
  signal REG_TAKT_NUMBER			   : std_logic_vector(C_DWIDTH-1 downto 0);
  signal TAKT_NUMBER_UPDATE			   : std_logic:= '0';
  signal iTAKT_NUMBER			   	   : std_logic_vector(31 downto 0):= (others => '0');
  signal slv_reg_write_select           : std_logic_vector(0 to 3);
  signal slv_reg_read_select            : std_logic_vector(0 to 3);
  signal slv_ip2bus_data                : std_logic_vector(0 to C_DWIDTH-1);
  signal slv_read_ack                   : std_logic;
  signal slv_write_ack                  : std_logic;

begin

  slv_reg_write_select <= Bus2IP_WrCE(0 to 3);
  slv_reg_read_select  <= Bus2IP_RdCE(0 to 3);
  slv_write_ack        <= Bus2IP_WrCE(0) or Bus2IP_WrCE(1) or Bus2IP_WrCE(2) or Bus2IP_WrCE(3);
  slv_read_ack         <= Bus2IP_RdCE(0) or Bus2IP_RdCE(1) or Bus2IP_RdCE(2) or Bus2IP_RdCE(3);

  -- implement slave model register(s)
  SLAVE_REG_WRITE_PROC : process( Bus2IP_Clk ) is
  begin

   if Bus2IP_Clk'event and Bus2IP_Clk = '1' then
			if Bus2IP_Reset = '1' then
			  REG_TAKT_NUMBER <= (others => '0');
			  TAKT_NUMBER_UPDATE<= '1';
			else
			  case slv_reg_write_select is
				 when "0010" =>
						 REG_TAKT_NUMBER <= Bus2IP_Data;
						 TAKT_NUMBER_UPDATE <= '1';
				 when others => 
						 TAKT_NUMBER_UPDATE <= '0';
			  end case;
			end if;
    end if;

  end process SLAVE_REG_WRITE_PROC;

  -- implement slave model register read mux
  SLAVE_REG_READ_PROC : process( slv_reg_read_select, REG_TAKT_NUMBER, iTAKT_NUMBER ) is
  begin

    case slv_reg_read_select is
      when "1000" => slv_ip2bus_data <= x"71827368"; -- ASCII "GRID"
      when "0100" => slv_ip2bus_data <= x"14060300";
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

Grid_Gen_inst: grid_gen_rvg
	port map(
		rst => Bus2IP_Reset,
		clk => Bus2IP_Clk,
		clk_19 => clk_19,
		clk_1_25 => clk_1_25,
		tact_ppc_en => TAKT_NUMBER_UPDATE,
		tact_ppc => REG_TAKT_NUMBER(15 downto 0),
		tact => iTAKT_NUMBER(15 downto 0), 		
		discr => discr
	);

iTAKT_NUMBER(31 downto 16)	<= (others => '0');
tact <= iTAKT_NUMBER(15 downto 0);
end IMP;
