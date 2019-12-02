library verilog;
use verilog.vl_types.all;
entity eraser is
    generic(
        SIZE            : integer := 32
    );
    port(
        value           : in     vl_logic_vector;
        erase           : in     vl_logic;
        result          : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of SIZE : constant is 1;
end eraser;
