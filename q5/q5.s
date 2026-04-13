.globl main

.section .data
filename: .string "input.txt"
reading_mode: .string "r"
yes: .string "Yes\n"
no: .string "No\n"

.section .text
main:
    add sp, sp, -48 #create space on stack
    sd ra, 40(sp)
    sd s0, 32(sp)
    sd s1, 24(sp)
    sd s2, 16(sp)
    sd s3, 8(sp)
    sd s4, 0(sp) #saved return address and saved registers to be used on stack

    la a0, filename
    la a1, reading_mode #load address of filename to a0 and address of reading mode to a1 as arguments for fopen
    call fopen
    mv s0, a0 #move filepointer to s0 to save it for future use
 
    li a1, 0 #argument for fseek, offset = 0
    li a2, 2 #argument for fseek, 2 means seekend
    call fseek #seeks end of file

    mv a0, s0 #argument for ftell
    call ftell #ftell gives us the current cursor position which happens to be at the end after fseek 
    add s1, a0, -1 #we store the index of the last element in s1 (s1 becomes right ptr) by using result of ftell-1
    li s2, 0 #left ptr

loop:
    bge s2, s1, printyes #if left ptr crosses or reaches right ptr then all elements have been checked and the input is a palindrome

    mv a0, s0
    mv a1, s2
    li a2, 0
    call fseek #fseek(fp, left, 0) since a2=0 fseek sets the cursor to left pos

    mv a0, s0
    call fgetc #gets character at cursor position i.e. left ptr
    mv s3, a0 #move left character to s3

    mv a0, s0
    mv a1, s1
    li a2, 0
    call fseek #set cursor to right position

    mv a0, s0
    call fgetc #gets character at cursor poition i.e. right ptr
    mv s4, a0 #store right character in s4
    
    bne s3, s4, printno #if character at left ptr != character at right ptr then the input cannot be a palindrome
    
    add s2, s2, 1 #increment leftptr
    add s1, s1, -1 #decrement rightptr
    j loop

printyes:
    la a0, yes
    call printf
    j done

printno:
    la a0, no
    call printf

done:
    ld ra, 40(sp)
    ld s0, 32(sp)
    ld s1, 24(sp)
    ld s2, 16(sp)
    ld s3, 8(sp)
    ld s4, 0(sp)
    add sp, sp, 48 #restore stack
    ret




