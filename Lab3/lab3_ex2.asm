; Microprocessors Laboratory - Flow Y [7th Semester]
; Abatzi Nafsika - 031 17 198 - nafsika.abatzi@gmail.com
; Dimos Dimitris - 031 17 165 - dimitris.dimos647@gmail.com
; Lab Exercise Set 3 - Exercise 2

.include "m16def.inc"


.DSEG 
	_tmp_: .byte 2


.CSEG
	.org 0x0
	rjmp MAIN	; put the main program in the start of the RAM

	.equ one   = 0x10
	.equ three = 0x40
	.equ password = 0x0D

	.def temp = r20
	.def pressed  = r24
	.def first  = r21
	.def second = r22
	.def counter = r16

	; ROUTINES
leds_on: ser temp
		 out PORTB,temp
		 ret

leds_off: clr temp
		  out PORTB,temp
		  ret			 	

scan_row_sim:       		
	out PORTC, r25  	
	push r24        	
	push r25        		
	ldi r24,low(500)	
	ldi r25,high(500)
	rcall wait_usec
	pop r25
	pop r24         		
	nop
	nop             		
	in r24, PINC    	        
                                       
	andi r24 ,0x0f  	
	ret             		

scan_keypad_sim:    	
	push r26        		
	push r27        		
	ldi r25 , 0x10  		
	rcall scan_row_sim
	swap r24        		
				
	mov r27, r24    	
	ldi r25 ,0x20   		
	rcall scan_row_sim
	add r27, r24    		
	ldi r25 , 0x40  		
	rcall scan_row_sim
	swap r24        		
	mov r26, r24    	
	ldi r25 ,0x80   		
	rcall scan_row_sim
	add r26, r24    		
	movw r24, r26   	
	clr r26         		
	out PORTC,r26   	
	pop r27         		
	pop r26
	ret             		 


scan_keypad_rising_edge_sim:
	push r22                	
	push r23        
	push r26                	
	push r27
	rcall scan_keypad_sim   
	push r24                	
	push r25
	ldi r24 ,15              
	ldi r25 ,0              	
	rcall wait_msec          
	rcall scan_keypad_sim   
	pop r23                 	
	pop r22
	and r24 ,r22
	and r25 ,r23
	ldi r26 ,low(_tmp_)       	
	ldi r27 ,high(_tmp_)      	
	ld r23 ,X+
	ld r22 ,X
	st X ,r24             
	st -X ,r25              
	com r23
	com r22                 	
	and r24 ,r22
	and r25 ,r23
	pop r27                 
	pop r26                
	pop r23
	pop r22
	ret 

keypad_to_ascii_sim:
	push r26                	
	push r27                	
	movw r26 ,r24           	
	                        	
	ldi r24 ,'*'
	sbrc r26 ,0
	rjmp return_ascii
	ldi r24 ,'0'
	sbrc r26 ,1
	rjmp return_ascii
	ldi r24 ,'#'
	sbrc r26 ,2
	rjmp return_ascii
	ldi r24 ,'D'
	sbrc r26 ,3 		
	rjmp return_ascii 	
	ldi r24 ,'7'
	sbrc r26 ,4
	rjmp return_ascii
	ldi r24 ,'8'
	sbrc r26 ,5
	rjmp return_ascii
	ldi r24 ,'9'
	sbrc r26 ,6
	rjmp return_ascii 	
	ldi r24 ,'C'
	sbrc r26 ,7
	rjmp return_ascii
	ldi r24 ,'4' 		
	sbrc r27 ,0 		
	rjmp return_ascii
	ldi r24 ,'5'
	;r27
	;Α 3 2 1 B 6 5 4
	sbrc r27 ,1
	rjmp return_ascii
	ldi r24 ,'6'
	sbrc r27 ,2
	rjmp return_ascii
	ldi r24 ,'B'
	sbrc r27 ,3
	rjmp return_ascii
	ldi r24 ,'1'
	sbrc r27 ,4
	rjmp return_ascii 
	ldi r24 ,'2'
	sbrc r27 ,5
	rjmp return_ascii
	ldi r24 ,'3' 
	sbrc r27 ,6
	rjmp return_ascii
	ldi r24 ,'A'
	sbrc r27 ,7
	rjmp return_ascii
	clr r24
	rjmp return_ascii
	return_ascii:
	pop r27 		
	pop r26
	ret

write_2_nibbles_sim:push r24 
					push r25 
					ldi r24 ,low(6000) 
					ldi r25 ,high(6000)
					rcall wait_usec
					pop r25
					pop r24 
					push r24 
					in r25, PIND 
					andi r25, 0x0f 
					andi r24, 0xf0 
					add r24, r25 
					out PORTD, r24 
					sbi PORTD, PD3 
					cbi PORTD, PD3 
					push r24 
					ldi r24 ,low(6000) 
					ldi r25 ,high(6000)
					rcall wait_usec
					pop r25
					pop r24
					pop r24 
					swap r24 
					andi r24 ,0xf0 
					add r24, r25
					out PORTD, r24
					sbi PORTD, PD3 
					cbi PORTD, PD3
					ret

lcd_data_sim:push r24
			push r25
			sbi PORTD, PD2 
			rcall write_2_nibbles_sim 
			ldi r24 ,43 
			ldi r25 ,0 
			rcall wait_usec
			pop r25 
			pop r24
			ret

lcd_command_sim:push r24 
				push r25
				cbi PORTD, PD2 
				rcall write_2_nibbles_sim 
				ldi r24, 39
				ldi r25, 0 
				rcall wait_usec 
				pop r25 
				pop r24
				ret

lcd_init_sim:   push r24 
				push r25 
				ldi r24, 40 
				ldi r25, 0 
				rcall wait_msec 
				ldi r24, 0x30 
				out PORTD, r24 
				sbi PORTD, PD3 
				cbi PORTD, PD3 
				ldi r24, 39
				ldi r25, 0 
				rcall wait_usec 
				push r24 
				push r25
				ldi r24,low(1000) 
				ldi r25,high(1000)
				rcall wait_usec
				pop r25
				pop r24 
				ldi r24, 0x30
				out PORTD, r24
				sbi PORTD, PD3
				cbi PORTD, PD3
				ldi r24,39
				ldi r25,0
				rcall wait_usec
				push r24 
				push r25 
				ldi r24 ,low(1000) 
				ldi r25 ,high(1000)
				rcall wait_usec
				pop r25
				pop r24 
				ldi r24,0x20 
				out PORTD, r24
				sbi PORTD, PD3
				cbi PORTD, PD3
				ldi r24,39
				ldi r25,0
				rcall wait_usec
				push r24
				push r25
				ldi r24 ,low(1000) 
				ldi r25 ,high(1000)
				rcall wait_usec
				pop r25
				pop r24 
				ldi r24,0x28 
				rcall lcd_command_sim
				ldi r24,0x0c 
				rcall lcd_command_sim
				ldi r24,0x01 
				rcall lcd_command_sim
				ldi r24, low(1530)
				ldi r25, high(1530)
				rcall wait_usec
				ldi r24 ,0x06 
				rcall lcd_command_sim 
				pop r25 
				pop r24
				ret

wait_msec:	push r24 
			push r25
			ldi r24 , low(998) 
			ldi r25 , high(998) 
			rcall wait_usec
			pop r25
			pop r24 
			sbiw r24 , 1 
			brne wait_msec 
			ret 

wait_usec:	sbiw r24 ,1 
			nop 
			nop 
			nop 
			nop
			brne wait_usec 
			ret 

MAIN:
	; stack initialization
	ldi temp,LOW(RAMEND)
	out SPL, temp
	ldi temp,HIGH(RAMEND)
	out SPH, temp				

	; I/O definition. input: PORTC, output: PORTB, LCD Display
	ldi temp, (1 << PC7) | (1 << PC6) | (1 << PC5) | (1 << PC4)
	out DDRC, temp       
	ser temp              
	out DDRB, temp
	out DDRD, temp      

START:	clr r24
		rcall lcd_init_sim 
		rcall leds_off	
		clr counter	
		
		; GETTING INPUT
digit1:	rcall scan_keypad_rising_edge_sim	; check for pushed bottons
		rcall keypad_to_ascii_sim
		cpi pressed, 0x00					
		breq digit1						; loop until first button is pressed

		subi pressed, 0x30				; convert from ascii to normal
		mov first, pressed				; save first input digit, before reading the second

digit2:	rcall scan_keypad_rising_edge_sim	; check for pushed bottons
		rcall keypad_to_ascii_sim
		cpi pressed, 0x00					
		breq digit2						; loop until a second button is pressed

		subi pressed, 0x30				; convert from ascii to normal
		mov second, pressed				; save second input digit

		; check if input matches password
		ldi temp, 0x0a			; first * 10
		mul first, temp	
		mov first, r0
		add first, second 			; password = first*10 + second
		cpi first, password		
		brne wrong_pass			; input == PASSWORD?

		; correct input
		rcall leds_on
		
		ldi r24, 'W'
		rcall lcd_data_sim  	; αποστολή ενός byte δεδομένων στον ελεγκτή της οθόνης lcd (για την εμφάνιση του "W")
		ldi r24, 'E'
		rcall lcd_data_sim  	; ομοίως για "E"      
		ldi r24, 'L'        
		rcall lcd_data_sim  	; ομοίως για "L"
		ldi r24, 'C'        
		rcall lcd_data_sim  	; ομοίως για "C"
		ldi r24, 'O'
		rcall lcd_data_sim  	; ομοίως για "O"
		ldi r24, 'M'
		rcall lcd_data_sim  	; ομοίως για "M"
		ldi r24, 'E'
		rcall lcd_data_sim  	; ομοίως για "E"
		ldi r24, ' '
		rcall lcd_data_sim  	; ομοίως για " "
		ldi r24, '1'
		rcall lcd_data_sim  	; ομοίως για "0"
		ldi r24, '3'
		rcall lcd_data_sim  	; ομοίως για "2"
		; set delay = 4 sec
		ldi r24,low(4000)			
		ldi r25,high(4000)
		rcall wait_msec
		; --------- NO ACTUAL NEED - BUG FIX -------
		rcall scan_keypad_rising_edge_sim
		; ------------------------------------------	
		rjmp START					


wrong_pass:  rcall scan_keypad_rising_edge_sim ; contine reading from keyboard
											   ; but ignore it

			ldi r24, 'A'
			rcall lcd_data_sim  	; αποστολή ενός byte δεδομένων στον ελεγκτή της οθόνης lcd για την εμφάνιση του "A"
			ldi r24, 'L'
			rcall lcd_data_sim  	; ομοίως για "L"
			ldi r24, 'A'
			rcall lcd_data_sim  	; ομοίως για "A"
			ldi r24, 'R'
			rcall lcd_data_sim  	; ομοίως για "R"
			ldi r24, 'M'
			rcall lcd_data_sim  	; ομοίως για "M"
			ldi r24, ' '
			rcall lcd_data_sim  	; ομοίως για " "
			ldi r24, 'O'
			rcall lcd_data_sim  	; ομοίως για "O"
			ldi r24, 'N'
			rcall lcd_data_sim  	; ομοίως για "N"
			 
	wrong:	 rcall leds_on
			 push r24							; leds on for 0.5 sec
			 push r25
			 ldi r24,low(500)
			 ldi r25,high(500)
			 rcall wait_msec
			 pop r25
			 pop r24
			 
			 rcall leds_off
			 push r24							; leds off for 0.5 sec
			 push r25
			 ldi r24,low(500)
			 ldi r25,high(500)
			 rcall wait_msec
			 pop r25
			 pop r24
			 inc counter						
			 cpi counter,0x04
			 brne wrong							; loop 4 times 	
			 clr counter						; then reinitialize counter
		
			; --------- NO ACTUAL NEED - BUG FIX -------
			rcall scan_keypad_rising_edge_sim
			; ------------------------------------------
			rjmp START							; start again