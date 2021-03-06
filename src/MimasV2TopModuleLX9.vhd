------------------------------------------------------------------------
-- Mimas V2 demo code
-- Numato Lab
-- http://www.numato.com
-- http://www.numato.cc
-- License : CC BY-SA (http://creativecommons.org/licenses/by-sa/2.0/)
------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity MimasV2TopModuleLX9 is
  GENERIC (          BoardDescription                               : STRING   := "NUMATO LAB Mimas V2";
                     DeviceDescripition                             : STRING   := "SPARTAN6 LX9";
                     ClockFrequency                                 : INTEGER  := 100_000_000;
                     NumberOfDIPSwitch                              : INTEGER  := 8;
                     NumberOfPushButtonSwitch                       : INTEGER  := 6;
                     NumberOfLEDs                                   : INTEGER  := 8;
                     NumberOfEachPortIOs                            : INTEGER  := 8;
                     VGAResolution                                  : STRING   := "640x480 @ 60Hz";
                     NumberOfVGAColor                               : INTEGER  := 3;                 
                     NumberOfSevenSegmentModule                     : INTEGER  := 3;
                     SevenSegmentLED                                : INTEGER  := 8
                );
  PORT ( -- Input's
            -- Assuming 100MHz input clock and active Low reset.
                     CLK                                            : IN   STD_LOGIC;
							RST_n                                          : IN   STD_LOGIC;
             -- Dip Switches and Switches.
                     DPSwitch                                       : IN   STD_LOGIC_VECTOR(NumberOfDIPSwitch-1 downto 0);
                     Switch                                         : IN   STD_LOGIC_VECTOR(NumberOfPushButtonSwitch-1 downto 0);
            -- Output's
              -- VGA Display
                     HSync                                          : OUT   STD_LOGIC;
                     VSync                                          : OUT   STD_LOGIC;
                     Red                                            : OUT   STD_LOGIC_VECTOR(NumberOfVGAColor-1 downto 0);
                     Green                                          : OUT   STD_LOGIC_VECTOR(NumberOfVGAColor-1 downto 0);
                     Blue                                           : OUT   STD_LOGIC_VECTOR(NumberOfVGAColor-1 downto 1);
              -- Audio
                     Audio1                                         : OUT   STD_LOGIC;
                     Audio2                                         : OUT   STD_LOGIC;
              -- 7 Segment Display
                     SevenSegment                                   : OUT   STD_LOGIC_VECTOR(SevenSegmentLED-1 downto 0);
                     SevenSegmentEnable                             : OUT   STD_LOGIC_VECTOR(NumberOfSevenSegmentModule-1 downto 0); 
              -- LED
                     LED                                            : INOUT STD_LOGIC_VECTOR(7 downto 0);
              -- Ports
                     IO_P6                                          : OUT   STD_LOGIC_VECTOR(NumberOfEachPortIOs-1 downto 0);
                     IO_P7                                          : OUT   STD_LOGIC_VECTOR(NumberOfEachPortIOs-1 downto 0);
							IO_P8                                          : OUT   STD_LOGIC_VECTOR(NumberOfEachPortIOs-1 downto 0);
                     IO_P9                                          : OUT   STD_LOGIC_VECTOR(NumberOfEachPortIOs-1 downto 0)
          );

end MimasV2TopModuleLX9;

architecture Behavioral of MimasV2TopModuleLX9 is

 component clocking
   port    (  --Input clock 100 MHz
                     CLK_IN                                          : in std_logic;
                --Output
                     CLK_100MHz                                      : out std_logic;
                     CLK_50MHz                                       : out std_logic);
 end component;
 

 
 
 component MimasV2SevenSegmentDisplay
    port    ( -- Input Clk 100 MHz
                                 Clk          : in std_logic;
											-- Input from Dip Switches and two GPI's for P5 Header two control the Seven Segment
											DPSwitch     : in std_logic_vector(7 downto 0);
											Switch       : in std_logic_vector(NumberOfPushButtonSwitch-1 downto 0);
                                  -- Output fot Seven Segment Display
							            SevenSegment : out std_logic_vector(7 downto 0);
                                 Enable       : out std_logic_vector(2 downto 0);
											LED			 : out std_logic_vector(7 downto 0)
                                );
 end component;

 

	 signal  CLK_100MHz                                              : std_logic := '0';
	 signal  CLK_50MHz                                               : std_logic := '0';
begin

    clocking_Instant            : clocking
                                   port map (CLK_IN                                         => CLK,
                                             CLK_100MHz                                     => CLK_100MHz,
                                             CLK_50MHz                                      => CLK_50MHz);
															 										 
    					  
   SevenSegmentDisplay_instant : MimasV2SevenSegmentDisplay
                                  port map   (CLK                                            => CLK_100MHz,
                                              DPSwitch                                       => DPSwitch,
															 Switch														=> Switch,
                                              SevenSegment                                   => SevenSegment,
                                              Enable                                         => SevenSegmentEnable,
															 LED                                         	=> LED);

    
 

        IO_P6 <= LED;
        IO_P7 <= LED;
        IO_P8 <= LED;
        IO_P9 <= LED;


end Behavioral;

