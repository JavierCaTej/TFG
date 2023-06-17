----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 17.06.2023 18:26:10
-- Design Name: 
-- Module Name: imageProcessorTop - rtl
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


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity imageProcessTop is
    port (
        axi_clk          : in  std_logic;                       -- Señal de reloj del bus AXI
        axi_reset_n      : in  std_logic;                       -- Señal de reinicio activa a la baja del bus AXI
        i_data_valid     : in  std_logic;                       -- Indica si los datos de entrada son validos
        i_data           : in  std_logic_vector(7 downto 0);    -- Datos de entrada (px de entrada)
        o_data_ready     : out std_logic;                       -- Indica que el diseño esta listo para recibir nuevos datos de salida 
        o_data_valid     : out std_logic;                       -- Indica que los datos de salida son validos
        o_data           : out std_logic_vector(7 downto 0);    -- Datos de salida (px de salida)
        i_data_ready     : in  std_logic;                       -- Indica que el diseño esta listo para recibir nuevos datos de entrada
        o_intr           : out std_logic                        -- Señal de interrupcion
    );
end entity imageProcessTop;

architecture rtl of imageProcessTop is
    signal pixel_data          : std_logic_vector(71 downto 0); -- Almacena los datos de 9px de la matriz
    signal pixel_data_valid    : std_logic;                     -- Indica si los datos de pixel_data son validos
    signal axis_prog_full      : std_logic;                     -- Indica si el bus AXI esta lleno y no puede aceptar mas datos
    signal convolved_data      : std_logic_vector(7 downto 0);  -- Almacena los datos convolucionados
    signal convolved_data_valid: std_logic;                     -- Indica si los datos convolucionados son validos
    
    component imageControl is
        port (
            i_clk               : in  std_logic;                        -- Señal de reloj
            i_rst               : in  std_logic;                        -- Señal de reset
            i_pixel_data        : in  std_logic_vector(7 downto 0);     -- Datos de entrada (px de entrada)
            i_pixel_data_valid  : in  std_logic;                        -- Indica si los datos de entrada son validos
            o_pixel_data        : out std_logic_vector(71 downto 0);    -- Datos de salida (9px de salida)
            o_pixel_data_valid  : out std_logic;                        -- Indica si los datos de salida son validos
            o_intr              : out std_logic                         -- Señal de interrupcion
        );
    end component imageControl;
    
    component conv is
        port (
            i_clk                 : in  std_logic;                      -- Señal de reloj
            i_pixel_data          : in  std_logic_vector(71 downto 0);  -- Datos de entrada (9px de entrada)
            i_pixel_data_valid    : in  std_logic;                      -- Indica si los datos de entrada son validos
            o_convolved_data      : out std_logic_vector(7 downto 0);   -- Datos de salida convolucionados (px de salida)
            o_convolved_data_valid: out std_logic                       -- Indica si los datos de salida son validos
        );
    end component conv;
    
    component outputBuffer is
        port (
            s_aclk            : in  std_logic;                      -- Señal de reloj del esclavo
            s_aresetn         : in  std_logic;                      -- Señal de reset de entrada del esclavo
            s_axis_tdata      : in  std_logic_vector(7 downto 0);   -- Datos de entrada de la interfaz esclavo
            s_axis_tvalid     : in  std_logic;                      -- Indica si los datos de entrada del esclavo son validos
            s_axis_tready     : out std_logic;                      -- Indica si los datos de entrada de la interfaz esclavo estan disponibles
            m_axis_tdata      : out std_logic_vector(7 downto 0);   -- Datos de salida de la interfaz maestro
            m_axis_tvalid     : out std_logic;                      -- Indica si los datos de salida del maestro son validos
            m_axis_tready     : in  std_logic;                      -- Indica si los datos de salida de la interfaz maestro estan disponibles
            axis_prog_full    : out std_logic;                      -- Indica si la interfaz esta llena de datos 
            wr_rst_busy       : out std_logic;                      -- Indica si la señal de reset de escritura ocupada
            rd_rst_busy       : out std_logic                       -- Indica si la señal de reset de lectura ocupada
        );
    end component outputBuffer;

    signal s_aresetn         : std_logic;
    signal s_axis_tready     : std_logic;
    signal m_axis_tdata      : std_logic_vector(7 downto 0);
    signal m_axis_tvalid     : std_logic;
    signal m_axis_tready     : std_logic;
    signal wr_rst_busy       : std_logic;
    signal rd_rst_busy       : std_logic;
    signal not_axi_reset_n       : std_logic;    -- not axi_reset_n
    
begin
    -- Cuando la interfaz esta llena de datos axis_prog_full = '1' -> La salida de datos es NO valida o_data_ready = '0' y viceversa
    o_data_ready <= not axis_prog_full;
    
    not_axi_reset_n <= not axi_reset_n;
    
    -- CONTROL DE IMAGEN
    IC : imageControl
    port map (
        i_clk               => axi_clk,
        i_rst               => not_axi_reset_n,
        i_pixel_data        => i_data,
        i_pixel_data_valid  => i_data_valid,
        o_pixel_data        => pixel_data,
        o_pixel_data_valid  => pixel_data_valid,
        o_intr              => o_intr
    );
    
    -- CONVOLUCION DE LA IMAGEN
    C : conv
    port map (
        i_clk                 => axi_clk,
        i_pixel_data          => pixel_data,
        i_pixel_data_valid    => pixel_data_valid,
        o_convolved_data      => convolved_data,
        o_convolved_data_valid=> convolved_data_valid
    );
    
    -- BUFFER DE SALIDA
    OB : outputBuffer
    port map (
        wr_rst_busy         => wr_rst_busy,
        rd_rst_busy         => rd_rst_busy,
        s_aclk              => axi_clk,
        s_aresetn           => axi_reset_n,
        s_axis_tvalid       => convolved_data_valid,
        s_axis_tready       => s_axis_tready,
        s_axis_tdata        => convolved_data,
        m_axis_tvalid       => m_axis_tvalid,
        m_axis_tready       => i_data_ready,
        m_axis_tdata        => m_axis_tdata,
        axis_prog_full      => axis_prog_full
    );
    
    -- PROPAGACION DE VALIDACIONES INTERNAS HACIA LA SALIDA
    o_data_valid <= m_axis_tvalid;  
    
    -- PROPAGACION DE DATOS INTERNOS HACIA LA SALIDA
    o_data <= m_axis_tdata;
    
end architecture rtl;

