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
// eduBOS5 register file, reset handled in software
// 2 asynchronous read ports, 1 synchronous write port
//==========================================================================
module edubos5_rf
    import edubos5_pkg::*;
(
    input logic clk,
    input logic [4:0] rs1_addr,
    input logic [4:0] rs2_addr,
    input logic [4:0] rd_addr,
    input logic rf_we,
    input cpu_data_t rf_wdat,

    output cpu_data_t rs1,
    output cpu_data_t rs2
);

cpu_data_t rf [32] /* synthesis syn_ramstyle = "distributed_ram" */;

assign rs1 = rf[rs1_addr];       
assign rs2 = rf[rs2_addr];

always_ff @(posedge clk) begin : rf_writeback
    if (rf_we == HI) begin
       rf[rd_addr] <= rf_wdat; // one write port
    end
end : rf_writeback

endmodule: edubos5_rf
/*
-----------------------------------------------------------------------------
Version History:
-----------------------------------------------------------------------------
 2024/05/05 TI: initial creation    
*/
