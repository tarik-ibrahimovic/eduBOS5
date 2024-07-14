# eduBOS5
A compact, configurable RISC-V CPU core targeting FPGAs. 


This project includes a complete, pre-configured toolchain and workflow for deploying custom hardware and software to the previously mentioned RISC-V core aimed at Gowin FPGAs. While FPGA synthesis and place-and-route are conducted using Gowin's proprietary tools, verification is powered by open-source tools. The source files are not public yet, therefore the build steps are not included.
## Design overview
**eduBOS5** is a single-cycle, optional Machine privilege mode, RV32I RISC-V ISA implementation. Setting it apart is a relatively short 2-cycle execution pipeline, which can be configured to a 3-cycle alternative for a higher Fmax. The CPU is written in clean SystemVerilog-2017, making use of language features that enhance readability and simplify debugging.


Space for improvement is an important consideration while building this core, while no Zicsr is deployed at the time and the CPU runs bare-metal, following features are currently being developed:
- Misaligned data access using software traps
- Superscalar implementation
- Instruction & data prefetch 
- Branch prediction
- Interrupt handling
- FreeRTOS support
- CPU emulation support 


Until the CPU is finalized, below is a preview block diagram representing the conceptual design.
![eduBOS5 RISC-V block diagram](/0.doc/cpu_top_view_V2.png)
## Verification strategy
Both static (Formal) and dynamic (Functional) methods are used to verify **eduBOS5** RISC-V compliance, utilizing open-source [SymbiYosys](https://github.com/YosysHQ/sby) and [Verilator](https://github.com/verilator/verilator). Verilator testbench is written in SystemVerilog with a supporting C++ backend.
During development, hand-written assembly tests, functional simulation, and waveform analysis are utilized to verify each individual instruction and instruction type. Once the core is complete, it will undergo standard compliance testing using [riscv-tests](https://github.com/riscv-software-src/riscv-tests). 
Finally, formal verification will be conducted using [RISC-V Formal tests](https://github.com/YosysHQ/riscv-formal) to conclude the verification process.

## Current/Target performance and size

At the time, **eduBOS5** is RV32I compliant excluding Zicsr and misaligned data access and runs bare-metal C while using approx. 900 Gowin LUTs .  

The intent is to have a small, yet capable core. Main development platform is the Gowin LittleBee FPGA family, handing in utilization and performance figures of:
- CPI 2/3
- < 1000 Gowin LUTs
- < 100  FFs
- 80 MHz Fmax

An initial working version will undergo a series of custom performance comparison tests, along with standard benchmarks such as Dhrystone, to assess its performance. 