addi $a0, $zero, 0
nop
addi $a1, $zero, 6
startloop:
beq $a0, $a1, endloop
addi $a0, $a0, 1
j startloop
endloop:
addi $v0, $zero, 1
syscall
addi $v0, $zero, 10
syscall
