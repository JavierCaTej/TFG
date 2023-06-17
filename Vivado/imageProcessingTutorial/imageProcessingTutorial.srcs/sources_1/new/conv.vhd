----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 15.06.2023 17:00:16
-- Design Name: 
-- Module Name: conv - rtl
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

entity conv is
  port ( 
    i_clk                   : in std_logic; -- Señal de reloj
    i_pixel_data            : in std_logic_vector(71 downto 0); -- 72bits para 9px  - Coje los px de alrededor
    i_pixel_data_valid      : in std_logic; -- Indica si el px es valido
    o_convolved_data        : out std_logic_vector(7 downto 0); -- Salida del px que se ha procesado
    o_convolved_data_valid  : out std_logic -- Indica si la convolución es valida
  );
end conv;

architecture rtl of conv is

    constant DATA_WIDTH : natural := 8;
    constant KERNEL_SIZE : natural := 9;
    type kernel_array is array(natural range <>) of std_logic_vector(DATA_WIDTH-1 downto 0);
    type mult_data_array is array(natural range <>) of unsigned(15 downto 0);   -- la multiplicacion puede tener un ancho de 16 bits - en este caso son 8 bits
    
    -- KERNEL   box blur
    --        | 1 1 1 |
    --  1/9 * | 1 1 1 |
    --        | 1 1 1 |

    signal kernel           : kernel_array(8 downto 0); -- 9px de 8bits por px
    signal multData         : mult_data_array(8 downto 0);  -- de 9 px 
    signal sumDataInt       : unsigned(15 downto 0);    -- Suma del valor de cada px convolucionado - puede tener un ancho de 16 bits   
    signal sumData          : unsigned(15 downto 0);    -- Suma del valor de cada px convolucionado - puede tener un ancho de 16 bits
    signal multDataValid    : std_logic;    -- Indica si la multiplicacion es valida
    signal sumDataValid     : std_logic;    -- Indica si la suma es valida
    signal convolved_data_valid : std_logic;    -- Indica si el dato convolucionado es valido
    
begin

    -- INICIALIZACION DE LA MATRIZ DEL KERNEL 
    inicializar_kernel : process
    begin
        for i in 0 to 8 loop
            kernel(i) <= x"01";
        end loop;
        wait;   -- evita el posible loop infinito al no tener process statement
    end process inicializar_kernel;

    --  MULTIPLICACION 
    calcular_mult : process (i_clk)
    begin
        if rising_edge(i_clk) then
            if i_pixel_data_valid = '1' then

                for i in 0 to 8 loop
                    -- Se multiplica cada elemento de la matriz por cada px (8 bits) de i_pixel_data -- Se va cogiendo px por px 7-0, 15-8,... 
                    multData(i) <= unsigned(kernel(i)) * unsigned(i_pixel_data(i*DATA_WIDTH+DATA_WIDTH-1 downto i*DATA_WIDTH));
                end loop;
                multDataValid <= i_pixel_data_valid;

            end if;
        end if;
    end process calcular_mult;

    -- SUMA
    calcular_suma : process
    begin
        sumDataInt <= (others => '0');
        for i in 0 to 8 loop
            -- Se suma todos los valores de la convolucion
            sumDataInt <= sumDataInt + multData(i);
        end loop;
        wait;
    end process calcular_suma;        

    -- SUMA SINCRONIZADA
    sincronizar_suma : process (i_clk)
    begin
        if rising_edge (i_clk) then
            sumData <= sumDataInt;
            sumDataValid <= multDataValid;
        end if;
    end process sincronizar_suma;
    
    -- OUTPUT DIVISION
    divide_output : process (i_clk)
    begin
        if rising_edge(i_clk) then
            o_convolved_data <= std_logic_vector(resize(sumData / to_unsigned(9, sumData'length), o_convolved_data'length));
            convolved_data_valid <= sumDataValid;
        end if;    
    end process divide_output;

    -- OUTPUT SIGNAL ASSIGNMENT
    -- o_convolved_data <= o_convolved_data(o_convolved_data'high downto o_convolved_data'low);
    o_convolved_data_valid <= convolved_data_valid;

end rtl;
