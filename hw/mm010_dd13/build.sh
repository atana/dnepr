#!/bin/bash

d=`dirname "$0"`
cd $d

source /opt/Xilinx/10.1/ISE/settings32.sh
source /opt/Xilinx/10.1/EDK/settings32.sh
source /opt/Xilinx/10.1/ChipScope/settings32.sh

make -f system.make bits
impact -batch gen_mcs.cmd
make -f system.make clean
