lw $a0, stuff
li $v0, 1
syscall
li $v0, 10
syscall

.data
stuff: .word 3, 4, 5