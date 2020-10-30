  
; Microprocessors Laboratory - Flow Y [7th Semester]
; Abatzi Nafsika - 031 17 198 - nafsika.abatzi@gmail.com
; Dimos Dimitris - 031 17 165 - dimitris.dimos647@gmail.com
; Lab Exercise Set 2 - Exercise 1




.include "m16def.inc"
stack: ldi r24 , low(RAMEND) ; initialize stack pointer
out SPL , r24
ldi r24 , high(RAMEND)
out SPH , r24
IO_set: ser r24 ; initialize PORTB
out DDRB, r24 ; for output
clr r24 ; initialize PORTC
out DDRC, r24 ; for input


main: ldi r26, 01 ; initialize r26
rcall left
nop
rcall right
rjmp main


left: in r24, PINC ; check input
andi r24, 04 ; keep bit 2 == PC2
cpi r24, 04 ; repeat till it's not 1
brcc left
out PORTB, r26
cpi r26, 80
brcc endl
lsl r26
rjmp left
endl: ret


right: in r24, PINC ; check input
andi r24, 04 ; keep bit 2 == PC2
cpi r24, 04 ; repeat till it's not 1
brcc right
out PORTB, r26
cpi r26, 01
breq endr
lsr r26
rjmp right
endr: ret
