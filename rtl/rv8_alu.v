module rv8_alu (
    input        clk,
    input        rst,

    input  [7:0]  rs1,
    input  [7:0]  rs2,
    input  [2:0]  alu_op,

    output reg [7:0] result,
    output reg       zero,
    output reg       carry,
    output reg       overflow,
    output reg       negative
);

    // Registered inputs
    reg [7:0] rs1_reg;
    reg [7:0] rs2_reg;
    reg [2:0] alu_op_reg;

    // Combinational ALU signals
    reg [7:0] alu_result;
    reg       alu_carry;
    reg       alu_overflow;

    // Register the inputs
    always @(posedge clk) begin
        if (rst) begin
            rs1_reg   <= 8'b0;
            rs2_reg   <= 8'b0;
            alu_op_reg <= 3'b0;
        end
        else begin
            rs1_reg   <= rs1;
            rs2_reg   <= rs2;
            alu_op_reg <= alu_op;
        end
    end

    // Combinational ALU
    always @(*) begin

        // Default values
        alu_result   = 8'b0;
        alu_carry    = 1'b0;
        alu_overflow = 1'b0;

        case (alu_op_reg)

            // ADD
            3'b000: begin
                {alu_carry, alu_result} = rs1_reg + rs2_reg;

                alu_overflow =
                    (~(rs1_reg[7] ^ rs2_reg[7])) &
                    (alu_result[7] ^ rs1_reg[7]);
            end

            // SUB
            3'b001: begin
                alu_result = rs1_reg - rs2_reg;

                alu_carry = (rs1_reg >= rs2_reg);

                alu_overflow =
                    (rs1_reg[7] ^ rs2_reg[7]) &
                    (alu_result[7] ^ rs1_reg[7]);
            end

            // AND
            3'b010: begin
                alu_result = rs1_reg & rs2_reg;
            end

            // OR
            3'b011: begin
                alu_result = rs1_reg | rs2_reg;
            end

            // XOR
            3'b100: begin
                alu_result = rs1_reg ^ rs2_reg;
            end

            // Shift Left Logical
            3'b101: begin
                alu_result = rs1_reg << rs2_reg[2:0];
            end

            // Shift Right Logical
            3'b110: begin
                alu_result = rs1_reg >> rs2_reg[2:0];
            end

            // Set Less Than (signed)
            3'b111: begin
                if ($signed(rs1_reg) < $signed(rs2_reg))
                    alu_result = 8'b00000001;
                else
                    alu_result = 8'b00000000;
            end

            default: begin
                alu_result   = 8'b0;
                alu_carry    = 1'b0;
                alu_overflow = 1'b0;
            end

        endcase
    end

    // Register the ALU result and flags
    always @(posedge clk) begin
        if (rst) begin
            result   <= 8'b0;
            zero     <= 1'b1;
            carry    <= 1'b0;
            overflow <= 1'b0;
            negative <= 1'b0;
        end
        else begin
            result   <= alu_result;
            zero     <= (alu_result == 8'b0);
            carry    <= alu_carry;
            overflow <= alu_overflow;
            negative <= alu_result[7];
        end
    end

endmodule
