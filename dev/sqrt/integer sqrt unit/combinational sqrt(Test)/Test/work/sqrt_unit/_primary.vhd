library verilog;
use verilog.vl_types.all;
entity sqrt_unit is
    generic(
        SIZE            : integer := 32
    );
    port(
        prev_result     : in     vl_logic_vector;
        prev_num        : in     vl_logic_vector;
        prev_biggest_power: in     vl_logic_vector;
        cur_result      : out    vl_logic_vector;
        cur_num         : out    vl_logic_vector;
        cur_biggest_power: out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of SIZE : constant is 1;
end sqrt_unit;
