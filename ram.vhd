library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memory is
   port(
	clk: in std_logic;
	reset: in std_logic;
	write_enable: in std_logic;
	read_enable: in std_logic;
	write_address: in std_logic_vector(9 downto 0);
	read_address: in std_logic_vector(9 downto 0);
	write_data: in std_logic_vector(31 downto 0);
	read_data: out std_logic_vector(31 downto 0));
end memory;

architecture behavioral of memory is

   type memory_type is array(1023 downto 0) of std_logic_vector(7 downto 0);
   signal state_reg,state_next: memory_type;
   signal en1,en2:std_logic_vector(1023 downto 0);

begin
	
   process(CLK,reset)
   begin
      if(reset = '1') then
	 for i in 0 to 1023 loop
 	   state_reg(i) <= (others => '0');
	 end loop;
      elsif(clk'event and clk = '1') then
	for i in 0 to 1023 loop
	   state_reg(i) <= state_next(i);
	end loop;
      end if;
   end process;
   process(state_reg,write_enable,write_address)
   begin

      if (write_enable = '1') then
         en1 <= (to_integer(unsigned(write_address)) => '1',others => '0');
      else
	 en1 <= (others => '0');
      end if; 
     
   end process;
   process(en1,write_data)
   begin
      for i in 0 to 1023 loop
         state_next(i) <= state_reg(i);
      end loop;
      if (en1(to_integer(unsigned(write_address))) = '1') then 
	 state_next(to_integer(unsigned(write_address))) <= write_data(7 DOWNTO 0);
	 state_next(to_integer(unsigned(write_address))+1) <= write_data(15 DOWNTO 8);
	 state_next(to_integer(unsigned(write_address))+2) <= write_data(23 DOWNTO 16);
	 state_next(to_integer(unsigned(write_address))+3) <= write_data(31 DOWNTO 24);
      end if;
   end process;

process(state_reg,read_enable,read_address)
   begin

      if (read_enable = '1') then
         en2 <= (to_integer(unsigned(read_address)) => '1',others => '0');
      else
	 en2 <= (others => '0');
      end if; 
     
   end process;
   process(en2)
   begin
      if (en2(to_integer(unsigned(read_address))) = '1') then 
	 read_data(7 DOWNTO 0) <= state_reg(to_integer(unsigned(read_address)));
	 read_data(15 DOWNTO 8) <= state_reg(to_integer(unsigned(read_address))+1);
	 read_data(23 DOWNTO 16) <= state_reg(to_integer(unsigned(read_address))+2);
	 read_data(31 DOWNTO 24) <= state_reg(to_integer(unsigned(read_address))+3);
      end if;
   end process;

end behavioral;
