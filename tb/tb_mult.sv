`timescale 1ns / 1ps

module tb_mult();

//---------------------signals------------------
   logic signed [8:0] a,b; 
   logic signed [17:0]out; 
//----------------------------------------------

//-------------------stimulus
initial begin 
   a=0; b=0; 
   for(int i=0; i<2**9; i++) begin 
   #10
      for(int j=0;j <2**9; j++) begin 
         a=i; 
         b=j; 
         #1
         if($signed(out)!=$signed(a[8:0])*$signed(b[8:0])) $fatal("wrong output for a=%d, b=%d, and output is %d",$signed(a),$signed(b),$signed(out)); 
         #9; 
        
      end
   end
   #100 $finish(); 
end

//--inst
    booth_dadda_9bits dut (
    .x   (a),
    .y   (b),
    .mult(out) 
);
endmodule
