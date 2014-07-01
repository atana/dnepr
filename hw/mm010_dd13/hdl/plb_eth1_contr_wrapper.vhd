-------------------------------------------------------------------------------
-- plb_eth1_contr_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library plb_ethernet_v1_01_a;
use plb_ethernet_v1_01_a.all;

entity plb_eth1_contr_wrapper is
  port (
    PHY_tx_clk : in std_logic;
    PHY_rx_clk : in std_logic;
    PHY_crs : in std_logic;
    PHY_dv : in std_logic;
    PHY_rx_data : in std_logic_vector(3 downto 0);
    PHY_col : in std_logic;
    PHY_rx_er : in std_logic;
    PHY_tx_en : out std_logic;
    PHY_rx_en : out std_logic;
    PHY_tx_er : out std_logic;
    PHY_tx_data : out std_logic_vector(3 downto 0);
    PHY_rst_n : out std_logic;
    PLB_Clk : in std_logic;
    PLB_Rst : in std_logic;
    Freeze : in std_logic;
    IP2INTC_Irpt : out std_logic;
    PLB_ABus : in std_logic_vector(0 to 31);
    PLB_PAValid : in std_logic;
    PLB_SAValid : in std_logic;
    PLB_rdPrim : in std_logic;
    PLB_wrPrim : in std_logic;
    PLB_masterID : in std_logic_vector(0 to 1);
    PLB_abort : in std_logic;
    PLB_busLock : in std_logic;
    PLB_RNW : in std_logic;
    PLB_BE : in std_logic_vector(0 to 7);
    PLB_MSize : in std_logic_vector(0 to 1);
    PLB_size : in std_logic_vector(0 to 3);
    PLB_type : in std_logic_vector(0 to 2);
    PLB_compress : in std_logic;
    PLB_guarded : in std_logic;
    PLB_ordered : in std_logic;
    PLB_lockErr : in std_logic;
    PLB_wrDBus : in std_logic_vector(0 to 63);
    PLB_wrBurst : in std_logic;
    PLB_rdBurst : in std_logic;
    PLB_pendReq : in std_logic;
    PLB_pendPri : in std_logic_vector(0 to 1);
    PLB_reqPri : in std_logic_vector(0 to 1);
    Sl_addrAck : out std_logic;
    Sl_SSize : out std_logic_vector(0 to 1);
    Sl_wait : out std_logic;
    Sl_rearbitrate : out std_logic;
    Sl_wrDAck : out std_logic;
    Sl_wrComp : out std_logic;
    Sl_wrBTerm : out std_logic;
    Sl_rdDBus : out std_logic_vector(0 to 63);
    Sl_rdWdAddr : out std_logic_vector(0 to 3);
    Sl_rdDAck : out std_logic;
    Sl_rdComp : out std_logic;
    Sl_rdBTerm : out std_logic;
    Sl_MBusy : out std_logic_vector(0 to 3);
    Sl_MErr : out std_logic_vector(0 to 3);
    PLB_MAddrAck : in std_logic;
    PLB_MSSize : in std_logic_vector(0 to 1);
    PLB_MRearbitrate : in std_logic;
    PLB_MBusy : in std_logic;
    PLB_MErr : in std_logic;
    PLB_MWrDAck : in std_logic;
    PLB_MRdDBus : in std_logic_vector(0 to 63);
    PLB_MRdWdAddr : in std_logic_vector(0 to 3);
    PLB_MRdDAck : in std_logic;
    PLB_MRdBTerm : in std_logic;
    PLB_MWrBTerm : in std_logic;
    M_request : out std_logic;
    M_priority : out std_logic_vector(0 to 1);
    M_buslock : out std_logic;
    M_RNW : out std_logic;
    M_BE : out std_logic_vector(0 to 7);
    M_MSize : out std_logic_vector(0 to 1);
    M_size : out std_logic_vector(0 to 3);
    M_type : out std_logic_vector(0 to 2);
    M_compress : out std_logic;
    M_guarded : out std_logic;
    M_ordered : out std_logic;
    M_lockErr : out std_logic;
    M_abort : out std_logic;
    M_ABus : out std_logic_vector(0 to 31);
    M_wrDBus : out std_logic_vector(0 to 63);
    M_wrBurst : out std_logic;
    M_rdBurst : out std_logic;
    PHY_Mii_clk_I : in std_logic;
    PHY_Mii_clk_O : out std_logic;
    PHY_Mii_clk_T : out std_logic;
    PHY_Mii_data_I : in std_logic;
    PHY_Mii_data_O : out std_logic;
    PHY_Mii_data_T : out std_logic
  );

  attribute x_core_info : STRING;
  attribute x_core_info of plb_eth1_contr_wrapper : entity is "plb_ethernet_v1_01_a";

end plb_eth1_contr_wrapper;

architecture STRUCTURE of plb_eth1_contr_wrapper is

  component plb_ethernet is
    generic (
      C_DEV_BLK_ID : INTEGER;
      C_PLB_CLK_PERIOD_PS : INTEGER;
      C_FAMILY : STRING;
      C_IPIF_FIFO_DEPTH : INTEGER;
      C_BASEADDR : std_logic_vector;
      C_HIGHADDR : std_logic_vector;
      C_DEV_MIR_ENABLE : INTEGER;
      C_RESET_PRESENT : INTEGER;
      C_INCLUDE_DEV_PENCODER : INTEGER;
      C_DMA_PRESENT : INTEGER;
      C_DMA_INTR_COALESCE : INTEGER;
      C_PLB_NUM_MASTERS : INTEGER;
      C_PLB_MID_WIDTH : INTEGER;
      C_PLB_AWIDTH : INTEGER;
      C_PLB_DWIDTH : INTEGER;
      C_MIIM_CLKDVD : std_logic_vector;
      C_SOURCE_ADDR_INSERT_EXIST : INTEGER;
      C_PAD_INSERT_EXIST : INTEGER;
      C_FCS_INSERT_EXIST : INTEGER;
      C_MAC_FIFO_DEPTH : INTEGER;
      C_HALF_DUPLEX_EXIST : INTEGER;
      C_ERR_COUNT_EXIST : INTEGER;
      C_MII_EXIST : INTEGER
    );
    port (
      PHY_tx_clk : in std_logic;
      PHY_rx_clk : in std_logic;
      PHY_crs : in std_logic;
      PHY_dv : in std_logic;
      PHY_rx_data : in std_logic_vector(3 downto 0);
      PHY_col : in std_logic;
      PHY_rx_er : in std_logic;
      PHY_tx_en : out std_logic;
      PHY_rx_en : out std_logic;
      PHY_tx_er : out std_logic;
      PHY_tx_data : out std_logic_vector(3 downto 0);
      PHY_rst_n : out std_logic;
      PLB_Clk : in std_logic;
      PLB_Rst : in std_logic;
      Freeze : in std_logic;
      IP2INTC_Irpt : out std_logic;
      PLB_ABus : in std_logic_vector(0 to (C_PLB_AWIDTH-1));
      PLB_PAValid : in std_logic;
      PLB_SAValid : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_wrPrim : in std_logic;
      PLB_masterID : in std_logic_vector(0 to (C_PLB_MID_WIDTH-1));
      PLB_abort : in std_logic;
      PLB_busLock : in std_logic;
      PLB_RNW : in std_logic;
      PLB_BE : in std_logic_vector(0 to ((C_PLB_DWIDTH/8)-1));
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_compress : in std_logic;
      PLB_guarded : in std_logic;
      PLB_ordered : in std_logic;
      PLB_lockErr : in std_logic;
      PLB_wrDBus : in std_logic_vector(0 to (C_PLB_DWIDTH-1));
      PLB_wrBurst : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_pendReq : in std_logic;
      PLB_pendPri : in std_logic_vector(0 to 1);
      PLB_reqPri : in std_logic_vector(0 to 1);
      Sl_addrAck : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_rearbitrate : out std_logic;
      Sl_wrDAck : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_wrBTerm : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to (C_PLB_DWIDTH-1));
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rdDAck : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_rdBTerm : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to (C_PLB_NUM_MASTERS-1));
      Sl_MErr : out std_logic_vector(0 to (C_PLB_NUM_MASTERS-1));
      PLB_MAddrAck : in std_logic;
      PLB_MSSize : in std_logic_vector(0 to 1);
      PLB_MRearbitrate : in std_logic;
      PLB_MBusy : in std_logic;
      PLB_MErr : in std_logic;
      PLB_MWrDAck : in std_logic;
      PLB_MRdDBus : in std_logic_vector(0 to (C_PLB_DWIDTH-1));
      PLB_MRdWdAddr : in std_logic_vector(0 to 3);
      PLB_MRdDAck : in std_logic;
      PLB_MRdBTerm : in std_logic;
      PLB_MWrBTerm : in std_logic;
      M_request : out std_logic;
      M_priority : out std_logic_vector(0 to 1);
      M_buslock : out std_logic;
      M_RNW : out std_logic;
      M_BE : out std_logic_vector(0 to ((C_PLB_DWIDTH/8)-1));
      M_MSize : out std_logic_vector(0 to 1);
      M_size : out std_logic_vector(0 to 3);
      M_type : out std_logic_vector(0 to 2);
      M_compress : out std_logic;
      M_guarded : out std_logic;
      M_ordered : out std_logic;
      M_lockErr : out std_logic;
      M_abort : out std_logic;
      M_ABus : out std_logic_vector(0 to (C_PLB_AWIDTH-1));
      M_wrDBus : out std_logic_vector(0 to (C_PLB_DWIDTH-1));
      M_wrBurst : out std_logic;
      M_rdBurst : out std_logic;
      PHY_Mii_clk_I : in std_logic;
      PHY_Mii_clk_O : out std_logic;
      PHY_Mii_clk_T : out std_logic;
      PHY_Mii_data_I : in std_logic;
      PHY_Mii_data_O : out std_logic;
      PHY_Mii_data_T : out std_logic
    );
  end component;

begin

  plb_eth1_contr : plb_ethernet
    generic map (
      C_DEV_BLK_ID => 0,
      C_PLB_CLK_PERIOD_PS => 10000,
      C_FAMILY => "virtex2p",
      C_IPIF_FIFO_DEPTH => 131072,
      C_BASEADDR => X"0A000000",
      C_HIGHADDR => X"0A00FFFF",
      C_DEV_MIR_ENABLE => 1,
      C_RESET_PRESENT => 1,
      C_INCLUDE_DEV_PENCODER => 1,
      C_DMA_PRESENT => 3,
      C_DMA_INTR_COALESCE => 1,
      C_PLB_NUM_MASTERS => 4,
      C_PLB_MID_WIDTH => 2,
      C_PLB_AWIDTH => 32,
      C_PLB_DWIDTH => 64,
      C_MIIM_CLKDVD => B"10011",
      C_SOURCE_ADDR_INSERT_EXIST => 1,
      C_PAD_INSERT_EXIST => 1,
      C_FCS_INSERT_EXIST => 1,
      C_MAC_FIFO_DEPTH => 64,
      C_HALF_DUPLEX_EXIST => 1,
      C_ERR_COUNT_EXIST => 1,
      C_MII_EXIST => 1
    )
    port map (
      PHY_tx_clk => PHY_tx_clk,
      PHY_rx_clk => PHY_rx_clk,
      PHY_crs => PHY_crs,
      PHY_dv => PHY_dv,
      PHY_rx_data => PHY_rx_data,
      PHY_col => PHY_col,
      PHY_rx_er => PHY_rx_er,
      PHY_tx_en => PHY_tx_en,
      PHY_rx_en => PHY_rx_en,
      PHY_tx_er => PHY_tx_er,
      PHY_tx_data => PHY_tx_data,
      PHY_rst_n => PHY_rst_n,
      PLB_Clk => PLB_Clk,
      PLB_Rst => PLB_Rst,
      Freeze => Freeze,
      IP2INTC_Irpt => IP2INTC_Irpt,
      PLB_ABus => PLB_ABus,
      PLB_PAValid => PLB_PAValid,
      PLB_SAValid => PLB_SAValid,
      PLB_rdPrim => PLB_rdPrim,
      PLB_wrPrim => PLB_wrPrim,
      PLB_masterID => PLB_masterID,
      PLB_abort => PLB_abort,
      PLB_busLock => PLB_busLock,
      PLB_RNW => PLB_RNW,
      PLB_BE => PLB_BE,
      PLB_MSize => PLB_MSize,
      PLB_size => PLB_size,
      PLB_type => PLB_type,
      PLB_compress => PLB_compress,
      PLB_guarded => PLB_guarded,
      PLB_ordered => PLB_ordered,
      PLB_lockErr => PLB_lockErr,
      PLB_wrDBus => PLB_wrDBus,
      PLB_wrBurst => PLB_wrBurst,
      PLB_rdBurst => PLB_rdBurst,
      PLB_pendReq => PLB_pendReq,
      PLB_pendPri => PLB_pendPri,
      PLB_reqPri => PLB_reqPri,
      Sl_addrAck => Sl_addrAck,
      Sl_SSize => Sl_SSize,
      Sl_wait => Sl_wait,
      Sl_rearbitrate => Sl_rearbitrate,
      Sl_wrDAck => Sl_wrDAck,
      Sl_wrComp => Sl_wrComp,
      Sl_wrBTerm => Sl_wrBTerm,
      Sl_rdDBus => Sl_rdDBus,
      Sl_rdWdAddr => Sl_rdWdAddr,
      Sl_rdDAck => Sl_rdDAck,
      Sl_rdComp => Sl_rdComp,
      Sl_rdBTerm => Sl_rdBTerm,
      Sl_MBusy => Sl_MBusy,
      Sl_MErr => Sl_MErr,
      PLB_MAddrAck => PLB_MAddrAck,
      PLB_MSSize => PLB_MSSize,
      PLB_MRearbitrate => PLB_MRearbitrate,
      PLB_MBusy => PLB_MBusy,
      PLB_MErr => PLB_MErr,
      PLB_MWrDAck => PLB_MWrDAck,
      PLB_MRdDBus => PLB_MRdDBus,
      PLB_MRdWdAddr => PLB_MRdWdAddr,
      PLB_MRdDAck => PLB_MRdDAck,
      PLB_MRdBTerm => PLB_MRdBTerm,
      PLB_MWrBTerm => PLB_MWrBTerm,
      M_request => M_request,
      M_priority => M_priority,
      M_buslock => M_buslock,
      M_RNW => M_RNW,
      M_BE => M_BE,
      M_MSize => M_MSize,
      M_size => M_size,
      M_type => M_type,
      M_compress => M_compress,
      M_guarded => M_guarded,
      M_ordered => M_ordered,
      M_lockErr => M_lockErr,
      M_abort => M_abort,
      M_ABus => M_ABus,
      M_wrDBus => M_wrDBus,
      M_wrBurst => M_wrBurst,
      M_rdBurst => M_rdBurst,
      PHY_Mii_clk_I => PHY_Mii_clk_I,
      PHY_Mii_clk_O => PHY_Mii_clk_O,
      PHY_Mii_clk_T => PHY_Mii_clk_T,
      PHY_Mii_data_I => PHY_Mii_data_I,
      PHY_Mii_data_O => PHY_Mii_data_O,
      PHY_Mii_data_T => PHY_Mii_data_T
    );

end architecture STRUCTURE;

