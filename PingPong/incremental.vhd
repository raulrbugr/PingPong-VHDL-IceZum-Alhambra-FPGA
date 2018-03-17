LIBRARY ieee  ; 
USE ieee.std_logic_1164.all  ; 
use ieee.numeric_std.all;

entity incremental is
	port(
		reset, clk: in std_logic;
		
		leds: out unsigned (7 downto 0)
	);
end incremental;

architecture arquitecturaIncremental of incremental is

	--Unidad de control
	
	component UCincremental is
 		port (
    		--lista de entradas y salidas de la UC: reset, clk etc
		reset, clk: in std_logic;
		fin_cnt, Reg9, Reg0 : in std_logic;
		ld_cnt,dcr,sl_reg,sr_reg: out std_logic
  	);
	end component;

	--Señales internas que tenemos que conectar entre la UC y la UP
	signal fin_cnt : std_logic;
	signal Reg9, Reg0 : std_logic;
	signal ld_cnt,dcr,sl_reg,sr_reg: std_logic;
	
	
	signal register10 : unsigned (9 downto 0) ;
	signal value_cnt : unsigned (23 downto 0) := "101101110001101100000000";
	--signal value_cnt : unsigned (23 downto 0) := "000000000000000000010000"; --simulation
	

	begin

		UC : UCincremental
			port map(
				reset => reset, 
				clk => clk, 
				fin_cnt => fin_cnt,
				Reg9 => Reg9,
				Reg0 => Reg0,
				ld_cnt => ld_cnt, 
				sl_reg=> sl_reg, 
				sr_reg => sr_reg,
				dcr=>dcr

			);
		
		--registro de desplazamiento
		process(clk, reset,sl_reg,sr_reg)
			begin
				if reset='1' then register10(9 downto 0)<="0000000001";
				elsif (clk'event) and (clk='1')  then
					if (sl_reg='1') then 	 -- Desplazamos a la izquierda
						register10(9 downto 1) <= register10( 8 downto 0);
						register10(0) <= '0';
					elsif (sr_reg='1') then  -- Desplazamos a la derecha
						register10(8 downto 0) <= register10( 9 downto 1);
						register10(9) <= '0';
					end if;
				end if;
		end process;

		-- Asignamos a los leds
		leds <= register10 (8 downto 1);
		Reg9 <= register10(9);
		Reg0 <= register10(0);

		--registro de contador byte
		process(clk,reset,dcr,ld_cnt)
			begin
				if (reset='1')  then value_cnt<="101101110001101100000000";
				elsif (clk'event) and (clk='1') then
					if (ld_cnt='1') then value_cnt<="101101110001101100000000";
					elsif (dcr='1')  then 
						value_cnt<=value_cnt-1;
						
					end if;
				end if;
		end process;

		--Registro fin de cotnador
		fin_cnt<='1' WHEN  (value_cnt=0) else '0';

		

end arquitecturaIncremental;
