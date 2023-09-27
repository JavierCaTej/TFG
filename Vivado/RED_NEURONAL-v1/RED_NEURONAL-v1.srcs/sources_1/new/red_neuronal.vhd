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
-- Additional Comments: Se utiliza en imagenes 512x512, lo aconsejado es usar tantas neuronas en la capa de entrada como px haya.
--                      Las capas seran: capa1->262144 neuronas ; capa2->1024 neuronas ; capa3->10 neuronas
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
        --Entrada de 32 bits, cada neurona coge 2 bits
        clk : in std_logic;
        entrada : in std_logic_vector(31 downto 0);
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
        entrada4 : in STD_LOGIC;
        --Salida de la neurona
        salida : out STD_LOGIC);
end component neurona2;

-- NEURONA CAPA 3
component neurona3 is
    Port ( 
        --Entradas de la neurona
        entrada1 : in STD_LOGIC;
        entrada2 : in STD_LOGIC;
        entrada3 : in STD_LOGIC;
        entrada4 : in STD_LOGIC;
        --Salida de la neurona
        salida : out STD_LOGIC_VECTOR(9 downto 0));
end component neurona3;

-- SEÑALES
signal sal1 : std_logic_vector(15 downto 0);     -- Salida de las neuronas de capa 1 
signal ent : std_logic_vector(31 downto 0) := entrada;

signal sal2 : std_logic_vector(3 downto 0);      -- Salida de las neuronas de capa 2

signal sal3 : std_logic_vector(9 downto 0);        -- Salida de la neurona de capa 3 - 10 numeros = 10 salidas

begin
   
   
    --CAPA 1 - ENTRADA
    capa1: for K in 0 to 15 generate 
    begin
      n1: entity work.neurona1 port map (entrada1 => ent(K*2), entrada2 => ent(K*2+1), salida => sal1(K));
    end generate;

    --CAPA 2 - OCULTA
    capa2: for K in 0 to 3 generate
    begin
        n2: entity work.neurona2 port map (entrada1 => sal1(K), entrada2 => sal1(K+1), entrada3 => sal1(K+2), entrada4 => sal1(K+3), salida => sal2(K));
    end generate;
    
    --CAPA 3 - SALIDA
    capa3: for K in 0 to 10 generate
    begin
        n3: neurona3 port map (sal2(0), sal2(1), sal2(2), sal2(3), sal3); 
    end generate;
    
end Behavioral;
