  
; Microprocessors Laboratory - Flow Y [7th Semester]
; Abatzi Nafsika - 031 17 198 - nafsika.abatzi@gmail.com
; Dimos Dimitris - 031 17 165 - dimitris.dimos647@gmail.com
; Lab Exercise Set 2 - Exercise 2

rjmp reset


reset: ldi r24 ,( 1 << ISC11) | ( 1 << ISC10)
		out MCUCR , r24 
		ldi r24 ,( 1 << INT1) ; INT1 is allowed
		out GICR , r24
		sei

IO_set: ser r24 ; initialize PORTC
		out DDRC, r24 ; for output
		clr r24 ; initialize PORTA
		out DDRC, r24	;for input when INT1 occures
		.org 0x4	;addr of INT1 is at 0x4
rjmp ISR1

main_program: out PORTC , r26 ; show counter at PORTC
			  inc r26 ; increase counter
	  		  rjmp main_program ; loop


ISR1:	in r21,PINA	;load PINA
		andi r21,0xc0	;check bits 6 and 7
		cpi r21,0xc0
		breq cont	;if bits 6 and 7 ->'1' continue
		rjmp ISR1	;else wait

cont:	inc r23	;increase the counter for the interupts INT1 till now
		out PORTB,r23	;show the counter at PORTB
		reti
