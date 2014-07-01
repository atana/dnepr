-------------------------------------------------------------------------------
-- $Id: plb_ddr.vhd,v 1.14 2006/02/28 21:36:55 jennj Exp $
-------------------------------------------------------------------------------
-- plb_ddr.vhd - entity/architecture pair
-------------------------------------------------------------------------------
--
--  ***************************************************************************
--  **  Copyright(C) 2003 by Xilinx, Inc. All rights reserved.               **
--  **                                                                       **
--  **  This text contains proprietary, confidential                         **
--  **  information of Xilinx, Inc. , is distributed by                      **
--  **  under license from Xilinx, Inc., and may be used,                    **
--  **  copied and/or disclosed only pursuant to the terms                   **
--  **  of a valid license agreement with Xilinx, Inc.                       **
--  **                                                                       **
--  **  Unmodified source code is guaranteed to place and route,             **
--  **  function and run at speed according to the datasheet                 **
--  **  specification. Source code is provided "as-is", with no              **
--  **  obligation on the part of Xilinx to provide support.                 **
--  **                                                                       **
--  **  Xilinx Hotline support of source code IP shall only include          **
--  **  standard level Xilinx Hotline support, and will only address         **
--  **  issues and questions related to the standard released Netlist        **
--  **  version of the core (and thus indirectly, the original core source). **
--  **                                                                       **
--  **  The Xilinx Support Hotline does not have access to source            **
--  **  code and therefore cannot answer specific questions related          **
--  **  to source HDL. The Xilinx Support Hotline will only be able          **
--  **  to confirm the problem in the Netlist version of the core.           **
--  **                                                                       **
--  **  This copyright and support notice must be retained as part           **
--  **  of this text at all times.                                           **
--  ***************************************************************************
--
-------------------------------------------------------------------------------
-- Filename:        plb_ddr.vhd
-- Version:         v1.11a
-- Description:     Top level file for PLB DDR controller
--                  
-- VHDL-Standard:   VHDL'93
-------------------------------------------------------------------------------
-- Structure:   
--                  -- plb_ddr.vhd                  
--                      -- ddr_controller.vhd
--                          -- read_data_path.vhd
--                          -- data_statemachine.vhd
--                          -- command_statemachine.vhd
--                          -- init_statemachine.vhd
--                          -- counters.vhd
--                          -- io_registers.vhd
--                          -- clock_gen.vhd
--                          -- ipic_if.vhd
--                          -- dw64_wr.vhd
--                          -- dw64_rd.vhd
--                      -- plb_ipif.vhd
--                      -- ecc.vhd (if C_INCLUDE_ECC_SUPPORT=1)
--                          -- ecc_bhw.vhd
--                          -- ecc_write.vhd
--                              -- gen_ecc.vhd
--                          -- ecc_read.vhd
--                              -- gen_synd.vhd
--                              -- corr_data.vhd
--                              -- gen_err.vhd
--                          -- ecc_reg.vhd
--                              -- ecccr.vhd
--                              -- eccsr.vhd
--                              -- eccsec.vhd
--                              -- eccdec.vhd
--                              -- eccpec.vhd
--                          -- ecc_intr.vhd
--
-------------------------------------------------------------------------------
-- Change log:
-------------------------------------------------------------------------------
-- @BEGIN_CHANGELOG EDK_Gm_SP2 
--  ***************************************************************************
--  New version: v1.11a
--
--  Parameter modications:
--  => Supports multiple memory banks (up to 4) with C_NUM_BANKS_MEM generic.
--  => C_BASEADDR generic is now C_MEM0_BASEADDR.
--  => C_HIGHADDR generic is now C_MEM0_HIGHADDR. 
--  => Supports multiple DDR clock paris (up to 4) with C_NUM_CLK_PAIRS generic.
--  => C_DQS_PULLUPS parameter is removed.  The new default setting assumes pullups.
--  => Supports ECC write/read logic with C_INCLUDE_ECC_SUPPORT generic.
--  => Supports DDR data widths of 64 bits. C_DDR_DWIDTH can now be 32 or 64. 
--  =>      -- NOTE: C_DDR_DWIDTH can only be 64 if C_INCLUDE_ECC_SUPPORT=0
--  =>               ECC support is for 32-bit wide DDR only
--
--  Port modifications:
--  => Requires additional clock inputs: plb_clk_n, clk90_in_n, and ddr_clk90_in_n
--  => DDR_Clk is now a vectorized signal, DDR_Clk = DDR_Clk(0)
--  => DDR_Clkn is now a vectorized signal, DDR_Clkn = DDR_Clkn(0)
--  => DDR_CKE is now a vectorized signal, DDR_CKE = DDR_CKE(0)
--  => DDR_CSn is now a vectorized signal, DDR_CSn = DDR_CSn(0)
--  => New port signal: ddr_dq_ecc_o    
--  => New port signal: ddr_dq_ecc_i    
--  => New port signal: ddr_dq_ecc_t    
--  => New port signal: ddr_dqs_ecc_o   
--  => New port signal: ddr_dqs_ecc_i   
--  => New port signal: ddr_dqs_ecc_t   
--  => New port signal: ddr_dm_ecc      
--  => New port signal: IP2INTC_Irpt    
--
-- **************************************************************************
-- @END_CHANGELOG 
-------------------------------------------------------------------------------
-- @BEGIN_CHANGELOG EDK_Gmm_SP1
--  ***************************************************************************
--  
--  Modified the support for 64-bit DDR - now all 128-bits of DDR data are captured
--  in the Read Data FIFO. The muxing of the low and high double words based
--  off Bus2IP_Addr(28) now occurs after the Read Data FIFO on the PLB clock
--  domain. This reduces the amount of logic on the DDR feedback clock as well 
--  as the number of signals required to cross clock domains. Also, generated 
--  new signal, Addr28_fifo_wren, to write Bus2IP_Addr(28) into the Addr28 FIFO.
--
--  Modified DDR_DQS IOB input register instantiation for Virtex-4 systems.  
--  DDR_DQS register is no longer registered in IOB, due to reset/set signal 
--  differences in the Virtex-4 ILOGIC cell model.  Please note that UCF 
--  timing constraints are necessary with this modification.  Please refer 
--  to Xilinx Solution Record # 20202 found on http://www.support.xilinx.com/
--  for more information.
--
--  ***************************************************************************
-- @END_CHANGELOG 
-------------------------------------------------------------------------------
-- @BEGIN_CHANGELOG EDK_H
--  ***************************************************************************
--
--   Modified underlying library file ddr_v1_11_a/command_statemachine.vhd to
--   fix the constant ZERO_ADDR28_FIFO_OCC so that it is not a null array when
--   C_ADDR28_FIFO_OCC_WIDTH = 0.
--
--  ***************************************************************************
-- @END_CHANGELOG 
-------------------------------------------------------------------------------
-- @BEGIN_CHANGELOG EDK_H_SP1 
--  ***************************************************************************
--  Modified ddr_controller.vhd:
--  Write enable for Addr_28FIFO is directly connected to ip2bus_rdaddrack.
--  ***************************************************************************
-- @END_CHANGELOG 
-------------------------------------------------------------------------------
-- @BEGIN_CHANGELOG EDK_H_SP2
--  ***************************************************************************
--  Modified read_data_path_64.vhd to fix bug.
--  ***************************************************************************
-- @END_CHANGELOG 
-------------------------------------------------------------------------------
-- @BEGIN_CHANGELOG EDK_I_SP1
--  ***************************************************************************
--  Updated Read Data Path module for ECC to combine DQ & DQ_ECC FIFO read 
--  enable signals.
--  Removed ALERT statement in MPD file generation. 
--  ***************************************************************************
-- @END_CHANGELOG 
-------------------------------------------------------------------------------
-------------------------------------------------------------------------------
-- @BEGIN_CHANGELOG EDK_I_SP2
--  ***************************************************************************
--
--  Fix issue when PLB indeterminate read burst is followed by a cacheline read
--  operation.  Only effects design implementations when C_DDR_WIDTH = 64.  
--  Modified behavior of Addr28 FIFO reset signal in DDR v1.11a helper library.
--
--  ***************************************************************************
-- @END_CHANGELOG 
-------------------------------------------------------------------------------
-- 
-------------------------------------------------------------------------------
-- Author:          ALS
-- History:
--   ALS           05/20/02    First Version
-- ^^^^^^
--      First version of PLB DDR controller
-- ~~~~~~
-- 
--  ALS             06/05/02
-- ^^^^^^
--      Removed C_IPIF_DWIDTH and C_IPIF_AWIDTH from top level. These are 
--      C_PLB_DWIDTH and C_PLB_AWIDTH. Added C_FAMILY generic.
-- ~~~~~~
--  ALS             06/06/02
-- ^^^^^^
--      Changed C_CLK_FREQ to C_PLB_CLK_PERIOD_PS to be consistent with other cores.
-- ~~~~~~
--  ALS             06/15/02
-- ^^^^^^
--      Added Clk, Clk90, and Clk_DDR_RdData outputs
-- ~~~~~~
--  ALS             07/02/02
-- ^^^^^^
--      Upgraded to plb_ipif_v1_00_b and ddr_v1_00_b.
-- ~~~~~~
--  ALS             07/12/02
-- ^^^^^^
--      Added C_REG_DIMM and C_INCLUDE_DDR_DCM generics. Changed C_INCLUDE_CLK90_GEN
--      to C_INCLUDE_CLK90_DCM for clarity. Also added C_INCLUDE_BURSTS to 
--      control bursting capability.
-- ~~~~~~
--  ALS             07/19/02            -- VERSION B (to avoid confusion)
-- ^^^^^^
--      Removed C_REG_DIMM from top level since can't hardware test at this point.
--      Set to 0 in DDR instantiation.
--      Changed C_INCLUDE_BURSTS to C_INCLUDE_BURST_CACHELN_SUPPORT.
-- ~~~~~~
--  ALS             09/10/92
-- ^^^^^^
--      Put in XST workarounds to correctly handle ARD_DTIME_READ_ARRAY to IPIF.
--      Also put back in the C_REG_DIMM generic.
-- ~~~~~~
--  ALS             10/03/02
-- ^^^^^^
--      Removed all generics associated with the DCMs. Added generic to indicate
--      if the DDR DQS lines were pulled up or down. Renamed DDR_Clk_in to 
--      DDR_Clk90_in. Removed the following ports:
--          Clk            
--          Clk90          
--          Clk_DDR_RdData 
--          Clk90_locked   
--          Clkddr_locked  
--          DCM_Rst        
-- ~~~~~~
--  ALS             06/25/03
-- ^^^^^^
--      Version C:
--      Use latest PLB IPIF to remove latency and support indeterminate bursts
--      Add INIT_DONE as output pin
--      Provide C_SIM_INIT_TIME parameter to allow simulation to run faster
--      Remove XST workarounds
--      Assert TOUTSUP during transfers
-- ~~~~~~
--  JLJ             11/10/03
-- ^^^^^^
--      Version D:
--      Add support for ECC logic on read and write operations.  Use generate
--      statement to instantiate ecc.vhd and sub modules.  Based on parameter,
--      C_INCLUDE_ECC_SUPPORT.  
--      Addition of port signals to DDR for ECC logic that include:
--          DDR_DQ_ECC_o (0 to NUM_ECC_BITS-1)          -- DDR DQ ECC output
--          DDR_DQ_ECC_i (0 to NUM_ECC_BITS-1)          -- DDR DQ ECC input
--          DDR_DQ_ECC_t (0 to NUM_ECC_BITS-1)          -- DDR DQ ECC output enable
--          DDR_DQS_ECC_i                               -- DDR DQS ECC input
--          DDR_DQS_ECC_o                               -- DDR DQS ECC output
--          DDR_DQS_ECC_t                               -- DDR DQS ECC output enable
--          DDR_DM_ECC                                  -- DDR DM ECC output
--
--      Addition of PLB port signal:
--          IP2INTC_Irpt                                -- System Interrupt Controller
--
--      Connect Bus2IP_CE, Bus2IP_RdCE, Bus2IP_WrCE in PLB_IPIF connection 
--      to DDR controller
--      
--      Update to ddr_v1_00_d.
--
--      Removed RESERVED attribute on C_SIM_INIT_TIME_PS.
--
-- ~~~~~~
--  JLJ             02/16/04
-- ^^^^^^
--      Removed C_DQS_PULLUPS generic.  If this parameter was set to 1, the DDR DQS lines 
--      had pullups.  If this parameter was set to 0, then pulldowns were assumed.  The 
--      new default setting will assume pullups.
-- ~~~~~~
--  JLJ             02/18/04
-- ^^^^^^
--      Add PLB_Clk_n, Clk90_in_n, and DDR_Clk90_in_n signals on port mapping for DDR core.
--      This update of the core requires global inversion on clock inputs to prevent any
--      duty cycle distortion as system frequencies increase.
-- ~~~~~~
--  JLJ             02/20/04
-- ^^^^^^
--      Add support for multiple memory banks with new parameter, C_NUM_BANKS_MEM.
--      Supported number of memory banks is 1 to 4.
-- ~~~~~~
--  JLJ             02/25/04
-- ^^^^^^
--      Create multiple DDR clock pairs to support clocking requirements
--      of certain DDR SDRAM DIMM vendors. Added support for up to 3 differential
--      DDR clock pairs.  Renamed DDR_Clk and DDR_Clkn to DDR_Clk0 and DDR_Clk0n.
--      Added ports DDR_Clk1, DDR_Clk1n, DDR_Clk2, DDR_Clk2n. Added support for
--      2 output DDR clock enables.  Renamed DDR_CKE to DDR_CKE0, and added DDR_CKE1.
-- ~~~~~~
--  JLJ             03/18/04
-- ^^^^^^
--      Updated to version v1.10a.  Added support for Virtex4 (uses family.vhd in
--      proc_common_v2_00_a).  Also updated to proc_common_v2_00_a.
-- ~~~~~~
--  JLJ             04/05/04
-- ^^^^^^
--      Updated to plb_ipif_v1_00_f.  Remove ipif_common library.
-- ~~~~~~
--  JLJ             04/06/04
-- ^^^^^^
--      Added parameter, C_NUM_CLK_PAIRS for the number of differential DDR clock
--      pairs needed in design.  Renamed DDR_Clk0, DDR_Clk0n, DDR_Clk1, DDR_Clk1n, 
--      DDR_Clk2, & DDR_Clk2n to DDR_Clk (0:C_NUM_CLK_PAIRS-1) and 
--      DDR_Clkn (0:C_NUM_CLK_PAIRS-1).
--
--      Renamed DDR_CKE0 and DDR_CKE1 to DDR_CKE (0:C_NUM_BANKS_MEM-1).  Each
--      bank of DDR memory will have a dedicated CKE.
-- ~~~~~~
--  JLJ             04/16/04
-- ^^^^^^
--      Update MPD attributes at top level entity declaration.
-- ~~~~~~
--  NITIN          05/10/04
--      Added in attribute option XRANGE of C_DDR_DWIDTH 64 option
-- ~~~~~~
--  NITIN          05/13/04
--      Added in attribute     attribute RUN_NGCBUILD  = TRUE
-- ~~~~~~
--  NITIN          05/14/04
--      Updated for Review 2 comments.
-- ~~~~~~
--  NITIN          05/15/04
--      Updated for attribute assignment for NUM_ECC_BITS, C_PLB_DWIDTH and
--      C_PLB_AWIDTH
-- ~~~~~~
--  JLJ             05/05/04
-- ^^^^^^
--      Add component declaration for Virtex-4 primitives, IDDR & ODDR, in 
--      ddr_v1_10_a, io_registers and clock_gen modules.
-- ~~~~~~
--  JLJ             10/20/04          v1.11a
-- ^^^^^^
--      Remove IOB TRUE attribute on DDR_DQS signal for Virtex-4 in IO registers
-- ~~~~~~
--  Nitin Kabra     05/18/05
-- ^^^^^^^
--      Added generic C_EXTRA_TSU which enables extra set up on DDR_CSn,DDR_RASn,
--      DDR_CASn,DDR_WEn,DDR_BankAddr,DDR_Addr.
-- ~~~~~~~
--  Nitin Kabra     07/18/05
-- ^^^^^^^
--      Removed unused parameter C_DDR_TREFC to fix CR #206616.
-- ~~~~~~~
--  Nitin Kabra     11/14/05
-- ^^^^^^^
--      Removed ALERT statement in PSFUtil MPD attribute section to fix CR #220242.
-- ~~~~~~~
--  JLJ/Nitin       11/21/05            v1.11a
-- ^^^^^^
--      Rename library call to ddr_v1_11_a.  Incorrect earlier file update.
--      Put back in C_DDR_TREFC (only fix CR # 206616 in ddr_v1_12_a).
--      Remove C_EXTRA_TSU in ddr_controller ddr_v1_11_a library call.
-- ~~~~~~
--  JLJ             02/28/06            v1.11a
-- ^^^^^^
--      Updated change log text for DDR v1.11a helper library change.  See
--      details in ddr_v1_11a ddr_controller module.
-- ~~~~~~
-------------------------------------------------------------------------------
-- Naming Conventions:
--      active low signals:                     "*_n"
--      clock signals:                          "clk", "clk_div#", "clk_#x" 
--      reset signals:                          "rst", "rst_n" 
--      generics:                               "C_*" 
--      user defined types:                     "*_TYPE" 
--      state machine next state:               "*_ns" 
--      state machine current state:            "*_cs" 
--      combinatorial signals:                  "*_com" 
--      pipelined or register delay signals:    "*_d#" 
--      counter signals:                        "*cnt*"
--      clock enable signals:                   "*_ce" 
--      internal version of output port         "*_i"
--      device pins:                            "*_pin" 
--      ports:                                  - Names begin with Uppercase 
--      processes:                              "*_PROCESS" 
--      component instantiations:               "<ENTITY_>I_<#|FUNC>
-------------------------------------------------------------------------------

library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

library proc_common_v2_00_a;
use proc_common_v2_00_a.ipif_pkg.all;
use proc_common_v2_00_a.proc_common_pkg.all;
use proc_common_v2_00_a.family.all;
use proc_common_v2_00_a.all;

library ddr_v1_11_a;
use ddr_v1_11_a.all;

library plb_ipif_v1_00_f;
use plb_ipif_v1_00_f.all;

library ecc_v1_00_a;
use ecc_v1_00_a.all;

-------------------------------------------------------------------------------
-- Definition of Generics:
--  -- PLB DDR Generics
--      C_INCLUDE_BURST_CACHELN_SUPPORT -- include bursting and cacheline support
--      C_REG_DIMM                      -- include pipeline stage to support Reg DIMM
--      C_NUM_BANKS_MEM                 -- supported number of memory banks
--      C_NUM_CLK_PAIRS                 -- supported number of DDR clock pairs
--      C_FAMILY                        -- target device family
--
--  -- ECC Generics
--      C_INCLUDE_ECC_SUPPORT           -- include ECC logic
--      C_ENABLE_ECC_REG                -- enable ECC & IPIF interrupt registers
--      C_ECC_DEFAULT_ON                -- ecc default on or off setting
--      C_INCLUDE_ECC_INTR              -- include ECC interrupts     
--      C_INCLUDE_ECC_TEST              -- include ECC test logic
--      C_ECC_SEC_THRESHOLD             -- single error interrupt threshold
--      C_ECC_DEC_THRESHOLD             -- double error interrupt threshold
--      C_ECC_PEC_THRESHOLD             -- parity error interrupt threshold
--
--  -- DDR SDRAM Device Generics
--      C_DDR_TMRD                  -- Load Mode Register command cycle time
--      C_DDR_TWR                   -- write recovery time
--      C_DDR_TWTR                  -- write-to-read recovery time
--      C_DDR_TRAS                  -- delay after ACTIVE command before
--                                  -- PRECHARGE command
--      C_DDR_TRC                   -- delay after ACTIVE command before
--                                  -- another ACTIVE or AUTOREFRESH command
--      C_DDR_TRFC                  -- delay after AUTOREFRESH before another command
--      C_DDR_TRCD                  -- delay after ACTIVE before READ/WRITE
--      C_DDR_TRRD                  -- delay after ACTIVE row a before ACTIVE 
--                                  -- row b
--      C_DDR_TRP                   -- delay after PRECHARGE command
--      C_DDR_TREFI                 -- average periodic refresh command interval
--      C_DDR_TREFC                 -- refresh command interval
--      C_DDR_CAS_LAT               -- CAS latency
--      C_DDR_DWIDTH                -- DDR data width 
--      C_DDR_AWIDTH                -- DDR row address width
--      C_DDR_COL_AWIDTH            -- DDR column address width
--      C_DDR_BANK_AWIDTH           -- DDR bank address width
--
--  -- Address Space Generics
--      C_MEM0_BASEADDR             -- DDR memory bank 0 base address
--      C_MEM0_HIGHADDR             -- DDR memory bank 0 high address
--      C_MEM1_BASEADDR             -- DDR memory bank 1 base address
--      C_MEM1_HIGHADDR             -- DDR memory bank 1 high address
--      C_MEM2_BASEADDR             -- DDR memory bank 2 base address
--      C_MEM2_HIGHADDR             -- DDR memory bank 2 high address
--      C_MEM3_BASEADDR             -- DDR memory bank 3 base address
--      C_MEM3_HIGHADDR             -- DDR memory bank 3 high address
--      C_ECC_BASEADDR              -- ECC register base address
--      C_ECC_HIGHADDR              -- ECC register high address
--
--  -- PLB Bus Interface Generics
--      C_PLB_NUM_MASTERS           -- Number of PLB masters
--      C_PLB_MID_WIDTH             -- Number of bits to encode number of masters
--      C_PLB_AWIDTH                -- PLB address width
--      C_PLB_DWIDTH                -- PLB data width
--      C_PLB_CLK_PERIOD_PS         -- clock frequency
--
--  -- Simulation Only Generic
--      C_SIM_INIT_TIME_PS          -- DDR initialization time to be used in simulation
--
--
-- Definition of Ports:
--  -- PLB Interface
--      PLB_ABus               -- PLB address bus
--      PLB_PAValid            -- PLB primary address valid indicator
--      PLB_SAValid            -- PLB secondary address valid indicator
--      PLB_rdPrim             -- PLB secondary to primary read request indicator
--      PLB_wrPrim             -- PLB secondary to primary write request indicator
--      PLB_masterID           -- PLB current master indicator
--      PLB_abort              -- PLB abort bus request indicator
--      PLB_busLock            -- PLB bus lock
--      PLB_RNW                -- PLB read not write
--      PLB_BE                 -- PLB byte enables
--      PLB_MSize              -- PLB master data bus size
--      PLB_size               -- PLB transfer size
--      PLB_type               -- PLB transfer type
--      PLB_compress           -- PLB compressed data transfer indicator
--      PLB_guarded            -- PLB guarded transfer indicator
--      PLB_ordered            -- PLB synchronize transfer indicator
--      PLB_lockErr            -- PLB lock error indicator
--      PLB_wrDBus             -- PLB write data bus
--      PLB_wrBurst            -- PLB burst write transfer indicator
--      PLB_rdBurst            -- PLB burst read transfer indicator
--      PLB_pendReq            -- PLB pending request
--      PLB_pendPri            -- PLB pending request priority
--      PLB_reqPri             -- PLB request priority
--      Sl_addrAck             -- Slave address acknowledge
--      Sl_SSize               -- Slave data bus sizer
--      Sl_wait                -- Slave wait indicator
--      Sl_rearbitrate         -- Slave rearbitrate bus indicator
--      Sl_wrDAck              -- Slave write data acknowledge
--      Sl_wrComp              -- Slave write transfer complete indicator
--      Sl_wrBTerm             -- Slave terminate write burst transfer
--      Sl_rdDBus              -- Slave read bus
--      Sl_rdWdAddr            -- Slave read word address
--      Sl_rdDAck              -- Slave read data acknowledge
--      Sl_rdComp              -- Slave read transfer complete indicator
--      Sl_rdBTerm             -- Slave terminate read burst transfer
--      Sl_MBusy               -- Slave busy indicator
--      Sl_MErr                -- Slave error indicator
--      IP2INTC_Irpt           -- System interrupt controller
--
--  -- DDR interface
--      DDR_Clk                -- DDR clock output(s)
--      DDR_Clkn               -- DDR inverted clock output(s)
--      DDR_CKE                -- DDR clock enable(s)
--      DDR_CSn                -- DDR chip select(s)
--      DDR_RASn               -- DDR row address strobe
--      DDR_CASn               -- DDR column address strobe
--      DDR_WEn                -- DDR write enable
--      DDR_DM                 -- DDR data mask
--      DDR_BankAddr           -- DDR bank address
--      DDR_Addr               -- DDR address
--      DDR_DQ_o               -- DDR DQ output
--      DDR_DQ_i               -- DDR DQ input
--      DDR_DQ_t               -- DDR DQ output enable
--      DDR_DQS_i              -- DDR DQS input
--      DDR_DQS_o              -- DDR DQS output
--      DDR_DQS_t              -- DDR DQS output enable
--      DDR_DM_ECC             -- DDR ECC data mask
--      DDR_DQ_ECC_o           -- DDR ECC DQ output
--      DDR_DQ_ECC_i           -- DDR ECC DQ input
--      DDR_DQ_ECC_t           -- DDR ECC DQ output enable
--      DDR_DQS_ECC_i          -- DDR ECC DQS input
--      DDR_DQS_ECC_o          -- DDR ECC DQS output
--      DDR_DQS_ECC_t          -- DDR ECC DQS output enable

--  -- Timer or interrrupt signals
--      DDR_Init_done          -- DDR power-up/reset initialization is
--                             -- complete
--
--  -- Clocks and reset
--      PLB_Clk                -- PLB clock 
--      PLB_Clk_n              -- PLB clock shifted by 180
--      Clk90_in               -- PLB clock shifted 90
--      Clk90_in_n             -- PLB clock shifted by 270
--      DDR_Clk90_in           -- DDR clock feedback shifted 90
--      DDR_Clk90_in_n         -- DDR clock feedback shifted by 270
--      PLB_Rst                -- PLB Reset                                                          
---------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- Entity section
-----------------------------------------------------------------------------

entity plb_ddr is
    generic (
        -- ddr generics
        C_INCLUDE_BURST_CACHELN_SUPPORT : integer  := 0;
        C_REG_DIMM                      : integer  := 0;
        C_NUM_BANKS_MEM                 : integer  := 1;
            -- supported number of memory banks, allowable values: 1-4. default = 1
        C_NUM_CLK_PAIRS                 : integer  := 1;
            -- supported number of ddr clock pairs, allowable values: 1-4. default = 1
        C_FAMILY                        : string   := "virtex2";
      
        -- ecc generics
        C_INCLUDE_ECC_SUPPORT   : integer  := 0;
            -- Set this equal to 1 to enable ECC logic
            -- Set this equal to 0 to disable all ECC logic
        
        C_ENABLE_ECC_REG        : integer  := 1;
            -- Set this equal to 0 to disable all ECC registers.
            -- Default = 1 (all ECC registers are enabled)
        
        C_ECC_DEFAULT_ON        : integer  := 1;
            -- Set this equal to 1 for ECC to be ON as default (power up) condition (default setting)
            -- Set this equal to 0 to disable ECC as default (power up) condition
            -- When equal to 0, ECC must be turned on via ECCCR

        C_INCLUDE_ECC_INTR      : integer   := 0;
            -- Set this equal to 1 to enable ECC interrupts on error conditions.

        C_INCLUDE_ECC_TEST      : integer   := 0;
            -- Set this equal to 1 to enable ECC test support.     
                    
        C_ECC_SEC_THRESHOLD     : integer        := 1;
        C_ECC_DEC_THRESHOLD     : integer        := 1;    
        C_ECC_PEC_THRESHOLD     : integer        := 1;  
            -- Threshold values before an interrupt is generated

        NUM_ECC_BITS            : integer         := 7;
            -- Internal parameter to set the number of ECC check bits.
            -- Default setting is 7 (number of ECC bits) based on 32-bit data to DDR.   
        
        -- ddr device generics
        C_DDR_TMRD              : integer  := 15000;
        C_DDR_TWR               : integer  := 15000;
        C_DDR_TWTR              : integer  := 1;
        C_DDR_TRAS              : integer  := 40000;
        C_DDR_TRC               : integer  := 65000;
        C_DDR_TRFC              : integer  := 75000;
        C_DDR_TRCD              : integer  := 20000;
        C_DDR_TRRD              : integer  := 15000;
        C_DDR_TREFI             : integer  := 7800000;
        C_DDR_TREFC             : integer  := 70000000;
        C_DDR_TRP               : integer  := 20000;
        C_DDR_CAS_LAT           : integer  := 2;
        C_DDR_DWIDTH            : integer  := 32;
        C_DDR_AWIDTH            : integer  := 13;
        C_DDR_COL_AWIDTH        : integer  := 9;
        C_DDR_BANK_AWIDTH       : integer  := 2;

        -- address space generics
        C_MEM0_BASEADDR         : std_logic_vector := x"FFFFFFFF";
        C_MEM0_HIGHADDR         : std_logic_vector := x"00000000";
        C_MEM1_BASEADDR         : std_logic_vector := x"FFFFFFFF";
        C_MEM1_HIGHADDR         : std_logic_vector := x"00000000";
        C_MEM2_BASEADDR         : std_logic_vector := x"FFFFFFFF";
        C_MEM2_HIGHADDR         : std_logic_vector := x"00000000";
        C_MEM3_BASEADDR         : std_logic_vector := x"FFFFFFFF";
        C_MEM3_HIGHADDR         : std_logic_vector := x"00000000";
        C_ECC_BASEADDR          : std_logic_vector := x"FFFFFFFF";
        C_ECC_HIGHADDR          : std_logic_vector := x"00000000";

        -- ipif generics
        C_PLB_NUM_MASTERS       : integer := 8;
        C_PLB_MID_WIDTH         : integer := 3;
        C_PLB_AWIDTH            : integer := 32;
        C_PLB_DWIDTH            : integer := 64;
        C_PLB_CLK_PERIOD_PS     : integer := 10000;

        -- simulation only generic (set to 200us)
        C_SIM_INIT_TIME_PS      : integer  := 200000000       
        
     );  
  port (
  
        -- Clocks and reset
        PLB_Clk             : in  std_logic;
        PLB_Clk_n           : in  std_logic;
        Clk90_in            : in  std_logic;
        Clk90_in_n          : in  std_logic;
        DDR_Clk90_in        : in  std_logic;
        DDR_Clk90_in_n      : in  std_logic;
        PLB_Rst             : in  std_logic;

        -- PLB Slave signals
        PLB_ABus            : in  std_logic_vector(0 to C_PLB_AWIDTH-1);                            
        PLB_PAValid         : in  std_logic;                            
        PLB_SAValid         : in  std_logic;                            
        PLB_rdPrim          : in  std_logic;                            
        PLB_wrPrim          : in  std_logic;                            
        PLB_masterID        : in  std_logic_vector(0 to C_PLB_MID_WIDTH-1);                            
        PLB_abort           : in  std_logic;                            
        PLB_busLock         : in  std_logic;                            
        PLB_RNW             : in  std_logic;                            
        PLB_BE              : in  std_logic_vector(0 to (C_PLB_DWIDTH/8)-1);                            
        PLB_MSize           : in  std_logic_vector(0 to 1);                            
        PLB_size            : in  std_logic_vector(0 to 3);                            
        PLB_type            : in  std_logic_vector(0 to 2);                            
        PLB_compress        : in  std_logic;                            
        PLB_guarded         : in  std_logic;                            
        PLB_ordered         : in  std_logic;                            
        PLB_lockErr         : in  std_logic;                            
        PLB_wrDBus          : in  std_logic_vector(0 to C_PLB_DWIDTH-1);                            
        PLB_wrBurst         : in  std_logic;                            
        PLB_rdBurst         : in  std_logic;                            
        PLB_pendReq         : in  std_logic;
        PLB_pendPri         : in  std_logic_vector(0 to 1);        
        PLB_reqPri          : in  std_logic_vector(0 to 1);                            
        Sl_addrAck          : out std_logic;                            
        Sl_SSize            : out std_logic_vector(0 to 1);                            
        Sl_wait             : out std_logic;                            
        Sl_rearbitrate      : out std_logic;                            
        Sl_wrDAck           : out std_logic;                            
        Sl_wrComp           : out std_logic;                            
        Sl_wrBTerm          : out std_logic;                            
        Sl_rdDBus           : out std_logic_vector(0 to C_PLB_DWIDTH-1);                            
        Sl_rdWdAddr         : out std_logic_vector(0 to 3);                            
        Sl_rdDAck           : out std_logic;                            
        Sl_rdComp           : out std_logic;                            
        Sl_rdBTerm          : out std_logic;                            
        Sl_MBusy            : out std_logic_vector(0 to C_PLB_NUM_MASTERS-1);                            
        Sl_MErr             : out std_logic_vector(0 to C_PLB_NUM_MASTERS-1);
        IP2INTC_Irpt        : out std_logic;

        -- DDR interface signals
        DDR_Clk             : out std_logic_vector(0 to C_NUM_CLK_PAIRS-1);
        DDR_Clkn            : out std_logic_vector(0 to C_NUM_CLK_PAIRS-1);
        DDR_CKE             : out std_logic_vector(0 to C_NUM_BANKS_MEM-1);
        DDR_CSn             : out std_logic_vector(0 to C_NUM_BANKS_MEM-1);
        DDR_RASn            : out std_logic;
        DDR_CASn            : out std_logic;
        DDR_WEn             : out std_logic;
        DDR_DM              : out std_logic_vector(0 to C_DDR_DWIDTH/8-1);
        DDR_BankAddr        : out std_logic_vector(0 to C_DDR_BANK_AWIDTH-1);
        DDR_Addr            : out std_logic_vector(0 to C_DDR_AWIDTH-1);
        DDR_DQ_o            : out std_logic_vector(0 to C_DDR_DWIDTH-1);
        DDR_DQ_i            : in  std_logic_vector(0 to C_DDR_DWIDTH-1);
        DDR_DQ_t            : out std_logic_vector(0 to C_DDR_DWIDTH-1);
        DDR_DQS_i           : in  std_logic_vector(0 to C_DDR_DWIDTH/8-1);
        DDR_DQS_o           : out std_logic_vector(0 to C_DDR_DWIDTH/8-1);
        DDR_DQS_t           : out std_logic_vector(0 to C_DDR_DWIDTH/8-1);

        -- DDR ECC interface signals
        DDR_DM_ECC          : out std_logic;
        DDR_DQ_ECC_o        : out std_logic_vector(0 to NUM_ECC_BITS-1);
        DDR_DQ_ECC_i        : in  std_logic_vector(0 to NUM_ECC_BITS-1);
        DDR_DQ_ECC_t        : out std_logic_vector(0 to NUM_ECC_BITS-1);
        DDR_DQS_ECC_i       : in  std_logic;
        DDR_DQS_ECC_o       : out std_logic;
        DDR_DQS_ECC_t       : out std_logic;

        -- Timer/Interrupt signals
        DDR_Init_done       : out std_logic

 );

    -- fan-out attributes for Synplicity
    attribute SYN_MAXFAN                    : integer;
    attribute SYN_MAXFAN   of PLB_Clk       : signal is 10000;
    attribute SYN_MAXFAN   of PLB_Rst       : signal is 10000;
                                           
    --fan-out attributes for XST           
    attribute MAX_FANOUT                    : string;
    attribute MAX_FANOUT   of PLB_Clk       : signal is "10000";
    attribute MAX_FANOUT   of PLB_Rst       : signal is "10000";
    
    -----------------------------------------------------------------
    -- Start of PSFUtil MPD attributes              
    -----------------------------------------------------------------
    attribute IP_GROUP                      : string;
    attribute IP_GROUP of plb_ddr           : entity is "LOGICORE";
    
    attribute RUN_NGCBUILD                  : string;
    attribute RUN_NGCBUILD of plb_ddr       : entity is "TRUE";

    attribute MIN_SIZE                      : string;
    attribute MIN_SIZE of C_MEM0_BASEADDR   : constant is "0x08";
    attribute MIN_SIZE of C_MEM1_BASEADDR   : constant is "0x08";
    attribute MIN_SIZE of C_MEM2_BASEADDR   : constant is "0x08";
    attribute MIN_SIZE of C_MEM3_BASEADDR   : constant is "0x08";
    
    attribute ASSIGNMENT                    : string;
    attribute ASSIGNMENT of C_MEM0_BASEADDR : constant is "REQUIRE";
    attribute ASSIGNMENT of C_MEM0_HIGHADDR : constant is "REQUIRE";
    
    attribute ASSIGNMENT of C_PLB_DWIDTH    : constant is "CONSTANT"; 
    attribute ASSIGNMENT of C_PLB_AWIDTH    : constant is "CONSTANT";

    attribute SIGIS                         : string;
    attribute SIGIS of PLB_Clk              : signal is "Clk";
    attribute SIGIS of PLB_Rst              : signal is "Rst";
    attribute SIGIS of IP2INTC_Irpt         : signal is "INTR_EDGE_RISING";
    
    attribute XRANGE                        : string;
    attribute XRANGE of C_NUM_BANKS_MEM     : constant is "(1:4)";
    attribute XRANGE of C_NUM_CLK_PAIRS     : constant is "(1:4)";    
    attribute XRANGE of C_DDR_CAS_LAT       : constant is "(2,3)";
    attribute XRANGE of C_DDR_DWIDTH        : constant is "(32,64)";
    
    attribute XRANGE of C_ECC_SEC_THRESHOLD : constant is "(1:4096)";
    attribute XRANGE of C_ECC_DEC_THRESHOLD : constant is "(1:4096)";
    attribute XRANGE of C_ECC_PEC_THRESHOLD : constant is "(1:4096)";
    attribute XRANGE of NUM_ECC_BITS        : constant is "(7)";
    
    attribute ADDR_TYPE                     : string;
    attribute ADDR_TYPE of C_MEM0_BASEADDR  : constant is "MEMORY";  
    attribute ADDR_TYPE of C_MEM0_HIGHADDR  : constant is "MEMORY";  
    attribute ADDR_TYPE of C_MEM1_BASEADDR  : constant is "MEMORY";  
    attribute ADDR_TYPE of C_MEM1_HIGHADDR  : constant is "MEMORY";  
    attribute ADDR_TYPE of C_MEM2_BASEADDR  : constant is "MEMORY";  
    attribute ADDR_TYPE of C_MEM2_HIGHADDR  : constant is "MEMORY";  
    attribute ADDR_TYPE of C_MEM3_BASEADDR  : constant is "MEMORY";  
    attribute ADDR_TYPE of C_MEM3_HIGHADDR  : constant is "MEMORY";  
    attribute ADDR_TYPE of C_ECC_BASEADDR   : constant is "REGISTER";
    attribute ADDR_TYPE of C_ECC_HIGHADDR   : constant is "REGISTER";                    
                           
    -----------------------------------------------------------------
    -- End of PSFUtil MPD attributes              
    -----------------------------------------------------------------                           

end entity plb_ddr;

-----------------------------------------------------------------------------
-- Architecture section
-----------------------------------------------------------------------------

architecture imp of plb_ddr is

-----------------------------------------------------------------------------
-- Constant declarations
-----------------------------------------------------------------------------

-- addresses are now expected to be 64-bits wide - create constants to 
-- zero the most significant address bits
constant ZERO_ADDR_PAD  : std_logic_vector(0 to 64-C_PLB_AWIDTH-1) := (others => '0');

-- identifiers for ECC register space in ARD arrays
constant ECC_REG : integer := 110;

constant IPIF_INTR_BASEADDR : std_logic_vector(0 to C_PLB_AWIDTH-1) := C_ECC_BASEADDR or x"00000100";
constant IPIF_INTR_HIGHADDR : std_logic_vector(0 to C_PLB_AWIDTH-1) := C_ECC_HIGHADDR or x"00000100";

-----------------------------------------------------------------------------
-- Function declarations
-----------------------------------------------------------------------------
-----------------------------------------------------------------------------
-- Function: GET_ARD_ARRAY_SIZE
-- Purpose: Get array size for ARD_ID_ARRAY, ARD_DWIDTH_ARRAY, and 
--          ARD_NUM_CE_ARRAY
-----------------------------------------------------------------------------
function GET_ARD_ARRAY_SIZE return INTEGER is
variable ARD_ARRAY_SIZE : INTEGER;
begin

    if ((C_INCLUDE_ECC_SUPPORT = 0) or 
        (C_INCLUDE_ECC_SUPPORT = 1 and C_ENABLE_ECC_REG = 0)) then    
        ARD_ARRAY_SIZE := C_NUM_BANKS_MEM;
    elsif (C_INCLUDE_ECC_SUPPORT = 1 and C_ENABLE_ECC_REG = 1 and C_INCLUDE_ECC_INTR = 0) then
        ARD_ARRAY_SIZE := C_NUM_BANKS_MEM + 1;
    elsif (C_INCLUDE_ECC_SUPPORT = 1 and C_ENABLE_ECC_REG = 1 and C_INCLUDE_ECC_INTR = 1) then
        ARD_ARRAY_SIZE := C_NUM_BANKS_MEM + 2;
    end if;
  
    return ARD_ARRAY_SIZE;
    
end function GET_ARD_ARRAY_SIZE;

-----------------------------------------------------------------------------
-- Function: GET_ARD_ADDR_ARRAY_SIZE
-- Purpose: Get array size for ARD_ID_ARRAY, ARD_DWIDTH_ARRAY, and 
--          ARD_NUM_CE_ARRAY
-----------------------------------------------------------------------------
function GET_ARD_ADDR_ARRAY_SIZE return INTEGER is
variable ARD_ADDR_ARRAY_SIZE : INTEGER;
begin

    if ((C_INCLUDE_ECC_SUPPORT = 0) or 
        (C_INCLUDE_ECC_SUPPORT = 1 and C_ENABLE_ECC_REG = 0)) then           
        if (C_NUM_BANKS_MEM = 1) then
            ARD_ADDR_ARRAY_SIZE := 2;
        else
            ARD_ADDR_ARRAY_SIZE := C_NUM_BANKS_MEM * 2;
        end if;
    elsif (C_INCLUDE_ECC_SUPPORT = 1 and C_ENABLE_ECC_REG = 1 and C_INCLUDE_ECC_INTR = 0) then
        if (C_NUM_BANKS_MEM = 1) then
            ARD_ADDR_ARRAY_SIZE := 4;
        else
            ARD_ADDR_ARRAY_SIZE := (C_NUM_BANKS_MEM * 2) + 2;
        end if;
    elsif (C_INCLUDE_ECC_SUPPORT = 1 and C_ENABLE_ECC_REG = 1 and C_INCLUDE_ECC_INTR = 1) then
        if (C_NUM_BANKS_MEM = 1) then
            ARD_ADDR_ARRAY_SIZE := 6;
        else
            ARD_ADDR_ARRAY_SIZE := (C_NUM_BANKS_MEM * 2) + 4;
        end if;
    end if;
  
    return ARD_ADDR_ARRAY_SIZE;
    
end function GET_ARD_ADDR_ARRAY_SIZE;

-----------------------------------------------------------------------------
-- Function: GET_IP_ARRAY_SIZE
-- Purpose: Get array size for IP_INTR_MODE_ARRAY
-----------------------------------------------------------------------------
function GET_IP_ARRAY_SIZE return INTEGER is
variable IP_ARRAY_SIZE : INTEGER;
begin

    if (C_INCLUDE_ECC_SUPPORT = 0) then    
        IP_ARRAY_SIZE := 1;
    elsif (C_INCLUDE_ECC_SUPPORT = 1 and C_INCLUDE_ECC_INTR = 0) then
        IP_ARRAY_SIZE := 1;
    elsif (C_INCLUDE_ECC_SUPPORT = 1 and C_INCLUDE_ECC_INTR = 1) then
        IP_ARRAY_SIZE := 3;
    end if;
  
    return IP_ARRAY_SIZE;
    
end function GET_IP_ARRAY_SIZE;

-----------------------------------------------------------------------------
-- Function: GET_ARD_ID_ARRAY
-- Purpose: Fill ARD_ID_ARRAY based on input parameters
-----------------------------------------------------------------------------
function GET_ARD_ID_ARRAY return INTEGER_ARRAY_TYPE is
variable ARD_ID_ARRAY_V : INTEGER_ARRAY_TYPE (0 to GET_ARD_ARRAY_SIZE-1);
begin

    if ((C_INCLUDE_ECC_SUPPORT = 0) or 
        (C_INCLUDE_ECC_SUPPORT = 1 and C_ENABLE_ECC_REG = 0)) then  
        
        if (C_NUM_BANKS_MEM = 1) then
            ARD_ID_ARRAY_V(0) := USER_00;           
        elsif (C_NUM_BANKS_MEM = 2) then
            ARD_ID_ARRAY_V(0) := USER_00;    
            ARD_ID_ARRAY_V(1) := USER_01;    
        elsif (C_NUM_BANKS_MEM = 3) then
            ARD_ID_ARRAY_V(0) := USER_00;    
            ARD_ID_ARRAY_V(1) := USER_01;     
            ARD_ID_ARRAY_V(2) := USER_02;     
        elsif (C_NUM_BANKS_MEM = 4) then
            ARD_ID_ARRAY_V(0) := USER_00;    
            ARD_ID_ARRAY_V(1) := USER_01;     
            ARD_ID_ARRAY_V(2) := USER_02;     
            ARD_ID_ARRAY_V(3) := USER_03;  
        end if;      
        
    elsif (C_INCLUDE_ECC_SUPPORT = 1 and C_ENABLE_ECC_REG = 1 and C_INCLUDE_ECC_INTR = 0) then

        if (C_NUM_BANKS_MEM = 1) then
            ARD_ID_ARRAY_V(0) := USER_00;           
            ARD_ID_ARRAY_V(1) := ECC_REG;    
        elsif (C_NUM_BANKS_MEM = 2) then
            ARD_ID_ARRAY_V(0) := USER_00;    
            ARD_ID_ARRAY_V(1) := USER_01;    
            ARD_ID_ARRAY_V(2) := ECC_REG;     
        elsif (C_NUM_BANKS_MEM = 3) then
            ARD_ID_ARRAY_V(0) := USER_00;    
            ARD_ID_ARRAY_V(1) := USER_01;     
            ARD_ID_ARRAY_V(2) := USER_02;     
            ARD_ID_ARRAY_V(3) := ECC_REG;  
        elsif (C_NUM_BANKS_MEM = 4) then
            ARD_ID_ARRAY_V(0) := USER_00;    
            ARD_ID_ARRAY_V(1) := USER_01;     
            ARD_ID_ARRAY_V(2) := USER_02;     
            ARD_ID_ARRAY_V(3) := USER_03;  
            ARD_ID_ARRAY_V(4) := ECC_REG;  
        end if;      

    elsif (C_INCLUDE_ECC_SUPPORT = 1 and C_ENABLE_ECC_REG = 1 and C_INCLUDE_ECC_INTR = 1) then

        if (C_NUM_BANKS_MEM = 1) then
            ARD_ID_ARRAY_V(0) := USER_00;           
            ARD_ID_ARRAY_V(1) := ECC_REG;    
            ARD_ID_ARRAY_V(2) := IPIF_INTR;
       elsif (C_NUM_BANKS_MEM = 2) then
            ARD_ID_ARRAY_V(0) := USER_00;    
            ARD_ID_ARRAY_V(1) := USER_01;    
            ARD_ID_ARRAY_V(2) := ECC_REG;     
            ARD_ID_ARRAY_V(3) := IPIF_INTR;
        elsif (C_NUM_BANKS_MEM = 3) then
            ARD_ID_ARRAY_V(0) := USER_00;    
            ARD_ID_ARRAY_V(1) := USER_01;     
            ARD_ID_ARRAY_V(2) := USER_02;     
            ARD_ID_ARRAY_V(3) := ECC_REG;  
            ARD_ID_ARRAY_V(4) := IPIF_INTR;
        elsif (C_NUM_BANKS_MEM = 4) then
            ARD_ID_ARRAY_V(0) := USER_00;    
            ARD_ID_ARRAY_V(1) := USER_01;     
            ARD_ID_ARRAY_V(2) := USER_02;     
            ARD_ID_ARRAY_V(3) := USER_03;  
            ARD_ID_ARRAY_V(4) := ECC_REG;  
            ARD_ID_ARRAY_V(5) := IPIF_INTR;
        end if;      

    end if;
  
    return ARD_ID_ARRAY_V;
    
end function GET_ARD_ID_ARRAY;

-----------------------------------------------------------------------------
-- Function: GET_ARD_ADDR_RANGE_ARRAY
-- Purpose: Fill ARD_ADDR_RANGE_ARRAY based on input parameters
-----------------------------------------------------------------------------
function GET_ARD_ADDR_RANGE_ARRAY return SLV64_ARRAY_TYPE is
variable ARD_ADDR_RANGE_ARRAY_V : SLV64_ARRAY_TYPE (0 to GET_ARD_ADDR_ARRAY_SIZE-1);
begin

    if ((C_INCLUDE_ECC_SUPPORT = 0) or 
        (C_INCLUDE_ECC_SUPPORT = 1 and C_ENABLE_ECC_REG = 0)) then    

        if (C_NUM_BANKS_MEM = 1) then
            ARD_ADDR_RANGE_ARRAY_V(0) := ZERO_ADDR_PAD&C_MEM0_BASEADDR;      -- PLB DDR base address MEM0
            ARD_ADDR_RANGE_ARRAY_V(1) := ZERO_ADDR_PAD&C_MEM0_HIGHADDR;      -- PLB DDR high address MEM0
        elsif (C_NUM_BANKS_MEM = 2) then
            ARD_ADDR_RANGE_ARRAY_V(0) := ZERO_ADDR_PAD&C_MEM0_BASEADDR;      -- PLB DDR base address MEM0
            ARD_ADDR_RANGE_ARRAY_V(1) := ZERO_ADDR_PAD&C_MEM0_HIGHADDR;      -- PLB DDR high address MEM0
            ARD_ADDR_RANGE_ARRAY_V(2) := ZERO_ADDR_PAD&C_MEM1_BASEADDR;      -- PLB DDR base address MEM1
            ARD_ADDR_RANGE_ARRAY_V(3) := ZERO_ADDR_PAD&C_MEM1_HIGHADDR;      -- PLB DDR high address MEM1
        elsif (C_NUM_BANKS_MEM = 3) then
            ARD_ADDR_RANGE_ARRAY_V(0) := ZERO_ADDR_PAD&C_MEM0_BASEADDR;      -- PLB DDR base address MEM0
            ARD_ADDR_RANGE_ARRAY_V(1) := ZERO_ADDR_PAD&C_MEM0_HIGHADDR;      -- PLB DDR high address MEM0
            ARD_ADDR_RANGE_ARRAY_V(2) := ZERO_ADDR_PAD&C_MEM1_BASEADDR;      -- PLB DDR base address MEM1
            ARD_ADDR_RANGE_ARRAY_V(3) := ZERO_ADDR_PAD&C_MEM1_HIGHADDR;      -- PLB DDR high address MEM1
            ARD_ADDR_RANGE_ARRAY_V(4) := ZERO_ADDR_PAD&C_MEM2_BASEADDR;      -- PLB DDR base address MEM2
            ARD_ADDR_RANGE_ARRAY_V(5) := ZERO_ADDR_PAD&C_MEM2_HIGHADDR;      -- PLB DDR high address MEM2
        elsif (C_NUM_BANKS_MEM = 4) then
            ARD_ADDR_RANGE_ARRAY_V(0) := ZERO_ADDR_PAD&C_MEM0_BASEADDR;      -- PLB DDR base address MEM0
            ARD_ADDR_RANGE_ARRAY_V(1) := ZERO_ADDR_PAD&C_MEM0_HIGHADDR;      -- PLB DDR high address MEM0
            ARD_ADDR_RANGE_ARRAY_V(2) := ZERO_ADDR_PAD&C_MEM1_BASEADDR;      -- PLB DDR base address MEM1
            ARD_ADDR_RANGE_ARRAY_V(3) := ZERO_ADDR_PAD&C_MEM1_HIGHADDR;      -- PLB DDR high address MEM1
            ARD_ADDR_RANGE_ARRAY_V(4) := ZERO_ADDR_PAD&C_MEM2_BASEADDR;      -- PLB DDR base address MEM2
            ARD_ADDR_RANGE_ARRAY_V(5) := ZERO_ADDR_PAD&C_MEM2_HIGHADDR;      -- PLB DDR high address MEM2
            ARD_ADDR_RANGE_ARRAY_V(6) := ZERO_ADDR_PAD&C_MEM3_BASEADDR;      -- PLB DDR base address MEM3
            ARD_ADDR_RANGE_ARRAY_V(7) := ZERO_ADDR_PAD&C_MEM3_HIGHADDR;      -- PLB DDR high address MEM3
        end if;      
        
    elsif (C_INCLUDE_ECC_SUPPORT = 1 and C_ENABLE_ECC_REG = 1 and C_INCLUDE_ECC_INTR = 0) then

        if (C_NUM_BANKS_MEM = 1) then
            ARD_ADDR_RANGE_ARRAY_V(0) := ZERO_ADDR_PAD&C_MEM0_BASEADDR;     -- PLB DDR base address MEM0
            ARD_ADDR_RANGE_ARRAY_V(1) := ZERO_ADDR_PAD&C_MEM0_HIGHADDR;     -- PLB DDR high address MEM0
            ARD_ADDR_RANGE_ARRAY_V(2) := ZERO_ADDR_PAD&C_ECC_BASEADDR;      -- ECC register base address 
            ARD_ADDR_RANGE_ARRAY_V(3) := ZERO_ADDR_PAD&C_ECC_HIGHADDR;      -- ECC register high address 
        elsif (C_NUM_BANKS_MEM = 2) then
            ARD_ADDR_RANGE_ARRAY_V(0) := ZERO_ADDR_PAD&C_MEM0_BASEADDR;     -- PLB DDR base address MEM0
            ARD_ADDR_RANGE_ARRAY_V(1) := ZERO_ADDR_PAD&C_MEM0_HIGHADDR;     -- PLB DDR high address MEM0
            ARD_ADDR_RANGE_ARRAY_V(2) := ZERO_ADDR_PAD&C_MEM1_BASEADDR;     -- PLB DDR base address MEM1
            ARD_ADDR_RANGE_ARRAY_V(3) := ZERO_ADDR_PAD&C_MEM1_HIGHADDR;     -- PLB DDR high address MEM1
            ARD_ADDR_RANGE_ARRAY_V(4) := ZERO_ADDR_PAD&C_ECC_BASEADDR;      -- ECC register base address 
            ARD_ADDR_RANGE_ARRAY_V(5) := ZERO_ADDR_PAD&C_ECC_HIGHADDR;      -- ECC register high address 
        elsif (C_NUM_BANKS_MEM = 3) then
            ARD_ADDR_RANGE_ARRAY_V(0) := ZERO_ADDR_PAD&C_MEM0_BASEADDR;     -- PLB DDR base address MEM0
            ARD_ADDR_RANGE_ARRAY_V(1) := ZERO_ADDR_PAD&C_MEM0_HIGHADDR;     -- PLB DDR high address MEM0
            ARD_ADDR_RANGE_ARRAY_V(2) := ZERO_ADDR_PAD&C_MEM1_BASEADDR;     -- PLB DDR base address MEM1
            ARD_ADDR_RANGE_ARRAY_V(3) := ZERO_ADDR_PAD&C_MEM1_HIGHADDR;     -- PLB DDR high address MEM1
            ARD_ADDR_RANGE_ARRAY_V(4) := ZERO_ADDR_PAD&C_MEM2_BASEADDR;     -- PLB DDR base address MEM2
            ARD_ADDR_RANGE_ARRAY_V(5) := ZERO_ADDR_PAD&C_MEM2_HIGHADDR;     -- PLB DDR high address MEM2
            ARD_ADDR_RANGE_ARRAY_V(6) := ZERO_ADDR_PAD&C_ECC_BASEADDR;      -- ECC register base address 
            ARD_ADDR_RANGE_ARRAY_V(7) := ZERO_ADDR_PAD&C_ECC_HIGHADDR;      -- ECC register high address 
        elsif (C_NUM_BANKS_MEM = 4) then
            ARD_ADDR_RANGE_ARRAY_V(0) := ZERO_ADDR_PAD&C_MEM0_BASEADDR;     -- PLB DDR base address MEM0
            ARD_ADDR_RANGE_ARRAY_V(1) := ZERO_ADDR_PAD&C_MEM0_HIGHADDR;     -- PLB DDR high address MEM0
            ARD_ADDR_RANGE_ARRAY_V(2) := ZERO_ADDR_PAD&C_MEM1_BASEADDR;     -- PLB DDR base address MEM1
            ARD_ADDR_RANGE_ARRAY_V(3) := ZERO_ADDR_PAD&C_MEM1_HIGHADDR;     -- PLB DDR high address MEM1
            ARD_ADDR_RANGE_ARRAY_V(4) := ZERO_ADDR_PAD&C_MEM2_BASEADDR;     -- PLB DDR base address MEM2
            ARD_ADDR_RANGE_ARRAY_V(5) := ZERO_ADDR_PAD&C_MEM2_HIGHADDR;     -- PLB DDR high address MEM2
            ARD_ADDR_RANGE_ARRAY_V(6) := ZERO_ADDR_PAD&C_MEM3_BASEADDR;     -- PLB DDR base address MEM3
            ARD_ADDR_RANGE_ARRAY_V(7) := ZERO_ADDR_PAD&C_MEM3_HIGHADDR;     -- PLB DDR high address MEM3
            ARD_ADDR_RANGE_ARRAY_V(8) := ZERO_ADDR_PAD&C_ECC_BASEADDR;      -- ECC register base address 
            ARD_ADDR_RANGE_ARRAY_V(9) := ZERO_ADDR_PAD&C_ECC_HIGHADDR;      -- ECC register high address 
        end if;      
       
    elsif (C_INCLUDE_ECC_SUPPORT = 1 and C_ENABLE_ECC_REG = 1 and C_INCLUDE_ECC_INTR = 1) then

        if (C_NUM_BANKS_MEM = 1) then
            ARD_ADDR_RANGE_ARRAY_V(0) := ZERO_ADDR_PAD&C_MEM0_BASEADDR;     -- PLB DDR base address MEM0
            ARD_ADDR_RANGE_ARRAY_V(1) := ZERO_ADDR_PAD&C_MEM0_HIGHADDR;     -- PLB DDR high address MEM0
            ARD_ADDR_RANGE_ARRAY_V(2) := ZERO_ADDR_PAD&C_ECC_BASEADDR;      -- ECC register base address 
            ARD_ADDR_RANGE_ARRAY_V(3) := ZERO_ADDR_PAD&C_ECC_HIGHADDR;      -- ECC register high address 
            ARD_ADDR_RANGE_ARRAY_V(4) := ZERO_ADDR_PAD&IPIF_INTR_BASEADDR;  -- IPIF interrupt base address
            ARD_ADDR_RANGE_ARRAY_V(5) := ZERO_ADDR_PAD&IPIF_INTR_HIGHADDR;  -- IPIF interrupt high address 
       elsif (C_NUM_BANKS_MEM = 2) then
            ARD_ADDR_RANGE_ARRAY_V(0) := ZERO_ADDR_PAD&C_MEM0_BASEADDR;     -- PLB DDR base address MEM0
            ARD_ADDR_RANGE_ARRAY_V(1) := ZERO_ADDR_PAD&C_MEM0_HIGHADDR;     -- PLB DDR high address MEM0
            ARD_ADDR_RANGE_ARRAY_V(2) := ZERO_ADDR_PAD&C_MEM1_BASEADDR;     -- PLB DDR base address MEM1
            ARD_ADDR_RANGE_ARRAY_V(3) := ZERO_ADDR_PAD&C_MEM1_HIGHADDR;     -- PLB DDR high address MEM1
            ARD_ADDR_RANGE_ARRAY_V(4) := ZERO_ADDR_PAD&C_ECC_BASEADDR;      -- ECC register base address 
            ARD_ADDR_RANGE_ARRAY_V(5) := ZERO_ADDR_PAD&C_ECC_HIGHADDR;      -- ECC register high address 
            ARD_ADDR_RANGE_ARRAY_V(6) := ZERO_ADDR_PAD&IPIF_INTR_BASEADDR;  -- IPIF interrupt base address
            ARD_ADDR_RANGE_ARRAY_V(7) := ZERO_ADDR_PAD&IPIF_INTR_HIGHADDR;  -- IPIF interrupt high address 
       elsif (C_NUM_BANKS_MEM = 3) then
            ARD_ADDR_RANGE_ARRAY_V(0) := ZERO_ADDR_PAD&C_MEM0_BASEADDR;     -- PLB DDR base address MEM0
            ARD_ADDR_RANGE_ARRAY_V(1) := ZERO_ADDR_PAD&C_MEM0_HIGHADDR;     -- PLB DDR high address MEM0
            ARD_ADDR_RANGE_ARRAY_V(2) := ZERO_ADDR_PAD&C_MEM1_BASEADDR;     -- PLB DDR base address MEM1
            ARD_ADDR_RANGE_ARRAY_V(3) := ZERO_ADDR_PAD&C_MEM1_HIGHADDR;     -- PLB DDR high address MEM1
            ARD_ADDR_RANGE_ARRAY_V(4) := ZERO_ADDR_PAD&C_MEM2_BASEADDR;     -- PLB DDR base address MEM2
            ARD_ADDR_RANGE_ARRAY_V(5) := ZERO_ADDR_PAD&C_MEM2_HIGHADDR;     -- PLB DDR high address MEM2
            ARD_ADDR_RANGE_ARRAY_V(6) := ZERO_ADDR_PAD&C_ECC_BASEADDR;      -- ECC register base address 
            ARD_ADDR_RANGE_ARRAY_V(7) := ZERO_ADDR_PAD&C_ECC_HIGHADDR;      -- ECC register high address 
            ARD_ADDR_RANGE_ARRAY_V(8) := ZERO_ADDR_PAD&IPIF_INTR_BASEADDR;  -- IPIF interrupt base address
            ARD_ADDR_RANGE_ARRAY_V(9) := ZERO_ADDR_PAD&IPIF_INTR_HIGHADDR;  -- IPIF interrupt high address 
        elsif (C_NUM_BANKS_MEM = 4) then
            ARD_ADDR_RANGE_ARRAY_V(0) := ZERO_ADDR_PAD&C_MEM0_BASEADDR;     -- PLB DDR base address MEM0
            ARD_ADDR_RANGE_ARRAY_V(1) := ZERO_ADDR_PAD&C_MEM0_HIGHADDR;     -- PLB DDR high address MEM0
            ARD_ADDR_RANGE_ARRAY_V(2) := ZERO_ADDR_PAD&C_MEM1_BASEADDR;     -- PLB DDR base address MEM1
            ARD_ADDR_RANGE_ARRAY_V(3) := ZERO_ADDR_PAD&C_MEM1_HIGHADDR;     -- PLB DDR high address MEM1
            ARD_ADDR_RANGE_ARRAY_V(4) := ZERO_ADDR_PAD&C_MEM2_BASEADDR;     -- PLB DDR base address MEM2
            ARD_ADDR_RANGE_ARRAY_V(5) := ZERO_ADDR_PAD&C_MEM2_HIGHADDR;     -- PLB DDR high address MEM2
            ARD_ADDR_RANGE_ARRAY_V(6) := ZERO_ADDR_PAD&C_MEM3_BASEADDR;     -- PLB DDR base address MEM3
            ARD_ADDR_RANGE_ARRAY_V(7) := ZERO_ADDR_PAD&C_MEM3_HIGHADDR;     -- PLB DDR high address MEM3
            ARD_ADDR_RANGE_ARRAY_V(8) := ZERO_ADDR_PAD&C_ECC_BASEADDR;      -- ECC register base address 
            ARD_ADDR_RANGE_ARRAY_V(9) := ZERO_ADDR_PAD&C_ECC_HIGHADDR;      -- ECC register high address 
            ARD_ADDR_RANGE_ARRAY_V(10) := ZERO_ADDR_PAD&IPIF_INTR_BASEADDR; -- IPIF interrupt base address
            ARD_ADDR_RANGE_ARRAY_V(11) := ZERO_ADDR_PAD&IPIF_INTR_HIGHADDR; -- IPIF interrupt high address 
        end if; 
    
    end if;
  
    return ARD_ADDR_RANGE_ARRAY_V;
    
end function GET_ARD_ADDR_RANGE_ARRAY;

-----------------------------------------------------------------------------
-- Function: GET_ARD_DWIDTH_ARRAY
-- Purpose: Fill ARD_DWIDTH_ARRAY based on input parameters
-----------------------------------------------------------------------------
function GET_ARD_DWIDTH_ARRAY return INTEGER_ARRAY_TYPE is
variable ARD_DWIDTH_ARRAY_V : INTEGER_ARRAY_TYPE (0 to GET_ARD_ARRAY_SIZE-1);
begin

    if ((C_INCLUDE_ECC_SUPPORT = 0) or 
        (C_INCLUDE_ECC_SUPPORT = 1 and C_ENABLE_ECC_REG = 0)) then    
        
        if (C_NUM_BANKS_MEM = 1) then
            ARD_DWIDTH_ARRAY_V(0) := C_PLB_DWIDTH;      -- User0 data width (memory space)
        elsif (C_NUM_BANKS_MEM = 2) then
            ARD_DWIDTH_ARRAY_V(0) := C_PLB_DWIDTH;      -- User0 data width (memory space)
            ARD_DWIDTH_ARRAY_V(1) := C_PLB_DWIDTH;      -- User1 data width (memory space)
        elsif (C_NUM_BANKS_MEM = 3) then
            ARD_DWIDTH_ARRAY_V(0) := C_PLB_DWIDTH;      -- User0 data width (memory space)
            ARD_DWIDTH_ARRAY_V(1) := C_PLB_DWIDTH;      -- User1 data width (memory space)
            ARD_DWIDTH_ARRAY_V(2) := C_PLB_DWIDTH;      -- User2 data width (memory space)
        elsif (C_NUM_BANKS_MEM = 4) then
            ARD_DWIDTH_ARRAY_V(0) := C_PLB_DWIDTH;      -- User0 data width (memory space)
            ARD_DWIDTH_ARRAY_V(1) := C_PLB_DWIDTH;      -- User1 data width (memory space)
            ARD_DWIDTH_ARRAY_V(2) := C_PLB_DWIDTH;      -- User2 data width (memory space)
            ARD_DWIDTH_ARRAY_V(3) := C_PLB_DWIDTH;      -- User3 data width (memory space)
        end if;      
                
    elsif (C_INCLUDE_ECC_SUPPORT = 1 and C_ENABLE_ECC_REG = 1 and C_INCLUDE_ECC_INTR = 0) then

        if (C_NUM_BANKS_MEM = 1) then
            ARD_DWIDTH_ARRAY_V(0) := C_PLB_DWIDTH;      -- User0 data width (memory space)
            ARD_DWIDTH_ARRAY_V(1) := 32;                -- User1 data width (ECC register space)
        elsif (C_NUM_BANKS_MEM = 2) then
            ARD_DWIDTH_ARRAY_V(0) := C_PLB_DWIDTH;      -- User0 data width (memory space)
            ARD_DWIDTH_ARRAY_V(1) := C_PLB_DWIDTH;      -- User1 data width (memory space)
            ARD_DWIDTH_ARRAY_V(2) := 32;                -- User2 data width (ECC register space)
        elsif (C_NUM_BANKS_MEM = 3) then
            ARD_DWIDTH_ARRAY_V(0) := C_PLB_DWIDTH;      -- User0 data width (memory space)
            ARD_DWIDTH_ARRAY_V(1) := C_PLB_DWIDTH;      -- User1 data width (memory space)
            ARD_DWIDTH_ARRAY_V(2) := C_PLB_DWIDTH;      -- User2 data width (memory space)
            ARD_DWIDTH_ARRAY_V(3) := 32;                -- User3 data width (ECC register space)
        elsif (C_NUM_BANKS_MEM = 4) then
            ARD_DWIDTH_ARRAY_V(0) := C_PLB_DWIDTH;      -- User0 data width (memory space)
            ARD_DWIDTH_ARRAY_V(1) := C_PLB_DWIDTH;      -- User1 data width (memory space)
            ARD_DWIDTH_ARRAY_V(2) := C_PLB_DWIDTH;      -- User2 data width (memory space)
            ARD_DWIDTH_ARRAY_V(3) := C_PLB_DWIDTH;      -- User3 data width (memory space)
            ARD_DWIDTH_ARRAY_V(4) := 32;                -- User4 data width (ECC register space)
       end if;      

    elsif (C_INCLUDE_ECC_SUPPORT = 1 and C_ENABLE_ECC_REG = 1 and C_INCLUDE_ECC_INTR = 1) then

        if (C_NUM_BANKS_MEM = 1) then
            ARD_DWIDTH_ARRAY_V(0) := C_PLB_DWIDTH;      -- User0 data width (memory space)
            ARD_DWIDTH_ARRAY_V(1) := 32;                -- User1 data width (ECC register space)
            ARD_DWIDTH_ARRAY_V(2) := 64;                -- IPIF Interrupt data width
       elsif (C_NUM_BANKS_MEM = 2) then
            ARD_DWIDTH_ARRAY_V(0) := C_PLB_DWIDTH;      -- User0 data width (memory space)
            ARD_DWIDTH_ARRAY_V(1) := C_PLB_DWIDTH;      -- User1 data width (memory space)
            ARD_DWIDTH_ARRAY_V(2) := 32;                -- User2 data width (ECC register space)
            ARD_DWIDTH_ARRAY_V(3) := 64;                -- IPIF Interrupt data width
        elsif (C_NUM_BANKS_MEM = 3) then
            ARD_DWIDTH_ARRAY_V(0) := C_PLB_DWIDTH;      -- User0 data width (memory space)
            ARD_DWIDTH_ARRAY_V(1) := C_PLB_DWIDTH;      -- User1 data width (memory space)
            ARD_DWIDTH_ARRAY_V(2) := C_PLB_DWIDTH;      -- User2 data width (memory space)
            ARD_DWIDTH_ARRAY_V(3) := 32;                -- User3 data width (ECC register space)
            ARD_DWIDTH_ARRAY_V(4) := 64;                -- IPIF Interrupt data width
        elsif (C_NUM_BANKS_MEM = 4) then
            ARD_DWIDTH_ARRAY_V(0) := C_PLB_DWIDTH;      -- User0 data width (memory space)
            ARD_DWIDTH_ARRAY_V(1) := C_PLB_DWIDTH;      -- User1 data width (memory space)
            ARD_DWIDTH_ARRAY_V(2) := C_PLB_DWIDTH;      -- User2 data width (memory space)
            ARD_DWIDTH_ARRAY_V(3) := C_PLB_DWIDTH;      -- User3 data width (memory space)
            ARD_DWIDTH_ARRAY_V(4) := 32;                -- User4 data width (ECC register space)
            ARD_DWIDTH_ARRAY_V(5) := 64;                -- IPIF Interrupt data width
       end if;      

    end if;
  
    return ARD_DWIDTH_ARRAY_V;
    
end function GET_ARD_DWIDTH_ARRAY;

-----------------------------------------------------------------------------
-- Function: GET_ARD_NUM_CE_ARRAY
-- Purpose: Fill ARD_NUM_CE_ARRAY based on input parameters
-----------------------------------------------------------------------------
function GET_ARD_NUM_CE_ARRAY return INTEGER_ARRAY_TYPE is
variable ARD_NUM_CE_ARRAY_V : INTEGER_ARRAY_TYPE (0 to GET_ARD_ARRAY_SIZE-1);
begin

    if ((C_INCLUDE_ECC_SUPPORT = 0) or 
        (C_INCLUDE_ECC_SUPPORT = 1 and C_ENABLE_ECC_REG = 0)) then    
 
        if (C_NUM_BANKS_MEM = 1) then
            ARD_NUM_CE_ARRAY_V(0) := 1;  
        elsif (C_NUM_BANKS_MEM = 2) then
            ARD_NUM_CE_ARRAY_V(0) := 1;  
            ARD_NUM_CE_ARRAY_V(1) := 1;  
        elsif (C_NUM_BANKS_MEM = 3) then
            ARD_NUM_CE_ARRAY_V(0) := 1;  
            ARD_NUM_CE_ARRAY_V(1) := 1;  
            ARD_NUM_CE_ARRAY_V(2) := 1;  
        elsif (C_NUM_BANKS_MEM = 4) then
            ARD_NUM_CE_ARRAY_V(0) := 1;  
            ARD_NUM_CE_ARRAY_V(1) := 1;  
            ARD_NUM_CE_ARRAY_V(2) := 1;  
            ARD_NUM_CE_ARRAY_V(3) := 1;  
        end if;      
        
    elsif (C_INCLUDE_ECC_SUPPORT = 1 and C_ENABLE_ECC_REG = 1 and C_INCLUDE_ECC_INTR = 0) then

        if (C_NUM_BANKS_MEM = 1) then
            ARD_NUM_CE_ARRAY_V(0) := 1;  
            ARD_NUM_CE_ARRAY_V(1) := 5;         -- Number of CEs for ECC register bank     
        elsif (C_NUM_BANKS_MEM = 2) then
            ARD_NUM_CE_ARRAY_V(0) := 1;  
            ARD_NUM_CE_ARRAY_V(1) := 1;  
            ARD_NUM_CE_ARRAY_V(2) := 5;         -- Number of CEs for ECC register bank     
       elsif (C_NUM_BANKS_MEM = 3) then
            ARD_NUM_CE_ARRAY_V(0) := 1;  
            ARD_NUM_CE_ARRAY_V(1) := 1;  
            ARD_NUM_CE_ARRAY_V(2) := 1;  
            ARD_NUM_CE_ARRAY_V(3) := 5;         -- Number of CEs for ECC register bank     
        elsif (C_NUM_BANKS_MEM = 4) then
            ARD_NUM_CE_ARRAY_V(0) := 1;  
            ARD_NUM_CE_ARRAY_V(1) := 1;  
            ARD_NUM_CE_ARRAY_V(2) := 1;  
            ARD_NUM_CE_ARRAY_V(3) := 1;  
            ARD_NUM_CE_ARRAY_V(4) := 5;         -- Number of CEs for ECC register bank     
        end if;          
    
    elsif (C_INCLUDE_ECC_SUPPORT = 1 and C_ENABLE_ECC_REG = 1 and C_INCLUDE_ECC_INTR = 1) then

        if (C_NUM_BANKS_MEM = 1) then
            ARD_NUM_CE_ARRAY_V(0) := 1;  
            ARD_NUM_CE_ARRAY_V(1) := 5;         -- Number of CEs for ECC register bank     
            ARD_NUM_CE_ARRAY_V(2) := 8;         -- Number of CEs for IPIF interrupt registers            
        elsif (C_NUM_BANKS_MEM = 2) then
            ARD_NUM_CE_ARRAY_V(0) := 1;  
            ARD_NUM_CE_ARRAY_V(1) := 1;  
            ARD_NUM_CE_ARRAY_V(2) := 5;         -- Number of CEs for ECC register bank     
            ARD_NUM_CE_ARRAY_V(3) := 8;         -- Number of CEs for IPIF interrupt registers            
       elsif (C_NUM_BANKS_MEM = 3) then
            ARD_NUM_CE_ARRAY_V(0) := 1;  
            ARD_NUM_CE_ARRAY_V(1) := 1;  
            ARD_NUM_CE_ARRAY_V(2) := 1;  
            ARD_NUM_CE_ARRAY_V(3) := 5;         -- Number of CEs for ECC register bank     
            ARD_NUM_CE_ARRAY_V(4) := 8;         -- Number of CEs for IPIF interrupt registers            
        elsif (C_NUM_BANKS_MEM = 4) then
            ARD_NUM_CE_ARRAY_V(0) := 1;  
            ARD_NUM_CE_ARRAY_V(1) := 1;  
            ARD_NUM_CE_ARRAY_V(2) := 1;  
            ARD_NUM_CE_ARRAY_V(3) := 1;  
            ARD_NUM_CE_ARRAY_V(4) := 5;         -- Number of CEs for ECC register bank     
            ARD_NUM_CE_ARRAY_V(5) := 8;         -- Number of CEs for IPIF interrupt registers            
        end if;          
              
    end if;
  
    return ARD_NUM_CE_ARRAY_V;
    
end function GET_ARD_NUM_CE_ARRAY;

-----------------------------------------------------------------------------
-- Function: GET_IP_INTR_MODE_ARRAY
-- Purpose: Fill IP_INTR_MODE_ARRAY based on input parameters
-----------------------------------------------------------------------------
function GET_IP_INTR_MODE_ARRAY return INTEGER_ARRAY_TYPE is
variable IP_INTR_MODE_ARRAY_V : INTEGER_ARRAY_TYPE (0 to GET_IP_ARRAY_SIZE-1);
begin

    if (C_INCLUDE_ECC_SUPPORT = 0) then    
        IP_INTR_MODE_ARRAY_V(0) := 0;      
    elsif (C_INCLUDE_ECC_SUPPORT = 1 and C_INCLUDE_ECC_INTR = 0) then
        IP_INTR_MODE_ARRAY_V(0) := 0;      
    elsif (C_INCLUDE_ECC_SUPPORT = 1 and C_INCLUDE_ECC_INTR = 1) then
        IP_INTR_MODE_ARRAY_V(0) := 3;      
        IP_INTR_MODE_ARRAY_V(1) := 3;                
        IP_INTR_MODE_ARRAY_V(2) := 3;                
    end if;
  
    return IP_INTR_MODE_ARRAY_V;
    
end function GET_IP_INTR_MODE_ARRAY;
          

-----------------------------------------------------------------------------
-- Constant declarations
-----------------------------------------------------------------------------
-- set the bus to be used - 
constant OPB_BUS        : integer := 0;
constant PLB_BUS        : integer := 1;

-- set the DDR burst size
-- constant DDR_BRST_SIZE  : integer := C_PLB_DWIDTH/C_DDR_DWIDTH;
-- modified the above line to make the DDR_BRST_SIZE value to be fixed at
-- value 2.
constant DDR_BRST_SIZE: integer    := max2(2, C_PLB_DWIDTH/C_DDR_DWIDTH);

-- dummy value for PLB IPIF workaround
constant DUMMY          : integer := 200;

-- Constants for PLB IPIF (with ECC logic)
-- Call functions to populate these arrays 
constant ARD_ID_ARRAY           : INTEGER_ARRAY_TYPE := GET_ARD_ID_ARRAY;
constant ARD_ADDR_RANGE_ARRAY   : SLV64_ARRAY_TYPE   := GET_ARD_ADDR_RANGE_ARRAY;
constant ARD_DWIDTH_ARRAY       : INTEGER_ARRAY_TYPE := GET_ARD_DWIDTH_ARRAY;
constant ARD_NUM_CE_ARRAY       : INTEGER_ARRAY_TYPE := GET_ARD_NUM_CE_ARRAY;

-- Interrupt constants
constant INCLUDE_DEV_ISC        : boolean           := false;
constant INCLUDE_DEV_PENCODER   : boolean           := false;
constant IP_INTR_MODE_ARRAY     : INTEGER_ARRAY_TYPE := GET_IP_INTR_MODE_ARRAY;
constant IP_NUM_INTR            :  integer := IP_INTR_MODE_ARRAY'length;
constant ZERO_INTREVENT         : std_logic_vector(0 to IP_NUM_INTR-1) := (others => '0');

-- don't include MIR
constant DEV_MIR_ENABLE         : boolean   := false;
constant DEV_BLK_ID             : integer   := 1;

-- set IPIF timeout counter to 64
constant DEV_DPHASE_TIMEOUT     : integer   := 64;

-- set IPIF burst page size 
constant DEV_BURST_ENABLE       : boolean := true;
constant DEV_FAST_DATA_XFER     : boolean := C_INCLUDE_BURST_CACHELN_SUPPORT /= 0; 
constant ADDR_OFFSET            : integer := log2(C_DDR_DWIDTH/8);
constant DEV_BURST_PAGE_SIZE    : integer := 
                    2**(C_DDR_AWIDTH+C_DDR_BANK_AWIDTH+C_DDR_COL_AWIDTH+ADDR_OFFSET); 
constant DEV_MAX_BURST_SIZE     : integer := DEV_BURST_PAGE_SIZE;

-- no FIFOs, just use default generics
-- no master, slave only
constant IP_MASTER_PRESENT      : boolean           := false;

-- zero constants for unused IPIF inputs
constant ZERO_ADDR      : std_logic_vector(0 to C_PLB_AWIDTH-1)   := (others => '0');
constant ZERO_DATA      : std_logic_vector(0 to C_PLB_DWIDTH-1)   := (others => '0');
constant ZERO_BE        : std_logic_vector(0 to C_PLB_DWIDTH/8-1) := (others => '0');

-- zero read fifo data input
constant RDFIFO_DWIDTH  : integer := C_PLB_DWIDTH;
constant ZERO_RFIFO_DATA: std_logic_vector(0 to RDFIFO_DWIDTH-1) := (others => '0');     

-----------------------------------------------------------------------------
-- Signal declarations
-----------------------------------------------------------------------------
-- IPIC Signals
signal bus2ip_cs            : std_logic_vector(0 to ARD_ADDR_RANGE_ARRAY'LENGTH/2 -1);
signal bus2ip_addr          : std_logic_vector(0 to C_PLB_AWIDTH-1);
signal bus2ip_rnw           : std_logic;
signal bus2ip_data          : std_logic_vector(0 to C_PLB_DWIDTH-1);
signal bus2ip_be            : std_logic_vector(0 to C_PLB_DWIDTH/8-1);
signal bus2ip_burst         : std_logic;
signal bus2ip_iburst        : std_logic;
signal bus2ip_rdreq         : std_logic;
signal bus2ip_wrreq         : std_logic;

signal ip2bus_retry         : std_logic;
signal ip2bus_busy          : std_logic;
signal ip2bus_toutsup       : std_logic;
signal ip2bus_errack        : std_logic;
signal ip2bus_data          : std_logic_vector(0 to C_PLB_DWIDTH-1);
signal ip2bus_rdack         : std_logic;
signal ip2bus_wrack         : std_logic;
signal ip2bus_addrack       : std_logic;
signal ip2bus_wraddrack       : std_logic;
signal ip2bus_rdaddrack       : std_logic;

-----------------------------------------------------------------------------
-- Begin architecture
-----------------------------------------------------------------------------

begin  -- architecture imp


-----------------------------------------------------------------------------
-- Assign output signals
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- WO_ECC Generate
-- Create generate statement based on including ECC logic
-- If C_INCLUDE_ECC_SUPPORT = 0 or C_DDR_DWIDTH = 64, no ECC logic instantiated
-- If C_INCLUDE_ECC_SUPPORT = 1 and C_DDR_DWIDTH=64, ECC logic is instantiated
-- 
-----------------------------------------------------------------------------
WO_ECC: if (C_INCLUDE_ECC_SUPPORT = 0 or C_DDR_DWIDTH = 64) generate

-----------------------------------------------------------------------------
-- Constant declarations
-----------------------------------------------------------------------------
constant ZERO_ECC_BITS      : std_logic_vector(0 to NUM_ECC_BITS*2-1)   := (others => '0');
constant ZERO_DQ_ECC_BITS   : std_logic_vector(0 to NUM_ECC_BITS-1)     := (others => '0');

begin

    IP2Bus_AddrAck <= IP2Bus_WrAddrAck or IP2Bus_RdAddrAck;
    
    -----------------------------------------------------------------------------
    -- Instantiate the DDR Controller
    -----------------------------------------------------------------------------
    DDR_CTRL_I: entity ddr_v1_11_a.ddr_controller(imp) 
    generic map (
        C_FAMILY                =>  C_FAMILY            ,
        C_NUM_BANKS_MEM         =>  C_NUM_BANKS_MEM     ,
        C_NUM_CLK_PAIRS         =>  C_NUM_CLK_PAIRS     ,
        C_REG_DIMM              =>  C_REG_DIMM          ,
        C_DDR_TMRD              =>  C_DDR_TMRD          ,
        C_DDR_TWR               =>  C_DDR_TWR           ,
        C_DDR_TWTR              =>  C_DDR_TWTR          ,
        C_DDR_TRAS              =>  C_DDR_TRAS          ,
        C_DDR_TRC               =>  C_DDR_TRC           ,
        C_DDR_TRFC              =>  C_DDR_TRFC          ,
        C_DDR_TRCD              =>  C_DDR_TRCD          ,
        C_DDR_TRRD              =>  C_DDR_TRRD          ,
        C_DDR_TREFI             =>  C_DDR_TREFI         ,
        C_DDR_TREFC             =>  C_DDR_TREFC         ,
        C_DDR_TRP               =>  C_DDR_TRP           ,
        C_DDR_CAS_LAT           =>  C_DDR_CAS_LAT       ,
        C_DDR_DWIDTH            =>  C_DDR_DWIDTH        ,
        C_DDR_AWIDTH            =>  C_DDR_AWIDTH        ,
        C_DDR_COL_AWIDTH        =>  C_DDR_COL_AWIDTH    ,
        C_DDR_BANK_AWIDTH       =>  C_DDR_BANK_AWIDTH   ,
        C_DDR_BRST_SIZE         =>  DDR_BRST_SIZE       ,
        C_IPIF_DWIDTH           =>  C_PLB_DWIDTH        ,
        C_IPIF_AWIDTH           =>  C_PLB_AWIDTH        ,
        C_INCLUDE_BURSTS        =>  C_INCLUDE_BURST_CACHELN_SUPPORT,
        C_CLK_PERIOD            =>  C_PLB_CLK_PERIOD_PS ,
        C_OPB_BUS               =>  OPB_BUS             ,
        C_PLB_BUS               =>  PLB_BUS             ,
        C_SIM_INIT_TIME_PS      =>  C_SIM_INIT_TIME_PS    ,
        C_INCLUDE_ECC_SUPPORT   =>  C_INCLUDE_ECC_SUPPORT ,
        NUM_ECC_BITS            =>  NUM_ECC_BITS
        )  
    port map (
        Bus2IP_Addr         =>  bus2ip_addr     ,                                            
        Bus2IP_BE           =>  bus2ip_be       ,                                            
        Bus2IP_Data         =>  bus2ip_data     ,                                            
        Bus2IP_RNW          =>  bus2ip_rnw      ,                                            
        Bus2IP_RdReq        =>  bus2ip_rdreq    ,                                            
        Bus2IP_WrReq        =>  bus2ip_wrreq    ,                                            
        Bus2IP_Burst        =>  bus2ip_burst    ,  
        Bus2IP_IBurst       =>  bus2ip_iburst   ,  
        Bus2IP_CS           =>  bus2ip_cs       ,                                            
        IP2Bus_Data         =>  ip2bus_data     , 
        IP2Bus_WrAddrAck    =>  IP2Bus_WrAddrAck  ,
        IP2Bus_RdAddrAck    =>  IP2Bus_RdAddrAck  ,
        IP2Bus_Busy         =>  ip2bus_busy     ,
        IP2Bus_RdAck        =>  ip2bus_rdack    ,                                            
        IP2Bus_WrAck        =>  ip2bus_wrack    ,                                            
        IP2Bus_ErrAck       =>  ip2bus_errack   ,                                            
        IP2Bus_Retry        =>  ip2bus_retry    ,                                            
        IP2Bus_ToutSup      =>  ip2bus_toutsup  ,  
        ECC_chk_bits_wr     =>  ZERO_ECC_BITS   , 
        ECC_chk_bits_rd     =>  open            , 
        DDR_Clk             =>  DDR_Clk         ,                     
        DDR_Clkn            =>  DDR_Clkn        ,                  
        DDR_CKE             =>  DDR_CKE         ,                                            
        DDR_CSn             =>  DDR_CSn         ,                                            
        DDR_RASn            =>  DDR_RASn        ,                                            
        DDR_CASn            =>  DDR_CASn        ,                                            
        DDR_WEn             =>  DDR_WEn         ,                                            
        DDR_DM              =>  DDR_DM          ,                                            
        DDR_BankAddr        =>  DDR_BankAddr    ,                                            
        DDR_Addr            =>  DDR_Addr        ,                                            
        DDR_DQ_o            =>  DDR_DQ_o        ,                                            
        DDR_DQ_i            =>  DDR_DQ_i        ,                                            
        DDR_DQ_t            =>  DDR_DQ_t        ,                                            
        DDR_DQS_i           =>  DDR_DQS_i       ,                                            
        DDR_DQS_o           =>  DDR_DQS_o       ,                                            
        DDR_DQS_t           =>  DDR_DQS_t       ,  
        DDR_DM_ECC          =>  open            ,                                            
        DDR_DQ_ECC_o        =>  open            ,                                    
        DDR_DQ_ECC_i        =>  ZERO_DQ_ECC_BITS ,                                            
        DDR_DQ_ECC_t        =>  open            ,                                            
        DDR_DQS_ECC_i       =>  '0'             ,                                            
        DDR_DQS_ECC_o       =>  open            ,                                            
        DDR_DQS_ECC_t       =>  open            ,   
        DDR_Init_done       =>  DDR_Init_done   ,
        Sys_Clk             =>  PLB_Clk         ,                                            
        Sys_Clk_n           =>  PLB_Clk_n       ,                                            
        Clk90_in            =>  Clk90_in        ,
        Clk90_in_n          =>  Clk90_in_n      ,
        DDR_Clk90_in        =>  DDR_Clk90_in    , 
        DDR_Clk90_in_n      =>  DDR_Clk90_in_n  , 
        Rst                 =>  PLB_Rst                                                        
        );

    -----------------------------------------------------------------------------
    -- Instantiate the PLB-IPIF
    -----------------------------------------------------------------------------
    PLB_IPIF_I: entity plb_ipif_v1_00_f.plb_ipif(implementation) 
    generic map (
        C_ARD_ID_ARRAY          => ARD_ID_ARRAY,
        C_ARD_ADDR_RANGE_ARRAY  => ARD_ADDR_RANGE_ARRAY,
        C_ARD_DWIDTH_ARRAY      => ARD_DWIDTH_ARRAY,                
        C_ARD_NUM_CE_ARRAY      => ARD_NUM_CE_ARRAY,
        C_DEV_BLK_ID            => DEV_BLK_ID,  
        C_DEV_MIR_ENABLE        => DEV_MIR_ENABLE,                      
        C_DEV_BURST_ENABLE      => DEV_BURST_ENABLE,
        C_DEV_FAST_DATA_XFER    => DEV_FAST_DATA_XFER,
        C_DEV_BURST_PAGE_SIZE   => DEV_BURST_PAGE_SIZE,
        C_DEV_MAX_BURST_SIZE    => DEV_MAX_BURST_SIZE,
        C_DEV_DPHASE_TIMEOUT    => DEV_DPHASE_TIMEOUT,
        C_INCLUDE_DEV_ISC       => INCLUDE_DEV_ISC,
        C_INCLUDE_DEV_PENCODER  => INCLUDE_DEV_PENCODER,
        C_IP_INTR_MODE_ARRAY    => IP_INTR_MODE_ARRAY,
        C_IP_MASTER_PRESENT     => IP_MASTER_PRESENT,
        C_PLB_MID_WIDTH         => C_PLB_MID_WIDTH,
        C_PLB_NUM_MASTERS       => C_PLB_NUM_MASTERS,
        C_PLB_AWIDTH            => C_PLB_AWIDTH,  
        C_PLB_DWIDTH            => C_PLB_DWIDTH,  
        C_PLB_CLK_PERIOD_PS     => C_PLB_CLK_PERIOD_PS,  
        C_IPIF_DWIDTH           => C_PLB_DWIDTH,
        C_IPIF_AWIDTH           => C_PLB_AWIDTH,
        C_FAMILY                => C_FAMILY
        )
    port map (  
        -- System signals ---------------------------------------------------------    
        PLB_clk                 => PLB_Clk,                                 
        Reset                   => PLB_Rst,                                
        Freeze                  => '0',                                
        IP2INTC_Irpt            => open,                
        -- Bus Slave signals ------------------------------------------------------       
        PLB_ABus                => PLB_ABus      ,                          
        PLB_PAValid             => PLB_PAValid   ,
        PLB_SAValid             => PLB_SAValid   ,
        PLB_rdPrim              => PLB_rdPrim    ,
        PLB_wrPrim              => PLB_wrPrim    ,
        PLB_masterID            => PLB_masterID  ,                             
        PLB_abort               => PLB_abort     ,
        PLB_busLock             => PLB_busLock   ,
        PLB_RNW                 => PLB_RNW       ,
        PLB_BE                  => PLB_BE        ,                             
        PLB_MSize               => PLB_MSize     ,             
        PLB_size                => PLB_size      ,             
        PLB_type                => PLB_type      ,             
        PLB_compress            => PLB_compress  ,
        PLB_guarded             => PLB_guarded   ,
        PLB_ordered             => PLB_ordered   ,
        PLB_lockErr             => PLB_lockErr   ,
        PLB_wrDBus              => PLB_wrDBus    ,                          
        PLB_wrBurst             => PLB_wrBurst   ,
        PLB_rdBurst             => PLB_rdBurst   ,
        PLB_pendReq             => PLB_pendReq   ,
        PLB_pendPri             => PLB_pendPri   ,
        PLB_reqPri              => PLB_reqPri    ,             
        Sl_addrAck              => Sl_addrAck    ,
        Sl_SSize                => Sl_SSize      ,             
        Sl_wait                 => Sl_wait       ,
        Sl_rearbitrate          => Sl_rearbitrate,
        Sl_wrDAck               => Sl_wrDAck     ,
        Sl_wrComp               => Sl_wrComp     ,
        Sl_wrBTerm              => Sl_wrBTerm    ,
        Sl_rdDBus               => Sl_rdDBus     ,                          
        Sl_rdWdAddr             => Sl_rdWdAddr   ,             
        Sl_rdDAck               => Sl_rdDAck     ,
        Sl_rdComp               => Sl_rdComp     ,
        Sl_rdBTerm              => Sl_rdBTerm    ,
        Sl_MBusy                => Sl_MBusy      ,                               
        Sl_MErr                 => Sl_MErr       ,               
        -- Bus Master Signals -----------------------------------------------------        
        PLB_MAddrAck            => '0',                                
        PLB_MSSize              => "00",                                
        PLB_MRearbitrate        => '0',                                         
        PLB_MBusy               => '0',                                         
        PLB_MErr                => '0',                                         
        PLB_MWrDAck             => '0',                                         
        PLB_MRdDBus             => ZERO_DATA,                                
        PLB_MRdWdAddr           => "0000",
        PLB_MRdDAck             => '0',                                         
        PLB_MRdBTerm            => '0',         
        PLB_MWrBTerm            => '0',         
        M_request               => open,                                
        M_priority              => open,                                
        M_buslock               => open,                                        
        M_RNW                   => open,                                        
        M_BE                    => open,                                                                       
        M_MSize                 => open,                                                       
        M_size                  => open,                                                       
        M_type                  => open,                                                       
        M_compress              => open,                                        
        M_guarded               => open,                                        
        M_ordered               => open,                                        
        M_lockErr               => open,                                        
        M_abort                 => open,                                                                      
        M_ABus                  => open,                                                                    
        M_wrDBus                => open,                                                                    
        M_wrBurst               => open,                                           
        M_rdBurst               => open,                         
        -- IP Interconnect (IPIC) port signals -----------------------------------------        
        --System Signals
        IP2Bus_Clk              => '0',        
        Bus2IP_Clk              => open,        
        Bus2IP_Reset            => open,        
        Bus2IP_Freeze           => open,       
        -- IP Slave signals
        IP2Bus_IntrEvent        => ZERO_INTREVENT,        
        IP2Bus_Data             => ip2bus_data,                                
        IP2Bus_WrAck            => ip2bus_wrack,                                
        IP2Bus_RdAck            => ip2bus_rdack,        
        IP2Bus_Retry            => ip2bus_retry,
        IP2Bus_Error            => ip2bus_errack,
        IP2Bus_ToutSup          => ip2bus_toutsup,        
        IP2Bus_PostedWrInh      => '0',
        IP2Bus_Busy             => ip2bus_busy,
        IP2Bus_AddrAck          => ip2bus_addrack,
        IP2Bus_BTerm            => '0',
        Bus2IP_Addr             => bus2ip_addr,                               
        Bus2IP_Data             => bus2ip_data,                                
        Bus2IP_RNW              => bus2ip_rnw,             
        Bus2IP_BE               => bus2ip_be,        
        Bus2IP_Burst            => bus2ip_burst, 
        Bus2IP_IBurst           => bus2ip_iburst,
        Bus2IP_WrReq            => bus2ip_wrreq,        
        Bus2IP_RdReq            => bus2ip_rdreq, 
        Bus2IP_RNW_Early        => open,
        Bus2IP_PselHit          => open,
        Bus2IP_CS               => bus2ip_cs,        
        Bus2IP_CE               => open,                                                                 
        Bus2IP_RdCE             => open,                                                                 
        Bus2IP_WrCE             => open,                                                          
        -- IP to DMA Support Signals (Length and Status FIFO I/O)
        IP2DMA_RxLength_Empty   => '0',        
        IP2DMA_RxStatus_Empty   => '0',        
        IP2DMA_TxLength_Full    => '0',        
        IP2DMA_TxStatus_Empty   => '0',                                
        -- IP Master Signals
        IP2Bus_Addr             => ZERO_ADDR,        
        IP2Bus_MstBE            => ZERO_BE,        
        IP2IP_Addr              => ZERO_ADDR,        
        IP2Bus_MstWrReq         => '0',
        IP2Bus_MstRdReq         => '0',        
        IP2Bus_MstBurst         => '0',        
        IP2Bus_MstBusLock       => '0',        
        Bus2IP_MstWrAck         => open,        
        Bus2IP_MstRdAck         => open,        
        Bus2IP_MstRetry         => open,        
        Bus2IP_MstError         => open,        
        Bus2IP_MstTimeOut       => open,        
        Bus2IP_MstLastAck       => open,                
        -- RdPFIFO Signals
        IP2RFIFO_WrReq          => '0',        
        IP2RFIFO_Data           => ZERO_RFIFO_DATA,
        IP2RFIFO_WrMark         => '0',        
        IP2RFIFO_WrRelease      => '0',        
        IP2RFIFO_WrRestore      => '0',        
        RFIFO2IP_WrAck          => open,                
        RFIFO2IP_AlmostFull     => open,                
        RFIFO2IP_Full           => open,        
        RFIFO2IP_Vacancy        => open,
        -- WrPFIFO signals
        IP2WFIFO_RdReq          => '0',        
        IP2WFIFO_RdMark         => '0',
        IP2WFIFO_RdRelease      => '0',        
        IP2WFIFO_RdRestore      => '0',
        WFIFO2IP_Data           => open,                                
        WFIFO2IP_RdAck          => open,                
        WFIFO2IP_AlmostEmpty    => open,                
        WFIFO2IP_Empty          => open,                
        WFIFO2IP_Occupancy      => open,                
        -- IP DMA signals
        IP2Bus_DMA_Req          => '0',        
        Bus2IP_DMA_Ack          => open                
        );    

end generate WO_ECC;
    
-----------------------------------------------------------------------------
-- W_ECC Generate
-- If ECC support is desired, instantiate ECC logic
-- If C_INCLUDE_ECC_SUPPORT = 1 and C_DDR_DWIDTH = 32, then instantiate ECC
-- logic between IPIF and DDR controller
-----------------------------------------------------------------------------
W_ECC: if (C_INCLUDE_ECC_SUPPORT = 1 and C_DDR_DWIDTH = 32) generate

-----------------------------------------------------------------------------
-- Constant declarations
-----------------------------------------------------------------------------

-----------------------------------------------------------------------------
-- Signal declarations
-----------------------------------------------------------------------------
signal ECC2IP_Data          : std_logic_vector(0 to C_DDR_DWIDTH*2 - 1 );
signal ECC2IP_Addr          : std_logic_vector(0 to C_PLB_AWIDTH-1);
signal ECC2IP_Chk_Bits      : std_logic_vector(0 to NUM_ECC_BITS*2-1);
signal ECC2IP_WrReq         : std_logic;
signal ECC2IP_RdReq         : std_logic;
signal ECC2IP_CS            : std_logic_vector(0 to C_NUM_BANKS_MEM-1);
signal ECC2IP_CE            : std_logic_vector(0 to calc_num_ce(ARD_NUM_CE_ARRAY)-1);
signal ECC2IP_BE            : std_logic_vector(0 to C_PLB_DWIDTH/8-1);
signal ECC2IP_RNW           : std_logic;
signal ECC2IP_Burst         : std_logic;
signal ECC2IP_IBurst        : std_logic;

signal Bus2IP_CE            : std_logic_vector(0 to calc_num_ce(ARD_NUM_CE_ARRAY)-1);          
signal Bus2IP_RdCE          : std_logic_vector(0 to calc_num_ce(ARD_NUM_CE_ARRAY)-1);          
signal Bus2IP_WrCE          : std_logic_vector(0 to calc_num_ce(ARD_NUM_CE_ARRAY)-1);  

signal IP2ECC_Data          : std_logic_vector(0 to C_DDR_DWIDTH*2 - 1 );
signal IP2ECC_Chk_Bits      : std_logic_vector(0 to NUM_ECC_BITS*2-1);
signal IP2ECC_WrAck         : std_logic;
signal IP2ECC_RdAck         : std_logic;
signal IP2ECC_WrAddrAck     : std_logic;
signal IP2ECC_RdAddrAck     : std_logic;

signal IP2Bus_IntrEvent     : std_logic_vector(0 to IP_INTR_MODE_ARRAY'length - 1 );

begin
     
    -----------------------------------------------------------------------------
    -- Instantiate the ECC Logic
    -----------------------------------------------------------------------------
    ECC_I: entity ecc_v1_00_a.ecc(imp)
    generic map (   
        NUM_ECC_BITS                => NUM_ECC_BITS             ,
        C_ENABLE_ECC_REG            => C_ENABLE_ECC_REG         ,  
        C_ECC_DEFAULT_ON            => C_ECC_DEFAULT_ON         ,
        C_INCLUDE_ECC_INTR          => C_INCLUDE_ECC_INTR       ,
        C_INCLUDE_ECC_TEST          => C_INCLUDE_ECC_TEST       ,
        C_ECC_SEC_THRESHOLD         => C_ECC_SEC_THRESHOLD      ,
        C_ECC_DEC_THRESHOLD         => C_ECC_DEC_THRESHOLD      ,
        C_ECC_PEC_THRESHOLD         => C_ECC_PEC_THRESHOLD      ,
        C_NUM_BANKS_MEM             => C_NUM_BANKS_MEM          ,
        C_MEM_DWIDTH                => 32,--C_DDR_DWIDTH             ,
        C_IPIF_DWIDTH               => C_PLB_DWIDTH             ,
        C_IPIF_AWIDTH               => C_PLB_AWIDTH             ,
        C_ECC_REG                   => ECC_REG                  ,
        C_ARD_ID_ARRAY              => ARD_ID_ARRAY             ,
        C_ARD_ADDR_RANGE_ARRAY      => ARD_ADDR_RANGE_ARRAY     ,
        C_ARD_DWIDTH_ARRAY          => ARD_DWIDTH_ARRAY         ,   
        C_ARD_NUM_CE_ARRAY          => ARD_NUM_CE_ARRAY         ,
        C_IP_INTR_MODE_ARRAY        => IP_INTR_MODE_ARRAY         
        )          
    port map (
        Bus2IP_Data          => Bus2IP_Data         , 
        Bus2IP_Addr          => Bus2IP_Addr         ,                                            
        Bus2IP_RNW           => Bus2IP_RNW          ,                                            
        Bus2IP_WrReq         => Bus2IP_WrReq        , 
        Bus2IP_RdReq         => Bus2IP_RdReq        , 
        Bus2IP_CS            => Bus2IP_CS           , 
        Bus2IP_CE            => Bus2IP_CE           , 
        Bus2IP_BE            => Bus2IP_BE           , 
        Bus2IP_RdCE          => Bus2IP_RdCE         , 
        Bus2IP_WrCE          => Bus2IP_WrCE         ,
        Bus2IP_Burst         => Bus2IP_Burst        ,
        Bus2IP_IBurst        => Bus2IP_IBurst       ,
        IP2Bus_Data          => IP2Bus_Data         ,                                  
        IP2Bus_WrAck         => IP2Bus_WrAck        ,
        IP2Bus_RdAck         => IP2Bus_RdAck        , 
        IP2Bus_AddrAck       => IP2Bus_AddrAck      ,
        IP2Bus_IntrEvent     => IP2Bus_IntrEvent    , 
        ECC2IP_Data          => ECC2IP_Data         ,  
        ECC2IP_Addr          => ECC2IP_Addr         ,
        ECC2IP_Chk_Bits      => ECC2IP_Chk_Bits     ,  
        ECC2IP_WrReq         => ECC2IP_WrReq        ,
        ECC2IP_RdReq         => ECC2IP_RdReq        ,
        ECC2IP_CS            => ECC2IP_CS           ,
        ECC2IP_CE            => ECC2IP_CE           ,
        ECC2IP_BE            => ECC2IP_BE           ,
        ECC2IP_RNW           => ECC2IP_RNW          ,
        ECC2IP_Burst         => ECC2IP_Burst        ,
        ECC2IP_IBurst        => ECC2IP_IBurst       ,
        IP2ECC_WrAck         => IP2ECC_WrAck        ,      
        IP2ECC_RdAck         => IP2ECC_RdAck        , 
        IP2ECC_WrAddrAck     => IP2ECC_WrAddrAck    ,
        IP2ECC_RdAddrAck     => IP2ECC_RdAddrAck    ,
        IP2ECC_Data          => IP2ECC_Data         ,      
        IP2ECC_Chk_Bits      => IP2ECC_Chk_Bits     ,
        Sys_Clk              => PLB_Clk             ,            
        Rst                  => PLB_Rst  
        );  

    -----------------------------------------------------------------------------
    -- Instantiate the DDR Controller
    -----------------------------------------------------------------------------
    DDR_CTRL_I: entity ddr_v1_11_a.ddr_controller(imp) 
    generic map (
        C_FAMILY                =>  C_FAMILY            ,
        C_NUM_BANKS_MEM         =>  C_NUM_BANKS_MEM     ,
        C_NUM_CLK_PAIRS         =>  C_NUM_CLK_PAIRS     ,
        C_REG_DIMM              =>  C_REG_DIMM          ,
        C_DDR_TMRD              =>  C_DDR_TMRD          ,
        C_DDR_TWR               =>  C_DDR_TWR           ,
        C_DDR_TWTR              =>  C_DDR_TWTR          ,
        C_DDR_TRAS              =>  C_DDR_TRAS          ,
        C_DDR_TRC               =>  C_DDR_TRC           ,
        C_DDR_TRFC              =>  C_DDR_TRFC          ,
        C_DDR_TRCD              =>  C_DDR_TRCD          ,
        C_DDR_TRRD              =>  C_DDR_TRRD          ,
        C_DDR_TREFI             =>  C_DDR_TREFI         ,
        C_DDR_TREFC             =>  C_DDR_TREFC         ,
        C_DDR_TRP               =>  C_DDR_TRP           ,
        C_DDR_CAS_LAT           =>  C_DDR_CAS_LAT       ,
        C_DDR_DWIDTH            =>  C_DDR_DWIDTH        ,
        C_DDR_AWIDTH            =>  C_DDR_AWIDTH        ,
        C_DDR_COL_AWIDTH        =>  C_DDR_COL_AWIDTH    ,
        C_DDR_BANK_AWIDTH       =>  C_DDR_BANK_AWIDTH   ,
        C_DDR_BRST_SIZE         =>  DDR_BRST_SIZE       ,
        C_IPIF_DWIDTH           =>  C_PLB_DWIDTH        ,
        C_IPIF_AWIDTH           =>  C_PLB_AWIDTH        ,
        C_INCLUDE_BURSTS        =>  C_INCLUDE_BURST_CACHELN_SUPPORT,
        C_CLK_PERIOD            =>  C_PLB_CLK_PERIOD_PS ,
        C_OPB_BUS               =>  OPB_BUS             ,
        C_PLB_BUS               =>  PLB_BUS             ,
        C_SIM_INIT_TIME_PS      =>  C_SIM_INIT_TIME_PS  ,
        C_INCLUDE_ECC_SUPPORT   =>  C_INCLUDE_ECC_SUPPORT ,
        NUM_ECC_BITS            =>  NUM_ECC_BITS
     )  
    port map (
        Bus2IP_Addr         =>  ECC2IP_Addr         ,                                            
        Bus2IP_BE           =>  ECC2IP_BE           ,                                            
        Bus2IP_Data         =>  ECC2IP_Data         ,                                            
        Bus2IP_RNW          =>  ECC2IP_RNW          ,                                            
        Bus2IP_RdReq        =>  ECC2IP_RdReq        ,                                            
        Bus2IP_WrReq        =>  ECC2IP_WrReq        ,                                            
        Bus2IP_Burst        =>  ECC2IP_Burst        ,  
        Bus2IP_IBurst       =>  ECC2IP_IBurst       ,  
        Bus2IP_CS           =>  ECC2IP_CS           ,                                            
        IP2Bus_Data         =>  IP2ECC_Data         , 
        IP2Bus_WrAddrAck    =>  IP2ECC_WrAddrAck    ,
        IP2Bus_RdAddrAck    =>  IP2ECC_RdAddrAck    ,
        IP2Bus_Busy         =>  IP2Bus_Busy         ,
        IP2Bus_RdAck        =>  IP2ECC_RdAck        ,                                            
        IP2Bus_WrAck        =>  IP2ECC_WrAck        ,                                            
        IP2Bus_ErrAck       =>  ip2bus_errack       ,                                            
        IP2Bus_Retry        =>  ip2bus_retry        ,                                            
        IP2Bus_ToutSup      =>  ip2bus_toutsup      ,  
        ECC_chk_bits_wr     =>  ECC2IP_Chk_Bits     , 
        ECC_chk_bits_rd     =>  IP2ECC_Chk_Bits     ,
        DDR_Clk             =>  DDR_Clk             ,                     
        DDR_Clkn            =>  DDR_Clkn            ,                  
        DDR_CKE             =>  DDR_CKE             ,                                            
        DDR_CSn             =>  DDR_CSn             ,                                            
        DDR_RASn            =>  DDR_RASn            ,                                            
        DDR_CASn            =>  DDR_CASn            ,                                            
        DDR_WEn             =>  DDR_WEn             ,                                            
        DDR_DM              =>  DDR_DM              ,                                            
        DDR_BankAddr        =>  DDR_BankAddr        ,                                            
        DDR_Addr            =>  DDR_Addr            ,                                            
        DDR_DQ_o            =>  DDR_DQ_o            ,                                            
        DDR_DQ_i            =>  DDR_DQ_i            ,                                            
        DDR_DQ_t            =>  DDR_DQ_t            ,                                            
        DDR_DQS_i           =>  DDR_DQS_i           ,                                            
        DDR_DQS_o           =>  DDR_DQS_o           ,                                            
        DDR_DQS_t           =>  DDR_DQS_t           ,  
        DDR_DM_ECC          =>  DDR_DM_ECC          ,                                            
        DDR_DQ_ECC_o        =>  DDR_DQ_ECC_o        ,                                            
        DDR_DQ_ECC_i        =>  DDR_DQ_ECC_i        ,                                            
        DDR_DQ_ECC_t        =>  DDR_DQ_ECC_t        ,                                            
        DDR_DQS_ECC_i       =>  DDR_DQS_ECC_i       ,                                            
        DDR_DQS_ECC_o       =>  DDR_DQS_ECC_o       ,                                            
        DDR_DQS_ECC_t       =>  DDR_DQS_ECC_t       ,  
        DDR_Init_done       =>  DDR_Init_done       ,
        Sys_Clk             =>  PLB_Clk         ,                                            
        Sys_Clk_n           =>  PLB_Clk_n       ,                                            
        Clk90_in            =>  Clk90_in        ,
        Clk90_in_n          =>  Clk90_in_n      ,
        DDR_Clk90_in        =>  DDR_Clk90_in    , 
        DDR_Clk90_in_n      =>  DDR_Clk90_in_n  , 
        Rst                 =>  PLB_Rst                                                        
        );

    -- instantiate the PLB-IPIF
    PLB_IPIF_I: entity plb_ipif_v1_00_f.plb_ipif(implementation) 
    generic map (
        C_ARD_ID_ARRAY          => ARD_ID_ARRAY,
        C_ARD_ADDR_RANGE_ARRAY  => ARD_ADDR_RANGE_ARRAY,
        C_ARD_DWIDTH_ARRAY      => ARD_DWIDTH_ARRAY,                
        C_ARD_NUM_CE_ARRAY      => ARD_NUM_CE_ARRAY,
        C_DEV_BLK_ID            => DEV_BLK_ID,  
        C_DEV_MIR_ENABLE        => DEV_MIR_ENABLE,                      
        C_DEV_BURST_ENABLE      => DEV_BURST_ENABLE,
        C_DEV_FAST_DATA_XFER    => DEV_FAST_DATA_XFER,
        C_DEV_BURST_PAGE_SIZE   => DEV_BURST_PAGE_SIZE,
        C_DEV_MAX_BURST_SIZE    => DEV_MAX_BURST_SIZE,
        C_DEV_DPHASE_TIMEOUT    => DEV_DPHASE_TIMEOUT,
        C_INCLUDE_DEV_ISC       => INCLUDE_DEV_ISC,
        C_INCLUDE_DEV_PENCODER  => INCLUDE_DEV_PENCODER,
        C_IP_INTR_MODE_ARRAY    => IP_INTR_MODE_ARRAY,
        C_IP_MASTER_PRESENT     => IP_MASTER_PRESENT,
        C_PLB_MID_WIDTH         => C_PLB_MID_WIDTH,
        C_PLB_NUM_MASTERS       => C_PLB_NUM_MASTERS,
        C_PLB_AWIDTH            => C_PLB_AWIDTH,  
        C_PLB_DWIDTH            => C_PLB_DWIDTH,  
        C_PLB_CLK_PERIOD_PS     => C_PLB_CLK_PERIOD_PS,  
        C_IPIF_DWIDTH           => C_PLB_DWIDTH,
        C_IPIF_AWIDTH           => C_PLB_AWIDTH,
        C_FAMILY                => C_FAMILY
        )
    port map (  
        -- System signals ---------------------------------------------------------    
        PLB_clk                 => PLB_Clk,                                 
        Reset                   => PLB_Rst,                                
        Freeze                  => '0',                                
        IP2INTC_Irpt            => IP2INTC_Irpt,                
        -- Bus Slave signals ------------------------------------------------------       
        PLB_ABus                => PLB_ABus      ,                          
        PLB_PAValid             => PLB_PAValid   ,
        PLB_SAValid             => PLB_SAValid   ,
        PLB_rdPrim              => PLB_rdPrim    ,
        PLB_wrPrim              => PLB_wrPrim    ,
        PLB_masterID            => PLB_masterID  ,                             
        PLB_abort               => PLB_abort     ,
        PLB_busLock             => PLB_busLock   ,
        PLB_RNW                 => PLB_RNW       ,
        PLB_BE                  => PLB_BE        ,                             
        PLB_MSize               => PLB_MSize     ,             
        PLB_size                => PLB_size      ,             
        PLB_type                => PLB_type      ,             
        PLB_compress            => PLB_compress  ,
        PLB_guarded             => PLB_guarded   ,
        PLB_ordered             => PLB_ordered   ,
        PLB_lockErr             => PLB_lockErr   ,
        PLB_wrDBus              => PLB_wrDBus    ,                          
        PLB_wrBurst             => PLB_wrBurst   ,
        PLB_rdBurst             => PLB_rdBurst   ,
        PLB_pendReq             => PLB_pendReq   ,
        PLB_pendPri             => PLB_pendPri   ,
        PLB_reqPri              => PLB_reqPri    ,             
        Sl_addrAck              => Sl_addrAck    ,
        Sl_SSize                => Sl_SSize      ,             
        Sl_wait                 => Sl_wait       ,
        Sl_rearbitrate          => Sl_rearbitrate,
        Sl_wrDAck               => Sl_wrDAck     ,
        Sl_wrComp               => Sl_wrComp     ,
        Sl_wrBTerm              => Sl_wrBTerm    ,
        Sl_rdDBus               => Sl_rdDBus     ,                          
        Sl_rdWdAddr             => Sl_rdWdAddr   ,             
        Sl_rdDAck               => Sl_rdDAck     ,
        Sl_rdComp               => Sl_rdComp     ,
        Sl_rdBTerm              => Sl_rdBTerm    ,
        Sl_MBusy                => Sl_MBusy      ,                               
        Sl_MErr                 => Sl_MErr       ,               
        -- Bus Master Signals -----------------------------------------------------        
        PLB_MAddrAck            => '0',                                
        PLB_MSSize              => "00",                                
        PLB_MRearbitrate        => '0',                                         
        PLB_MBusy               => '0',                                         
        PLB_MErr                => '0',                                         
        PLB_MWrDAck             => '0',                                         
        PLB_MRdDBus             => ZERO_DATA,                                
        PLB_MRdWdAddr           => "0000",
        PLB_MRdDAck             => '0',                                         
        PLB_MRdBTerm            => '0',         
        PLB_MWrBTerm            => '0',         
        M_request               => open,                                
        M_priority              => open,                                
        M_buslock               => open,                                        
        M_RNW                   => open,                                        
        M_BE                    => open,                                                                       
        M_MSize                 => open,                                                       
        M_size                  => open,                                                       
        M_type                  => open,                                                       
        M_compress              => open,                                        
        M_guarded               => open,                                        
        M_ordered               => open,                                        
        M_lockErr               => open,                                        
        M_abort                 => open,                                                                      
        M_ABus                  => open,                                                                    
        M_wrDBus                => open,                                                                    
        M_wrBurst               => open,                                           
        M_rdBurst               => open,                         
        -- IP Interconnect (IPIC) port signals -----------------------------------------        
        --System Signals
        IP2Bus_Clk              => '0',        
        Bus2IP_Clk              => open,        
        Bus2IP_Reset            => open,        
        Bus2IP_Freeze           => open,       
        -- IP Slave signals
        IP2Bus_IntrEvent        => IP2Bus_IntrEvent,        
        IP2Bus_Data             => ip2bus_data,                                
        IP2Bus_WrAck            => ip2bus_wrack,                                
        IP2Bus_RdAck            => ip2bus_rdack,        
        IP2Bus_Retry            => ip2bus_retry,
        IP2Bus_Error            => ip2bus_errack,
        IP2Bus_ToutSup          => ip2bus_toutsup,        
        IP2Bus_PostedWrInh      => '0',
        IP2Bus_Busy             => ip2bus_busy,
        IP2Bus_AddrAck          => ip2bus_addrack,
        IP2Bus_BTerm            => '0',
        Bus2IP_Addr             => bus2ip_addr,                               
        Bus2IP_Data             => bus2ip_data,                                
        Bus2IP_RNW              => bus2ip_rnw,             
        Bus2IP_BE               => bus2ip_be,        
        Bus2IP_Burst            => bus2ip_burst, 
        Bus2IP_IBurst           => bus2ip_iburst,
        Bus2IP_WrReq            => bus2ip_wrreq,        
        Bus2IP_RdReq            => bus2ip_rdreq, 
        Bus2IP_RNW_Early        => open,
        Bus2IP_PselHit          => open,
        Bus2IP_CS               => bus2ip_cs,        
        Bus2IP_CE               => bus2ip_ce,                                                                 
        Bus2IP_RdCE             => bus2ip_rdce,                                                                 
        Bus2IP_WrCE             => bus2ip_wrce,                                                          
        -- IP to DMA Support Signals (Length and Status FIFO I/O)
        IP2DMA_RxLength_Empty   => '0',        
        IP2DMA_RxStatus_Empty   => '0',        
        IP2DMA_TxLength_Full    => '0',        
        IP2DMA_TxStatus_Empty   => '0',                                
        -- IP Master Signals
        IP2Bus_Addr             => ZERO_ADDR,        
        IP2Bus_MstBE            => ZERO_BE,        
        IP2IP_Addr              => ZERO_ADDR,        
        IP2Bus_MstWrReq         => '0',
        IP2Bus_MstRdReq         => '0',        
        IP2Bus_MstBurst         => '0',        
        IP2Bus_MstBusLock       => '0',        
        Bus2IP_MstWrAck         => open,        
        Bus2IP_MstRdAck         => open,        
        Bus2IP_MstRetry         => open,        
        Bus2IP_MstError         => open,        
        Bus2IP_MstTimeOut       => open,        
        Bus2IP_MstLastAck       => open,                
        -- RdPFIFO Signals
        IP2RFIFO_WrReq          => '0',        
        IP2RFIFO_Data           => ZERO_RFIFO_DATA,
        IP2RFIFO_WrMark         => '0',        
        IP2RFIFO_WrRelease      => '0',        
        IP2RFIFO_WrRestore      => '0',        
        RFIFO2IP_WrAck          => open,                
        RFIFO2IP_AlmostFull     => open,                
        RFIFO2IP_Full           => open,        
        RFIFO2IP_Vacancy        => open,
        -- WrPFIFO signals
        IP2WFIFO_RdReq          => '0',        
        IP2WFIFO_RdMark         => '0',
        IP2WFIFO_RdRelease      => '0',        
        IP2WFIFO_RdRestore      => '0',
        WFIFO2IP_Data           => open,                                
        WFIFO2IP_RdAck          => open,                
        WFIFO2IP_AlmostEmpty    => open,                
        WFIFO2IP_Empty          => open,                
        WFIFO2IP_Occupancy      => open,                
        -- IP DMA signals
        IP2Bus_DMA_Req          => '0',        
        Bus2IP_DMA_Ack          => open                
        ); 
  
end generate W_ECC;        
        
end imp;

