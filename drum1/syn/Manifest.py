target = "xilinx"
action = "synthesis"

syn_device = "xc6slx25"
syn_grade = "-3"
syn_package = "ftg256"
syn_top = "drum1"
syn_project = "drum1.xise"
syn_tool = "ise"

modules = {
    "local" : [ "../vhdl" ],
}


