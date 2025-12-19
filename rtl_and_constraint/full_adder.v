`timescale 1ns / 1ps


module full_adder(
    input a,b,cin,
    output cout,s
    );
//    LUT6_2 #( .INIT(64'he8e8e8e896969696))
//    lut (
//        .O6(cout),.O5(s),.I5(1),.I4(0),.I3(0),.I2(a),.I1(b),.I0(cin));
        
   assign   s    = a^b^cin; 
   assign   cout = a&&b || (a^b)&&cin; 
endmodule
