----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 07.05.2023 17:44:38
-- Design Name: 
-- Module Name: neurona3 - Behavioral
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



entity neurona3 is
    Port ( 
        --Entradas de la neurona
        entrada1 : in STD_LOGIC;
        entrada2 : in STD_LOGIC;
        entrada3 : in STD_LOGIC;
        entrada4 : in STD_LOGIC;
        --Salida de la neurona
        salida : out STD_LOGIC);
end neurona3;

architecture Behavioral of neurona3 is

    --Constantes para los pesos y bias de la neurona
    constant w1 : real := 0.1;
    constant w2 : real := 0.2;
    constant w3 : real := 0.21;
    constant w4 : real := 0.21;
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
    salida <= '1' when rampa((to_real(entrada1)*w1) + (to_real(entrada2)*w2) + (to_real(entrada3)*w3) + (to_real(entrada4)*w4) + b) > 0.5 else '0';

end Behavioral;
