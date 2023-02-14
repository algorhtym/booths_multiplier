library ieee;
use ieee.std_logic_1164.all;

-- updated to 4 bit but didn't change name

entity cntr_4bit is
    port (
        cnt_dec   : in std_logic;
        reset_bar : in std_logic;
        cnt_set : in std_logic;
        cnt_val : out std_logic_vector(3 downto 0);
        zero : out std_logic
    );
end entity;

architecture rtl of cntr_4bit is

    signal i_q : std_logic_vector(3 downto 0);
    signal i_q_bar : std_logic_vector(3 downto 0);

    signal i_cnt_set_bar : std_logic;

    signal i_zero : std_logic;
	 
	 signal i_reset : std_logic;
	 
	 signal i_zero_d : std_logic;
	 
	 --signal i_cnt_set_bar_d : std_logic;

    component dflipflop
        port(i_d, i_clk, i_set, i_rst: in STD_LOGIC; 
                o_q, o_qbar : inout STD_LOGIC);
    end component;

begin

    q0 : dflipflop port map (
        i_d => i_q_bar(0),
		i_clk => cnt_dec,
		i_set => i_cnt_set_bar,
		i_rst => '1',
		o_q => i_q(0),
		o_qbar => i_q_bar(0)
    );

    q1 : dflipflop port map (
        i_d => i_q_bar(1),
		i_clk => i_q(0),
		i_set => i_cnt_set_bar,
		i_rst => '1',
		o_q => i_q(1),
		o_qbar => i_q_bar(1)
    );

    q2 : dflipflop port map (
        i_d => i_q_bar(2),
		i_clk => i_q(1),
		i_set => i_cnt_set_bar,
		i_rst => '1',
		o_q => i_q(2),
		o_qbar => i_q_bar(2)
    );

    q3 : dflipflop port map (
        i_d => i_q_bar(3),
		i_clk => i_q(2),
		i_set => '1',
		i_rst => i_cnt_set_bar,
		o_q => i_q(3),
		o_qbar => i_q_bar(3)
    );
	 
	 z : dflipflop port map (
        i_d => i_zero,
		i_clk => i_q(3),
		i_set => '1',
		i_rst => i_cnt_set_bar,
		o_q => i_zero_d,
		o_qbar => open
    );
	 
	 


	 i_reset <= cnt_set or i_zero_d;
	 --i_reset <= cnt_set or i_zero;

    --i_cnt_set_bar <= not i_zero and (reset_bar and not cnt_set);
	 i_cnt_set_bar <= (reset_bar and not i_reset);
	 


    --i_zero <= (not i_q_bar(3) and not i_q_bar(2)) and (not i_q_bar(1) and not i_q_bar(0));
	 i_zero <= (not i_q(3) and not i_q(2)) and (not i_q(1) and not i_q(0));
    --i_zero <= (i_q(3) and not i_q(2)) and (not i_q(1) and not i_q(0));

    zero <= i_zero;
    cnt_val <= i_q;

end architecture;