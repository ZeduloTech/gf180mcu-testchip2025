/*
 * eFuse array behaviour Verilog-2005 model
 */

 `timescale 1ns/1ps

`ifndef EFUSE_ARRAY_NAME
`define EFUSE_ARRAY_NAME efuse_array_64x8
`endif

`define assert(statement) \
        if ($time > 1 && !(statement)) begin \
            $display("ASSERTION FAILED in %m on line %d", `__LINE__); \
            $finish; \
        end

module `EFUSE_ARRAY_NAME #(
    parameter NWORDS = 64,
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
    localparam MIN_PRESET_NS    = 5;
    localparam MIN_SENSE_NS     = 10;
    localparam MIN_WRITE_NS     = 1000;

    reg [WORD_WIDTH-1:0] fuses [NWORDS-1:0];    // memory

    reg [WORD_WIDTH-1:0] out;
    reg [NWORDS-1:0] sel;
    reg [WORD_WIDTH-1:0] prog;
    reg preset = 1'b0;
    integer state = STATE_IDLE;
    reg [63:0] timestamp = 0;

    assign OUT = out;

    // set array to all zeroes on start
    initial begin
        integer i;
        for (i = 0; i < NWORDS; i = i + 1) begin
            fuses[i] = {WORD_WIDTH{1'b0}};
        end
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
            `assert(state == STATE_IDLE || state == STATE_PRESET || state == STATE_SENSE)
            `assert(COL_PROG_N === {WORD_WIDTH{1'b1}})
            `assert(state == STATE_IDLE || sel == 0 || sel == BIT_SEL)

            if (BIT_SEL != 0 && sel == 0) begin
                timestamp = $time;
                for (i = 0; i < NWORDS; i = i + 1)
                    if (BIT_SEL[i]) begin
                        out = fuses[i];
                        ones = ones + 1;
                    end
                `assert(ones == 1)
            end
            sel = BIT_SEL;
            
            state = STATE_SENSE;
        end else if (COL_PROG_N != {WORD_WIDTH{1'b1}}) begin
            // write
            `assert(state == STATE_IDLE || state == STATE_WRITE)
            `ifndef ENABLE_SDF
            `assert(state == STATE_IDLE || (prog == COL_PROG_N && sel == BIT_SEL))
            `else
            // TODO: proper width check for timing simulation
            `endif
            sel = BIT_SEL;
            prog = COL_PROG_N;
            if (state == STATE_IDLE)
                timestamp = $time;

            for (i = 0; i < NWORDS; i = i + 1)
                if (BIT_SEL[i]) begin
                    fuses[i] = fuses[i] | (~COL_PROG_N);
                    ones = ones + 1;
                end
            `assert(ones == 1)

            state = STATE_WRITE;
        end else begin
            // idle after active states, check signal hold times
            if (state == STATE_PRESET)
                `assert($time - timestamp >= MIN_PRESET_NS)
            else if (state == STATE_WRITE)
                `assert($time - timestamp >= MIN_WRITE_NS)
            else if (state == STATE_SENSE) begin
                `assert($time - timestamp >= MIN_SENSE_NS)
                `assert(preset == 1'b1)
                preset = 1'b0;
            end 
            
            sel = BIT_SEL;
            prog = COL_PROG_N;
            state = STATE_IDLE;
        end
    end
    
endmodule
