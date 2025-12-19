`timescale 1ms / 100us

module tb_countdown;

    reg clk;
    reg rst_n;
    reg start;
    reg [6:0] preset_value;
    wire [6:0] count_out;
    wire active;

    countdown uut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .preset_value(preset_value),
        .count_out(count_out),
        .active(active)
    );


    initial clk = 0;
    always #5 clk = ~clk;
    
    initial begin
        $display("Starting countdown test...");
        $dumpfile("countdown.vcd");
        $dumpvars(0, tb_countdown);

        rst_n = 0;
        start = 0;
        preset_value = 7'd0;

        #20;
        rst_n = 1;

        #10;
        preset_value = 7'd5;
        start = 1;
        #10;
        start = 0;

        wait (count_out == 0);

        #20;
        preset_value = 7'd10;
        start = 1;
        #10;
        start = 0;

        wait (count_out == 0);
        
        $display("Finished test.");
        $finish;
    end

endmodule
