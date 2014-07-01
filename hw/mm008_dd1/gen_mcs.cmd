setMode -pff
setSubmode -pffserial
addPromDevice -p 1 -name xcf08p
addDesign -version 0 -name 0
addDeviceChain -index 0
addDevice -p 1 -file "fu2_119.bit"
generate -format mcs -fillvalue FF -output "../../release/mpgf13_6ma119_7mm008_dd1.mcs"
quit 
