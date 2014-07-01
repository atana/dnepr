LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
 
ENTITY tb_ring IS
END tb_ring;
 
ARCHITECTURE behavior OF tb_ring IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT ring
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         DIN : IN  std_logic_vector(63 downto 0);
         WE : IN  std_logic;
         RE : IN  std_logic;
         DOUT : OUT  std_logic_vector(63 downto 0);
         EMPTY : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal DIN : std_logic_vector(63 downto 0) := (others => '0');
   signal WE : std_logic := '0';
   signal RE : std_logic := '0';

 	--Outputs
   signal DOUT : std_logic_vector(63 downto 0);
   signal EMPTY : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: ring PORT MAP (
          clk => clk,
          rst => rst,
          DIN => DIN,
          WE => WE,
          RE => RE,
          DOUT => DOUT,
          EMPTY => EMPTY
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
stim_proc: process
begin		
	rst <= '1';
	wait for 100 ns;	
	rst <= '0';
	wait for 100 ns;
	
	wait for 2 ns;
	
	DIN <= x"0000000000000001";
	WE <= '1';
	wait for 10 ns;
	DIN <= x"0000000000000000";
	WE <= '0';
	wait for 10 ns;
	
	wait for 100 ns;
	
	RE <= '1';
	wait for 10 ns;
	RE <= '0';
	wait for 10 ns;
	
	wait for 100 ns;
	
	DIN <= x"0000000000000002";
	WE <= '1';
	wait for 10 ns;
	DIN <= x"0000000000000000";
	WE <= '0';
	wait for 10 ns;
	DIN <= x"0000000000000003";
	WE <= '1';
	wait for 10 ns;
	DIN <= x"0000000000000000";
	WE <= '0';
	wait for 10 ns;
	DIN <= x"0000000000000004";
	WE <= '1';
	wait for 10 ns;
	DIN <= x"0000000000000000";
	WE <= '0';
	wait for 10 ns;
	DIN <= x"0000000000000005";
	WE <= '1';
	wait for 10 ns;
	DIN <= x"0000000000000000";
	WE <= '0';
	wait for 10 ns;
	DIN <= x"0000000000000006";
	WE <= '1';
	wait for 10 ns;
	DIN <= x"0000000000000000";
	WE <= '0';
	wait for 10 ns;
	DIN <= x"0000000000000007";
	WE <= '1';
	wait for 10 ns;
	DIN <= x"0000000000000000";
	WE <= '0';
	wait for 10 ns;
	
	wait for 100 ns;
	
	RE <= '1';
	wait for 10 ns;
	RE <= '0';
	wait for 10 ns;
	RE <= '1';
	wait for 10 ns;
	RE <= '0';
	wait for 10 ns;
	RE <= '1';
	wait for 10 ns;
	RE <= '0';
	wait for 10 ns;
	RE <= '1';
	wait for 10 ns;
	RE <= '0';
	wait for 10 ns;
	RE <= '1';
	wait for 10 ns;
	RE <= '0';
	wait for 10 ns;
	RE <= '1';
	wait for 10 ns;
	RE <= '0';
	wait for 10 ns;
	RE <= '1';
	wait for 10 ns;
	RE <= '0';
	wait for 10 ns;
	
	wait for 100 ns;
	
	DIN <= x"0000000000000008";
	WE <= '1';
	wait for 10 ns;
	DIN <= x"0000000000000000";
	WE <= '0';
	wait for 10 ns;
	DIN <= x"0000000000000009";
	WE <= '1';
	wait for 10 ns;
	DIN <= x"0000000000000000";
	WE <= '0';
	wait for 10 ns;
	
	wait for 100 ns;
	
	RE <= '1';
	wait for 10 ns;
	RE <= '0';
	wait for 10 ns;
	RE <= '1';
	wait for 10 ns;
	RE <= '0';
	wait for 10 ns;
	RE <= '1';
	wait for 10 ns;
	RE <= '0';
	wait for 10 ns;
	
	wait for 100 ns;
	
	DIN <= x"000000000000000A";
	WE <= '1';
	wait for 10 ns;
	DIN <= x"0000000000000000";
	WE <= '0';
	wait for 10 ns;
	DIN <= x"000000000000000B";
	WE <= '1';
	RE <= '1';
	wait for 10 ns;
	DIN <= x"0000000000000000";
	WE <= '0';
	RE <= '0';
	wait for 10 ns;
	
	RE <= '1';
	wait for 10 ns;
	RE <= '0';
	wait for 10 ns;
	
	wait;
end process;

END;
