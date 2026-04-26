# Execute stage of MIPS
The Execute stage is responsible for performing the actual computation, logic operations, or address calculations defined by the instruction decoded in the previous stage.
# Key Functions

**Arithmetic and Logical Operations:**
For R-type instructions (like add, sub, and, or), the ALU performs the mathematical or bitwise operation on two source registers.

**Address Calculation** 
For memory instructions (like lw and sw), the ALU adds the base register value to a sign-extended 16-bit offset to determine the target memory address.

**Branch Conditions**
For branch instructions (like beq or bne), the ALU subtracts two register values to set a "Zero" flag, which determines if the branch should be taken.