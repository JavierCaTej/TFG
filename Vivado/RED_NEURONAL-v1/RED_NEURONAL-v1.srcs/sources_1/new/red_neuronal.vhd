----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 22.04.2023 17:50:31
-- Design Name: 
-- Module Name: red_neuronal - Behavioral
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

entity red_neuronal is
    Port (
        --Entrada de 6 bits, cada neurona coge 2 bits
        entrada : in std_logic_vector(5 downto 0);
        --Salida de la red neuronal despues del proceso
        salida_red  : out std_logic);
end red_neuronal;

architecture Behavioral of red_neuronal is

-- NEURONA CAPA 1
component neurona1 is
    Port ( 
        --Entradas de la neurona
        entrada1 : in STD_LOGIC;
        entrada2 : in STD_LOGIC;
        --Salida de la neurona
        salida : out STD_LOGIC);
end component neurona1;

-- NEURONA CAPA 2
component neurona2 is
    Port ( 
        --Entradas de la neurona
        entrada1 : in STD_LOGIC;
        entrada2 : in STD_LOGIC;
        entrada3 : in STD_LOGIC;
        --Salida de la neurona
        salida : out STD_LOGIC);
end component neurona2;

-- SEÑALES
signal sal_n1, sal_n2, sal_n3, sal_n4 : std_logic;
signal ent : std_logic_vector(5 downto 0) := entrada;


begin
    --CAPA 1
    n1 : neurona1   port map (ent(0), ent(1), sal_n1);
    n2 : neurona1   port map (ent(2), ent(3), sal_n2);
    n3 : neurona1   port map (ent(4), ent(5), sal_n3);

    --CAPA 2
    n4 : neurona2   port map (sal_n1, sal_n2 , sal_n3, salida_red);

    --ASIGNACIÓN DE LA SALIDA
    --salida_red <= sal_n4;
    
end Behavioral;
