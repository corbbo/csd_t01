module top
(
    input wire clk, rst, start, stop, split,
    output wire [7:0] an, dec_ddp,
);

wire start_ed, stop_ed, split_ed;
wire clk_milisec, clk_500ms;
wire [3:0] o_hr_0, o_hr_1, o_min_0, o_min_1, o_sec_0, o_sec_1, o_cent_0, o_cent_1;

edge_detector_sintese start_ed (
    .clk(clk),
    .rst(rst),
    .start(start),
    .start_ed(start_ed)
);

edge_detector_sintese stop_ed (
    .clk(clk),
    .rst(rst),
    .start(stop),
    .start_ed(stop_ed)
);

edge_detector_sintese split_ed (
    .clk(clk),
    .rst(rst),
    .start(split),
    .start_ed(split_ed)
);

dcm dcm (
  .rst(rst),
  .clk(clk),
  .clk_milisec(clk_milisec)
  .clk_500ms(clk_500ms)
);

counters counters (
    .rst(rst),
    .clk_milisec(clk_milisec),
    .o_hr_0(o_hr_0),
    .o_hr_1(o_hr_1),
    .o_min_0(o_min_0),
    .o_min_1(o_min_1),
    .o_sec_0(o_sec_0),
    .o_sec_1(o_sec_1),
    .o_cent_0(o_cent_0),
    .o_cent_1(o_cent_1),
    .split(split_ed)
);

dm dm (
    .rst(rst),
    .clk(clk),
    .clk_500ms(clk_500ms)
    .splitcheck(split_ed)
    .hr_0(o_hr_0),
    .hr_1(o_hr_1),
    .min_0(o_min_0),
    .min_1(o_min_1),
    .sec_0(o_sec_0),
    .sec_1(o_sec_1),
    .cent_0(o_cent_0),
    .cent_1(o_cent_1),
    .an(an),
    .dec_ddp(dec_ddp)
);

//Maquina de Estados
localparam S_IDLE = 2'b00;
localparam S_RUNNING = 2'b01;
localparam S_SPLIT = 2'b10;
localparam S_STOP = 2'b11;
reg [3:0] EA, PE;
reg splitcontrol;

//logica de troca de estados
always @(posedge clk or posedge rst) begin
    if (rst) begin
        EA <= S_IDLE;
    end
    else begin
        case (EA)
            S_IDLE: begin
                if (start_ed == 1) begin
                    PE <= S_RUNNING;
                end
                else EA <= PE;
            end
            S_RUNNING: begin
                if (stop_ed = 1) begin
                    PE <= S_STOP;
                end else if (split_ed = 1) begin
                    PE <= S_SPLIT;
                end
                else EA <= PE;
            end
            S_SPLIT: begin
                if (splitcontrol = 1) begin
                PE <= S_RUNNING;
                end
                else EA <= PE;
            end
            S_STOP: begin
                if (start_ed = 1) begin
                    PE <= S_RUNNING;
                end
                else EA <= PE;
            end
            default: begin PE <= S_IDLE; end
        endcase
    end
end

assign splitcontrol = ~split_ed;

endmodule