library ieee;
use ieee.std_logic_1164.all;

entity UCincremental is
  port (
    	--lista de entradas y salidas de la UC: reset, clk etc
	reset, clk: in std_logic;
	fin_cnt, Reg9, Reg0 : in std_logic;
	ld_cnt,dcr,sl_reg,sr_reg: out std_logic
  );
end UCincremental;

architecture arquitecturaUCincremental of UCincremental is

	type estado is (e0, e1, e2, e3, e4, e5, e6,e7,e8);
	signal ep, es: estado;
	
	begin
		process (clk,reset)
    		begin
      			if reset='1' then ep<=e0;
        		elsif clk'event and clk='1' then ep<=es;
      			end if;
  		end process;

		process (ep, fin_cnt, Reg9,Reg0)
		begin
			case ep is
			when e0 =>  es <= e1;
			when e1 => es <= e2;
			when e2 => if fin_cnt = '0' then es <= e2;
				else es <= e3; 
				end if;
			when e3 => es <=e7;
			when e7 => if Reg9 = '0' then es <= e1;
				else es <= e4; 
				end if;
			when e4 =>  es <= e5;
			when e5 => if fin_cnt = '0' then es <= e5;
				else es <= e6; 
				end if;
			when e6 => es <=e8;
			when e8 => if Reg0 = '0' then es <= e4;
				else es <= e0;
				end if;
			end case;
		end process;
	
		
		ld_cnt <= '1' when (ep=e1 or ep=e4 ) else '0';
		dcr <= '1' when (ep=e2 or ep=e5) else '0';
		sl_reg <= '1' when ep=e3 else '0';
		sr_reg <= '1' when (ep=e6 ) else '0';
		
end arquitecturaUCincremental;
