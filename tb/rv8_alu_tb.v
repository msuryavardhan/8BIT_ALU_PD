`timescale 1ns/1ps

module rv8_alu_tb;

    reg        clk;
    reg        rst;
    reg [7:0]  rs1;
    reg [7:0]  rs2;
    reg [2:0]  alu_op;

    wire [7:0] result;
    wire       zero;
    wire       carry;
    wire       overflow;
    wire       negative;

    // Instantiate DUT
    rv8_alu dut (
        .clk(clk),
        .rst(rst),
        .rs1(rs1),
        .rs2(rs2),
        .alu_op(alu_op),
        .result(result),
        .zero(zero),
        .carry(carry),
        .overflow(overflow),
        .negative(negative)
    );

    // Clock: 10 ns period
    always #5 clk = ~clk;

    // Apply one ALU operation
    task test_operation;
        input [7:0] a;
        input [7:0] b;
        input [2:0] op;
        input [7:0] expected;
        begin
            @(negedge clk);

            rs1    = a;
            rs2    = b;
            alu_op = op;

            @(posedge clk);
            #1;
	    @(posedge clk);
	    #1;

            $display(
                "TIME=%0t | OP=%03b | RS1=%0d | RS2=%0d | RESULT=%0d | EXPECTED=%0d | ZERO=%b | CARRY=%b | OVERFLOW=%b | NEGATIVE=%b",
                $time, op, a, b, result, expected,
                zero, carry, overflow, negative
            );

            if (result !== expected)
                $display("ERROR: Expected %0d, got %0d", expected, result);
            else
                $display("PASS");
        end
    endtask

    initial begin
	$dumpfile("rv8_alu.vcd");
	$dumpvars(0, rv8_alu_tb);

        // Initial values
        clk   = 0;
        rst   = 1;
        rs1   = 0;
        rs2   = 0;
        alu_op = 0;

        // Reset
        #12;
        rst = 0;

        // ADD: 10 + 5 = 15
        test_operation(8'd10, 8'd5, 3'b000, 8'd15);

        // SUB: 10 - 5 = 5
        test_operation(8'd10, 8'd5, 3'b001, 8'd5);

        // AND
        test_operation(8'b10101010, 8'b11001100, 3'b010, 8'b10001000);

        // OR
        test_operation(8'b10101010, 8'b11001100, 3'b011, 8'b11101110);

        // XOR
        test_operation(8'b10101010, 8'b11001100, 3'b100, 8'b01100110);

        // SLL: 3 << 2 = 12
        test_operation(8'd3, 8'd2, 3'b101, 8'd12);

        // SRL: 136 >> 2 = 34
        test_operation(8'd136, 8'd2, 3'b110, 8'd34);

        // SLT signed: -1 < 5
        test_operation(8'hFF, 8'd5, 3'b111, 8'd1);

        $display("======================================");
        $display("        ALL TESTS COMPLETED");
        $display("======================================");

        $finish;
    end

endmodule
