-------------------------------------------------------------------------------
-- system_clk_0_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library system_clk_v1_00_a;
use system_clk_v1_00_a.all;

entity system_clk_0_wrapper is
  port (
    clk_in_p : in std_logic;
    clk_in_n : in std_logic;
    clk_out : out std_logic;
    LEDS_OPB_GPIO : out std_logic_vector(0 to 2);
    J51_ZOUT : out std_logic_vector(0 to 32);
    RX : in std_logic;
    TX : out std_logic;
    PPCI_SYS_1_ren : out std_logic;
    PPCI_SYS_2_ren : out std_logic;
    PPCI_AD_5_ren : out std_logic;
    PPCI_SYS_IN : in std_logic_vector(0 to 28);
    PPCI_AD_IN : in std_logic_vector(0 to 20)
  );

  attribute x_core_info : STRING;
  attribute x_core_info of system_clk_0_wrapper : entity is "system_clk_v1_00_a";

end system_clk_0_wrapper;

architecture STRUCTURE of system_clk_0_wrapper is

  component system_clk is
    port (
      clk_in_p : in std_logic;
      clk_in_n : in std_logic;
      clk_out : out std_logic;
      LEDS_OPB_GPIO : out std_logic_vector(0 to 2);
      J51_ZOUT : out std_logic_vector(0 to 32);
      RX : in std_logic;
      TX : out std_logic;
      PPCI_SYS_1_ren : out std_logic;
      PPCI_SYS_2_ren : out std_logic;
      PPCI_AD_5_ren : out std_logic;
      PPCI_SYS_IN : in std_logic_vector(0 to 28);
      PPCI_AD_IN : in std_logic_vector(0 to 20)
    );
  end component;

begin

  system_clk_0 : system_clk
    port map (
      clk_in_p => clk_in_p,
      clk_in_n => clk_in_n,
      clk_out => clk_out,
      LEDS_OPB_GPIO => LEDS_OPB_GPIO,
      J51_ZOUT => J51_ZOUT,
      RX => RX,
      TX => TX,
      PPCI_SYS_1_ren => PPCI_SYS_1_ren,
      PPCI_SYS_2_ren => PPCI_SYS_2_ren,
      PPCI_AD_5_ren => PPCI_AD_5_ren,
      PPCI_SYS_IN => PPCI_SYS_IN,
      PPCI_AD_IN => PPCI_AD_IN
    );

end architecture STRUCTURE;

