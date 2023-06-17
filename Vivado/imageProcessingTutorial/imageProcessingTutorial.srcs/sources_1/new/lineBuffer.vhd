----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.06.2023 12:58:07
-- Design Name: 
-- Module Name: lineBuffer - rtl
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
use IEEE.NUMERIC_STD.ALL;


entity lineBuffer is
    port( 
        i_clk : in std_logic;   -- Reloj
        i_rst : in std_logic;   -- Reset activo alto
        i_data : in std_logic_vector(7 downto 0);   -- Datos que llegan al bufer de linea, un px de datos (1 byte)
        i_data_valid : in std_logic;    -- Indica si los datos son validos o no
        o_data : out std_logic_vector(23 downto 0); -- 3 px de una misma linea concatenados (3 bytes = 24 bits)
        i_rd_data : in std_logic    -- Indica si los datos se pueden leer   
    );
end lineBuffer;

architecture rtl of lineBuffer is
    type line_type is array(511 downto 0) of std_logic_vector(7 downto 0);  -- Cada linea son 512 px y cada px son 8 bits (en imagen 512x512)
    signal line : line_type;
    
    -- Punteros para escritura y lectura. Indican el px donde escribir o leer de cada linea (2^9 = 512px por linea)
    signal wrPntr, rdPntr : std_logic_vector(8 downto 0);   
    
    
begin

    -- LEER LINEA
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if i_data_valid = '1' then
                line(to_integer(unsigned(wrPntr))) <= i_data;  -- Se asigna los px de la linea     
            end if;
        end if;     
    end process;

    -- AVANZAR PUNTERO DE ESCRITURA
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if i_rst = '1' then
                wrPntr <= (others => '0');    
            elsif i_data_valid = '1' then
                wrPntr <= std_logic_vector(unsigned(wrPntr) + 1);
            end if;
        end if;     
    end process;
    
    -- SALIDA DE 3 px conjuntos
    o_data <= line(to_integer(unsigned(rdPntr))) & line(to_integer(unsigned(rdPntr))+1) & line(to_integer(unsigned(rdPntr))+2);

    -- AVANZAR PUNTERO DE LECTURA
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if i_rst = '1' then
                rdPntr <= (others => '0');    
            elsif i_rd_data = '1' then
                rdPntr <= std_logic_vector(unsigned(rdPntr) + 1);
            end if;
        end if;     
    end process;    

end rtl;
