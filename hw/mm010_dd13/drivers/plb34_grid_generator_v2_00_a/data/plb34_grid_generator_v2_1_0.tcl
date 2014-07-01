##############################################################################
## Filename:          D:\6MB261\FPO\6A118_7M010_DD13_v5_00\6A118_7M010_DD13_v5_00_ISE\system/drivers/plb34_grid_generator_v2_00_a/data/plb34_grid_generator_v2_1_0.tcl
## Description:       Microprocess Driver Command (tcl)
## Date:              Tue Mar 16 16:26:29 2010 (by Create and Import Peripheral Wizard)
##############################################################################

#uses "xillib.tcl"

proc generate {drv_handle} {
  xdefine_include_file $drv_handle "xparameters.h" "plb34_grid_generator" "NUM_INSTANCES" "DEVICE_ID" "C_BASEADDR" "C_HIGHADDR" 
}
