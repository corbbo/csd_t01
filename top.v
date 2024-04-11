module top
(
    input wire clk, rst, start, stop, split,
    output wire [7:0] an, dec_ddp
);

wire start_ed, stop_ed, split_ed;
wire clk_milisec, clk_500ms;
wire [3:0] o_hr_0, o_hr_1, o_min_0, o_min_1, o_sec_0, o_sec_1, o_cent_0, o_cent_1;
reg en;

edge_detector_sintese ed_start (
    .clk(clk),
    .rst(rst),
    .din(start),
    .rising(start_ed)
);

edge_detector_sintese ed_stop (
    .clk(clk),
    .rst(rst),
    .din(stop),
    .rising(stop_ed)
);

edge_detector_sintese ed_split (
    .clk(clk),
    .rst(rst),
    .din(split),
    .rising(split_ed)
);

dcm dcm (
  .rst(rst),
  .clk(clk),
  .clk_milisec(clk_milisec),
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
    .split(split_ed),
    .en(en)
);

dm dm (
    .rst(rst),
    .clk(clk),
    .clk_500ms(clk_500ms),
    .splitcheck(split_ed),
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
reg [1:0] EA;
wire splitcontrol;


//logica de troca de estados
always @(posedge clk or posedge rst) begin
    if (rst) begin
        EA <= S_IDLE;
    end
    else begin
        case (EA)
            S_IDLE: begin
                if (start_ed == 1) begin
                    EA <= S_RUNNING;
                end
            end
            S_RUNNING: begin
                if (stop_ed == 1) begin
                    EA <= S_STOP;
                end else if (split_ed == 1) begin
                    EA <= S_SPLIT;
                end
            end
            S_SPLIT: begin
                if (splitcontrol == 1) begin
                EA <= S_RUNNING;
                end
            end
            S_STOP: begin
                if (start_ed == 1) begin
                    EA <= S_RUNNING;
                end
            end
            default: begin EA <= S_IDLE; end
        endcase
    end
end

always @(posedge clk or posedge rst) begin
    if (rst) begin
        en <= 1'b0;
    end
    else begin
        case (EA)
            S_IDLE: begin
                en <= 1'b0;
            end
            S_RUNNING: begin
                en <= 1'b1;
            end
            S_SPLIT: begin
                en <= 1'b1;
            end
            S_STOP: begin
                en <= 1'b0;
            end
            default: begin en <= 1'b0; end
        endcase
    end
end

assign splitcontrol = ~split_ed;

endmodule