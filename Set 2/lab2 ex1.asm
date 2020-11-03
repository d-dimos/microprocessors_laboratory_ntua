; Microprocessors Laboratory - Flow Y [7th Semester]
; Abatzi Nafsika - 031 17 198 - nafsika.abatzi@gmail.com
; Dimos Dimitris - 031 17 165 - dimitris.dimos647@gmail.com
; Lab Exercise Set 2 - Exercise 1

.include "m16def.inc"
.DEF A = r16
.DEF B = r17
.DEF C = r18
.DEF D = r19
.DEF F = r20
.DEF T = r21

stack: ldi r24 , low(RAMEND)
	out SPL , r24
	ldi r24 , high(RAMEND)
	out SPH , r24

IO_set: ser r24 ; initialize PORTB
	out DDRB, r24 ; for output
	clr r24 ; initialize PORTC
	out DDRC, r24 ; for input

main: clr F ; ready F
	in T, PINC ; T <-- input
	mov A, T ; LSB(A) = A
	lsr T
	mov B, T ; LSB(B) = B
	lsr T
	mov C, T ; LSB(C) = C
	lsr T
	mov D, T ; LSB(D) = D
	mov T, B ; save B in T
	mov F, B
	com F ; LSB(F) = B'
	and F, A ; LSB(F) = AB'
	com C ; LSB(C) = C'
	and B, C ; LSB(B) = BC'
	or F, B ; LSB(F) = (AB' + BC'D)
	com F ; LSB(F) = (AB' + BC'D)' <---
	com C ; restore C: LSB(C) = C
	mov B, T ; restore B: LSB(B) = B
	or A, C ; LSB(A) = A + C
	or B, D ; LSB(B) = B + D
	and A, B ; LSB(A) = (A + C)(B + D) <---
	lsl A ; A1 = (A + C)(B + D)
	andi A, 2 ; A = F1
	andi F, 1 ; F = F0or F, A ; F = F + A = OUTPUT
	out PORTB, F
	rjmp main
