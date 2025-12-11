/*
 * eFuse array behaviour Verilog-2005 model
 */

 `timescale 1ns/1ps
 
 // ugly composition to disable asserts in GL without SDF
 `ifdef GL
    `ifndef ENABLE_SDF
        `define SKIP_ASSERTS
    `endif
 `endif

`ifndef SKIP_ASSERTS
    `define assert(statement) \
            if ($time > 1 && !(statement)) begin \
                $display("ASSERTION FAILED in %m on line %d", `__LINE__); \
                $finish; \
            end
`else
    `define assert(statement)
    `undef SKIP_ASSERTS
`endif

module efuse_array_async_1x8 (
    `ifdef USE_POWER_PINS
    input VDD,
    input VSS,
    `endif
    input  [7:0] COL_PROG_N,
    output [7:0] OUT,
    input  SENSE,
    input  PRESET_N
);

efuse_array_1x8 wrapped_model (
    `ifdef USE_POWER_PINS
    .VDD(VDD),
    .VSS(VSS),
    `endif
    .BIT_SEL(1'b1),
    .COL_PROG_N(COL_PROG_N),
    .OUT(OUT),
    .PRESET_N(PRESET_N),
    .SENSE(SENSE)
);

endmodule

module efuse_array_1x8 #(
    `ifdef EFUSE_MEMORY_INIT
    parameter INIT_FILE_NAME = "efuse_init.hex",
    `endif
    parameter NWORDS = 1,
    parameter WORD_WIDTH = 8
) (
    `ifdef USE_POWER_PINS
    input VDD,
    input VSS,
    `endif
    input  [NWORDS-1:0]     BIT_SEL,
    input  [WORD_WIDTH-1:0] COL_PROG_N,
    input                   PRESET_N,
    input                   SENSE,
    output [WORD_WIDTH-1:0] OUT
);

    localparam STATE_IDLE   = 0;
    localparam STATE_PRESET = 1;
    localparam STATE_SENSE  = 2;
    localparam STATE_WRITE  = 3;

    // times in ns
    localparam MIN_PRESET_NS    = 1;
    localparam MIN_SENSE_NS     = 3;
    localparam MIN_WRITE_NS     = 1000;

    reg [WORD_WIDTH-1:0] fuses [NWORDS-1:0];    // memory

    reg [WORD_WIDTH-1:0] out;
    reg [NWORDS-1:0] sel;
    reg [WORD_WIDTH-1:0] prog;
    reg preset = 1'b0;
    integer state = STATE_IDLE;
    reg [63:0] timestamp = 0;

    assign OUT = out;

    initial begin
        `ifndef EFUSE_MEMORY_INIT
            // set array to all zeroes on start
            integer i;
            for (i = 0; i < NWORDS; i = i + 1) begin
                fuses[i] = {WORD_WIDTH{1'b0}};
            end
        `else
            // init from file
            $readmemh(INIT_FILE_NAME, fuses);
        `endif
    end

    integer i, ones;

    always @(*) begin

        ones = 0;

        if (PRESET_N === 1'b0) begin
            // preset
            `assert(state == STATE_IDLE || state == STATE_PRESET)
            `assert(COL_PROG_N === {WORD_WIDTH{1'b1}})
            if (state == STATE_IDLE)
                timestamp = $time;
            preset = 1'b1;
            state = STATE_PRESET;
        end else if (SENSE === 1'b1) begin
            // read
            `assert(preset == 1'b1)
            `assert(state == STATE_IDLE || state == STATE_PRESET || state == STATE_SENSE)
            `assert(COL_PROG_N === {WORD_WIDTH{1'b1}})
            `assert(state == STATE_IDLE || sel == 0 || sel == BIT_SEL)

            out = fuses[0];
            
            state = STATE_SENSE;
        end else if (COL_PROG_N != {WORD_WIDTH{1'b1}}) begin
            // write
            `assert(state == STATE_IDLE || state == STATE_WRITE)
            `ifndef ENABLE_SDF
            // `assert(state == STATE_IDLE || (prog == COL_PROG_N && sel == BIT_SEL))
            `else
            // TODO: proper width check for timing simulation
            `endif
            sel = BIT_SEL;
            prog = COL_PROG_N;
            if (state == STATE_IDLE)
                timestamp = $time;

            fuses[0] = fuses[0] | (~COL_PROG_N);

            state = STATE_WRITE;
        end else begin
            // idle after active states, check signal hold times
            if (state == STATE_PRESET) begin
                `assert($time - timestamp >= MIN_PRESET_NS)
            end else if (state == STATE_WRITE) begin
                `assert($time - timestamp >= MIN_WRITE_NS)
            end else if (state == STATE_SENSE) begin
                `assert($time - timestamp >= MIN_SENSE_NS)
                preset = 1'b0;
            end 
            
            sel = BIT_SEL;
            prog = COL_PROG_N;
            state = STATE_IDLE;
        end
    end
    
endmodule
