library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity carry_look_ahead_32 is
port(
         A      :  IN   STD_LOGIC_VECTOR(31 DOWNTO 0);
         B      :  IN   STD_LOGIC_VECTOR(31 DOWNTO 0);
         Cin  :  IN   STD_LOGIC;
         S       :  OUT  STD_LOGIC_VECTOR(31 DOWNTO 0);
         Cout :  OUT  STD_LOGIC;
	 overflow :  OUT  STD_LOGIC
        );
END carry_look_ahead_32;

ARCHITECTURE behavioral OF carry_look_ahead_32 IS

SIGNAL    h_sum     :    STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL    G         :    STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL    P         :    STD_LOGIC_VECTOR(31 DOWNTO 0);
SIGNAL    TEMP      :    STD_LOGIC_VECTOR(31 DOWNTO 1);
SIGNAL    Cout1      :    STD_LOGIC;

BEGIN
    h_sum <= A XOR B;
    g <= A AND B;
    p <= A OR B;
    PROCESS (G,P,TEMP)
    BEGIN
    TEMP(1) <= G(0) OR (P(0) AND Cin);
        lable1 : FOR i IN 1 TO 30 LOOP
              TEMP(i+1) <= G(i) OR (P(i) AND TEMP(i));
              END LOOP;
    Cout1 <= G(31) OR (P(31) AND TEMP(31));
    Cout <= G(31) OR (P(31) AND TEMP(31));
    END PROCESS;

    S(0) <= h_sum(0) XOR Cin;
    S(31 DOWNTO 1) <= h_sum(31 DOWNTO 1) XOR TEMP(31 DOWNTO 1);
	overflow <= temp(31) xor COUT1;
END behavioral;
