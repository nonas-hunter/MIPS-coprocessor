addi $t0, $t0, 0 #Stepper
li $t1, 12 #N
li $v0, 1 #set ouput reg
li $a0, 0 #output
nop
nop
nop

start_loop:
 beq $t0, $t1, break_loop
 addi $t0, $t0, 1
 add $a0, $a0, $t0
 j start_loop
break_loop:
syscall
li $v0, 10
syscall

# addi $t0, $t0, 0 #Stepper
# li $t1, 12 #N
# li $v0, 1 #set ouput reg
# li $a0, 0 #output
# 
# start_loop:
#  beq $t0, $t1, break_loop
#  addi $t0, $t0, 1
#  add $a0, $a0, $t0
#  j start_loop
# break_loop:
# 