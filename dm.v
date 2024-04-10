module dm
(
    input wire rst, clk,
    input wire [3:0] hr_0, hr_1, min_0, min_1, sec_0, sec_1, cent_0, cent_1,
    output wire [7:0] an, dec_ddp
);

dspl_drv_NexysA7 driver (
  .reset(rst), 
  .clock(clk), 
  .d1({1'b1, cent_0, 1'b0}), 
  .d2({1'b1, cent_1, 1'b0}), 
  .d3({1'b1, sec_0, 1'b0}), 
  .d4({1'b1, sec_1, 1'b0}), 
  .d5({1'b1, min_0, 1'b0}), 
  .d6({1'b1, min_1, 1'b0}), 
  .d7({1'b1, hr_0, 1'b0}), 
  .d8({1'b1, hr_1, 1'b0}), 
  .an(an), 
  .dec_cat(dec_ddp)
);

endmodule