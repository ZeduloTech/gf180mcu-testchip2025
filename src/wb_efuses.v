/*
 * 4 eFuse blocks connected to one master Wishbone
 *
 * eFuse Blocks:
 * 0 - 1024x32
 * 1 - 128x8
 * 2 - 64x32
 * 3 - 32x8
 */

 module wb_efuses # (
     parameter DATA_WIDTH   = 32,                // width of data bus in bits (8, 16, 32, or 64)
     parameter ADDR_WIDTH   = 32,                // width of address bus in bits
     parameter SELECT_WIDTH = (DATA_WIDTH/8)     // width of word select bus (1, 2, 4, or 8) 
) (
    // Wishbone master bus
    input  wire                    wb_clk_i,    // Clock
    input  wire                    wb_rst_i,    // Reset

    input  wire [ADDR_WIDTH-1:0]   wbm_adr_i,   // ADR_I() address input
    input  wire [DATA_WIDTH-1:0]   wbm_dat_i,   // DAT_I() data in
    output wire [DATA_WIDTH-1:0]   wbm_dat_o,   // DAT_O() data out
    input  wire                    wbm_we_i,    // WE_I write enable input
    input  wire [SELECT_WIDTH-1:0] wbm_sel_i,   // SEL_I() select input
    input  wire                    wbm_stb_i,   // STB_I strobe input
    output wire                    wbm_ack_o,   // ACK_O acknowledge output
    input  wire                    wbm_cyc_i,   // CYC_I cycle input

    input  wire                    npor_i       // Active-low power on reset
 );

    // Wishbones for efuse blocks
    wire        ef0_wb_cyc;
    wire        ef0_wb_stb;
    wire        ef0_wb_we;
    wire [3:0]  ef0_wb_sel;
    wire [31:0] ef0_wb_adr;
    wire [31:0] ef0_wb_dat_wr;
    wire [31:0] ef0_wb_dat_rd;
    wire        ef0_wb_ack;

    wire        ef1_wb_cyc;
    wire        ef1_wb_stb;
    wire        ef1_wb_we;
    wire [3:0]  ef1_wb_sel;
    wire [31:0] ef1_wb_adr;
    wire [31:0] ef1_wb_dat_wr;
    wire [31:0] ef1_wb_dat_rd;
    wire        ef1_wb_ack;
    
    wire        ef2_wb_cyc;
    wire        ef2_wb_stb;
    wire        ef2_wb_we;
    wire [3:0]  ef2_wb_sel;
    wire [31:0] ef2_wb_adr;
    wire [31:0] ef2_wb_dat_wr;
    wire [31:0] ef2_wb_dat_rd;
    wire        ef2_wb_ack;
    
    wire        ef3_wb_cyc;
    wire        ef3_wb_stb;
    wire        ef3_wb_we;
    wire [3:0]  ef3_wb_sel;
    wire [31:0] ef3_wb_adr;
    wire [31:0] ef3_wb_dat_wr;
    wire [31:0] ef3_wb_dat_rd;
    wire        ef3_wb_ack;


    // Wishbone switch
    wb_switch efuse_wb_switch (
        // General signals
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
 
        // Master
        .wbm_adr_i(wbm_adr_i),      // ADR_I() address input
        .wbm_dat_i(wbm_dat_i),      // DAT_I() data in
        .wbm_dat_o(wbm_dat_o),      // DAT_O() data out
        .wbm_we_i (wbm_we_i),       // WE_I write enable input
        .wbm_sel_i(wbm_sel_i),      // SEL_I() select input
        .wbm_stb_i(wbm_stb_i),      // STB_I strobe input
        .wbm_ack_o(wbm_ack_o),      // ACK_O acknowledge output
        .wbm_cyc_i(wbm_cyc_i),      // CYC_I cycle input

        // eFuse 0
        .wbs0_adr_o(ef0_wb_adr),    // ADR_O() address output
        .wbs0_dat_i(ef0_wb_dat_rd), // DAT_I() data in
        .wbs0_dat_o(ef0_wb_dat_wr), // DAT_O() data out
        .wbs0_we_o (ef0_wb_we),     // WE_O write enable output
        .wbs0_sel_o(ef0_wb_sel),    // SEL_O() select output
        .wbs0_stb_o(ef0_wb_stb),    // STB_O strobe output
        .wbs0_ack_i(ef0_wb_ack),    // ACK_I acknowledge input
        .wbs0_cyc_o(ef0_wb_cyc),    // CYC_O cycle output

        // eFuse 1
        .wbs1_adr_o(ef1_wb_adr),    // ADR_O() address output
        .wbs1_dat_i(ef1_wb_dat_rd), // DAT_I() data in
        .wbs1_dat_o(ef1_wb_dat_wr), // DAT_O() data out
        .wbs1_we_o (ef1_wb_we),     // WE_O write enable output
        .wbs1_sel_o(ef1_wb_sel),    // SEL_O() select output
        .wbs1_stb_o(ef1_wb_stb),    // STB_O strobe output
        .wbs1_ack_i(ef1_wb_ack),    // ACK_I acknowledge input
        .wbs1_cyc_o(ef1_wb_cyc),    // CYC_O cycle output

        // eFuse 2
        .wbs2_adr_o(ef2_wb_adr),    // ADR_O() address output
        .wbs2_dat_i(ef2_wb_dat_rd), // DAT_I() data in
        .wbs2_dat_o(ef2_wb_dat_wr), // DAT_O() data out
        .wbs2_we_o (ef2_wb_we),     // WE_O write enable output
        .wbs2_sel_o(ef2_wb_sel),    // SEL_O() select output
        .wbs2_stb_o(ef2_wb_stb),    // STB_O strobe output
        .wbs2_ack_i(ef2_wb_ack),    // ACK_I acknowledge input
        .wbs2_cyc_o(ef2_wb_cyc),    // CYC_O cycle output

        // eFuse 3
        .wbs3_adr_o(ef3_wb_adr),    // ADR_O() address output
        .wbs3_dat_i(ef3_wb_dat_rd), // DAT_I() data in
        .wbs3_dat_o(ef3_wb_dat_wr), // DAT_O() data out
        .wbs3_we_o (ef3_wb_we),     // WE_O write enable output
        .wbs3_sel_o(ef3_wb_sel),    // SEL_O() select output
        .wbs3_stb_o(ef3_wb_stb),    // STB_O strobe output
        .wbs3_ack_i(ef3_wb_ack),    // ACK_I acknowledge input
        .wbs3_cyc_o(ef3_wb_cyc)     // CYC_O cycle output
    );

    // eFuse blocks
    efuse_wb_mem_1024x32 efuse_wb_1024x32 (
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
        .wb_stb_i(ef0_wb_stb),
        .wb_cyc_i(ef0_wb_cyc),
        .wb_adr_i(ef0_wb_adr[11:2]),
        .wb_dat_i(ef0_wb_dat_wr),
        .wb_we_i (ef0_wb_we),
        .wb_sel_i(ef0_wb_sel),
        .wb_dat_o(ef0_wb_dat_rd),
        .wb_ack_o(ef0_wb_ack),
        .write_enable_i(npor_i)
    );

    efuse_wb_mem_128x8 efuse_wb_128x8 (
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
        .wb_stb_i(ef1_wb_stb),
        .wb_cyc_i(ef1_wb_cyc),
        .wb_adr_i(ef1_wb_adr[8:2]),
        .wb_dat_i(ef1_wb_dat_wr),
        .wb_we_i (ef1_wb_we),
        .wb_sel_i(ef1_wb_sel),
        .wb_dat_o(ef1_wb_dat_rd),
        .wb_ack_o(ef1_wb_ack),
        .write_enable_i(npor_i)
    );
    assign ef1_wb_dat_rd[31:8] = 24'b0;

     efuse_wb_mem_64x32 efuse_wb_64x32 (
         .wb_clk_i(wb_clk_i),
         .wb_rst_i(wb_rst_i),
         .wb_stb_i(ef2_wb_stb),
         .wb_cyc_i(ef2_wb_cyc),
         .wb_adr_i(ef2_wb_adr[7:2]),
         .wb_dat_i(ef2_wb_dat_wr),
         .wb_we_i (ef2_wb_we),
         .wb_sel_i(ef2_wb_sel),
         .wb_dat_o(ef2_wb_dat_rd),
         .wb_ack_o(ef2_wb_ack),
         .write_enable_i(npor_i)
    );
    
    efuse_wb_mem_32x8 efuse_wb_32x8 (
        .wb_clk_i(wb_clk_i),
        .wb_rst_i(wb_rst_i),
        .wb_stb_i(ef3_wb_stb),
        .wb_cyc_i(ef3_wb_cyc),
        .wb_adr_i(ef3_wb_adr[6:2]),
        .wb_dat_i(ef3_wb_dat_wr),
        .wb_we_i (ef3_wb_we),
        .wb_sel_i(ef3_wb_sel),
        .wb_dat_o(ef3_wb_dat_rd),
        .wb_ack_o(ef3_wb_ack),
        .write_enable_i(npor_i)
    );
    assign ef3_wb_dat_rd[31:8] = 24'b0;

 endmodule
