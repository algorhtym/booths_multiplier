library ieee;
use ieee.std_logic_1164.all;

entity pulse_detect is
    port (
        clk   : in std_logic;
        pulse_in : in std_logic;
        pulse_out : out std_logic
    );
end entity;

architecture rtl of pulse_detect is
    signal a, b, c : std_logic;

    component dflipflop is
        port(i_d, i_clk, i_set, i_rst: in STD_LOGIC; 
                o_q, o_qbar : inout STD_LOGIC);
    end component;

begin
    
    dff1 : dflipflop port map (
        i_d => pulse_in,
		i_clk => clk,
		i_set => '1',
		i_rst => '1',
		o_q => a,
		o_qbar => open
    );

    dff2 : dflipflop port map (
        i_d => a,
		i_clk => clk,
		i_set => '1',
		i_rst => '1',
		o_q => open,
		o_qbar => b
    );

    c <= a nand b;

    pulse_out <= c;

end architecture;