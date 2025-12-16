//=======================================================
// UART2GPI TESTBENCH
// Zedulo
// 6-byte protocol: UART, GPIO, PWM, I2C
//=======================================================

`timescale 1ns/1ps

`ifndef UART2GPIO_WRAPPED
    `define UART2GPIO_MOD uart2gpio
`else
    `define UART2GPIO_MOD chip_wrapper_uart2gpi
`endif

module uart2gpi_tb;

    //=========================================
    // Parameters (changed for 20MHz clk as set in Librelane config)
    //==============================
    localparam CLK_PERIOD_NS = 50;  // 20 MHz
    localparam BAUD_RATE     = 46080; //115200;
    localparam BIT_PERIOD_NS = 1_000_000_000 / BAUD_RATE;  // ~21701ns
    
    // IP Select Code
    localparam [6:0] IP_UART = 7'h7F;
    localparam [6:0] IP_GPIO = 7'h01;
    localparam [6:0] IP_I2C = 7'h03;
    localparam [6:0] IP_PWM = 7'h02;
    
    // UART Register Offsets
    localparam [7:0] UART_CTRL_ADDR   = 8'h10;
    localparam [7:0] UART_STATUS_ADDR = 8'h14;

    // GPIO OFFSETS
    localparam [7:0] GPIO_DIRECT_OUT = 8'h14; 
    localparam [7:0] GPIO_DIRECT_OE  = 8'h20;
    localparam [7:0] GPIO_DATA_IN    = 8'h10;

    // I2C OFFSET
    localparam [7:0] I2C_STATUS_OFFSET       = 8'h14;
    localparam [7:0] I2C_CTRL_OFFSET         = 8'h10;
    localparam [7:0] I2C_FIFO_CTRL_OFFSET    = 8'h20;
    localparam [7:0] I2C_TIMING0_OFFSET      = 8'h3C;
    localparam [7:0] I2C_TIMING1_OFFSET      = 8'h40;
    localparam [7:0] I2C_TIMING2_OFFSET      = 8'h44;
    localparam [7:0] I2C_TIMING3_OFFSET      = 8'h48;
    localparam [7:0] I2C_TIMING4_OFFSET      = 8'h4C;

    // PWM OFFSET
    localparam [7:0] PWM_CFG_OFFSET = 8'h00;
    localparam [7:0] PWM_PWM_EN_OFFSET = 8'h04;
    localparam [7:0] PWM_DUTY_CYCLE_0_OFFSET = 8'h14;

    //=========================================
    // DUT Signals
    //=========================================
    logic        clk_i;
    logic        rst_ni;
    
    // UART
    logic        uart_rx_i;
    logic        uart_tx_o;
    
    // GPIO
    logic [3:0]  gpio_i;
    logic [3:0]  gpio_o;
    logic [3:0]  gpio_oe;
    
    // PWM
    logic [1:0]  pwm_o;
    
    // I2C
    logic        i2c_scl_i;
    logic        i2c_scl_o;
    logic        i2c_scl_oe;
    logic        i2c_sda_i;
    logic        i2c_sda_o;
    logic        i2c_sda_oe;

    logic [31:0] tx_data;

    // For chip-integrated testbench
    logic        test_success = 1'b0;

    //=================================
    // Clock Generation - 50 MHz
    //==============================
    initial begin
        clk_i = 1'b0;
        forever #(CLK_PERIOD_NS / 2) clk_i = ~clk_i;
    end

    //==============================
    // DUT Instantiation
    //=======================
    `UART2GPIO_MOD u_dut (
        .clk_i      (clk_i),
        .rst_ni     (rst_ni),

        .uart_rx_i  (uart_rx_i),
        .uart_tx_o  (uart_tx_o),

        .gpio_i     (gpio_i),
        .gpio_o     (gpio_o),
        .gpio_oe    (gpio_oe),

        .pwm_o      (pwm_o),

        .i2c_scl_i  (i2c_scl_i),
        .i2c_scl_o  (i2c_scl_o),
        .i2c_scl_oe (i2c_scl_oe),
        .i2c_sda_i  (i2c_sda_i),
        .i2c_sda_o  (i2c_sda_o),
        .i2c_sda_oe (i2c_sda_oe)
    );

    //=========================================
    // UART TX Task - Send one byte to DUT
    //=========================================
    task uart_send_byte(input [7:0] data);
        integer i;
        begin
            // Start bit
            uart_rx_i = 1'b0;
            #(BIT_PERIOD_NS);
            
            // Data bits
            for (i = 0; i < 8; i = i + 1) begin
                uart_rx_i = data[i];
                #(BIT_PERIOD_NS);
            end
            
            // Stop bi
            uart_rx_i = 1'b1;
            #(BIT_PERIOD_NS);
        end
    endtask

    //=========================================
    // UART RX Task - Receive one byte from DUT
    //====================================
    task uart_recv_byte(output [7:0] data);
        integer i;
        begin
            data = 8'h00;
            
            // Wait for start bit
            @(negedge uart_tx_o);
            
            // Wait half bit period to sample in middle
            #(BIT_PERIOD_NS / 2);
            
            // Verify start bit is LOW
            if (uart_tx_o !== 1'b0) begin
                $display("[ERROR] Invalid start bit detected!");
            end
            
            // Sample 8 data bits
            for (i = 0; i < 8; i = i + 1) begin
                #(BIT_PERIOD_NS);
                data[i] = uart_tx_o;
            end
            
            // Wait through stop bit
            #(BIT_PERIOD_NS);
        end
    endtask

    //=========================================
    // Send 6-byte Command Packet
    //==================================
    task send_command(
        input [6:0]  ip_select,
        input [7:0]  addr,
        input [31:0] data,
        input        is_read
    );
        logic [7:0] cmd_byte;
        begin
            // command byte: [7]=R/W, [6:0]=IP Select
            cmd_byte = {is_read, ip_select};
            
            $display("[TX] CMD=0x%02X ADDR=0x%02X DATA=0x%08X (%s)",
                     cmd_byte, addr, data, is_read ? "READ" : "WRITE");
            
            // Send 6 bytes: CMD, ADDR, DATA[31:24..7:0]
            uart_send_byte(cmd_byte);
            uart_send_byte(addr);
            uart_send_byte(data[31:24]);
            uart_send_byte(data[23:16]);
            uart_send_byte(data[15:8]);
            uart_send_byte(data[7:0]);
        end
    endtask

    //=========================================
    // Receive 4-byte Response
    //=================================
    task recv_response(output [31:0] data);
        logic [7:0] byte0, byte1, byte2, byte3;
        begin
            uart_recv_byte(byte0);  // MSB
            uart_recv_byte(byte1);
            uart_recv_byte(byte2);
            uart_recv_byte(byte3);  // LSB
            
            data = {byte0, byte1, byte2, byte3};
            $display("[RX] Response = 0x%08X", data);
        end
    endtask

    //=========================================
    // Write Register - No response expecte
    //======================================
    task write_reg(
        input [6:0] ip_addr,
        input [7:0]  addr,
        input [31:0] data
    );
        begin
            send_command(ip_addr, addr, data, 1'b0);
            #(BIT_PERIOD_NS * 2);  // Small gap after write
        end
    endtask

    //=========================================
    // Read Register - Waits for 4-byte response
    //=======================================
    task read_reg(
        input [6:0] ip_addr,
        input  [7:0]  addr,
        output [31:0] data
    );
        begin
            send_command(ip_addr, addr, 32'h0, 1'b1);
            recv_response(data);
        end
    endtask

    //=========================================
    // Decode and display UART/I2C status bits
    //=========================================
    task decode_status(input [31:0] status);
        begin
            $display("       [5] RXEMPTY = %b", status[5]);
            $display("       [4] RXIDLE  = %b", status[4]);
            $display("       [3] TXIDLE  = %b", status[3]);
            $display("       [2] TXEMPTY = %b", status[2]);
            $display("       [1] RXFULL  = %b", status[1]);
            $display("       [0] TXFULL  = %b", status[0]);
        end
    endtask

    task decode_status1(input [31:0] status);
        begin
            $display("       [5] RX EMPTY = %b", status[5]);
            $display("       [3] HOST IDLE  = %b", status[3]);
            $display("       [2] FMT EMPTY = %b", status[2]);
            $display("       [1] RX FULL  = %b", status[1]);
            $display("       [0] FMT FULL  = %b", status[0]);
        end
    endtask

    //==============================
    // Test Area
    //=========================
    initial begin
        // VCD dump for waveform viewing
        $dumpfile("uart2gpi_tb.vcd");
        $dumpvars(0, uart2gpi_tb);
        
        // Initialize signals
        rst_ni    = 1'b0;
        uart_rx_i = 1'b1;  // UART idle = HIGH
        gpio_i    = 4'b0000;
        i2c_scl_i = 1'b1;
        i2c_sda_i = 1'b1;
        
        $display("");
        $display("==============================================");
        $display("  uart2gpi Testbench - UART Register Test");
        $display("  Baud: %0d, Bit Period: %0d ns", BAUD_RATE, BIT_PERIOD_NS);
        $display("==============================================");
        
        //=============================================
        // Reset Sequence
        //===========================================
        $display("\n[INFO] Applying reset...");
        #(CLK_PERIOD_NS * 10);
        rst_ni = 1'b1;
        #(CLK_PERIOD_NS * 10);
        
        // Wait for FSM INIT state to complete
        $display("[INFO] Waiting for FSM initialization...");
        #(CLK_PERIOD_NS * 1100);
        
        //=============================================
        // TEST 1.1: Read UART STATUS Register
        //===========================================
        $display("\n--- TEST 1: Read UART STATUS (0x14) ---");
        read_reg(IP_UART, UART_STATUS_ADDR, tx_data);
        $display("[INFO] UART STATUS = 0x%08X", tx_data);
        decode_status(tx_data);
        
        //=============================================
        // TEST 1.2: Read UART CTRL Register
        //===========================================
        $display("\n--- TEST 1.2: Read UART CTRL (0x10) ---");
        read_reg(IP_UART, UART_CTRL_ADDR, tx_data);
        $display("[INFO] UART CTRL = 0x%08X", tx_data);
        
        //=============================================
        // TEST 1.3: Write then Read UART CTRL
        //==========================================
        $display("\n--- TEST 1.3: Write/Read UART CTRL ---");
        
        // Write a new value to CTRL
        $display("[TEST] Writing 0x09700007 to CTRL...");
        write_reg(IP_UART, UART_CTRL_ADDR, 32'h0970_0007);

        #(BIT_PERIOD_NS * 2);
        
        // Read it CTRL
        $display("[TEST] Reading CTRL back...");
        read_reg(IP_UART, UART_CTRL_ADDR, tx_data);
        $display("[INFO] UART CTRL = 0x%08X", tx_data);

        //=============================================
        // TEST 2: GPIO
        //==========================================
        $display("\n--- TEST 2: GPIO");

        $display("Write to GPIO DIRECT_OUT AND DIRECT_OE");
        write_reg(IP_GPIO, GPIO_DIRECT_OUT, 32'hDEAD_BEEF);
        write_reg(IP_GPIO, GPIO_DIRECT_OE, 32'h0000_0001);

        #(BIT_PERIOD_NS * 2);

        $display("Read GPIO DIRECT_OUT");
        read_reg(IP_GPIO, GPIO_DIRECT_OUT, tx_data);
        $display("[INFO] GPIO DIRECT_OUT = 0x%08X", tx_data);

        assert(gpio_o[0] === 1'b1) else $fatal(1, "Incorrect GPIO out value");   // last bit of DEADBEEF

        //=============================================
        // TEST 3: I2C
        //===========================================
        $display("\n--- TEST 3: I2C");

        // read i2c status register
        $display("\n Reading I2C Status");
        read_reg(IP_I2C, I2C_STATUS_OFFSET, tx_data);
        $display("[INFO] I2C STATUS = 0x%08X", tx_data);
        decode_status1(tx_data);

        // write i2c ctrl register
        $display("\n Writing I2C Ctrl to enablw");
        write_reg(IP_I2C, I2C_CTRL_OFFSET, 32'h0000_0019);
       
        #(BIT_PERIOD_NS * 2);

        $display("\n Reading I2C CTRL OFFSET");
        read_reg(IP_I2C, I2C_CTRL_OFFSET, tx_data);
        $display("[INFO] I2C CTRL STATUS = 0x%08X", tx_data);

        $display("\n Reading I2C Status");
        read_reg(IP_I2C, I2C_STATUS_OFFSET, tx_data);
        $display("[INFO] I2C STATUS = 0x%08X", tx_data);
        decode_status1(tx_data);

         //=============================================
        // TEST 4: PWM
        //=============================================
        $display("\n-- Test 4: Test PWM");

        // Read PWM CTRL
        $display("\n Read PWM CTRL");
        read_reg(IP_PWM, PWM_CFG_OFFSET, tx_data);
        $display("[INFO] PWM CTRL = 0x%08X", tx_data);

        // write to duty cycle 0
        $display("\n WRITE PWM duty cycle 0");
        write_reg(IP_PWM, PWM_DUTY_CYCLE_0_OFFSET, 32'h9C40);
        write_reg(IP_PWM, PWM_PWM_EN_OFFSET, 32'h3);
        write_reg(IP_PWM, PWM_CFG_OFFSET, 32'h8000_0001);

        #(BIT_PERIOD_NS * 2);

        // read duty cycle 0
        $display("\n Read PWM DUTY CYCLE");
        read_reg(IP_PWM, PWM_DUTY_CYCLE_0_OFFSET, tx_data);
        $display("[INFO] PWM duty cycle = 0x%08X", tx_data);
        assert(pwm_o === 2'b01) else $fatal(1, "Incorrect PWM out value"); 

        // DONE
        $display("");
        $display("==============================================");
        $display("  Test Complete!");
        $display("============================================");
        $display("");
        
        test_success = 1'b1;
        #(BIT_PERIOD_NS * 10);
        $finish;
    end

endmodule