`include "lib/opcodes.v"
`include "lib/debug.v"
`timescale 1ns / 1 ps

module DECODE 
 (input [`W_CPU-1:0] inst,
  
  // Register File control
  output reg [`W_REG-1:0]     wa,      // Register Write Address 
  output reg [`W_REG-1:0]     ra1,     // Register Read Address 1
  output reg [`W_REG-1:0]     ra2,     // Register Read Address 2
  output reg                  reg_wen, // Register Write Enable
  // Immediate
  output reg [`W_IMM_EXT-1:0] imm_ext, // 1-Sign or 0-Zero extend
  output reg [`W_IMM-1:0]     imm,     // Immediate Field
  // Shift Amount
  output reg [`W_IMM_EXT-1:0] sha_ext,
  output reg [`W_SHAMT-1:0]   sha,     // Shift Amount Field
  // Jump Address
  output reg [`W_JADDR-1:0]   addr,    // Jump Addr Field
  // ALU Control
  output reg [`W_FUNCT-1:0]   alu_op,  // ALU OP
  // Muxing
  output reg [`W_PC_SRC-1:0]  pc_src,  // PC Source
  output reg [`W_MEM_CMD-1:0] mem_cmd, // Mem Command
  output reg [`W_ALU_SRC-1:0] alu_src, // ALU Source
  output reg [`W_REG_SRC-1:0] reg_src, // Mem to Reg
  output reg                  check_zero); // Check zero for branching

  // Unconditionally pull some instruction fields
  wire [`W_REG-1:0] rs; 
  wire [`W_REG-1:0] rt; 
  wire [`W_REG-1:0] rd;
  assign rs   = inst[`FLD_RS];
  assign rt   = inst[`FLD_RT];
  assign rd   = inst[`FLD_RD];
  assign imm  = inst[`FLD_IMM];
  assign imm_ext = imm[`SIGN_IMM] ? `IMM_SIGN_EXT : `IMM_ZERO_EXT;
  assign sha  = inst[`FLD_SHAMT];
  assign sha_ext = imm[`SIGN_SHA] ? `IMM_SIGN_EXT : `IMM_ZERO_EXT;
  assign addr = inst[`FLD_ADDR];
  
  // always @(inst) begin
    // if (`DEBUG_DECODE) 
      /* verilator lint_off STMTDLY */
       // Delay Slightly
      // $display("op = %x rs = %x rt = %x rd = %x imm = %x addr = %x",inst[`FLD_OPCODE],rs,rt,rd,imm,addr);
      /* verilator lint_on STMTDLY */
  // end

  always @* begin
    // $display("inst %b", inst);
    // $display("op = %x rs = %x rt = %x rd = %x imm = %x addr = %x",inst[`FLD_OPCODE],rs,rt,rd,imm,addr);
    case(inst[`FLD_OPCODE])
      // Here be dragons.
      // @@@@@@@@@@@@@@@@@@@@@**^^""~~~"^@@^*@*@@**@@@@@@@@@
      // @@@@@@@@@@@@@*^^'"~   , - ' '; ,@@b. '  -e@@@@@@@@@
      // @@@@@@@@*^"~      . '     . ' ,@@@@(  e@*@@@@@@@@@@
      // @@@@@^~         .       .   ' @@@@@@, ~^@@@@@@@@@@@
      // @@@~ ,e**@@*e,  ,e**e, .    ' '@@@@@@e,  "*@@@@@'^@
      // @',e@@@@@@@@@@ e@@@@@@       ' '*@@@@@@    @@@'   0
      // @@@@@@@@@@@@@@@@@@@@@',e,     ;  ~^*^'    ;^~   ' 0
      // @@@@@@@@@@@@@@@^""^@@e@@@   .'           ,'   .'  @
      // @@@@@@@@@@@@@@'    '@@@@@ '         ,  ,e'  .    ;@
      // @@@@@@@@@@@@@' ,&&,  ^@*'     ,  .  i^"@e, ,e@e  @@
      // @@@@@@@@@@@@' ,@@@@,          ;  ,& !,,@@@e@@@@ e@@
      // @@@@@,~*@@*' ,@@@@@@e,   ',   e^~^@,   ~'@@@@@@,@@@
      // @@@@@@, ~" ,e@@@@@@@@@*e*@*  ,@e  @@""@e,,@@@@@@@@@
      // @@@@@@@@ee@@@@@@@@@@@@@@@" ,e@' ,e@' e@@@@@@@@@@@@@
      // @@@@@@@@@@@@@@@@@@@@@@@@" ,@" ,e@@e,,@@@@@@@@@@@@@@
      // @@@@@@@@@@@@@@@@@@@@@@@~ ,@@@,,0@@@@@@@@@@@@@@@@@@@
      // @@@@@@@@@@@@@@@@@@@@@@@@,,@@@@@@@@@@@@@@@@@@@@@@@@@
      // """""""""""""""""""""""""""""""""""""""""""""""""""
      // https://textart.io/art/tag/dragon/1
      `ADDI,
      `ADDIU,
      `ANDI,
      `ORI,
      `SLTI,
      `SLTIU,
      `XORI: begin // i type instructions
        // $display("I type %b", inst[`FLD_OPCODE]);
        wa = rt; ra1 = rs; ra2 = 0; reg_wen = `WREN; mem_cmd = `MEM_NOP;
        alu_src = `ALU_SRC_IMM;  reg_src = `REG_SRC_ALU;
        pc_src  = `PC_SRC_NEXT;  alu_op  = inst[`FLD_OPCODE]; 
      end
      `OP_ZERO: begin
        // zero opcodes are not i type instructions
        case(inst[`FLD_FUNCT])
          `F_SYSCAL: begin
            // $display("NOP/SYSCAL type %b", inst[`FLD_FUNCT]);
            wa = rd; ra1 = `REG_V0; ra2 = `REG_A0; reg_wen = `WDIS; mem_cmd = `MEM_NOP;
            alu_src = `ALU_SRC_REG;  reg_src = `REG_SRC_ALU;
            pc_src  = `PC_SRC_NEXT;  alu_op  = `F_XOR;
          end
          `F_DIV, // stuff we don't care about
          `F_DIVU,
          `F_MFHI,
          `F_MFLO,
          `F_MTHI,
          `F_MTLO,
          `F_MULT,
          `F_MULTU,
          `F_JALR:; // don't care about anything until here
          `F_JR: begin // HEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEEERE!!!!!!!!!!!!!!!!!!!!!!!!!!
            wa = rd; ra1 = rs; ra2 = 0; reg_wen = `WDIS; mem_cmd = `MEM_NOP;
            alu_src = `ALU_SRC_REG;  reg_src = `REG_SRC_ALU;
            pc_src  = `PC_SRC_REGF;  alu_op  = `F_SUB; 
          end
          `F_SLL,
          `F_SRA,
          `F_SRL: begin
            // $display("SHA type %b", inst[`FLD_FUNCT]);
            // $display("SHA %b", sha);
            wa = rd; ra1 = rt; ra2 = rs; reg_wen = `WREN; mem_cmd = `MEM_NOP;
            alu_src = `ALU_SRC_SHA;  reg_src = `REG_SRC_ALU;
            pc_src  = `PC_SRC_NEXT;  alu_op  = inst[`FLD_FUNCT]; 
          end
          `F_SRAV: begin
            // $display("SHA type %b", inst[`FLD_FUNCT]);
            // $display("SHA %b", sha);
            wa = rd; ra1 = rt; ra2 = rs; reg_wen = `WREN; mem_cmd = `MEM_NOP;
            alu_src = `ALU_SRC_REG;  reg_src = `REG_SRC_ALU;
            pc_src  = `PC_SRC_NEXT;  alu_op  = inst[`FLD_FUNCT]; 
          end
          default: begin // Enter ALU
            // $display("DEFAULT type %b", inst[`FLD_FUNCT]);
            wa = rd; ra1 = rs; ra2 = rt; reg_wen = `WREN; mem_cmd = `MEM_NOP;
            alu_src = `ALU_SRC_REG;  reg_src = `REG_SRC_ALU;
            pc_src  = `PC_SRC_NEXT;  alu_op  = inst[`FLD_FUNCT]; 
          end
        endcase
      end // end OP_ZERO
      `BEQ: begin
        // $display("BEQ on the way!");
        wa = rd; ra1 = rs; ra2 = rt; reg_wen = `WDIS; mem_cmd = `MEM_NOP;
        alu_src = `ALU_SRC_REG;  reg_src = `REG_SRC_ALU;
        pc_src  = `PC_SRC_BRCH;  alu_op  = `F_SUB;
        check_zero = 1;
      end
      `BNE: begin
        wa = rd; ra1 = rs; ra2 = rt; reg_wen = `WDIS; mem_cmd = `MEM_NOP;
        alu_src = `ALU_SRC_REG;  reg_src = `REG_SRC_ALU;
        pc_src  = `PC_SRC_BRCH;  alu_op  = `F_SUB;
        check_zero = 0; 
      end
      `LW: begin
        wa = rt; ra1 = rs; ra2 = 0; reg_wen = `WREN; mem_cmd = `MEM_READ;
        alu_src = `ALU_SRC_IMM;  reg_src = `REG_SRC_MEM;
        pc_src  = `PC_SRC_NEXT;  alu_op  = `F_ADD; 
      end
      `SW: begin
        wa = rt; ra1 = rs; ra2 = rt; reg_wen = `WREN; mem_cmd = `MEM_WRITE;
        alu_src = `ALU_SRC_IMM;  reg_src = `REG_SRC_MEM;
        pc_src  = `PC_SRC_NEXT;  alu_op  = `F_ADD;
      end
      `J_: begin
        wa = rd; ra1 = rs; ra2 = rt; reg_wen = `WDIS; mem_cmd = `MEM_NOP;
        alu_src = `ALU_SRC_REG;  reg_src = `REG_SRC_ALU;
        pc_src  = `PC_SRC_JUMP;  alu_op  = `F_SUB; 
      end
      `JAL: begin
        wa = 5'b11111; ra1 = rs; ra2 = rt; reg_wen = `WREN; mem_cmd = `MEM_NOP;
        alu_src = `ALU_SRC_REG;  reg_src = `REG_SRC_PC;
        pc_src  = `PC_SRC_JUMP;  alu_op  = `F_SUB;
      end
      
      default:;
    endcase
  end
endmodule
