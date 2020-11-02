import sys, os
import re

TAB = "    "
TIMESCALE = "`timescale 1us/1ns"
has_clock = 0
pattern = re.compile(r"module .*\((.*)\);", flags=re.MULTILINE|re.DOTALL)
vector_pattern = re.compile(r"\[\d+:\d+\]")

def get_module_text(module_name: str) -> str:
    with open(f"{module_name}.v", "r") as module:
        ios = re.findall(pattern, module.read())[0]
    return ios.strip()

def get_testbench_ios(module_text: str) -> tuple:
    ios = tuple(map(str.strip, module_text.split('\n')))
    testbench_ios = []
    for io in ios:
        input_string = re.sub(r"input\s(reg|wire)?", "reg ", io)
        if input_string != io:
            testbench_ios.append("".join([input_string.rstrip(","), ";"]))

        output_string = re.sub(r"output\s(reg|wire)?", "wire ", io)
        if output_string != io:
            testbench_ios.append("".join([output_string.rstrip(","), ";"]))
    return tuple(testbench_ios)

def get_io_names(module_text: str) -> tuple:
    ios = list(map(str.strip, module_text.split('\n')))
    io_names = []
    for io in ios:
        names = tuple(re.sub(r"(in|out)put\s(reg|wire)?", "", io).replace(",", " ").split())
        for name in names:
            if not(re.findall(vector_pattern, name)):
                io_names.append(name)
    return tuple(io_names)


if __name__ == "__main__":
    module_name = sys.argv[1].rstrip(".v")

    module_text = get_module_text(module_name)
    testbench_ios = get_testbench_ios(module_text)
    io_names = get_io_names(module_text)
    has_clock = "CLOCK_50" in io_names or "clk" in io_names or "clock" in io_names
    

    try:
        os.mkdir("testbench")
    except OSError:
        pass

    with open(f"./testbench/{module_name}_testbench.v", "w+") as testbench:
        testbench.write(f"/*\n* Testbench for {module_name}.v\n*/\n\n")
        testbench.write(f"{TIMESCALE}\n\n")
       
        testbench.write(f"module {module_name}_testbench();\n\n")
        
        # Inputs and outputs
        for item in testbench_ios:
            testbench.write(f"{TAB}{item}\n")
        testbench.write("\n")
        
        # Local parametres
        testbench.write(f"{TAB}localparam clock_period = 0.5;\n\n")

        # Device under test
        testbench.write(f"{TAB}{module_name} UUT(\n")
        for index, name in enumerate(io_names):
            testbench.write(f"{TAB}{TAB}.{name:10s} ({name})")
            if index < len(io_names) - 1:
                testbench.write(",\n")
        testbench.write("\n")
        testbench.write(f"{TAB});\n\n")

        # Print always block with clock
        if has_clock:
            testbench.write(f"{TAB}always begin\n")
            testbench.write(f"{TAB}{TAB}#clock_period;\n")
            testbench.write(f"{TAB}{TAB}// ADD CLOCK REVERSER HERE\n")
            testbench.write(f"{TAB}{TAB}// I HAVE NOT UNDERSTAND YET HOW TO GENERILIZE THIS SHIT\n")
            testbench.write(f"{TAB}end\n\n")

        # Print initial block
        testbench.write(f"{TAB}initial begin\n")
        testbench.write(f"{TAB}{TAB}$dumpfile(\"./{module_name}.vcd\");\n")
        testbench.write(f"{TAB}{TAB}$dumpvars(0, {module_name}_testbench);\n\n")
        if has_clock:
            testbench.write(f"{TAB}{TAB}$finish;\n")
        testbench.write(f"{TAB}end\n\n")
        
        testbench.write(f"endmodule\n")
