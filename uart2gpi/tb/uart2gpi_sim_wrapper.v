// Simulation wrapper around chip_top to test UART2GPI in cocotb

`default_nettype none
`include "pinout.vh"
`include "defines.v"
    
module chip_wrapper_uart2gpi #(
    parameter NUM_INPUT_PADS = 12,
    parameter NUM_BIDIR_PADS = 42
) (
    // Clock and Reset
    input  logic        clk_i,
    input  logic        rst_ni,

    // UART Interface
    input  logic        uart_rx_i,
    output logic        uart_tx_o,

    // GPIO Interfac
    input  logic [3:0]  gpio_i,
    output logic [3:0]  gpio_o,
    output logic [3:0]  gpio_oe,

    // PWM Outputs
    output logic [1:0]  pwm_o,

    // I2C Interface
    input  logic        i2c_scl_i,
    output logic        i2c_scl_o,
    output logic        i2c_scl_oe,
    input  logic        i2c_sda_i,
    output logic        i2c_sda_o,
    output logic        i2c_sda_oe
);

    wire clock = 1'bz;
    wire resetb = 1'bz;
    supply1 VDD;
    supply0 VSS;
    
    wire [NUM_INPUT_PADS-1:0] in_pads = {1'b0, {(NUM_INPUT_PADS-1){1'bz}}};
    wire [NUM_BIDIR_PADS-1:0] bidir_pads = {NUM_BIDIR_PADS{1'bz}};
    
    assign bidir_pads[`PAD_UART2GPI_UARTRX] = uart_rx_i;
    // not used in test & spoils outputs
    // assign bidir_pads[`PAD_UART2GPI_GPIO3:`PAD_UART2GPI_GPIO0] = gpio_i;
    // assign bidir_pads[`PAD_UART2GPI_I2CSCL] = i2c_scl_i;
    // assign bidir_pads[`PAD_UART2GPI_I2CSDA] = i2c_sda_i;

    assign uart_tx_o = bidir_pads[`PAD_UART2GPI_UARTTX];    
    assign gpio_o = bidir_pads[`PAD_UART2GPI_GPIO3:`PAD_UART2GPI_GPIO0];    
    assign pwm_o = bidir_pads[`PAD_UART2GPI_PWM1:`PAD_UART2GPI_PWM0];    
    assign i2c_scl_o = bidir_pads[`PAD_UART2GPI_I2CSCL];    
    assign i2c_sda_o = bidir_pads[`PAD_UART2GPI_I2CSDA];    


    chip_top chip (
        `ifdef USE_POWER_PINS
        .VDD(VDD),
        .VSS(VSS),
        `endif
    
        .clk_PAD(clk_i),
        .rst_n_PAD(rst_ni),

        .input_PAD(in_pads),
        .bidir_PAD(bidir_pads)
    );
    
    `define CHIP_TOP_HIER chip
    `include "sdf.vh"

endmodule
