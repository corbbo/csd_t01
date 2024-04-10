module dm
(
    input wire rst, clk, clk_500ms, splitcheck,
    input wire [3:0] hr_0, hr_1, min_0, min_1, sec_0, sec_1, cent_0, cent_1,
    output wire [7:0] an, dec_ddp
);

reg [5:0] d1, d2, d3, d4, d5, d6, d7, d8;

//se split for ligado, liga e desliga bit de luz a cada ciclo de clock 500ms
always@(posedge clk_500ms) begin
  if (splitcheck) begin
    d1[5] <= ~d1[5];
    d2[5] <= ~d2[5];
    d3[5] <= ~d3[5];
    d4[5] <= ~d4[5];
    d5[5] <= ~d5[5];
    d6[5] <= ~d6[5];
    d7[5] <= ~d7[5];
    d8[5] <= ~d8[5];
  end
end

assign d1 = ({1'b1, cent_0, 1'b0});
assign d2 = ({1'b1, cent_1, 1'b0});
assign d3 = ({1'b1, sec_0, 1'b0});
assign d4 = ({1'b1, sec_1, 1'b0}); 
assign d5 = ({1'b1, min_0, 1'b0});
assign d6 = ({1'b1, min_1, 1'b0}); 
assign d7 = ({1'b1, hr_0, 1'b0});
assign d8 = ({1'b1, hr_1, 1'b0}); 

dspl_drv_NexysA7 driver (
  .reset(rst), 
  .clock(clk), 
  .d1(d1), 
  .d2(d2), 
  .d3(d3), 
  .d4(d4), 
  .d5(d5), 
  .d6(d6), 
  .d7(d7), 
  .d8(d8), 
  .an(an), 
  .dec_cat(dec_ddp)
);

endmodule