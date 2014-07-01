-------------------------------------------------------------------------------
-- opb_flash_wrapper.vhd
-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

library UNISIM;
use UNISIM.VCOMPONENTS.ALL;

library opb_flash_controller_v1_00_a;
use opb_flash_controller_v1_00_a.all;

entity opb_flash_wrapper is
  port (
    OPB_Clk : in std_logic;
    OPB_Rst : in std_logic;
    Sl_DBus : out std_logic_vector(0 to 31);
    Sl_errAck : out std_logic;
    Sl_retry : out std_logic;
    Sl_toutSup : out std_logic;
    Sl_xferAck : out std_logic;
    OPB_ABus : in std_logic_vector(0 to 31);
    OPB_DBus : in std_logic_vector(0 to 31);
    OPB_RNW : in std_logic;
    OPB_select : in std_logic;
    OPB_seqAddr : in std_logic;
    Flash_A : out std_logic_vector(0 to 31);
    Flash_CEN : out std_logic_vector(0 to 3);
    Flash_OEN : out std_logic;
    Flash_WEN : out std_logic;
    Flash_Rst : out std_logic;
    periph_reset : in std_logic;
    Flash_DQ_I : in std_logic_vector(0 to 15);
    Flash_DQ_O : out std_logic_vector(0 to 15);
    Flash_DQ_T : out std_logic
  );

  attribute x_core_info : STRING;
  attribute x_core_info of opb_flash_wrapper : entity is "opb_flash_controller_v1_00_a";

end opb_flash_wrapper;

architecture STRUCTURE of opb_flash_wrapper is

  component opb_flash_controller is
    generic (
      OPB_FC_BASEADDR : std_logic_vector;
      OPB_FC_HIGHADDR : std_logic_vector;
      FL0_BASEADDR : std_logic_vector;
      FL0_HIGHADDR : std_logic_vector;
      FL1_BASEADDR : std_logic_vector;
      FL1_HIGHADDR : std_logic_vector;
      FL2_BASEADDR : std_logic_vector;
      FL2_HIGHADDR : std_logic_vector;
      FL3_BASEADDR : std_logic_vector;
      FL3_HIGHADDR : std_logic_vector;
      C_OPB_AWIDTH : INTEGER;
      C_OPB_DWIDTH : INTEGER;
      C_FAMILY : STRING
    );
    port (
      OPB_Clk : in std_logic;
      OPB_Rst : in std_logic;
      Sl_DBus : out std_logic_vector(0 to (C_OPB_DWIDTH-1));
      Sl_errAck : out std_logic;
      Sl_retry : out std_logic;
      Sl_toutSup : out std_logic;
      Sl_xferAck : out std_logic;
      OPB_ABus : in std_logic_vector(0 to (C_OPB_AWIDTH-1));
      OPB_DBus : in std_logic_vector(0 to (C_OPB_DWIDTH-1));
      OPB_RNW : in std_logic;
      OPB_select : in std_logic;
      OPB_seqAddr : in std_logic;
      Flash_A : out std_logic_vector(0 to 31);
      Flash_CEN : out std_logic_vector(0 to 3);
      Flash_OEN : out std_logic;
      Flash_WEN : out std_logic;
      Flash_Rst : out std_logic;
      periph_reset : in std_logic;
      Flash_DQ_I : in std_logic_vector(0 to 15);
      Flash_DQ_O : out std_logic_vector(0 to 15);
      Flash_DQ_T : out std_logic
    );
  end component;

begin

  opb_flash : opb_flash_controller
    generic map (
      OPB_FC_BASEADDR => X"ffffffff",
      OPB_FC_HIGHADDR => X"00000000",
      FL0_BASEADDR => X"CC000000",
      FL0_HIGHADDR => X"CFFFFFFF",
      FL1_BASEADDR => X"D0000000",
      FL1_HIGHADDR => X"D3FFFFFF",
      FL2_BASEADDR => X"D4000000",
      FL2_HIGHADDR => X"D7FFFFFF",
      FL3_BASEADDR => X"D8000000",
      FL3_HIGHADDR => X"DBFFFFFF",
      C_OPB_AWIDTH => 32,
      C_OPB_DWIDTH => 32,
      C_FAMILY => "virtex2p"
    )
    port map (
      OPB_Clk => OPB_Clk,
      OPB_Rst => OPB_Rst,
      Sl_DBus => Sl_DBus,
      Sl_errAck => Sl_errAck,
      Sl_retry => Sl_retry,
      Sl_toutSup => Sl_toutSup,
      Sl_xferAck => Sl_xferAck,
      OPB_ABus => OPB_ABus,
      OPB_DBus => OPB_DBus,
      OPB_RNW => OPB_RNW,
      OPB_select => OPB_select,
      OPB_seqAddr => OPB_seqAddr,
      Flash_A => Flash_A,
      Flash_CEN => Flash_CEN,
      Flash_OEN => Flash_OEN,
      Flash_WEN => Flash_WEN,
      Flash_Rst => Flash_Rst,
      periph_reset => periph_reset,
      Flash_DQ_I => Flash_DQ_I,
      Flash_DQ_O => Flash_DQ_O,
      Flash_DQ_T => Flash_DQ_T
    );

end architecture STRUCTURE;

