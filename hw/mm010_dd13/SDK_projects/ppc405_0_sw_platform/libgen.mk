################################################################# 
# Makefile generated by Xilinx Platform Studio SDK 
#                                                          
# WARNING : This file will be re-generated every time a command 
# to run a make target is invoked. So, any changes made to this 
# file manually, will be lost when make is invoked next. 
#################################################################

MHSFILE = /home/atana/RTI/dnepr/hw/mm010_dd13_dts/system.mhs
MSSFILE = /home/atana/RTI/dnepr/hw/mm010_dd13_dts/SDK_projects/ppc405_0_sw_platform/system.mss
SW_PLATFORM_DIR = /home/atana/RTI/dnepr/hw/mm010_dd13_dts/SDK_projects/ppc405_0_sw_platform
LOGFILE = /home/atana/RTI/dnepr/hw/mm010_dd13_dts/SDK_projects/ppc405_0_sw_platform/libgen.log
LIBRARIES = /home/atana/RTI/dnepr/hw/mm010_dd13_dts/SDK_projects/ppc405_0_sw_platform/ppc405_0/lib/libxil.a
DEVICE = xc2vp50ff1152-6
SEARCHPATHOPT = 

libs: $(LIBRARIES)

$(LIBRARIES): $(MHSFILE) $(MSSFILE)
	libgen -mhs /home/atana/RTI/dnepr/hw/mm010_dd13_dts/system.mhs -xmpdir /home/atana/RTI/dnepr/hw/mm010_dd13_dts \
	-p $(DEVICE) $(SEARCHPATHOPT) -pe ppc405_0 -od $(SW_PLATFORM_DIR) \
	-log ${LOGFILE} /home/atana/RTI/dnepr/hw/mm010_dd13_dts/SDK_projects/ppc405_0_sw_platform/system.mss

