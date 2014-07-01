##############################################################################
## Filename:          D:\temp\6MPGM_6MPS5_6B261_6A119_7M010_DD13\system/drivers/plb34_ps_v1_00_a/data/plb34_ps_v2_1_0.tcl
## Description:       Microprocess Driver Command (tcl)
## Date:              Mon Mar 15 16:04:35 2010 (by Create and Import Peripheral Wizard)
##############################################################################

#uses "xillib.tcl"

proc generate {drv_handle} {
  xdefine_include_file $drv_handle "xparameters.h" "plb34_ps" "NUM_INSTANCES" "DEVICE_ID" "C_BASEADDR" "C_HIGHADDR" 
}
