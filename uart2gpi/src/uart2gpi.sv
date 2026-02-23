//=======================================================
//  uart2gpi - UART Bridge to IP Blocks
//  6-byte protocol: GPIO, PWM, I2C, UART
//=======================================================

import uart_reg_pkg::*;
import gpio_reg_pkg::*;
import pwm_reg_pkg::*;
import i2c_reg_pkg::*;
	 
module uart2gpi (
    // Clock and Reset
    input  logic        clk,
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

    //=============================================
    // IP Select Codes, other IP's can be added
    //=============================================
    localparam [6:0] IP_UART = 7'h7F;
    localparam [6:0] IP_GPIO = 7'h01;
    localparam [6:0] IP_PWM  = 7'h02;
    localparam [6:0] IP_I2C  = 7'h03;

    //==========================
    // Signal Declarations
    //=======================
    uart_reg_pkg::uart_reg2hw_t uart_reg2hw;
    uart_reg_pkg::uart_hw2reg_t uart_hw2reg;

    gpio_reg_pkg::gpio_reg2hw_t gpio_reg2hw;
    gpio_reg_pkg::gpio_hw2reg_t gpio_hw2reg;

    //==============================
    // UART Bus Signals
    //==========================
    logic [5:0]  uart_bus_addr;
    logic [31:0] uart_bus_wdata;
    logic        uart_bus_wen;
    logic        uart_bus_ren;
    logic [31:0] uart_bus_rdata;
    logic        uart_bus_ready;

    //================================
    // Shared Peripheral Bus Signals 
    //==================================
    logic [6:0]  periph_bus_addr;
    logic [31:0] periph_bus_wdata;
    logic        periph_bus_wen;
    logic        periph_bus_ren;

    // Per-IP enables 
    logic gpio_wen, gpio_ren;
    logic pwm_wen, pwm_ren;
    logic i2c_wen, i2c_ren;

    // GPIO response
    logic [31:0] gpio_bus_rdata;
    logic        gpio_bus_error;

    // PWM response  
    logic [31:0] pwm_bus_rdata;

    // I2C response
    logic [31:0] i2c_bus_rdata;

    //=======================================================
    // GPIO Physical Pins - Connect to module ports
    //=======================================================
    logic [3:0] gpio_pins_i;
    logic [3:0] gpio_pins_o;
    logic [3:0] gpio_pins_oe;

    // Connect internal signals to module ports
    assign gpio_pins_i = gpio_i;
    assign gpio_o      = gpio_pins_o;
    assign gpio_oe     = gpio_pins_oe;

    //===================================
    // IP Selection and Response Mux
    //=================================
    logic [6:0]  ip_select;
    logic [6:0]  active_ip;
    
    logic [31:0] selected_rdata;
    logic        selected_ready;

    // Gate peripheral enables based on active_ip
    assign gpio_wen = periph_bus_wen & (active_ip == IP_GPIO);
    assign gpio_ren = periph_bus_ren & (active_ip == IP_GPIO);
    assign pwm_wen  = periph_bus_wen & (active_ip == IP_PWM);
    assign pwm_ren  = periph_bus_ren & (active_ip == IP_PWM);
    assign i2c_wen  = periph_bus_wen & (active_ip == IP_I2C);
    assign i2c_ren  = periph_bus_ren & (active_ip == IP_I2C);

    // Response mux
    always_comb begin
        case (active_ip)
            IP_UART: begin
                selected_rdata = uart_bus_rdata;
                selected_ready = uart_bus_ready;
            end
            IP_GPIO: begin
                selected_rdata = gpio_bus_rdata;
                selected_ready = 1'b1;
            end
            IP_PWM: begin
                selected_rdata = pwm_bus_rdata;
                selected_ready = 1'b1;
            end
            IP_I2C: begin
                selected_rdata = i2c_bus_rdata;
                selected_ready = 1'b1;
            end
            default: begin
                selected_rdata = 32'hDEAD_BEEF;
                selected_ready = 1'b1;
            end
        endcase
    end

    //===========================
    // Instances
    //=================================
    
    uart_reg_top u_uart_reg (
        .clk_i   (clk),
        .rst_ni  (rst_ni),
        .addr_i  (uart_bus_addr),
        .wdata_i (uart_bus_wdata),
        .wen_i   (uart_bus_wen),
        .ren_i   (uart_bus_ren),
        .rdata_o (uart_bus_rdata),
        .ready_o (uart_bus_ready),
        .reg2hw  (uart_reg2hw),
        .hw2reg  (uart_hw2reg)
    );

    uart_core u_uart_core (
        .clk_i  (clk),
        .rst_ni (rst_ni),
        .tx     (uart_tx_o),
        .rx     (uart_rx_i),
        .reg2hw (uart_reg2hw),
        .hw2reg (uart_hw2reg)
    );

    gpio_reg_lite #(.AW(7)) u_gpio_reg (
        .clk_i     (clk),
        .rst_ni    (rst_ni),
        .reg_we    (gpio_wen),
        .reg_re    (gpio_ren),
        .reg_addr  (periph_bus_addr),
        .reg_wdata (periph_bus_wdata),
        .reg_be    (4'hF),
        .reg_rdata (gpio_bus_rdata),
        .reg_error (gpio_bus_error),
        .reg2hw    (gpio_reg2hw),
        .hw2reg    (gpio_hw2reg)
    );

    gpio u_gpio (
        .clk_i        (clk),
        .rst_ni       (rst_ni),
        .reg2hw       (gpio_reg2hw),
        .hw2reg       (gpio_hw2reg),
        .cio_gpio_i   (gpio_pins_i),
        .cio_gpio_o   (gpio_pins_o),
        .cio_gpio_en_o(gpio_pins_oe)
    );

    pwm_reg_lite u_pwm (
        .clk      (clk),
        .rst_n    (rst_ni),
        .bus_addr (periph_bus_addr),
        .wdata_i  (periph_bus_wdata),
        .wen_i    (pwm_wen),
        .ren_i    (pwm_ren),
        .rdata_o  (pwm_bus_rdata),
        .reg2hw   (),
        .pwm_out  (pwm_o)
    );

    localparam BlockAw = 7;
    
    i2c_reg_top u_i2c (
        .clk      (clk),
        .rst_n    (rst_ni),
        .bus_addr (periph_bus_addr[BlockAw-1:0]),
        .wdata_i  (periph_bus_wdata),
        .wen_i    (i2c_wen),
        .ren_i    (i2c_ren),
        .rdata_o  (i2c_bus_rdata),
        .reg2hw   (),
        .hw2reg   (),
        // I2C pins - directly directly-driven signals
        .scl_i    (i2c_scl_i),
        .scl_o    (i2c_scl_o),
        .scl_oe   (i2c_scl_oe),
        .sda_i    (i2c_sda_i),
        .sda_o    (i2c_sda_o),
        .sda_oe   (i2c_sda_oe)
    );

    //================================
    // FSM
    //=====================================
    typedef enum logic [4:0] {
        INIT, 
        WAIT_INIT, 
        IDLE,
        WAIT_STATUS, 
        CHECK_EMPTY,
        READ_DATA, 
        WAIT_DATA, 
        CAPTURE,
        EXECUTE,
        DO_READ, 
        WAIT_READ,
        DO_WRITE, 
        WAIT_WRITE,
        TX_CHECK_FIFO,
        TX_WRITE,
        TX_WAIT_ACK,
        TX_NEXT
    } state_t;
    
    state_t state, next_state;

    //========================
    // Registers
    //================================
    logic [2:0]  byte_count;
    logic [7:0]  cmd_byte;
    logic [7:0]  addr_byte;
    logic [31:0] data_word;
    logic [31:0] response_word;
    logic [2:0]  tx_byte_count;
    logic        is_read;
    logic [9:0]  init_counter;
    logic [31:0] latched_uart_rdata;

    wire uart_rx_empty = uart_hw2reg.status.rxempty.d;
    wire uart_tx_full  = uart_hw2reg.status.txfull.d;

    //=======================
    // TX Byte Mux
    //=====================
    logic [7:0] tx_byte_data;
    always_comb begin
        case (tx_byte_count[1:0])
            2'd0: tx_byte_data = response_word[31:24];
            2'd1: tx_byte_data = response_word[23:16];
            2'd2: tx_byte_data = response_word[15:8];
            2'd3: tx_byte_data = response_word[7:0];
        endcase
    end

    //=============================
    // FSM Sequential Logic
    //===============================
    always_ff @(posedge clk or negedge rst_ni) begin
        if (!rst_ni) begin
            state              <= INIT;
            byte_count         <= 3'd0;
            uart_bus_addr      <= 6'h0;
            uart_bus_wdata     <= 32'h0;
            uart_bus_wen       <= 1'b0;
            uart_bus_ren       <= 1'b0;
            periph_bus_addr    <= 7'h0;
            periph_bus_wdata   <= 32'h0;
            periph_bus_wen     <= 1'b0;
            periph_bus_ren     <= 1'b0;
            cmd_byte           <= 8'h0;
            addr_byte          <= 8'h0;
            data_word          <= 32'h0;
            response_word      <= 32'h0;
            tx_byte_count      <= 3'd0;
            is_read            <= 1'b0;
            ip_select          <= 7'h0;
            active_ip          <= 7'h0;
            init_counter       <= 10'h0;
            latched_uart_rdata <= 32'h0;
        end else begin
            state <= next_state;
            
            // Default: deassert strobes
            uart_bus_wen   <= 1'b0;
            uart_bus_ren   <= 1'b0;
            periph_bus_wen <= 1'b0;
            periph_bus_ren <= 1'b0;
            
            case (state)
                INIT: begin
                    if (init_counter == 10'd0) begin
                        uart_bus_addr  <= uart_reg_pkg::UART_CTRL_OFFSET;
                        uart_bus_wdata <= 32'h0970_0003;
                        uart_bus_wen   <= 1'b1;
                        init_counter   <= 10'd1;
                    end else if (init_counter < 10'd1000) begin
                        init_counter <= init_counter + 10'd1;
                    end
                end

                IDLE: begin
                    uart_bus_addr <= uart_reg_pkg::UART_STATUS_OFFSET;
                    uart_bus_ren  <= 1'b1;
                end
                
                CHECK_EMPTY: begin
                    if (!uart_bus_rdata[5]) begin
                        uart_bus_addr <= uart_reg_pkg::UART_RDATA_OFFSET;
                        uart_bus_ren  <= 1'b1;
                    end
                end

                WAIT_DATA: begin
                    if (uart_bus_ready) begin
                        latched_uart_rdata <= uart_bus_rdata;
                    end
                end
                
                CAPTURE: begin
                    case (byte_count)
                        3'd0: begin
                            cmd_byte   <= latched_uart_rdata[7:0];
                            is_read    <= latched_uart_rdata[7];
                            ip_select  <= latched_uart_rdata[6:0];
                            byte_count <= 3'd1;
                        end
                        3'd1: begin
                            addr_byte  <= latched_uart_rdata[7:0];
                            byte_count <= 3'd2;
                        end
                        3'd2: begin
                            data_word[31:24] <= latched_uart_rdata[7:0];
                            byte_count <= 3'd3;
                        end
                        3'd3: begin
                            data_word[23:16] <= latched_uart_rdata[7:0];
                            byte_count <= 3'd4;
                        end
                        3'd4: begin
                            data_word[15:8] <= latched_uart_rdata[7:0];
                            byte_count <= 3'd5;
                        end
                        3'd5: begin
                            data_word[7:0] <= latched_uart_rdata[7:0];
                            byte_count <= 3'd0;
                        end
                        default: byte_count <= 3'd0;
                    endcase
                end
                
                EXECUTE: begin
                    active_ip <= ip_select;
                    
                    case (ip_select)
                        IP_UART: begin
                            if (is_read) begin
                                uart_bus_addr <= {2'b00, addr_byte[5:2], 2'b00};
                                uart_bus_ren  <= 1'b1;
                            end else begin
                                uart_bus_addr  <= {2'b00, addr_byte[5:2], 2'b00};
                                uart_bus_wdata <= data_word;
                                uart_bus_wen   <= 1'b1;
                            end
                        end
                        
                        IP_GPIO, IP_PWM, IP_I2C: begin
                            periph_bus_addr  <= {1'b0, addr_byte[5:0]};
                            periph_bus_wdata <= data_word;
                            if (is_read)
                                periph_bus_ren <= 1'b1;
                            else
                                periph_bus_wen <= 1'b1;
                        end
                        
                        default: ;
                    endcase
                end
                
                DO_READ: begin
                    case (active_ip)
                        IP_UART: uart_bus_ren   <= 1'b1;
                        IP_GPIO,
                        IP_PWM,
                        IP_I2C:  periph_bus_ren <= 1'b1;
                        default: ;
                    endcase
                end

                WAIT_READ: begin
                    if (!selected_ready) begin
                        case (active_ip)
                            IP_UART: uart_bus_ren   <= 1'b1;
                            IP_GPIO,
                            IP_PWM,
                            IP_I2C:  periph_bus_ren <= 1'b1;
                            default: ;
                        endcase
                    end

                    if (selected_ready) begin
                        response_word <= selected_rdata;
                        tx_byte_count <= 3'd0;
                    end
                end

                TX_CHECK_FIFO: begin
                    // Waiting for FIFO space
                end

                TX_WRITE: begin
                    uart_bus_addr  <= uart_reg_pkg::UART_WDATA_OFFSET;
                    uart_bus_wdata <= {24'h0, tx_byte_data};
                    uart_bus_wen   <= 1'b1;
                end
                
                TX_NEXT: begin
                    tx_byte_count <= tx_byte_count + 3'd1;
                end
                
                default: ;
            endcase
        end
    end

    //=========================================
    // FSM Next State Logic (Combinational)
    //=========================================
    always_comb begin
        next_state = state;
        
        case (state)
            INIT:        next_state = (init_counter >= 10'd999) ? WAIT_INIT : INIT;
            WAIT_INIT:   next_state = IDLE;
 
            IDLE:        next_state = WAIT_STATUS; 
            
            WAIT_STATUS: next_state = (uart_bus_ready) ? CHECK_EMPTY : WAIT_STATUS;
            
            CHECK_EMPTY: next_state = (!uart_bus_rdata[5]) ? READ_DATA : IDLE;
            READ_DATA:   next_state = WAIT_DATA;
            WAIT_DATA:   next_state = (uart_bus_ready) ? CAPTURE : WAIT_DATA;
            
            CAPTURE:     next_state = (byte_count == 3'd5) ? EXECUTE : IDLE;
            
            EXECUTE: begin
                case (ip_select)
                    IP_UART: next_state = (is_read) ? DO_READ : DO_WRITE;
                    IP_GPIO: next_state = (is_read) ? DO_READ : DO_WRITE;
                    IP_PWM:  next_state = (is_read) ? DO_READ : DO_WRITE;
                    IP_I2C:  next_state = (is_read) ? DO_READ : DO_WRITE;
                    default: next_state = (is_read) ? DO_READ : IDLE;
                endcase
            end
            
            DO_READ:    next_state = WAIT_READ;
            WAIT_READ:  next_state = (selected_ready) ? TX_CHECK_FIFO : WAIT_READ;
            
            DO_WRITE:   next_state = WAIT_WRITE;
            WAIT_WRITE: next_state = (selected_ready) ? IDLE : WAIT_WRITE;

            TX_CHECK_FIFO: next_state = (!uart_tx_full) ? TX_WRITE : TX_CHECK_FIFO;
            TX_WRITE:      next_state = TX_WAIT_ACK;
            TX_WAIT_ACK:   next_state = (uart_bus_ready) ? TX_NEXT : TX_WAIT_ACK;

            TX_NEXT: begin
                if (tx_byte_count == 3'd3) 
                    next_state = IDLE;
                else 
                    next_state = TX_CHECK_FIFO;
            end
            
            default: next_state = IDLE;
        endcase
    end

endmodule
