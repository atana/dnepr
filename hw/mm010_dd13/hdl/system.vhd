-------------------------------------------------------------------------------
-- system.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

entity system is
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
end system;

architecture STRUCTURE of system is

  component dnepr_wrapper is
    port (
      tact : in std_logic_vector(15 downto 0);
      discr : in std_logic_vector(15 downto 0);
      TR_start : out std_logic;
      TR_stop : out std_logic;
      RC_start : out std_logic;
      RC_stop : out std_logic;
      dTR_start : out std_logic;
      dTR_stop : out std_logic;
      dRC_start : out std_logic;
      dRC_stop : out std_logic;
      PLB_Clk : in std_logic;
      PLB_Rst : in std_logic;
      Sl_addrAck : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 3);
      Sl_MErr : out std_logic_vector(0 to 3);
      Sl_rdBTerm : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_rdDAck : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 63);
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rearbitrate : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_wrBTerm : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_wrDAck : out std_logic;
      PLB_abort : in std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_BE : in std_logic_vector(0 to 7);
      PLB_busLock : in std_logic;
      PLB_compress : in std_logic;
      PLB_guarded : in std_logic;
      PLB_lockErr : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 1);
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_ordered : in std_logic;
      PLB_PAValid : in std_logic;
      PLB_pendPri : in std_logic_vector(0 to 1);
      PLB_pendReq : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_RNW : in std_logic;
      PLB_SAValid : in std_logic;
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_wrBurst : in std_logic;
      PLB_wrDBus : in std_logic_vector(0 to 63);
      PLB_wrPrim : in std_logic
    );
  end component;

  component grid_gen_wrapper is
    port (
      clk_19 : in std_logic;
      clk_1_25 : in std_logic;
      tact : out std_logic_vector(15 downto 0);
      discr : out std_logic_vector(15 downto 0);
      PLB_Clk : in std_logic;
      PLB_Rst : in std_logic;
      Sl_addrAck : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 3);
      Sl_MErr : out std_logic_vector(0 to 3);
      Sl_rdBTerm : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_rdDAck : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 63);
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rearbitrate : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_wrBTerm : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_wrDAck : out std_logic;
      PLB_abort : in std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_BE : in std_logic_vector(0 to 7);
      PLB_busLock : in std_logic;
      PLB_compress : in std_logic;
      PLB_guarded : in std_logic;
      PLB_lockErr : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 1);
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_ordered : in std_logic;
      PLB_PAValid : in std_logic;
      PLB_pendPri : in std_logic_vector(0 to 1);
      PLB_pendReq : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_RNW : in std_logic;
      PLB_SAValid : in std_logic;
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_wrBurst : in std_logic;
      PLB_wrDBus : in std_logic_vector(0 to 63);
      PLB_wrPrim : in std_logic
    );
  end component;

  component delay_meter_wrapper is
    port (
      ft_edge : in std_logic;
      signal_in : in std_logic;
      signal_out : out std_logic;
      delay : out std_logic_vector(15 downto 0);
      PLB_Clk : in std_logic;
      PLB_Rst : in std_logic;
      Sl_addrAck : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 3);
      Sl_MErr : out std_logic_vector(0 to 3);
      Sl_rdBTerm : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_rdDAck : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 63);
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rearbitrate : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_wrBTerm : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_wrDAck : out std_logic;
      PLB_abort : in std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_BE : in std_logic_vector(0 to 7);
      PLB_busLock : in std_logic;
      PLB_compress : in std_logic;
      PLB_guarded : in std_logic;
      PLB_lockErr : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 1);
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_ordered : in std_logic;
      PLB_PAValid : in std_logic;
      PLB_pendPri : in std_logic_vector(0 to 1);
      PLB_pendReq : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_RNW : in std_logic;
      PLB_SAValid : in std_logic;
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_wrBurst : in std_logic;
      PLB_wrDBus : in std_logic_vector(0 to 63);
      PLB_wrPrim : in std_logic
    );
  end component;

  component ft_fd_input_wrapper is
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

  component ppc405_1_wrapper is
    port (
      C405CPMCORESLEEPREQ : out std_logic;
      C405CPMMSRCE : out std_logic;
      C405CPMMSREE : out std_logic;
      C405CPMTIMERIRQ : out std_logic;
      C405CPMTIMERRESETREQ : out std_logic;
      C405XXXMACHINECHECK : out std_logic;
      CPMC405CLOCK : in std_logic;
      CPMC405CORECLKINACTIVE : in std_logic;
      CPMC405CPUCLKEN : in std_logic;
      CPMC405JTAGCLKEN : in std_logic;
      CPMC405TIMERCLKEN : in std_logic;
      CPMC405TIMERTICK : in std_logic;
      MCBCPUCLKEN : in std_logic;
      MCBTIMEREN : in std_logic;
      MCPPCRST : in std_logic;
      PLBCLK : in std_logic;
      DCRCLK : in std_logic;
      C405RSTCHIPRESETREQ : out std_logic;
      C405RSTCORERESETREQ : out std_logic;
      C405RSTSYSRESETREQ : out std_logic;
      RSTC405RESETCHIP : in std_logic;
      RSTC405RESETCORE : in std_logic;
      RSTC405RESETSYS : in std_logic;
      C405PLBICUABUS : out std_logic_vector(0 to 31);
      C405PLBICUBE : out std_logic_vector(0 to 7);
      C405PLBICURNW : out std_logic;
      C405PLBICUABORT : out std_logic;
      C405PLBICUBUSLOCK : out std_logic;
      C405PLBICUU0ATTR : out std_logic;
      C405PLBICUGUARDED : out std_logic;
      C405PLBICULOCKERR : out std_logic;
      C405PLBICUMSIZE : out std_logic_vector(0 to 1);
      C405PLBICUORDERED : out std_logic;
      C405PLBICUPRIORITY : out std_logic_vector(0 to 1);
      C405PLBICURDBURST : out std_logic;
      C405PLBICUREQUEST : out std_logic;
      C405PLBICUSIZE : out std_logic_vector(0 to 3);
      C405PLBICUTYPE : out std_logic_vector(0 to 2);
      C405PLBICUWRBURST : out std_logic;
      C405PLBICUWRDBUS : out std_logic_vector(0 to 63);
      C405PLBICUCACHEABLE : out std_logic;
      PLBC405ICUADDRACK : in std_logic;
      PLBC405ICUBUSY : in std_logic;
      PLBC405ICUERR : in std_logic;
      PLBC405ICURDBTERM : in std_logic;
      PLBC405ICURDDACK : in std_logic;
      PLBC405ICURDDBUS : in std_logic_vector(0 to 63);
      PLBC405ICURDWDADDR : in std_logic_vector(0 to 3);
      PLBC405ICUREARBITRATE : in std_logic;
      PLBC405ICUWRBTERM : in std_logic;
      PLBC405ICUWRDACK : in std_logic;
      PLBC405ICUSSIZE : in std_logic_vector(0 to 1);
      PLBC405ICUSERR : in std_logic;
      PLBC405ICUSBUSYS : in std_logic;
      C405PLBDCUABUS : out std_logic_vector(0 to 31);
      C405PLBDCUBE : out std_logic_vector(0 to 7);
      C405PLBDCURNW : out std_logic;
      C405PLBDCUABORT : out std_logic;
      C405PLBDCUBUSLOCK : out std_logic;
      C405PLBDCUU0ATTR : out std_logic;
      C405PLBDCUGUARDED : out std_logic;
      C405PLBDCULOCKERR : out std_logic;
      C405PLBDCUMSIZE : out std_logic_vector(0 to 1);
      C405PLBDCUORDERED : out std_logic;
      C405PLBDCUPRIORITY : out std_logic_vector(0 to 1);
      C405PLBDCURDBURST : out std_logic;
      C405PLBDCUREQUEST : out std_logic;
      C405PLBDCUSIZE : out std_logic_vector(0 to 3);
      C405PLBDCUTYPE : out std_logic_vector(0 to 2);
      C405PLBDCUWRBURST : out std_logic;
      C405PLBDCUWRDBUS : out std_logic_vector(0 to 63);
      C405PLBDCUCACHEABLE : out std_logic;
      C405PLBDCUWRITETHRU : out std_logic;
      PLBC405DCUADDRACK : in std_logic;
      PLBC405DCUBUSY : in std_logic;
      PLBC405DCUERR : in std_logic;
      PLBC405DCURDBTERM : in std_logic;
      PLBC405DCURDDACK : in std_logic;
      PLBC405DCURDDBUS : in std_logic_vector(0 to 63);
      PLBC405DCURDWDADDR : in std_logic_vector(0 to 3);
      PLBC405DCUREARBITRATE : in std_logic;
      PLBC405DCUWRBTERM : in std_logic;
      PLBC405DCUWRDACK : in std_logic;
      PLBC405DCUSSIZE : in std_logic_vector(0 to 1);
      PLBC405DCUSERR : in std_logic;
      PLBC405DCUSBUSYS : in std_logic;
      BRAMDSOCMCLK : in std_logic;
      BRAMDSOCMRDDBUS : in std_logic_vector(0 to 31);
      DSARCVALUE : in std_logic_vector(0 to 7);
      DSCNTLVALUE : in std_logic_vector(0 to 7);
      DSOCMBRAMABUS : out std_logic_vector(8 to 29);
      DSOCMBRAMBYTEWRITE : out std_logic_vector(0 to 3);
      DSOCMBRAMEN : out std_logic;
      DSOCMBRAMWRDBUS : out std_logic_vector(0 to 31);
      DSOCMBUSY : out std_logic;
      BRAMISOCMCLK : in std_logic;
      BRAMISOCMRDDBUS : in std_logic_vector(0 to 63);
      ISARCVALUE : in std_logic_vector(0 to 7);
      ISCNTLVALUE : in std_logic_vector(0 to 7);
      ISOCMBRAMEN : out std_logic;
      ISOCMBRAMEVENWRITEEN : out std_logic;
      ISOCMBRAMODDWRITEEN : out std_logic;
      ISOCMBRAMRDABUS : out std_logic_vector(8 to 28);
      ISOCMBRAMWRABUS : out std_logic_vector(8 to 28);
      ISOCMBRAMWRDBUS : out std_logic_vector(0 to 31);
      C405DCRABUS : out std_logic_vector(0 to 9);
      C405DCRDBUSOUT : out std_logic_vector(0 to 31);
      C405DCRREAD : out std_logic;
      C405DCRWRITE : out std_logic;
      DCRC405ACK : in std_logic;
      DCRC405DBUSIN : in std_logic_vector(0 to 31);
      EICC405CRITINPUTIRQ : in std_logic;
      EICC405EXTINPUTIRQ : in std_logic;
      C405JTGCAPTUREDR : out std_logic;
      C405JTGEXTEST : out std_logic;
      C405JTGPGMOUT : out std_logic;
      C405JTGSHIFTDR : out std_logic;
      C405JTGTDO : out std_logic;
      C405JTGTDOEN : out std_logic;
      C405JTGUPDATEDR : out std_logic;
      MCBJTAGEN : in std_logic;
      JTGC405BNDSCANTDO : in std_logic;
      JTGC405TCK : in std_logic;
      JTGC405TDI : in std_logic;
      JTGC405TMS : in std_logic;
      JTGC405TRSTNEG : in std_logic;
      C405DBGMSRWE : out std_logic;
      C405DBGSTOPACK : out std_logic;
      C405DBGWBCOMPLETE : out std_logic;
      C405DBGWBFULL : out std_logic;
      C405DBGWBIAR : out std_logic_vector(0 to 29);
      DBGC405DEBUGHALT : in std_logic;
      DBGC405EXTBUSHOLDACK : in std_logic;
      DBGC405UNCONDDEBUGEVENT : in std_logic;
      C405TRCCYCLE : out std_logic;
      C405TRCEVENEXECUTIONSTATUS : out std_logic_vector(0 to 1);
      C405TRCODDEXECUTIONSTATUS : out std_logic_vector(0 to 1);
      C405TRCTRACESTATUS : out std_logic_vector(0 to 3);
      C405TRCTRIGGEREVENTOUT : out std_logic;
      C405TRCTRIGGEREVENTTYPE : out std_logic_vector(0 to 10);
      TRCC405TRACEDISABLE : in std_logic;
      TRCC405TRIGGEREVENTIN : in std_logic
    );
  end component;

  component ppc405_0_wrapper is
    port (
      C405CPMCORESLEEPREQ : out std_logic;
      C405CPMMSRCE : out std_logic;
      C405CPMMSREE : out std_logic;
      C405CPMTIMERIRQ : out std_logic;
      C405CPMTIMERRESETREQ : out std_logic;
      C405XXXMACHINECHECK : out std_logic;
      CPMC405CLOCK : in std_logic;
      CPMC405CORECLKINACTIVE : in std_logic;
      CPMC405CPUCLKEN : in std_logic;
      CPMC405JTAGCLKEN : in std_logic;
      CPMC405TIMERCLKEN : in std_logic;
      CPMC405TIMERTICK : in std_logic;
      MCBCPUCLKEN : in std_logic;
      MCBTIMEREN : in std_logic;
      MCPPCRST : in std_logic;
      PLBCLK : in std_logic;
      DCRCLK : in std_logic;
      C405RSTCHIPRESETREQ : out std_logic;
      C405RSTCORERESETREQ : out std_logic;
      C405RSTSYSRESETREQ : out std_logic;
      RSTC405RESETCHIP : in std_logic;
      RSTC405RESETCORE : in std_logic;
      RSTC405RESETSYS : in std_logic;
      C405PLBICUABUS : out std_logic_vector(0 to 31);
      C405PLBICUBE : out std_logic_vector(0 to 7);
      C405PLBICURNW : out std_logic;
      C405PLBICUABORT : out std_logic;
      C405PLBICUBUSLOCK : out std_logic;
      C405PLBICUU0ATTR : out std_logic;
      C405PLBICUGUARDED : out std_logic;
      C405PLBICULOCKERR : out std_logic;
      C405PLBICUMSIZE : out std_logic_vector(0 to 1);
      C405PLBICUORDERED : out std_logic;
      C405PLBICUPRIORITY : out std_logic_vector(0 to 1);
      C405PLBICURDBURST : out std_logic;
      C405PLBICUREQUEST : out std_logic;
      C405PLBICUSIZE : out std_logic_vector(0 to 3);
      C405PLBICUTYPE : out std_logic_vector(0 to 2);
      C405PLBICUWRBURST : out std_logic;
      C405PLBICUWRDBUS : out std_logic_vector(0 to 63);
      C405PLBICUCACHEABLE : out std_logic;
      PLBC405ICUADDRACK : in std_logic;
      PLBC405ICUBUSY : in std_logic;
      PLBC405ICUERR : in std_logic;
      PLBC405ICURDBTERM : in std_logic;
      PLBC405ICURDDACK : in std_logic;
      PLBC405ICURDDBUS : in std_logic_vector(0 to 63);
      PLBC405ICURDWDADDR : in std_logic_vector(0 to 3);
      PLBC405ICUREARBITRATE : in std_logic;
      PLBC405ICUWRBTERM : in std_logic;
      PLBC405ICUWRDACK : in std_logic;
      PLBC405ICUSSIZE : in std_logic_vector(0 to 1);
      PLBC405ICUSERR : in std_logic;
      PLBC405ICUSBUSYS : in std_logic;
      C405PLBDCUABUS : out std_logic_vector(0 to 31);
      C405PLBDCUBE : out std_logic_vector(0 to 7);
      C405PLBDCURNW : out std_logic;
      C405PLBDCUABORT : out std_logic;
      C405PLBDCUBUSLOCK : out std_logic;
      C405PLBDCUU0ATTR : out std_logic;
      C405PLBDCUGUARDED : out std_logic;
      C405PLBDCULOCKERR : out std_logic;
      C405PLBDCUMSIZE : out std_logic_vector(0 to 1);
      C405PLBDCUORDERED : out std_logic;
      C405PLBDCUPRIORITY : out std_logic_vector(0 to 1);
      C405PLBDCURDBURST : out std_logic;
      C405PLBDCUREQUEST : out std_logic;
      C405PLBDCUSIZE : out std_logic_vector(0 to 3);
      C405PLBDCUTYPE : out std_logic_vector(0 to 2);
      C405PLBDCUWRBURST : out std_logic;
      C405PLBDCUWRDBUS : out std_logic_vector(0 to 63);
      C405PLBDCUCACHEABLE : out std_logic;
      C405PLBDCUWRITETHRU : out std_logic;
      PLBC405DCUADDRACK : in std_logic;
      PLBC405DCUBUSY : in std_logic;
      PLBC405DCUERR : in std_logic;
      PLBC405DCURDBTERM : in std_logic;
      PLBC405DCURDDACK : in std_logic;
      PLBC405DCURDDBUS : in std_logic_vector(0 to 63);
      PLBC405DCURDWDADDR : in std_logic_vector(0 to 3);
      PLBC405DCUREARBITRATE : in std_logic;
      PLBC405DCUWRBTERM : in std_logic;
      PLBC405DCUWRDACK : in std_logic;
      PLBC405DCUSSIZE : in std_logic_vector(0 to 1);
      PLBC405DCUSERR : in std_logic;
      PLBC405DCUSBUSYS : in std_logic;
      BRAMDSOCMCLK : in std_logic;
      BRAMDSOCMRDDBUS : in std_logic_vector(0 to 31);
      DSARCVALUE : in std_logic_vector(0 to 7);
      DSCNTLVALUE : in std_logic_vector(0 to 7);
      DSOCMBRAMABUS : out std_logic_vector(8 to 29);
      DSOCMBRAMBYTEWRITE : out std_logic_vector(0 to 3);
      DSOCMBRAMEN : out std_logic;
      DSOCMBRAMWRDBUS : out std_logic_vector(0 to 31);
      DSOCMBUSY : out std_logic;
      BRAMISOCMCLK : in std_logic;
      BRAMISOCMRDDBUS : in std_logic_vector(0 to 63);
      ISARCVALUE : in std_logic_vector(0 to 7);
      ISCNTLVALUE : in std_logic_vector(0 to 7);
      ISOCMBRAMEN : out std_logic;
      ISOCMBRAMEVENWRITEEN : out std_logic;
      ISOCMBRAMODDWRITEEN : out std_logic;
      ISOCMBRAMRDABUS : out std_logic_vector(8 to 28);
      ISOCMBRAMWRABUS : out std_logic_vector(8 to 28);
      ISOCMBRAMWRDBUS : out std_logic_vector(0 to 31);
      C405DCRABUS : out std_logic_vector(0 to 9);
      C405DCRDBUSOUT : out std_logic_vector(0 to 31);
      C405DCRREAD : out std_logic;
      C405DCRWRITE : out std_logic;
      DCRC405ACK : in std_logic;
      DCRC405DBUSIN : in std_logic_vector(0 to 31);
      EICC405CRITINPUTIRQ : in std_logic;
      EICC405EXTINPUTIRQ : in std_logic;
      C405JTGCAPTUREDR : out std_logic;
      C405JTGEXTEST : out std_logic;
      C405JTGPGMOUT : out std_logic;
      C405JTGSHIFTDR : out std_logic;
      C405JTGTDO : out std_logic;
      C405JTGTDOEN : out std_logic;
      C405JTGUPDATEDR : out std_logic;
      MCBJTAGEN : in std_logic;
      JTGC405BNDSCANTDO : in std_logic;
      JTGC405TCK : in std_logic;
      JTGC405TDI : in std_logic;
      JTGC405TMS : in std_logic;
      JTGC405TRSTNEG : in std_logic;
      C405DBGMSRWE : out std_logic;
      C405DBGSTOPACK : out std_logic;
      C405DBGWBCOMPLETE : out std_logic;
      C405DBGWBFULL : out std_logic;
      C405DBGWBIAR : out std_logic_vector(0 to 29);
      DBGC405DEBUGHALT : in std_logic;
      DBGC405EXTBUSHOLDACK : in std_logic;
      DBGC405UNCONDDEBUGEVENT : in std_logic;
      C405TRCCYCLE : out std_logic;
      C405TRCEVENEXECUTIONSTATUS : out std_logic_vector(0 to 1);
      C405TRCODDEXECUTIONSTATUS : out std_logic_vector(0 to 1);
      C405TRCTRACESTATUS : out std_logic_vector(0 to 3);
      C405TRCTRIGGEREVENTOUT : out std_logic;
      C405TRCTRIGGEREVENTTYPE : out std_logic_vector(0 to 10);
      TRCC405TRACEDISABLE : in std_logic;
      TRCC405TRIGGEREVENTIN : in std_logic
    );
  end component;

  component jtagppc_0_wrapper is
    port (
      TRSTNEG : in std_logic;
      HALTNEG0 : in std_logic;
      DBGC405DEBUGHALT0 : out std_logic;
      HALTNEG1 : in std_logic;
      DBGC405DEBUGHALT1 : out std_logic;
      C405JTGTDO0 : in std_logic;
      C405JTGTDOEN0 : in std_logic;
      JTGC405TCK0 : out std_logic;
      JTGC405TDI0 : out std_logic;
      JTGC405TMS0 : out std_logic;
      JTGC405TRSTNEG0 : out std_logic;
      C405JTGTDO1 : in std_logic;
      C405JTGTDOEN1 : in std_logic;
      JTGC405TCK1 : out std_logic;
      JTGC405TDI1 : out std_logic;
      JTGC405TMS1 : out std_logic;
      JTGC405TRSTNEG1 : out std_logic
    );
  end component;

  component plb2opb_wrapper is
    port (
      PLB_Clk : in std_logic;
      OPB_Clk : in std_logic;
      PLB_Rst : in std_logic;
      OPB_Rst : in std_logic;
      Bus_Error_Det : out std_logic;
      BGI_Trans_Abort : out std_logic;
      BGO_dcrAck : out std_logic;
      BGO_dcrDBus : out std_logic_vector(0 to 31);
      DCR_ABus : in std_logic_vector(0 to 9);
      DCR_DBus : in std_logic_vector(0 to 31);
      DCR_Read : in std_logic;
      DCR_Write : in std_logic;
      BGO_addrAck : out std_logic;
      BGO_MErr : out std_logic_vector(0 to 3);
      BGO_MBusy : out std_logic_vector(0 to 3);
      BGO_rdBTerm : out std_logic;
      BGO_rdComp : out std_logic;
      BGO_rdDAck : out std_logic;
      BGO_rdDBus : out std_logic_vector(0 to 63);
      BGO_rdWdAddr : out std_logic_vector(0 to 3);
      BGO_rearbitrate : out std_logic;
      BGO_SSize : out std_logic_vector(0 to 1);
      BGO_wait : out std_logic;
      BGO_wrBTerm : out std_logic;
      BGO_wrComp : out std_logic;
      BGO_wrDAck : out std_logic;
      PLB_abort : in std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_BE : in std_logic_vector(0 to 7);
      PLB_busLock : in std_logic;
      PLB_compress : in std_logic;
      PLB_guarded : in std_logic;
      PLB_lockErr : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 1);
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_ordered : in std_logic;
      PLB_PAValid : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_RNW : in std_logic;
      PLB_SAValid : in std_logic;
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_wrBurst : in std_logic;
      PLB_wrDBus : in std_logic_vector(0 to 63);
      PLB_wrPrim : in std_logic;
      PLB2OPB_rearb : out std_logic;
      BGO_ABus : out std_logic_vector(0 to 31);
      BGO_BE : out std_logic_vector(0 to 3);
      BGO_busLock : out std_logic;
      BGO_DBus : out std_logic_vector(0 to 31);
      BGO_request : out std_logic;
      BGO_RNW : out std_logic;
      BGO_select : out std_logic;
      BGO_seqAddr : out std_logic;
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_errAck : in std_logic;
      OPB_MnGrant : in std_logic;
      OPB_retry : in std_logic;
      OPB_timeout : in std_logic;
      OPB_xferAck : in std_logic
    );
  end component;

  component opb_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : out std_logic;
      SYS_Rst : in std_logic;
      Debug_SYS_Rst : in std_logic;
      WDT_Rst : in std_logic;
      M_ABus : in std_logic_vector(0 to 31);
      M_BE : in std_logic_vector(0 to 3);
      M_beXfer : in std_logic_vector(0 to 0);
      M_busLock : in std_logic_vector(0 to 0);
      M_DBus : in std_logic_vector(0 to 31);
      M_DBusEn : in std_logic_vector(0 to 0);
      M_DBusEn32_63 : in std_logic_vector(0 to 0);
      M_dwXfer : in std_logic_vector(0 to 0);
      M_fwXfer : in std_logic_vector(0 to 0);
      M_hwXfer : in std_logic_vector(0 to 0);
      M_request : in std_logic_vector(0 to 0);
      M_RNW : in std_logic_vector(0 to 0);
      M_select : in std_logic_vector(0 to 0);
      M_seqAddr : in std_logic_vector(0 to 0);
      Sl_beAck : in std_logic_vector(0 to 7);
      Sl_DBus : in std_logic_vector(0 to 255);
      Sl_DBusEn : in std_logic_vector(0 to 7);
      Sl_DBusEn32_63 : in std_logic_vector(0 to 7);
      Sl_errAck : in std_logic_vector(0 to 7);
      Sl_dwAck : in std_logic_vector(0 to 7);
      Sl_fwAck : in std_logic_vector(0 to 7);
      Sl_hwAck : in std_logic_vector(0 to 7);
      Sl_retry : in std_logic_vector(0 to 7);
      Sl_toutSup : in std_logic_vector(0 to 7);
      Sl_xferAck : in std_logic_vector(0 to 7);
      OPB_MRequest : out std_logic_vector(0 to 0);
      OPB_ABus : out std_logic_vector(0 to 31);
      OPB_BE : out std_logic_vector(0 to 3);
      OPB_beXfer : out std_logic;
      OPB_beAck : out std_logic;
      OPB_busLock : out std_logic;
      OPB_rdDBus : out std_logic_vector(0 to 31);
      OPB_wrDBus : out std_logic_vector(0 to 31);
      OPB_DBus : out std_logic_vector(0 to 31);
      OPB_errAck : out std_logic;
      OPB_dwAck : out std_logic;
      OPB_dwXfer : out std_logic;
      OPB_fwAck : out std_logic;
      OPB_fwXfer : out std_logic;
      OPB_hwAck : out std_logic;
      OPB_hwXfer : out std_logic;
      OPB_MGrant : out std_logic_vector(0 to 0);
      OPB_pendReq : out std_logic_vector(0 to 0);
      OPB_retry : out std_logic;
      OPB_RNW : out std_logic;
      OPB_select : out std_logic;
      OPB_seqAddr : out std_logic;
      OPB_timeout : out std_logic;
      OPB_toutSup : out std_logic;
      OPB_xferAck : out std_logic
    );
  end component;

  component plb_wrapper is
    port (
      PLB_Clk : in std_logic;
      SYS_Rst : in std_logic;
      PLB_Rst : out std_logic;
      PLB_dcrAck : out std_logic;
      PLB_dcrDBus : out std_logic_vector(0 to 31);
      DCR_ABus : in std_logic_vector(0 to 9);
      DCR_DBus : in std_logic_vector(0 to 31);
      DCR_Read : in std_logic;
      DCR_Write : in std_logic;
      M_ABus : in std_logic_vector(0 to 127);
      M_BE : in std_logic_vector(0 to 31);
      M_RNW : in std_logic_vector(0 to 3);
      M_abort : in std_logic_vector(0 to 3);
      M_busLock : in std_logic_vector(0 to 3);
      M_compress : in std_logic_vector(0 to 3);
      M_guarded : in std_logic_vector(0 to 3);
      M_lockErr : in std_logic_vector(0 to 3);
      M_MSize : in std_logic_vector(0 to 7);
      M_ordered : in std_logic_vector(0 to 3);
      M_priority : in std_logic_vector(0 to 7);
      M_rdBurst : in std_logic_vector(0 to 3);
      M_request : in std_logic_vector(0 to 3);
      M_size : in std_logic_vector(0 to 15);
      M_type : in std_logic_vector(0 to 11);
      M_wrBurst : in std_logic_vector(0 to 3);
      M_wrDBus : in std_logic_vector(0 to 255);
      Sl_addrAck : in std_logic_vector(0 to 8);
      Sl_MErr : in std_logic_vector(0 to 35);
      Sl_MBusy : in std_logic_vector(0 to 35);
      Sl_rdBTerm : in std_logic_vector(0 to 8);
      Sl_rdComp : in std_logic_vector(0 to 8);
      Sl_rdDAck : in std_logic_vector(0 to 8);
      Sl_rdDBus : in std_logic_vector(0 to 575);
      Sl_rdWdAddr : in std_logic_vector(0 to 35);
      Sl_rearbitrate : in std_logic_vector(0 to 8);
      Sl_SSize : in std_logic_vector(0 to 17);
      Sl_wait : in std_logic_vector(0 to 8);
      Sl_wrBTerm : in std_logic_vector(0 to 8);
      Sl_wrComp : in std_logic_vector(0 to 8);
      Sl_wrDAck : in std_logic_vector(0 to 8);
      PLB_ABus : out std_logic_vector(0 to 31);
      PLB_BE : out std_logic_vector(0 to 7);
      PLB_MAddrAck : out std_logic_vector(0 to 3);
      PLB_MBusy : out std_logic_vector(0 to 3);
      PLB_MErr : out std_logic_vector(0 to 3);
      PLB_MRdBTerm : out std_logic_vector(0 to 3);
      PLB_MRdDAck : out std_logic_vector(0 to 3);
      PLB_MRdDBus : out std_logic_vector(0 to 255);
      PLB_MRdWdAddr : out std_logic_vector(0 to 15);
      PLB_MRearbitrate : out std_logic_vector(0 to 3);
      PLB_MWrBTerm : out std_logic_vector(0 to 3);
      PLB_MWrDAck : out std_logic_vector(0 to 3);
      PLB_MSSize : out std_logic_vector(0 to 7);
      PLB_PAValid : out std_logic;
      PLB_RNW : out std_logic;
      PLB_SAValid : out std_logic;
      PLB_abort : out std_logic;
      PLB_busLock : out std_logic;
      PLB_compress : out std_logic;
      PLB_guarded : out std_logic;
      PLB_lockErr : out std_logic;
      PLB_masterID : out std_logic_vector(0 to 1);
      PLB_MSize : out std_logic_vector(0 to 1);
      PLB_ordered : out std_logic;
      PLB_pendPri : out std_logic_vector(0 to 1);
      PLB_pendReq : out std_logic;
      PLB_rdBurst : out std_logic;
      PLB_rdPrim : out std_logic;
      PLB_reqPri : out std_logic_vector(0 to 1);
      PLB_size : out std_logic_vector(0 to 3);
      PLB_type : out std_logic_vector(0 to 2);
      PLB_wrBurst : out std_logic;
      PLB_wrDBus : out std_logic_vector(0 to 63);
      PLB_wrPrim : out std_logic;
      PLB_SaddrAck : out std_logic;
      PLB_SMErr : out std_logic_vector(0 to 3);
      PLB_SMBusy : out std_logic_vector(0 to 3);
      PLB_SrdBTerm : out std_logic;
      PLB_SrdComp : out std_logic;
      PLB_SrdDAck : out std_logic;
      PLB_SrdDBus : out std_logic_vector(0 to 63);
      PLB_SrdWdAddr : out std_logic_vector(0 to 3);
      PLB_Srearbitrate : out std_logic;
      PLB_Sssize : out std_logic_vector(0 to 1);
      PLB_Swait : out std_logic;
      PLB_SwrBTerm : out std_logic;
      PLB_SwrComp : out std_logic;
      PLB_SwrDAck : out std_logic;
      PLB2OPB_rearb : in std_logic_vector(0 to 8);
      ArbAddrVldReg : out std_logic;
      Bus_Error_Det : out std_logic
    );
  end component;

  component reset_block_wrapper is
    port (
      Slowest_sync_clk : in std_logic;
      Ext_Reset_In : in std_logic;
      Aux_Reset_In : in std_logic;
      Core_Reset_Req : in std_logic;
      Chip_Reset_Req : in std_logic;
      System_Reset_Req : in std_logic;
      Dcm_locked : in std_logic;
      Rstc405resetcore : out std_logic;
      Rstc405resetchip : out std_logic;
      Rstc405resetsys : out std_logic;
      Bus_Struct_Reset : out std_logic_vector(0 to 0);
      Peripheral_Reset : out std_logic_vector(0 to 0)
    );
  end component;

  component system_clk_0_wrapper is
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

  component ddr_fb_dcm_wrapper is
    port (
      RST : in std_logic;
      CLKIN : in std_logic;
      CLKFB : in std_logic;
      PSEN : in std_logic;
      PSINCDEC : in std_logic;
      PSCLK : in std_logic;
      DSSEN : in std_logic;
      CLK0 : out std_logic;
      CLK90 : out std_logic;
      CLK180 : out std_logic;
      CLK270 : out std_logic;
      CLKDV : out std_logic;
      CLK2X : out std_logic;
      CLK2X180 : out std_logic;
      CLKFX : out std_logic;
      CLKFX180 : out std_logic;
      STATUS : out std_logic_vector(7 downto 0);
      LOCKED : out std_logic;
      PSDONE : out std_logic
    );
  end component;

  component ddr90_dcm_wrapper is
    port (
      RST : in std_logic;
      CLKIN : in std_logic;
      CLKFB : in std_logic;
      PSEN : in std_logic;
      PSINCDEC : in std_logic;
      PSCLK : in std_logic;
      DSSEN : in std_logic;
      CLK0 : out std_logic;
      CLK90 : out std_logic;
      CLK180 : out std_logic;
      CLK270 : out std_logic;
      CLKDV : out std_logic;
      CLK2X : out std_logic;
      CLK2X180 : out std_logic;
      CLKFX : out std_logic;
      CLKFX180 : out std_logic;
      STATUS : out std_logic_vector(7 downto 0);
      LOCKED : out std_logic;
      PSDONE : out std_logic
    );
  end component;

  component sys_dcm_wrapper is
    port (
      RST : in std_logic;
      CLKIN : in std_logic;
      CLKFB : in std_logic;
      PSEN : in std_logic;
      PSINCDEC : in std_logic;
      PSCLK : in std_logic;
      DSSEN : in std_logic;
      CLK0 : out std_logic;
      CLK90 : out std_logic;
      CLK180 : out std_logic;
      CLK270 : out std_logic;
      CLKDV : out std_logic;
      CLK2X : out std_logic;
      CLK2X180 : out std_logic;
      CLKFX : out std_logic;
      CLKFX180 : out std_logic;
      STATUS : out std_logic_vector(7 downto 0);
      LOCKED : out std_logic;
      PSDONE : out std_logic
    );
  end component;

  component plb_eth2_contr_wrapper is
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
  end component;

  component plb_eth1_contr_wrapper is
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
  end component;

  component opb_intc_0_wrapper is
    port (
      OPB_Clk : in std_logic;
      Intr : in std_logic_vector(5 downto 0);
      OPB_Rst : in std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      OPB_DBus : in std_logic_vector(0 to 31);
      IntC_DBus : out std_logic_vector(0 to 31);
      IntC_errAck : out std_logic;
      IntC_retry : out std_logic;
      IntC_toutSup : out std_logic;
      IntC_xferAck : out std_logic;
      Irq : out std_logic
    );
  end component;

  component opb_flash_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to 31);
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      Flash_A : out std_logic_vector(0 to 31);
      Flash_CEN : out std_logic_vector(0 to 3);
      Flash_OEN : out std_logic;
      Flash_WEN : out std_logic;
      Flash_Rst : out std_logic;
      periph_reset : in std_logic;
      Flash_DQ_I : in std_logic_vector(0 to 15);
      Flash_DQ_O : out std_logic_vector(0 to 15);
      Flash_DQ_T : out std_logic
    );
  end component;

  component boot_ppc_cntrl_wrapper is
    port (
      opb_clk : in std_logic;
      opb_rst : in std_logic;
      opb_abus : in std_logic_vector(0 to 31);
      opb_dbus : in std_logic_vector(0 to 31);
      sln_dbus : out std_logic_vector(0 to 31);
      opb_select : in std_logic;
      opb_rnw : in std_logic;
      opb_seqaddr : in std_logic;
      opb_be : in std_logic_vector(0 to 3);
      sln_xferack : out std_logic;
      sln_errack : out std_logic;
      sln_toutsup : out std_logic;
      sln_retry : out std_logic;
      bram_rst : out std_logic;
      bram_clk : out std_logic;
      bram_en : out std_logic;
      bram_wen : out std_logic_vector(0 to 3);
      bram_addr : out std_logic_vector(0 to 31);
      bram_din : in std_logic_vector(0 to 31);
      bram_dout : out std_logic_vector(0 to 31)
    );
  end component;

  component boot_ppc_bram_wrapper is
    port (
      BRAM_Rst_A : in std_logic;
      BRAM_Clk_A : in std_logic;
      BRAM_EN_A : in std_logic;
      BRAM_WEN_A : in std_logic_vector(0 to 3);
      BRAM_Addr_A : in std_logic_vector(0 to 31);
      BRAM_Din_A : out std_logic_vector(0 to 31);
      BRAM_Dout_A : in std_logic_vector(0 to 31);
      BRAM_Rst_B : in std_logic;
      BRAM_Clk_B : in std_logic;
      BRAM_EN_B : in std_logic;
      BRAM_WEN_B : in std_logic_vector(0 to 3);
      BRAM_Addr_B : in std_logic_vector(0 to 31);
      BRAM_Din_B : out std_logic_vector(0 to 31);
      BRAM_Dout_B : in std_logic_vector(0 to 31)
    );
  end component;

  component plb_ddr_sdram_wrapper is
    port (
      PLB_Clk : in std_logic;
      PLB_Clk_n : in std_logic;
      Clk90_in : in std_logic;
      Clk90_in_n : in std_logic;
      DDR_Clk90_in : in std_logic;
      DDR_Clk90_in_n : in std_logic;
      PLB_Rst : in std_logic;
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
      IP2INTC_Irpt : out std_logic;
      DDR_Clk : out std_logic_vector(0 to 0);
      DDR_Clkn : out std_logic_vector(0 to 0);
      DDR_CKE : out std_logic_vector(0 to 0);
      DDR_CSn : out std_logic_vector(0 to 0);
      DDR_RASn : out std_logic;
      DDR_CASn : out std_logic;
      DDR_WEn : out std_logic;
      DDR_DM : out std_logic_vector(0 to 3);
      DDR_BankAddr : out std_logic_vector(0 to 1);
      DDR_Addr : out std_logic_vector(0 to 12);
      DDR_DM_ECC : out std_logic;
      DDR_Init_done : out std_logic;
      DDR_DQ_I : in std_logic_vector(0 to 31);
      DDR_DQ_O : out std_logic_vector(0 to 31);
      DDR_DQ_T : out std_logic_vector(0 to 31);
      DDR_DQS_I : in std_logic_vector(0 to 3);
      DDR_DQS_O : out std_logic_vector(0 to 3);
      DDR_DQS_T : out std_logic_vector(0 to 3);
      DDR_DQ_ECC_I : in std_logic_vector(0 to 6);
      DDR_DQ_ECC_O : out std_logic_vector(0 to 6);
      DDR_DQ_ECC_T : out std_logic_vector(0 to 6);
      DDR_DQS_ECC_I : in std_logic;
      DDR_DQS_ECC_O : out std_logic;
      DDR_DQS_ECC_T : out std_logic
    );
  end component;

  component uart_tuts_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Interrupt : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      OPB_DBus : in std_logic_vector(0 to 31);
      UART_DBus : out std_logic_vector(0 to 31);
      UART_errAck : out std_logic;
      UART_retry : out std_logic;
      UART_toutSup : out std_logic;
      UART_xferAck : out std_logic;
      RX : in std_logic;
      TX : out std_logic
    );
  end component;

  component rs232_1_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Interrupt : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      OPB_DBus : in std_logic_vector(0 to 31);
      UART_DBus : out std_logic_vector(0 to 31);
      UART_errAck : out std_logic;
      UART_retry : out std_logic;
      UART_toutSup : out std_logic;
      UART_xferAck : out std_logic;
      RX : in std_logic;
      TX : out std_logic
    );
  end component;

  component rs232_2_wrapper is
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Interrupt : out std_logic;
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      OPB_DBus : in std_logic_vector(0 to 31);
      UART_DBus : out std_logic_vector(0 to 31);
      UART_errAck : out std_logic;
      UART_retry : out std_logic;
      UART_toutSup : out std_logic;
      UART_xferAck : out std_logic;
      RX : in std_logic;
      TX : out std_logic
    );
  end component;

  component gpio_leds_wrapper is
    port (
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_Clk : in std_logic;
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_Rst : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      Sln_DBus : out std_logic_vector(0 to 31);
      Sln_errAck : out std_logic;
      Sln_retry : out std_logic;
      Sln_toutSup : out std_logic;
      Sln_xferAck : out std_logic;
      IP2INTC_Irpt : out std_logic;
      GPIO_in : in std_logic_vector(0 to 2);
      GPIO_d_out : out std_logic_vector(0 to 2);
      GPIO_t_out : out std_logic_vector(0 to 2);
      GPIO2_in : in std_logic_vector(0 to 2);
      GPIO2_d_out : out std_logic_vector(0 to 2);
      GPIO2_t_out : out std_logic_vector(0 to 2);
      GPIO_IO_I : in std_logic_vector(0 to 2);
      GPIO_IO_O : out std_logic_vector(0 to 2);
      GPIO_IO_T : out std_logic_vector(0 to 2);
      GPIO2_IO_I : in std_logic_vector(0 to 2);
      GPIO2_IO_O : out std_logic_vector(0 to 2);
      GPIO2_IO_T : out std_logic_vector(0 to 2)
    );
  end component;

  component freq_detect_wrapper is
    port (
      OPB_ABus : in std_logic_vector(0 to 31);
      OPB_BE : in std_logic_vector(0 to 3);
      OPB_Clk : in std_logic;
      OPB_DBus : in std_logic_vector(0 to 31);
      OPB_RNW : in std_logic;
      OPB_Rst : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      Sln_DBus : out std_logic_vector(0 to 31);
      Sln_errAck : out std_logic;
      Sln_retry : out std_logic;
      Sln_toutSup : out std_logic;
      Sln_xferAck : out std_logic;
      IP2INTC_Irpt : out std_logic;
      GPIO_in : in std_logic_vector(0 to 1);
      GPIO_d_out : out std_logic_vector(0 to 1);
      GPIO_t_out : out std_logic_vector(0 to 1);
      GPIO2_in : in std_logic_vector(0 to 1);
      GPIO2_d_out : out std_logic_vector(0 to 1);
      GPIO2_t_out : out std_logic_vector(0 to 1);
      GPIO_IO_I : in std_logic_vector(0 to 1);
      GPIO_IO_O : out std_logic_vector(0 to 1);
      GPIO_IO_T : out std_logic_vector(0 to 1);
      GPIO2_IO_I : in std_logic_vector(0 to 1);
      GPIO2_IO_O : out std_logic_vector(0 to 1);
      GPIO2_IO_T : out std_logic_vector(0 to 1)
    );
  end component;

  component reg_version_wrapper is
    port (
      PLB_Clk : in std_logic;
      PLB_Rst : in std_logic;
      Sl_addrAck : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 3);
      Sl_MErr : out std_logic_vector(0 to 3);
      Sl_rdBTerm : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_rdDAck : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 63);
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rearbitrate : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_wrBTerm : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_wrDAck : out std_logic;
      PLB_abort : in std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_BE : in std_logic_vector(0 to 7);
      PLB_busLock : in std_logic;
      PLB_compress : in std_logic;
      PLB_guarded : in std_logic;
      PLB_lockErr : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 1);
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_ordered : in std_logic;
      PLB_PAValid : in std_logic;
      PLB_pendPri : in std_logic_vector(0 to 1);
      PLB_pendReq : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_RNW : in std_logic;
      PLB_SAValid : in std_logic;
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_wrBurst : in std_logic;
      PLB_wrDBus : in std_logic_vector(0 to 63);
      PLB_wrPrim : in std_logic
    );
  end component;

  component f_gen_0_wrapper is
    port (
      ft_in : in std_logic;
      fd_in : in std_logic;
      ft_out : out std_logic;
      fd_out : out std_logic;
      PLB_Clk : in std_logic;
      PLB_Rst : in std_logic;
      Sl_addrAck : out std_logic;
      Sl_MBusy : out std_logic_vector(0 to 3);
      Sl_MErr : out std_logic_vector(0 to 3);
      Sl_rdBTerm : out std_logic;
      Sl_rdComp : out std_logic;
      Sl_rdDAck : out std_logic;
      Sl_rdDBus : out std_logic_vector(0 to 63);
      Sl_rdWdAddr : out std_logic_vector(0 to 3);
      Sl_rearbitrate : out std_logic;
      Sl_SSize : out std_logic_vector(0 to 1);
      Sl_wait : out std_logic;
      Sl_wrBTerm : out std_logic;
      Sl_wrComp : out std_logic;
      Sl_wrDAck : out std_logic;
      PLB_abort : in std_logic;
      PLB_ABus : in std_logic_vector(0 to 31);
      PLB_BE : in std_logic_vector(0 to 7);
      PLB_busLock : in std_logic;
      PLB_compress : in std_logic;
      PLB_guarded : in std_logic;
      PLB_lockErr : in std_logic;
      PLB_masterID : in std_logic_vector(0 to 1);
      PLB_MSize : in std_logic_vector(0 to 1);
      PLB_ordered : in std_logic;
      PLB_PAValid : in std_logic;
      PLB_pendPri : in std_logic_vector(0 to 1);
      PLB_pendReq : in std_logic;
      PLB_rdBurst : in std_logic;
      PLB_rdPrim : in std_logic;
      PLB_reqPri : in std_logic_vector(0 to 1);
      PLB_RNW : in std_logic;
      PLB_SAValid : in std_logic;
      PLB_size : in std_logic_vector(0 to 3);
      PLB_type : in std_logic_vector(0 to 2);
      PLB_wrBurst : in std_logic;
      PLB_wrDBus : in std_logic_vector(0 to 63);
      PLB_wrPrim : in std_logic
    );
  end component;

  component IOBUF is
    port (
      I : in std_logic;
      IO : inout std_logic;
      O : out std_logic;
      T : in std_logic
    );
  end component;

  -- Internal signals

  signal C405RSTCHIPRESETREQ : std_logic;
  signal C405RSTCORERESETREQ : std_logic;
  signal C405RSTSYSRESETREQ : std_logic;
  signal DDR_DQS_I : std_logic_vector(0 to 3);
  signal DDR_DQS_O : std_logic_vector(0 to 3);
  signal DDR_DQS_T : std_logic_vector(0 to 3);
  signal DDR_DQ_I : std_logic_vector(0 to 31);
  signal DDR_DQ_O : std_logic_vector(0 to 31);
  signal DDR_DQ_T : std_logic_vector(0 to 31);
  signal EICC405EXTINPUTIRQ : std_logic;
  signal Eth1_PHY_Mii_clk_I : std_logic;
  signal Eth1_PHY_Mii_clk_O : std_logic;
  signal Eth1_PHY_Mii_clk_T : std_logic;
  signal Eth1_PHY_Mii_data_I : std_logic;
  signal Eth1_PHY_Mii_data_O : std_logic;
  signal Eth1_PHY_Mii_data_T : std_logic;
  signal Eth2_PHY_Mii_clk_I : std_logic;
  signal Eth2_PHY_Mii_clk_O : std_logic;
  signal Eth2_PHY_Mii_clk_T : std_logic;
  signal Eth2_PHY_Mii_data_I : std_logic;
  signal Eth2_PHY_Mii_data_O : std_logic;
  signal Eth2_PHY_Mii_data_T : std_logic;
  signal Flash_DQ_I : std_logic_vector(0 to 15);
  signal Flash_DQ_O : std_logic_vector(0 to 15);
  signal Flash_DQ_T : std_logic;
  signal RSTC405RESETCHIP : std_logic;
  signal RSTC405RESETCORE : std_logic;
  signal RSTC405RESETSYS : std_logic;
  signal UART_TUTS_RX : std_logic;
  signal UART_TUTS_TX : std_logic;
  signal UART_TUTS_int : std_logic;
  signal boot_ppc_cntrl_port_BRAM_Addr : std_logic_vector(0 to 31);
  signal boot_ppc_cntrl_port_BRAM_Clk : std_logic;
  signal boot_ppc_cntrl_port_BRAM_Din : std_logic_vector(0 to 31);
  signal boot_ppc_cntrl_port_BRAM_Dout : std_logic_vector(0 to 31);
  signal boot_ppc_cntrl_port_BRAM_EN : std_logic;
  signal boot_ppc_cntrl_port_BRAM_Rst : std_logic;
  signal boot_ppc_cntrl_port_BRAM_WEN : std_logic_vector(0 to 3);
  signal clk_10_ext : std_logic;
  signal clk_10_int : std_logic;
  signal clk_19_ext : std_logic;
  signal clk_19_int : std_logic;
  signal clk_90_n_s : std_logic;
  signal clk_90_s : std_logic;
  signal cpu_clk : std_logic;
  signal dcm_0_lock : std_logic;
  signal dcm_1_FB : std_logic;
  signal dcm_1_lock : std_logic;
  signal dcm_2_FB : std_logic;
  signal dcm_2_lock : std_logic;
  signal dcm_clk_s : std_logic;
  signal ddr_clk_90_n_s : std_logic;
  signal ddr_clk_90_s : std_logic;
  signal ddr_feedback_s : std_logic;
  signal delay_meter_signal_in : std_logic;
  signal delay_meter_signal_out : std_logic;
  signal discr : std_logic_vector(15 downto 0);
  signal dnepr_RC_start : std_logic;
  signal dnepr_RC_stop : std_logic;
  signal dnepr_TR_start : std_logic;
  signal dnepr_TR_stop : std_logic;
  signal dnepr_dRC_start : std_logic;
  signal dnepr_dRC_stop : std_logic;
  signal dnepr_dTR_start : std_logic;
  signal dnepr_dTR_stop : std_logic;
  signal edge_discr_clk : std_logic;
  signal edge_tact_clk : std_logic;
  signal eth_1_int : std_logic;
  signal eth_2_int : std_logic;
  signal fd_ok : std_logic;
  signal ft_fd_input_ft_int : std_logic;
  signal ft_ok : std_logic;
  signal jtagppc_0_0_C405JTGTDO : std_logic;
  signal jtagppc_0_0_C405JTGTDOEN : std_logic;
  signal jtagppc_0_0_JTGC405TCK : std_logic;
  signal jtagppc_0_0_JTGC405TDI : std_logic;
  signal jtagppc_0_0_JTGC405TMS : std_logic;
  signal jtagppc_0_0_JTGC405TRSTNEG : std_logic;
  signal jtagppc_0_1_C405JTGTDO : std_logic;
  signal jtagppc_0_1_C405JTGTDOEN : std_logic;
  signal jtagppc_0_1_JTGC405TCK : std_logic;
  signal jtagppc_0_1_JTGC405TDI : std_logic;
  signal jtagppc_0_1_JTGC405TMS : std_logic;
  signal jtagppc_0_1_JTGC405TRSTNEG : std_logic;
  signal net_gnd0 : std_logic;
  signal net_gnd1 : std_logic_vector(0 to 0);
  signal net_gnd2 : std_logic_vector(0 to 1);
  signal net_gnd3 : std_logic_vector(0 to 2);
  signal net_gnd4 : std_logic_vector(0 to 3);
  signal net_gnd7 : std_logic_vector(0 to 6);
  signal net_gnd8 : std_logic_vector(0 to 7);
  signal net_gnd10 : std_logic_vector(0 to 9);
  signal net_gnd21 : std_logic_vector(0 to 20);
  signal net_gnd29 : std_logic_vector(0 to 28);
  signal net_gnd32 : std_logic_vector(0 to 31);
  signal net_gnd64 : std_logic_vector(0 to 63);
  signal net_vcc0 : std_logic;
  signal net_vcc1 : std_logic_vector(0 to 0);
  signal net_vcc8 : std_logic_vector(0 to 7);
  signal opb_M_ABus : std_logic_vector(0 to 31);
  signal opb_M_BE : std_logic_vector(0 to 3);
  signal opb_M_DBus : std_logic_vector(0 to 31);
  signal opb_M_RNW : std_logic_vector(0 to 0);
  signal opb_M_busLock : std_logic_vector(0 to 0);
  signal opb_M_request : std_logic_vector(0 to 0);
  signal opb_M_select : std_logic_vector(0 to 0);
  signal opb_M_seqAddr : std_logic_vector(0 to 0);
  signal opb_OPB_ABus : std_logic_vector(0 to 31);
  signal opb_OPB_BE : std_logic_vector(0 to 3);
  signal opb_OPB_DBus : std_logic_vector(0 to 31);
  signal opb_OPB_MGrant : std_logic_vector(0 to 0);
  signal opb_OPB_RNW : std_logic;
  signal opb_OPB_Rst : std_logic;
  signal opb_OPB_errAck : std_logic;
  signal opb_OPB_retry : std_logic;
  signal opb_OPB_select : std_logic;
  signal opb_OPB_seqAddr : std_logic;
  signal opb_OPB_timeout : std_logic;
  signal opb_OPB_xferAck : std_logic;
  signal opb_Sl_DBus : std_logic_vector(0 to 255);
  signal opb_Sl_errAck : std_logic_vector(0 to 7);
  signal opb_Sl_retry : std_logic_vector(0 to 7);
  signal opb_Sl_toutSup : std_logic_vector(0 to 7);
  signal opb_Sl_xferAck : std_logic_vector(0 to 7);
  signal pgassign1 : std_logic_vector(0 to 0);
  signal pgassign2 : std_logic_vector(0 to 0);
  signal pgassign3 : std_logic_vector(0 to 0);
  signal pgassign4 : std_logic_vector(0 to 0);
  signal pgassign5 : std_logic_vector(5 downto 0);
  signal pgassign6 : std_logic_vector(0 to 1);
  signal plb_M_ABus : std_logic_vector(0 to 127);
  signal plb_M_BE : std_logic_vector(0 to 31);
  signal plb_M_MSize : std_logic_vector(0 to 7);
  signal plb_M_RNW : std_logic_vector(0 to 3);
  signal plb_M_abort : std_logic_vector(0 to 3);
  signal plb_M_busLock : std_logic_vector(0 to 3);
  signal plb_M_compress : std_logic_vector(0 to 3);
  signal plb_M_guarded : std_logic_vector(0 to 3);
  signal plb_M_lockErr : std_logic_vector(0 to 3);
  signal plb_M_ordered : std_logic_vector(0 to 3);
  signal plb_M_priority : std_logic_vector(0 to 7);
  signal plb_M_rdBurst : std_logic_vector(0 to 3);
  signal plb_M_request : std_logic_vector(0 to 3);
  signal plb_M_size : std_logic_vector(0 to 15);
  signal plb_M_type : std_logic_vector(0 to 11);
  signal plb_M_wrBurst : std_logic_vector(0 to 3);
  signal plb_M_wrDBus : std_logic_vector(0 to 255);
  signal plb_PLB2OPB_rearb : std_logic_vector(0 to 8);
  signal plb_PLB_ABus : std_logic_vector(0 to 31);
  signal plb_PLB_BE : std_logic_vector(0 to 7);
  signal plb_PLB_MAddrAck : std_logic_vector(0 to 3);
  signal plb_PLB_MBusy : std_logic_vector(0 to 3);
  signal plb_PLB_MErr : std_logic_vector(0 to 3);
  signal plb_PLB_MRdBTerm : std_logic_vector(0 to 3);
  signal plb_PLB_MRdDAck : std_logic_vector(0 to 3);
  signal plb_PLB_MRdDBus : std_logic_vector(0 to 255);
  signal plb_PLB_MRdWdAddr : std_logic_vector(0 to 15);
  signal plb_PLB_MRearbitrate : std_logic_vector(0 to 3);
  signal plb_PLB_MSSize : std_logic_vector(0 to 7);
  signal plb_PLB_MSize : std_logic_vector(0 to 1);
  signal plb_PLB_MWrBTerm : std_logic_vector(0 to 3);
  signal plb_PLB_MWrDAck : std_logic_vector(0 to 3);
  signal plb_PLB_PAValid : std_logic;
  signal plb_PLB_RNW : std_logic;
  signal plb_PLB_Rst : std_logic;
  signal plb_PLB_SAValid : std_logic;
  signal plb_PLB_SMBusy : std_logic_vector(0 to 3);
  signal plb_PLB_SMErr : std_logic_vector(0 to 3);
  signal plb_PLB_abort : std_logic;
  signal plb_PLB_busLock : std_logic;
  signal plb_PLB_compress : std_logic;
  signal plb_PLB_guarded : std_logic;
  signal plb_PLB_lockErr : std_logic;
  signal plb_PLB_masterID : std_logic_vector(0 to 1);
  signal plb_PLB_ordered : std_logic;
  signal plb_PLB_pendPri : std_logic_vector(0 to 1);
  signal plb_PLB_pendReq : std_logic;
  signal plb_PLB_rdBurst : std_logic;
  signal plb_PLB_rdPrim : std_logic;
  signal plb_PLB_reqPri : std_logic_vector(0 to 1);
  signal plb_PLB_size : std_logic_vector(0 to 3);
  signal plb_PLB_type : std_logic_vector(0 to 2);
  signal plb_PLB_wrBurst : std_logic;
  signal plb_PLB_wrDBus : std_logic_vector(0 to 63);
  signal plb_PLB_wrPrim : std_logic;
  signal plb_Sl_MBusy : std_logic_vector(0 to 35);
  signal plb_Sl_MErr : std_logic_vector(0 to 35);
  signal plb_Sl_SSize : std_logic_vector(0 to 17);
  signal plb_Sl_addrAck : std_logic_vector(0 to 8);
  signal plb_Sl_rdBTerm : std_logic_vector(0 to 8);
  signal plb_Sl_rdComp : std_logic_vector(0 to 8);
  signal plb_Sl_rdDAck : std_logic_vector(0 to 8);
  signal plb_Sl_rdDBus : std_logic_vector(0 to 575);
  signal plb_Sl_rdWdAddr : std_logic_vector(0 to 35);
  signal plb_Sl_rearbitrate : std_logic_vector(0 to 8);
  signal plb_Sl_wait : std_logic_vector(0 to 8);
  signal plb_Sl_wrBTerm : std_logic_vector(0 to 8);
  signal plb_Sl_wrComp : std_logic_vector(0 to 8);
  signal plb_Sl_wrDAck : std_logic_vector(0 to 8);
  signal rs232_1_int : std_logic;
  signal rs232_2_int : std_logic;
  signal sys_bus_reset : std_logic_vector(0 to 0);
  signal sys_clk_n_s : std_logic;
  signal sys_clk_s : std_logic;
  signal sys_per_rst : std_logic_vector(0 to 0);
  signal tact : std_logic_vector(15 downto 0);

  attribute BOX_TYPE : STRING;
  attribute BOX_TYPE of dnepr_wrapper : component is "black_box";
  attribute BOX_TYPE of grid_gen_wrapper : component is "black_box";
  attribute BOX_TYPE of delay_meter_wrapper : component is "black_box";
  attribute BOX_TYPE of ft_fd_input_wrapper : component is "black_box";
  attribute BOX_TYPE of ppc405_1_wrapper : component is "black_box";
  attribute BOX_TYPE of ppc405_0_wrapper : component is "black_box";
  attribute BOX_TYPE of jtagppc_0_wrapper : component is "black_box";
  attribute BOX_TYPE of plb2opb_wrapper : component is "black_box";
  attribute BOX_TYPE of opb_wrapper : component is "black_box";
  attribute BOX_TYPE of plb_wrapper : component is "black_box";
  attribute BOX_TYPE of reset_block_wrapper : component is "black_box";
  attribute BOX_TYPE of system_clk_0_wrapper : component is "black_box";
  attribute BOX_TYPE of ddr_fb_dcm_wrapper : component is "black_box";
  attribute BOX_TYPE of ddr90_dcm_wrapper : component is "black_box";
  attribute BOX_TYPE of sys_dcm_wrapper : component is "black_box";
  attribute BOX_TYPE of plb_eth2_contr_wrapper : component is "black_box";
  attribute BOX_TYPE of plb_eth1_contr_wrapper : component is "black_box";
  attribute BOX_TYPE of opb_intc_0_wrapper : component is "black_box";
  attribute BOX_TYPE of opb_flash_wrapper : component is "black_box";
  attribute BOX_TYPE of boot_ppc_cntrl_wrapper : component is "black_box";
  attribute BOX_TYPE of boot_ppc_bram_wrapper : component is "black_box";
  attribute BOX_TYPE of plb_ddr_sdram_wrapper : component is "black_box";
  attribute BOX_TYPE of uart_tuts_wrapper : component is "black_box";
  attribute BOX_TYPE of rs232_1_wrapper : component is "black_box";
  attribute BOX_TYPE of rs232_2_wrapper : component is "black_box";
  attribute BOX_TYPE of gpio_leds_wrapper : component is "black_box";
  attribute BOX_TYPE of freq_detect_wrapper : component is "black_box";
  attribute BOX_TYPE of reg_version_wrapper : component is "black_box";
  attribute BOX_TYPE of f_gen_0_wrapper : component is "black_box";

begin

  -- Internal assignments

  ddr_feedback_s <= DDR_CLK_FB;
  UART_TUTS_RX <= dnepr_RX;
  dnepr_TX <= UART_TUTS_TX;
  clk_19_ext <= clk_19;
  clk_10_ext <= clk_10;
  delay_out <= delay_meter_signal_out;
  delay_meter_signal_in <= delay_in;
  dnepr_dRC_stop_pin <= dnepr_dRC_stop;
  dnepr_dRC_start_pin <= dnepr_dRC_start;
  dnepr_dTR_stop_pin <= dnepr_dTR_stop;
  dnepr_dTR_start_pin <= dnepr_dTR_start;
  dnepr_RC_stop_pin <= dnepr_RC_stop;
  dnepr_RC_start_pin <= dnepr_RC_start;
  dnepr_TR_stop_pin <= dnepr_TR_stop;
  dnepr_TR_start_pin <= dnepr_TR_start;
  plb_PLB2OPB_rearb(0 to 0) <= B"0";
  plb_PLB2OPB_rearb(1 to 1) <= B"0";
  plb_PLB2OPB_rearb(2 to 2) <= B"0";
  plb_PLB2OPB_rearb(3 to 3) <= B"0";
  plb_PLB2OPB_rearb(4 to 4) <= B"0";
  plb_PLB2OPB_rearb(6 to 6) <= B"0";
  plb_PLB2OPB_rearb(7 to 7) <= B"0";
  plb_PLB2OPB_rearb(8 to 8) <= B"0";
  DDR_CKE <= pgassign1(0);
  DDR_CSn <= pgassign2(0);
  DDR_Clk <= pgassign3(0);
  DDR_Clkn <= pgassign4(0);
  pgassign5(5) <= ft_fd_input_ft_int;
  pgassign5(4) <= UART_TUTS_int;
  pgassign5(3) <= rs232_2_int;
  pgassign5(2) <= rs232_1_int;
  pgassign5(1) <= eth_2_int;
  pgassign5(0) <= eth_1_int;
  pgassign6(0) <= ft_ok;
  pgassign6(1) <= fd_ok;
  net_gnd0 <= '0';
  net_gnd1(0 to 0) <= B"0";
  net_gnd10(0 to 9) <= B"0000000000";
  net_gnd2(0 to 1) <= B"00";
  net_gnd21(0 to 20) <= B"000000000000000000000";
  net_gnd29(0 to 28) <= B"00000000000000000000000000000";
  net_gnd3(0 to 2) <= B"000";
  net_gnd32(0 to 31) <= B"00000000000000000000000000000000";
  net_gnd4(0 to 3) <= B"0000";
  net_gnd64(0 to 63) <= B"0000000000000000000000000000000000000000000000000000000000000000";
  net_gnd7(0 to 6) <= B"0000000";
  net_gnd8(0 to 7) <= B"00000000";
  net_vcc0 <= '1';
  net_vcc1(0 to 0) <= B"1";
  net_vcc8(0 to 7) <= B"11111111";

  dnepr : dnepr_wrapper
    port map (
      tact => tact,
      discr => discr,
      TR_start => dnepr_TR_start,
      TR_stop => dnepr_TR_stop,
      RC_start => dnepr_RC_start,
      RC_stop => dnepr_RC_stop,
      dTR_start => dnepr_dTR_start,
      dTR_stop => dnepr_dTR_stop,
      dRC_start => dnepr_dRC_start,
      dRC_stop => dnepr_dRC_stop,
      PLB_Clk => sys_clk_s,
      PLB_Rst => plb_PLB_Rst,
      Sl_addrAck => plb_Sl_addrAck(0),
      Sl_MBusy => plb_Sl_MBusy(0 to 3),
      Sl_MErr => plb_Sl_MErr(0 to 3),
      Sl_rdBTerm => plb_Sl_rdBTerm(0),
      Sl_rdComp => plb_Sl_rdComp(0),
      Sl_rdDAck => plb_Sl_rdDAck(0),
      Sl_rdDBus => plb_Sl_rdDBus(0 to 63),
      Sl_rdWdAddr => plb_Sl_rdWdAddr(0 to 3),
      Sl_rearbitrate => plb_Sl_rearbitrate(0),
      Sl_SSize => plb_Sl_SSize(0 to 1),
      Sl_wait => plb_Sl_wait(0),
      Sl_wrBTerm => plb_Sl_wrBTerm(0),
      Sl_wrComp => plb_Sl_wrComp(0),
      Sl_wrDAck => plb_Sl_wrDAck(0),
      PLB_abort => plb_PLB_abort,
      PLB_ABus => plb_PLB_ABus,
      PLB_BE => plb_PLB_BE,
      PLB_busLock => plb_PLB_busLock,
      PLB_compress => plb_PLB_compress,
      PLB_guarded => plb_PLB_guarded,
      PLB_lockErr => plb_PLB_lockErr,
      PLB_masterID => plb_PLB_masterID,
      PLB_MSize => plb_PLB_MSize,
      PLB_ordered => plb_PLB_ordered,
      PLB_PAValid => plb_PLB_PAValid,
      PLB_pendPri => plb_PLB_pendPri,
      PLB_pendReq => plb_PLB_pendReq,
      PLB_rdBurst => plb_PLB_rdBurst,
      PLB_rdPrim => plb_PLB_rdPrim,
      PLB_reqPri => plb_PLB_reqPri,
      PLB_RNW => plb_PLB_RNW,
      PLB_SAValid => plb_PLB_SAValid,
      PLB_size => plb_PLB_size,
      PLB_type => plb_PLB_type,
      PLB_wrBurst => plb_PLB_wrBurst,
      PLB_wrDBus => plb_PLB_wrDBus,
      PLB_wrPrim => plb_PLB_wrPrim
    );

  grid_gen : grid_gen_wrapper
    port map (
      clk_19 => edge_tact_clk,
      clk_1_25 => edge_discr_clk,
      tact => tact,
      discr => discr,
      PLB_Clk => sys_clk_s,
      PLB_Rst => plb_PLB_Rst,
      Sl_addrAck => plb_Sl_addrAck(1),
      Sl_MBusy => plb_Sl_MBusy(4 to 7),
      Sl_MErr => plb_Sl_MErr(4 to 7),
      Sl_rdBTerm => plb_Sl_rdBTerm(1),
      Sl_rdComp => plb_Sl_rdComp(1),
      Sl_rdDAck => plb_Sl_rdDAck(1),
      Sl_rdDBus => plb_Sl_rdDBus(64 to 127),
      Sl_rdWdAddr => plb_Sl_rdWdAddr(4 to 7),
      Sl_rearbitrate => plb_Sl_rearbitrate(1),
      Sl_SSize => plb_Sl_SSize(2 to 3),
      Sl_wait => plb_Sl_wait(1),
      Sl_wrBTerm => plb_Sl_wrBTerm(1),
      Sl_wrComp => plb_Sl_wrComp(1),
      Sl_wrDAck => plb_Sl_wrDAck(1),
      PLB_abort => plb_PLB_abort,
      PLB_ABus => plb_PLB_ABus,
      PLB_BE => plb_PLB_BE,
      PLB_busLock => plb_PLB_busLock,
      PLB_compress => plb_PLB_compress,
      PLB_guarded => plb_PLB_guarded,
      PLB_lockErr => plb_PLB_lockErr,
      PLB_masterID => plb_PLB_masterID,
      PLB_MSize => plb_PLB_MSize,
      PLB_ordered => plb_PLB_ordered,
      PLB_PAValid => plb_PLB_PAValid,
      PLB_pendPri => plb_PLB_pendPri,
      PLB_pendReq => plb_PLB_pendReq,
      PLB_rdBurst => plb_PLB_rdBurst,
      PLB_rdPrim => plb_PLB_rdPrim,
      PLB_reqPri => plb_PLB_reqPri,
      PLB_RNW => plb_PLB_RNW,
      PLB_SAValid => plb_PLB_SAValid,
      PLB_size => plb_PLB_size,
      PLB_type => plb_PLB_type,
      PLB_wrBurst => plb_PLB_wrBurst,
      PLB_wrDBus => plb_PLB_wrDBus,
      PLB_wrPrim => plb_PLB_wrPrim
    );

  delay_meter : delay_meter_wrapper
    port map (
      ft_edge => edge_tact_clk,
      signal_in => delay_meter_signal_in,
      signal_out => delay_meter_signal_out,
      delay => open,
      PLB_Clk => sys_clk_s,
      PLB_Rst => plb_PLB_Rst,
      Sl_addrAck => plb_Sl_addrAck(4),
      Sl_MBusy => plb_Sl_MBusy(16 to 19),
      Sl_MErr => plb_Sl_MErr(16 to 19),
      Sl_rdBTerm => plb_Sl_rdBTerm(4),
      Sl_rdComp => plb_Sl_rdComp(4),
      Sl_rdDAck => plb_Sl_rdDAck(4),
      Sl_rdDBus => plb_Sl_rdDBus(256 to 319),
      Sl_rdWdAddr => plb_Sl_rdWdAddr(16 to 19),
      Sl_rearbitrate => plb_Sl_rearbitrate(4),
      Sl_SSize => plb_Sl_SSize(8 to 9),
      Sl_wait => plb_Sl_wait(4),
      Sl_wrBTerm => plb_Sl_wrBTerm(4),
      Sl_wrComp => plb_Sl_wrComp(4),
      Sl_wrDAck => plb_Sl_wrDAck(4),
      PLB_abort => plb_PLB_abort,
      PLB_ABus => plb_PLB_ABus,
      PLB_BE => plb_PLB_BE,
      PLB_busLock => plb_PLB_busLock,
      PLB_compress => plb_PLB_compress,
      PLB_guarded => plb_PLB_guarded,
      PLB_lockErr => plb_PLB_lockErr,
      PLB_masterID => plb_PLB_masterID,
      PLB_MSize => plb_PLB_MSize,
      PLB_ordered => plb_PLB_ordered,
      PLB_PAValid => plb_PLB_PAValid,
      PLB_pendPri => plb_PLB_pendPri,
      PLB_pendReq => plb_PLB_pendReq,
      PLB_rdBurst => plb_PLB_rdBurst,
      PLB_rdPrim => plb_PLB_rdPrim,
      PLB_reqPri => plb_PLB_reqPri,
      PLB_RNW => plb_PLB_RNW,
      PLB_SAValid => plb_PLB_SAValid,
      PLB_size => plb_PLB_size,
      PLB_type => plb_PLB_type,
      PLB_wrBurst => plb_PLB_wrBurst,
      PLB_wrDBus => plb_PLB_wrDBus,
      PLB_wrPrim => plb_PLB_wrPrim
    );

  ft_fd_input : ft_fd_input_wrapper
    port map (
      rst => sys_bus_reset(0),
      clk => sys_clk_s,
      clk_19 => clk_19_int,
      clk_10M => clk_10_int,
      ft_edge => edge_tact_clk,
      fd_edge => edge_discr_clk,
      ft_int => ft_fd_input_ft_int,
      ft_ok => ft_ok,
      fd_ok => fd_ok
    );

  ppc405_1 : ppc405_1_wrapper
    port map (
      C405CPMCORESLEEPREQ => open,
      C405CPMMSRCE => open,
      C405CPMMSREE => open,
      C405CPMTIMERIRQ => open,
      C405CPMTIMERRESETREQ => open,
      C405XXXMACHINECHECK => open,
      CPMC405CLOCK => net_gnd0,
      CPMC405CORECLKINACTIVE => net_gnd0,
      CPMC405CPUCLKEN => net_vcc0,
      CPMC405JTAGCLKEN => net_vcc0,
      CPMC405TIMERCLKEN => net_vcc0,
      CPMC405TIMERTICK => net_vcc0,
      MCBCPUCLKEN => net_vcc0,
      MCBTIMEREN => net_vcc0,
      MCPPCRST => net_vcc0,
      PLBCLK => net_gnd0,
      DCRCLK => net_gnd0,
      C405RSTCHIPRESETREQ => open,
      C405RSTCORERESETREQ => open,
      C405RSTSYSRESETREQ => open,
      RSTC405RESETCHIP => net_gnd0,
      RSTC405RESETCORE => net_gnd0,
      RSTC405RESETSYS => net_gnd0,
      C405PLBICUABUS => open,
      C405PLBICUBE => open,
      C405PLBICURNW => open,
      C405PLBICUABORT => open,
      C405PLBICUBUSLOCK => open,
      C405PLBICUU0ATTR => open,
      C405PLBICUGUARDED => open,
      C405PLBICULOCKERR => open,
      C405PLBICUMSIZE => open,
      C405PLBICUORDERED => open,
      C405PLBICUPRIORITY => open,
      C405PLBICURDBURST => open,
      C405PLBICUREQUEST => open,
      C405PLBICUSIZE => open,
      C405PLBICUTYPE => open,
      C405PLBICUWRBURST => open,
      C405PLBICUWRDBUS => open,
      C405PLBICUCACHEABLE => open,
      PLBC405ICUADDRACK => net_gnd0,
      PLBC405ICUBUSY => net_gnd0,
      PLBC405ICUERR => net_gnd0,
      PLBC405ICURDBTERM => net_gnd0,
      PLBC405ICURDDACK => net_gnd0,
      PLBC405ICURDDBUS => net_gnd64,
      PLBC405ICURDWDADDR => net_gnd4,
      PLBC405ICUREARBITRATE => net_gnd0,
      PLBC405ICUWRBTERM => net_gnd0,
      PLBC405ICUWRDACK => net_gnd0,
      PLBC405ICUSSIZE => net_gnd2,
      PLBC405ICUSERR => net_gnd0,
      PLBC405ICUSBUSYS => net_gnd0,
      C405PLBDCUABUS => open,
      C405PLBDCUBE => open,
      C405PLBDCURNW => open,
      C405PLBDCUABORT => open,
      C405PLBDCUBUSLOCK => open,
      C405PLBDCUU0ATTR => open,
      C405PLBDCUGUARDED => open,
      C405PLBDCULOCKERR => open,
      C405PLBDCUMSIZE => open,
      C405PLBDCUORDERED => open,
      C405PLBDCUPRIORITY => open,
      C405PLBDCURDBURST => open,
      C405PLBDCUREQUEST => open,
      C405PLBDCUSIZE => open,
      C405PLBDCUTYPE => open,
      C405PLBDCUWRBURST => open,
      C405PLBDCUWRDBUS => open,
      C405PLBDCUCACHEABLE => open,
      C405PLBDCUWRITETHRU => open,
      PLBC405DCUADDRACK => net_gnd0,
      PLBC405DCUBUSY => net_gnd0,
      PLBC405DCUERR => net_gnd0,
      PLBC405DCURDBTERM => net_gnd0,
      PLBC405DCURDDACK => net_gnd0,
      PLBC405DCURDDBUS => net_gnd64,
      PLBC405DCURDWDADDR => net_gnd4,
      PLBC405DCUREARBITRATE => net_gnd0,
      PLBC405DCUWRBTERM => net_gnd0,
      PLBC405DCUWRDACK => net_gnd0,
      PLBC405DCUSSIZE => net_gnd2,
      PLBC405DCUSERR => net_gnd0,
      PLBC405DCUSBUSYS => net_gnd0,
      BRAMDSOCMCLK => net_gnd0,
      BRAMDSOCMRDDBUS => net_gnd32,
      DSARCVALUE => net_gnd8,
      DSCNTLVALUE => net_gnd8,
      DSOCMBRAMABUS => open,
      DSOCMBRAMBYTEWRITE => open,
      DSOCMBRAMEN => open,
      DSOCMBRAMWRDBUS => open,
      DSOCMBUSY => open,
      BRAMISOCMCLK => net_gnd0,
      BRAMISOCMRDDBUS => net_gnd64,
      ISARCVALUE => net_gnd8,
      ISCNTLVALUE => net_gnd8,
      ISOCMBRAMEN => open,
      ISOCMBRAMEVENWRITEEN => open,
      ISOCMBRAMODDWRITEEN => open,
      ISOCMBRAMRDABUS => open,
      ISOCMBRAMWRABUS => open,
      ISOCMBRAMWRDBUS => open,
      C405DCRABUS => open,
      C405DCRDBUSOUT => open,
      C405DCRREAD => open,
      C405DCRWRITE => open,
      DCRC405ACK => net_gnd0,
      DCRC405DBUSIN => net_gnd32,
      EICC405CRITINPUTIRQ => net_gnd0,
      EICC405EXTINPUTIRQ => net_gnd0,
      C405JTGCAPTUREDR => open,
      C405JTGEXTEST => open,
      C405JTGPGMOUT => open,
      C405JTGSHIFTDR => open,
      C405JTGTDO => jtagppc_0_1_C405JTGTDO,
      C405JTGTDOEN => jtagppc_0_1_C405JTGTDOEN,
      C405JTGUPDATEDR => open,
      MCBJTAGEN => net_vcc0,
      JTGC405BNDSCANTDO => net_gnd0,
      JTGC405TCK => jtagppc_0_1_JTGC405TCK,
      JTGC405TDI => jtagppc_0_1_JTGC405TDI,
      JTGC405TMS => jtagppc_0_1_JTGC405TMS,
      JTGC405TRSTNEG => jtagppc_0_1_JTGC405TRSTNEG,
      C405DBGMSRWE => open,
      C405DBGSTOPACK => open,
      C405DBGWBCOMPLETE => open,
      C405DBGWBFULL => open,
      C405DBGWBIAR => open,
      DBGC405DEBUGHALT => net_gnd0,
      DBGC405EXTBUSHOLDACK => net_gnd0,
      DBGC405UNCONDDEBUGEVENT => net_gnd0,
      C405TRCCYCLE => open,
      C405TRCEVENEXECUTIONSTATUS => open,
      C405TRCODDEXECUTIONSTATUS => open,
      C405TRCTRACESTATUS => open,
      C405TRCTRIGGEREVENTOUT => open,
      C405TRCTRIGGEREVENTTYPE => open,
      TRCC405TRACEDISABLE => net_gnd0,
      TRCC405TRIGGEREVENTIN => net_gnd0
    );

  ppc405_0 : ppc405_0_wrapper
    port map (
      C405CPMCORESLEEPREQ => open,
      C405CPMMSRCE => open,
      C405CPMMSREE => open,
      C405CPMTIMERIRQ => open,
      C405CPMTIMERRESETREQ => open,
      C405XXXMACHINECHECK => open,
      CPMC405CLOCK => cpu_clk,
      CPMC405CORECLKINACTIVE => net_gnd0,
      CPMC405CPUCLKEN => net_vcc0,
      CPMC405JTAGCLKEN => net_vcc0,
      CPMC405TIMERCLKEN => net_vcc0,
      CPMC405TIMERTICK => net_vcc0,
      MCBCPUCLKEN => net_vcc0,
      MCBTIMEREN => net_vcc0,
      MCPPCRST => net_vcc0,
      PLBCLK => sys_clk_s,
      DCRCLK => net_gnd0,
      C405RSTCHIPRESETREQ => C405RSTCHIPRESETREQ,
      C405RSTCORERESETREQ => C405RSTCORERESETREQ,
      C405RSTSYSRESETREQ => C405RSTSYSRESETREQ,
      RSTC405RESETCHIP => RSTC405RESETCHIP,
      RSTC405RESETCORE => RSTC405RESETCORE,
      RSTC405RESETSYS => RSTC405RESETSYS,
      C405PLBICUABUS => plb_M_ABus(32 to 63),
      C405PLBICUBE => plb_M_BE(8 to 15),
      C405PLBICURNW => plb_M_RNW(1),
      C405PLBICUABORT => plb_M_abort(1),
      C405PLBICUBUSLOCK => plb_M_busLock(1),
      C405PLBICUU0ATTR => plb_M_compress(1),
      C405PLBICUGUARDED => plb_M_guarded(1),
      C405PLBICULOCKERR => plb_M_lockErr(1),
      C405PLBICUMSIZE => plb_M_MSize(2 to 3),
      C405PLBICUORDERED => plb_M_ordered(1),
      C405PLBICUPRIORITY => plb_M_priority(2 to 3),
      C405PLBICURDBURST => plb_M_rdBurst(1),
      C405PLBICUREQUEST => plb_M_request(1),
      C405PLBICUSIZE => plb_M_size(4 to 7),
      C405PLBICUTYPE => plb_M_type(3 to 5),
      C405PLBICUWRBURST => plb_M_wrBurst(1),
      C405PLBICUWRDBUS => plb_M_wrDBus(64 to 127),
      C405PLBICUCACHEABLE => open,
      PLBC405ICUADDRACK => plb_PLB_MAddrAck(1),
      PLBC405ICUBUSY => plb_PLB_MBusy(1),
      PLBC405ICUERR => plb_PLB_MErr(1),
      PLBC405ICURDBTERM => plb_PLB_MRdBTerm(1),
      PLBC405ICURDDACK => plb_PLB_MRdDAck(1),
      PLBC405ICURDDBUS => plb_PLB_MRdDBus(64 to 127),
      PLBC405ICURDWDADDR => plb_PLB_MRdWdAddr(4 to 7),
      PLBC405ICUREARBITRATE => plb_PLB_MRearbitrate(1),
      PLBC405ICUWRBTERM => plb_PLB_MWrBTerm(1),
      PLBC405ICUWRDACK => plb_PLB_MWrDAck(1),
      PLBC405ICUSSIZE => plb_PLB_MSSize(2 to 3),
      PLBC405ICUSERR => plb_PLB_SMErr(1),
      PLBC405ICUSBUSYS => plb_PLB_SMBusy(1),
      C405PLBDCUABUS => plb_M_ABus(0 to 31),
      C405PLBDCUBE => plb_M_BE(0 to 7),
      C405PLBDCURNW => plb_M_RNW(0),
      C405PLBDCUABORT => plb_M_abort(0),
      C405PLBDCUBUSLOCK => plb_M_busLock(0),
      C405PLBDCUU0ATTR => plb_M_compress(0),
      C405PLBDCUGUARDED => plb_M_guarded(0),
      C405PLBDCULOCKERR => plb_M_lockErr(0),
      C405PLBDCUMSIZE => plb_M_MSize(0 to 1),
      C405PLBDCUORDERED => plb_M_ordered(0),
      C405PLBDCUPRIORITY => plb_M_priority(0 to 1),
      C405PLBDCURDBURST => plb_M_rdBurst(0),
      C405PLBDCUREQUEST => plb_M_request(0),
      C405PLBDCUSIZE => plb_M_size(0 to 3),
      C405PLBDCUTYPE => plb_M_type(0 to 2),
      C405PLBDCUWRBURST => plb_M_wrBurst(0),
      C405PLBDCUWRDBUS => plb_M_wrDBus(0 to 63),
      C405PLBDCUCACHEABLE => open,
      C405PLBDCUWRITETHRU => open,
      PLBC405DCUADDRACK => plb_PLB_MAddrAck(0),
      PLBC405DCUBUSY => plb_PLB_MBusy(0),
      PLBC405DCUERR => plb_PLB_MErr(0),
      PLBC405DCURDBTERM => plb_PLB_MRdBTerm(0),
      PLBC405DCURDDACK => plb_PLB_MRdDAck(0),
      PLBC405DCURDDBUS => plb_PLB_MRdDBus(0 to 63),
      PLBC405DCURDWDADDR => plb_PLB_MRdWdAddr(0 to 3),
      PLBC405DCUREARBITRATE => plb_PLB_MRearbitrate(0),
      PLBC405DCUWRBTERM => plb_PLB_MWrBTerm(0),
      PLBC405DCUWRDACK => plb_PLB_MWrDAck(0),
      PLBC405DCUSSIZE => plb_PLB_MSSize(0 to 1),
      PLBC405DCUSERR => plb_PLB_SMErr(0),
      PLBC405DCUSBUSYS => plb_PLB_SMBusy(0),
      BRAMDSOCMCLK => net_gnd0,
      BRAMDSOCMRDDBUS => net_gnd32,
      DSARCVALUE => net_gnd8,
      DSCNTLVALUE => net_gnd8,
      DSOCMBRAMABUS => open,
      DSOCMBRAMBYTEWRITE => open,
      DSOCMBRAMEN => open,
      DSOCMBRAMWRDBUS => open,
      DSOCMBUSY => open,
      BRAMISOCMCLK => net_gnd0,
      BRAMISOCMRDDBUS => net_gnd64,
      ISARCVALUE => net_gnd8,
      ISCNTLVALUE => net_gnd8,
      ISOCMBRAMEN => open,
      ISOCMBRAMEVENWRITEEN => open,
      ISOCMBRAMODDWRITEEN => open,
      ISOCMBRAMRDABUS => open,
      ISOCMBRAMWRABUS => open,
      ISOCMBRAMWRDBUS => open,
      C405DCRABUS => open,
      C405DCRDBUSOUT => open,
      C405DCRREAD => open,
      C405DCRWRITE => open,
      DCRC405ACK => net_gnd0,
      DCRC405DBUSIN => net_gnd32,
      EICC405CRITINPUTIRQ => net_gnd0,
      EICC405EXTINPUTIRQ => EICC405EXTINPUTIRQ,
      C405JTGCAPTUREDR => open,
      C405JTGEXTEST => open,
      C405JTGPGMOUT => open,
      C405JTGSHIFTDR => open,
      C405JTGTDO => jtagppc_0_0_C405JTGTDO,
      C405JTGTDOEN => jtagppc_0_0_C405JTGTDOEN,
      C405JTGUPDATEDR => open,
      MCBJTAGEN => net_vcc0,
      JTGC405BNDSCANTDO => net_gnd0,
      JTGC405TCK => jtagppc_0_0_JTGC405TCK,
      JTGC405TDI => jtagppc_0_0_JTGC405TDI,
      JTGC405TMS => jtagppc_0_0_JTGC405TMS,
      JTGC405TRSTNEG => jtagppc_0_0_JTGC405TRSTNEG,
      C405DBGMSRWE => open,
      C405DBGSTOPACK => open,
      C405DBGWBCOMPLETE => open,
      C405DBGWBFULL => open,
      C405DBGWBIAR => open,
      DBGC405DEBUGHALT => net_gnd0,
      DBGC405EXTBUSHOLDACK => net_gnd0,
      DBGC405UNCONDDEBUGEVENT => net_gnd0,
      C405TRCCYCLE => open,
      C405TRCEVENEXECUTIONSTATUS => open,
      C405TRCODDEXECUTIONSTATUS => open,
      C405TRCTRACESTATUS => open,
      C405TRCTRIGGEREVENTOUT => open,
      C405TRCTRIGGEREVENTTYPE => open,
      TRCC405TRACEDISABLE => net_gnd0,
      TRCC405TRIGGEREVENTIN => net_gnd0
    );

  jtagppc_0 : jtagppc_0_wrapper
    port map (
      TRSTNEG => net_vcc0,
      HALTNEG0 => net_vcc0,
      DBGC405DEBUGHALT0 => open,
      HALTNEG1 => net_vcc0,
      DBGC405DEBUGHALT1 => open,
      C405JTGTDO0 => jtagppc_0_0_C405JTGTDO,
      C405JTGTDOEN0 => jtagppc_0_0_C405JTGTDOEN,
      JTGC405TCK0 => jtagppc_0_0_JTGC405TCK,
      JTGC405TDI0 => jtagppc_0_0_JTGC405TDI,
      JTGC405TMS0 => jtagppc_0_0_JTGC405TMS,
      JTGC405TRSTNEG0 => jtagppc_0_0_JTGC405TRSTNEG,
      C405JTGTDO1 => jtagppc_0_1_C405JTGTDO,
      C405JTGTDOEN1 => jtagppc_0_1_C405JTGTDOEN,
      JTGC405TCK1 => jtagppc_0_1_JTGC405TCK,
      JTGC405TDI1 => jtagppc_0_1_JTGC405TDI,
      JTGC405TMS1 => jtagppc_0_1_JTGC405TMS,
      JTGC405TRSTNEG1 => jtagppc_0_1_JTGC405TRSTNEG
    );

  plb2opb : plb2opb_wrapper
    port map (
      PLB_Clk => sys_clk_s,
      OPB_Clk => sys_clk_s,
      PLB_Rst => plb_PLB_Rst,
      OPB_Rst => opb_OPB_Rst,
      Bus_Error_Det => open,
      BGI_Trans_Abort => open,
      BGO_dcrAck => open,
      BGO_dcrDBus => open,
      DCR_ABus => net_gnd10,
      DCR_DBus => net_gnd32,
      DCR_Read => net_gnd0,
      DCR_Write => net_gnd0,
      BGO_addrAck => plb_Sl_addrAck(5),
      BGO_MErr => plb_Sl_MErr(20 to 23),
      BGO_MBusy => plb_Sl_MBusy(20 to 23),
      BGO_rdBTerm => plb_Sl_rdBTerm(5),
      BGO_rdComp => plb_Sl_rdComp(5),
      BGO_rdDAck => plb_Sl_rdDAck(5),
      BGO_rdDBus => plb_Sl_rdDBus(320 to 383),
      BGO_rdWdAddr => plb_Sl_rdWdAddr(20 to 23),
      BGO_rearbitrate => plb_Sl_rearbitrate(5),
      BGO_SSize => plb_Sl_SSize(10 to 11),
      BGO_wait => plb_Sl_wait(5),
      BGO_wrBTerm => plb_Sl_wrBTerm(5),
      BGO_wrComp => plb_Sl_wrComp(5),
      BGO_wrDAck => plb_Sl_wrDAck(5),
      PLB_abort => plb_PLB_abort,
      PLB_ABus => plb_PLB_ABus,
      PLB_BE => plb_PLB_BE,
      PLB_busLock => plb_PLB_busLock,
      PLB_compress => plb_PLB_compress,
      PLB_guarded => plb_PLB_guarded,
      PLB_lockErr => plb_PLB_lockErr,
      PLB_masterID => plb_PLB_masterID,
      PLB_MSize => plb_PLB_MSize,
      PLB_ordered => plb_PLB_ordered,
      PLB_PAValid => plb_PLB_PAValid,
      PLB_rdBurst => plb_PLB_rdBurst,
      PLB_rdPrim => plb_PLB_rdPrim,
      PLB_RNW => plb_PLB_RNW,
      PLB_SAValid => plb_PLB_SAValid,
      PLB_size => plb_PLB_size,
      PLB_type => plb_PLB_type,
      PLB_wrBurst => plb_PLB_wrBurst,
      PLB_wrDBus => plb_PLB_wrDBus,
      PLB_wrPrim => plb_PLB_wrPrim,
      PLB2OPB_rearb => plb_PLB2OPB_rearb(5),
      BGO_ABus => opb_M_ABus,
      BGO_BE => opb_M_BE,
      BGO_busLock => opb_M_busLock(0),
      BGO_DBus => opb_M_DBus,
      BGO_request => opb_M_request(0),
      BGO_RNW => opb_M_RNW(0),
      BGO_select => opb_M_select(0),
      BGO_seqAddr => opb_M_seqAddr(0),
      OPB_DBus => opb_OPB_DBus,
      OPB_errAck => opb_OPB_errAck,
      OPB_MnGrant => opb_OPB_MGrant(0),
      OPB_retry => opb_OPB_retry,
      OPB_timeout => opb_OPB_timeout,
      OPB_xferAck => opb_OPB_xferAck
    );

  opb : opb_wrapper
    port map (
      OPB_Clk => sys_clk_s,
      OPB_Rst => opb_OPB_Rst,
      SYS_Rst => sys_bus_reset(0),
      Debug_SYS_Rst => net_gnd0,
      WDT_Rst => net_gnd0,
      M_ABus => opb_M_ABus,
      M_BE => opb_M_BE,
      M_beXfer => net_gnd1(0 to 0),
      M_busLock => opb_M_busLock(0 to 0),
      M_DBus => opb_M_DBus,
      M_DBusEn => net_gnd1(0 to 0),
      M_DBusEn32_63 => net_vcc1(0 to 0),
      M_dwXfer => net_gnd1(0 to 0),
      M_fwXfer => net_gnd1(0 to 0),
      M_hwXfer => net_gnd1(0 to 0),
      M_request => opb_M_request(0 to 0),
      M_RNW => opb_M_RNW(0 to 0),
      M_select => opb_M_select(0 to 0),
      M_seqAddr => opb_M_seqAddr(0 to 0),
      Sl_beAck => net_gnd8,
      Sl_DBus => opb_Sl_DBus,
      Sl_DBusEn => net_vcc8,
      Sl_DBusEn32_63 => net_vcc8,
      Sl_errAck => opb_Sl_errAck,
      Sl_dwAck => net_gnd8,
      Sl_fwAck => net_gnd8,
      Sl_hwAck => net_gnd8,
      Sl_retry => opb_Sl_retry,
      Sl_toutSup => opb_Sl_toutSup,
      Sl_xferAck => opb_Sl_xferAck,
      OPB_MRequest => open,
      OPB_ABus => opb_OPB_ABus,
      OPB_BE => opb_OPB_BE,
      OPB_beXfer => open,
      OPB_beAck => open,
      OPB_busLock => open,
      OPB_rdDBus => open,
      OPB_wrDBus => open,
      OPB_DBus => opb_OPB_DBus,
      OPB_errAck => opb_OPB_errAck,
      OPB_dwAck => open,
      OPB_dwXfer => open,
      OPB_fwAck => open,
      OPB_fwXfer => open,
      OPB_hwAck => open,
      OPB_hwXfer => open,
      OPB_MGrant => opb_OPB_MGrant(0 to 0),
      OPB_pendReq => open,
      OPB_retry => opb_OPB_retry,
      OPB_RNW => opb_OPB_RNW,
      OPB_select => opb_OPB_select,
      OPB_seqAddr => opb_OPB_seqAddr,
      OPB_timeout => opb_OPB_timeout,
      OPB_toutSup => open,
      OPB_xferAck => opb_OPB_xferAck
    );

  plb : plb_wrapper
    port map (
      PLB_Clk => sys_clk_s,
      SYS_Rst => sys_bus_reset(0),
      PLB_Rst => plb_PLB_Rst,
      PLB_dcrAck => open,
      PLB_dcrDBus => open,
      DCR_ABus => net_gnd10,
      DCR_DBus => net_gnd32,
      DCR_Read => net_gnd0,
      DCR_Write => net_gnd0,
      M_ABus => plb_M_ABus,
      M_BE => plb_M_BE,
      M_RNW => plb_M_RNW,
      M_abort => plb_M_abort,
      M_busLock => plb_M_busLock,
      M_compress => plb_M_compress,
      M_guarded => plb_M_guarded,
      M_lockErr => plb_M_lockErr,
      M_MSize => plb_M_MSize,
      M_ordered => plb_M_ordered,
      M_priority => plb_M_priority,
      M_rdBurst => plb_M_rdBurst,
      M_request => plb_M_request,
      M_size => plb_M_size,
      M_type => plb_M_type,
      M_wrBurst => plb_M_wrBurst,
      M_wrDBus => plb_M_wrDBus,
      Sl_addrAck => plb_Sl_addrAck,
      Sl_MErr => plb_Sl_MErr,
      Sl_MBusy => plb_Sl_MBusy,
      Sl_rdBTerm => plb_Sl_rdBTerm,
      Sl_rdComp => plb_Sl_rdComp,
      Sl_rdDAck => plb_Sl_rdDAck,
      Sl_rdDBus => plb_Sl_rdDBus,
      Sl_rdWdAddr => plb_Sl_rdWdAddr,
      Sl_rearbitrate => plb_Sl_rearbitrate,
      Sl_SSize => plb_Sl_SSize,
      Sl_wait => plb_Sl_wait,
      Sl_wrBTerm => plb_Sl_wrBTerm,
      Sl_wrComp => plb_Sl_wrComp,
      Sl_wrDAck => plb_Sl_wrDAck,
      PLB_ABus => plb_PLB_ABus,
      PLB_BE => plb_PLB_BE,
      PLB_MAddrAck => plb_PLB_MAddrAck,
      PLB_MBusy => plb_PLB_MBusy,
      PLB_MErr => plb_PLB_MErr,
      PLB_MRdBTerm => plb_PLB_MRdBTerm,
      PLB_MRdDAck => plb_PLB_MRdDAck,
      PLB_MRdDBus => plb_PLB_MRdDBus,
      PLB_MRdWdAddr => plb_PLB_MRdWdAddr,
      PLB_MRearbitrate => plb_PLB_MRearbitrate,
      PLB_MWrBTerm => plb_PLB_MWrBTerm,
      PLB_MWrDAck => plb_PLB_MWrDAck,
      PLB_MSSize => plb_PLB_MSSize,
      PLB_PAValid => plb_PLB_PAValid,
      PLB_RNW => plb_PLB_RNW,
      PLB_SAValid => plb_PLB_SAValid,
      PLB_abort => plb_PLB_abort,
      PLB_busLock => plb_PLB_busLock,
      PLB_compress => plb_PLB_compress,
      PLB_guarded => plb_PLB_guarded,
      PLB_lockErr => plb_PLB_lockErr,
      PLB_masterID => plb_PLB_masterID,
      PLB_MSize => plb_PLB_MSize,
      PLB_ordered => plb_PLB_ordered,
      PLB_pendPri => plb_PLB_pendPri,
      PLB_pendReq => plb_PLB_pendReq,
      PLB_rdBurst => plb_PLB_rdBurst,
      PLB_rdPrim => plb_PLB_rdPrim,
      PLB_reqPri => plb_PLB_reqPri,
      PLB_size => plb_PLB_size,
      PLB_type => plb_PLB_type,
      PLB_wrBurst => plb_PLB_wrBurst,
      PLB_wrDBus => plb_PLB_wrDBus,
      PLB_wrPrim => plb_PLB_wrPrim,
      PLB_SaddrAck => open,
      PLB_SMErr => plb_PLB_SMErr,
      PLB_SMBusy => plb_PLB_SMBusy,
      PLB_SrdBTerm => open,
      PLB_SrdComp => open,
      PLB_SrdDAck => open,
      PLB_SrdDBus => open,
      PLB_SrdWdAddr => open,
      PLB_Srearbitrate => open,
      PLB_Sssize => open,
      PLB_Swait => open,
      PLB_SwrBTerm => open,
      PLB_SwrComp => open,
      PLB_SwrDAck => open,
      PLB2OPB_rearb => plb_PLB2OPB_rearb,
      ArbAddrVldReg => open,
      Bus_Error_Det => open
    );

  reset_block : reset_block_wrapper
    port map (
      Slowest_sync_clk => sys_clk_s,
      Ext_Reset_In => net_gnd0,
      Aux_Reset_In => net_gnd0,
      Core_Reset_Req => C405RSTCORERESETREQ,
      Chip_Reset_Req => C405RSTCHIPRESETREQ,
      System_Reset_Req => C405RSTSYSRESETREQ,
      Dcm_locked => dcm_2_lock,
      Rstc405resetcore => RSTC405RESETCORE,
      Rstc405resetchip => RSTC405RESETCHIP,
      Rstc405resetsys => RSTC405RESETSYS,
      Bus_Struct_Reset => sys_bus_reset(0 to 0),
      Peripheral_Reset => sys_per_rst(0 to 0)
    );

  system_clk_0 : system_clk_0_wrapper
    port map (
      clk_in_p => LVPECLK_p,
      clk_in_n => LVPECLK_n,
      clk_out => dcm_clk_s,
      LEDS_OPB_GPIO => open,
      J51_ZOUT => open,
      RX => net_gnd0,
      TX => open,
      PPCI_SYS_1_ren => open,
      PPCI_SYS_2_ren => open,
      PPCI_AD_5_ren => open,
      PPCI_SYS_IN => net_gnd29,
      PPCI_AD_IN => net_gnd21
    );

  ddr_fb_dcm : ddr_fb_dcm_wrapper
    port map (
      RST => dcm_1_lock,
      CLKIN => ddr_feedback_s,
      CLKFB => dcm_2_FB,
      PSEN => net_gnd0,
      PSINCDEC => net_gnd0,
      PSCLK => net_gnd0,
      DSSEN => net_gnd0,
      CLK0 => dcm_2_FB,
      CLK90 => ddr_clk_90_s,
      CLK180 => open,
      CLK270 => ddr_clk_90_n_s,
      CLKDV => open,
      CLK2X => open,
      CLK2X180 => open,
      CLKFX => open,
      CLKFX180 => open,
      STATUS => open,
      LOCKED => dcm_2_lock,
      PSDONE => open
    );

  ddr90_dcm : ddr90_dcm_wrapper
    port map (
      RST => dcm_0_lock,
      CLKIN => dcm_clk_s,
      CLKFB => dcm_1_FB,
      PSEN => net_gnd0,
      PSINCDEC => net_gnd0,
      PSCLK => net_gnd0,
      DSSEN => net_gnd0,
      CLK0 => dcm_1_FB,
      CLK90 => clk_90_s,
      CLK180 => sys_clk_n_s,
      CLK270 => clk_90_n_s,
      CLKDV => open,
      CLK2X => open,
      CLK2X180 => open,
      CLKFX => open,
      CLKFX180 => open,
      STATUS => open,
      LOCKED => dcm_1_lock,
      PSDONE => open
    );

  sys_dcm : sys_dcm_wrapper
    port map (
      RST => net_gnd0,
      CLKIN => dcm_clk_s,
      CLKFB => sys_clk_s,
      PSEN => net_gnd0,
      PSINCDEC => net_gnd0,
      PSCLK => net_gnd0,
      DSSEN => net_gnd0,
      CLK0 => sys_clk_s,
      CLK90 => open,
      CLK180 => open,
      CLK270 => open,
      CLKDV => open,
      CLK2X => open,
      CLK2X180 => open,
      CLKFX => cpu_clk,
      CLKFX180 => open,
      STATUS => open,
      LOCKED => dcm_0_lock,
      PSDONE => open
    );

  plb_eth2_contr : plb_eth2_contr_wrapper
    port map (
      PHY_tx_clk => Eth2_PHY_tx_clk,
      PHY_rx_clk => Eth2_PHY_rx_clk,
      PHY_crs => Eth2_PHY_crs,
      PHY_dv => Eth2_PHY_dv,
      PHY_rx_data => Eth2_PHY_rx_data,
      PHY_col => Eth2_PHY_col,
      PHY_rx_er => Eth2_PHY_rx_er,
      PHY_tx_en => Eth2_PHY_tx_en,
      PHY_rx_en => open,
      PHY_tx_er => Eth2_PHY_tx_er,
      PHY_tx_data => Eth2_PHY_tx_data,
      PHY_rst_n => Eth2_PHY_rst_n,
      PLB_Clk => sys_clk_s,
      PLB_Rst => plb_PLB_Rst,
      Freeze => net_gnd0,
      IP2INTC_Irpt => eth_2_int,
      PLB_ABus => plb_PLB_ABus,
      PLB_PAValid => plb_PLB_PAValid,
      PLB_SAValid => plb_PLB_SAValid,
      PLB_rdPrim => plb_PLB_rdPrim,
      PLB_wrPrim => plb_PLB_wrPrim,
      PLB_masterID => plb_PLB_masterID,
      PLB_abort => plb_PLB_abort,
      PLB_busLock => plb_PLB_busLock,
      PLB_RNW => plb_PLB_RNW,
      PLB_BE => plb_PLB_BE,
      PLB_MSize => plb_PLB_MSize,
      PLB_size => plb_PLB_size,
      PLB_type => plb_PLB_type,
      PLB_compress => plb_PLB_compress,
      PLB_guarded => plb_PLB_guarded,
      PLB_ordered => plb_PLB_ordered,
      PLB_lockErr => plb_PLB_lockErr,
      PLB_wrDBus => plb_PLB_wrDBus,
      PLB_wrBurst => plb_PLB_wrBurst,
      PLB_rdBurst => plb_PLB_rdBurst,
      PLB_pendReq => plb_PLB_pendReq,
      PLB_pendPri => plb_PLB_pendPri,
      PLB_reqPri => plb_PLB_reqPri,
      Sl_addrAck => plb_Sl_addrAck(2),
      Sl_SSize => plb_Sl_SSize(4 to 5),
      Sl_wait => plb_Sl_wait(2),
      Sl_rearbitrate => plb_Sl_rearbitrate(2),
      Sl_wrDAck => plb_Sl_wrDAck(2),
      Sl_wrComp => plb_Sl_wrComp(2),
      Sl_wrBTerm => plb_Sl_wrBTerm(2),
      Sl_rdDBus => plb_Sl_rdDBus(128 to 191),
      Sl_rdWdAddr => plb_Sl_rdWdAddr(8 to 11),
      Sl_rdDAck => plb_Sl_rdDAck(2),
      Sl_rdComp => plb_Sl_rdComp(2),
      Sl_rdBTerm => plb_Sl_rdBTerm(2),
      Sl_MBusy => plb_Sl_MBusy(8 to 11),
      Sl_MErr => plb_Sl_MErr(8 to 11),
      PLB_MAddrAck => plb_PLB_MAddrAck(2),
      PLB_MSSize => plb_PLB_MSSize(4 to 5),
      PLB_MRearbitrate => plb_PLB_MRearbitrate(2),
      PLB_MBusy => plb_PLB_MBusy(2),
      PLB_MErr => plb_PLB_MErr(2),
      PLB_MWrDAck => plb_PLB_MWrDAck(2),
      PLB_MRdDBus => plb_PLB_MRdDBus(128 to 191),
      PLB_MRdWdAddr => plb_PLB_MRdWdAddr(8 to 11),
      PLB_MRdDAck => plb_PLB_MRdDAck(2),
      PLB_MRdBTerm => plb_PLB_MRdBTerm(2),
      PLB_MWrBTerm => plb_PLB_MWrBTerm(2),
      M_request => plb_M_request(2),
      M_priority => plb_M_priority(4 to 5),
      M_buslock => plb_M_busLock(2),
      M_RNW => plb_M_RNW(2),
      M_BE => plb_M_BE(16 to 23),
      M_MSize => plb_M_MSize(4 to 5),
      M_size => plb_M_size(8 to 11),
      M_type => plb_M_type(6 to 8),
      M_compress => plb_M_compress(2),
      M_guarded => plb_M_guarded(2),
      M_ordered => plb_M_ordered(2),
      M_lockErr => plb_M_lockErr(2),
      M_abort => plb_M_abort(2),
      M_ABus => plb_M_ABus(64 to 95),
      M_wrDBus => plb_M_wrDBus(128 to 191),
      M_wrBurst => plb_M_wrBurst(2),
      M_rdBurst => plb_M_rdBurst(2),
      PHY_Mii_clk_I => Eth2_PHY_Mii_clk_I,
      PHY_Mii_clk_O => Eth2_PHY_Mii_clk_O,
      PHY_Mii_clk_T => Eth2_PHY_Mii_clk_T,
      PHY_Mii_data_I => Eth2_PHY_Mii_data_I,
      PHY_Mii_data_O => Eth2_PHY_Mii_data_O,
      PHY_Mii_data_T => Eth2_PHY_Mii_data_T
    );

  plb_eth1_contr : plb_eth1_contr_wrapper
    port map (
      PHY_tx_clk => Eth1_PHY_tx_clk,
      PHY_rx_clk => Eth1_PHY_rx_clk,
      PHY_crs => Eth1_PHY_crs,
      PHY_dv => Eth1_PHY_dv,
      PHY_rx_data => Eth1_PHY_rx_data,
      PHY_col => Eth1_PHY_col,
      PHY_rx_er => Eth1_PHY_rx_er,
      PHY_tx_en => Eth1_PHY_tx_en,
      PHY_rx_en => open,
      PHY_tx_er => Eth1_PHY_tx_er,
      PHY_tx_data => Eth1_PHY_tx_data,
      PHY_rst_n => Eth1_PHY_rst_n,
      PLB_Clk => sys_clk_s,
      PLB_Rst => plb_PLB_Rst,
      Freeze => net_gnd0,
      IP2INTC_Irpt => eth_1_int,
      PLB_ABus => plb_PLB_ABus,
      PLB_PAValid => plb_PLB_PAValid,
      PLB_SAValid => plb_PLB_SAValid,
      PLB_rdPrim => plb_PLB_rdPrim,
      PLB_wrPrim => plb_PLB_wrPrim,
      PLB_masterID => plb_PLB_masterID,
      PLB_abort => plb_PLB_abort,
      PLB_busLock => plb_PLB_busLock,
      PLB_RNW => plb_PLB_RNW,
      PLB_BE => plb_PLB_BE,
      PLB_MSize => plb_PLB_MSize,
      PLB_size => plb_PLB_size,
      PLB_type => plb_PLB_type,
      PLB_compress => plb_PLB_compress,
      PLB_guarded => plb_PLB_guarded,
      PLB_ordered => plb_PLB_ordered,
      PLB_lockErr => plb_PLB_lockErr,
      PLB_wrDBus => plb_PLB_wrDBus,
      PLB_wrBurst => plb_PLB_wrBurst,
      PLB_rdBurst => plb_PLB_rdBurst,
      PLB_pendReq => plb_PLB_pendReq,
      PLB_pendPri => plb_PLB_pendPri,
      PLB_reqPri => plb_PLB_reqPri,
      Sl_addrAck => plb_Sl_addrAck(3),
      Sl_SSize => plb_Sl_SSize(6 to 7),
      Sl_wait => plb_Sl_wait(3),
      Sl_rearbitrate => plb_Sl_rearbitrate(3),
      Sl_wrDAck => plb_Sl_wrDAck(3),
      Sl_wrComp => plb_Sl_wrComp(3),
      Sl_wrBTerm => plb_Sl_wrBTerm(3),
      Sl_rdDBus => plb_Sl_rdDBus(192 to 255),
      Sl_rdWdAddr => plb_Sl_rdWdAddr(12 to 15),
      Sl_rdDAck => plb_Sl_rdDAck(3),
      Sl_rdComp => plb_Sl_rdComp(3),
      Sl_rdBTerm => plb_Sl_rdBTerm(3),
      Sl_MBusy => plb_Sl_MBusy(12 to 15),
      Sl_MErr => plb_Sl_MErr(12 to 15),
      PLB_MAddrAck => plb_PLB_MAddrAck(3),
      PLB_MSSize => plb_PLB_MSSize(6 to 7),
      PLB_MRearbitrate => plb_PLB_MRearbitrate(3),
      PLB_MBusy => plb_PLB_MBusy(3),
      PLB_MErr => plb_PLB_MErr(3),
      PLB_MWrDAck => plb_PLB_MWrDAck(3),
      PLB_MRdDBus => plb_PLB_MRdDBus(192 to 255),
      PLB_MRdWdAddr => plb_PLB_MRdWdAddr(12 to 15),
      PLB_MRdDAck => plb_PLB_MRdDAck(3),
      PLB_MRdBTerm => plb_PLB_MRdBTerm(3),
      PLB_MWrBTerm => plb_PLB_MWrBTerm(3),
      M_request => plb_M_request(3),
      M_priority => plb_M_priority(6 to 7),
      M_buslock => plb_M_busLock(3),
      M_RNW => plb_M_RNW(3),
      M_BE => plb_M_BE(24 to 31),
      M_MSize => plb_M_MSize(6 to 7),
      M_size => plb_M_size(12 to 15),
      M_type => plb_M_type(9 to 11),
      M_compress => plb_M_compress(3),
      M_guarded => plb_M_guarded(3),
      M_ordered => plb_M_ordered(3),
      M_lockErr => plb_M_lockErr(3),
      M_abort => plb_M_abort(3),
      M_ABus => plb_M_ABus(96 to 127),
      M_wrDBus => plb_M_wrDBus(192 to 255),
      M_wrBurst => plb_M_wrBurst(3),
      M_rdBurst => plb_M_rdBurst(3),
      PHY_Mii_clk_I => Eth1_PHY_Mii_clk_I,
      PHY_Mii_clk_O => Eth1_PHY_Mii_clk_O,
      PHY_Mii_clk_T => Eth1_PHY_Mii_clk_T,
      PHY_Mii_data_I => Eth1_PHY_Mii_data_I,
      PHY_Mii_data_O => Eth1_PHY_Mii_data_O,
      PHY_Mii_data_T => Eth1_PHY_Mii_data_T
    );

  opb_intc_0 : opb_intc_0_wrapper
    port map (
      OPB_Clk => sys_clk_s,
      Intr => pgassign5,
      OPB_Rst => opb_OPB_Rst,
      OPB_ABus => opb_OPB_ABus,
      OPB_BE => opb_OPB_BE,
      OPB_RNW => opb_OPB_RNW,
      OPB_select => opb_OPB_select,
      OPB_seqAddr => opb_OPB_seqAddr,
      OPB_DBus => opb_OPB_DBus,
      IntC_DBus => opb_Sl_DBus(0 to 31),
      IntC_errAck => opb_Sl_errAck(0),
      IntC_retry => opb_Sl_retry(0),
      IntC_toutSup => opb_Sl_toutSup(0),
      IntC_xferAck => opb_Sl_xferAck(0),
      Irq => EICC405EXTINPUTIRQ
    );

  opb_flash : opb_flash_wrapper
    port map (
      OPB_Clk => sys_clk_s,
      OPB_Rst => opb_OPB_Rst,
      Sl_DBus => opb_Sl_DBus(32 to 63),
      Sl_errAck => opb_Sl_errAck(1),
      Sl_retry => opb_Sl_retry(1),
      Sl_toutSup => opb_Sl_toutSup(1),
      Sl_xferAck => opb_Sl_xferAck(1),
      OPB_ABus => opb_OPB_ABus,
      OPB_DBus => opb_OPB_DBus,
      OPB_RNW => opb_OPB_RNW,
      OPB_select => opb_OPB_select,
      OPB_seqAddr => opb_OPB_seqAddr,
      Flash_A => Flash_A,
      Flash_CEN => Flash_CEN,
      Flash_OEN => Flash_OEN,
      Flash_WEN => Flash_WEN,
      Flash_Rst => Flash_Rst,
      periph_reset => sys_per_rst(0),
      Flash_DQ_I => Flash_DQ_I,
      Flash_DQ_O => Flash_DQ_O,
      Flash_DQ_T => Flash_DQ_T
    );

  boot_ppc_cntrl : boot_ppc_cntrl_wrapper
    port map (
      opb_clk => sys_clk_s,
      opb_rst => opb_OPB_Rst,
      opb_abus => opb_OPB_ABus,
      opb_dbus => opb_OPB_DBus,
      sln_dbus => opb_Sl_DBus(64 to 95),
      opb_select => opb_OPB_select,
      opb_rnw => opb_OPB_RNW,
      opb_seqaddr => opb_OPB_seqAddr,
      opb_be => opb_OPB_BE,
      sln_xferack => opb_Sl_xferAck(2),
      sln_errack => opb_Sl_errAck(2),
      sln_toutsup => opb_Sl_toutSup(2),
      sln_retry => opb_Sl_retry(2),
      bram_rst => boot_ppc_cntrl_port_BRAM_Rst,
      bram_clk => boot_ppc_cntrl_port_BRAM_Clk,
      bram_en => boot_ppc_cntrl_port_BRAM_EN,
      bram_wen => boot_ppc_cntrl_port_BRAM_WEN,
      bram_addr => boot_ppc_cntrl_port_BRAM_Addr,
      bram_din => boot_ppc_cntrl_port_BRAM_Din,
      bram_dout => boot_ppc_cntrl_port_BRAM_Dout
    );

  boot_ppc_bram : boot_ppc_bram_wrapper
    port map (
      BRAM_Rst_A => boot_ppc_cntrl_port_BRAM_Rst,
      BRAM_Clk_A => boot_ppc_cntrl_port_BRAM_Clk,
      BRAM_EN_A => boot_ppc_cntrl_port_BRAM_EN,
      BRAM_WEN_A => boot_ppc_cntrl_port_BRAM_WEN,
      BRAM_Addr_A => boot_ppc_cntrl_port_BRAM_Addr,
      BRAM_Din_A => boot_ppc_cntrl_port_BRAM_Din,
      BRAM_Dout_A => boot_ppc_cntrl_port_BRAM_Dout,
      BRAM_Rst_B => net_gnd0,
      BRAM_Clk_B => net_gnd0,
      BRAM_EN_B => net_gnd0,
      BRAM_WEN_B => net_gnd4,
      BRAM_Addr_B => net_gnd32,
      BRAM_Din_B => open,
      BRAM_Dout_B => net_gnd32
    );

  plb_DDR_SDRAM : plb_ddr_sdram_wrapper
    port map (
      PLB_Clk => sys_clk_s,
      PLB_Clk_n => sys_clk_n_s,
      Clk90_in => clk_90_s,
      Clk90_in_n => clk_90_n_s,
      DDR_Clk90_in => ddr_clk_90_s,
      DDR_Clk90_in_n => ddr_clk_90_n_s,
      PLB_Rst => plb_PLB_Rst,
      PLB_ABus => plb_PLB_ABus,
      PLB_PAValid => plb_PLB_PAValid,
      PLB_SAValid => plb_PLB_SAValid,
      PLB_rdPrim => plb_PLB_rdPrim,
      PLB_wrPrim => plb_PLB_wrPrim,
      PLB_masterID => plb_PLB_masterID,
      PLB_abort => plb_PLB_abort,
      PLB_busLock => plb_PLB_busLock,
      PLB_RNW => plb_PLB_RNW,
      PLB_BE => plb_PLB_BE,
      PLB_MSize => plb_PLB_MSize,
      PLB_size => plb_PLB_size,
      PLB_type => plb_PLB_type,
      PLB_compress => plb_PLB_compress,
      PLB_guarded => plb_PLB_guarded,
      PLB_ordered => plb_PLB_ordered,
      PLB_lockErr => plb_PLB_lockErr,
      PLB_wrDBus => plb_PLB_wrDBus,
      PLB_wrBurst => plb_PLB_wrBurst,
      PLB_rdBurst => plb_PLB_rdBurst,
      PLB_pendReq => plb_PLB_pendReq,
      PLB_pendPri => plb_PLB_pendPri,
      PLB_reqPri => plb_PLB_reqPri,
      Sl_addrAck => plb_Sl_addrAck(6),
      Sl_SSize => plb_Sl_SSize(12 to 13),
      Sl_wait => plb_Sl_wait(6),
      Sl_rearbitrate => plb_Sl_rearbitrate(6),
      Sl_wrDAck => plb_Sl_wrDAck(6),
      Sl_wrComp => plb_Sl_wrComp(6),
      Sl_wrBTerm => plb_Sl_wrBTerm(6),
      Sl_rdDBus => plb_Sl_rdDBus(384 to 447),
      Sl_rdWdAddr => plb_Sl_rdWdAddr(24 to 27),
      Sl_rdDAck => plb_Sl_rdDAck(6),
      Sl_rdComp => plb_Sl_rdComp(6),
      Sl_rdBTerm => plb_Sl_rdBTerm(6),
      Sl_MBusy => plb_Sl_MBusy(24 to 27),
      Sl_MErr => plb_Sl_MErr(24 to 27),
      IP2INTC_Irpt => open,
      DDR_Clk => pgassign3(0 to 0),
      DDR_Clkn => pgassign4(0 to 0),
      DDR_CKE => pgassign1(0 to 0),
      DDR_CSn => pgassign2(0 to 0),
      DDR_RASn => DDR_RASn,
      DDR_CASn => DDR_CASn,
      DDR_WEn => DDR_WEn,
      DDR_DM => DDR_DM,
      DDR_BankAddr => DDR_BankAddr,
      DDR_Addr => DDR_Addr,
      DDR_DM_ECC => open,
      DDR_Init_done => open,
      DDR_DQ_I => DDR_DQ_I,
      DDR_DQ_O => DDR_DQ_O,
      DDR_DQ_T => DDR_DQ_T,
      DDR_DQS_I => DDR_DQS_I,
      DDR_DQS_O => DDR_DQS_O,
      DDR_DQS_T => DDR_DQS_T,
      DDR_DQ_ECC_I => net_gnd7,
      DDR_DQ_ECC_O => open,
      DDR_DQ_ECC_T => open,
      DDR_DQS_ECC_I => net_gnd0,
      DDR_DQS_ECC_O => open,
      DDR_DQS_ECC_T => open
    );

  UART_TUTS : uart_tuts_wrapper
    port map (
      OPB_Clk => sys_clk_s,
      OPB_Rst => opb_OPB_Rst,
      Interrupt => UART_TUTS_int,
      OPB_ABus => opb_OPB_ABus,
      OPB_BE => opb_OPB_BE,
      OPB_RNW => opb_OPB_RNW,
      OPB_select => opb_OPB_select,
      OPB_seqAddr => opb_OPB_seqAddr,
      OPB_DBus => opb_OPB_DBus,
      UART_DBus => opb_Sl_DBus(96 to 127),
      UART_errAck => opb_Sl_errAck(3),
      UART_retry => opb_Sl_retry(3),
      UART_toutSup => opb_Sl_toutSup(3),
      UART_xferAck => opb_Sl_xferAck(3),
      RX => UART_TUTS_RX,
      TX => UART_TUTS_TX
    );

  RS232_1 : rs232_1_wrapper
    port map (
      OPB_Clk => sys_clk_s,
      OPB_Rst => opb_OPB_Rst,
      Interrupt => rs232_1_int,
      OPB_ABus => opb_OPB_ABus,
      OPB_BE => opb_OPB_BE,
      OPB_RNW => opb_OPB_RNW,
      OPB_select => opb_OPB_select,
      OPB_seqAddr => opb_OPB_seqAddr,
      OPB_DBus => opb_OPB_DBus,
      UART_DBus => opb_Sl_DBus(128 to 159),
      UART_errAck => opb_Sl_errAck(4),
      UART_retry => opb_Sl_retry(4),
      UART_toutSup => opb_Sl_toutSup(4),
      UART_xferAck => opb_Sl_xferAck(4),
      RX => RS232_1_RX,
      TX => RS232_1_TX
    );

  RS232_2 : rs232_2_wrapper
    port map (
      OPB_Clk => sys_clk_s,
      OPB_Rst => opb_OPB_Rst,
      Interrupt => rs232_2_int,
      OPB_ABus => opb_OPB_ABus,
      OPB_BE => opb_OPB_BE,
      OPB_RNW => opb_OPB_RNW,
      OPB_select => opb_OPB_select,
      OPB_seqAddr => opb_OPB_seqAddr,
      OPB_DBus => opb_OPB_DBus,
      UART_DBus => opb_Sl_DBus(160 to 191),
      UART_errAck => opb_Sl_errAck(5),
      UART_retry => opb_Sl_retry(5),
      UART_toutSup => opb_Sl_toutSup(5),
      UART_xferAck => opb_Sl_xferAck(5),
      RX => RS232_2_RX,
      TX => RS232_2_TX
    );

  gpio_LEDS : gpio_leds_wrapper
    port map (
      OPB_ABus => opb_OPB_ABus,
      OPB_BE => opb_OPB_BE,
      OPB_Clk => sys_clk_s,
      OPB_DBus => opb_OPB_DBus,
      OPB_RNW => opb_OPB_RNW,
      OPB_Rst => opb_OPB_Rst,
      OPB_select => opb_OPB_select,
      OPB_seqAddr => opb_OPB_seqAddr,
      Sln_DBus => opb_Sl_DBus(192 to 223),
      Sln_errAck => opb_Sl_errAck(6),
      Sln_retry => opb_Sl_retry(6),
      Sln_toutSup => opb_Sl_toutSup(6),
      Sln_xferAck => opb_Sl_xferAck(6),
      IP2INTC_Irpt => open,
      GPIO_in => net_gnd3,
      GPIO_d_out => LEDS,
      GPIO_t_out => open,
      GPIO2_in => net_gnd3,
      GPIO2_d_out => open,
      GPIO2_t_out => open,
      GPIO_IO_I => net_gnd3,
      GPIO_IO_O => open,
      GPIO_IO_T => open,
      GPIO2_IO_I => net_gnd3,
      GPIO2_IO_O => open,
      GPIO2_IO_T => open
    );

  freq_detect : freq_detect_wrapper
    port map (
      OPB_ABus => opb_OPB_ABus,
      OPB_BE => opb_OPB_BE,
      OPB_Clk => sys_clk_s,
      OPB_DBus => opb_OPB_DBus,
      OPB_RNW => opb_OPB_RNW,
      OPB_Rst => opb_OPB_Rst,
      OPB_select => opb_OPB_select,
      OPB_seqAddr => opb_OPB_seqAddr,
      Sln_DBus => opb_Sl_DBus(224 to 255),
      Sln_errAck => opb_Sl_errAck(7),
      Sln_retry => opb_Sl_retry(7),
      Sln_toutSup => opb_Sl_toutSup(7),
      Sln_xferAck => opb_Sl_xferAck(7),
      IP2INTC_Irpt => open,
      GPIO_in => pgassign6,
      GPIO_d_out => open,
      GPIO_t_out => open,
      GPIO2_in => net_gnd2,
      GPIO2_d_out => open,
      GPIO2_t_out => open,
      GPIO_IO_I => net_gnd2,
      GPIO_IO_O => open,
      GPIO_IO_T => open,
      GPIO2_IO_I => net_gnd2,
      GPIO2_IO_O => open,
      GPIO2_IO_T => open
    );

  reg_version : reg_version_wrapper
    port map (
      PLB_Clk => sys_clk_s,
      PLB_Rst => plb_PLB_Rst,
      Sl_addrAck => plb_Sl_addrAck(7),
      Sl_MBusy => plb_Sl_MBusy(28 to 31),
      Sl_MErr => plb_Sl_MErr(28 to 31),
      Sl_rdBTerm => plb_Sl_rdBTerm(7),
      Sl_rdComp => plb_Sl_rdComp(7),
      Sl_rdDAck => plb_Sl_rdDAck(7),
      Sl_rdDBus => plb_Sl_rdDBus(448 to 511),
      Sl_rdWdAddr => plb_Sl_rdWdAddr(28 to 31),
      Sl_rearbitrate => plb_Sl_rearbitrate(7),
      Sl_SSize => plb_Sl_SSize(14 to 15),
      Sl_wait => plb_Sl_wait(7),
      Sl_wrBTerm => plb_Sl_wrBTerm(7),
      Sl_wrComp => plb_Sl_wrComp(7),
      Sl_wrDAck => plb_Sl_wrDAck(7),
      PLB_abort => plb_PLB_abort,
      PLB_ABus => plb_PLB_ABus,
      PLB_BE => plb_PLB_BE,
      PLB_busLock => plb_PLB_busLock,
      PLB_compress => plb_PLB_compress,
      PLB_guarded => plb_PLB_guarded,
      PLB_lockErr => plb_PLB_lockErr,
      PLB_masterID => plb_PLB_masterID,
      PLB_MSize => plb_PLB_MSize,
      PLB_ordered => plb_PLB_ordered,
      PLB_PAValid => plb_PLB_PAValid,
      PLB_pendPri => plb_PLB_pendPri,
      PLB_pendReq => plb_PLB_pendReq,
      PLB_rdBurst => plb_PLB_rdBurst,
      PLB_rdPrim => plb_PLB_rdPrim,
      PLB_reqPri => plb_PLB_reqPri,
      PLB_RNW => plb_PLB_RNW,
      PLB_SAValid => plb_PLB_SAValid,
      PLB_size => plb_PLB_size,
      PLB_type => plb_PLB_type,
      PLB_wrBurst => plb_PLB_wrBurst,
      PLB_wrDBus => plb_PLB_wrDBus,
      PLB_wrPrim => plb_PLB_wrPrim
    );

  f_gen_0 : f_gen_0_wrapper
    port map (
      ft_in => clk_19_ext,
      fd_in => clk_10_ext,
      ft_out => clk_19_int,
      fd_out => clk_10_int,
      PLB_Clk => sys_clk_s,
      PLB_Rst => plb_PLB_Rst,
      Sl_addrAck => plb_Sl_addrAck(8),
      Sl_MBusy => plb_Sl_MBusy(32 to 35),
      Sl_MErr => plb_Sl_MErr(32 to 35),
      Sl_rdBTerm => plb_Sl_rdBTerm(8),
      Sl_rdComp => plb_Sl_rdComp(8),
      Sl_rdDAck => plb_Sl_rdDAck(8),
      Sl_rdDBus => plb_Sl_rdDBus(512 to 575),
      Sl_rdWdAddr => plb_Sl_rdWdAddr(32 to 35),
      Sl_rearbitrate => plb_Sl_rearbitrate(8),
      Sl_SSize => plb_Sl_SSize(16 to 17),
      Sl_wait => plb_Sl_wait(8),
      Sl_wrBTerm => plb_Sl_wrBTerm(8),
      Sl_wrComp => plb_Sl_wrComp(8),
      Sl_wrDAck => plb_Sl_wrDAck(8),
      PLB_abort => plb_PLB_abort,
      PLB_ABus => plb_PLB_ABus,
      PLB_BE => plb_PLB_BE,
      PLB_busLock => plb_PLB_busLock,
      PLB_compress => plb_PLB_compress,
      PLB_guarded => plb_PLB_guarded,
      PLB_lockErr => plb_PLB_lockErr,
      PLB_masterID => plb_PLB_masterID,
      PLB_MSize => plb_PLB_MSize,
      PLB_ordered => plb_PLB_ordered,
      PLB_PAValid => plb_PLB_PAValid,
      PLB_pendPri => plb_PLB_pendPri,
      PLB_pendReq => plb_PLB_pendReq,
      PLB_rdBurst => plb_PLB_rdBurst,
      PLB_rdPrim => plb_PLB_rdPrim,
      PLB_reqPri => plb_PLB_reqPri,
      PLB_RNW => plb_PLB_RNW,
      PLB_SAValid => plb_PLB_SAValid,
      PLB_size => plb_PLB_size,
      PLB_type => plb_PLB_type,
      PLB_wrBurst => plb_PLB_wrBurst,
      PLB_wrDBus => plb_PLB_wrDBus,
      PLB_wrPrim => plb_PLB_wrPrim
    );

  iobuf_0 : IOBUF
    port map (
      I => DDR_DQ_O(0),
      IO => DDR_DQ(0),
      O => DDR_DQ_I(0),
      T => DDR_DQ_T(0)
    );

  iobuf_1 : IOBUF
    port map (
      I => DDR_DQ_O(1),
      IO => DDR_DQ(1),
      O => DDR_DQ_I(1),
      T => DDR_DQ_T(1)
    );

  iobuf_2 : IOBUF
    port map (
      I => DDR_DQ_O(2),
      IO => DDR_DQ(2),
      O => DDR_DQ_I(2),
      T => DDR_DQ_T(2)
    );

  iobuf_3 : IOBUF
    port map (
      I => DDR_DQ_O(3),
      IO => DDR_DQ(3),
      O => DDR_DQ_I(3),
      T => DDR_DQ_T(3)
    );

  iobuf_4 : IOBUF
    port map (
      I => DDR_DQ_O(4),
      IO => DDR_DQ(4),
      O => DDR_DQ_I(4),
      T => DDR_DQ_T(4)
    );

  iobuf_5 : IOBUF
    port map (
      I => DDR_DQ_O(5),
      IO => DDR_DQ(5),
      O => DDR_DQ_I(5),
      T => DDR_DQ_T(5)
    );

  iobuf_6 : IOBUF
    port map (
      I => DDR_DQ_O(6),
      IO => DDR_DQ(6),
      O => DDR_DQ_I(6),
      T => DDR_DQ_T(6)
    );

  iobuf_7 : IOBUF
    port map (
      I => DDR_DQ_O(7),
      IO => DDR_DQ(7),
      O => DDR_DQ_I(7),
      T => DDR_DQ_T(7)
    );

  iobuf_8 : IOBUF
    port map (
      I => DDR_DQ_O(8),
      IO => DDR_DQ(8),
      O => DDR_DQ_I(8),
      T => DDR_DQ_T(8)
    );

  iobuf_9 : IOBUF
    port map (
      I => DDR_DQ_O(9),
      IO => DDR_DQ(9),
      O => DDR_DQ_I(9),
      T => DDR_DQ_T(9)
    );

  iobuf_10 : IOBUF
    port map (
      I => DDR_DQ_O(10),
      IO => DDR_DQ(10),
      O => DDR_DQ_I(10),
      T => DDR_DQ_T(10)
    );

  iobuf_11 : IOBUF
    port map (
      I => DDR_DQ_O(11),
      IO => DDR_DQ(11),
      O => DDR_DQ_I(11),
      T => DDR_DQ_T(11)
    );

  iobuf_12 : IOBUF
    port map (
      I => DDR_DQ_O(12),
      IO => DDR_DQ(12),
      O => DDR_DQ_I(12),
      T => DDR_DQ_T(12)
    );

  iobuf_13 : IOBUF
    port map (
      I => DDR_DQ_O(13),
      IO => DDR_DQ(13),
      O => DDR_DQ_I(13),
      T => DDR_DQ_T(13)
    );

  iobuf_14 : IOBUF
    port map (
      I => DDR_DQ_O(14),
      IO => DDR_DQ(14),
      O => DDR_DQ_I(14),
      T => DDR_DQ_T(14)
    );

  iobuf_15 : IOBUF
    port map (
      I => DDR_DQ_O(15),
      IO => DDR_DQ(15),
      O => DDR_DQ_I(15),
      T => DDR_DQ_T(15)
    );

  iobuf_16 : IOBUF
    port map (
      I => DDR_DQ_O(16),
      IO => DDR_DQ(16),
      O => DDR_DQ_I(16),
      T => DDR_DQ_T(16)
    );

  iobuf_17 : IOBUF
    port map (
      I => DDR_DQ_O(17),
      IO => DDR_DQ(17),
      O => DDR_DQ_I(17),
      T => DDR_DQ_T(17)
    );

  iobuf_18 : IOBUF
    port map (
      I => DDR_DQ_O(18),
      IO => DDR_DQ(18),
      O => DDR_DQ_I(18),
      T => DDR_DQ_T(18)
    );

  iobuf_19 : IOBUF
    port map (
      I => DDR_DQ_O(19),
      IO => DDR_DQ(19),
      O => DDR_DQ_I(19),
      T => DDR_DQ_T(19)
    );

  iobuf_20 : IOBUF
    port map (
      I => DDR_DQ_O(20),
      IO => DDR_DQ(20),
      O => DDR_DQ_I(20),
      T => DDR_DQ_T(20)
    );

  iobuf_21 : IOBUF
    port map (
      I => DDR_DQ_O(21),
      IO => DDR_DQ(21),
      O => DDR_DQ_I(21),
      T => DDR_DQ_T(21)
    );

  iobuf_22 : IOBUF
    port map (
      I => DDR_DQ_O(22),
      IO => DDR_DQ(22),
      O => DDR_DQ_I(22),
      T => DDR_DQ_T(22)
    );

  iobuf_23 : IOBUF
    port map (
      I => DDR_DQ_O(23),
      IO => DDR_DQ(23),
      O => DDR_DQ_I(23),
      T => DDR_DQ_T(23)
    );

  iobuf_24 : IOBUF
    port map (
      I => DDR_DQ_O(24),
      IO => DDR_DQ(24),
      O => DDR_DQ_I(24),
      T => DDR_DQ_T(24)
    );

  iobuf_25 : IOBUF
    port map (
      I => DDR_DQ_O(25),
      IO => DDR_DQ(25),
      O => DDR_DQ_I(25),
      T => DDR_DQ_T(25)
    );

  iobuf_26 : IOBUF
    port map (
      I => DDR_DQ_O(26),
      IO => DDR_DQ(26),
      O => DDR_DQ_I(26),
      T => DDR_DQ_T(26)
    );

  iobuf_27 : IOBUF
    port map (
      I => DDR_DQ_O(27),
      IO => DDR_DQ(27),
      O => DDR_DQ_I(27),
      T => DDR_DQ_T(27)
    );

  iobuf_28 : IOBUF
    port map (
      I => DDR_DQ_O(28),
      IO => DDR_DQ(28),
      O => DDR_DQ_I(28),
      T => DDR_DQ_T(28)
    );

  iobuf_29 : IOBUF
    port map (
      I => DDR_DQ_O(29),
      IO => DDR_DQ(29),
      O => DDR_DQ_I(29),
      T => DDR_DQ_T(29)
    );

  iobuf_30 : IOBUF
    port map (
      I => DDR_DQ_O(30),
      IO => DDR_DQ(30),
      O => DDR_DQ_I(30),
      T => DDR_DQ_T(30)
    );

  iobuf_31 : IOBUF
    port map (
      I => DDR_DQ_O(31),
      IO => DDR_DQ(31),
      O => DDR_DQ_I(31),
      T => DDR_DQ_T(31)
    );

  iobuf_32 : IOBUF
    port map (
      I => DDR_DQS_O(0),
      IO => DDR_DQS(0),
      O => DDR_DQS_I(0),
      T => DDR_DQS_T(0)
    );

  iobuf_33 : IOBUF
    port map (
      I => DDR_DQS_O(1),
      IO => DDR_DQS(1),
      O => DDR_DQS_I(1),
      T => DDR_DQS_T(1)
    );

  iobuf_34 : IOBUF
    port map (
      I => DDR_DQS_O(2),
      IO => DDR_DQS(2),
      O => DDR_DQS_I(2),
      T => DDR_DQS_T(2)
    );

  iobuf_35 : IOBUF
    port map (
      I => DDR_DQS_O(3),
      IO => DDR_DQS(3),
      O => DDR_DQS_I(3),
      T => DDR_DQS_T(3)
    );

  iobuf_36 : IOBUF
    port map (
      I => Eth1_PHY_Mii_clk_O,
      IO => Eth1_PHY_Mii_clk,
      O => Eth1_PHY_Mii_clk_I,
      T => Eth1_PHY_Mii_clk_T
    );

  iobuf_37 : IOBUF
    port map (
      I => Eth1_PHY_Mii_data_O,
      IO => Eth1_PHY_Mii_data,
      O => Eth1_PHY_Mii_data_I,
      T => Eth1_PHY_Mii_data_T
    );

  iobuf_38 : IOBUF
    port map (
      I => Eth2_PHY_Mii_clk_O,
      IO => Eth2_PHY_Mii_clk,
      O => Eth2_PHY_Mii_clk_I,
      T => Eth2_PHY_Mii_clk_T
    );

  iobuf_39 : IOBUF
    port map (
      I => Eth2_PHY_Mii_data_O,
      IO => Eth2_PHY_Mii_data,
      O => Eth2_PHY_Mii_data_I,
      T => Eth2_PHY_Mii_data_T
    );

  iobuf_40 : IOBUF
    port map (
      I => Flash_DQ_O(0),
      IO => Flash_DQ(0),
      O => Flash_DQ_I(0),
      T => Flash_DQ_T
    );

  iobuf_41 : IOBUF
    port map (
      I => Flash_DQ_O(1),
      IO => Flash_DQ(1),
      O => Flash_DQ_I(1),
      T => Flash_DQ_T
    );

  iobuf_42 : IOBUF
    port map (
      I => Flash_DQ_O(2),
      IO => Flash_DQ(2),
      O => Flash_DQ_I(2),
      T => Flash_DQ_T
    );

  iobuf_43 : IOBUF
    port map (
      I => Flash_DQ_O(3),
      IO => Flash_DQ(3),
      O => Flash_DQ_I(3),
      T => Flash_DQ_T
    );

  iobuf_44 : IOBUF
    port map (
      I => Flash_DQ_O(4),
      IO => Flash_DQ(4),
      O => Flash_DQ_I(4),
      T => Flash_DQ_T
    );

  iobuf_45 : IOBUF
    port map (
      I => Flash_DQ_O(5),
      IO => Flash_DQ(5),
      O => Flash_DQ_I(5),
      T => Flash_DQ_T
    );

  iobuf_46 : IOBUF
    port map (
      I => Flash_DQ_O(6),
      IO => Flash_DQ(6),
      O => Flash_DQ_I(6),
      T => Flash_DQ_T
    );

  iobuf_47 : IOBUF
    port map (
      I => Flash_DQ_O(7),
      IO => Flash_DQ(7),
      O => Flash_DQ_I(7),
      T => Flash_DQ_T
    );

  iobuf_48 : IOBUF
    port map (
      I => Flash_DQ_O(8),
      IO => Flash_DQ(8),
      O => Flash_DQ_I(8),
      T => Flash_DQ_T
    );

  iobuf_49 : IOBUF
    port map (
      I => Flash_DQ_O(9),
      IO => Flash_DQ(9),
      O => Flash_DQ_I(9),
      T => Flash_DQ_T
    );

  iobuf_50 : IOBUF
    port map (
      I => Flash_DQ_O(10),
      IO => Flash_DQ(10),
      O => Flash_DQ_I(10),
      T => Flash_DQ_T
    );

  iobuf_51 : IOBUF
    port map (
      I => Flash_DQ_O(11),
      IO => Flash_DQ(11),
      O => Flash_DQ_I(11),
      T => Flash_DQ_T
    );

  iobuf_52 : IOBUF
    port map (
      I => Flash_DQ_O(12),
      IO => Flash_DQ(12),
      O => Flash_DQ_I(12),
      T => Flash_DQ_T
    );

  iobuf_53 : IOBUF
    port map (
      I => Flash_DQ_O(13),
      IO => Flash_DQ(13),
      O => Flash_DQ_I(13),
      T => Flash_DQ_T
    );

  iobuf_54 : IOBUF
    port map (
      I => Flash_DQ_O(14),
      IO => Flash_DQ(14),
      O => Flash_DQ_I(14),
      T => Flash_DQ_T
    );

  iobuf_55 : IOBUF
    port map (
      I => Flash_DQ_O(15),
      IO => Flash_DQ(15),
      O => Flash_DQ_I(15),
      T => Flash_DQ_T
    );

end architecture STRUCTURE;

