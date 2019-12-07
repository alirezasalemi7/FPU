library verilog;
use verilog.vl_types.all;
entity OutputInterface is
    port(
        mode            : in     vl_logic;
        intA            : in     vl_logic_vector(52 downto 0);
        intB            : in     vl_logic_vector(52 downto 0);
        expA            : in     vl_logic_vector(10 downto 0);
        expB            : in     vl_logic_vector(10 downto 0);
        signA           : in     vl_logic;
        signB           : in     vl_logic;
        nanA            : in     vl_logic;
        nanB            : in     vl_logic;
        infA            : in     vl_logic;
        infB            : in     vl_logic;
        errA            : in     vl_logic;
        errB            : in     vl_logic;
        outA            : out    vl_logic_vector(63 downto 0);
        outB            : out    vl_logic_vector(63 downto 0);
        err             : out    vl_logic
    );
end OutputInterface;
