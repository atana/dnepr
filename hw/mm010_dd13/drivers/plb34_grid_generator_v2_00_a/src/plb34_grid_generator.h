//////////////////////////////////////////////////////////////////////////////
// Filename:          D:\6MB261\FPO\6A118_7M010_DD13_v5_00\6A118_7M010_DD13_v5_00_ISE\system/drivers/plb34_grid_generator_v2_00_a/src/plb34_grid_generator.h
// Version:           2.00.a
// Description:       plb34_grid_generator Driver Header File
// Date:              Tue Mar 16 16:26:29 2010 (by Create and Import Peripheral Wizard)
//////////////////////////////////////////////////////////////////////////////

#ifndef PLB34_GRID_GENERATOR_H
#define PLB34_GRID_GENERATOR_H

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
 */
#define PLB34_GRID_GENERATOR_USER_SLAVE_SPACE_OFFSET (0x00000000)
#define PLB34_GRID_GENERATOR_SLAVE_REG0_OFFSET (PLB34_GRID_GENERATOR_USER_SLAVE_SPACE_OFFSET + 0x00000000)
#define PLB34_GRID_GENERATOR_SLAVE_REG1_OFFSET (PLB34_GRID_GENERATOR_USER_SLAVE_SPACE_OFFSET + 0x00000004)
#define PLB34_GRID_GENERATOR_SLAVE_REG2_OFFSET (PLB34_GRID_GENERATOR_USER_SLAVE_SPACE_OFFSET + 0x00000008)

/**************************** Type Definitions *****************************/


/***************** Macros (Inline Functions) Definitions *******************/

/**
 *
 * Write a value to a PLB34_GRID_GENERATOR register. A 32 bit write is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is written.
 *
 * @param   BaseAddress is the base address of the PLB34_GRID_GENERATOR device.
 * @param   RegOffset is the register offset from the base to write to.
 * @param   Data is the data written to the register.
 *
 * @return  None.
 *
 * @note
 * C-style signature:
 * 	void PLB34_GRID_GENERATOR_mWriteReg(Xuint32 BaseAddress, unsigned RegOffset, Xuint32 Data)
 *
 */
#define PLB34_GRID_GENERATOR_mWriteReg(BaseAddress, RegOffset, Data) \
 	XIo_Out32((BaseAddress) + (RegOffset), (Xuint32)(Data))

/**
 *
 * Read a value from a PLB34_GRID_GENERATOR register. A 32 bit read is performed.
 * If the component is implemented in a smaller width, only the least
 * significant data is read from the register. The most significant data
 * will be read as 0.
 *
 * @param   BaseAddress is the base address of the PLB34_GRID_GENERATOR device.
 * @param   RegOffset is the register offset from the base to write to.
 *
 * @return  Data is the data from the register.
 *
 * @note
 * C-style signature:
 * 	Xuint32 PLB34_GRID_GENERATOR_mReadReg(Xuint32 BaseAddress, unsigned RegOffset)
 *
 */
#define PLB34_GRID_GENERATOR_mReadReg(BaseAddress, RegOffset) \
 	XIo_In32((BaseAddress) + (RegOffset))


/**
 *
 * Write/Read value to/from PLB34_GRID_GENERATOR user logic slave registers.
 *
 * @param   BaseAddress is the base address of the PLB34_GRID_GENERATOR device.
 * @param   Value is the data written to the register.
 *
 * @return  Data is the data from the user logic slave register.
 *
 * @note
 * C-style signature:
 * 	Xuint32 PLB34_GRID_GENERATOR_mReadSlaveRegn(Xuint32 BaseAddress)
 *
 */
#define PLB34_GRID_GENERATOR_mWriteSlaveReg0(BaseAddress, Value) \
 	XIo_Out32((BaseAddress) + (PLB34_GRID_GENERATOR_SLAVE_REG0_OFFSET), (Xuint32)(Value))
#define PLB34_GRID_GENERATOR_mWriteSlaveReg1(BaseAddress, Value) \
 	XIo_Out32((BaseAddress) + (PLB34_GRID_GENERATOR_SLAVE_REG1_OFFSET), (Xuint32)(Value))
#define PLB34_GRID_GENERATOR_mWriteSlaveReg2(BaseAddress, Value) \
 	XIo_Out32((BaseAddress) + (PLB34_GRID_GENERATOR_SLAVE_REG2_OFFSET), (Xuint32)(Value))

#define PLB34_GRID_GENERATOR_mReadSlaveReg0(BaseAddress) \
 	XIo_In32((BaseAddress) + (PLB34_GRID_GENERATOR_SLAVE_REG0_OFFSET))
#define PLB34_GRID_GENERATOR_mReadSlaveReg1(BaseAddress) \
 	XIo_In32((BaseAddress) + (PLB34_GRID_GENERATOR_SLAVE_REG1_OFFSET))
#define PLB34_GRID_GENERATOR_mReadSlaveReg2(BaseAddress) \
 	XIo_In32((BaseAddress) + (PLB34_GRID_GENERATOR_SLAVE_REG2_OFFSET))

/************************** Function Prototypes ****************************/


/**
 *
 * Run a self-test on the driver/device. Note this may be a destructive test if
 * resets of the device are performed.
 *
 * If the hardware system is not built correctly, this function may never
 * return to the caller.
 *
 * @param   baseaddr_p is the base address of the PLB34_GRID_GENERATOR instance to be worked on.
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
XStatus PLB34_GRID_GENERATOR_SelfTest(void * baseaddr_p);

#endif // PLB34_GRID_GENERATOR_H
