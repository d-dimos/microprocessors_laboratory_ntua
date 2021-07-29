.globl main

.text
main:
    
    li t0, 0x80001404   # t0 = LEDs address
    li t1, 0x80001408   # t1 = IO address
    li t2, 0xFFFF       # 0xFFFF: setting LEDs to output
    sw t2, 0(t1)        

    # t0 will always contain LEDs address
    # t1 holds the value of static LEDs (background)
    # t2 holds the value of the moving LED (shifter)
    # t3 hold the limit value of the shifter

    mv t1,zero  # initially, background LEDs are OFF
    li t3,0x8000    # initial limit is = 1000 0000 0000 0000
    li t5,0xFFFF    # when output is t5 (== 0xFFFF), reverse

left:
    li t2,1     # initialize shifter
rep1:
    add t4,t1,t2    # result = background + shifter
    sw t4, 0(t0)    # output result to LEDs
    beq t4,t5,end_left  # if (LEDs == 1111 1111 1111 1111) then begin reverse
    slli t2,t2,1    # shifter goes left
    bne t2,t3,rep1  # if shifter has not reached limit, repeat 

    add t1,t1,t2    # otherwise, update background (the static LEDs)
    sw t1, 0(t0)    # output background
    srli t3,t3,1    # lower the shifter limit for the next round
    j left
end_left:


    mv t1,t4    # update background
    li t5,0     # result == t5 will signify the end of program

# inverse process, now shifter goes right
right:
    li t2,0x8000    # initialize shifter
rep2:
    xor t4,t1,t2    # result = background xor shifter
    sw t4, 0(t0)    # output result to LEDs
    beq t4,t5,end_right # if we output a result of 0x0000 --> end
    srli t2,t2,1    # shifter goes right
    bne t2,t3,rep2  # if shifter has not reached limit, repeat 

    xor t1,t1,t2    # otherwise, update background
    sw t1, 0(t0)    # output background
    slli t3,t3,1    # increase shifter limit for the next round
    j right

end_right:

.end