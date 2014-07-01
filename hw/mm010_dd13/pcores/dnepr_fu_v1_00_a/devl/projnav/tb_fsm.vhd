LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
use IEEE.STD_LOGIC_ARITH.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY tb_fsm IS
END tb_fsm;
 
ARCHITECTURE behavior OF tb_fsm IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT fsm
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         tact : IN  std_logic_vector(15 downto 0);
         discr : IN  std_logic_vector(15 downto 0);
         optical_line_delay : IN  std_logic_vector(15 downto 0);
         outrun : IN  std_logic_vector(15 downto 0);
         Tstart : IN  std_logic_vector(15 downto 0);
         Dstart : IN  std_logic_vector(15 downto 0);
         Tstop : IN  std_logic_vector(15 downto 0);
         Dstop : IN  std_logic_vector(15 downto 0);
         EMPTY : IN  std_logic;
         RE : OUT  std_logic;
         start_pulse : OUT  std_logic;
         stop_pulse : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal tact : std_logic_vector(15 downto 0) := (others => '0');
   signal discr : std_logic_vector(15 downto 0) := (others => '0');
   signal optical_line_delay : std_logic_vector(15 downto 0) := (others => '0');
   signal outrun : std_logic_vector(15 downto 0) := (others => '0');
   signal Tstart : std_logic_vector(15 downto 0) := (others => '0');
   signal Dstart : std_logic_vector(15 downto 0) := (others => '0');
   signal Tstop : std_logic_vector(15 downto 0) := (others => '0');
   signal Dstop : std_logic_vector(15 downto 0) := (others => '0');
   signal EMPTY : std_logic := '0';

 	--Outputs
   signal RE : std_logic;
   signal start_pulse : std_logic;
   signal stop_pulse : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
	
	constant discr_period : time := 100 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: fsm PORT MAP (
          clk => clk,
          rst => rst,
          tact => tact,
          discr => discr,
          optical_line_delay => optical_line_delay,
          outrun => outrun,
          Tstart => Tstart,
          Dstart => Dstart,
          Tstop => Tstop,
          Dstop => Dstop,
          EMPTY => EMPTY,
          RE => RE,
          start_pulse => start_pulse,
          stop_pulse => stop_pulse
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
	
	discr_process :process
   begin
		discr <= conv_std_logic_vector(65520, 16);
		for i in 1 to 100 loop
			wait for discr_period;
			discr <= discr + '1';
		end loop;
   end process;

	tact_process :process
   begin
		tact <= conv_std_logic_vector(65535, 16);
		wait for 1600 ns;
		tact <= conv_std_logic_vector(0, 16);
		wait;
   end process;
	
	fu_process :process
   begin
		Tstart <= conv_std_logic_vector(65535, 16);
		Dstart <= conv_std_logic_vector(65534, 16);
		Tstop <= conv_std_logic_vector(0, 16);
		Dstop <= conv_std_logic_vector(2, 16);
		wait;
   end process;
 

-- Stimulus process
stim_proc: process
begin		
 rst <= '1';
 wait for 100 ns;
 rst <= '0';
 
 
	wait;
end process;

END;
