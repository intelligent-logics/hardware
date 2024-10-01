//basics of modules
//referenced from:
//https://www.chipverify.com/verilog/verilog-modules

//modules are how we implement actual logic into verilog

//a module consists of the following:
module <nameofmodule> (<portlist>);

//module logic

endmodule;

//note that the port list is optional
//its perfectly valid to go:

module <nameofmodule>;

//module logic

endmodule;

//the module logic contains variable declarations
//dataflow statements, functions, tasks, and
//instances of any modules used or instantiated

//multiple modules can be declared 