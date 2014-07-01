//////////////////////////////////////////////////////////////////////////////
// Filename:          C:\Xilinx\10.1\edk_user_repository\MyProcessorIPLib/drivers/plb34_freq_test_v1_00_a/src/plb34_freq_test.h
// Version:           1.00.a
// Description:       plb34_freq_test Driver Header File
// Date:              Sat Mar 06 13:02:13 2010 (by Create and Import Peripheral Wizard)
//////////////////////////////////////////////////////////////////////////////

#ifndef PLB34_FREQ_TEST_H
#define PLB34_FREQ_TEST_H

/***************************** Include Files *******************************/

#include "xbasic_types.h"
#include "xstatus.h"
#include "xio.h"

/************************** Constant Definitions ***************************/


/**
 * User Logic Slave Space Offsets
 * -- SLAVE_REG0 : user logic slave module register 0
 * -- SLAVE_REG1 : user logic slave module register 1
 * -- SLAVE_REG2 : user logic slave module register 2
 * -- SLAVE_REG3 : user logic slave module register 3
 * -- SLAVE_REG4 : user logic slave module register 4
 */
#define PLB34_FREQ_TEST_USER_SLAVE_SPACE_OFFSET (0x00000000)
#define PLB34_FREQ_TEST_SLAVE_REG0_OFFSET (PLB34_FREQ_TEST_USER_SLAVE_SPACE_OFFSET + 0x00000000)
#define PLB34_FREQ_TEST_SLAVE_REG1_OFFSET (PLB34_FREQ_TEST_USER_SLAVE_SPACE_OFFSET + 0x00000004)
#define PLB34_FREQ_TEST_SLAVE_REG2_OFFSET (PLB34_FREQ_TEST_USER_SLAVE_SPACE_OFFSET + 0x00000008)
#define PLB34_FREQ_TEST_SLAVE_REG3_OFFSET (PLB34_FREQ_TEST_USER_SLAVE_SPACE_OFFSET + 0x0000000C)
#define PLB34_FREQ_TEST_SLAVE_REG4_OFFSET (PLB34_FREQ_TEST_USER_SLAVE_SPACE_OFFSET + 0x00000010)

/**************************** Type Definitions *****************************/


/***************** Macros (Inline Functions) Definitions *******************/

/**
 *
 * Write a value to a PLB34_FREQ_TEST register. A 32 bit write is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is written.
 *
 * @param   BaseAddress is the base address of the PLB34_FREQ_TEST device.
 * @param   RegOffset is the register offset from the base to write to.
 * @param   Data is the data written to the register.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 * 	void PLB34_FREQ_TEST_mWriteReg(Xuint32 BaseAddress, unsigned RegOffset, Xuint32 Data)
 *
 */
#define PLB34_FREQ_TEST_mWriteReg(BaseAddress, RegOffset, Data) \
 	XIo_Out32((BaseAddress) + (RegOffset), (Xuint32)(Data))

/**
 *
 * Read a value from a PLB34_FREQ_TEST register. A 32 bit read is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is read from the register. The most significant data
 * will be read as 0.
 *
 * @param   BaseAddress is the base address of the PLB34_FREQ_TEST device.
 * @param   RegOffset is the register offset from the base to write to.
 *
 * @return  Data is the data from the register.
 *
 * @note
 * C-style signature:
 * 	Xuint32 PLB34_FREQ_TEST_mReadReg(Xuint32 BaseAddress, unsigned RegOffset)
 *
 */
#define PLB34_FREQ_TEST_mReadReg(BaseAddress, RegOffset) \
 	XIo_In32((BaseAddress) + (RegOffset))


/**
 *
 * Write/Read value to/from PLB34_FREQ_TEST user logic slave registers.
 *
 * @param   BaseAddress is the base address of the PLB34_FREQ_TEST device.
 * @param   Value is the data written to the register.
 *
 * @return  Data is the data from the user logic slave register.
 *
 * @note
 * C-style signature:
 * 	Xuint32 PLB34_FREQ_TEST_mReadSlaveRegn(Xuint32 BaseAddress)
 *
 */
#define PLB34_FREQ_TEST_mWriteSlaveReg0(BaseAddress, Value) \
 	XIo_Out32((BaseAddress) + (PLB34_FREQ_TEST_SLAVE_REG0_OFFSET), (Xuint32)(Value))
#define PLB34_FREQ_TEST_mWriteSlaveReg1(BaseAddress, Value) \
 	XIo_Out32((BaseAddress) + (PLB34_FREQ_TEST_SLAVE_REG1_OFFSET), (Xuint32)(Value))
#define PLB34_FREQ_TEST_mWriteSlaveReg2(BaseAddress, Value) \
 	XIo_Out32((BaseAddress) + (PLB34_FREQ_TEST_SLAVE_REG2_OFFSET), (Xuint32)(Value))
#define PLB34_FREQ_TEST_mWriteSlaveReg3(BaseAddress, Value) \
 	XIo_Out32((BaseAddress) + (PLB34_FREQ_TEST_SLAVE_REG3_OFFSET), (Xuint32)(Value))
#define PLB34_FREQ_TEST_mWriteSlaveReg4(BaseAddress, Value) \
 	XIo_Out32((BaseAddress) + (PLB34_FREQ_TEST_SLAVE_REG4_OFFSET), (Xuint32)(Value))

#define PLB34_FREQ_TEST_mReadSlaveReg0(BaseAddress) \
 	XIo_In32((BaseAddress) + (PLB34_FREQ_TEST_SLAVE_REG0_OFFSET))
#define PLB34_FREQ_TEST_mReadSlaveReg1(BaseAddress) \
 	XIo_In32((BaseAddress) + (PLB34_FREQ_TEST_SLAVE_REG1_OFFSET))
#define PLB34_FREQ_TEST_mReadSlaveReg2(BaseAddress) \
 	XIo_In32((BaseAddress) + (PLB34_FREQ_TEST_SLAVE_REG2_OFFSET))
#define PLB34_FREQ_TEST_mReadSlaveReg3(BaseAddress) \
 	XIo_In32((BaseAddress) + (PLB34_FREQ_TEST_SLAVE_REG3_OFFSET))
#define PLB34_FREQ_TEST_mReadSlaveReg4(BaseAddress) \
 	XIo_In32((BaseAddress) + (PLB34_FREQ_TEST_SLAVE_REG4_OFFSET))

/************************** Function Prototypes ****************************/


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
XStatus PLB34_FREQ_TEST_SelfTest(void * baseaddr_p);

#endif // PLB34_FREQ_TEST_H
