library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity core is
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
end core;

architecture Behavioral of core is

component ring
	Port( 
		clk : in std_logic;
		rst : in std_logic;

		DIN : in std_logic_vector (63 downto 0);
		WE : in std_logic;

		RE : in std_logic;
		DOUT : out std_logic_vector (63 downto 0);
		EMPTY : out std_logic
	);
end component;

component fsm
	Port(
		clk : in std_logic;
		rst : in std_logic;

		tact : in std_logic_vector(15 downto 0);
		discr : in std_logic_vector(15 downto 0);
		optical_line_delay : in std_logic_vector(15 downto 0);
		outrun : in std_logic_vector(15 downto 0);

		Tstart : in std_logic_vector(15 downto 0);
		Dstart : in std_logic_vector(15 downto 0);
		Tstop : in std_logic_vector(15 downto 0);
		Dstop : in std_logic_vector(15 downto 0);
		EMPTY : in std_logic;
		RE : out std_logic;

		start_pulse : out std_logic;
		stop_pulse : out std_logic
	);
end component;

	signal tr_ring_in : std_logic_vector (63 downto 0) := (others => '0');
	signal rc_ring_in : std_logic_vector (63 downto 0) := (others => '0');

	signal tr_ring_out : std_logic_vector (63 downto 0) := (others => '0');
	signal rc_ring_out : std_logic_vector (63 downto 0) := (others => '0');
	signal dtr_ring_out : std_logic_vector (63 downto 0) := (others => '0');
	signal drc_ring_out : std_logic_vector (63 downto 0) := (others => '0');

	signal tr_empty : std_logic := '0';
	signal rc_empty : std_logic := '0';
	signal dtr_empty : std_logic := '0';
	signal drc_empty : std_logic := '0';

	signal tr_re : std_logic := '0';
	signal rc_re : std_logic := '0';
	signal dtr_re : std_logic := '0';
	signal drc_re : std_logic := '0';

begin

	tr_ring_in <= TstartTR & DstartTR & TstopTR & DstopTR;
	rc_ring_in <= TstartRC & DstartRC & TstopRC & DstopRC;

	TR_ring: ring
	Port map( 
		clk => clk,
		rst => rst,

		DIN => tr_ring_in,
		WE => WTR,

		RE => tr_re,
		DOUT => tr_ring_out,
		EMPTY => tr_empty
	);

	RC_ring: ring
	Port map( 
		clk => clk,
		rst => rst,

		DIN => rc_ring_in,
		WE => WRC,

		RE => rc_re,
		DOUT => rc_ring_out,
		EMPTY => rc_empty
	);

	dTR_ring: ring
	Port map( 
		clk => clk,
		rst => rst,

		DIN => tr_ring_in,
		WE => WTR,

		RE => dtr_re,
		DOUT => dtr_ring_out,
		EMPTY => dtr_empty
	);

	dRC_ring: ring
	Port map( 
		clk => clk,
		rst => rst,

		DIN => rc_ring_in,
		WE => WRC,

		RE => drc_re,
		DOUT => drc_ring_out,
		EMPTY => drc_empty
	);
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------
	TR_fsm: fsm
	Port map(
		clk => clk,
		rst => rst,

		tact => tact,
		discr => discr,
		optical_line_delay => optical_line_delay,
		outrun => x"0000",

		Tstart => tr_ring_out(63 downto 48),
		Dstart => tr_ring_out(47 downto 32),
		Tstop => tr_ring_out(31 downto 16),
		Dstop => tr_ring_out(15 downto 0),
		EMPTY => tr_empty,
		RE => tr_re,

		start_pulse => TR_start,
		stop_pulse => TR_stop
	);

	RC_fsm: fsm
	Port map(
		clk => clk,
		rst => rst,

		tact => tact,
		discr => discr,
		optical_line_delay => optical_line_delay,
		outrun => x"0000",

		Tstart => rc_ring_out(63 downto 48),
		Dstart => rc_ring_out(47 downto 32),
		Tstop => rc_ring_out(31 downto 16),
		Dstop => rc_ring_out(15 downto 0),
		EMPTY => rc_empty,
		RE => rc_re,

		start_pulse => RC_start,
		stop_pulse => RC_stop
	);

	dTR_fsm: fsm
	Port map(
		clk => clk,
		rst => rst,

		tact => tact,
		discr => discr,
		optical_line_delay => optical_line_delay,
		outrun => outrun,

		Tstart => dtr_ring_out(63 downto 48),
		Dstart => dtr_ring_out(47 downto 32),
		Tstop => dtr_ring_out(31 downto 16),
		Dstop => dtr_ring_out(15 downto 0),
		EMPTY => dtr_empty,
		RE => dtr_re,

		start_pulse => dTR_start,
		stop_pulse => dTR_stop
	);

	dRC_fsm: fsm
	Port map(
		clk => clk,
		rst => rst,

		tact => tact,
		discr => discr,
		optical_line_delay => optical_line_delay,
		outrun => outrun,

		Tstart => drc_ring_out(63 downto 48),
		Dstart => drc_ring_out(47 downto 32),
		Tstop => drc_ring_out(31 downto 16),
		Dstop => drc_ring_out(15 downto 0),
		EMPTY => drc_empty,
		RE => drc_re,

		start_pulse => dRC_start,
		stop_pulse => dRC_stop
	);

end Behavioral;

