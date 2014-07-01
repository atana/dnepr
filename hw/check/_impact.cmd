setMode -bs
setMode -bs
setCable -port auto
Identify 
identifyMPM 
assignFile -p 1 -file "/home/atana/RTI/dnepr/check/ise/top.bit"
Program -p 1 -e -v 
setMode -bs
deleteDevice -position 2
deleteDevice -position 1
