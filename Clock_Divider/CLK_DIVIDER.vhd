----------------------------------------------------------------------------------
-- 
-- Designer : Kishore Bachu
-- Date: 10-June-2023
-- Title: Clock Divider module
-- 
-- Inputs: SYS_CLK, SYS_RESET
-- Outputs: CLK_25MHz, CLK_5MHz
-- Parent : CLK_DIVIDER.vhd
-- Child : None
--
----------------------------------------------------------------------------------

-- Library
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.STD_LOGIC_UNSIGNED.all;

-- Entity
entity CLK_DIVIDER is
    port (
            SYS_CLK     :   in std_logic;       -- System Clock, 125MHz on PYNQ-Z2
            SYS_RESET   :   in std_logic;       -- Active High Reset
            CLK_25MHz   :   out std_logic;      -- Output Clock, 25Mhz
            CLK_5MHz    :   out std_logic;      -- Output Clock, 5Mhz
            CLK_1MHz    :   out std_logic;      -- Output Clock, 1Mhz
            CLK_100KHz  :   out std_logic       -- Output Clock, 100KHz
         );
end CLK_DIVIDER;

-- Architecture
architecture Behavioral of CLK_DIVIDER is

    -- internal signals
    signal slow_clk_counter1   :   std_logic_vector(3 downto 0);
    signal slow_clk_counter2   :   std_logic_vector(7 downto 0);
    signal slow_clk_counter3   :   std_logic_vector(11 downto 0);
    signal slow_clk_counter4   :   std_logic_vector(15 downto 0);
    signal CLK_100MHz_buf      :   std_logic;
    signal CLK_25MHz_buf       :   std_logic;
    signal CLK_5MHz_buf        :   std_logic;
    signal CLK_1MHz_buf        :   std_logic;
    signal CLK_100KHz_buf      :   std_logic;
    
    -- Constants for calculating the desired frequencyn clocks:
    -- clk_divider = (SYS_CLK / desired freq. * duty cycle) 
    -- clk_divider for 25MHz = (125MHz / 25MHz * 50%) = 2.5
    -- clk_divider for 5MHz = (125MHz / 5MHz * 50%) = 12.5
    -- clk_divider for 1MHz = (125MHz / 1MHz * 50%) = 62.5
    -- clk_divider for 100KHz = (1MHz / 100KHz * 50%) = 5
    
    constant clk_Div_25MHz     :   integer   := 2;
    constant clk_Div_5MHz      :   integer   := 12;
    constant clk_Div_1MHz      :   integer   := 62;
    constant clk_Div_100KHz    :   integer   := 5;
    
begin
    
    -- Process block for 25MHz clock
    sync_25Mhz: process (SYS_CLK, SYS_RESET)
    begin
        if (rising_edge(SYS_CLK)) then
            if(SYS_RESET = '1') then
                slow_clk_counter1 <= x"0";
                CLK_25MHz_buf <= '0';
            elsif (slow_clk_counter1 < 2*clk_Div_25MHz) then  -- Increment slow_clk_counter1 for 4 clock cycles
                slow_clk_counter1 <= slow_clk_counter1 + 1; 
            else
                slow_clk_counter1 <= x"0"; 
            end if; 
                              
            if (slow_clk_counter1 < clk_Div_25MHz) then
                CLK_25MHz_buf <= '0';
            else
                CLK_25MHz_buf <= '1';
            end if; 
        end if;          
    end process sync_25Mhz;

    -- Process block for 5MHz clock
    sync_5Mhz: process (SYS_CLK, SYS_RESET)
    begin
        if (rising_edge(SYS_CLK)) then
            if(SYS_RESET = '1') then
                slow_clk_counter2 <= x"00";
                CLK_5MHz_buf <= '0';
            elsif (slow_clk_counter2 < 2*clk_Div_5MHz) then  -- Increment slow_clk_counter2 for 24 clock cycles
                slow_clk_counter2 <= slow_clk_counter2 + 1; 
            else
                slow_clk_counter2 <= x"00"; 
            end if; 
                              
            if (slow_clk_counter2 < clk_Div_5MHz) then
                CLK_5MHz_buf <= '0';
            else
                CLK_5MHz_buf <= '1';
            end if; 
        end if;          
    end process sync_5Mhz;
 
    -- Process block for 1MHz clock
    sync_1Mhz: process (SYS_CLK, SYS_RESET)
    begin
        if (rising_edge(SYS_CLK)) then
            if(SYS_RESET = '1') then
                slow_clk_counter3 <= x"000";
                CLK_1MHz_buf <= '0';
            elsif (slow_clk_counter3 < 2*clk_Div_1MHz) then  -- Increment slow_clk_counter3 for 125 clock cycles
                slow_clk_counter3 <= slow_clk_counter3 + 1; 
            else
                slow_clk_counter3 <= x"000"; 
            end if; 
                              
            if (slow_clk_counter3 < clk_Div_1MHz) then
                CLK_1MHz_buf <= '0';
            else
                CLK_1MHz_buf <= '1';
            end if; 
        end if;          
    end process sync_1Mhz;

    -- Process block for 100KHz clock
    -- 100KHz clock is generated from 1MHz
    sync_100Khz: process (CLK_1MHz_buf, SYS_RESET)
    begin
        if (rising_edge(CLK_1MHz_buf)) then
            if(SYS_RESET = '1') then
                slow_clk_counter4 <= x"0000";
                CLK_100KHz_buf <= '0';
            elsif (slow_clk_counter4 < 2*clk_Div_100KHz) then  -- Increment slow_clk_counter4 for 10 1Mhz clock cycles
                slow_clk_counter4 <= slow_clk_counter4 + 1; 
            else
                slow_clk_counter4 <= x"0000"; 
            end if; 
                              
            if (slow_clk_counter4 < clk_Div_100KHz) then
                CLK_100KHz_buf <= '0';
            else
                CLK_100KHz_buf <= '1';
            end if; 
        end if;          
    end process sync_100Khz;
            
    -- Assign clock buffers to output clock signals
    CLK_25MHz   <= CLK_25MHz_buf;
    CLK_5MHz    <= CLK_5MHz_buf;
    CLK_1MHz    <= CLK_1MHz_buf;
    CLK_100KHz  <= CLK_100KHz_buf;
    
end Behavioral;
