# eduBOS5
A configurable, impressive throughput, miniscule RISC-V CPU core targeting FPGAs. 


This project includes a complete, pre-configured toolchain and workflow for deploying custom hardware and software to the previously mentioned RISC-V core primarily aimed at Gowin FPGAs. While FPGA synthesis and place-and-route are conducted using proprietary tools, verification is powered by open-source tools. The source files are not public yet, therefore the build steps are not included.
## Design overview
**eduBOS5** is a single-cycle, optional Machine privilege mode, RV32I RISC-V ISA implementation. Setting it apart is a relatively short 2-cycle execution pipeline, which can be configured to a 3-cycle alternative for a higher Fmax. The CPU is written in clean SystemVerilog-2017, making use of language features that enhance readability and simplify debugging. 

The CPU, optimized for Gowin FPGAs, features a DSP ALU optional parametrization, which gives it a +30 MHz boosted Fmax over the LUT alternative. The 3 cycle pipeline may be configured with MCP to achieve even greater frequencies.


Space for improvement is an important consideration while building this core, while no Zicsr is deployed at the time and the CPU runs bare-metal, following features are currently being developed:
- Misaligned data access using software traps
- Superscalar implementation
- Instruction & data prefetch 
- Branch prediction
- Interrupt handling
- FreeRTOS support
- CPU emulation support using [Vproc](https://github.com/wyvernSemi/vproc)

### Block diagram
CPU is of Harvard architecture type, it features separate busses and ports for instruction and data memory. This diagram doesn't include some pipeline registers, carefully placed optimizing for Fmax.

![eduBOS5 RISC-V block diagram](/0.doc/cpu_top_view_V2.png)
## Verification strategy
Both static (Formal) and dynamic (Functional) methods are used to verify **eduBOS5** RISC-V compliance, utilizing open-source [SymbiYosys](https://github.com/YosysHQ/sby) and [Verilator](https://github.com/verilator/verilator). Verilator testbench is written in SystemVerilog with a supporting C++ backend.
During development, hand-written assembly tests, functional simulation, and waveform analysis are utilized to verify each individual instruction and instruction type. Once the core is complete, it will undergo standard compliance testing using [riscv-tests](https://github.com/riscv-software-src/riscv-tests). 
Finally, formal verification will be conducted using [RISC-V Formal tests](https://github.com/YosysHQ/riscv-formal) to conclude the verification process.

## Current/Target performance and size (WIP)

At the time, **eduBOS5** is RV32I compliant excluding Zicsr and misaligned data access and runs bare-metal C.  The intent is to have a small, yet capable core, waiting for it's deployment in specialized embedded applications achieving significant performance, along with custom FPGA accelerators. There already are a number of variants of the CPU implementation:
- [Register file implemented in SSRAM distributed memory (LUTRAM) or BSRAM]
- [DSP block or LUT ALU]
- [Superscalar or singe-cycle]

Main development platform is the Gowin LittleBee and Arora FPGA family, in general, handing in utilization and performance figures of:
- **CPI 2/3**
- ~**1000 Gowin LUTs**
- ~**400  FFs**
- **80-100 MHz Fmax**
### Performance evaluation and comparison
Dhrystone yielded in **0.39 DMIPS/MHz**, **2.56 CPI**, combined with a significant Fmax **eduBOS5** is no short of performance, especially when comparing to base version of [PicoRV2](https://github.com/YosysHQ/picorv32) as a referent design. 

![eduBOS5 RISC-V block diagram](/0.doc/dhry.png)

Assessing performance beyond synthetic tests, computing the Mandelbrot set and comparing times with **PicoRV32** is presented below.

![eduBOS5 RISC-V block diagram](/0.doc/dhrystone.gif)


### Performance/Power/Area table across FPGAs
Numbers listed are acquired using a minimal SOC, featuring an UART, memory, LEDs and user buttons. Although not shown in this table, **eduBOS5** is frequency resilient to adding more peripherals while PicoRV32 hasn't expressed same properties. Base **PicoRV32** is used for comparison as both fall into the same size/area category. In this configuraton, **eduBOS5** needs some optimizations (DSP_ALU) to achieve same Fmax as **PicoRV32**, but nevertheless outperforms it in it's LUT-only version with it's much shorter pipeline.

![eduBOS5 RISC-V block diagram](/0.doc/performance_table.png)


