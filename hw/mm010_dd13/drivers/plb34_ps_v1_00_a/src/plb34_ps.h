//////////////////////////////////////////////////////////////////////////////
// Filename:          D:\temp\6MPGM_6MPS5_6B261_6A119_7M010_DD13\system/drivers/plb34_ps_v1_00_a/src/plb34_ps.h
// Version:           1.00.a
// Description:       plb34_ps Driver Header File
// Date:              Mon Mar 15 16:04:35 2010 (by Create and Import Peripheral Wizard)
//////////////////////////////////////////////////////////////////////////////

#ifndef PLB34_PS_H
#define PLB34_PS_H

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
 * -- SLAVE_REG5 : user logic slave module register 5
 * -- SLAVE_REG6 : user logic slave module register 6
 * -- SLAVE_REG7 : user logic slave module register 7
 */
#define PLB34_PS_USER_SLAVE_SPACE_OFFSET (0x00000000)
#define PLB34_PS_SLAVE_REG0_OFFSET (PLB34_PS_USER_SLAVE_SPACE_OFFSET + 0x00000000)
#define PLB34_PS_SLAVE_REG1_OFFSET (PLB34_PS_USER_SLAVE_SPACE_OFFSET + 0x00000004)
#define PLB34_PS_SLAVE_REG2_OFFSET (PLB34_PS_USER_SLAVE_SPACE_OFFSET + 0x00000008)
#define PLB34_PS_SLAVE_REG3_OFFSET (PLB34_PS_USER_SLAVE_SPACE_OFFSET + 0x0000000C)
#define PLB34_PS_SLAVE_REG4_OFFSET (PLB34_PS_USER_SLAVE_SPACE_OFFSET + 0x00000010)
#define PLB34_PS_SLAVE_REG5_OFFSET (PLB34_PS_USER_SLAVE_SPACE_OFFSET + 0x00000014)
#define PLB34_PS_SLAVE_REG6_OFFSET (PLB34_PS_USER_SLAVE_SPACE_OFFSET + 0x00000018)
#define PLB34_PS_SLAVE_REG7_OFFSET (PLB34_PS_USER_SLAVE_SPACE_OFFSET + 0x0000001C)

/**************************** Type Definitions *****************************/


/***************** Macros (Inline Functions) Definitions *******************/

/**
 *
 * Write a value to a PLB34_PS register. A 32 bit write is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is written.
 *
 * @param   BaseAddress is the base address of the PLB34_PS device.
 * @param   RegOffset is the register offset from the base to write to.
 * @param   Data is the data written to the register.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 * 	void PLB34_PS_mWriteReg(Xuint32 BaseAddress, unsigned RegOffset, Xuint32 Data)
 *
 */
#define PLB34_PS_mWriteReg(BaseAddress, RegOffset, Data) \
 	XIo_Out32((BaseAddress) + (RegOffset), (Xuint32)(Data))

/**
 *
 * Read a value from a PLB34_PS register. A 32 bit read is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is read from the register. The most significant data
 * will be read as 0.
 *
 * @param   BaseAddress is the base address of the PLB34_PS device.
 * @param   RegOffset is the register offset from the base to write to.
 *
 * @return  Data is the data from the register.
 *
 * @note
 * C-style signature:
 * 	Xuint32 PLB34_PS_mReadReg(Xuint32 BaseAddress, unsigned RegOffset)
 *
 */
#define PLB34_PS_mReadReg(BaseAddress, RegOffset) \
 	XIo_In32((BaseAddress) + (RegOffset))


/**
 *
 * Write/Read value to/from PLB34_PS user logic slave registers.
 *
 * @param   BaseAddress is the base address of the PLB34_PS device.
 * @param   Value is the data written to the register.
 *
 * @return  Data is the data from the user logic slave register.
 *
 * @note
 * C-style signature:
 * 	Xuint32 PLB34_PS_mReadSlaveRegn(Xuint32 BaseAddress)
 *
 */
#define PLB34_PS_mWriteSlaveReg0(BaseAddress, Value) \
 	XIo_Out32((BaseAddress) + (PLB34_PS_SLAVE_REG0_OFFSET), (Xuint32)(Value))
#define PLB34_PS_mWriteSlaveReg1(BaseAddress, Value) \
 	XIo_Out32((BaseAddress) + (PLB34_PS_SLAVE_REG1_OFFSET), (Xuint32)(Value))
#define PLB34_PS_mWriteSlaveReg2(BaseAddress, Value) \
 	XIo_Out32((BaseAddress) + (PLB34_PS_SLAVE_REG2_OFFSET), (Xuint32)(Value))
#define PLB34_PS_mWriteSlaveReg3(BaseAddress, Value) \
 	XIo_Out32((BaseAddress) + (PLB34_PS_SLAVE_REG3_OFFSET), (Xuint32)(Value))
#define PLB34_PS_mWriteSlaveReg4(BaseAddress, Value) \
 	XIo_Out32((BaseAddress) + (PLB34_PS_SLAVE_REG4_OFFSET), (Xuint32)(Value))
#define PLB34_PS_mWriteSlaveReg5(BaseAddress, Value) \
 	XIo_Out32((BaseAddress) + (PLB34_PS_SLAVE_REG5_OFFSET), (Xuint32)(Value))
#define PLB34_PS_mWriteSlaveReg6(BaseAddress, Value) \
 	XIo_Out32((BaseAddress) + (PLB34_PS_SLAVE_REG6_OFFSET), (Xuint32)(Value))
#define PLB34_PS_mWriteSlaveReg7(BaseAddress, Value) \
 	XIo_Out32((BaseAddress) + (PLB34_PS_SLAVE_REG7_OFFSET), (Xuint32)(Value))

#define PLB34_PS_mReadSlaveReg0(BaseAddress) \
 	XIo_In32((BaseAddress) + (PLB34_PS_SLAVE_REG0_OFFSET))
#define PLB34_PS_mReadSlaveReg1(BaseAddress) \
 	XIo_In32((BaseAddress) + (PLB34_PS_SLAVE_REG1_OFFSET))
#define PLB34_PS_mReadSlaveReg2(BaseAddress) \
 	XIo_In32((BaseAddress) + (PLB34_PS_SLAVE_REG2_OFFSET))
#define PLB34_PS_mReadSlaveReg3(BaseAddress) \
 	XIo_In32((BaseAddress) + (PLB34_PS_SLAVE_REG3_OFFSET))
#define PLB34_PS_mReadSlaveReg4(BaseAddress) \
 	XIo_In32((BaseAddress) + (PLB34_PS_SLAVE_REG4_OFFSET))
#define PLB34_PS_mReadSlaveReg5(BaseAddress) \
 	XIo_In32((BaseAddress) + (PLB34_PS_SLAVE_REG5_OFFSET))
#define PLB34_PS_mReadSlaveReg6(BaseAddress) \
 	XIo_In32((BaseAddress) + (PLB34_PS_SLAVE_REG6_OFFSET))
#define PLB34_PS_mReadSlaveReg7(BaseAddress) \
 	XIo_In32((BaseAddress) + (PLB34_PS_SLAVE_REG7_OFFSET))

/************************** Function Prototypes ****************************/


/**
 *
 * Run a self-test on the driver/device. Note this may be a destructive test if
 * resets of the device are performed.
 *
 * If the hardware system is not built correctly, this function may never
 * return to the caller.
 *
 * @param   baseaddr_p is the base address of the PLB34_PS instance to be worked on.
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
XStatus PLB34_PS_SelfTest(void * baseaddr_p);

#endif // PLB34_PS_H
