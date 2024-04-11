module dcm 
(
  input wire rst, clk,
  output wire clk_milisec, clk_500ms
);

reg [31:0] counter_clk;

// Divisores de clock
reg clock, clock_500ms;
reg [31:0] counter, counter500;

always @(posedge clk or posedge rst) begin
  if (rst) begin
    clock <= 0;
    counter_clk <= 0;
    counter500 <= 32'd0;
  end
  else begin
    if (counter_clk >= 32'd499999) begin
      clock <= ~clock;
      counter_clk <= 32'd0;
      counter500 <= counter500 + 32'd1;
      if (counter500 >= 32'd49) begin
        clock_500ms <= ~clock_500ms;
        counter500 <= 32'd0;
      end
    end
    else begin
      counter_clk <= counter_clk + 32'd1;
    end
  end
end

assign clk_milisec = clock;
assign clk_500ms = clock_500ms;

endmodule
