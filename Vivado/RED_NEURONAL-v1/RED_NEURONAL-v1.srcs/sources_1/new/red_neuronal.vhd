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
use IEEE.std_logic_arith.all;
use ieee.std_logic_unsigned.all; --usar los operandos + y *
use ieee.numeric_std.all;   --usar los numeros reales (se ponen con decimales 2.0, 14.0,...)
use ieee.math_real.all;     --usar los operandos ** 



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
signal sal : std_logic_vector(2 downto 0);
signal ent : std_logic_vector(5 downto 0) := entrada;


begin
   
   
--    --CAPA 1

    capa1: for K in 0 to 2 generate 
    begin
      n1: entity work.neurona1 port map (entrada1 => ent(K*2), entrada2 => ent(K*2+1), salida => sal(K));
    end generate;


    --CAPA 2
    n4 : neurona2   port map (sal(0), sal(1) , sal(2), salida_red);

    
end Behavioral;
