`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Aditya Mathuriya  
//   proposed FA 
//   S    = (A?+B)?Cin 
//   Cout = A  
//////////////////////////////////////////////////////////////////////////////////


module fa_approx(
    input  logic a   ,
    input  logic b   ,
    input  logic cin ,
    output logic s   ,
    output logic cout
    );
assign s = a^b^cin;            // exact 
//assign s    = b ;              // AFA3
//assign s    = (~a | b) & cin; // AFA2
//assign s    = a^b ;             // AFA1
//assign cout = a&b; 
assign cout = a&&b || (a^b)&&cin; // exact
    
endmodule
