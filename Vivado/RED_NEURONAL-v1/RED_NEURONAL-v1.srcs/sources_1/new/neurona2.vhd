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
-- Description: Componente de neuronas de capa 2. Este componente tiene 3 bits de entrada que corresponden a las 
--              salidas de las 3 neuronas de capa 1. Cada bit de entrada tiene asignado un peso especifico. En este caso
--              como estamos en una capa de salida se usara como funcion de activacion una funcion lineal.
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
use ieee.std_logic_unsigned.all; --usar los operandos + y *
use ieee.numeric_std.all;   --usar los numeros reales (se ponen con decimales 2.0, 14.0,...)
use ieee.math_real.all;     --usar los operandos ** 

entity neurona2 is
    Port ( 
        --Entradas de la neurona
        entrada1 : in STD_LOGIC;
        entrada2 : in STD_LOGIC;
        entrada3 : in STD_LOGIC;
        --Salida de la neurona
        salida : out STD_LOGIC);
end neurona2;

architecture Behavioral of neurona2 is

    --Constantes para los pesos y bias de la neurona
    constant w1 : real := 0.1;
    constant w2 : real := 0.2;
    constant w3 : real := 0.21;
    constant b  : real := 0.0;

    --Funcion de activacion rampa   -- NO HACE NADA, SIMPLEMENTE PARA ACLARAR LA FUNCION DE ACTIVACION
    function rampa(x : real) return real is 
    begin
        return x;
    end function;

    --Funcion para pasar de std_logic a real
    function to_real(x : std_logic) return real is
    begin
        if x = '1' then
            return 1.0;
        else
            return 0.0;
        end if;   
    end function;
    
    
begin
    --Calculo de la salida de la neurona
    salida <= '1' when rampa((to_real(entrada1)*w1) + (to_real(entrada2)*w2) + (to_real(entrada3)*w3) + b) > 0.5 else '0';

end Behavioral;
