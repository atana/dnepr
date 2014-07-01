###############################################################################
##
## Copyright (c) 2005 Xilinx, Inc. All Rights Reserved.
##
## plb_ddr_v2_1_0.tcl
##
###############################################################################


## @BEGIN_CHANGELOG EDK_I
##
## - added IOBDELAY=NONE constraints to ports DDR_DQ and DDR_DQS
## - removed FROM:TO constraints 
## - clean up old datastructure APIs
##
## @END_CHANGELOG


## @BEGIN_CHANGELOG EDK_Gm_SP2
##
## remove the check for parameter C_DDR_DWIDTH,  this check has been done in MPD
##
## @END_CHANGELOG

#***--------------------------------***------------------------------------***
#
#			     SYSLEVEL_DRC_PROC
#
#***--------------------------------***------------------------------------***

#
# 1. check C_DDR_AWIDTH + C_DDR_COL_AWIDTH + C_DDR_BANK_AWIDTH + log2(C_DDR_DWIDTH/8)
#    must be < C_PLB_AWIDTH - 1
#
proc check_syslevel_settings {mhsinst} {

    # check the sum of ddr awidth
    set mhs_handle [xget_hw_parent_handle $mhsinst]

    xload_hw_library ddr_v1_11_a
    hw_ddr_v1_11_a::check_awidth     "C_PLB_AWIDTH" $mhsinst

}

#***--------------------------------***-----------------------------------***
#
#			     IPLEVEL_DRC_PROC
#
#***--------------------------------***-----------------------------------***

#
# if C_DDR_DWIDTH = 64 then C_INCLUDE_ECC_SUPPORT must be 0
#
proc check_iplevel_settings {mhsinst} {

    set mhs_handle [xget_hw_parent_handle $mhsinst]

    xload_hw_library ddr_v1_11_a
    hw_ddr_v1_11_a::check_include_ecc_support  $mhsinst

}

#***--------------------------------***-----------------------------------***
#
#			     CORE_LEVEL_CONSTRAINTS
#
#***--------------------------------***-----------------------------------***


proc generate_corelevel_ucf {mhsinst} {

    xload_hw_library ddr_v1_11_a
    hw_ddr_v1_11_a::timing_constraints_ucf $mhsinst 

}
