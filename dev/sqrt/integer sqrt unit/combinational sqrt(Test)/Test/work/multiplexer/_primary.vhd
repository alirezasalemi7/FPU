library verilog;
use verilog.vl_types.all;
entity multiplexer is
    generic(
        SIZE            : integer := 32
    );
    port(
        first_value     : in     vl_logic_vector;
        second_value    : in     vl_logic_vector;
        \select\        : in     vl_logic;
        \out\           : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of SIZE : constant is 1;
end multiplexer;
