library verilog;
use verilog.vl_types.all;
entity InputInterface is
    port(
        inpA            : in     vl_logic_vector(63 downto 0);
        inpB            : in     vl_logic_vector(63 downto 0);
        operation       : in     vl_logic_vector(1 downto 0);
        outA            : out    vl_logic_vector(52 downto 0);
        outB            : out    vl_logic_vector(52 downto 0);
        expA            : out    vl_logic_vector(10 downto 0);
        expB            : out    vl_logic_vector(10 downto 0);
        signA           : out    vl_logic;
        signB           : out    vl_logic;
        flagsA          : out    vl_logic_vector(2 downto 0);
        flagsB          : out    vl_logic_vector(2 downto 0);
        op              : out    vl_logic_vector(1 downto 0)
    );
end InputInterface;
