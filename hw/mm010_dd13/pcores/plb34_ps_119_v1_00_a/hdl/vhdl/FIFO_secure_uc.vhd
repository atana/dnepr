-- ��������� ���������� ��� 6��-119
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

library UNISIM;
use UNISIM.VComponents.all;

entity FIFO_secure_uc is
	 Generic(
			FIFO_DEPTH: integer := 96; -- = 16x6x48 = 4608 (4,5Kbit) -- ������������ ���-�� ����, max 512x32bit = 16Kbit
			FIFO_STYLE: string := "BLOCK" -- "BLOCK" ��� "DISTRIBUTED"
			);
	 Port ( 

--			DTEST_rst		: in  STD_LOGIC;
			
			CLK 			: in  STD_LOGIC;
         RST 			: in  STD_LOGIC;
         
			FIFO_ENABLE : in STD_LOGIC;

			DIN 			: in  STD_LOGIC_VECTOR (47 downto 0):=(others => '0');
         WE 			: in  STD_LOGIC;
         wr_ack 		: out  STD_LOGIC;
         
			DOUT 			: out  STD_LOGIC_VECTOR (47 downto 0);
         RE 			: in  STD_LOGIC;
         valid 		: out  STD_LOGIC;
			FIFO_USE 	: out STD_LOGIC_VECTOR (6 downto 0);
         FULL 			: out  STD_LOGIC;
         EMPTY 		: out  STD_LOGIC
			);
end FIFO_secure_uc;

architecture Behavioral of FIFO_secure_uc is

type RAM_type is array (127 downto 0) of std_logic_vector (47 downto 0); -- ����������� ����� ����� ������ Virtex4
signal RAM: RAM_type;
attribute RAM_STYLE : string;
attribute RAM_STYLE of RAM: signal is FIFO_STYLE;

signal wr_address: std_logic_vector (6 downto 0); -- 2**14 = 16384 -- ��������� ������ ������
signal rd_address: std_logic_vector (6 downto 0); -- 2**14 = 16384 -- ��������� ������ ������
--signal word_count: integer;
signal word_count: std_logic_vector (6 downto 0); -- ������� ������������ � FIFO ����

signal DOUT_in: std_logic_vector (47 downto 0); -- �������� ������ � ������� ������
signal valid_in : std_logic; -- ������������� ������ ���������� ������
signal wr_ack_in : std_logic; -- ������������� ������ ������������� ������

signal RE_secure : std_logic := '0';
signal RE_secure_next : std_logic := '0';

-- ��� CS -------------------------------------------------------------------------
--signal count_rd_address	: std_logic_vector (5 downto 0); 
--signal test_en				: std_logic; 
--signal DTEST				: std_logic_vector (47 downto 0); 
-- ��� CS -------------------------------------------------------------------------

begin
secure_re_proc : process(clk)
begin
FIFO_USE <= word_count;
	if clk'event and clk='1' then
		if rst='1' then
			RE_secure <= '0';
			RE_secure_next <= '0';
		else
			if RE='1' and WE='0' then
				RE_secure <= '1';
				RE_secure_next <= '0';
			elsif RE='1' and WE='1' then
				RE_secure <= '0';
				RE_secure_next <= '1';
			else
				RE_secure <= RE_secure_next;
				RE_secure_next <= '0';
			end if;
		end if;
	end if;
end process;
----------------------------- ������/������ ������ --------------------------------
process (CLK) -- Block RAM, 1 CLK, 1 Write port, 1 Read port
begin
   if (CLK'event and CLK = '1') then
 		if (RST = '1') then	
			DOUT_in <= (others => '0');
		else 
			DOUT_in <= RAM(conv_integer(rd_address));
		end if;
		
		if (FIFO_ENABLE = '1' and WE = '1' and conv_integer(word_count) /= FIFO_DEPTH) then
--		elsif (FIFO_ENABLE = '1' and WE = '1' and conv_integer(word_count) /= FIFO_DEPTH) then
				RAM(conv_integer(wr_address)) <= DIN;
		end if;
   end if;
end process;
-----------------------------------------------------------------------------------

--begin ��� CS -------------------------------------------------------------------------
--process (CLK)
--begin
--   if (CLK'event and CLK = '1') then
-- 		if (RST = '1' or DTEST_rst = '1') then
--			count_rd_address <= (others => '0');
--			test_en <= '0';
--		elsif (count_rd_address <= 30) then
--			count_rd_address <= count_rd_address + '1';
--			test_en <= '1';
--		end if;
--	end if;
--end process;
--
--process (CLK)
--begin
--   if (CLK'event and CLK = '1') then
-- 		if (RST = '1' or DTEST_rst = '1') then	
--			DTEST <= (others => '0');		
--		elsif (test_en = '0') then
--			DTEST <= RAM(conv_integer(count_rd_address));
--		else
--			DTEST <= DTEST;
--		end if;
--   end if;
--end process;

--end ��� CS -------------------------------------------------------------------------

---------- ������������� ������/������ ------------------
process (CLK)
begin
	if (CLK'event and CLK = '1') then
		if (FIFO_ENABLE = '1') then

			if (RE_secure = '1' and conv_integer(word_count) /= 0) then
				valid_in <= '1';
			else
				valid_in <= '0';
			end if;
			
			if (WE = '1' and conv_integer(word_count) /= FIFO_DEPTH) then
				wr_ack_in <= '1';
			else	
				wr_ack_in <= '0';
			end if;

		else
			valid_in <= '0';
			wr_ack_in <= '0';
		end if;
	end if;
end process;

process (CLK) -- �������� �� ��������
begin
if (CLK'event and CLK = '0') then
	valid <= valid_in;
	wr_ack <= wr_ack_in;
end if;
end process;
-------------------------------------------------------------------------

------------- ����� ������ ---------
process (CLK)
begin
	if (CLK'event and CLK = '1') then
		if 	(RST = '1') 			then 	
			DOUT <= (others => '0');
		else
			if (FIFO_ENABLE = '1') 	then 	
				DOUT <= DOUT_in;
			else 										
				DOUT <= (others => '0');
			end if;
		end if;
	end if;
end process;
-------------------------------------


----------- ������� ����, ������������ � FIFO -------
process(CLK)
begin
if (CLK'event and CLK = '1') then
	if (RST = '1') then
		word_count <= (others => '0');
	elsif (WE = '1' and conv_integer(word_count) /= FIFO_DEPTH) then
		word_count <= word_count + '1';
	elsif (RE_secure = '1' and conv_integer(word_count) /= 0) then
		word_count <= word_count - '1';
	else
		word_count <= word_count;
	end if;
end if;
end process;
------------------------------------------------------


-------------- �������� ������� ������/������ --------
process (CLK)
begin
if (CLK'event and CLK = '1') then
	if (RST = '1') then -- or word_count = 0
		wr_address <= (others => '0');
	elsif (WE = '1' and conv_integer(word_count) /= FIFO_DEPTH) then
		if (conv_integer(wr_address) = FIFO_DEPTH) then
			wr_address <= (others => '0');
		else
			wr_address <= wr_address + '1';
		end if;
	else
		wr_address <= wr_address;
	end if;
end if;
end process;

process (CLK)
begin
if (CLK'event and CLK = '1') then
	if (RST = '1') then -- or word_count = 0
		rd_address <= (others => '0');
	elsif (RE_secure = '1' and  conv_integer(word_count) /= 0) then
		if (conv_integer(rd_address) = FIFO_DEPTH) then
			rd_address <= (others => '0');
		else
			rd_address <= rd_address + '1';
		end if;
	else
		rd_address <= rd_address;
	end if;
end if;
end process;
------------------------------------------------------

--------------- ����� ������/������ ----------------
process(CLK)
begin
if (CLK'event and CLK = '1') then
	if (conv_integer(word_count) = FIFO_DEPTH) then
		FULL <= '1';
	else
		FULL <= '0';
	end if;
	
	if (conv_integer(word_count) = 0) then
		EMPTY <= '1';
	else		
		EMPTY <= '0';
	end if;
end if;
end process;
----------------------------------------------------

end Behavioral;

