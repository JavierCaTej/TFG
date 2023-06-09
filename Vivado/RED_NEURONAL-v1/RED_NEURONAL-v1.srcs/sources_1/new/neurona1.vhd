----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Javier Carmona Tejero
-- 
-- Create Date: 22.04.2023 17:51:58
-- Design Name: 
-- Module Name: neurona1 - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Componente de neuronas de capa 1
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


entity neurona1 is
    Port ( 
        --Entradas de la neurona
        entrada1 : in STD_LOGIC;
        entrada2 : in STD_LOGIC;
        --Salida de la neurona
        salida : out STD_LOGIC);
end neurona1;

architecture Behavioral of neurona1 is
   
    --Constantes para los pesos y bias de la neurona
    constant w1 : real := 1.0;
    constant w2 : real := 0.0;
    constant b  : real := 0.0;
    
    --Funcion de activación sigmoidal
    function sigmoidal(x : real) return real is
        constant e : real := 2.71828;
    begin
        return 1.0 / (1.0 + e**(-x));
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
    
    signal sal : std_logic;
    
begin
    --Calculo de la salidad de la neurona
    sal <= '1' when sigmoidal((to_real(entrada1)*w1) + (to_real(entrada2)*w2) + b) > 0.5 else '0';
    salida <= sal;

end Behavioral;
