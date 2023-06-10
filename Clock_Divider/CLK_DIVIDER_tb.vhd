----------------------------------------------------------------------------------
--  Test bench for CLK_DIVIDER module
----------------------------------------------------------------------------------

-- Library
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Entity with no ports
entity CLK_DIVIDER_tb is
end CLK_DIVIDER_tb;

-- Architecture
architecture Behavioral of CLK_DIVIDER_tb is

    -- Component declaration of UUT
    component CLK_DIVIDER port
        (
            SYS_CLK     :    in std_logic;
            SYS_RESET   :    in std_logic;
            CLK_25MHz   :    out std_logic;
            CLK_5MHz    :    out std_logic;
            CLK_1MHz    :    out std_logic;
            CLK_100KHz  :    out std_logic     
        );
    end component;
    
    -- Test bench signals
    signal  SYS_CLK_tb      :   std_logic;
    signal  SYS_RESET_tb    :   std_logic;
    signal  CLK_25MHz_tb    :   std_logic;
    signal  CLK_5MHz_tb     :   std_logic;
    signal  CLK_1MHz_tb     :   std_logic;
    signal  CLK_100KHz_tb   :   std_logic;
    
    -- constants
    constant    T:  time    :=  8ns; -- clock period
    
begin

    -- UUT instantiation
    UUT : CLK_DIVIDER
    port map (
                SYS_CLK     =>  SYS_CLK_tb,
                SYS_RESET   =>  SYS_RESET_tb,
                CLK_25MHz   =>  CLK_25MHz_tb,
                CLK_5MHz    =>  CLK_5MHz_tb,
                CLK_1MHz    =>  CLK_1MHz_tb,
                CLK_100KHz  =>  CLK_100KHz_tb   
             );
    
    -- SYS_CLK generation
    sync_proc : process
    begin
        SYS_CLK_tb <= '0';
        wait for T/2;   -- First half period
        SYS_CLK_tb <= '1';
        wait for T/2;   
    end process sync_proc;
    
    -- Stimulus
    stim_proc : process
    begin
        SYS_RESET_tb <= '1';
        wait for 2*T;
        SYS_RESET_tb <= '0';
        wait for 500*T;
    end process stim_proc;
    
end Behavioral;
