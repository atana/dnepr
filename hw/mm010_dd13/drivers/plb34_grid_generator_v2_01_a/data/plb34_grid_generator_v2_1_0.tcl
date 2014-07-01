##############################################################################
## Filename:          D:\TEST\HW_SW_test\sym_plb34_grid_generator/drivers/plb34_grid_generator_v2_01_a/data/plb34_grid_generator_v2_1_0.tcl
## Description:       Microprocess Driver Command (tcl)
## Date:              Mon Mar 29 18:03:56 2010 (by Create and Import Peripheral Wizard)
##############################################################################

#uses "xillib.tcl"

proc generate {drv_handle} {
  xdefine_include_file $drv_handle "xparameters.h" "plb34_grid_generator" "NUM_INSTANCES" "DEVICE_ID" "C_BASEADDR" "C_HIGHADDR" 
}
