library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ula_core is
    Port (
        A      : in  STD_LOGIC_VECTOR(4 downto 0); -- 5 bits
        B      : in  STD_LOGIC_VECTOR(4 downto 0); -- 5 bits
        opcode : in  STD_LOGIC_VECTOR(3 downto 0); -- 4 bits
        Result : out STD_LOGIC_VECTOR(4 downto 0); -- 5 bits
        Zero   : out STD_LOGIC;
        Carry  : out STD_LOGIC
    );
end ula_core;

architecture RTL of ula_core is
begin
    process(A, B, opcode)
        -- Variáveis temporárias estendidas para 6 bits para tratar o carry de forma limpa
        variable unsigned_A   : unsigned(5 downto 0);
        variable unsigned_B   : unsigned(5 downto 0);
        variable arithmetic_R : unsigned(5 downto 0);
        
        -- Variáveis para armazenar as saídas parciais
        variable tmp_result   : std_logic_vector(4 downto 0);
        variable tmp_carry    : std_logic;
    begin
        -- Ajuste de tamanho para operações aritméticas (bit extra à esquerda)
        unsigned_A := unsigned('0' & A);
        unsigned_B := unsigned('0' & B);
        
        -- Inicializações padrão
        arithmetic_R := (others => '0');
        tmp_result   := (others => '0');
        tmp_carry    := '0';

        case opcode is

            -- OPERAÇÕES ARITMÉTICAS
            when "0000" => -- A + B (soma)
                arithmetic_R := unsigned_A + unsigned_B;
                tmp_result   := std_logic_vector(arithmetic_R(4 downto 0));
                tmp_carry    := arithmetic_R(5);

            when "0001" => -- A - B (subtração via complemento de 2)
                arithmetic_R := unsigned_A - unsigned_B;
                tmp_result   := std_logic_vector(arithmetic_R(4 downto 0));
                tmp_carry    := arithmetic_R(5); -- captura o comportamento natural do vetor

            when "0111" => -- A + 1 (incremento de A)
                arithmetic_R := unsigned_A + 1;
                tmp_result   := std_logic_vector(arithmetic_R(4 downto 0));
                tmp_carry    := arithmetic_R(5);

            when "1000" => -- B + 1 (incremento de B)
                arithmetic_R := unsigned_B + 1;
                tmp_result   := std_logic_vector(arithmetic_R(4 downto 0));
                tmp_carry    := arithmetic_R(5);

            -- OPERAÇÕES LÓGICAS
            when "0010" => -- A AND B
                tmp_result := A and B;
                tmp_carry  := '0';

            when "0011" => -- A OR B
                tmp_result := A or B;
                tmp_carry  := '0';

            when "0100" => -- A XOR B
                tmp_result := A xor B;
                tmp_carry  := '0';

            when "0101" => -- NOT A
                tmp_result := not A;
                tmp_carry  := '0';

            when "0110" => -- NOT B
                tmp_result := not B;
                tmp_carry  := '0';

            -- Trata opcodes não mapeados para evitar travas no circuito (Latches)
            when others =>
                tmp_result := (others => '0');
                tmp_carry  := '0';
        end case;

            -- GERAÇÃO DA FLAG ZERO
        if tmp_result = "00000" then
            Zero <= '1';
        else
            Zero <= '0';
        end if;

        -- Atribuição final às saídas da entidade
        Result <= tmp_result;
        Carry  <= tmp_carry;

    end process;
end RTL;