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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity red_neuronal_tb is
--  Port ( );
end red_neuronal_tb;

architecture Behavioral of red_neuronal_tb is

component red_neuronal is
    Port (
        --Entrada de 6 bits, cada neurona coge 2 bits
        entrada : in std_logic_vector(5 downto 0);
        --Salida de la red neuronal despues del proceso
        salida  : out std_logic);
end component red_neuronal;

--SEÑALES
signal entrada : std_logic_vector(5 downto 0) := "000000";
signal salida : std_logic;

begin

--INSTANCIACION DE UNIT UNDER TEST (UUT)
    uut : red_neuronal port map (entrada => entrada, salida => salida);
    
--SIMULACION
    entrada <= "000000" after 100 ns,
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
               "001111" after 1600 ns;

end Behavioral;
