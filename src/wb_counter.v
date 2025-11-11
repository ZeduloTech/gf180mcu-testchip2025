// Simple Wishbone counter example

module wb_counter #(
    parameter WB_ADR_WIDTH      = 8,
    parameter WB_DAT_WIDTH      = 32
) (
    input                       wb_clk_i,
    input                       wb_rst_i, 
    input                       wb_stb_i, 
    input                       wb_cyc_i, 
    input  [WB_ADR_WIDTH-1:0]   wb_adr_i,
    input  [WB_DAT_WIDTH-1:0]   wb_dat_i, 
    input                       wb_we_i,
    output [WB_DAT_WIDTH-1:0]   wb_dat_o,
    output                      wb_ack_o
);

    reg [WB_DAT_WIDTH-1:0] counter;
    reg [WB_DAT_WIDTH-1:0] counter_out;
    reg ack;

    assign wb_dat_o = counter_out;
    assign wb_ack_o = ack;

    always @(posedge wb_clk_i or posedge wb_rst_i) begin
        if (wb_rst_i) begin
            counter <= 0;
            counter_out <= 0;
            ack <= 1'b0;
        end else begin
            counter <= counter + 1;
            ack <= 1'b0;

            if (wb_stb_i & wb_cyc_i & ~ack) begin
                if (wb_we_i)
                    counter <= wb_dat_i;
                else
                    counter_out <= counter;

                ack <= 1'b1;
            end
        end
    end
    
endmodule
