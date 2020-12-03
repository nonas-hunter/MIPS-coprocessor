`include "lib/opcodes.v"
`include "lib/debug.v"
`timescale 1ns / 1ps

module FETCH 
 (input                      clk,
  input                      rst,
  input      [`W_PC_SRC-1:0] pc_src,
  input      [`W_EN-1:0]     branch_ctrl,
  input      [`W_CPU-1:0]    reg_addr,
  input      [`W_JADDR-1:0]  jump_addr,
  input      [`W_IMM-1:0]    imm_addr,
  input                      isZero,
  input                      checkZero,
  output reg [`W_CPU-1:0]    pc_next);
  
  wire [`W_PC_UPPER-1:0] pc_upper;
  assign pc_upper = pc_next[`PC_UPPER];

  always @* begin
    // $display("imm %x", imm_addr);
  end

  always @(posedge clk, posedge rst) begin
    if (rst) begin
      pc_next <= `W_CPU'd0;
    end
    else begin
      case(pc_src) 
        // Make sure you're very careful here!!
        // You need to add more cases here
        `PC_SRC_REGF: begin
          pc_next <= reg_addr;
        end
        `PC_SRC_JUMP: begin
          pc_next <= {pc_upper, jump_addr, 2'b0};
        end
        `PC_SRC_BRCH: begin
          // $display("branch now");
          if(isZero == checkZero) begin
            pc_next <= pc_next + (imm_addr*4) + 4;
          end else begin
            pc_next <= pc_next + 4; 
          end
        end
        // `PC_SRC_BRCH: begin
        //   // $display("branch? %d %d", isZero, checkZero);
        //   if(isZero == checkZero) begin
        //     // $display("go here %d", imm_addr);
        //     // $display("old pc next %d", pc_next);
        //     pc_next <= pc_next + imm_addr << 2;
        //     // $display("new pc next %d", pc_next);
        //   end else begin
        //     pc_next <= pc_next + 4;
        //   end
        //   // use iszero and branch ctrl to determin pc_next
        // end
        `PC_SRC_NEXT: pc_next <= pc_next + 4; 
        default: $display("pc src not yet implemented");
      endcase
      if (`DEBUG_PC && ~rst) 
        $display("-- PC, PC/4 = %x, %d",pc_next,pc_next/4); 
    end
  end
endmodule

