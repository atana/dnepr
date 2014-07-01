TABLE OF CONTENTS
  1) Peripheral Summary
  2) Description of Generated Files
  3) Description of Used IPIC Signals
  4) Description of Top Level Generics


================================================================================
*                             1) Peripheral Summary                            *
================================================================================
Peripheral Summary:

  XPS project / EDK repository               : C:\Xilinx\10.1\edk_user_repository\MyProcessorIPLib
  logical library name                       : plb34_reg_version_v1_00_a
  top name                                   : plb34_reg_version
  version                                    : 1.00.a
  type                                       : PLB slave
  features                                   : slave attachment
                                               user s/w registers

Address Block for User Logic and IPIF Predefined Services

  User logic slave space service             : C_BASEADDR + 0x00000000
                                             : C_BASEADDR + 0x000000FF


================================================================================
*                          2) Description of Generated Files                   *
================================================================================
- HDL source file(s)
  C:\Xilinx\10.1\edk_user_repository\MyProcessorIPLib/pcores/plb34_reg_version_v1_00_a/hdl

  vhdl/plb34_reg_version.vhd

    This is the template file for your peripheral's top design entity. It
    configures and instantiates the corresponding IPIF unit in the way you
    indicated in the wizard GUI and hooks it up to the stub user logic where
    the actual functionalites should get implemented. You are not expected to
    modify this template file except certain marked places for adding user
    specific generics and ports.

  vhdl/user_logic.vhd

    This is the template file for the stub user logic design entity, either in
    VHDL or Verilog, where the actual functionalities should get implemented.
    Some sample code snippet may be provided for demonstration purpose.


- XPS interface file(s)
  C:\Xilinx\10.1\edk_user_repository\MyProcessorIPLib/pcores/plb34_reg_version_v1_00_a/data

  plb34_reg_version_v2_1_0.mpd

    This Microprocessor Peripheral Description file contains information of the
    interface of your peripheral, so that other EDK tools can recognize your
    peripheral.

  plb34_reg_version_v2_1_0.pao

    This Peripheral Analysis Order file defines the analysis order of all the HDL
    source files that are used to compile your peripheral.


- ISE project file(s)
  C:\Xilinx\10.1\edk_user_repository\MyProcessorIPLib/pcores/plb34_reg_version_v1_00_a/devl/projnav

  plb34_reg_version.ise

    This is the ProjNavigator project file. It sets up the needed logical
    libraries and dependent library files for you to help you develop your
    peripheral using ProjNavigator.

  plb34_reg_version.cli

    This is the TCL command line file used to generate the .ise file.


- XST synthesis file(s)
  C:\Xilinx\10.1\edk_user_repository\MyProcessorIPLib/pcores/plb34_reg_version_v1_00_a/devl/synthesis

  plb34_reg_version_xst.scr

    This is the XST synthesis script file to compile your peripheral.
    Note: you may want to modify the device part option for your target.

  plb34_reg_version_xst.prj

    This is the XST synthesis project file used by the above script file to
    compile your peripheral.


- Driver source file(s)
  C:\Xilinx\10.1\edk_user_repository\MyProcessorIPLib/drivers/plb34_reg_version_v1_00_a/src

  plb34_reg_version.h

    This is the software driver header template file, which contains address offset of
    software addressable registers in your peripheral, as well as some common masks and
    simple register access macros or function declaration.

  plb34_reg_version.c

    This is the software driver source template file, to define all applicable driver
    functions.

  plb34_reg_version_selftest.c

    This is the software driver self test example file, which contain self test example
    code to test various hardware features of your peripheral.

  Makefile

    This is the software driver makefile to compile drivers.


- Driver interface file(s)
  C:\Xilinx\10.1\edk_user_repository\MyProcessorIPLib/drivers/plb34_reg_version_v1_00_a/data

  plb34_reg_version_v2_1_0.mdd

    This is the Microprocessor Driver Definition file.

  plb34_reg_version_v2_1_0.tcl

    This is the Microprocessor Driver Command file.


- Other misc file(s)
  C:\Xilinx\10.1\edk_user_repository\MyProcessorIPLib/pcores/plb34_reg_version_v1_00_a/devl

  ipwiz.opt

    This is the option setting file for the wizard batch mode, which should
    generate the same result as the wizard GUI mode.

  README.txt

    This README file for your peripheral.

  ipwiz.log

    This is the log file by operating on this wizard.


================================================================================
*                         3) Description of Used IPIC Signals                  *
================================================================================
For more information (usage, timing diagrams, etc.) regarding the IPIC signals
used in the templates, please refer to the following specifications (under
%XILINX_EDK%\doc for windows or $XILINX_EDK/doc for solaris and linux):
proc_ip_ref_guide.pdf - Processor IP Reference Guide (chapter 4 IPIF)
user_core_templates_ref_guide.pdf - User Core Templates Reference Guide

Bus2IP_Clk
    Synchronization clock provided to the user logic. All IPIC signals are 
    synchronous to this clock. It is identical to the input <bus>_Clk signal of 
    the peripheral. No additional buffering is provided on the clock; it is 
    passed through as is. 

Bus2IP_Reset
    Active high reset for used by the user logic; it is asserted whenever the 
    <bus>_Rst signal asserts or whenever there is a software-programmed reset 
    (if the soft reset block is included). 

Bus2IP_Data
    Write data bus to the user logic. Write data is accepted by the user logic 
    during a write operation by assertion of the write acknowledgement signal 
    and the rising edge of the Bus2IP_Clk. 

Bus2IP_BE
    Byte Enable qualifiers for the requested read or write operation to the user 
    logic. A bit in the Bus2IP_BE set to '1' indicates that the associated byte 
    lane contains valid data. For example, if Bus2IP_BE = 0011, this indicates 
    that byte lanes 2 and 3 contains valid data. 

Bus2IP_RdCE
    Active high chip enable bus to the user logic. These chip enables are 
    asserted only during active read transaction requests with the target 
    address space and in conjunction with the corresponding sub-address within 
    the space. Typically used for user logic readable registers selection. 

Bus2IP_WrCE
    Active high chip enable bus to the user logic. These chip enables are 
    asserted only during active write transaction requests with the target 
    address space and in conjunction with the corresponding sub-address within 
    the space. Typically used for user logic writable registers selection. 

Bus2IP_RdReq
    Active high signal indicating the initiation of a read operation with the 
    user logic. It is asserted for one Bus2IP_Clk during single data beat 
    transactions and remains high to completion on burst read operations. 

Bus2IP_WrReq
    Active high signal indicating the initiation of a write operation with the 
    user logic. It is asserted for one Bus2IP_Clk during single data beat 
    transactions and remains high to completion on burst write operations. 

IP2Bus_Data
    Output read data bus from the user logic; data is qualified with the 
    assertion of IP2Bus_RdAck signal and the rising edge of the Bus2IP_Clk. 

IP2Bus_Retry
    IP2Bus_Retry is a response from the user logic to the IPIF that indicates 
    the currently requested transaction cannot be completed at this time and 
    that the requesting master should retry the operation. If the IP2Bus_Retry 
    signal will be delayed more than 8 clocks, then the IP2Bus_ToutSup (timeout 
    suppress) signal must also be asserted to prevent a timeout on the host bus. 
    Note: this signal is unused by PLB IPIF. 

IP2Bus_Error
    Active high signal indicating the user logic has encountered an error with 
    the requested operation. It is asserted in conjunction with the read/write 
    acknowledgement signal(s). 

IP2Bus_ToutSup
    The IP2Bus_ToutSup must be asserted by the user logic whenever its 
    acknowledgement or retry response will take longer than 8 clock cycles. 

IP2Bus_Busy
    IP2Bus_Busy indicating the user logic is busy and cannot respond to any new 
    requests. This signal causes the IPIF to reply with a rearbitrate to any new 
    PLB requests that are received from the PLB and meet address decoding 
    criteria. 

IP2Bus_RdAck
    Active high read data qualifier providing the read acknowledgement from the 
    user logic. Read data on the IP2Bus_Data bus is deemed valid at the rising 
    edge of the Bus2IP_Clk and IP2Bus_RdAck asserted high by the user logic. For 
    immediate acknowledgement (such as for a register read), this signal can be 
    tied to '1'. Wait states can be inserted in the transaction by delaying the 
    assertion of the acknowledgement. 

IP2Bus_WrAck
    Active high write data qualifier providing the write acknowledgement from 
    the user logic. Write data on the Bus2IP_Data bus is deemed accepted by the 
    user logic at the rising edge of the Bus2IP_Clk and IP2Bus_WrAck asserted 
    high by the user logic. For immediate acknowledgement (such as for a 
    register write), this signal can be tied to '1'. Wait states can be inserted 
    in the transaction by delaying the assertion of the acknowledgement. 

================================================================================
*                     4) Description of Top Level Generics                     *
================================================================================
C_BASEADDR/C_HIGHADDR
    These two generics are used to define the memory mapped address space for
    the peripheral registers, including Reset/MIR register, Interrupt Source
    Controller registers, Read/Write FIFO control/data registers, user logic
    software accessible registers and etc., but excluding those user logic
    address ranges if ever used. When instantiation, the address space size
    determined by these two generics must be a power of 2 (e.g. 2^k =
    C_HIGHADDR - C_BASEADDR + 1), a factor of C_BASEADDR and larger than the
    minimum size as indicated in the template.

C_PLB_DWIDTH
    This is the data bus width for Processor Local Bus (PLB). It should
    always be set to 64 as of today.

C_PLB_AWIDTH
    This is the address bus width for Processor Local Bus (PLB). It should
    always be set to 32 as of today.

C_FAMILY
    This is to set the target FPGA architecture, s.t. virtex2, virtex2p, etc.

