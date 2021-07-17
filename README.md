# ROP_v1 (single-core-fpga-matrix-multiplyer)
## _A single core resource optimized processor for matrix multiplication_

ROP_v1 is a resource optimized single-core processor for FPGA matrix multiplication which has been designed using verilog HDL. 
This is the first version of the processor design for a matrix multiplication.

## Internal features

- 256 byte memories as data memory & instruction memory
- 16 bit BUS
- 8 bit general purpose registers
- 16 bit special purpose registers

## Specifications

This processor can multiply matrices without limiting to square matrices. But, due to the resource limitations the maximum dimensions are limited by a certain extend.

- Can multiply any given 2 matrices without limiting to square matrices.
- Internal registers have been used to reduce memory access.
- Resource usage has been optimized.
- Designed in a way it can reads 8 bit values and write 16 bit values to the memory to reduce overflows after multiplications.
- Can be easilty extendable to read 16 bit values and write 32 bit values to memory.
- A simple processor architecture.

Multicore processor designed using this single-core processor(ROP_v2) is available on github as a [public repository][dill].


## Installation

ROP_v1 can be compiled using QuartusPrime software and can be simulated using ModelSim.

Clone the repository using following commands

```sh
git clone https://github.com/SahanGura/single-core-fpga-matrix-multiplyer.git
```

Following steps should be proceeded to compile and simulate this processor using QuartusPrime and Modelsim. (Plese note that these softwares can be only run in Windows Operating System. If you are using macOS run windows in a virtual environemnt and install)
- After installing above softwares you can simply create a new project and add files in the "src" directory to the project.
- While creating the new project give ModelSim Altera as the simulation software.
- After project creation is finished, select the top level module as the processor.v and run synthesis ans analysis.
- Project should compile without any errors.
- You can run the netlist_viewer and check the processor architecture.
- Next you can simulate the processor using ModelSim.
- Before doing that you should add this path "C:\intelFPGA_lite\18.1\modelsim_ase\win32aloem" to the QuartusPrime software so it can recognize the ModelSim software to run the simulation process.

## Development

Development of this processor has been done as a partial fullfillment of the EN3030 - Circuit Systems & Design module in Electronic & Telecommunication Engineering Department of University of Moratuwa, Sri Lanka in 2021.







  
