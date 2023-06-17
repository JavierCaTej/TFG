----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 13.06.2023 16:45:50
-- Design Name: 
-- Module Name: main - Behavioral
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
use work.SdCardPckg.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity main is
--  Port ( );
end main;

architecture Behavioral of main is

component SdCardCtrl is
generic (
  FREQ_G          : real       := 100.0;  -- Master clock frequency (MHz).
  INIT_SPI_FREQ_G : real       := 0.4;  -- Slow SPI clock freq. during initialization (MHz).
  SPI_FREQ_G      : real       := 25.0;  -- Operational SPI freq. to the SD card (MHz).
  BLOCK_SIZE_G    : natural    := 512;  -- Number of bytes in an SD card block or sector.
  CARD_TYPE_G     : CardType_t := SD_CARD_E  -- Type of SD card connected to this controller.
  );
port (
  -- Host-side interface signals.
  clk_i      : in  std_logic;       -- Master clock.
  reset_i    : in  std_logic                     := NO;  -- active-high, synchronous  reset.
  rd_i       : in  std_logic                     := NO;  -- active-high read block request.
  wr_i       : in  std_logic                     := NO;  -- active-high write block request.
  continue_i : in  std_logic                     := NO;  -- If true, inc address and continue R/W.
  addr_i     : in  std_logic_vector(31 downto 0) := x"00000000";  -- Block address.
  data_i     : in  std_logic_vector(7 downto 0)  := x"00";  -- Data to write to block.
  data_o     : out std_logic_vector(7 downto 0)  := x"00";  -- Data read from block.
  busy_o     : out std_logic;  -- High when controller is busy performing some operation.
  hndShk_i   : in  std_logic;  -- High when host has data to give or has taken data.
  hndShk_o   : out std_logic;  -- High when controller has taken data or has data to give.
  error_o    : out std_logic_vector(15 downto 0) := (others => NO);
  -- I/O signals to the external SD card.
  cs_bo      : out std_logic                     := HI;  -- Active-low chip-select.
  sclk_o     : out std_logic                     := LO;  -- Serial clock to SD card.
  mosi_o     : out std_logic                     := HI;  -- Serial data output to SD card.
  miso_i     : in  std_logic                     := ZERO  -- Serial data input from SD card.
  );
end component;



begin


end Behavioral;
