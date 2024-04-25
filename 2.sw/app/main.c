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
// Description: Test program for eduBOS5. Only CSR is reg_led
//==========================================================================
#include <stdint.h>
#define reg_led (*(volatile uint32_t*)0x02000004)

int main(int argc, char *argv[]){
    int a = 0;
    while (1) {
        a = a + 1;
        reg_led = (uint32_t) a/100000;
    }
    return 0;
}

/*
------------------------------------------------------------------------------
Version History:
------------------------------------------------------------------------------
 2024/03/05 TI: initial creation    
*/