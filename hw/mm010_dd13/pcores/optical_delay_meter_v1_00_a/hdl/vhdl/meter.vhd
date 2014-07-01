library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity meter is
  generic (
    code : std_logic_vector(11 downto 0) := ("001100111100")
  );
  port (
    clk : in std_logic;
    rst : in std_logic;

    ft_edge       : in std_logic;
    signal_in     : in std_logic;
    signal_out    : out std_logic;
    delay         : out std_logic_vector(15 downto 0);
	 
    status        : out std_logic_vector(7 downto 0)
  );

end entity meter;

architecture IMP of meter is

  signal tr_buf       : std_logic_vector(11 downto 0) := (others => '0');
  signal rc_buf       : std_logic_vector(11 downto 0) := (others => '0');
  signal end_tr_buf   : std_logic_vector(11 downto 0) := (others => '0');
  signal end_tr       : std_logic := '0';
  signal rc_complete  : std_logic := '0';

  signal counter      : std_logic_vector(15 downto 0) := (others => '0');
  signal cnt          : std_logic_vector(15 downto 0) := (others => '0');

  signal state        : std_logic := '0'; -- 0 = stop, 1 = counting;
  signal timeout      : std_logic := '0';
  
  signal status_in    : std_logic_vector(7 downto 0) := (others => '0');

begin

generator: process(clk)
begin
  if (clk'event and clk = '1') then
    if (ft_edge = '1') then
      tr_buf <= code;
      end_tr_buf <= "000000000001";
    else
      tr_buf <= tr_buf(10 downto 0) & '0';
      end_tr_buf <= end_tr_buf(10 downto 0) & '0';
    end if ;
  end if ;
end process;

signal_out <= tr_buf(11);
end_tr <= end_tr_buf(11);

recognize: process(clk)
begin
  if (clk'event and clk = '1') then
    rc_buf <= rc_buf(10 downto 0) & signal_in;
  end if;
end process;
rc_complete <= '1' when (rc_buf = code) else '0';

fsm: process(clk)
begin
  if (clk'event and clk = '1') then
    case( state ) is
    
      when '0' =>
        if (end_tr = '1' and rc_complete = '0') then
          state <= '1';
        else
          state <= '0';			 
        end if ;

      when '1' =>
        if (rc_complete = '1') then
          state <= '0';
        elsif (timeout = '1') then
          state <= '0';
        end if ;
    
      when others =>
        state <= '0';
    
    end case ;
  end if ;
end process;

counting: process(clk)
begin
  if (clk'event and clk = '1') then
    if (state = '0') then
      counter <= x"0001";
    elsif (state = '1') then
        if (timeout = '0') then
          counter <= counter + '1';
        else
          counter <= counter;
        end if ;
    end if ;
  end if ;
end process;

--delay LTX-7225 300ns
--delay line = 6ns/meter
--SUM = (300*2 + 6*5000)*2 = 61200ns = 6120clk
timeout <= counter(13); --1<<13 = 8192clk

lock: process(clk)
begin
  if (clk'event and clk = '1') then
    if (rc_complete = '1' and state = '1') then
      cnt <= counter;
    else
      cnt <= cnt;
    end if ;
  end if ;
end process;

delay <= cnt;

status_proc: process(clk)
begin
  if (clk'event and clk = '1') then
    if (rst = '1') then
      status_in <= (others => '0');
    else
      if (rc_complete = '1' and state = '1') then
        status_in <= status_in(6 downto 0) & '1';
      elsif (timeout = '1') then
        status_in <= status_in(6 downto 0) & '0';
      else
        status_in <= status_in;
      end if ;
    end if ;
  end if ;
end process;
status <= status_in;

end IMP;
