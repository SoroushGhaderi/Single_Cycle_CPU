-- package declaration for single cycle CPU functional units

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity single_cycle_cpu is  
    port(
        signal CLK, RESET, WREN, START, WRDST, SHIFT, WRDATA : in std_logic;  -- set RESET to a key
        signal WRADDRESS : in std_logic_vector(6 downto 0);
        signal LOAD : in std_logic_vector(7 downto 0);
        signal CLKS : out std_logic
        );
end entity single_cycle_cpu;


architecture structure of  single_cycle_cpu is


-- register file
component register_file is
    port(
        signal REGWR, CLK : in std_logic;
        signal RD, RS, RT : in std_logic_vector(3 downto 0);
        signal WRDATA, LO, HI : in std_logic_vector(31 downto 0);
        signal RDATA1, RDATA2, RV : out std_logic_vector(31 downto 0)
    );
end component register_file;

-- carry look ahead adder
component carry_look_ahead is
    port(
             A      :  IN   STD_LOGIC_VECTOR(31 DOWNTO 0);
             B      :  IN   STD_LOGIC_VECTOR(31 DOWNTO 0);
             Cin  :  IN   STD_LOGIC;
             S       :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
             Cout :  OUT  STD_LOGIC;
             overflow :  OUT  STD_LOGIC
            );
    END component;

-- arithmetic-logical unit
component project_ALU is
    port(
        signal OPCODE : in std_logic_vector(1 downto 0);
        signal X, Y : in std_logic_vector(31 downto 0);
        signal R : out std_logic_vector(31 downto 0);
        signal Z : out std_logic;
        signal Anot : in STD_LOGIC;
        signal Bnot : in STD_LOGIC;
        signal overflow : out STD_LOGIC;
        signal zero : out STD_LOGIC;
        signal cout : out STD_LOGIC);
end component project_ALU;

        
-- main control unit
component project_control is
    port(
        signal OPCODE : in std_logic_vector(3 downto 0);
        signal REGDST, ALUSRC, MEMTOREG, REGWRITE, MEMREAD : out std_logic;
        signal MEMWRITE, BRANCH, JUMP, JPLINK, JUMPRST : out std_logic;
        signal ALUOP : out std_logic_vector(1 downto 0)
    );
end component project_control;


-- 32bit wide 2:1 multiplexer
component multiplexer_32bit_2_1 is
    port(
        signal SEL : in std_logic;
        signal A, B : in std_logic_vector(31 downto 0);
        signal O : out std_logic_vector(31 downto 0)
    );
end component multiplexer_32bit_2_1;

-- 5bit wide 2:1 multiplexer
component multiplexer_5bit_2_1 is
    port(
        signal SEL : in std_logic;
        signal A, B : in std_logic_vector(4 downto 0);
        signal O : out std_logic_vector(4 downto 0)
    );
end component multiplexer_5bit_2_1;

-- memory
component memory is
    port(
     clk: in std_logic;
     reset: in std_logic;
     write_enable: in std_logic;
     read_enable: in std_logic;
     write_address: in std_logic_vector(9 downto 0);
     read_address: in std_logic_vector(9 downto 0);
     write_data: in std_logic_vector(31 downto 0);
     read_data: out std_logic_vector(31 downto 0));
 end component memory;


   
-- control intermediate signals
signal registerDestination, aluSource, memoryToRegister, registerWrite, jumpRegister : std_logic;
signal memoryRead, memoryWrite, branch, jump, zeroFlag, branchControl, jumpAndLink : std_logic;
signal aluOperation : std_logic_vector(1 downto 0);
signal operationCode : std_logic_vector(3 downto 0);
-- other signals
signal writeInstructionMemory, writeDataMemory, clockSignal : std_logic;
signal temporal2, destination : std_logic_vector(4 downto 0);
signal instruction, readData1, readData2, aluResult, offset, instructionAddress, nextInstruction : std_logic_vector(31 downto 0); 
signal loadMemory, loadData, dataOut, operand, toRegisterFile, branchOffset: std_logic_vector(31 downto 0);
signal nextSequentialInstruction, branchAddress, source2, jumpAddress : std_logic_vector(31 downto 0);
signal temporalAddress1, temporalAddress2, temporal3, returnValue, writeReadAddress : std_logic_vector(31 downto 0);
signal temporal : signed(31 downto 0);


    begin
        -- component instantiation
        
        mux1 : multiplexer_5bit_2_1
            port map(SEL => registerDestination, A => instruction(19 downto 16), B => instruction(15 downto 12), O => temporal2);

        mux2 : multiplexer_5bit_2_1
            port map(SEL => jumpAndLink, A => temporal2, B => "11111", O => destination);

        registerFile : register_file
            port map(REGWR => registerWrite, CLK => clockSignal, RD => destination, RS => instruction(23 downto 20), RT => instruction(20 downto 16), WRDATA => toRegisterFile, RDATA1 => readData1, RDATA2 => readData2, RV => returnValue);

        mux3 : multiplexer_32bit_2_1
            port map(SEL => aluSource, A => readData2, B => operand, O => source2);

        alu : project_ALU
            port map(OPCODE => operationCode, X => readData1, Y => source2, Z => zeroFlag, R => aluResult);

        -- to register file
        mux4 : multiplexer_32bit_2_1
            port map(SEL => memoryToRegister, A => aluResult, B => dataOut, O => temporal3);

        mux5 : multiplexer_32bit_2_1
            port map(SEL => jumpAndLink, A => temporal3, B => nextSequentialInstruction, O => toRegisterFile);            

        control : project_control
            port map(OPCODE => instruction(27 downto 24), REGDST => registerDestination, ALUSRC => aluSource, MEMTOREG => memoryToRegister, REGWRITE => registerWrite, MEMREAD => memoryRead, MEMWRITE => memoryWrite, BRANCH => branch, JUMP => jump, JPLINK => jumpAndLink, JUMPRST => jumpRegister, ALUOP => aluOperation);

        adder1 : carry_look_ahead
            port map(X => instructionAddress, Y => offset, SUM => nextSequentialInstruction);

        adder2 : carry_look_ahead
            port map(X => nextSequentialInstruction, Y => branchOffset, SUM => branchAddress);

        mux6 : multiplexer_32bit_2_1
            port map(SEL => branchControl, A => nextSequentialInstruction, B => branchAddress, O => temporalAddress1);

        mux7 : multiplexer_32bit_2_1
            port map(SEL => jump, A => temporalAddress1, B => jumpAddress, O => temporalAddress2);

        mux8 : multiplexer_32bit_2_1
            port map(SEL => jumpRegister, A => temporalAddress2, B => readData1, O => nextInstruction);

        
        

end architecture structure;
