setMode -pff
setMode -pff
addConfigDevice  -name "dd13" -path "/home/atana/RTI/dnepr/hw/mm010_dd13_dts/"
setSubmode -pffserial
addDesign -version 0 -name "00"
setMode -pff
addDeviceChain -index 0
setMode -pff
addDeviceChain -index 0
setAttribute -configdevice -attr compressed -value "FALSE"
setAttribute -configdevice -attr compressed -value "FALSE"
setAttribute -configdevice -attr autoSize -value "FALSE"
setAttribute -configdevice -attr fileFormat -value "mcs"
setAttribute -configdevice -attr fillValue -value "FF"
setAttribute -configdevice -attr swapBit -value "FALSE"
setAttribute -configdevice -attr dir -value "UP"
setAttribute -configdevice -attr multiboot -value "FALSE"
setAttribute -configdevice -attr multiboot -value "FALSE"
setAttribute -configdevice -attr spiSelected -value "FALSE"
setAttribute -configdevice -attr spiSelected -value "FALSE"
addPromDevice -p 1 -size 0 -name xcf32p
setMode -pff
setMode -pff
deletePromDevice -position 1
setCurrentDesign -version 0
deleteDesign -version 0
setCurrentDesign -version -1
setMode -pff
addConfigDevice -size 512 -name "dd13" -path "/home/atana/RTI/dnepr/hw/mm010_dd13_dts/"
setSubmode -pffserial
setAttribute -configdevice -attr dir -value "UP"
setAttribute -configdevice -attr flashDataWidth -value "8"
addPromDevice -p 1 -size 0 -name xcf32p
setMode -pff
setSubmode -pffserial
setAttribute -configdevice -attr dir -value "UP"
addDesign -version 0 -name "0000"
setMode -pff
addDeviceChain -index 0
setAttribute -design -attr name -value "0"
addDevice -p 1 -file "/home/atana/RTI/dnepr/hw/mm010_dd13_dts/implementation/system.bit"
setMode -pff
setSubmode -pffserial
setAttribute -configdevice -attr fillValue -value "FF"
setAttribute -configdevice -attr fileFormat -value "mcs"
setAttribute -configdevice -attr dir -value "UP"
setAttribute -configdevice -attr path -value "/home/atana/RTI/dnepr/hw/mm010_dd13_dts"
setAttribute -configdevice -attr name -value "dd13"
generate
setCurrentDesign -version 0
setMode -bs
setMode -bs
setCable -port auto
Identify 
identifyMPM 
assignFile -p 2 -file "/home/atana/RTI/dnepr/hw/mm010_dd13_dts/dd13.mcs"
setAttribute -position 2 -attr readnextdevice -value "(null)"
Program -p 2 -e -v -defaultVersion 0 
