library IEEE;
use IEEE.std_logic_1164.all;

entity tb_ULA is
end entity tb_ULA;

architecture comportamento of tb_ULA is

    component ula_core
        port (
            A      : in std_logic_vector(4 downto 0);
            B      : in std_logic_vector(4 downto 0);
            opcode : in std_logic_vector(3 downto 0);
            Result : out std_logic_vector(4 downto 0);
            Zero   : out std_logic;
            Carry  : out std_logic
        );
    end component;
    
    signal fio_A         : std_logic_vector(4 downto 0);
    signal fio_B         : std_logic_vector(4 downto 0);
    signal fio_Opcode    : std_logic_vector(3 downto 0);
    signal fio_Resultado : std_logic_vector(4 downto 0);
    signal fio_Zero      : std_logic;
    signal fio_Carry     : std_logic;

begin

    UUT: ula_core port map(
        A      => fio_A,
        B      => fio_B,
        opcode => fio_Opcode,
        Result => fio_Resultado,
        Zero   => fio_Zero,
        Carry  => fio_Carry
    );

    processo_de_teste: process
    begin
        fio_A <= "00101"; -- recebe +5
        fio_B <= "00100"; -- recebe +4
        
        -- Teste da Soma 
        fio_Opcode <= "0000";
        wait for 20 ns;
        
        -- Teste da Subtração
        fio_Opcode <= "0001";
        wait for 20 ns;
        
        -- Teste da AND
        fio_Opcode <= "0010";
        wait for 20 ns;
        
        -- Teste da OR
        fio_Opcode <= "0011";
        wait for 20 ns;
        
        -- Teste da XOR
        fio_Opcode <= "0100";
        wait for 20 ns;
        
        -- Teste da NOT A
        fio_Opcode <= "0101";
        wait for 20 ns;
        
        -- Teste da NOT B
        fio_Opcode <= "0110";
        wait for 20 ns;
        
        -- Teste do Incremento de A (A + 1)
        fio_Opcode <= "0111"; 
        wait for 20 ns;

        -- Teste do Incremento de B (B + 1)
        fio_Opcode <= "1000"; 
        wait for 20 ns;
        
        wait; 
    end process;

end architecture comportamento;