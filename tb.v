
module tb;
reg clk, rst, start, stop, split;

localparam CLK_PERIOD100MHZ = 10;
forever #(CLK_PERIOD100MHZ/2) clk = ~clk;

initial begin
    rst = 1'b1;
    #30;
    start = 1'b1;
    #80;
    stop = 1'b1;
    #30;
    start = 1'b1;
    #50;
    split = 1'b1;
    #80;
    split = 1'b1;
    #30;
    stop = 1'b1;
end

top DUT(.rst(rst), .clk(clk), .start(start), .stop(stop), .split(split));

endmodule