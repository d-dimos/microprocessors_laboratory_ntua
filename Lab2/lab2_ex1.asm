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
.DEF b = r22

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
	  mov F, A	; save A in F
	  com F ; LSB(F) = A'
	  and F, B ; LSB(F) = A'B
	  mov b,B	;save B in b
	  com B ; LSB(B) = B'
	  and B, C ; LSB(B) = B'C
	  and B,D	;LSB(B) = B'CD
	  or F, B ; LSB(F) = (A'B + B'CD)
	  com F ; LSB(F) = (A'B + B'CD)' <---
	  
	  mov B,b	;restore B
	  and A, C ; LSB(A) = AC
	  or B, D ; LSB(B) = B + D
	  and A, B ; LSB(A) = (AC)(B + D) <---
	  lsl A ; A1 = (AC)(B + D)
	  andi A, 2 ; A = F1
	  andi F, 1 ; F = F0A ; F = F + A = OUTPUT
	  add F,A ; F = F + A = OUTPUT
	  out PORTB, F
	  rjmp main