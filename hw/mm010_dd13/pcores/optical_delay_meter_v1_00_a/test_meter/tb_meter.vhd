LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;
USE ieee.numeric_std.ALL;
 
ENTITY tb_meter IS
END tb_meter;
 
ARCHITECTURE behavior OF tb_meter IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT meter
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         ft_edge : IN  std_logic;
         signal_in : IN  std_logic;
         signal_out : OUT  std_logic;
         delay : OUT  std_logic_vector(15 downto 0);
			status: out std_logic_vector(7 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal ft_edge : std_logic := '0';
   signal signal_in : std_logic := '0';

 	--Outputs
   signal signal_out : std_logic;
   signal delay : std_logic_vector(15 downto 0);
   signal status : std_logic_vector(7 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
   constant DELAY_TIME : time := 310 ns;
	
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: meter PORT MAP (
          clk => clk,
          rst => rst,
          ft_edge => ft_edge,
          signal_in => signal_in,
          signal_out => signal_out,
          delay => delay,
			 status => status
        );

   -- Clock process definitions
   clk_process: process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
	
	ft_process:  process
	begin
		ft_edge <= '0';
		wait for clk_period*100;
		ft_edge <= '1';
		wait for clk_period;
   end process;
	
--	signal_in_process: process
--	begin
		signal_in <= TRANSPORT signal_out after DELAY_TIME;
--		signal_in <= signal_out;
--	end process;
 

   -- Stimulus process
--   stim_proc: process
--   begin		
--      -- hold reset state for 100ms.
--      wait for 100 ns;	
--
--      wait for clk_period*10;
--
--      -- insert stimulus here 
--
--      wait;
--   end process;
--
END;
