-------------------------------------------------------------------------
--Seven segment LED display demo code
--Numato Lab
--http://www.numato.com
--http://www.numato.cc
--License : CC BY-SA (http://creativecommons.org/licenses/by-sa/2.0/)
--------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MimasV2SevenSegmentDisplay is
   port ( 
   -- Assuming 100MHz input clock. My need to adjust the counter below
  -- if any other input frequency is used
   Clk              : in std_logic; 
   
	-- The input is from GPI and two GPI pin's of peripheral port P5 for the control of Seven Segment.
	DPSwitch         : in std_logic_vector(7 downto 0);
	Switch       : in std_logic_vector(5 downto 0);
	
  -- Seven segments of the display. The displays are multiplexed
  -- So we need only 7 common IOs for all displays
   SevenSegment     : out std_logic_vector (7 downto 0);
 
  -- Enable pins for each Seven Segment display module
   Enable           : out std_logic_vector(2 downto 0)                                          
    );

end MimasV2SevenSegmentDisplay;

-- Implementation:
-- The seven segment LED display uses multiplexed
-- topology to reduce the number of IOs required. In this topology,
-- each segment of a display is connected to the corresponding 
-- segments of all other displays. i.e., all 'a' segments connected 
-- together, all 'b' segments connected together and so on..
-- Each display has separate enable inputs that will turn a particular
-- display module on or off. This code enables each display module one
-- at a time and output the data to it. This keeps happening Indefinitely.
-- Though only one display is on at any given time, persistence of vision
-- causes it to look like all display are on at all times. 


architecture rtl of MimasV2SevenSegmentDisplay is
	
signal clk_i      : std_logic := '0';	 
signal counter    : std_logic_vector(27 downto 0) := (others => '0');
signal state      : std_logic_vector(1 downto 0)  := (others => '0');

signal bcd0        : integer := 0;
signal bcd1        : integer := 0;
signal bcd2        : integer := 0;

signal i          : integer := 0;
begin
-- Scale down clock to a lower frequency
process(Clk)
 begin
   if rising_edge(Clk) then
	   counter <= std_logic_vector (unsigned(counter) + 1); 
	   clk_i <= counter(18);
   end if;
end process;

process(clk_i)
 -- Variable's used for the intermediate purpose. 
  variable SevenSegment_O       : std_logic_vector (7 downto 0) := (others => '0');
  variable En                   : std_logic_vector(2 downto 0)  := B"110";
  variable addVal					  : integer := 1;
  variable val						  : integer := 0;
  variable temp					  : integer := 0;
   begin
    if rising_edge(clk_i) then
	 addVal := to_integer(signed(DPSwitch));
	 -- Each Seven Segment display is activated by passing active-low signal to enable pin(Common Anode Configured).
     En := En(1 downto 0) & En(2);                             
	-- Increment the value to be displayed.
	if (Switch(1)='0') then
		val := 0;
		bcd0 <= 0;
		bcd1 <= 0;
		bcd2 <= 0;
	end if;	

	if (Switch(0)='0') then
	 if (i = 20) then 
			val := val + addVal;
			i <= 0; 
	 else
		-- Once the value is reached reload the count. 
		bcd0 <= val mod 10;
		bcd1 <= (val / 10) mod 10;
		bcd2 <= val / 100;	
	   i <= i + 1;
     end if;
   end if;
  -- This module uses Common Anode configuration. Each display module is enabled one at a time
  -- and corresponding segment data is output. 

			--        a    
			--      ____
			--   f |    | b
			--     |_g__| 
			--   e |    | c
			--     |____| .h
			--       d
		   
--	if (DPSwitch /= x"FF") then
--	
--	-- Dip Switch takes the priority over the count. When a particular Dip Switch is ON, the number of the DIP Switch is
--   --	displayed on the Seven Segment.
--	
--	  case DPSwitch is                  -- 	   abcdefgh
--	     when "01111111"  => SevenSegment_o := B"10011111";
--		  when "10111111"  => SevenSegment_o := B"00100101";
--		  when "11011111"  => SevenSegment_o := B"00001101";
--		  when "11101111"  => SevenSegment_o := B"10011001";
--		  when "11110111"  => SevenSegment_o := B"01001001";
--		  when "11111011"  => SevenSegment_o := B"01000001";
--		  when "11111101"  => SevenSegment_o := B"00011111";
--		  when "11111110"  => SevenSegment_o := B"00000001";
--		  when others      => null;
--	  end case;
--	  
--	else
--		if (En = "110") then
--			if (Switch(0)='0') then
--				SevenSegment_o := B"00000011";
--			elsif (Switch(1)='0') then
--				SevenSegment_o := B"10011111";
--			elsif (Switch(2)='0') then
--				SevenSegment_o := B"00001101";
--			else
--				SevenSegment_o := B"00000011";
--			end if;
--		elsif (En = "101") then
--			if (Switch(0)='0') then
--				SevenSegment_o := B"00001101";
--			elsif (Switch(1)='0') then
--				SevenSegment_o := B"10011001";
--			elsif (Switch(2)='0') then
--				SevenSegment_o := B"01001001";
--			else
--				SevenSegment_o := B"00000011";
--			end if;
--		elsif (En = "011") then
--			if (Switch(0)='0') then
--				SevenSegment_o := B"01000001";
--			elsif (Switch(1)='0') then
--				SevenSegment_o := B"00011111";
--			elsif (Switch(2)='0') then
--				SevenSegment_o := B"00000000";
--			else
--				SevenSegment_o := B"00000011";
--			end if;
--		end if;		
	-- If all the DIP Switches are OFF the the count contionous and that value is displayed.
	   if (En = "110") then
		  case bcd0 is
			  when 0      => SevenSegment_o := B"00000011";
			  when 1      => SevenSegment_o := B"10011111";
			  when 2      => SevenSegment_o := B"00100101";
			  when 3      => SevenSegment_o := B"00001101";
			  when 4      => SevenSegment_o := B"10011001";
			  when 5      => SevenSegment_o := B"01001001";
			  when 6      => SevenSegment_o := B"01000001";
			  when 7      => SevenSegment_o := B"00011111";
			  when 8      => SevenSegment_o := B"00000001";
			  when 9      => SevenSegment_o := B"00011001";
			  when others => SevenSegment_o := B"11111111";
		  end case;
		elsif (En = "101") then
		  case bcd1 is
			  when 0      => SevenSegment_o := B"00000011";
			  when 1      => SevenSegment_o := B"10011111";
			  when 2      => SevenSegment_o := B"00100101";
			  when 3      => SevenSegment_o := B"00001101";
			  when 4      => SevenSegment_o := B"10011001";
			  when 5      => SevenSegment_o := B"01001001";
			  when 6      => SevenSegment_o := B"01000001";
			  when 7      => SevenSegment_o := B"00011111";
			  when 8      => SevenSegment_o := B"00000001";
			  when 9      => SevenSegment_o := B"00011001";
			  when others => SevenSegment_o := B"11111111";
		  end case;
		elsif (En = "011") then
		  case bcd2 is
			  when 0      => SevenSegment_o := B"00000011";
			  when 1      => SevenSegment_o := B"10011111";
			  when 2      => SevenSegment_o := B"00100101";
			  when 3      => SevenSegment_o := B"00001101";
			  when 4      => SevenSegment_o := B"10011001";
			  when 5      => SevenSegment_o := B"01001001";
			  when 6      => SevenSegment_o := B"01000001";
			  when 7      => SevenSegment_o := B"00011111";
			  when 8      => SevenSegment_o := B"00000001";
			  when 9      => SevenSegment_o := B"00011001";
			  when others => SevenSegment_o := B"11111111";
		  end case;
	   end if;
--	end if;

-- Latch the value to the output PINs.
  SevenSegment <= SevenSegment_o;
  Enable       <= En;
  
 end if;
end process;
end rtl;