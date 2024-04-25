
//==========================================================================
// Copyright (C) 2024 Chili.CHIPS*ba
//--------------------------------------------------------------------------
//                      PROPRIETARY INFORMATION
//
// The information contained in this file is the property of CHILI CHIPS LLC.
// Except as specifically authorized in writing by CHILI CHIPS LLC, the holder
// of this file: (1) shall keep all information contained herein confidential;
// and (2) shall protect the same in whole or in part from disclosure and
// dissemination to all third parties; and (3) shall use the same for operation
// and maintenance purposes only.
//--------------------------------------------------------------------------
// Description: Simulation testbench for FPGA. 
//==========================================================================
`timescale 1ns/1ns
module TB;
logic arst_n, clk_27;
logic [6:1] led_n;
logic [31:0] reg_o, reg_k;

initial begin
    arst_n = 1'b0;
    #100
    arst_n = 1'b1;
    #100000ns;
    // If the CPU gets stuck, also print out an error
    $display("\n*******************\nTest code:\033[0;31m ERROR\033[0m\n*******************\n\n\n");
    $finish; // Finish simulation after a certain period
end
/*
 // Assertions have to be done like this
  always_ff @(posedge clk_27) begin
    $display("a = %b, b = %b, c = %b, y = %b",a,b,c,y);
    if ($past(b) > 2'b0) begin
      if (y !== 1'b1) $fatal("Assertion failed for Test Case: b > 2'b0");
    end else begin
      if (y !== 1'b0) $fatal("Assertion failed for Test Case: b <= 2'b0");
    end
  end
*/
initial begin
    clk_27 = 0;
    forever #18 clk_27 = ~clk_27; //36ns clock period
end
always @(posedge clk_27) begin
  if(reg_o == "O" & reg_k == "K" | reg_o == "E" & reg_k == "R" ) begin
    if(reg_o == "O") begin
      $display("\n*******************\nTest code:\033[0;32m %c%c\033[0m\n*******************\n\n\n", reg_o[7:0], reg_k[7:0]);
    end
    else begin
      $display("\n*******************\nTest code:\033[0;31m ERROR\033[0m\n*******************\n\n\n");
    end

    $finish;
  end
end
assign reg_o = dut.u_edubos5.rf[11];
assign reg_k = dut.u_edubos5.rf[12];
lab_11 dut(.*);


endmodule
/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/03/05 TI: initial creation    
*/