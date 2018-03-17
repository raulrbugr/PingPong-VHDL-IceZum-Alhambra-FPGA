LIBRARY ieee  ; 
USE ieee.std_logic_1164.all  ; 
use ieee.numeric_std.all;

ENTITY incremental_tb  IS 

END ; 

architecture incremental_tb_arch of incremental_tb is
	
	--Entradas
	signal clk : std_logic := '0';
	signal reset : std_logic :='1';
	--Salidas
	signal  leds : unsigned (7 downto 0) ;

	component incremental is
		port(
			reset, clk: in std_logic;
			leds: out unsigned (7 downto 0)
		);
	end component;

	begin
		DUT: incremental
		
		port map(
			clk=>clk,
			reset=>reset,
			leds=>leds
		);
		--Reloj
		clk <= not clk after 10 ns;


		--Test bench

		process
		begin
						
			wait for 40 ns;
			reset <= '0';
                        wait for 100 ns;
			
			

			wait;
		end process;
end;
			
