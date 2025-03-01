# LC3 Simulator (Logisim)

This project was to create a fully functional simulation of the [LC3 educational computer](https://en.wikipedia.org/wiki/Little_Computer_3) designed by Patt & Patel in [Logisim](https://www.cburch.com/logisim/download.html). This version is based on the description in the [2nd Edition of Introduction to Computing Systems: From Bits and Gates to C and Beyond](https://highered.mheducation.com/sites/0072467509/), with some modifications based on the implementation by Aiden Garvey in the [WebLC3 project](https://github.com/University-of-Manitoba-Computer-Science/WebLC3).

The notable way this simulator deviates from the specification in the textbook that `TRAP` instructions switch the machine to supervisor mode/stack (as inspired by WebLC3). This both allows us to abstract stacks when introducing the LC3 to students for awhile, and makes sense given that these subroutines are part of OS space. Modifications to the [microcode](#the-microcode) were made to support this.

## The Simulator

The simulator runs in Logisim. You can download platform-specific binaries [here](https://www.cburch.com/logisim/download.html). Once installed, you can simply open up "lc3_simulator.circ" to get started! The circuitry is laid out similarly to the to the data path diagrams in Appendix C of the textbook. In the top left you'll find instructions on how to run the simulator, the primary reset and clock controls, a quick view of all the status and control lines in the computer, console output, and keyboard input.

Note: The sim doesn't handle `HALT` well currently (and the OS allows the program to keep running), and keyboard interrupts aren't implemented yet. (I'll add both eventually, right?)

## The Assembler

The LC3 assembler used for this project was written by Aiden Garvey as part of the [WebLC3 project](https://github.com/University-of-Manitoba-Computer-Science/WebLC3). I have only made small modifications to allow it to be run on the command-line 

To assemble (from within the "assembly_code" directory):

```shell
npm run assemble example_program.asm
```
 
## The OS Linker

Links object files created by the above assembler with OS code also written by Aiden Garvey. Respects `.orig` directives passed to the assembler. (If using an `.orig` other than `x3000`, you'll need to modify the `orig` input in the simulator.)

To link (from within the "assembly_code" directory):

```shell
npm run link example_program.obj
```

## The Microcode

Microcode is outlined in the [microcode spreadsheet](./microcode/lc3_control_store.xlsx). This currently gets manually converted to a binary file by copying the contents of the "Raw" sheet into `control_store.txt` and then running `text_binary_to_bin.py` on it to converted to a `.bin`. This can then get loaded into the microcode ROM in the simulator. (It should be pre-loaded when you run it however.)

As mentioned above, the `TRAP` runs in supervisor mode in this implementation. In order to support that, the microcode has been adjusted. The differences between the original specification and mine can be seen in the microcode spreadsheet. tl;dr: I've had to add a number of states to handle the difference in how the new PC is calculated between `TRAP` and an interrupt. This could probably be simplified to some degree, but there was enough room in the state address space that I could make it work in a straightforward way, as opposed to making it slightly more "efficient". Ideally I'll create an updated state diagram with my changes at some point, and include them here.

## Simulator Peculiarities

*   Attempting to read `DDR` results in undefined input on the line, as this maps to a read from memory (via INMUX), which isn't enabled.