##############################################################################
## Filename:          C:\Xilinx\10.1\edk_user_repository\MyProcessorIPLib/drivers/plb34_freq_test_v1_00_a/data/plb34_freq_test_v2_1_0.tcl
## Description:       Microprocess Driver Command (tcl)
## Date:              Sat Mar 06 13:02:13 2010 (by Create and Import Peripheral Wizard)
##############################################################################

#uses "xillib.tcl"

proc generate {drv_handle} {
  xdefine_include_file $drv_handle "xparameters.h" "plb34_freq_test" "NUM_INSTANCES" "DEVICE_ID" "C_BASEADDR" "C_HIGHADDR" 
}
