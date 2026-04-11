.globl main
.section .data
fmt_space: .string "%ld " #used for all elements except the last (adds space)
fmt_newline: .string "%ld\n" #used for the last element (adds newline)

.section .text
main:
    addi sp, sp, -80
    sd ra, 72(sp)
    sd s0, 64(sp)
    sd s1, 56(sp)
    sd s2, 48(sp)
    sd s3, 40(sp)
    sd s4, 32(sp)
    sd s5, 24(sp)
    sd s6, 16(sp)
    sd s7, 8(sp)
    sd s8, 0(sp)
    mv s0, a1 #s0=argv=array of string pointers
    mv s1, a0 #s1=argc (no of arguments includes program name)
    addi s2, s1, -1 #s2=n=argc-1
    slli a0, s2, 3 #a0=n*8 (how many bytes we need for n longs)
    jal ra, malloc #call malloc; returns pointer in a0
    mv s3, a0 #s3 is the address of array
    slli a0, s2, 3 #a0=n*8
    jal ra, malloc #call malloc; returns pointer in a0
    mv s4, a0 #s4 is now the address of result array
    slli a0, s2, 3 #a0=n*8 (stack can hold at most n indices)
    jal ra, malloc #call malloc; returns pointer in a0
    mv s7, a0 #s7 is the address of the stack array
    li s8, 1 #skip first argument i.e. program name
#parse goes through arguments and converts them from string to int
parse_loop:
    bge s8, s1, parse_done #end parsing if past last argument
    slli t1, s8, 3 #each pointer is 8 bytes
    add t2, s0, t1 #t2=&argv[i]
    ld a0, 0(t2) #a0=argv[i]
    jal ra, atoi #argv has strings so we must convert to int
    addi t3, s8, -1 #index = i-1
    slli t3, t3, 3 #t3=(i-1)*8
    add t3, s3, t3 #t3=&arr[i-1]
    sd a0, 0(t3) #arr[i-1]=result of convert
    addi s8, s8, 1 #i++
    j parse_loop
parse_done:
    li t0, 0 #t0=i=0
#initialise sets default result to -1 for all indices
initialise_loop:
    bge t0, s2, initialise_done #if i>=n done
    slli t1, t0, 3 #t1=i*8
    add t1, s4, t1 #t1=&result[i]
    li t2, -1
    sd t2, 0(t1) #result[i]=-1
    addi t0, t0, 1
    j initialise_loop
initialise_done:
    li s5, 0 #stack top index (empty)
    addi t0, s2, -1 #i = n-1
#for solving process go through stack and pop until desired element is reached for each index
nge_loop:
    blt t0, zero, nge_done
#pop while stack not empty && arr[stack.top()] <= arr[i]
pop_loop:
    beq s5, zero, pop_done #stop if stack empty
    addi t1, s5, -1 #t1 is top index since s5 is count
    slli t1, t1, 3 #t1=top*8
    add t1, s7, t1 #t1=&stack[top]
    ld t2, 0(t1) #t2=stack[top]
    slli t3, t2, 3
    add t3, s3, t3 #t3=&arr[stack[top]]
    ld t3, 0(t3) #t3=arr[stack[top]]
    slli t4, t0, 3
    add t4, s3, t4
    ld t4, 0(t4) #t4=arr[i]
    bgt t3, t4, pop_done #stop if arr[stk[top]]>arr[i]
    addi s5, s5, -1 #else pop
    j pop_loop
pop_done:
    beq s5, zero, push #if stack is empty the result stays -1, push current index
    addi t1, s5, -1 #peek
    slli t1, t1, 3
    add t1, s7, t1
    ld t2, 0(t1) #t2=stack[top] (this is an index)
    slli t1, t2, 3 #convert index to offset
    add t1, s3, t1 #get address of arr[stack[top]]
    ld t2, 0(t1) #t2=arr[stack[top]] (get the actual VALUE)
    slli t3, t0, 3
    add t3, s4, t3 #t3=&result[i]
    sd t2, 0(t3) #result[i]=arr[stack[top]] (store the VALUE, not the index)
push:
    slli t1, s5, 3
    add t1, s7, t1 #t1=&stack[s5], where s5 is count
    sd t0, 0(t1) #stack[s5]=i, current index pushed
    addi s5, s5, 1 #increment count
    addi t0, t0, -1 #decrement i
    j nge_loop
nge_done:
    li s6, 0 #i = 0
print_loop:
    bge s6, s2, print_done
    slli t0, s6, 3
    add t0, s4, t0
    ld a1, 0(t0) #a1=result[i] (second argument to printf)
    addi t1, s6, 1
    bge t1, s2, print_last #for last element we need to print value with new line instead of space at end
    la a0, fmt_space #a0=format string "%ld ", print number with space
    jal ra, printf
    j print_next
print_last:
    la a0, fmt_newline #a0=format string "%ld\n", print number with new line
    jal ra, printf
print_next:
    addi s6, s6, 1
    j print_loop
print_done:
    ld ra, 72(sp)
    ld s0, 64(sp)
    ld s1, 56(sp)
    ld s2, 48(sp)
    ld s3, 40(sp)
    ld s4, 32(sp)
    ld s5, 24(sp)
    ld s6, 16(sp)
    ld s7, 8(sp)
    ld s8, 0(sp)
    addi sp, sp, 80 #restore stack and end program
    li a0, 0
    ret
