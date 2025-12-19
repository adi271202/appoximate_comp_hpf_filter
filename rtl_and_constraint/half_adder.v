`timescale 1ns / 1ps



module half_adder(
    input a,b,
   output cout,s
    );
//    LUT6_2 #(.INIT(64'h8888888866666666))
//    lut_inst(.O6(cout),.O5(s),.I5(1'b1),.I4(0),.I3(0),.I2(0),.I1(a),.I0(b));
    
   assign s    = a^b; 
   assign cout = a&b; 
endmodule