library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

--library UNISIM;
--use UNISIM.VComponents.all;

entity ft_fd_control is
	port(
		rst : in std_logic;
		clk : in std_logic;

		clk_19 : in std_logic;
		clk_10M : in std_logic;

		ft_edge : out std_logic;
		fd_edge : out std_logic;

		ft_ok : out std_logic;
		fd_ok : out std_logic
	);
end ft_fd_control;

architecture Behavioral of ft_fd_control is

	signal clk_19_t : std_logic := '0';
	signal clk_19_tt : std_logic := '0';
	signal clk_10M_t : std_logic := '0';
	signal clk_10M_tt : std_logic := '0';

	signal fd_ring : std_logic_vector(7 downto 0) := (others => '0');

	constant ft_ratio : integer := 5263157; -- 100M/19
	constant ft_ratio_max : integer := 6315789; -- +20%
	constant ft_ratio_min : integer := 4210526; -- -20%

	constant fd_ratio : integer := 10; -- 100M/10M
	constant fd_ratio_max : integer := 12; -- +20%
	constant fd_ratio_min : integer := 8; -- -20%

	signal ft_cnt : integer range 0 to ft_ratio_max;
	signal ft_cnt_reg : integer range 0 to ft_ratio_max;
	signal fd_cnt : integer range 0 to fd_ratio_max;
	signal fd_cnt_reg : integer range 0 to fd_ratio_max;


begin

	ft_proc: process(clk)
	begin
		if (clk'event and clk = '1') then
			clk_19_t <= clk_19;
			clk_19_tt <= clk_19_t;
			ft_edge <= clk_19_t and not clk_19_tt;
		end if;
	end process;

	front_10M : process(clk)
	begin
		if (clk'event and clk = '1') then
			clk_10M_t <= clk_10M;
			clk_10M_tt <= clk_10M_t;
		end if;
	end process;

	ring_10M : process(clk)
	begin
		if (clk'event and clk = '1') then
			if ((clk_19_t = '1') and (clk_19_tt) = '0') then
				fd_ring <= x"02";
			elsif ((clk_10M_t = '1') and (clk_10M_tt) = '0') then
				fd_ring <= fd_ring(6 downto 0) & fd_ring(7);
			else
				fd_ring <= fd_ring;
			end if;
		end if;
	end process;

	fd_proc : process(clk)
	begin
		if (clk'event and clk = '1') then
			fd_edge <= fd_ring(0) and (clk_10M_t and not clk_10M_tt);
		end if;
	end process;

	----------------------------------------------------------------------
	ft_ok_proc : process(clk)
	begin
		if (clk'event and clk = '1') then
			if (clk_19_t = '1' and clk_19_tt = '0') then
				ft_cnt <= 1;
				ft_cnt_reg <= ft_cnt;
			elsif (ft_cnt = ft_ratio_max) then
				ft_cnt <= ft_cnt;
				ft_cnt_reg <= ft_cnt;
			else
				ft_cnt <= ft_cnt + 1;
			end if;

			if (ft_cnt_reg > ft_ratio_min and ft_cnt_reg < ft_ratio_max) then
				ft_ok <= '1';
			else
				ft_ok <= '0';
			end if;
		end if;
	end process;

	fd_ok_proc : process(clk)
	begin
		if (clk'event and clk = '1') then
			if (clk_10M_t = '1' and clk_10M_tt = '0') then
				fd_cnt <= 1;
				fd_cnt_reg <= fd_cnt;
			elsif (fd_cnt = fd_ratio_max) then
				fd_cnt <= fd_cnt;
				fd_cnt_reg <= fd_cnt;
			else
				fd_cnt <= fd_cnt + 1;
			end if;

			if (fd_cnt_reg > fd_ratio_min and fd_cnt_reg < fd_ratio_max) then
				fd_ok <= '1';
			else
				fd_ok <= '0';
			end if;
		end if;
	end process;

end Behavioral;