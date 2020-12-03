addi $a0, $zero, 5        
addi $t0, $zero, 1        
addi $t1, $zero, 1        
addi $t2, $zero, 2        

add $t2, $t1, $t2
addi $a1, $a0, 30
sll $a1, $a1, 2
li $v1, 1
syscall
add $v1, $v1, 9
syscall