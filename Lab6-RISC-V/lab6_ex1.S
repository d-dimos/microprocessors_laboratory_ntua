.globl main

.equ N,10

.data
A: .word 0,1,2,7,-8,4,5,-12,11,-2
B: .word 0,1,2,7,-8,4,5,12,-11,-2

.bss
C: .space 4*N

.text
main:
    la t0, A    # address of A --> t0 (t0 points at A[0])
    la t1, B    # address of B --> t1 (t1 points at B[0])
    add t1, t1, 4*(N-1)     # now t1 points to B[N-1]
    li t2, 0    # i = 0 (iterator on the C array)
    li t6, 4*N  # t6 = N (when i == t6, program finishes)

process:
    beq t2, t6, end_process # end condition (i == N)
    lw t3, 0(t0)    # t3 <-- A[i]
    lw t4, 0(t1)    # t4 <-- B[N-1-i]

    add t5, t3, t4  # temp = A[i] + B[N-1-i]
    bge t5, zero, sign_ok   # if temp >= 0 then go on
    neg t5, t5      # otherwise reverse sign

sign_ok:
    la t3, C    # t3 <-- address of C (t3 points at C[0])
    add t3, t3, t2  # now t3 points at C[i]
    sw t5, 0(t3)    # t5 --> C[i], meaning C[i] = | A[i] + B[N-1-i] | 
    addi t0, t0, 4  # t0 points to the next 4 bytes (1 word): the next A cell
    addi t1, t1, -4 # t1 points to the previous 4 bytes (1 word): the previous B cell
    addi t2, t2, 4  # i++
    j process

end_process:

.end