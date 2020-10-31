// Microprocessors Laboratory - Flow Y [7th Semester]
// Abatzi Nafsika - 031 17 198 - nafsika.abatzi@gmail.com
// Dimos Dimitris - 031 17 165 - dimitris.dimos647@gmail.com
// Lab Exercise Set 2 - Exercise 3

#include <avr/io.h>
#include <avr/interrupt.h>
//interrupt [EXT_INT0]
ISR(INT0_vect)  	// External Interrupt 0 service routine
	{
		b = PORTB;
		a = 0x01;		//a = 1
		Led = PINA;
		cnt = 0x00;
	for(i=0; i<8; i++){	
			c = b & a;		//mask LSB of PORTB
			if(c==0x01){
				cnt++;
			}
			b = b>>1;		//rotate so the 2nd LSB is checked		
	}
	check = Led & 0x04;	//check only LSB 2 from PORTA
	if(check == 0x00){		//if it is OFF
		a = 0x01;
		Led=0x00;
		for(i=1; i<=cnt; i++){
			Led = Led+a;
			a = a<<1;
		}
		PORTC = Led;
	}
	
	else{		//if PA2 is ON
		PORTC = cnt;
		}		
}