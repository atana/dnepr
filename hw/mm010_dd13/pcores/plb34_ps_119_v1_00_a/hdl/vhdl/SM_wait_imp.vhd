----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    07:55:58 03/24/2010 
-- Design Name: 
-- Module Name:    SM_wait_imp - Behavioral 
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

entity SM_wait_imp is
    Port ( 
				rst_sys							: in STD_LOGIC;							-- 
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
end SM_wait_imp;

architecture Behavioral of SM_wait_imp is
	
	type state_type is (		st0_RST									,	--	состо€ние "системный сброс"
	                        st1_wait_FIFO_not_empty				,	-- ожидание "не пустоты" FIFO
									st2_Load_Parameters					,	-- загрузка параметрой из FIFO в вектора Ntakt, Ndiscr, Dlit
									st4_wait_Imp							,	-- ожидание такта и дискрета начала импульса
																					-- и проверка "нормальности" параметров импульса (Ntakt >= takt_number ?)
	                        st5_wait_Dlit							,	-- ожидание прохождени€ длительности импульса
									st6_fall_wait								-- обработка отбрасывани€ задани€, при пропуске номера такта импульса
							); 
	signal state, next_state : state_type;
	signal next_num_state	: std_logic_vector(3 downto 0);
	
	signal Ntakt				: STD_LOGIC_VECTOR(15 downto 0);
	signal Ndiscr				: STD_LOGIC_VECTOR(15 downto 0);
	signal Dlit					: STD_LOGIC_VECTOR(15 downto 0);
	signal Parameters_load	: STD_LOGIC;
	signal Parameters_normal: STD_LOGIC;
		
	signal Ntakt_event		: STD_LOGIC;
	signal Ndiscr_event  	: STD_LOGIC;
	signal Dlit_event    	: STD_LOGIC;
	signal count_Dlit_EN 	: STD_LOGIC;
	signal count_Dlit_RES	: STD_LOGIC;
	signal count_Dlit			: STD_LOGIC_VECTOR(15 downto 0);
	
	signal sh					: STD_LOGIC;
	
	signal iPS_isp		      : STD_LOGIC;
	signal icount_isp			: STD_LOGIC_VECTOR(31 downto 0);
	signal PS_isp_once      : STD_LOGIC;
	
	signal fall_wait			: STD_LOGIC;
	signal icount_fall_wait	: STD_LOGIC_VECTOR(31 downto 0);
	signal fall_wait_once 	: STD_LOGIC;
	
begin

test_sig	<= Parameters_normal;
------------------------------------------------------------------------------------------------------------------
-- синхронизаци€
   SYNC_PROC: process (rst_sys, clk_sys)
   begin
      if (rst_sys = '1') then
         state <= st0_RST;
			num_state <= x"0";
      elsif (clk_sys'event and clk_sys = '1') then
         state <= next_state;
			num_state <= next_num_state;
      end if;
   end process;	

	Load_Parameters_DECODE: process (rst_sys, clk_sys)
   begin
		if (rst_sys = '1') then
			Ntakt				<= (others => '0');
			Ndiscr			<= (others => '0');
			Dlit				<= (others => '0');
			Parameters_load <= '0';
		elsif (clk_sys'event and clk_sys = '1') then
			if (state = st2_Load_Parameters and Parameters_valid = '1') then
				Ntakt			<= Ntakt_FIFO;
				Ndiscr		<= Ndiscr_FIFO;	
				Dlit			<= Dlit_FIFO;
				Parameters_load <= '1';
			else
				Ntakt			<= Ntakt;
				Ndiscr		<= Ndiscr;
				Dlit			<= Dlit;
				Parameters_load <= '0';
			end if;
		end if;
	end process;

	count_Dlit_EN_DECODE: process (rst_sys, clk_sys)
	begin
		if (rst_sys = '1') then
			count_Dlit_EN <= '0';
		elsif (clk_sys'event and clk_sys = '1') then
				if (state = st5_wait_Dlit) then
					count_Dlit_RES <= '0';
					if (clk_d = '1') then
						count_Dlit_EN <= '1';
					else
						count_Dlit_EN <= '0';
					end if;
				else
					count_Dlit_RES <= '1';
				end if;
		end if;
	end process;
	
	
	count_Dlit_proc: process (rst_sys, clk_sys)
	begin
		if (rst_sys = '1') then
			count_Dlit <= (others => '0');
		elsif (clk_sys'event and clk_sys = '1') then
				if (count_Dlit_RES = '1') then
					count_Dlit <= (others => '0');
				elsif (count_Dlit_EN = '1') then
					count_Dlit <= count_Dlit + '1';
				else
					count_Dlit <= count_Dlit;
				end if;
		end if;
	end process;

	Parameters_normal_DECODE: process (rst_sys, clk_sys)
	begin
		if (rst_sys = '1') then
			Parameters_normal	<= '0';
		elsif (clk_sys'event and clk_sys = '1') then
			if (Ntakt >= takt_number) then
				Parameters_normal	<= '1';			--	Ntakt(импульс) >= takt_number(текущий) - это правльно.
			else
				Parameters_normal	<= '0';			--	Ntakt(импульс) < takt_number(текущий) <=> поздно ждать.
			end if;
		end if;
	end process;

	
	comp_Ntakt_w_takt_number_DECODE: process (rst_sys, clk_sys)
	begin
		if (rst_sys = '1') then
			Ntakt_event	<= '0';
		elsif (clk_sys'event and clk_sys = '1') then
			if (Ntakt = takt_number) then
				Ntakt_event	<= '1';
			else
				Ntakt_event	<= '0';
			end if;
		end if;
	end process;

	comp_Ndiscr_w_discr_number_DECODE: process (rst_sys, clk_sys)
	begin
		if (rst_sys = '1') then
			Ndiscr_event	<= '0';
		elsif (clk_sys'event and clk_sys = '1') then
			if (Ndiscr = discr_number and Ntakt_event = '1') then
				Ndiscr_event	<= '1';
			else
				Ndiscr_event	<= '0';
			end if;
		end if;
	end process;
	
	comp_count_Dlit_w_Dlit_DECODE: process (rst_sys, clk_sys)
	begin
		if (rst_sys = '1') then
			Dlit_event	<= '0';
		elsif (clk_sys'event and clk_sys = '1') then
			if (count_Dlit = Dlit) then
				Dlit_event	<= '1';
			else
				Dlit_event	<= '0';
			end if;
		end if;
	end process;	
	
	Load_Parameters_proc: process (rst_sys, clk_sys)
	begin
		if (rst_sys = '1') then
			Load_Parameters	<= '0';
			sh <= '0';
		elsif (clk_sys'event and clk_sys = '1') then
			if (state = st2_Load_Parameters) then
				if (sh = '0')	then
					Load_Parameters <= '1';
					sh <= '1';
				else
					Load_Parameters <= '0';
					sh <= '1';
				end if;
			else
				sh <= '0';
			end if;
		end if;
	end process;

------------------	
	iPS_isp_proc: process (rst_sys, clk_sys)
	begin
		if (rst_sys = '1') then
			iPS_isp	<= '0';
		elsif (clk_sys'event and clk_sys = '1') then
			if (state = st5_wait_Dlit) then
				iPS_isp <= '1';
			else
				iPS_isp <= '0';
			end if;
		end if;
	end process;
	
	PS_isp <= iPS_isp;

	icount_isp_proc: process (rst_sys, clk_sys)
	begin
		if (rst_sys = '1') then
			icount_isp	<= (others => '0');
			PS_isp_once <= '0';
		elsif (clk_sys'event and clk_sys = '1') then
			if (iPS_isp = '1') then
				if (PS_isp_once = '0') then
					icount_isp	<= icount_isp + '1';
					PS_isp_once <= '1';
				else
					icount_isp	<= icount_isp;
					PS_isp_once <= PS_isp_once;
				end if;
			else
				PS_isp_once <= '0';
			end if;
		end if;
	end process;

	count_isp	<= icount_isp;

------------------
	
	fall_wait_proc: process (rst_sys, clk_sys)
	begin
		if (rst_sys = '1') then
			fall_wait			<= '0';
		elsif (clk_sys'event and clk_sys = '1') then
			if (state = st6_fall_wait) then
				fall_wait <= '1';
			else
				fall_wait <= '0';
			end if;
		end if;
	end process;
	
	icount_fall_wait_proc: process (rst_sys, clk_sys)
	begin
		if (rst_sys = '1') then
			icount_fall_wait			<= (others => '0');
			fall_wait_once 	<= '0';
		elsif (clk_sys'event and clk_sys = '1') then
			if (fall_wait = '1') then
				if (fall_wait_once = '0') then
					icount_fall_wait	<= icount_fall_wait + '1';
					fall_wait_once <= '1';
				else
					icount_fall_wait	<= icount_fall_wait;
					fall_wait_once <= fall_wait_once;
				end if;
			else
				fall_wait_once <= '0';
			end if;
		end if;
	end process;

	count_fall_wait	<= icount_fall_wait;
	
------------------
	
	NEXT_STATE_DECODE: process (state, rst_sys, FIFO_not_empty, Parameters_load, Parameters_normal, Ntakt_event, Ndiscr_event, Dlit_event)
	begin

      next_state <= state;

      case (state) is
         when st0_RST =>
				if (rst_sys = '0') then
					next_state <= st1_wait_FIFO_not_empty;					-- сброс Ntakt, Nach_isp_d, Dlit_isp_d, count_Dlit
				else
					next_state <= st0_RST;
				end if;
	
			when st1_wait_FIFO_not_empty =>
				if (FIFO_not_empty = '1') then										-- ожидание "FIFO не пустое"
					next_state <= st2_Load_Parameters;								-- count_Dlit <= (others => 0);
				else
					next_state <= st1_wait_FIFO_not_empty;
				end if;

			when st2_Load_Parameters =>
				if (Parameters_load = '1') then										-- ожидание валидности данных на выходе FIFO
					next_state <= st4_wait_Imp;
				else
					next_state <= st2_Load_Parameters;
				end if;					

			when st4_wait_Imp =>
				if (Ndiscr_event = '1') then					 						-- ожидание "наступил номер такта и дискрета импульса"
					next_state <= st5_wait_Dlit;
				elsif (Parameters_normal = '0') then								-- проверка "нормальности" параметров импульса по отношению к номеру текущего такта
					next_state <= st6_fall_wait;
				else
					next_state <= st4_wait_Imp;
				end if;
							
			when st5_wait_Dlit =>	
				if (Dlit_event	= '1') then												-- ожидание "счетчик длительности импульса закончил счЄт"
					next_state <= st1_wait_FIFO_not_empty;
				else
					next_state <= st5_wait_Dlit;
				end if;
				
			when st6_fall_wait =>
				next_state <= st1_wait_FIFO_not_empty;
				
			when others => next_state <= st0_RST;
		end case;		
	end process;

	STATE_NUM_DECODE: process (next_state)
	begin
      case (next_state) is
			when st0_RST						 => next_num_state <= x"0";
			when st1_wait_FIFO_not_empty	 => next_num_state <= x"1";	
			when st2_Load_Parameters		 => next_num_state <= x"2";
			when st4_wait_Imp			 	 	 => next_num_state <= x"4";
			when st5_wait_Dlit				 => next_num_state <= x"5";
			when others 						=>  next_num_state <= x"A";
		end case;
	end process;
	
end Behavioral;
