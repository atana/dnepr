#!/bin/bash

d=`dirname "$0"`
cd $d

source /opt/Xilinx/10.1/ISE/settings32.sh
source /opt/Xilinx/10.1/EDK/settings32.sh
source /opt/Xilinx/10.1/ChipScope/settings32.sh

xtclsh mpgf13_6ma119_7mm008_dd1.tcl run_process
impact -batch gen_mcs.cmd
