library verilog;
use verilog.vl_types.all;
entity comb_sqrt is
    generic(
        SIZE            : integer := 4
    );
    port(
        value           : in     vl_logic_vector;
        sqrt            : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of SIZE : constant is 1;
end comb_sqrt;
