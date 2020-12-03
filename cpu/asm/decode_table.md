## Decode table for Triangle Sum assembly 

| Instruction | RegDst | RegWr | ALUctrl | MemWr | MemToReg | ALUsrc |
|-------------|--------|-------|---------|-------|----------|--------|
|LI |1|1|add|0|0|1|
|BEQ |1|0|add|0|1|0|
|ADDI |1|1|op|0|0|1|
|ADD |0|1|op|0|0|0|
|J |0|0|add|0|0|0| 

<br>
<br>


## Decode table for Binary Search assembly 

| Instruction | RegDst | RegWr | ALUctrl | MemWr | MemToReg | ALUsrc |
|-------------|--------|-------|---------|-------|----------|--------|
|SUB  |||||||
|BEQ  |||||||
|BLTZ |||||||
|ADDI |||||||
|ADD  |||||||
|MFLO |||||||
