.globl make_node
make_node:
    addi sp, sp, -16
    sd ra, 8(sp) # save return address on stack
    sd s0, 0(sp)
    mv s0, a0 # save val into s0
    li a0, 24 #malloc size of struct at a0
    call malloc # a0 is the pointer to new node
    sd s0, 0(a0) #save node val
    sd zero, 8(a0) #set node left as NULL
    sd zero, 16(a0) #set node right as NULL
    ld ra, 8(sp)
    ld s0, 0(sp)
    addi sp, sp, 16
    ret




.globl insert
insert:
    add sp, sp, -32 #make space for ra and s0 and s1, 32 is used and not 24 since stack pointer should be offset by a multiple of 16
    sd ra, 24(sp) #store ra on stack
    sd s0, 16(sp) #store s0 on stack
    sd s1, 8(sp) #store s1 on stack

    mv s0, a0 #store root node in s0
    mv s1, a1 #store value to be inserted in a1

    beq zero, s0, insert_null #branch if root is NULL

insert_notnull:
    ld t0, 0(s0)
    blt s1, t0, insert_left #if val<root->val insert left of tree
    beq s1, t0, insert_exists #if val=root->val return the root
#if val is not <= root->val then insert right
insert_right:
    ld a0, 16(s0) #set root->right node argument for insert
    mv a1, s1 #set val argument for insert
    call insert
    sd a0, 16(s0) #store result of insertion to right subtree in the right subtree
    j insert_exists #return the root node after insertion

insert_left:
    ld a0, 8(s0) #set root->left node argument for insert
    mv a1, s1  #set val argument for insert
    call insert
    sd a0, 8(s0) #store result of insertion to left subtree in the left subtree

insert_exists:
    mv a0, s0 #if value exists return value 
    j insert_end

insert_null:
    mv a0, s1 #if value does not exist make node and return
    call make_node

insert_end:
    ld ra, 24(sp)
    ld s0, 16(sp)
    ld s1, 8(sp)
    addi sp, sp, 32
    ret







.globl get
get:
    add sp, sp, -32 
    sd ra, 24(sp) # save return address on stack
    sd s0, 16(sp) # save s0 and s1 on stack
    sd s1, 8(sp)

    mv s0, a0 # store root node in s0
    mv s1, a1 # store value in s1

    beq zero, s0, get_end # if root is null 
    ld t0, 0(s0) # store root->val in t0
    beq t0, s1, get_end # if value=root->val go to end
    blt s1, t0, get_left #if value<root->val go left
#if value>root->val go right
get_right:
    ld a0, 16(s0) #set root->right as argument for get 
    mv a1, s1 # set value as argument for get
    call get
    j get_end

get_left:
    ld a0, 8(s0) #set root->left as argument for get
    mv a1, s1 #set value as argument for get
    call get

get_end:
    ld ra, 24(sp)
    ld s0, 16(sp)
    ld s1, 8(sp)
    add sp, sp, 32
    ret







.globl getAtMost
getAtMost:
    add sp, sp, -32 
    sd ra, 24(sp) # store ra on stack
    sd s0, 16(sp)
    sd s1, 8(sp) # store s0 and s1 on stack

    mv s0, a1 # store value in a0
    mv s1, a0 # store root node in a1
    li t0, -1 # default answer = -1

getAtMostloop:
    beq zero, s0, getAtMost_end #if root is null go to end
    ld t1, 0(s0) #store root->val in t1
    blt s1, t1, go_left #if value<root->val go left
    mv t0, t1 #set answer to current root->val
    ld s0, 16(s0) #change root=root->right
    j getAtMostloop #go back to start of loop

go_left:
    ld s0, 8(s0) #set root=root->left
    j getAtMostloop #go back to start of loop

getAtMost_end:
    mv a0, t0 

    ld ra, 24(sp)
    ld s0, 16(sp)
    ld s1, 8(sp)
    add sp, sp, 32
    ret



    

    


