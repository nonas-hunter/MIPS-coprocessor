# Implementation of a MIPS Coprocessor for Graphics Display
### Jasper Katzban, Andrew Mascillaro, Luke Nonas-Hunter

## Project Proposal
Our group plans to learn about and build a MIPS co-processor. We learned a lot when making our CPUs in the previous lab, and wanted to extend upon this by learning more about how the CPU extends its capabilities by offloading work to multiple processors and outputting more complex data to displays like LED matrices. Through this project, we intend to learn as much as we can about the usage of the MIPS co-processor, and if possible, build one ourselves. Our first milestone involves significant research into MIPS co-processors. We want to learn a lot about how co-processors interact with CPUs as well as the advantages of using co-processors in boosting performance of computers. Our stretch goals are flexible, although we are considering a few possible deliverables after doing research. Some possible deliverables we're considering include displaying graphics and running compiled C code on our CPU.

### Work Plan
#### **First Milestone:** Research
*Minimum Deliverable*  
We will create a brief report and presentation about our research and what we learned. 
- Learn about Co-processors and their implementation
    - What are co-processors used for (MIPS and non-MIPS implementations)
    - Why do we need them?
    - How do they assist the CPU?
- Learn about GPUs and their implementation
    - How are graphics displayed on a screen?
    - What systems are involved in that process?
    - Why are they important?
    - What are their special features?
    - How do they communicate with CPUs, especially in MIPS?  
- Decide on physical implementation direction
    - What makes the most sense based on our research?

#### **Second Milestone:** Minimum Viable Product in Simulation
*Planned Deliverable*  
We will implement a co-processor in Verilog used to display graphics. The co-processor will be able to take commands from the CPU and produce an output that could be used with some sort of display (7 segment display, LED matrix, VGA port). In addition, we will create a brief writeup and presentation which includes what we learned in our research, what we learned while implementing the co-processor, and what we would do going forward if we had more time.
- Create a co-processor (or graphics driver) of some type in Verilog.
    - The processor should take instructions and output a signal that could run an LCD or other display.

#### **Third Milestone (Option 1):** Expand Upon CPU Co-Processor Design and Begin Exploration into Writing C Code
*Stretch Deliverable*  
We will expand apon the work we were doing for the last deliverable. We will fully implement our CPU co-processor combination in Verilog and begin writing C code for it. We will explore differences in available compilers for our architecture and attempt to write C code for our processor which will make use of the display. These programs could include: a clock display, the game of life, looping through different images stored in memory. We will also add to the documentation we will have made for the last milestone. We hope to present our documentation alongside a small demo for our final submission.
- Begin exploring possible compilers for C++ code to translate it into MIPS assembly
- Add additional functionality to co-processor and CPU so any MIPS assembly code can be run on it.

#### **Third Milestone (Option 2):** Implement Simulation on FPGA
*Stretch Deliverable*  
We will attempt to take our CPU co-processor implementation and move it onto an FPGA. This will include exploring how an FPGA works and how we can use it to simulate our design. We also want to try and connect the display which we designed for to the FPGA and see if it is possible to produce an image on the display. We will also add to the documentation we will have made for the last milestone. We hope to present our documentation alongside a small demo for our final submission.
- Try to convert Verilog code to something that can be interpreted by the FPGA
- Try to connect a monitor or display to the FPGA and try to display a graphic to the screen.

### Planned References
- Implementing co-processors in MIPS
    - https://www.it.uu.se/education/course/homepage/os/vt20/module-1/mips-coprocessor-0/
- Verilog implementation of advanced circuits
    - https://verilogguide.readthedocs.io/en/latest/verilog/designs.html