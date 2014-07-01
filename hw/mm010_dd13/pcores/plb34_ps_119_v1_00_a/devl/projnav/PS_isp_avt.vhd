----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:40:56 03/24/2010 
-- Design Name: 
-- Module Name:    PS_isp_avt - Behavioral 
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

entity PS_isp_avt is
    Port ( 
				rst_sys				: in std_logic;
				clk_sys				: in std_logic;
				clk_d					: in std_logic;
				takt_number			: in STD_LOGIC_VECTOR(15 downto 0);
				discr_number		: in STD_LOGIC_VECTOR(15 downto 0);
				
				Ntakt_reg			: in  STD_LOGIC_VECTOR (31 downto 0);
				Nach_isp_d_reg		: in  STD_LOGIC_VECTOR (31 downto 0);
				Dlit_isp_d_reg		: in  STD_LOGIC_VECTOR (31 downto 0);

				Control_reg			: in  STD_LOGIC_VECTOR (31 downto 0);
				Status_reg			: out STD_LOGIC_VECTOR (31 downto 0);
				
				test_sig				: out STD_LOGIC;								-- тестовый сигнал
				count_isp			: out STD_LOGIC_VECTOR (31 downto 0);	-- счЄтчик исполненных импульсов
				count_fall_preload : out STD_LOGIC_VECTOR(31 downto 0);	-- счЄтчик заданий, отброшеных при загрузке 
				count_fall_wait	: out STD_LOGIC_VECTOR(31 downto 0);	-- счЄтчик заданий, отброшеных при ожидании
				PS_isp				: out STD_LOGIC
			);
end PS_isp_avt;

architecture Behavioral of PS_isp_avt is

	component SM_wait_imp is
		Port ( 
				rst_sys							: in STD_LOGIC;							-- системный и программный сброс
				clk_sys							: in STD_LOGIC;							-- 40 ћ√ц 	от grid_generator
				clk_d								: in STD_LOGIC;							-- 1,25 ћ√ц от grid_generator
				takt_number						: in STD_LOGIC_VECTOR(15 downto 0); -- текущий номер такта от grid_generator
				discr_number					: in STD_LOGIC_VECTOR(15 downto 0); -- текущий номер дискрета от grid_generator
				
				Ntakt_FIFO						: in STD_LOGIC_VECTOR(15 downto 0); -- номер такта импульса из Ntakt_FIFO
				Ndiscr_FIFO						: in STD_LOGIC_VECTOR(15 downto 0);	-- номер дискрета импульса из Ndiscr_FIFO
				Dlit_FIFO						: in STD_LOGIC_VECTOR(15 downto 0);	-- длительность импульса из Dlit_FIFO
			
				FIFO_not_empty					: in STD_LOGIC;							-- FIFO Ntakt и Ndiscr_FIFO и Dlit_FIFO не пустые
				Load_Parameters				: out STD_LOGIC;							-- сигнал чтени€ FIFO
				Parameters_valid				: in STD_LOGIC;							-- валидность параметров на Ntakt_FIFO, Ndiscr_FIFO, Dlit_FIFO

				test_sig							: out STD_LOGIC;							-- тестовый сигнал
				num_state						: out STD_LOGIC_VECTOR(3 downto 0);	 -- номер состо€ни€ автомата			
				count_isp						: out STD_LOGIC_VECTOR(31 downto 0); -- счЄтчик исполненных импульсов 
				count_fall_wait				: out STD_LOGIC_VECTOR(31 downto 0); -- счЄтчик заданий, отброшеных при ожидании
				PS_isp 							: out STD_LOGIC							-- импульс
			);	
	end component;

	component FIFO_secure_uc is	
		Generic(
				FIFO_DEPTH: integer := 48; -- максимальное кол-во слов, max 512x32bit = 16Kbit
				FIFO_STYLE: string := "BLOCK" -- "BLOCK" или "DISTRIBUTED"
				);
		Port ( 
				CLK 			: in  STD_LOGIC;
				RST 			: in  STD_LOGIC;

				FIFO_ENABLE : in STD_LOGIC;

				DIN 			: in  STD_LOGIC_VECTOR (47 downto 0):=(others => '0');
				WE 			: in  STD_LOGIC;
				wr_ack 		: out  STD_LOGIC;

				DOUT 			: out  STD_LOGIC_VECTOR (47 downto 0);
				RE 			: in  STD_LOGIC;
				valid 		: out  STD_LOGIC;
				FIFO_USE 	: out STD_LOGIC_VECTOR (6 downto 0);
				FULL 			: out  STD_LOGIC;
				EMPTY 		: out  STD_LOGIC
				);
	end component;

	signal Ntakt_Ndistr_Dlit			: std_logic_vector(47 downto 0);
	signal FIFO_DOUT						: std_logic_vector(47 downto 0);
	signal FIFO_DIN						: std_logic_vector(47 downto 0);
	signal FIFO_WE							: std_logic;
	signal FIFO_FULL						: std_logic;
	signal FIFO_FULL_80					: std_logic;
	signal FIFO_empty						: std_logic;
	signal FIFO_USE						: std_logic_vector(6 downto 0);
	signal not_FIFO_empty				: std_logic;
	signal Parameters_normal_preload : std_logic;
	signal Load_Parameters				: std_logic;
	signal Parameters_valid				: std_logic;
	signal PROG_RST						: std_logic;
	signal ALL_RST 						: std_logic;
	signal num_state						: std_logic_vector(3 downto 0);
	
	----- test signals:
	signal icount_fall_preload					: std_logic_vector(31 downto 0);
	signal Parameters_fall_preload			: std_logic;
	signal Parameters_fall_preload_once		: std_logic;

begin

	Status_reg_proc: process(ALL_RST, clk_sys)
	begin
		if (ALL_RST = '1') then
		elsif (clk_sys'event and clk_sys = '1') then
			Status_reg(0)					<= FIFO_FULL_80;
			Status_reg(1)					<= FIFO_empty;
			Status_reg(3 downto 2)		<= (others => '0');
			Status_reg(7 downto 4)		<= num_state(3 downto 0);
			Status_reg(14 downto 8)		<= FIFO_USE(6 downto 0);
			Status_reg(15 downto 15)	<= (others => '0');			
			Status_reg(16)					<= FIFO_FULL;
			Status_reg(31 downto 17)	<= (others => '0');
		end if;
	end process;		
-----

	not_FIFO_empty <= not FIFO_empty;

	FIFO_FULL_80_proc: process(ALL_RST, clk_sys)
	begin
		if (ALL_RST = '1') then
			FIFO_FULL_80 <= '0';
		elsif (clk_sys'event and clk_sys = '1') then
			if (FIFO_USE >= b"1010000") then
				FIFO_FULL_80 <= '1';
			else
				FIFO_FULL_80 <= '0';
			end if;			
		end if;
	end process;

	SM_wait_imp_inst: SM_wait_imp
		port map(
					rst_sys				=> ALL_RST,
					clk_sys				=> clk_sys,
					clk_d					=> clk_d,
					takt_number			=> takt_number,
					discr_number		=> discr_number,
					
					Ntakt_FIFO			=> FIFO_DOUT(47 downto 32),
					Ndiscr_FIFO			=> FIFO_DOUT(31 downto 16),
					Dlit_FIFO			=> FIFO_DOUT(15 downto 0),
											 
					FIFO_not_empty		=> not_FIFO_empty,
					Load_Parameters	=> Load_Parameters,
					Parameters_valid  => Parameters_valid,
					num_state			=> num_state,
					
					test_sig				=> test_sig,
					count_isp			=> count_isp,
					count_fall_wait	=> count_fall_wait,
					PS_isp				=> PS_isp
					);
------------------------------------------------------------------------------------------------------------------------------------------	
	FIFO_DIN 						<= Ntakt_reg(15 downto 0) & Nach_isp_d_reg(15 downto 0) & Dlit_isp_d_reg(15 downto 0);
	FIFO_WE 							<= Control_reg(0) and Parameters_normal_preload;
	Parameters_fall_preload 	<= Control_reg(0) and (not Parameters_normal_preload);
	PROG_RST							<= Control_reg(4);
	ALL_RST 							<= PROG_RST or rst_sys;
------------------------------------------------------------------------------------------------------------------------------------------

	FIFO_uc_inst: FIFO_secure_uc
		generic map  
						(
							FIFO_DEPTH	=> 96,	--48
							FIFO_STYLE	=> "BLOCK"
						)
		port map(
					CLK 			=> clk_sys,
					RST 			=> ALL_RST,
                        
					FIFO_ENABLE => '1',
                        
					DIN 			=> FIFO_DIN,
					WE 			=> FIFO_WE,
					wr_ack 		=> open,
                        
					DOUT 			=> FIFO_DOUT,
					RE 			=> Load_Parameters,
					valid 		=> Parameters_valid,
					FIFO_USE 	=> FIFO_USE,
					FULL 			=> FIFO_FULL,
					EMPTY 		=> FIFO_empty
				);

	Parameters_normal_preload_DECODE: process (rst_sys, clk_sys)
	begin
		if (rst_sys = '1') then
			Parameters_normal_preload	<= '0';
		elsif (clk_sys'event and clk_sys = '1') then
			if (Ntakt_reg(15 downto 0) >= takt_number) then
				Parameters_normal_preload	<= '1';			--	Ntakt(импульс) >= takt_number(текущий) - это правльно.
			else
				Parameters_normal_preload	<= '0';			--	Ntakt(импульс) < takt_number(текущий) <=> поздно ждать или не проводитьс€ (не проводилась) загрузка расписаний
			end if;
		end if;
	end process;
	
	icount_fall_preload_proc: process (rst_sys, clk_sys)
	begin
		if (rst_sys = '1') then
			icount_fall_preload					<= (others => '0');
			Parameters_fall_preload_once 	<= '0';
		elsif (clk_sys'event and clk_sys = '1') then
			if (Parameters_fall_preload = '1') then
				if (Parameters_fall_preload_once = '0') then
					icount_fall_preload	<= icount_fall_preload + '1';
					Parameters_fall_preload_once <= '1';
				else
					icount_fall_preload	<= icount_fall_preload;
					Parameters_fall_preload_once <= Parameters_fall_preload_once;
				end if;
			else
				Parameters_fall_preload_once <= '0';
			end if;
		end if;
	end process;

	count_fall_preload	<= icount_fall_preload;

end Behavioral;

