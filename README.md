# My first RISC-V CPU.
 Hi! I'm 15 years old and it is my training project. Here I am trying to understand how our computers works in low level.
 
Project is writing in **SytemVerilog**, **Xilinx Vivado** IDE.


#Stages
The architecture of the processor core is divided into stages:
* **Fetch ('fetch.sv)** - get instruction from the memory.
* **Decode ('decode.sv)** - decoding commands.
* **Execute ('execute.sv)** - executing commands.
* **Retire ('retire.sv)** - in progress.
  
# What's ready and what's in the plans:
**Ready:**
* Base structure and connection between modules in 'top.sv'.
* Decoding instructions.
* Work with memory: comands like **Load** and **Store**.
**In the near future:**
* Finish **WriteBack (Retire)**.
* Add 26 instructions.

**The goal is** to write a ready-made processor core myself.
