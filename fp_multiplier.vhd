library ieee;
  use ieee.std_logic_1164.all;

  entity ieee754_multiplier_8bit is
    port (
      signA, signB : in std_logic;
      mantissaA, mantissaB : in std_logic_vector(7 downto 0);
      exponentA, exponentB : in std_logic_vector(6 downto 0);
      gclock : in std_logic;
      greset : in std_logic;
      sign_out : out std_logic;
      mantissa_out : out std_logic_vector(7 downto 0);
      exponent_out : out std_logic_vector(6 downto 0);
      overflow : out std_logic);
  end ieee754_multiplier_8bit;

  architecture structural of ieee754_multiplier_8bit is
    -- signal declarations

    -- component declarations

  begin
    -- define components and port connections

    -- concurrent signal connections

    -- output driver


  end structural;