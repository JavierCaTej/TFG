----------------------------------------------------------------------------------
-- Company: Universidad de Cordoba
-- Engineer: Javier Carmona Tejero
-- 
-- Create Date: 22.04.2023 17:50:31
-- Design Name: 
-- Module Name: red_neuronal - Behavioral
-- Project Name: Optimización de toma de decisiones utilizando FPGAs
-- Target Devices: 
-- Tool Versions: 1.2
-- Description: En esta version, se crea una red neuronal de 2 capas en la cual la capa 1 
--              se compone de 3 neuronas y la capa 2 de 1 neurona de salida. Segun la capa a la que pertenezca
--              cada neurona tendra distintos parámetros de entrada y de salida.
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments: El objetivo es que las neuronas sean capaces de comunicarse dando la salida esperada.
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

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
signal sal_n1, sal_n2, sal_n3 : std_logic;      --señales de salida de cada neurona de capa 1
signal ent : std_logic_vector(5 downto 0) := entrada;   --señal de entrada de la red neuronal


begin
    --CAPA 1
    --Mapeo de las 3 neuronas de capa 1
    n1 : neurona1   port map (ent(0), ent(1), sal_n1);  
    n2 : neurona1   port map (ent(2), ent(3), sal_n2);
    n3 : neurona1   port map (ent(4), ent(5), sal_n3);

    --CAPA 2
    --Mapeo de la neurona de salida de capa 2
    n4 : neurona2   port map (sal_n1, sal_n2 , sal_n3, salida_red);

    
end Behavioral;
