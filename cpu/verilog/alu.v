`include "lib/opcodes.v"
`timescale 1ns / 1ps

module ALU
 (input      [`W_OPCODE-1:0]  alu_op, //6 bits 
  input      [`W_CPU-1:0]     A,
  input      [`W_CPU-1:0]     B,
  output reg [`W_CPU-1:0]     R,
  output reg overflow,
  output reg isZero); //1 if condition is every output of ALU is 0 

  assign isZero = (R == 0);

  always @* begin
    // $display("ALU: %b %b -> %b", A, B, alu_op);
    case(alu_op)
      `F_ADD, // change all to i-type opcodes and funct codes
      `F_ADDU,
      `ADDI,
      `ADDIU: begin
        {overflow, R} = A+B; //add, addi, addu, addiu
        // $display("ADD: %d = %d + %d", R, A, B);
      end
      `F_SUB,
      `F_SUBU:  begin
        {overflow, R} = A-B;
        // $display("%d - %d = %d", A, B, R);
      end
      `F_XOR,
      `XORI: R = A ^ B;
      `F_SLT,
      `F_SLTU,
      `SLTI: R = A < B; //slti, sltiu, sltu
      `F_AND:  R = A & B; //andi
      // `F_NAND: R = A nand B; 
      `F_NOR:  R = ~(A | B); 
      `F_OR:   R = A | B; //ori
      `F_SLLV,
      `F_SLL:  begin
        R = A << B;
        // $display("SLL: %d = %d << %b", R, A, B);
      end
      `F_SRLV,
      `F_SRL:  R = A >> B;
      `F_SRAV,
      `F_SRA: begin
        // $display("SRA: %d = %d >>> %b", R, A, B);
        R = A >>> B;
      end
      // `NOP: R = 0;
      default: $display("we messed up alu op %b", alu_op);
    endcase
  end

endmodule
