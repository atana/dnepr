library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ring is
	Port( 
		clk : in std_logic;
		rst : in std_logic;

		DIN : in std_logic_vector (63 downto 0);
		WE : in std_logic;

		RE : in std_logic;
		DOUT : out std_logic_vector (63 downto 0);
		EMPTY : out std_logic
	);
end ring;

architecture Behavioral of ring is

type array_type is array (3 downto 0) of std_logic_vector (63 downto 0);
signal ring_buf: array_type;

signal write_point : std_logic_vector(1 downto 0) := "00";
signal read_point : std_logic_vector(1 downto 0) := "00";
signal amount : std_logic_vector(2 downto 0) := "000";

begin

	write_proc : process(clk)
	begin
		if (clk'event and clk = '1') then
			if (rst = '1') then
				for i in 0 to 3 loop
					ring_buf(i) <= (others => '0');
				end loop;
				write_point <= "00";
			elsif (WE = '1' and conv_integer(amount) < 4) then
				ring_buf(conv_integer(write_point)) <= DIN;
				write_point <= write_point + '1';
			end if;
		end if;
	end process;

	read_proc : process(clk)
	begin
		if (clk'event and clk = '1') then
			if (rst = '1') then
				DOUT <= (others => '0');
				read_point <= "00";
			elsif (RE = '1' and conv_integer(amount) > 0) then
				DOUT <= ring_buf(conv_integer(read_point));
				read_point <= read_point + '1';
			end if;
		end if;
	end process;

	word_counter : process(clk)
	begin
		if (clk'event and clk = '1') then
			if (rst = '1') then
				amount <= "000";
			elsif (WE = '1' and RE = '1') then
				amount <= amount;
			elsif (WE = '1' and conv_integer(amount) < 4) then
				amount <= amount + '1';
			elsif (RE = '1' and conv_integer(amount) > 0) then
				amount <= amount - '1';
			else
				amount <= amount;
			end if;
		end if;
	end process;

	EMPTY <= '1' when (amount = 0) else '0';


end Behavioral;

