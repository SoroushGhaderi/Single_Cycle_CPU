-- 3-port register file

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
entity registerFileGeneric is
   port(
	clk: in std_logic;
	reset: in std_logic;
	wr_en: in std_logic;
	RD, RS, RT: in std_logic_vector(3 downto 0);
	WRDATA: in std_logic_vector(31 downto 0);
	RDATA1: out std_logic_vector(31 downto 0);
	RDATA2: out std_logic_vector(31 downto 0));
end registerFileGeneric;
architecture loop_arch of registerFileGeneric is
   type register_file_type is array(15 downto 0) of std_logic_vector(31 downto 0);
   signal state_reg,state_next: register_file_type;
   signal en,en1,en2:std_logic_vector(15 downto 0);
begin
   process(clk,reset)
   begin
      if(reset = '1') then
	 for i in 0 to 15 loop
 	   state_reg(i) <= (others => '0');
	 end loop;
      elsif(clk'event and clk = '1') then
	for i in 0 to 15 loop
	   state_reg(i) <= state_next(i);
	end loop;
      end if;
   end process;
   process(state_reg,wr_en,RD)
   begin
      en1 <= (others => '0');
      en2 <= (to_integer(unsigned(RD)) => '1',others => '0');
      if (wr_en = '1') then
         en <= en2;
      else
	 en <= en1;
      end if;      
   end process;
   process(en,WRDATA)
   begin
      for i in 0 to 15 loop
         state_next(i) <= state_reg(i);
      end loop;
      if (en(to_integer(unsigned(RD))) = '1') then 
	 state_next(to_integer(unsigned(RD))) <= WRDATA;
      end if;
   end process;
   RDATA1 <= state_reg(to_integer(unsigned(RS)));
   RDATA2 <= state_reg(to_integer(unsigned(RT)));
end loop_arch;