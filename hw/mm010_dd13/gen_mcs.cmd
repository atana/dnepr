setMode -pff
setSubmode -pffserial
addPromDevice -p 1 -name xcf32p
addDesign -version 0 -name 0
addDeviceChain -index 0
addDevice -p 1 -file "implementation/system.bit"
generate -format mcs -fillvalue FF -output "../../release/mpgf13_6ma119_7mm010_dd13.mcs"
quit
