----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:27:42 10/21/2009 
-- Design Name: 
-- Module Name:    Z_null - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Z_null is
    Port (
--				Z_null_out : out  STD_LOGIC_VECTOR(0 to 32)
				Z_null_out : out  STD_LOGIC
			);
end Z_null;

architecture Behavioral of Z_null is

begin

--	Z_null		<= b"000000000000000000000000000000000";

Z_null_out		<= '0';

end Behavioral;

