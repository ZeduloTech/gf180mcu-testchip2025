// Async eFuse Wishbone wrapper

module wb_async_efuse #(
    parameter WB_ADR_WIDTH      = 32,
    parameter WB_DAT_WIDTH      = 32
) (
    input                       wb_clk_i,
    input                       wb_rst_i, 
    input                       wb_stb_i, 
    input                       wb_cyc_i, 
    input  [WB_ADR_WIDTH-1:0]   wb_adr_i,
    input  [WB_DAT_WIDTH-1:0]   wb_dat_i, 
    input                       wb_we_i,
    input  [WB_DAT_WIDTH/8-1:0] wb_sel_i, 
    output [WB_DAT_WIDTH-1:0]   wb_dat_o,
    output                      wb_ack_o,

    input                       npor
);

    localparam EF_CNT = 4;

    reg ack;

    wire [EF_CNT-1:0] ef_ready;  // not used
    wire [WB_DAT_WIDTH-1:0] ef_out;
    reg  [WB_DAT_WIDTH-1:0] ef_out_reg;
    reg  [WB_DAT_WIDTH-1:0] ef_prog;
    integer m;

    assign wb_dat_o = ef_out_reg;
    assign wb_ack_o = ack;

    always @(posedge wb_clk_i or posedge wb_rst_i) begin
        if (wb_rst_i) begin
            ef_prog <= 0;
            ack <= 1'b0;
        end else begin
            ack <= 1'b0;

            if (wb_stb_i & wb_cyc_i & ~ack) begin
                if (wb_we_i) begin
                    for (m = 0; m < WB_DAT_WIDTH/8; m = m + 1)
                        if (wb_sel_i[m])
                            ef_prog[m*8 +: 8] <= wb_dat_i[m*8 +: 8];
                end else begin
                    ef_out_reg <= ef_out;
                end

                ack <= 1'b1;
            end
        end
    end

    // 4 blocks of eFuse async memory connected in parallel
    genvar i;
    generate
        for (i = 0; i < EF_CNT; i = i + 1) begin : efuse
            efuse_async_mem_1x8 efuse_async (
                .reset_n(npor),
                .ready(ef_ready[i]),
                .prog(ef_prog[(i+1)*8 - 1: i*8]),
                .out(ef_out[(i+1)*8 - 1: i*8])
            );
        end    
    endgenerate
    
endmodule
