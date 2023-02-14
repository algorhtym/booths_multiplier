library ieee;
use ieee.std_logic_1164.all;

entity ashr_17bit is
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
end entity;

architecture rtl of ashr_17bit is

    -- signal dec
    signal i_ashr_bar : std_logic;
    signal i_load_b, i_load_p : std_logic;
    signal i_dl_in_p, i_dl_in_b : std_logic_vector(7 downto 0);
    signal i_data_in_p, i_data_in_b : std_logic_vector(7 downto 0);
    signal i_dff_in_p, i_dff_in_b : std_logic_vector(7 downto 0);
    signal i_dff_in_bn1 : std_logic;
    signal i_data_b, i_data_p : std_logic_vector(7 downto 0);
    signal i_ALU_en_bar, i_add_bar_sub : std_logic;
    signal i_data_bn1 : std_logic;


    -- component dec

    component dflipflop 
        port(i_d, i_clk, i_set, i_rst: in STD_LOGIC; 
                o_q, o_qbar : inout STD_LOGIC);
    end component;
    
    component d_Latch 
        PORT(
            i_d		: IN	STD_LOGIC;
            i_enable	: IN	STD_LOGIC;
            o_q, o_qBar	: OUT	STD_LOGIC);
    end component;

    component pulse_detect
        port (
            clk   : in std_logic;
            pulse_in : in std_logic;
            pulse_out : out std_logic   
        );
    end component;

begin
    -- define components and port connections

    -- debounce dff circuit to detect single shift pulses
    pulse_deb : pulse_detect port map (
       clk => clk,
        pulse_in => ashr_bar,
        pulse_out => i_ashr_bar
    );
    
    -- -- dlatch for P(7)
    -- DL7_P : d_Latch port map (
	-- 	i_d => i_dl_in_p(7),
	-- 	i_enable => i_load_p,
	-- 	o_q => i_data_in_p(7),
	-- 	o_qBar => open
	-- );

    -- -- dlatch for P(6)
    -- DL6_P : d_Latch port map (
	-- 	i_d => i_dl_in_p(6),
	-- 	i_enable => i_load_p,
	-- 	o_q => i_data_in_p(6),
	-- 	o_qBar => open
	-- );

    -- -- dlatch for P(5)
    -- DL5_P : d_Latch port map (
	-- 	i_d => i_dl_in_p(5),
	-- 	i_enable => i_load_p,
	-- 	o_q => i_data_in_p(5),
	-- 	o_qBar => open
	-- );

    -- -- dlatch for P(4)
    -- DL4_P : d_Latch port map (
	-- 	i_d => i_dl_in_p(4),
	-- 	i_enable => i_load_p,
	-- 	o_q => i_data_in_p(4),
	-- 	o_qBar => open
	-- );

    -- -- dlatch for P(6)
    -- DL3_P : d_Latch port map (
	-- 	i_d => i_dl_in_p(3),
	-- 	i_enable => i_load_p,
	-- 	o_q => i_data_in_p(3),
	-- 	o_qBar => open
	-- );

    -- -- dlatch for P(2)
    -- DL2_P : d_Latch port map (
	-- 	i_d => i_dl_in_p(2),
	-- 	i_enable => i_load_p,
	-- 	o_q => i_data_in_p(2),
	-- 	o_qBar => open
	-- );

    -- -- dlatch for P(1)
    -- DL1_P : d_Latch port map (
	-- 	i_d => i_dl_in_p(1),
	-- 	i_enable => i_load_p,
	-- 	o_q => i_data_in_p(1),
	-- 	o_qBar => open
	-- );

    -- -- dlatch for P(0)
    -- DL0_P : d_Latch port map (
	-- 	i_d => i_dl_in_p(0),
	-- 	i_enable => i_load_p,
	-- 	o_q => i_data_in_p(0),
	-- 	o_qBar => open
	-- );

    -- -- dlatch for B(7)
    -- DL7_B : d_Latch port map (
	-- 	i_d => i_dl_in_b(7),
	-- 	i_enable => i_load_p,
	-- 	o_q => i_data_in_b(7),
	-- 	o_qBar => open
	-- );

    -- -- dlatch for B(6)
    -- DL6_B : d_Latch port map (
	-- 	i_d => i_dl_in_b(6),
	-- 	i_enable => i_load_b,
	-- 	o_q => i_data_in_b(6),
	-- 	o_qBar => open
	-- );

    -- -- dlatch for B(5)
    -- DL5_B : d_Latch port map (
	-- 	i_d => i_dl_in_b(5),
	-- 	i_enable => i_load_b,
	-- 	o_q => i_data_in_b(5),
	-- 	o_qBar => open
	-- );

    -- -- dlatch for B(4)
    -- DL4_B : d_Latch port map (
	-- 	i_d => i_dl_in_b(4),
	-- 	i_enable => i_load_b,
	-- 	o_q => i_data_in_b(4),
	-- 	o_qBar => open
	-- );

    -- -- dlatch for B(3)
    -- DL3_B : d_Latch port map (
	-- 	i_d => i_dl_in_b(3),
	-- 	i_enable => i_load_b,
	-- 	o_q => i_data_in_b(3),
	-- 	o_qBar => open
	-- );

    -- -- dlatch for B(2)
    -- DL2_B : d_Latch port map (
	-- 	i_d => i_dl_in_b(2),
	-- 	i_enable => i_load_b,
	-- 	o_q => i_data_in_b(2),
	-- 	o_qBar => open
	-- );

    -- -- dlatch for B(1)
    -- DL1_B : d_Latch port map (
	-- 	i_d => i_dl_in_b(1),
	-- 	i_enable => i_load_b,
	-- 	o_q => i_data_in_b(1),
	-- 	o_qBar => open
	-- );

    -- -- dlatch for B(0)
    -- DL0_B : d_Latch port map (
	-- 	i_d => i_dl_in_b(0),
	-- 	i_enable => i_load_b,
	-- 	o_q => i_data_in_b(0),
	-- 	o_qBar => open
	-- );

    -- dff for P(7)
    dff7_P : dflipflop port map (
        i_d => i_dff_in_p(7),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_p_bar,
		o_q => i_data_p(7),
		o_qbar => open
    );

    -- dff for P(6)
    dff6_P : dflipflop port map (
        i_d => i_dff_in_p(6),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_p_bar,
		o_q => i_data_p(6),
		o_qbar => open
    );

    -- dff for P(5)
    dff5_P : dflipflop port map (
        i_d => i_dff_in_p(5),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_p_bar,
		o_q => i_data_p(5),
		o_qbar => open
    );

    -- dff for P(4)
    dff4_P : dflipflop port map (
        i_d => i_dff_in_p(4),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_p_bar,
		o_q => i_data_p(4),
		o_qbar => open
    );

    -- dff for P(3)
    dff3_P : dflipflop port map (
        i_d => i_dff_in_p(3),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_p_bar,
		o_q => i_data_p(3),
		o_qbar => open
    );

    -- dff for P(2)
    dff2_P : dflipflop port map (
        i_d => i_dff_in_p(2),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_p_bar,
		o_q => i_data_p(2),
		o_qbar => open
    );

    -- dff for P(1)
    dff1_P : dflipflop port map (
        i_d => i_dff_in_p(1),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_p_bar,
		o_q => i_data_p(1),
		o_qbar => open
    );

    -- dff for P(0)
    dff0_P : dflipflop port map (
        i_d => i_dff_in_p(0),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_p_bar,
		o_q => i_data_p(0),
		o_qbar => open
    );

    -- dff for B(7)
    dff7_B : dflipflop port map (
        i_d => i_dff_in_b(7),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_b_bar,
		o_q => i_data_b(7),
		o_qbar => open
    );

    -- dff for B(6)
    dff6_B : dflipflop port map (
        i_d => i_dff_in_b(6),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_b_bar,
		o_q => i_data_b(6),
		o_qbar => open
    );

    -- dff for B(5)
    dff5_B : dflipflop port map (
        i_d => i_dff_in_b(5),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_b_bar,
		o_q => i_data_b(5),
		o_qbar => open
    );

    -- dff for B(4)
    dff4_B : dflipflop port map (
        i_d => i_dff_in_b(4),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_b_bar,
		o_q => i_data_b(4),
		o_qbar => open
    );

    -- dff for B(3)
    dff3_B : dflipflop port map (
        i_d => i_dff_in_b(3),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_b_bar,
		o_q => i_data_b(3),
		o_qbar => open
    );

    -- dff for B(2)
    dff2_B : dflipflop port map (
        i_d => i_dff_in_b(2),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_b_bar,
		o_q => i_data_b(2),
		o_qbar => open
    );

    -- dff for B(1)
    dff1_B : dflipflop port map (
        i_d => i_dff_in_b(1),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_b_bar,
		o_q => i_data_b(1),
		o_qbar => open
    );

    -- dff for B(0)
    dff0_B : dflipflop port map (
        i_d => i_dff_in_b(0),
		i_clk => clk,
		i_set => '1',
		i_rst => reset_b_bar,
		o_q => i_data_b(0),
		o_qbar => open
    );

    -- dff for B(-1)
    dffN1_B : dflipflop port map (
        i_d => i_dff_in_bn1,
		i_clk => clk,
		i_set => '1',
		i_rst => reset_p_bar,
		o_q => i_data_bn1,
		o_qbar => open
    );



    -- concurrent signal connections
	 
	--  i_ashr_bar <= ashr_bar;

    -- i_dl_in_p(7) <= P_in(7) and i_ashr_bar;
    -- i_dl_in_p(6) <= P_in(6) and i_ashr_bar;
    -- i_dl_in_p(5) <= P_in(5) and i_ashr_bar;
    -- i_dl_in_p(4) <= P_in(4) and i_ashr_bar;
    -- i_dl_in_p(3) <= P_in(3) and i_ashr_bar;
    -- i_dl_in_p(2) <= P_in(2) and i_ashr_bar;
    -- i_dl_in_p(1) <= P_in(1) and i_ashr_bar;
    -- i_dl_in_p(0) <= P_in(0) and i_ashr_bar;

    -- i_dl_in_b(7) <= B_in(7) and i_ashr_bar;
    -- i_dl_in_b(6) <= B_in(6) and i_ashr_bar;
    -- i_dl_in_b(5) <= B_in(5) and i_ashr_bar;
    -- i_dl_in_b(4) <= B_in(4) and i_ashr_bar;
    -- i_dl_in_b(3) <= B_in(3) and i_ashr_bar;
    -- i_dl_in_b(2) <= B_in(2) and i_ashr_bar;
    -- i_dl_in_b(1) <= B_in(1) and i_ashr_bar;
    -- i_dl_in_b(0) <= B_in(0) and i_ashr_bar;

    i_data_in_p(7) <= i_ashr_bar and ((p_in(7) and not i_load_p) or (i_data_p(7) and i_load_p));
    i_data_in_p(6) <= i_ashr_bar and ((p_in(6) and not i_load_p) or (i_data_p(6) and i_load_p));
    i_data_in_p(5) <= i_ashr_bar and ((p_in(5) and not i_load_p) or (i_data_p(5) and i_load_p));
    i_data_in_p(4) <= i_ashr_bar and ((p_in(4) and not i_load_p) or (i_data_p(4) and i_load_p));
    i_data_in_p(3) <= i_ashr_bar and ((p_in(3) and not i_load_p) or (i_data_p(3) and i_load_p));
    i_data_in_p(2) <= i_ashr_bar and ((p_in(2) and not i_load_p) or (i_data_p(2) and i_load_p));
    i_data_in_p(1) <= i_ashr_bar and ((p_in(1) and not i_load_p) or (i_data_p(1) and i_load_p));
    i_data_in_p(0) <= i_ashr_bar and ((p_in(0) and not i_load_p) or (i_data_p(0) and i_load_p));

    i_data_in_b(7) <= i_ashr_bar and ((b_in(7) and not i_load_b) or (i_data_b(7) and i_load_b));
    i_data_in_b(6) <= i_ashr_bar and ((b_in(6) and not i_load_b) or (i_data_b(6) and i_load_b));
    i_data_in_b(5) <= i_ashr_bar and ((b_in(5) and not i_load_b) or (i_data_b(5) and i_load_b));
    i_data_in_b(4) <= i_ashr_bar and ((b_in(4) and not i_load_b) or (i_data_b(4) and i_load_b));
    i_data_in_b(3) <= i_ashr_bar and ((b_in(3) and not i_load_b) or (i_data_b(3) and i_load_b));
    i_data_in_b(2) <= i_ashr_bar and ((b_in(2) and not i_load_b) or (i_data_b(2) and i_load_b));
    i_data_in_b(1) <= i_ashr_bar and ((b_in(1) and not i_load_b) or (i_data_b(1) and i_load_b));
    i_data_in_b(0) <= i_ashr_bar and ((b_in(0) and not i_load_b) or (i_data_b(0) and i_load_b));



    i_dff_in_p(7) <= (i_data_p(7) and not i_ashr_bar) or (i_data_in_p(7));
    i_dff_in_p(6) <= (i_data_p(7) and not i_ashr_bar) or (i_data_in_p(6));
    i_dff_in_p(5) <= (i_data_p(6) and not i_ashr_bar) or (i_data_in_p(5));
    i_dff_in_p(4) <= (i_data_p(5) and not i_ashr_bar) or (i_data_in_p(4));
    i_dff_in_p(3) <= (i_data_p(4) and not i_ashr_bar) or (i_data_in_p(3));
    i_dff_in_p(2) <= (i_data_p(3) and not i_ashr_bar) or (i_data_in_p(2));
    i_dff_in_p(1) <= (i_data_p(2) and not i_ashr_bar) or (i_data_in_p(1));
    i_dff_in_p(0) <= (i_data_p(1) and not i_ashr_bar) or (i_data_in_p(0));

    i_dff_in_b(7) <= (i_data_p(0) and not i_ashr_bar) or (i_data_in_b(7));
    i_dff_in_b(6) <= (i_data_b(7) and not i_ashr_bar) or (i_data_in_b(6));
    i_dff_in_b(5) <= (i_data_b(6) and not i_ashr_bar) or (i_data_in_b(5));
    i_dff_in_b(4) <= (i_data_b(5) and not i_ashr_bar) or (i_data_in_b(4));
    i_dff_in_b(3) <= (i_data_b(4) and not i_ashr_bar) or (i_data_in_b(3));
    i_dff_in_b(2) <= (i_data_b(3) and not i_ashr_bar) or (i_data_in_b(2));
    i_dff_in_b(1) <= (i_data_b(2) and not i_ashr_bar) or (i_data_in_b(1));
    i_dff_in_b(0) <= (i_data_b(1) and not i_ashr_bar) or (i_data_in_b(0));

    i_dff_in_bn1 <= (i_data_b(0) and not i_ashr_bar) or (i_data_bn1 and i_ashr_bar);

    i_ALU_en_bar <= i_data_b(0) xnor i_data_bn1;
    i_add_bar_sub <= i_data_b(0);
	 
	i_load_b <= load_b_bar;
	i_load_p <= load_p_bar;

    -- output driver
    
    ALU_en_bar <= i_ALU_en_bar; 
    add_bar_sub <= i_add_bar_sub;
    
    P_out <= i_data_p;
	B_out <= i_data_b;
	Bn1 <= i_data_bn1;
    

    
    

end architecture;
