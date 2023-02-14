library ieee;
use ieee.std_logic_1164.all;

entity mp_8bit is 
    port (
        A, B : in std_logic_vector(7 downto 0);
        G_reset : in std_logic;
        init_mult : in std_logic;
        G_clk : in std_logic;
        mult_done, o_f : out std_logic;
        counter : out std_logic_vector(3 downto 0);
        states : out std_logic_vector(4 downto 0);
        result : out std_logic_vector(15 downto 0)
        );
end mp_8bit;

architecture rtl of mp_8bit is
    -- signal declarations

    -- ashr_17 signals:
    signal i_load_b_bar, i_load_p_bar : std_logic;
    signal i_reset_p_bar, i_reset_b_bar : std_logic;
    signal i_ashr_bar : std_logic;
    signal i_p_in, i_p_out, i_b_in, i_b_out : std_logic_vector(7 downto 0);
    signal i_bn1 : std_logic;
    signal i_ALU_en_bar, i_add_bar_sub : std_logic;


    -- controller signals
    signal i_init_mult : std_logic;
    signal i_cnt_zero : std_logic;
    signal i_s_init, i_s0, i_s1, i_s2, i_s3 : std_logic;
    signal i_load_a, i_load_p, i_load_b : std_logic;
    signal i_reset_a, i_reset_b, i_reset_p, i_set_cnt : std_logic;
    signal i_cnt_dec, i_ashr_p : std_logic;
    signal i_mult_done : std_logic; 


    -- adder signals

    signal i_x, i_y, i_s : std_logic_vector(7 downto 0);
    -- add_bar_sub above in ashr17
    signal i_of : std_logic;


    -- reg 8 bit signals
    signal i_reset_a_bar : std_logic;
    signal i_load_a_bar : std_logic; -- connect to i_load_a(done)
    -- signal A_in comes from input already
    signal i_A_out : std_logic_vector(7 downto 0);

    -- cntr signals
    -- i_cnt_dec covered
    -- i_cnt_set covered as i_set_cnt
    -- i_cnt_zero covered in controller signals
    signal i_cnt_val : std_logic_vector(3 downto 0);

    signal i_states : std_logic_vector(4 downto 0);
	 
	 -- result signal declaration (for concatenation of p_out and b_out
	 signal i_result : std_logic_vector(15 downto 0);




    -- component declarations

    component mp_8bit_cont
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
    end component;

    component adder_8bit 
        port ( 
            add_sub_cont : in std_logic;
            x : in std_logic_vector(7 downto 0);
            y : in std_logic_vector(7 downto 0);
            s : out std_logic_vector(7 downto 0);
            c_n : out std_logic;
            o_f : out std_logic
            );
    end component;

    component ashr_17bit
        port (
            clk   : in std_logic;
            load_p_bar, load_b_bar : in std_logic;
            reset_p_bar, reset_b_bar : in std_logic;
            ashr_bar : in std_logic;
            P_in, B_in : in std_logic_vector(7 downto 0);
            P_out, B_out: out std_logic_vector(7 downto 0);
            Bn1 : out std_logic;
            ALU_en_bar, add_bar_sub : out std_logic 
        );
    end component;

    component reg_8bit
        port (
            reset_bar, load_bar : in std_logic;
            clk : in std_logic;
            data_in : in std_logic_vector(7 downto 0);
            data_out : out std_logic_vector(7 downto 0)
        );
    end component;

    component cntr_4bit is
        port (
            cnt_dec   : in std_logic;
            reset_bar : in std_logic;
            cnt_set : in std_logic;
            cnt_val : out std_logic_vector(3 downto 0);
            zero : out std_logic
        );
    end component;


begin
    -- define components and port connections
    asr17 : ashr_17bit port map (
        clk => G_clk,
        load_p_bar => i_load_p_bar, load_b_bar => i_load_b_bar,
        reset_p_bar => i_reset_p_bar, reset_b_bar => i_reset_b_bar,
        ashr_bar => i_ashr_bar,
        P_in => i_p_in, B_in => i_b_in,
        P_out => i_p_out, B_out => i_b_out,
        Bn1 => i_bn1,
        ALU_en_bar => i_ALU_en_bar, add_bar_sub => i_add_bar_sub 
    );

    regA : reg_8bit port map (
        reset_bar => i_reset_a_bar, load_bar => i_load_a_bar,
        clk => G_clk,
        data_in => A,
        data_out => i_A_out
    );

    alu : adder_8bit port map (
        add_sub_cont => i_add_bar_sub,
        x => i_x,
        y => i_y,
        s => i_s,
        c_n => open,
        o_f => i_of
    );

    cntr : cntr_4bit port map (
        cnt_dec => i_cnt_dec,
        reset_bar => G_reset,
        cnt_set => i_set_cnt,
        cnt_val => i_cnt_val,
        zero => i_cnt_zero
    );

    asm_cont : mp_8bit_cont port map (
        clk => G_clk,
        reset_bar => G_reset,
        init_mult => i_init_mult,
        cnt_zero => i_cnt_zero,
        s_init => i_states(4), s0 => i_states(3), s1 => i_states(2), s2 => i_states(1), s3 => i_states(0),
        load_a => i_load_a, load_p => i_load_p, load_b => i_load_b,
        reset_a => i_reset_a, reset_b => i_reset_b, reset_p => i_reset_p, set_cnt => i_set_cnt,
        cnt_dec => i_cnt_dec, ashr_p => i_ashr_p,
        mult_done => i_mult_done
    );
    

    -- concurrent signal connections

    i_init_mult <= init_mult;

    i_x <= i_p_out;
    i_y <= i_A_out;

    i_p_in(7) <= (i_s(7) and not i_ALU_en_bar) or (i_p_out(7) and i_ALU_en_bar);
    i_p_in(6) <= (i_s(6) and not i_ALU_en_bar) or (i_p_out(6) and i_ALU_en_bar);
    i_p_in(5) <= (i_s(5) and not i_ALU_en_bar) or (i_p_out(5) and i_ALU_en_bar);
    i_p_in(4) <= (i_s(4) and not i_ALU_en_bar) or (i_p_out(4) and i_ALU_en_bar);
    i_p_in(3) <= (i_s(3) and not i_ALU_en_bar) or (i_p_out(3) and i_ALU_en_bar);
    i_p_in(2) <= (i_s(2) and not i_ALU_en_bar) or (i_p_out(2) and i_ALU_en_bar);
    i_p_in(1) <= (i_s(1) and not i_ALU_en_bar) or (i_p_out(1) and i_ALU_en_bar);
    i_p_in(0) <= (i_s(0) and not i_ALU_en_bar) or (i_p_out(0) and i_ALU_en_bar);

    i_b_in <= B;




    i_load_a_bar <= not i_load_a;
    i_load_b_bar <= not i_load_b;
    i_load_p_bar <= not i_load_p;

    i_reset_a_bar <= not i_reset_a;
    i_reset_b_bar <= not i_reset_b;
    i_reset_p_bar <= not i_reset_p;

    i_ashr_bar <= not i_ashr_p;
	 
	 i_result <= i_p_out & i_b_out;

    -- output driver

    o_f <= i_of;

    counter <= i_cnt_val;

    mult_done <= i_mult_done;

    states <= i_states;

    result <= i_result;


    

end architecture;



