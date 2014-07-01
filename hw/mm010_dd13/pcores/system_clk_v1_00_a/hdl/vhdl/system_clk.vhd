library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- pragma translate_off
library unisim;
use unisim.all;
-- pragma translate_on

entity system_clk is
	Port(
		clk_in_p	: in	std_logic;
		clk_in_n	: in	std_logic;
		clk_out			: out	std_logic;
		LEDS_OPB_GPIO 	: out	std_logic_vector(0 to 2);
		J51_ZOUT			: out	std_logic_vector(0 to 32);
		RX			: in	std_logic;
		TX			: out	std_logic;
		PPCI_SYS_IN	: in	std_logic_vector(0 to 28);
		PPCI_AD_IN	: in	std_logic_vector(0 to 20);
		PPCI_SYS_1_ren	: out	std_logic;
		PPCI_SYS_2_ren	: out	std_logic;
		PPCI_AD_5_ren	: out	std_logic
		);
end;

architecture arch_system_clk of system_clk is

	component ibufgds_lvpecl_25
	port(	I	: in	std_logic;
			IB	: in	std_logic;
			O	: out	std_logic);
	end component;

--	component BUFG
--			port (I : in STD_LOGIC; O : out std_logic);
--	end component;

	signal clk_i				: std_logic;	
	signal count				: std_logic_vector(28 downto 0)	:= (others => '0');
	signal J51_ZOUT_net		: std_logic_vector(0 to 32)		:= (others => '0');

begin

	-- --------------------------
	-- Primary ECL clock buffer -
	-- --------------------------
	ecl_clk_ibufg: ibufgds_lvpecl_25
 --    ecl_clk_ibufg: ibufds
	port map(I	=>	clk_in_p,
		    IB	=>	clk_in_n,
		    O	=>	clk_i);
	-- ------
	-- BUFG -
	-- ------
--	CLK_BUFG:	BUFG	port	map(I	=>	clk_i, O => clk_out);
	clk_out	<= clk_i;

	clk_i_proc:	process (clk_i)
	begin
		if (clk_i'event and clk_i = '1') then
			count <= count + 1;
		else
			count <= count;
		end if;
	end process;
		
	LEDS_OPB_GPIO(0) <= count(26);
	LEDS_OPB_GPIO(1) <= count(25);
	LEDS_OPB_GPIO(2) <= '1';
	
--	PPCI_SYS_1_proc:	process (clk_i)
--	begin
--		if (clk_i'event and clk_i = '1') then	
--			J51_ZOUT_net		<= b"111111111111111111111111111111111";		-- b"000000000000000000000000000000000";
--		else
--			J51_ZOUT_net		<= J51_ZOUT_net;
--		end if;
--	end process;			
--
--	J51_ZOUT <= J51_ZOUT_net;
--
--	PPCI_SYS_1_proc:	process (clk_i)
--	begin
--		if (clk_i'event and clk_i = '1') then	
--			if (PPCI_SYS_IN(1) = '1') then PPCI_SYS_1_ren	<= '1'; 
--			else PPCI_SYS_1_ren	<= '0';	
----		else PPCI_SYS_1_ren	<= PPCI_SYS_1_ren;
--		end if;
--	end process;
--	
--	PPCI_SYS_2_proc:	process (clk_i)
--	begin
--		if (clk_i'event and clk_i = '1') then	
--			if (PPCI_SYS_IN(2) = '1') then PPCI_SYS_2_ren	<= '1';
--			else PPCI_SYS_2_ren	<= '0';	
--		else PPCI_SYS_2_ren	<= PPCI_SYS_2_ren;
--		end if;
--	end process;
--	
--	PPCI_AD_5_proc:	process (clk_i)
--	begin
--		if (clk_i'event and clk_i = '1') then	
--			if (PPCI_AD_IN(5) = '1') then PPCI_AD_5_ren	<= '1';
--			else PPCI_AD_5_ren	<= '0';	
--		else PPCI_AD_5_ren	<= PPCI_AD_5_ren;
--		end if;
--	end process;

	J51_ZOUT		<= b"000000000000000000000000000000000";	-- b"111111111111111111111111111111111";

--	PPCI_SYS		<= PPCI_SYS_IN;	
--	PPCI_AD	   <= PPCI_AD_IN;
	PPCI_SYS_1_ren	<= '1' when PPCI_SYS_IN(1) = '1' else '0';	
	PPCI_SYS_2_ren	<= '1' when PPCI_SYS_IN(2) = '1' else '0';
	PPCI_AD_5_ren	<=	'1' when PPCI_AD_IN(5) = '1' else '0';
	
end arch_system_clk;
