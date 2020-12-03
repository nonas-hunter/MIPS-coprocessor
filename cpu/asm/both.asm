.text
jal procedure # call procedure
li $a0, 5
li $v0, 1
syscall
li $v0, 10
syscall 

procedure:
li $a0, 3
li $v0, 1
syscall
jr $ra
li $v0, 10
syscall
