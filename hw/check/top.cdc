#ChipScope Core Inserter Project File Version 3.0
#Tue Jul 01 18:26:15 MSD 2014
Project.device.designInputFile=/home/atana/RTI/dnepr/check/ise/top_cs.ngc
Project.device.designOutputFile=/home/atana/RTI/dnepr/check/ise/top_cs.ngc
Project.device.deviceFamily=15
Project.device.enableRPMs=true
Project.device.outputDirectory=/home/atana/RTI/dnepr/check/ise/_ngo
Project.device.useSRL16=true
Project.filter.dimension=9
Project.filter<0>=*state*
Project.filter<1>=
Project.filter<2>=*err_*
Project.filter<3>=*err*
Project.filter<4>=*vor*
Project.filter<5>=*rc_*
Project.filter<6>=*tr_*
Project.filter<7>=*dnepr*
Project.filter<8>=*clk*
Project.icon.boundaryScanChain=1
Project.icon.disableBUFGInsertion=false
Project.icon.enableExtTriggerIn=false
Project.icon.enableExtTriggerOut=false
Project.icon.triggerInPinName=
Project.icon.triggerOutPinName=
Project.unit.dimension=1
Project.unit<0>.clockChannel=clk_BUFGP
Project.unit<0>.clockEdge=Rising
Project.unit<0>.dataChannel<0>=dnepr_tr_start_IBUF
Project.unit<0>.dataChannel<10>=err_overlay
Project.unit<0>.dataChannel<11>=err_OBUF
Project.unit<0>.dataChannel<12>=state_FSM_FFd1
Project.unit<0>.dataChannel<13>=state_FSM_FFd2
Project.unit<0>.dataChannel<14>=state_FSM_FFd3
Project.unit<0>.dataChannel<1>=dnepr_tr_stop_IBUF
Project.unit<0>.dataChannel<2>=dnepr_rc_start_IBUF
Project.unit<0>.dataChannel<3>=dnepr_rc_stop_IBUF
Project.unit<0>.dataChannel<4>=tr_start
Project.unit<0>.dataChannel<5>=tr_stop
Project.unit<0>.dataChannel<6>=rc_start
Project.unit<0>.dataChannel<7>=rc_stop
Project.unit<0>.dataChannel<8>=voronej_fu1_IBUF
Project.unit<0>.dataChannel<9>=voronej_fu2_IBUF
Project.unit<0>.dataDepth=16384
Project.unit<0>.dataEqualsTrigger=true
Project.unit<0>.dataPortWidth=15
Project.unit<0>.enableGaps=false
Project.unit<0>.enableStorageQualification=true
Project.unit<0>.enableTimestamps=false
Project.unit<0>.timestampDepth=0
Project.unit<0>.timestampWidth=0
Project.unit<0>.triggerChannel<0><0>=dnepr_tr_start_IBUF
Project.unit<0>.triggerChannel<0><10>=err_overlay
Project.unit<0>.triggerChannel<0><11>=err_OBUF
Project.unit<0>.triggerChannel<0><12>=state_FSM_FFd1
Project.unit<0>.triggerChannel<0><13>=state_FSM_FFd2
Project.unit<0>.triggerChannel<0><14>=state_FSM_FFd3
Project.unit<0>.triggerChannel<0><1>=dnepr_tr_stop_IBUF
Project.unit<0>.triggerChannel<0><2>=dnepr_rc_start_IBUF
Project.unit<0>.triggerChannel<0><3>=dnepr_rc_stop_IBUF
Project.unit<0>.triggerChannel<0><4>=tr_start
Project.unit<0>.triggerChannel<0><5>=tr_stop
Project.unit<0>.triggerChannel<0><6>=rc_start
Project.unit<0>.triggerChannel<0><7>=rc_stop
Project.unit<0>.triggerChannel<0><8>=voronej_fu1_IBUF
Project.unit<0>.triggerChannel<0><9>=voronej_fu2_IBUF
Project.unit<0>.triggerConditionCountWidth=0
Project.unit<0>.triggerMatchCount<0>=1
Project.unit<0>.triggerMatchCountWidth<0><0>=0
Project.unit<0>.triggerMatchType<0><0>=0
Project.unit<0>.triggerPortCount=1
Project.unit<0>.triggerPortIsData<0>=true
Project.unit<0>.triggerPortWidth<0>=15
Project.unit<0>.triggerSequencerLevels=16
Project.unit<0>.triggerSequencerType=1
Project.unit<0>.type=ilapro
