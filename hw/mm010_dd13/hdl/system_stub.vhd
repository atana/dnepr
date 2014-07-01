-------------------------------------------------------------------------------
-- system_stub.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity system_stub is
  port (
    DDR_Addr : out std_logic_vector(0 to 12);
    DDR_BankAddr : out std_logic_vector(0 to 1);
    DDR_CASn : out std_logic;
    DDR_CKE : out std_logic;
    DDR_CLK_FB : in std_logic;
    DDR_CSn : out std_logic;
    DDR_Clk : out std_logic;
    DDR_Clkn : out std_logic;
    DDR_DM : out std_logic_vector(0 to 3);
    DDR_DQ : inout std_logic_vector(0 to 31);
    DDR_DQS : inout std_logic_vector(0 to 3);
    DDR_RASn : out std_logic;
    DDR_WEn : out std_logic;
    Eth1_PHY_Mii_clk : inout std_logic;
    Eth1_PHY_Mii_data : inout std_logic;
    Eth1_PHY_col : in std_logic;
    Eth1_PHY_crs : in std_logic;
    Eth1_PHY_dv : in std_logic;
    Eth1_PHY_rst_n : out std_logic;
    Eth1_PHY_rx_clk : in std_logic;
    Eth1_PHY_rx_data : in std_logic_vector(3 downto 0);
    Eth1_PHY_rx_er : in std_logic;
    Eth1_PHY_tx_clk : in std_logic;
    Eth1_PHY_tx_data : out std_logic_vector(3 downto 0);
    Eth1_PHY_tx_en : out std_logic;
    Eth1_PHY_tx_er : out std_logic;
    Eth2_PHY_Mii_clk : inout std_logic;
    Eth2_PHY_Mii_data : inout std_logic;
    Eth2_PHY_col : in std_logic;
    Eth2_PHY_crs : in std_logic;
    Eth2_PHY_dv : in std_logic;
    Eth2_PHY_rst_n : out std_logic;
    Eth2_PHY_rx_clk : in std_logic;
    Eth2_PHY_rx_data : in std_logic_vector(3 downto 0);
    Eth2_PHY_rx_er : in std_logic;
    Eth2_PHY_tx_clk : in std_logic;
    Eth2_PHY_tx_data : out std_logic_vector(3 downto 0);
    Eth2_PHY_tx_en : out std_logic;
    Eth2_PHY_tx_er : out std_logic;
    Flash_A : out std_logic_vector(0 to 31);
    Flash_CEN : out std_logic_vector(0 to 3);
    Flash_DQ : inout std_logic_vector(0 to 15);
    Flash_OEN : out std_logic;
    Flash_Rst : out std_logic;
    Flash_WEN : out std_logic;
    LVPECLK_n : in std_logic;
    LVPECLK_p : in std_logic;
    RS232_1_RX : in std_logic;
    RS232_1_TX : out std_logic;
    RS232_2_RX : in std_logic;
    RS232_2_TX : out std_logic;
    dnepr_RX : in std_logic;
    dnepr_TX : out std_logic;
    LEDS : out std_logic_vector(0 to 2);
    clk_19 : in std_logic;
    clk_10 : in std_logic;
    delay_out : out std_logic;
    delay_in : in std_logic;
    dnepr_dRC_stop_pin : out std_logic;
    dnepr_dRC_start_pin : out std_logic;
    dnepr_dTR_stop_pin : out std_logic;
    dnepr_dTR_start_pin : out std_logic;
    dnepr_RC_stop_pin : out std_logic;
    dnepr_RC_start_pin : out std_logic;
    dnepr_TR_stop_pin : out std_logic;
    dnepr_TR_start_pin : out std_logic
  );
end system_stub;

architecture STRUCTURE of system_stub is

  component system is
    port (
      DDR_Addr : out std_logic_vector(0 to 12);
      DDR_BankAddr : out std_logic_vector(0 to 1);
      DDR_CASn : out std_logic;
      DDR_CKE : out std_logic;
      DDR_CLK_FB : in std_logic;
      DDR_CSn : out std_logic;
      DDR_Clk : out std_logic;
      DDR_Clkn : out std_logic;
      DDR_DM : out std_logic_vector(0 to 3);
      DDR_DQ : inout std_logic_vector(0 to 31);
      DDR_DQS : inout std_logic_vector(0 to 3);
      DDR_RASn : out std_logic;
      DDR_WEn : out std_logic;
      Eth1_PHY_Mii_clk : inout std_logic;
      Eth1_PHY_Mii_data : inout std_logic;
      Eth1_PHY_col : in std_logic;
      Eth1_PHY_crs : in std_logic;
      Eth1_PHY_dv : in std_logic;
      Eth1_PHY_rst_n : out std_logic;
      Eth1_PHY_rx_clk : in std_logic;
      Eth1_PHY_rx_data : in std_logic_vector(3 downto 0);
      Eth1_PHY_rx_er : in std_logic;
      Eth1_PHY_tx_clk : in std_logic;
      Eth1_PHY_tx_data : out std_logic_vector(3 downto 0);
      Eth1_PHY_tx_en : out std_logic;
      Eth1_PHY_tx_er : out std_logic;
      Eth2_PHY_Mii_clk : inout std_logic;
      Eth2_PHY_Mii_data : inout std_logic;
      Eth2_PHY_col : in std_logic;
      Eth2_PHY_crs : in std_logic;
      Eth2_PHY_dv : in std_logic;
      Eth2_PHY_rst_n : out std_logic;
      Eth2_PHY_rx_clk : in std_logic;
      Eth2_PHY_rx_data : in std_logic_vector(3 downto 0);
      Eth2_PHY_rx_er : in std_logic;
      Eth2_PHY_tx_clk : in std_logic;
      Eth2_PHY_tx_data : out std_logic_vector(3 downto 0);
      Eth2_PHY_tx_en : out std_logic;
      Eth2_PHY_tx_er : out std_logic;
      Flash_A : out std_logic_vector(0 to 31);
      Flash_CEN : out std_logic_vector(0 to 3);
      Flash_DQ : inout std_logic_vector(0 to 15);
      Flash_OEN : out std_logic;
      Flash_Rst : out std_logic;
      Flash_WEN : out std_logic;
      LVPECLK_n : in std_logic;
      LVPECLK_p : in std_logic;
      RS232_1_RX : in std_logic;
      RS232_1_TX : out std_logic;
      RS232_2_RX : in std_logic;
      RS232_2_TX : out std_logic;
      dnepr_RX : in std_logic;
      dnepr_TX : out std_logic;
      LEDS : out std_logic_vector(0 to 2);
      clk_19 : in std_logic;
      clk_10 : in std_logic;
      delay_out : out std_logic;
      delay_in : in std_logic;
      dnepr_dRC_stop_pin : out std_logic;
      dnepr_dRC_start_pin : out std_logic;
      dnepr_dTR_stop_pin : out std_logic;
      dnepr_dTR_start_pin : out std_logic;
      dnepr_RC_stop_pin : out std_logic;
      dnepr_RC_start_pin : out std_logic;
      dnepr_TR_stop_pin : out std_logic;
      dnepr_TR_start_pin : out std_logic
    );
  end component;

begin

  system_i : system
    port map (
      DDR_Addr => DDR_Addr,
      DDR_BankAddr => DDR_BankAddr,
      DDR_CASn => DDR_CASn,
      DDR_CKE => DDR_CKE,
      DDR_CLK_FB => DDR_CLK_FB,
      DDR_CSn => DDR_CSn,
      DDR_Clk => DDR_Clk,
      DDR_Clkn => DDR_Clkn,
      DDR_DM => DDR_DM,
      DDR_DQ => DDR_DQ,
      DDR_DQS => DDR_DQS,
      DDR_RASn => DDR_RASn,
      DDR_WEn => DDR_WEn,
      Eth1_PHY_Mii_clk => Eth1_PHY_Mii_clk,
      Eth1_PHY_Mii_data => Eth1_PHY_Mii_data,
      Eth1_PHY_col => Eth1_PHY_col,
      Eth1_PHY_crs => Eth1_PHY_crs,
      Eth1_PHY_dv => Eth1_PHY_dv,
      Eth1_PHY_rst_n => Eth1_PHY_rst_n,
      Eth1_PHY_rx_clk => Eth1_PHY_rx_clk,
      Eth1_PHY_rx_data => Eth1_PHY_rx_data,
      Eth1_PHY_rx_er => Eth1_PHY_rx_er,
      Eth1_PHY_tx_clk => Eth1_PHY_tx_clk,
      Eth1_PHY_tx_data => Eth1_PHY_tx_data,
      Eth1_PHY_tx_en => Eth1_PHY_tx_en,
      Eth1_PHY_tx_er => Eth1_PHY_tx_er,
      Eth2_PHY_Mii_clk => Eth2_PHY_Mii_clk,
      Eth2_PHY_Mii_data => Eth2_PHY_Mii_data,
      Eth2_PHY_col => Eth2_PHY_col,
      Eth2_PHY_crs => Eth2_PHY_crs,
      Eth2_PHY_dv => Eth2_PHY_dv,
      Eth2_PHY_rst_n => Eth2_PHY_rst_n,
      Eth2_PHY_rx_clk => Eth2_PHY_rx_clk,
      Eth2_PHY_rx_data => Eth2_PHY_rx_data,
      Eth2_PHY_rx_er => Eth2_PHY_rx_er,
      Eth2_PHY_tx_clk => Eth2_PHY_tx_clk,
      Eth2_PHY_tx_data => Eth2_PHY_tx_data,
      Eth2_PHY_tx_en => Eth2_PHY_tx_en,
      Eth2_PHY_tx_er => Eth2_PHY_tx_er,
      Flash_A => Flash_A,
      Flash_CEN => Flash_CEN,
      Flash_DQ => Flash_DQ,
      Flash_OEN => Flash_OEN,
      Flash_Rst => Flash_Rst,
      Flash_WEN => Flash_WEN,
      LVPECLK_n => LVPECLK_n,
      LVPECLK_p => LVPECLK_p,
      RS232_1_RX => RS232_1_RX,
      RS232_1_TX => RS232_1_TX,
      RS232_2_RX => RS232_2_RX,
      RS232_2_TX => RS232_2_TX,
      dnepr_RX => dnepr_RX,
      dnepr_TX => dnepr_TX,
      LEDS => LEDS,
      clk_19 => clk_19,
      clk_10 => clk_10,
      delay_out => delay_out,
      delay_in => delay_in,
      dnepr_dRC_stop_pin => dnepr_dRC_stop_pin,
      dnepr_dRC_start_pin => dnepr_dRC_start_pin,
      dnepr_dTR_stop_pin => dnepr_dTR_stop_pin,
      dnepr_dTR_start_pin => dnepr_dTR_start_pin,
      dnepr_RC_stop_pin => dnepr_RC_stop_pin,
      dnepr_RC_start_pin => dnepr_RC_start_pin,
      dnepr_TR_stop_pin => dnepr_TR_stop_pin,
      dnepr_TR_start_pin => dnepr_TR_start_pin
    );

end architecture STRUCTURE;

