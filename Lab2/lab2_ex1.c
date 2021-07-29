// Microprocessors Laboratory - Flow Y [7th Semester]
// Abatzi Nafsika - 031 17 198 - nafsika.abatzi@gmail.com
// Dimos Dimitris - 031 17 165 - dimitris.dimos647@gmail.com
// Lab Exercise Set 2 - Exercise 1 - C

#include <avr/io.h>
unsigned char x,F0,A,B,C,D,F1;

int main(void)
{
	DDRC = 0xff;	//PORTC->output	
	DDRB = 0x00;	//PORTB ->input
	
	while (1)
	{
		x = PINB;		//save input in x
		A = x & 0x01;	//LSB(PINB) = A
		B = x & 0x02;
		B = B>>1;		//2nd LSB(PINB) = B
		C = x & 0x04;
		C = C>>2;		// 3rd LSB(PINB) = C
		D = x & 0x08;
		D = D>>3;		//4rth LSB(PINB) = D
		
		F0 = ((~A & B) | (~B & C & B));
		F0 = (~F0);		//com F0
		F0 = F0 & 0x01;	//keep only LSB from F0
		
		F1 = (A&C)&(B|D);
		F1 = F1<<1;		//2nd LSB has now F1
		F0 = F0+F1;		//output at F0 ->1rst LSB F0 2nd LSB F1
		PORTC = F0;
		
	}
}


