----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.04.2023 20:05:50
-- Design Name: 
-- Module Name: red_neuronal_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity red_neuronal_tb is
--  Port ( );
end red_neuronal_tb;

architecture Behavioral of red_neuronal_tb is

component red_neuronal is
    Port (
        --Entrada de 6 bits, cada neurona coge 2 bits
        clk : in std_logic;
        entrada : in std_logic_vector(5 downto 0);
        --Salida de la red neuronal despues del proceso
        salida_red  : out std_logic);
end component red_neuronal;

component neurona1 is
    Port ( 
        --Entradas de la neurona
        entrada1 : in STD_LOGIC;
        entrada2 : in STD_LOGIC;
        --Salida de la neurona
        salida : out STD_LOGIC);
end component neurona1;

component neurona2 is
    Port ( 
        --Entradas de la neurona
        entrada1 : in STD_LOGIC;
        entrada2 : in STD_LOGIC;
        entrada3 : in STD_LOGIC;
        entrada4 : in STD_LOGIC;
        --Salida de la neurona
        salida : out STD_LOGIC);
end component neurona2;

component neurona3 is
    Port ( 
        --Entradas de la neurona
        entrada1 : in STD_LOGIC;
        entrada2 : in STD_LOGIC;
        entrada3 : in STD_LOGIC;
        entrada4 : in STD_LOGIC;
        --Salida de la neurona
        salida : out STD_LOGIC);
end component neurona3;

--SEÑALES
signal sal1 : std_logic_vector(15 downto 0);     -- Salida de las neuronas de capa 1 
signal ent : std_logic_vector(31 downto 0) := x"00";

signal sal2 : std_logic_vector(3 downto 0);      -- Salida de las neuronas de capa 2

signal sal3 : std_logic;        -- Salida de la neurona de capa 3

signal secuencia : std_logic_vector(31 downto 0) := x"00";

begin

    --CAPA 1
    capa1: for K in 0 to 15 generate 
    begin
      n1: entity work.neurona1 port map (entrada1 => ent(K*2), entrada2 => ent(K*2+1), salida => sal1(K));
    end generate;

    --CAPA 2
    capa2: for K in 0 to 3 generate
    begin
        n2: entity work.neurona2 port map (entrada1 => sal1(K), entrada2 => sal1(K+1), entrada3 => sal1(K+2), entrada4 => sal1(K+3), salida => sal2(K));
    end generate;
    
    --CAPA 3
    n3: neurona3 port map (sal2(0), sal2(1), sal2(2), sal2(3), sal3); 
    
    
--SIMULACION
    
    proceso_sim : process(clk)
        variable delay : integer := 100;
    begin
        if rising_edge(clk) then
          delay := delay + 100; -- Incrementa el tiempo de retraso en 100 ns
          for i in 0 to 6 loop -- Se genera un bucle de 7 iteraciones para los 7 valores de la secuencia
            if delay = (i+1)*100 then
              ent <= secuencia;
            end if;
          end loop;
        end if;    
        
    end process;  
    
    
    
    --RED NEURONAL
    ent <= "000000" after 100 ns,
               "000001" after 200 ns, 
               "000010" after 300 ns, 
               "000011" after 400 ns, 
               "000100" after 500 ns, 
               "000101" after 600 ns, 
               "000110" after 700 ns, 
               "000111" after 800 ns, 
               "001000" after 900 ns, 
               "001001" after 1000 ns, 
               "001010" after 1100 ns, 
               "001011" after 1200 ns, 
               "001100" after 1300 ns, 
               "001101" after 1400 ns, 
               "001110" after 1500 ns,
               "001111" after 1600 ns,
               "010000" after 1700 ns,
               "010001" after 1800 ns,
               "010010" after 1900 ns,
               "010011" after 2000 ns,
               "010100" after 2100 ns,
               "010101" after 2200 ns,
               "010110" after 2300 ns,
               "010111" after 2400 ns,
               "011000" after 2500 ns,
               "011001" after 2600 ns,
               "011010" after 2700 ns,
               "011011" after 2800 ns,
               "011100" after 2900 ns,
               "011101" after 3000 ns,
               "011110" after 3100 ns,
               "011111" after 3200 ns,
               "011111" after 3300 ns,
               "100000" after 3400 ns,
               "100001" after 3500 ns, 
               "100010" after 3600 ns, 
               "100011" after 3700 ns, 
               "100100" after 3800 ns, 
               "100101" after 3900 ns, 
               "100110" after 4000 ns, 
               "100111" after 4100 ns, 
               "101000" after 4200 ns, 
               "101001" after 4300 ns, 
               "101010" after 4400 ns, 
               "101011" after 4500 ns, 
               "101100" after 4600 ns, 
               "101101" after 4700 ns, 
               "101110" after 4800 ns,
               "101111" after 4900 ns,
               "110000" after 5000 ns,
               "110001" after 5100 ns,
               "110010" after 5200 ns,
               "110011" after 5300 ns,
               "110100" after 5400 ns,
               "110101" after 5500 ns,
               "110110" after 5600 ns,
               "110111" after 5700 ns,
               "111000" after 5800 ns,
               "111001" after 5900 ns,
               "111010" after 6000 ns,
               "111011" after 6100 ns,
               "111100" after 6200 ns,
               "111101" after 6300 ns,
               "111110" after 6400 ns,
               "111111" after 6500 ns;
end Behavioral;
