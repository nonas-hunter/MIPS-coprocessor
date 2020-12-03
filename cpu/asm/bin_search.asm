# go to the bottom of the script to make the list and search for a specific number

la   $v1, list            # memory position of first element
lw   $a3, listsz          # end search
addi $a3, $a3, -1         # highest index
lw   $a0, target

loop:
    slt $v0, $a3, $a1           #if end - start <= 0 goto breakloop because start is smaller than end;
    beq $v0, 1, breakloopfalse
    
    add $a2, $a1, $a3
    srl $a2, $a2, 1            
    sll $v0, $a2, 2		# mid*4 = 4 * (start + end) / 2 = (start + end) << 1
    
    # get the value at mid
    add $v0, $v1, $v0     # v1 is the location of arr[mid]
    lw $v0, 0($v0)
    
    beq $a0, $v0, breaklooptrue   # check if we found the element
    
    slt $v0, $v0, $a0 # v0 is $v0 < $a0, e.g. arr[mid] < target
    beq $v0, 0, else # arr[mid] < target
    	addi $a1, $a2, 1    # start = mid + 1
    	j endif
    else: 		  
    	addi $a3, $a2, -1   # end = mid - 1
    endif: 
    
    j loop                      #restart loop with new start and end
    
breakloopfalse:
    addi $a2, $zero, -1
breaklooptrue:
    addi $v0,$zero,1      #set syscall type to print int
    addi $a0, $a2, 0
    syscall

# https://people.cs.pitt.edu/~xujie/cs447/AccessingArray.htm
# also much credit to Jon for helping with the list!
.data
list: .word 0, 1, 3, 4, 6, 9, 11, 13 # the list
listsz: .word 8                      # the length of the list
target: .word -1                     # the target element in the list

# addi $t0, $zero, 0        # start
# addi $t1, $zero, 1        # 
# addi $t2, $zero, 3        # 
# addi $t3, $zero, 4        # 
# addi $t4, $zero, 6        # 
# addi $t5, $zero, 9        # 
# addi $t6, $zero, 11       # 
# addi $t7, $zero, 13       # end
# addi $a0, $zero, 4        # target
# addi $a1, $zero, 0        # start search
# addi $a2, $zero, 0        # mid search
# addi $ra, $zero, 0        # found element?


# loop
# start = 0
# end = len
# mid = (start + end) >> 1
# arr[mid] > target
#     start = mid+1
#     mid = (start + end) >> 1
# arr[mid] == target
#     return mid
# else
#     end = mid-1
#     mid = (start + end) >> 1
# if start < end loop
# else breakloop
 
