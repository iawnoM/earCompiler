.text
main:
# -----------------------
li $t0,4
li $t1,5
li $t2,13
# Printing -----------
move $a0, $t0
li $v0, 1
syscall
# Printing -----------
move $a0, $t2
li $v0, 1
syscall
# -----------------
#  Done, terminate program.

li $v0,10   # call code for terminate
syscall      # system call (terminate)
.end main
