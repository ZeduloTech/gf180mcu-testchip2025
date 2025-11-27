/*
 *
 * Wishbone switch to access all Wishbone eFuse blocks on a testchip from caravel.
 * Uses wb_mux & wb_reg by Alex Forencich.
 * All slave ports besides 0 are registered to improve timing.
 *
 */

`timescale 1 ns / 1 ps
 `default_nettype none

/*
 * Wishbone 4 port multiplexer
 */
module wb_switch #
(
    parameter DATA_WIDTH   = 32,                // width of data bus in bits (8, 16, 32, or 64)
    parameter ADDR_WIDTH   = 32,                // width of address bus in bits
    parameter SELECT_WIDTH = (DATA_WIDTH/8),    // width of word select bus (1, 2, 4, or 8)
    // Address config
    parameter ADDR_MASK    = 32'hFFFFF000,
    parameter S0_ADDR      = 32'h30000000,
    parameter S1_ADDR      = 32'h30001000,
    parameter S2_ADDR      = 32'h30002000,
    parameter S3_ADDR      = 32'h30003000
) (
    input  wire                    wb_clk_i,
    input  wire                    wb_rst_i,

    /*
     * Wishbone master input
     */
    input  wire [ADDR_WIDTH-1:0]   wbm_adr_i,     // ADR_I() address input
    input  wire [DATA_WIDTH-1:0]   wbm_dat_i,     // DAT_I() data in
    output wire [DATA_WIDTH-1:0]   wbm_dat_o,     // DAT_O() data out
    input  wire                    wbm_we_i,      // WE_I write enable input
    input  wire [SELECT_WIDTH-1:0] wbm_sel_i,     // SEL_I() select input
    input  wire                    wbm_stb_i,     // STB_I strobe input
    output wire                    wbm_ack_o,     // ACK_O acknowledge output
    input  wire                    wbm_cyc_i,     // CYC_I cycle input

    /*
     * Wishbone slave 0 output
     */
    output wire [ADDR_WIDTH-1:0]   wbs0_adr_o,    // ADR_O() address output
    input  wire [DATA_WIDTH-1:0]   wbs0_dat_i,    // DAT_I() data in
    output wire [DATA_WIDTH-1:0]   wbs0_dat_o,    // DAT_O() data out
    output wire                    wbs0_we_o,     // WE_O write enable output
    output wire [SELECT_WIDTH-1:0] wbs0_sel_o,    // SEL_O() select output
    output wire                    wbs0_stb_o,    // STB_O strobe output
    input  wire                    wbs0_ack_i,    // ACK_I acknowledge input
    output wire                    wbs0_cyc_o,    // CYC_O cycle output

    /*
     * Wishbone slave 1 output
     */
    output wire [ADDR_WIDTH-1:0]   wbs1_adr_o,    // ADR_O() address output
    input  wire [DATA_WIDTH-1:0]   wbs1_dat_i,    // DAT_I() data in
    output wire [DATA_WIDTH-1:0]   wbs1_dat_o,    // DAT_O() data out
    output wire                    wbs1_we_o,     // WE_O write enable output
    output wire [SELECT_WIDTH-1:0] wbs1_sel_o,    // SEL_O() select output
    output wire                    wbs1_stb_o,    // STB_O strobe output
    input  wire                    wbs1_ack_i,    // ACK_I acknowledge input
    output wire                    wbs1_cyc_o,    // CYC_O cycle output

    /*
     * Wishbone slave 2 output
     */
    output wire [ADDR_WIDTH-1:0]   wbs2_adr_o,    // ADR_O() address output
    input  wire [DATA_WIDTH-1:0]   wbs2_dat_i,    // DAT_I() data in
    output wire [DATA_WIDTH-1:0]   wbs2_dat_o,    // DAT_O() data out
    output wire                    wbs2_we_o,     // WE_O write enable output
    output wire [SELECT_WIDTH-1:0] wbs2_sel_o,    // SEL_O() select output
    output wire                    wbs2_stb_o,    // STB_O strobe output
    input  wire                    wbs2_ack_i,    // ACK_I acknowledge input
    output wire                    wbs2_cyc_o,    // CYC_O cycle output

    /*
     * Wishbone slave 3 output
     */
    output wire [ADDR_WIDTH-1:0]   wbs3_adr_o,    // ADR_O() address output
    input  wire [DATA_WIDTH-1:0]   wbs3_dat_i,    // DAT_I() data in
    output wire [DATA_WIDTH-1:0]   wbs3_dat_o,    // DAT_O() data out
    output wire                    wbs3_we_o,     // WE_O write enable output
    output wire [SELECT_WIDTH-1:0] wbs3_sel_o,    // SEL_O() select output
    output wire                    wbs3_stb_o,    // STB_O strobe output
    input  wire                    wbs3_ack_i,    // ACK_I acknowledge input
    output wire                    wbs3_cyc_o     // CYC_O cycle output
);

// Slave buses between switch and registers
wire [ADDR_WIDTH-1:0]   wbs1_prereg_adr;
wire [DATA_WIDTH-1:0]   wbs1_prereg_dat_i;
wire [DATA_WIDTH-1:0]   wbs1_prereg_dat_o;
wire                    wbs1_prereg_we ;
wire [SELECT_WIDTH-1:0] wbs1_prereg_sel;
wire                    wbs1_prereg_stb;
wire                    wbs1_prereg_ack;
wire                    wbs1_prereg_cyc;

wire [ADDR_WIDTH-1:0]   wbs2_prereg_adr;
wire [DATA_WIDTH-1:0]   wbs2_prereg_dat_i;
wire [DATA_WIDTH-1:0]   wbs2_prereg_dat_o;
wire                    wbs2_prereg_we ;
wire [SELECT_WIDTH-1:0] wbs2_prereg_sel;
wire                    wbs2_prereg_stb;
wire                    wbs2_prereg_ack;
wire                    wbs2_prereg_cyc;

wire [ADDR_WIDTH-1:0]   wbs3_prereg_adr;
wire [DATA_WIDTH-1:0]   wbs3_prereg_dat_i;
wire [DATA_WIDTH-1:0]   wbs3_prereg_dat_o;
wire                    wbs3_prereg_we ;
wire [SELECT_WIDTH-1:0] wbs3_prereg_sel;
wire                    wbs3_prereg_stb;
wire                    wbs3_prereg_ack;
wire                    wbs3_prereg_cyc;

// Wishbone mux 4->1
wb_mux_4 #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .SELECT_WIDTH(SELECT_WIDTH)
) wb_mux (
    // General signals
    .clk(wb_clk_i),
    .rst(wb_rst_i),
            
    // Address config
    .wbs0_addr(S0_ADDR),                // Slave address prefix
    .wbs0_addr_msk(ADDR_MASK),          // Slave address prefix mask
    .wbs1_addr(S1_ADDR),                // Slave address prefix
    .wbs1_addr_msk(ADDR_MASK),          // Slave address prefix mask
    .wbs2_addr(S2_ADDR),                // Slave address prefix
    .wbs2_addr_msk(ADDR_MASK),          // Slave address prefix mask
    .wbs3_addr(S3_ADDR),                // Slave address prefix
    .wbs3_addr_msk(ADDR_MASK),          // Slave address prefix mask

    // Master
    .wbm_adr_i(wbm_adr_i),              // ADR_I() address input
    .wbm_dat_i(wbm_dat_i),              // DAT_I() data in
    .wbm_dat_o(wbm_dat_o),              // DAT_O() data out
    .wbm_we_i (wbm_we_i),               // WE_I write enable input
    .wbm_sel_i(wbm_sel_i),              // SEL_I() select input
    .wbm_stb_i(wbm_stb_i),              // STB_I strobe input
    .wbm_ack_o(wbm_ack_o),              // ACK_O acknowledge output
    .wbm_cyc_i(wbm_cyc_i),              // CYC_I cycle i    nput

    // First slave
    .wbs0_adr_o(wbs0_adr_o),            // ADR_O() address output
    .wbs0_dat_i(wbs0_dat_i),            // DAT_I() data in
    .wbs0_dat_o(wbs0_dat_o),            // DAT_O() data out
    .wbs0_we_o (wbs0_we_o),             // WE_O write enable output
    .wbs0_sel_o(wbs0_sel_o),            // SEL_O() select output
    .wbs0_stb_o(wbs0_stb_o),            // STB_O strobe output
    .wbs0_ack_i(wbs0_ack_i),            // ACK_I acknowledge input
    .wbs0_cyc_o(wbs0_cyc_o),            // CYC_O cycle output
    .wbs0_err_i(1'b0),                  // ERR_I error input
    .wbs0_rty_i(1'b0),                  // RTY_I retry input

    // Second slave 
    .wbs1_adr_o(wbs1_prereg_adr),       // ADR_O() address output
    .wbs1_dat_i(wbs1_prereg_dat_i),     // DAT_I() data in
    .wbs1_dat_o(wbs1_prereg_dat_o),     // DAT_O() data out
    .wbs1_we_o (wbs1_prereg_we),        // WE_O write enable output
    .wbs1_sel_o(wbs1_prereg_sel),       // SEL_O() select output
    .wbs1_stb_o(wbs1_prereg_stb),       // STB_O strobe output
    .wbs1_ack_i(wbs1_prereg_ack),       // ACK_I acknowledge input
    .wbs1_cyc_o(wbs1_prereg_cyc),       // CYC_O cycle output
    .wbs1_err_i(1'b0),                  // ERR_I error input
    .wbs1_rty_i(1'b0),                  // RTY_I retry input

    // Third slave 
    .wbs2_adr_o(wbs2_prereg_adr),       // ADR_O() address output
    .wbs2_dat_i(wbs2_prereg_dat_i),     // DAT_I() data in
    .wbs2_dat_o(wbs2_prereg_dat_o),     // DAT_O() data out
    .wbs2_we_o (wbs2_prereg_we),        // WE_O write enable output
    .wbs2_sel_o(wbs2_prereg_sel),       // SEL_O() select output
    .wbs2_stb_o(wbs2_prereg_stb),       // STB_O strobe output
    .wbs2_ack_i(wbs2_prereg_ack),       // ACK_I acknowledge input
    .wbs2_cyc_o(wbs2_prereg_cyc),       // CYC_O cycle output
    .wbs2_err_i(1'b0),                  // ERR_I error input
    .wbs2_rty_i(1'b0),                  // RTY_I retry input

    // Fourth slave 
    .wbs3_adr_o(wbs3_prereg_adr),       // ADR_O() address output
    .wbs3_dat_i(wbs3_prereg_dat_i),     // DAT_I() data in
    .wbs3_dat_o(wbs3_prereg_dat_o),     // DAT_O() data out
    .wbs3_we_o (wbs3_prereg_we),        // WE_O write enable output
    .wbs3_sel_o(wbs3_prereg_sel),       // SEL_O() select output
    .wbs3_stb_o(wbs3_prereg_stb),       // STB_O strobe output
    .wbs3_ack_i(wbs3_prereg_ack),       // ACK_I acknowledge input
    .wbs3_cyc_o(wbs3_prereg_cyc),       // CYC_O cycle output
    .wbs3_err_i(1'b0),                  // ERR_I error input
    .wbs3_rty_i(1'b0)                   // RTY_I retry input
);

// Register all slave busses but 0th after the switch
wb_reg #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .SELECT_WIDTH(SELECT_WIDTH)
) reg_s1 (
    .clk(wb_clk_i),
    .rst(wb_rst_i),

    .wbm_adr_i(wbs1_prereg_adr),    // ADR_I() address
    .wbm_dat_i(wbs1_prereg_dat_o),  // DAT_I() data in
    .wbm_dat_o(wbs1_prereg_dat_i),  // DAT_O() data out
    .wbm_we_i (wbs1_prereg_we),     // WE_I write enable input
    .wbm_sel_i(wbs1_prereg_sel),    // SEL_I() select input
    .wbm_stb_i(wbs1_prereg_stb),    // STB_I strobe input
    .wbm_ack_o(wbs1_prereg_ack),    // ACK_O acknowledge output
    .wbm_cyc_i(wbs1_prereg_cyc),    // CYC_I cycle input

    .wbs_adr_o(wbs1_adr_o),         // ADR_O() address
    .wbs_dat_i(wbs1_dat_i),         // DAT_I() data in
    .wbs_dat_o(wbs1_dat_o),         // DAT_O() data out
    .wbs_we_o (wbs1_we_o),          // WE_O write enable output
    .wbs_sel_o(wbs1_sel_o),         // SEL_O() select output
    .wbs_stb_o(wbs1_stb_o),         // STB_O strobe output
    .wbs_ack_i(wbs1_ack_i),         // ACK_I acknowledge input
    .wbs_cyc_o(wbs1_cyc_o),         // CYC_O cycle output
    .wbs_err_i(1'b0),               // ERR_I error input
    .wbs_rty_i(1'b0)                // RTY_I retry input
);

wb_reg #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .SELECT_WIDTH(SELECT_WIDTH)
) reg_s2 (
    .clk(wb_clk_i),
    .rst(wb_rst_i),

    .wbm_adr_i(wbs2_prereg_adr),    // ADR_I() address
    .wbm_dat_i(wbs2_prereg_dat_o),  // DAT_I() data in
    .wbm_dat_o(wbs2_prereg_dat_i),  // DAT_O() data out
    .wbm_we_i (wbs2_prereg_we),     // WE_I write enable input
    .wbm_sel_i(wbs2_prereg_sel),    // SEL_I() select input
    .wbm_stb_i(wbs2_prereg_stb),    // STB_I strobe input
    .wbm_ack_o(wbs2_prereg_ack),    // ACK_O acknowledge output
    .wbm_cyc_i(wbs2_prereg_cyc),    // CYC_I cycle input

    .wbs_adr_o(wbs2_adr_o),         // ADR_O() address
    .wbs_dat_i(wbs2_dat_i),         // DAT_I() data in
    .wbs_dat_o(wbs2_dat_o),         // DAT_O() data out
    .wbs_we_o (wbs2_we_o),          // WE_O write enable output
    .wbs_sel_o(wbs2_sel_o),         // SEL_O() select output
    .wbs_stb_o(wbs2_stb_o),         // STB_O strobe output
    .wbs_ack_i(wbs2_ack_i),         // ACK_I acknowledge input
    .wbs_cyc_o(wbs2_cyc_o),         // CYC_O cycle output
    .wbs_err_i(1'b0),               // ERR_I error input
    .wbs_rty_i(1'b0)                // RTY_I retry input
);

wb_reg #(
    .DATA_WIDTH(DATA_WIDTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .SELECT_WIDTH(SELECT_WIDTH)
) reg_s3 (
    .clk(wb_clk_i),
    .rst(wb_rst_i),

    .wbm_adr_i(wbs3_prereg_adr),    // ADR_I() address
    .wbm_dat_i(wbs3_prereg_dat_o),  // DAT_I() data in
    .wbm_dat_o(wbs3_prereg_dat_i),  // DAT_O() data out
    .wbm_we_i (wbs3_prereg_we),     // WE_I write enable input
    .wbm_sel_i(wbs3_prereg_sel),    // SEL_I() select input
    .wbm_stb_i(wbs3_prereg_stb),    // STB_I strobe input
    .wbm_ack_o(wbs3_prereg_ack),    // ACK_O acknowledge output
    .wbm_cyc_i(wbs3_prereg_cyc),    // CYC_I cycle input

    .wbs_adr_o(wbs3_adr_o),         // ADR_O() address
    .wbs_dat_i(wbs3_dat_i),         // DAT_I() data in
    .wbs_dat_o(wbs3_dat_o),         // DAT_O() data out
    .wbs_we_o (wbs3_we_o),          // WE_O write enable output
    .wbs_sel_o(wbs3_sel_o),         // SEL_O() select output
    .wbs_stb_o(wbs3_stb_o),         // STB_O strobe output
    .wbs_ack_i(wbs3_ack_i),         // ACK_I acknowledge input
    .wbs_cyc_o(wbs3_cyc_o),         // CYC_O cycle output
    .wbs_err_i(1'b0),               // ERR_I error input
    .wbs_rty_i(1'b0)                // RTY_I retry input
);


endmodule
