`timescale 1ns / 1ps

module ALUControl(
    input  wire [1:0] ALUOp,
    input  wire [2:0] funct3,
    input  wire       funct7_bit5,   // instruction[30]
    output reg  [3:0] ALUControlOut
);
    always @(*) begin
        case (ALUOp)

            // ?? Load / Store / JALR ??????????????????????????????????
            2'b00: ALUControlOut = 4'b0010;  // Always ADD (address calc)

            // ?? Branch ???????????????????????????????????????????????
            // BEQ / BNE  ? SUB  (check Zero flag for equality)
            // BLT / BGE  ? SLT  (check ALUResult[0] for signed compare)
            2'b01: begin
                case (funct3)
                    3'b000:  ALUControlOut = 4'b0110;  // BEQ  ? SUB
                    3'b001:  ALUControlOut = 4'b0110;  // BNE  ? SUB
                    3'b100:  ALUControlOut = 4'b0111;  // BLT  ? SLT
                    3'b101:  ALUControlOut = 4'b0111;  // BGE  ? SLT
                    default: ALUControlOut = 4'b0110;
                endcase
            end

            // ?? I-type ALU (ADDI, SLTI) ??????????????????????????????
            // SLTI reuses the same SLT hardware as R-type SLT;
            // ALUSrc=1 already routes the sign-extended immediate as B.
            2'b11: begin
                case (funct3)
                    3'b000:  ALUControlOut = 4'b0010;  // ADDI ? ADD
                    3'b010:  ALUControlOut = 4'b0111;  // SLTI ? SLT  (NEW)
                    default: ALUControlOut = 4'b0010;
                endcase
            end

            // ?? R-type ???????????????????????????????????????????????
            2'b10: begin
                case (funct3)
                    3'b000:  ALUControlOut = funct7_bit5 ? 4'b0110 : 4'b0010; // SUB / ADD
                    3'b001:  ALUControlOut = 4'b0100;  // SLL
                    3'b101:  ALUControlOut = 4'b0101;  // SRL
                    3'b100:  ALUControlOut = 4'b0011;  // XOR
                    3'b110:  ALUControlOut = 4'b0001;  // OR
                    3'b111:  ALUControlOut = 4'b0000;  // AND
                    default: ALUControlOut = 4'b0000;
                endcase
            end

            default: ALUControlOut = 4'b0000;
        endcase
    end
endmodule