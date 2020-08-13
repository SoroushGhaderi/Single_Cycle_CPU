
library ieee;
use ieee.std_logic_1164.all;


entity ControlUnit is
    port(
        signal OPCODE : in std_logic_vector(3 downto 0);
        signal REGDST, ALUSRC, MEMTOREG, REGWRITE, MEMREAD : out std_logic;
        signal MEMWRITE, BRANCH, JUMP,NOOP,HALT,LUDI, JPLINK: out std_logic;
        signal ALUOP : out std_logic_vector(2 downto 0)  
    );
end entity ControlUnit;


architecture behavioral of ControlUnit is
    begin
        
        process(OPCODE)
            begin
                case OPCODE is
                    when "0000" =>  -- add
                        REGDST <= '1';
                        ALUSRC <= '0';
                        MEMTOREG <= '1';
                        REGWRITE <= '1';
                        MEMREAD <= '0';
                        MEMWRITE <= '0';
                        BRANCH <= '0';
                        JUMP <= '0';
                        JPLINK <= '0';
			            LUDI <= '0';
                        NOOP <= '0';
                        HALT <= '0';                      
                        ALUOP <= "000";

                    when "0001" =>   -- sub
                        REGDST <= '1';
                        ALUSRC <= '0';
                        MEMTOREG <= '1';
                        REGWRITE <= '1';
                        MEMREAD <= '0';
                        MEMWRITE <= '0';
                        BRANCH <= '0';
                        JUMP <= '0';
                        JPLINK <= '0';
			            LUDI <= '0';
                        NOOP <= '0';
                        HALT <= '0'; 
                        ALUOP <= "010";

                    when "0010" =>   -- slt
                        REGDST <= '1';
                        ALUSRC <= '0';
                        MEMTOREG <= '1';
                        REGWRITE <= '1';
                        MEMREAD <= '0';
                        MEMWRITE <= '0';
                        BRANCH <= '0';
                        JUMP <= '0';
                        JPLINK <= '0';
			            LUDI <= '0';
                        NOOP <= '0';
                        HALT <= '0'; 
                        ALUOP <= "111";

                    when "0011" =>   -- or
                        REGDST <= '1';
                        ALUSRC <= '0';
                        MEMTOREG <= '1';
                        REGWRITE <= '1';
                        MEMREAD <= '0';
                        MEMWRITE <= '0';
                        BRANCH <= '0';
                        JUMP <= '0';
                        JPLINK <= '0';
			            LUDI <= '0';
                        NOOP <= '0';
                        HALT <= '0'; 
                        ALUOP <= "001";

                    when "0100" =>   -- nand
                        REGDST <= '1';
                        ALUSRC <= '0';
                        MEMTOREG <= '1';
                        REGWRITE <= '1';
                        MEMREAD <= '0';
                        MEMWRITE <= '0';
                        BRANCH <= '0';
                        JUMP <= '0';
                        JPLINK <= '0';
			            LUDI <= '0';
                        NOOP <= '0';
                        HALT <= '0'; 
                        ALUOP <= "100";

                    when "0101" =>   -- add immediate
                        REGDST <= '1';
                        ALUSRC <= '1';
                        MEMTOREG <= '1';
                        REGWRITE <= '1';
                        MEMREAD <= '0';
                        MEMWRITE <= '0';
                        BRANCH <= '0';
                        JUMP <= '0';
                        JPLINK <= '0';
			            LUDI <= '0';
                        NOOP <= '0';
                        HALT <= '0'; 
                        ALUOP <= "000";

                    when "0110" =>   -- or immerdiate
                        REGDST <= '0';
                        ALUSRC <= '1';
                        MEMTOREG <= '1';
                        REGWRITE <= '1';
                        MEMREAD <= '0';
                        MEMWRITE <= '0';
                        BRANCH <= '0';
                        JUMP <= '0';
                        JPLINK <= '0';
 			            LUDI <= '0';
                        NOOP <= '0';
                        HALT <= '0'; 
                        ALUOP <= "001";

                    when "0111" =>   -- slt immediate
                        REGDST <= '0';
                        ALUSRC <= '1';
                        MEMTOREG <= '1';
                        REGWRITE <= '1';
                        MEMREAD <= '0';
                        MEMWRITE <= '0';
                        BRANCH <= '0';
                        JUMP <= '0';
                        JPLINK <= '0';
			            LUDI <= '0';
                        NOOP <= '0';
                        HALT <= '0'; 
                        ALUOP <= "111";

                    when "1000" =>  --lui 
                        REGDST <= '0';
                        ALUSRC <= '1';
                        MEMTOREG <= '1';
                        REGWRITE <= '1';
                        MEMREAD <= '0';
                        MEMWRITE <= '0';
                        BRANCH <= '0';
                        JUMP <= '0';
                        JPLINK <= '0';
			            LUDI <= '1';
                        NOOP <= '0';
                        HALT <= '0'; 
                        ALUOP <= "000";

                    when "1001"=> -- load word
                        REGDST <= '0';
                        ALUSRC <= '1';
                        MEMTOREG <= '0';
                        REGWRITE <= '1';
                        MEMREAD <= '1';
                        MEMWRITE <= '0';
                        BRANCH <= '0';
                        JUMP <= '0';
                        JPLINK <= '0';
  			            LUDI <= '0';
                        NOOP <= '0';
                        HALT <= '0'; 
                        ALUOP <= "000";

                   when "1010" =>   -- store word
                        REGDST <= '1';
                        ALUSRC <= '1';
                        MEMTOREG <= '0';
                        REGWRITE <= '0';
                        MEMREAD <= '0';
                        MEMWRITE <= '1';
                        BRANCH <= '0';
                        JUMP <= '0';
                        JPLINK <= '0';
  			            LUDI <= '0';
                        NOOP <= '0';
                        HALT <= '0'; 
                        ALUOP <= "000";

                   when "1011" =>  -- branch if equal 
                        REGDST <= '0';
                        ALUSRC <= '0';
                        MEMTOREG <= '0';
                        REGWRITE <= '0';
                        MEMREAD <= '0';
                        MEMWRITE <= '0';
                        BRANCH <= '1';
                        JUMP <= '0';
                        JPLINK <= '0';
     			        LUDI <= '0';
                        NOOP <= '0';
                        HALT <= '0'; 
                        ALUOP <= "010";

                   when "1100" =>   --jalr
                        REGDST <= '0';
                        ALUSRC <= '1';
                        MEMTOREG <= '0';
                        REGWRITE <= '1';
                        MEMREAD <= '0';
                        MEMWRITE <= '0';
                        BRANCH <= '0';
                        JUMP <= '0';
                        JPLINK <= '1';
   			            LUDI <= '0';
                        NOOP <= '0';
                        HALT <= '0'; 
                        ALUOP <= "000";

                   when "1101" =>        --jump
                        REGDST <= '0';
                        ALUSRC <= '1';
                        MEMTOREG <= '0';
                        REGWRITE <= '0';
                        MEMREAD <= '0';
                        MEMWRITE <= '0';
                        BRANCH <= '0';
                        JUMP <= '1';
                        JPLINK <= '0';
    			        LUDI <= '0';
                        NOOP <= '0';
                        HALT <= '0'; 
                        ALUOP <= "000";

    		   when "1110" =>      --noop   
                        REGDST <= '0';
                        ALUSRC <= '1';
                        MEMTOREG <= '0';
                        REGWRITE <= '0';
                        MEMREAD <= '0';
                        MEMWRITE <= '0';
                        BRANCH <= '0';
                        JUMP <= '0';
                        JPLINK <= '0';
    			LUDI <= '0';
                        NOOP <= '1';
                        HALT <= '0'; 
                        ALUOP <= "000";

                  when "1111" =>       --halt
                        REGDST <= '0';
                        ALUSRC <= '1';
                        MEMTOREG <= '0';
                        REGWRITE <= '0';
                        MEMREAD <= '0';
                        MEMWRITE <= '0';
                        BRANCH <= '0';
                        JUMP <= '0';
                        JPLINK <= '0';
    			        LUDI <= '0';
                        NOOP <= '0';
                        HALT <= '1'; 
                        ALUOP <= "000";
		  when others => 
			            REGDST <= '0'; -- this is for cover not identificated signals
                        ALUSRC <= '1';
                        MEMTOREG <= '0';
                        REGWRITE <= '0';
                        MEMREAD <= '0';
                        MEMWRITE <= '0';
                        BRANCH <= '0';
                        JUMP <= '0';
                        JPLINK <= '0';
    			        LUDI <= '0';
                        NOOP <= '0';
                        HALT <= '1'; 
                        ALUOP <= "000";
                end case;
        end process;
end architecture behavioral;