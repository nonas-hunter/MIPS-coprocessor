`include "fetch.v"
`include "decode.v"
`include "regfile.v"
`include "alu.v"
`include "memory.v"

`timescale 1ns / 1ps

module SINGLE_CYCLE_CPU
  (input clk,
   input rst);

  reg  [`W_CPU-1:0]       alu_select; 
  wire [`W_CPU-1:0]       alu_out;
  wire                    alu_overflow;
  wire                    alu_is_zero;
  wire [`W_REG-1:0]       wa;
  wire [`W_REG-1:0]       ra1; 
  wire [`W_REG-1:0]       ra2;
  wire [`W_EN-1:0]        reg_wen;
  wire [`W_IMM_EXT-1:0]   imm_ext;
  wire [`W_IMM-1:0]       imm;
  wire [`W_SHAMT-1:0]     sha;
  wire [`W_JADDR-1:0]     addr;
  wire [`W_FUNCT-1:0]     alu_op;
  wire [`W_PC_SRC-1:0]    pc_src;
  wire [`W_MEM_CMD-1:0]   mem_cmd;
  wire [`W_ALU_SRC-1:0]   alu_src;
  wire [`W_REG_SRC-1:0]   reg_src;
  reg  [`W_CPU-1:0]       reg_out_data;
  wire [`W_CPU-1:0]       rd1;
  wire [`W_CPU-1:0]       rd2;
  wire [`W_CPU-1:0]       pc;
  wire [`W_CPU-1:0]       inst;
  wire [`W_EN-1:0]        branch_ctrl;
  wire [`W_CPU-1:0]       reg_addr;
  wire [`W_JADDR-1:0]     jump_addr;
  wire [`W_CPU-1:0]       mem_out;

  // assign alu_select = 0;
  // assign alu_out = 0;
  // assign alu_overflow = 0;
  // assign alu_is_zero = 0;
  // assign wa = 0;
  // assign ra1 = 0;
  // assign ra2 = 0;


  FETCH fetch(clk, rst, pc_src, branch_ctrl, rd1, jump_addr, imm,
            alu_is_zero, check_zero, pc);
  MEMORY stage_MEMORY(clk, rst, pc, inst, mem_cmd, rd2, alu_out, mem_out);
  DECODE decode(inst, wa, ra1, ra2, reg_wen, imm_ext, imm, sha_ext, sha,
            jump_addr, alu_op, pc_src, mem_cmd, alu_src, reg_src, check_zero);
  REGFILE regfile(clk, rst, reg_wen, wa, reg_out_data,
            ra1, ra2, rd1, rd2);
  ALU alu(alu_op, rd1, alu_select, alu_out, alu_overflow, alu_is_zero);

  always @* begin
    case (reg_src)
      `REG_SRC_ALU: reg_out_data = alu_out;
      `REG_SRC_MEM: reg_out_data = mem_out;
      `REG_SRC_PC:  reg_out_data = pc+4;
      default: $display("bad reg_src %b", reg_src);
    endcase
  end

  always @* begin
    case(alu_src)
      `ALU_SRC_REG: alu_select = rd2;
      `ALU_SRC_IMM: alu_select = {{`SIGN_EXT_IMM{imm_ext}}, imm};
      `ALU_SRC_SHA: alu_select = {{`SIGN_EXT_SHA{sha_ext}}, sha};
    endcase
  end

  //SYSCALL Catch
  always @* begin
    if (inst[`FLD_OPCODE] == `OP_ZERO && 
        inst[`FLD_FUNCT]  == `F_SYSCAL) begin
        // $display("s y s c a l l . . . %b", rd1);
        // $display("%d", rd2);
        case(rd1)
          1 : $display("SYSCALL  1: a0 = %d",rd2);
          10: begin
              $display("SYSCALL 10: Exiting...");
              $finish;
            end
          default:;
        endcase
    end
  end
endmodule
