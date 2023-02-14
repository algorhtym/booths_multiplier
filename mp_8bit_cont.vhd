library ieee;
use ieee.std_logic_1164.all;

entity mp_8bit_cont is
    port (
        clk   : in std_logic;
        reset_bar : in std_logic;
        init_mult : in std_logic;
        cnt_zero : in std_logic;
        s_init, s0, s1, s2, s3 : out  std_logic;
        load_a, load_p, load_b : out std_logic;
        reset_a, reset_b, reset_p, set_cnt : out std_logic;
        cnt_dec, ashr_p : out std_logic;
        mult_done : out std_logic
    );
end entity;

architecture rtl of mp_8bit_cont is

    -- signal declarations
    signal i_cnt_zero : std_logic;
    signal i_s_init, i_s0, i_s1, i_s2, i_s3 : std_logic;
    signal i_load_a, i_load_p, i_load_b : std_logic;
    signal i_reset_a, i_reset_b, i_reset_p, i_set_cnt : std_logic;
    signal i_cnt_dec, i_ashr_p : std_logic;
    signal i_mult_done : std_logic; 

    signal i_s1_input : std_logic;
    signal i_s3_input : std_logic;

    -- component declarations

    component dflipflop is
        port(i_d, i_clk, i_set, i_rst: in STD_LOGIC; 
                o_q, o_qbar : inout STD_LOGIC);
    end component;


begin

    s_in : dflipflop port map (
        i_d => init_mult,
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_s_init,
		o_qbar => open
    );

    s_0 : dflipflop port map (
        i_d => i_s_init,
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_s0,
		o_qbar => open
    );

    s_1 : dflipflop port map (
        i_d => i_s1_input,
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_s1,
		o_qbar => open
    );

    s_2 : dflipflop port map (
        i_d => i_s1,
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_s2,
		o_qbar => open
    );

    s_3 : dflipflop port map (
        i_d => i_s3_input,
		i_clk => clk,
		i_set => '1',
		i_rst => reset_bar,
		o_q => i_s3,
		o_qbar => open
    );


    -- concurrent signal connections
    i_reset_a <= i_s_init;
    i_reset_b <= i_s_init;
    i_reset_p <= i_s_init or i_s0;
    i_set_cnt <= i_s0;

    i_load_a <= i_s0;
    i_load_b <= i_s0;
    i_load_p <= i_s1;

    i_cnt_dec <= i_s2;
    i_ashr_p <= i_s2;

    i_mult_done <= i_s3;
    i_cnt_zero <= cnt_zero;

    i_s1_input <= i_s0 or (i_s2 and not i_cnt_zero);
    i_s3_input <= i_mult_done or (i_s2 and i_cnt_zero);
    

    
    -- output driver

    s_init <= i_s_init;
    s0 <= i_s0;
    s1 <= i_s1;
    s2 <= i_s2;
    s3 <= i_s3;
    load_a <= i_load_a;
    load_b <= i_load_b;
    load_p <= i_load_p;
    reset_a <= i_reset_a;
    reset_b <= i_reset_b;
    reset_p <= i_reset_p;
    set_cnt <= i_set_cnt;
    cnt_dec <= i_cnt_dec;
    ashr_p <= i_ashr_p;
    mult_done <= i_mult_done;

end architecture;
