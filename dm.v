module dm
(
    input wire rst, clk, clk_500ms, splitcheck,
    input wire [3:0] hr_0, hr_1, min_0, min_1, sec_0, sec_1, cent_0, cent_1,
    output wire [7:0] an, dec_ddp
);

wire [5:0] d1, d2, d3, d4, d5, d6, d7, d8;
reg [3:0] split1, split2, split3, split4, split5, split6, split7, split8;
wire [3:0] digit1, digit2, digit3, digit4, digit5, digit6, digit7, digit8;
reg splitswitch, lightswitch;

//se split for pressionado, captura o valor dos contadores e alterna a switch
always @(posedge clk or posedge rst) begin
  if (rst) begin
    split1 <= 4'b0;
    split2 <= 4'b0;
    split3 <= 4'b0;
    split4 <= 4'b0;
    split5 <= 4'b0;
    split6 <= 4'b0;
    split7 <= 4'b0;
    split8 <= 4'b0;
    splitswitch <= 1'b0;
  end else begin
    if (splitcheck) begin
        split1 <= cent_0;
        split2 <= cent_1;
        split3 <= sec_0;
        split4 <= sec_1;
        split5 <= min_0;
        split6 <= min_1;
        split7 <= hr_0;
        split8 <= hr_1;
        splitswitch <= ~splitswitch;
    end
   end
end

//se splitswitch for 1, alterna a lightswitch, que liga e desliga o display
always@(posedge clk_500ms or posedge rst) begin
  if (rst) begin
    lightswitch <= 1'b1;
  end else begin
    if (splitswitch) begin
      lightswitch <= ~lightswitch;
    end else begin
      lightswitch <= 1'b1;
    end
  end
end

assign digit1 = splitswitch ? split1 : cent_0;
assign digit2 = splitswitch ? split2 : cent_1;
assign digit3 = splitswitch ? split3 : sec_0;
assign digit4 = splitswitch ? split4 : sec_1;
assign digit5 = splitswitch ? split5 : min_0;
assign digit6 = splitswitch ? split6 : min_1;
assign digit7 = splitswitch ? split7 : hr_0;
assign digit8 = splitswitch ? split8 : hr_1;

assign d1 = ({lightswitch, digit1, 1'b0});
assign d2 = ({lightswitch, digit2, 1'b0});
assign d3 = ({lightswitch, digit3, 1'b0});
assign d4 = ({lightswitch, digit4, 1'b0}); 
assign d5 = ({lightswitch, digit5, 1'b0});
assign d6 = ({lightswitch, digit6, 1'b0}); 
assign d7 = ({lightswitch, digit7, 1'b0});
assign d8 = ({lightswitch, digit8, 1'b0}); 

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