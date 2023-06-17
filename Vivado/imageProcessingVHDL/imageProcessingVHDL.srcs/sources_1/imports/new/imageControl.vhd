----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.06.2023 15:17:19
-- Design Name: 
-- Module Name: imageControl - rtl
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

entity imageControl is
  port ( 
        i_clk                  : in std_logic;                      -- Señal de reloj
        i_rst                  : in std_logic;                      -- Señal de reset
        i_pixel_data           : in std_logic_vector(7 downto 0);   -- Datos del px de entrada
        i_pixel_data_valid     : in std_logic;                      -- Indica si los datos del px de entrada son validos
        o_pixel_data           : out std_logic_vector(71 downto 0); -- Datos de los 9 pxs de salida - 9*8bits = 72bits
        o_pixel_data_valid     : out std_logic;                     -- Indica si los datos de salida estan listos 
        o_intr                 : out std_logic                      -- Señal de interrupcion que indica si se ha completado el procesamiento de una linea completa
  );
end imageControl;

architecture rtl of imageControl is

    -- type line_buffer_array is array (0 to 3) of std_logic_vector(23 downto 0);
    type RdStateType is (IDLE, RD_BUFFER);  -- Estados de espera o de lectura
    
    signal pixelCounter          : unsigned(8 downto 0);            -- Contador de px, indica la llegada de un nuevo px - 2^9 = 512 a la hora de acabar una linea 511 se incrementa y vuelve el valor a 0
    signal currentWrLineBuffer   : unsigned(1 downto 0);            -- Indica la posicion actual del buffer de linea de escritura - 3 de ancho en la "matriz"
    signal lineBuffDataValid     : std_logic_vector(3 downto 0);    -- Indica que buffers de linea tienen datos validos
    signal lineBuffRdData        : std_logic_vector(3 downto 0);    -- Indica que datos leer de los buffers de linea especifico
    signal currentRdLineBuffer   : unsigned(1 downto 0);            -- Indica la posicion actual del buffer de linea de lectura
    signal lb0data               : std_logic_vector(23 downto 0);   -- Almacenan los datos de los buffers de linea correspondientes
    signal lb1data               : std_logic_vector(23 downto 0);   -- Almacenan los datos de los buffers de linea correspondientes
    signal lb2data               : std_logic_vector(23 downto 0);   -- Almacenan los datos de los buffers de linea correspondientes
    signal lb3data               : std_logic_vector(23 downto 0);   -- Almacenan los datos de los buffers de linea correspondientes
    signal rdCounter             : unsigned(8 downto 0);            -- Contador durante la etapa de lectura 
    signal rd_line_buffer        : std_logic;                       -- Indica si se esta leyendo del buffer de linea
    signal totalPixelCounter     : unsigned(11 downto 0);           -- Contador global de px 
    signal rdState               : RdStateType;                     -- Indica el estado actual de la maquina de estados, espera IDLE y lectura del buffer RD_BUFFER

    -- constant IDLE    : std_logic_vector(1 downto 0) := "00";        -- Estado en espera
    -- constant RD_BUFFER : std_logic_vector(1 downto 0) := "01";      -- Estado de lectura del buffer

begin

    o_pixel_data_valid <= rd_line_buffer;

    -- ACTUALIZAR totalPixelCounter
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if i_rst = '1' then
                totalPixelCounter <= (others => '0');
            else
                -- Hay un nuevo px valido y no se esta leyendo buffer
                if i_pixel_data_valid = '1' and rd_line_buffer = '0' then       
                    totalPixelCounter <= totalPixelCounter + 1;
                -- No hay nuevo px valido y se esta leyendo buffer
                elsif i_pixel_data_valid = '0' and rd_line_buffer = '1' then
                    totalPixelCounter <= totalPixelCounter - 1;
                end if;
            end if;
        end if;
    end process;

    -- CONTROL DE ESTADO DEL BUFFER DE LINEA
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if i_rst = '1' then
                rdState <= IDLE;
                rd_line_buffer <= '0';
                o_intr <= '0';
            else
                case rdState is
                    -- ESTADO ESPERA
                    when IDLE =>
                        o_intr <= '0';
                        -- Al llegar a 3*512 = 1536 se ha alcanzado el limite de px necesarios -> Estado lectura
                        if totalPixelCounter >= 1536 then
                            rd_line_buffer <= '1';
                            rdState <= RD_BUFFER;
                        end if;
                    -- ESTADO LECTURA
                    when RD_BUFFER =>
                        -- Se lee una linea completa 512 px -> Estado espera
                        if rdCounter = 511 then
                            rdState <= IDLE;    
                            rd_line_buffer <= '0';
                            o_intr <= '1';
                        end if;
                end case;
            end if;
        end if;
    end process;
    
    -- CONTADOR de px
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if i_rst = '1' then
                pixelCounter <= (others => '0');
            else
                -- Si hay datos de px validos presentes
                if i_pixel_data_valid = '1' then
                    pixelCounter <= pixelCounter + 1;
                end if;
            end if;
        end if;
    end process;

    -- CONTROLAR INDICE DEL BUFFER DE LINEA DE ESCRITURA
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if i_rst = '1' then
                currentWrLineBuffer <= (others => '0');
            else
                -- Se ha recibido el ultimo px de una linea y se pasa al siguiente buffer de linea
                if pixelCounter = 511 and i_pixel_data_valid = '1' then
                    currentWrLineBuffer <= currentWrLineBuffer + 1;
                end if;
            end if;
        end if;
    end process;

    -- CONTADOR DE LECTURAS 
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if i_rst = '1' then
                rdCounter <= (others => '0');
            else
                -- Cuenta los ciclos de reloj en los que la lectura esta activa
                if rd_line_buffer = '1' then
                    rdCounter <= rdCounter + 1;
                end if;
            end if;
        end if;
    end process;

    -- ACTUALIZAR CURSOR DE BUFFER DE LINEA DE SALIDA
    process(i_clk)
    begin
        if rising_edge(i_clk) then
            if i_rst = '1' then
                currentRdLineBuffer <= (others => '0');
            else
                -- Si se han leido los 512px de la linea y se esta leyendo el buffer de linea
                if rdCounter = 511 and rd_line_buffer = '1' then
                    -- Se selecciona el siguiente buffer de linea
                    currentRdLineBuffer <= currentRdLineBuffer + 1;
                end if;
            end if;
        end if;
    end process;

    -- SELECCION DE LOS DATOS DE LOS BUFFERS DE LECTURA
    process(currentRdLineBuffer, lb0data, lb1data, lb2data, lb3data)
    begin
        case currentRdLineBuffer is
            when "00" =>
                o_pixel_data <= lb2data & lb1data & lb0data;
            when "01" =>
                o_pixel_data <= lb3data & lb2data & lb1data;
            when "10" =>
                o_pixel_data <= lb0data & lb3data & lb2data;
            when "11" =>
                o_pixel_data <= lb1data & lb0data & lb3data;
        end case;
    end process;
    
    -- ASIGNAR VALORES AL BUFFER DE LINEA DE LECTURA
    process(currentRdLineBuffer, rd_line_buffer)
    begin
        case currentRdLineBuffer is
            when "00" =>
                lineBuffRdData(0) <= rd_line_buffer;
                lineBuffRdData(1) <= rd_line_buffer;
                lineBuffRdData(2) <= rd_line_buffer;
                lineBuffRdData(3) <= '0';
            when "01" =>
                lineBuffRdData(0) <= '0';
                lineBuffRdData(1) <= rd_line_buffer;
                lineBuffRdData(2) <= rd_line_buffer;
                lineBuffRdData(3) <= rd_line_buffer;
            when "10" =>
                lineBuffRdData(0) <= rd_line_buffer;
                lineBuffRdData(1) <= '0';
                lineBuffRdData(2) <= rd_line_buffer;
                lineBuffRdData(3) <= rd_line_buffer;
            when "11" =>
                lineBuffRdData(0) <= rd_line_buffer;
                lineBuffRdData(1) <= rd_line_buffer;
                lineBuffRdData(2) <= '0';
                lineBuffRdData(3) <= rd_line_buffer;
        end case;
    end process;


    -- BUFFERS DE LINEA
    lB0 : entity work.lineBuffer
        port map (
            i_clk          => i_clk,
            i_rst          => i_rst,
            i_data         => i_pixel_data,
            i_data_valid   => lineBuffDataValid(0),
            o_data         => lb0data,
            i_rd_data      => lineBuffRdData(0)
        );

    lB1 : entity work.lineBuffer
        port map (
            i_clk          => i_clk,
            i_rst          => i_rst,
            i_data         => i_pixel_data,
            i_data_valid   => lineBuffDataValid(1),
            o_data         => lb1data,
            i_rd_data      => lineBuffRdData(1)
        );

    lB2 : entity work.lineBuffer
        port map (
            i_clk          => i_clk,
            i_rst          => i_rst,
            i_data         => i_pixel_data,
            i_data_valid   => lineBuffDataValid(2),
            o_data         => lb2data,
            i_rd_data      => lineBuffRdData(2)
        );

    lB3 : entity work.lineBuffer
        port map (
            i_clk          => i_clk,
            i_rst          => i_rst,
            i_data         => i_pixel_data,
            i_data_valid   => lineBuffDataValid(3),
            o_data         => lb3data,
            i_rd_data      => lineBuffRdData(3)
        );




end rtl;
