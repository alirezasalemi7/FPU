library verilog;
use verilog.vl_types.all;
entity comparator is
    generic(
        SIZE            : integer := 32
    );
    port(
        a               : in     vl_logic_vector;
        b               : in     vl_logic_vector;
        equal           : out    vl_logic;
        lower           : out    vl_logic;
        greater         : out    vl_logic
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of SIZE : constant is 1;
end comparator;
