//////////////////////////////////////////////////////////////////////////////
// Filename:          C:\Xilinx\10.1\edk_user_repository\MyProcessorIPLib/drivers/plb34_freq_test_v1_00_a/src/plb34_freq_test_selftest.c
// Version:           1.00.a
// Description:       Contains a diagnostic self-test function for the plb34_freq_test driver
// Date:              Sat Mar 06 13:02:13 2010 (by Create and Import Peripheral Wizard)
//////////////////////////////////////////////////////////////////////////////


/***************************** Include Files *******************************/

#include "plb34_freq_test.h"

/************************** Constant Definitions ***************************/


/************************** Variable Definitions ****************************/


/************************** Function Definitions ***************************/

/**
 *
 * Run a self-test on the driver/device. Note this may be a destructive test if
 * resets of the device are performed.
 *
 * If the hardware system is not built correctly, this function may never
 * return to the caller.
 *
 * @param   baseaddr_p is the base address of the PLB34_FREQ_TEST instance to be worked on.
 *
 * @return
 *
 *    - XST_SUCCESS   if all self-test code passed
 *    - XST_FAILURE   if any self-test code failed
 *
 * @note    Caching must be turned off for this function to work.
 * @note    Self test may fail if data memory and device are not on the same bus.
 *
 */
XStatus PLB34_FREQ_TEST_SelfTest(void * baseaddr_p)
{
   int     Index;
   Xuint32 baseaddr;
   Xuint8  Reg8Value;
   Xuint16 Reg16Value;
   Xuint32 Reg32Value;
   Xuint64 Reg64Value;

   /*
    * Assert the argument
    */
   XASSERT_NONVOID(baseaddr_p != XNULL);
   baseaddr = (Xuint32) baseaddr_p;

   xil_printf("******************************\n\r");
   xil_printf("* User Peripheral Self Test\n\r");
   xil_printf("******************************\n\n\r");

   /*
    * Write to user logic slave module register(s) and read back
    */
   xil_printf("User logic slave module test...\n\r");
   xil_printf("   - write 1 to slave register 0\n\r");
   PLB34_FREQ_TEST_mWriteSlaveReg0(baseaddr, 1);
   Reg32Value = PLB34_FREQ_TEST_mReadSlaveReg0(baseaddr);
   xil_printf("   - read %d from register 0\n\r", Reg32Value);
   if ( Reg32Value != (Xuint32) 1 )
   {
      xil_printf("   - slave register 0 write/read failed\n\r");
      return XST_FAILURE;
   }
   xil_printf("   - write 2 to slave register 1\n\r");
   PLB34_FREQ_TEST_mWriteSlaveReg1(baseaddr, 2);
   Reg32Value = PLB34_FREQ_TEST_mReadSlaveReg1(baseaddr);
   xil_printf("   - read %d from register 1\n\r", Reg32Value);
   if ( Reg32Value != (Xuint32) 2 )
   {
      xil_printf("   - slave register 1 write/read failed\n\r");
      return XST_FAILURE;
   }
   xil_printf("   - write 3 to slave register 2\n\r");
   PLB34_FREQ_TEST_mWriteSlaveReg2(baseaddr, 3);
   Reg32Value = PLB34_FREQ_TEST_mReadSlaveReg2(baseaddr);
   xil_printf("   - read %d from register 2\n\r", Reg32Value);
   if ( Reg32Value != (Xuint32) 3 )
   {
      xil_printf("   - slave register 2 write/read failed\n\r");
      return XST_FAILURE;
   }
   xil_printf("   - write 4 to slave register 3\n\r");
   PLB34_FREQ_TEST_mWriteSlaveReg3(baseaddr, 4);
   Reg32Value = PLB34_FREQ_TEST_mReadSlaveReg3(baseaddr);
   xil_printf("   - read %d from register 3\n\r", Reg32Value);
   if ( Reg32Value != (Xuint32) 4 )
   {
      xil_printf("   - slave register 3 write/read failed\n\r");
      return XST_FAILURE;
   }
   xil_printf("   - write 5 to slave register 4\n\r");
   PLB34_FREQ_TEST_mWriteSlaveReg4(baseaddr, 5);
   Reg32Value = PLB34_FREQ_TEST_mReadSlaveReg4(baseaddr);
   xil_printf("   - read %d from register 4\n\r", Reg32Value);
   if ( Reg32Value != (Xuint32) 5 )
   {
      xil_printf("   - slave register 4 write/read failed\n\r");
      return XST_FAILURE;
   }
   xil_printf("   - slave register write/read passed\n\n\r");

   return XST_SUCCESS;
}
