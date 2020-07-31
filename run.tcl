set filename $env(NAME)
set repeat $env(NUM)
set compile $env(COMPILE)

set library_file_list {
  design_library {
                    FPU/FPU.v
                    FPU/TB/TB.v
                 }
}

set top_level  design_library.TB

if {$compile == 0} {
  puts "Compiling.."
  foreach {library file_list} $library_file_list {
    vlib $library
    vmap work $library
    foreach file $file_list {
          vlog $file +incdir+TB +incdir+FPU +incdir+Headers +incdir+Interfaces/Input_interface +incdir+Interfaces/Output_interface +incdir+Basics/Adder +incdir+Basics/Comparator +incdir+Basics/Eraser +incdir+Basics/First_one_finder +incdir+Basics/Multiplexer +incdir+Basics/Register_div +incdir+Basics/Register_sqrt +incdir+Basics/Subtractor +incdir+FP_divider/Divider +incdir+FP_divider/Wrapper +incdir+FP_sqrt/Exponent_handler +incdir+FP_sqrt/Input_wrapper +incdir+FP_sqrt/Output_wrapper +incdir+FP_sqrt/Sqrt +incdir+FP_sqrt/Sqrt_FP -quiet -suppress 2275 -suppress 2608
    }
  }
}

puts "Simulating.."

vsim $top_level -gFILENAME=$filename -gREPEAT=$repeat -quiet
add wave -position insertpoint  -radix binary -r /*
run -all
quit -force
