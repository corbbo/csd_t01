module counters
(
  input wire rst, clk_milisec, en, split,
  output wire [3:0] o_hr_0, o_hr_1, o_min_0, o_min_1, o_sec_0, o_sec_1, o_cent_0, o_cent_1
);

reg split_en;
reg [3:0] hr_0, hr_1, min_0, min_1, sec_0, sec_1, cent_0, cent_1;

// contador de tempo
always @(posedge clk_milisec or posedge rst) begin
    if (rst) begin
        hr_0 <= 4'd0;
        hr_1 <= 4'd0;
        min_0 <= 4'd0;
        min_1 <= 4'd0;
        sec_0 <= 4'd0;
        sec_1 <= 4'd0;
        cent_0 <= 4'd0;
        cent_1 <= 4'd0;
    end
    else begin
        if (en) begin
            if (cent_0 == 4'd9) begin
                cent_0 <= 4'd0;
                if (cent_1 == 4'd9) begin
                    cent_1 <= 4'd0;
                    if (sec_0 == 4'd9) begin
                        sec_0 <= 4'd0;
                        if (sec_1 == 4'd5) begin
                            sec_1 <= 4'd0;
                            if (min_0 == 4'd9) begin
                                min_0 <= 4'd0;
                                if (min_1 == 4'd5) begin
                                    min_1 <= 4'd0;
                                    if (hr_0 == 4'd9) begin
                                        hr_0 <= 4'd0;
                                        if (hr_1 == 4'd9) begin
                                            hr_1 <= 4'd0;
                                        end
                                        else begin
                                            hr_1 <= hr_1 + 4'd1;
                                        end
                                    end
                                    else begin
                                        hr_0 <= hr_0 + 4'd1;
                                    end
                                end
                                else begin
                                    min_1 <= min_1 + 4'd1;
                                end
                            end
                            else begin
                                min_0 <= min_0 + 4'd1;
                            end
                        end
                        else begin
                            sec_1 <= sec_1 + 4'd1;
                        end
                    end
                    else begin
                        sec_0 <= sec_0 + 4'd1;
                    end
                end
                else begin
                    cent_1 <= cent_1 + 4'd1;
                end
            end
            else begin
                cent_0 <= cent_0 + 4'd1;
            end
        end
    end
end

assign o_hr_0 = hr_0;
assign o_hr_1 = hr_1;
assign o_min_0 = min_0;
assign o_min_1 = min_1;
assign o_sec_0 = sec_0;
assign o_sec_1 = sec_1;
assign o_cent_0 = cent_0;
assign o_cent_1 = cent_1;

endmodule