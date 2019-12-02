library verilog;
use verilog.vl_types.all;
entity first_one_finder is
    generic(
        SIZE            : integer := 32
    );
    port(
        number          : in     vl_logic_vector;
        max_power       : out    vl_logic_vector
    );
    attribute mti_svvh_generic_type : integer;
    attribute mti_svvh_generic_type of SIZE : constant is 1;
end first_one_finder;
