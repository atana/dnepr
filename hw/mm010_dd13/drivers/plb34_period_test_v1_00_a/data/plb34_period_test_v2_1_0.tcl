##############################################################################
## Filename:          C:\Xilinx\10.1\edk_user_repository\MyProcessorIPLib/drivers/plb34_period_test_v1_00_a/data/plb34_period_test_v2_1_0.tcl
## Description:       Microprocess Driver Command (tcl)
## Date:              Thu Mar 11 09:40:32 2010 (by Create and Import Peripheral Wizard)
##############################################################################

#uses "xillib.tcl"

proc generate {drv_handle} {
  xdefine_include_file $drv_handle "xparameters.h" "plb34_period_test" "NUM_INSTANCES" "DEVICE_ID" "C_BASEADDR" "C_HIGHADDR" 
}
