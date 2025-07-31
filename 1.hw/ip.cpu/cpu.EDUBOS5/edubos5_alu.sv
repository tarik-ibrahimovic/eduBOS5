//==========================================================================
// (c) Copyright 2022 -- CHILI CHIPS LLC, All rights reserved.
//--------------------------------------------------------------------------
//                      PROPRIETARY INFORMATION
//
// The information contained in this file is the property of CHILI CHIPS LLC.
// Except as specifically authorized in writing by CHILI CHIPS LLC, the holder
// of this file: (1) shall keep all information contained herein confidential;
// and (2) shall protect the same in whole or in part from disclosure and
// dissemination to all third parties; and (3) shall use the same for operation
// and maintenance purposes only.
//-----------------------------------------------------------------------------
// eduBOS5 ALU: RV32I (ADD, SUB, COMPARISONS, SHIFTS)
// 1 cycle to output - outputs are flopped 
// FAST_OP uses Gowin ALU54 DSP for timing closure
//==========================================================================
module edubos5_alu
   import edubos5_pkg::*;
#(
   parameter FAST_OP = 1
) (
   input logic clk,
   input logic reset,

   input cpu_data_t aluin_1, 
   input cpu_data_t aluin_2,

   input logic [4:0] shamt,

   input logic aluimm_dec,
   input logic jalr_dec, //uses alu_plus res
   input logic funct7_5,
   funct3_alu_t funct3,

   output cpu_data_t alu_out,

   output logic eq,
   output logic ltu,
   output logic lt
);
//-----------------------------------------
// Functions combo + aluin_2 2's complement
//-----------------------------------------
logic [32:0] aluin_2_n;

logic [31:0] alu_xor, alu_or, alu_and;

logic [32:0] alu_minus;
logic [31:0] alu_plus; 

logic [31:0] shifter, shifter_in;

always_comb begin : _alu_calc

   if (FAST_OP != 1) begin
      aluin_2_n = {1'b1, ~aluin_2} + 33'b1;

      alu_plus  = aluin_1 + aluin_2;
      alu_minus = {1'b0, aluin_1} + aluin_2_n;
   end
   alu_xor   = aluin_1 ^ aluin_2;
   alu_or    = aluin_1 | aluin_2;
   alu_and   = aluin_1 & aluin_2;  

end : _alu_calc

//------------------------------------------------------
// flopping alu outputs, barrel roll inputs, and functs
//------------------------------------------------------

logic [32:0] alu_minus_reg;
logic [31:0] alu_plus_reg, shifter_reg;

logic [31:0] shifter_in_reg;
logic [4:0]  shamt_reg;

logic [31:0] alu_and_reg, alu_xor_reg, alu_or_reg;
logic aluin_1_31_reg, aluin_2_31_reg;

funct3_alu_t funct3_alu_reg;

always_ff @(posedge clk) begin : _alu_pipe
   if(FAST_OP != 1) begin 
      alu_minus_reg    <= alu_minus ;
      alu_plus_reg     <= alu_plus  ;
   end
   shifter_in_reg   <= shifter_in;
   shamt_reg        <= shamt;
   aluin_1_31_reg   <= aluin_1[31];
   aluin_2_31_reg   <= aluin_2[31];

   alu_and_reg <= alu_and;
   alu_xor_reg <= alu_xor;
   alu_or_reg <= alu_or;

   funct3_alu_reg <= funct3;
end : _alu_pipe


//----------------------------------------------------------------------
// DSP ALU54 module for fast addition/substraction (108 MHz Fmax target)
//----------------------------------------------------------------------
logic [32:0] alu_dsp_plus, alu_dsp_minus;

if (FAST_OP == 1) begin
   Gowin_ALU54plus u_alu54plusDSP (
      .clk(clk),                     //i
      .ce(1'b1),                     //i
      .reset(reset),                 //i
      .a(aluin_1),                   //i
      .b(aluin_2),                   //i

      .dout(alu_dsp_plus),           //o
      .caso()                        //o
   );

   Gowin_ALU54minus u_alu54minusDSP (
      .clk(clk),                     //i
      .ce(1'b1),                     //i
      .reset(reset),                 //i
      .a(aluin_1),                   //i
      .b(aluin_2),                   //i

      .dout(alu_dsp_minus),          //o
      .caso()                        //o
   );
end
//---------------------------------------------------------------
// Extracting comparisons outputs from calculations + barrel roll
//---------------------------------------------------------------
always_comb begin: _alu_outputs

   shifter_in = funct3 == SLL? flip32(aluin_1) : aluin_1;
   shifter = cpu_data_t'($signed({funct7_5 & aluin_1_31_reg, shifter_in_reg}) >>> shamt_reg);

   if(FAST_OP == 1) begin 
      eq = alu_dsp_minus[31:0] == 0;
      ltu = alu_dsp_minus[32];
      lt = ((aluin_1_31_reg ^ aluin_2_31_reg) ? aluin_1_31_reg : alu_dsp_minus[32]);
   end
   else begin 
      eq = alu_minus_reg[31:0] == 0;
      ltu = alu_minus_reg[32];
      lt = ((aluin_1_31_reg ^ aluin_2_31_reg) ? aluin_1_31_reg : alu_minus_reg[32]);
   end
end: _alu_outputs
//---------------
// ALU output mux
//---------------
always_comb begin : _alu_output_mux
   // mux ALU functionality 
   unique case (funct3_alu_reg)
      ADD_SUB : begin
         if (aluimm_dec | (funct7_5 == 1'b0) | jalr_dec) begin
            if(FAST_OP == 1) begin
               alu_out = alu_dsp_plus[31:0];
            end
            else begin
               alu_out = cpu_data_t'(alu_plus_reg); //casting to 32 bits
            end
         end
         else begin
            if(FAST_OP == 1) begin
               alu_out = alu_dsp_minus[31:0];
            end
            else begin
               alu_out = cpu_data_t'(alu_minus_reg[31:0]);
            end 
         end
      end
      //comparisons: Signed Less Than; Unsigned Less Than
      SLT     : alu_out = {31'b0, lt};
      SLTU    : alu_out = {31'b0, ltu};

      //shifts: Logical Left; Logical Right/Arithmetic
      SLL     : alu_out = flip32(shifter);

      SRL_SRA : alu_out = shifter;

      //logic operations
      XOR     : alu_out = alu_xor_reg;
      OR      : alu_out = alu_or_reg ;
      AND     : alu_out = alu_and_reg;
      default : alu_out = shifter;
   endcase
end : _alu_output_mux
endmodule : edubos5_alu

/*
-----------------------------------------------------------------------------
Version History:
-----------------------------------------------------------------------------
 2024/05/07 TI: initial creation    
*/