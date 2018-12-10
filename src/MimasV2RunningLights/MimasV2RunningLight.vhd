--------------------------------------------------------------------------------
-- Mimas V2 Running LED demo code
-- Numato Lab
-- http:--www.numato.com
-- http:--www.numato.cc
-- License : CC BY-SA (http:--creativecommons.org/licenses/by-sa/2.0/)
---------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MimasV2RunningLight is
     generic (      NumberOfDIPSwitch                              : INTEGER := 4;
                    NumberOfPushButtonSwitch                       : INTEGER := 7;
                    NumberOfLEDs                                   : INTEGER := 8;
                    NumberOfEachPortIOs                            : INTEGER := 8
                    );
            port (
         -- Assuming 100MHz input clock. My need to adjust the counter below
         -- if any other input frequency is used
                   CLK                                             : in std_logic;
						 RST_n                                           : in std_logic;
          
         -- Inputs from the switches to control the LEDs          
                   Switch                                          : in std_logic_vector(NumberOfPushButtonSwitch-1 downto 0);
  
         -- Output to the LEDs and IO Ports
                   LED                                             : out std_logic_vector(NumberOfLEDs-1 downto 0)
         );
end MimasV2RunningLight;

architecture rtl of MimasV2RunningLight is

-- Intermediate register used internally            
    signal count              : std_logic_vector(50 downto 0) := (others => '0');
    signal enable             : std_logic                     := '0';
	 signal counter 				: unsigned(7 downto 0);
begin

-- Scale down the the clock for the visible display.The DPSwitches are use to control it. 
process(CLK,RST_n)
  begin
    if rising_edge(CLK) then
      count <= std_logic_vector (unsigned(count) + 1);
      enable <= count(24);
    end if;
end process; 


process(enable,RST_n)
 variable LEDOut   : std_logic_vector(NumberOfLEDs-1 downto 0)  := x"00";
 begin
   if (RST_n = '0') then
	  LEDOut  := x"00";

   elsif rising_edge(enable) then 
		counter <= counter + 1;
		LEDOut := std_logic_vector(counter);
   end if;
	-- reverse the bits and display the LEDs
	-- Mimas2 board does not have the LEDs soldered
	-- in natural order. So, we need to reverse the display
	-- to show in natural order.
	--     LED <= LEDOut; -- this will not reverse the LEDs
	  LED(0) <= LEDOut(7);
	  LED(1) <= LEDOut(6);
	  LED(2) <= LEDOut(5);
	  LED(3) <= LEDOut(4);
	  LED(4) <= LEDOut(3);
	  LED(5) <= LEDOut(2);
	  LED(6) <= LEDOut(1);
	  LED(7) <= LEDOut(0);

end process;
end rtl;

