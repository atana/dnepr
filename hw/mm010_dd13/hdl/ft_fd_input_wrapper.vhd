-------------------------------------------------------------------------------
-- ft_fd_input_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library ft_fd_control_v1_00_b;
use ft_fd_control_v1_00_b.all;

entity ft_fd_input_wrapper is
  port (
    rst : in std_logic;
    clk : in std_logic;
    clk_19 : in std_logic;
    clk_10M : in std_logic;
    ft_edge : out std_logic;
    fd_edge : out std_logic;
    ft_int : out std_logic;
    ft_ok : out std_logic;
    fd_ok : out std_logic
  );

  attribute x_core_info : STRING;
  attribute x_core_info of ft_fd_input_wrapper : entity is "ft_fd_control_v1_00_b";

end ft_fd_input_wrapper;

architecture STRUCTURE of ft_fd_input_wrapper is

  component ft_fd_control is
    port (
      rst : in std_logic;
      clk : in std_logic;
      clk_19 : in std_logic;
      clk_10M : in std_logic;
      ft_edge : out std_logic;
      fd_edge : out std_logic;
      ft_int : out std_logic;
      ft_ok : out std_logic;
      fd_ok : out std_logic
    );
  end component;

begin

  ft_fd_input : ft_fd_control
    port map (
      rst => rst,
      clk => clk,
      clk_19 => clk_19,
      clk_10M => clk_10M,
      ft_edge => ft_edge,
      fd_edge => fd_edge,
      ft_int => ft_int,
      ft_ok => ft_ok,
      fd_ok => fd_ok
    );

end architecture STRUCTURE;

