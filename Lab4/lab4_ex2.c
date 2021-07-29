// Microprocessors Laboratory - Flow Y [7th Semester]
// Abatzi Nafsika - 031 17 198 - nafsika.abatzi@gmail.com
// Dimos Dimitris - 031 17 165 - dimitris.dimos647@gmail.com
// Lab Exercise Set 4 - Exercise 2


#define F_CPU 8000000UL
#define SPARK_DELAY 15
#define PASSWORD 13

#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>

unsigned char scan_row_sim(int);
unsigned int scan_keypad_sim(void);
unsigned int scan_keypad_rising_edge_sim(void);
unsigned char keypad_to_ascii_sim(unsigned int);
unsigned int keypad(void);
void ADC_init(void);
unsigned char temp,i,level,keypad_check,flag;
unsigned int previous_state = 0;
unsigned char one_two;


ISR(TIMER1_OVF_vect){
			
	ADCSRA =0xEF;
}

ISR(ADC_vect) {	// check the CO level 
	
	unsigned char flag_ = 0;

	if(21<=ADC & ADC<=113){	//Cx = [0,35] ppm
		level = 0x01;
		flag_ = 1;
		//PORTB = 0x01;
		//TCNT1H = 0xfc;		
		//TCNT1L = 0xf3;		//Timer1 overflows in 100 msec
	}


	if(113<ADC & ADC<=205){	// Cx = [36,70] ppm
		level = 0x02;
		flag_ = 1;
		//PORTB = 0x02;
		
		//TCNT1H = 0xfc;		
		//TCNT1L = 0xf3;		//Timer1 overflows in 100 msec
	}

	 if(205<ADC & ADC<=298  ){ 		// Cx = [71,105] ppm
		 level = 0xc;
		 flag_ = 1;
		 //TCNT1H = 0xfc;		
		 //TCNT1L = 0xf3;		
		 	 
	 }
	 
	if(298<ADC & ADC<=614){ 		 // Cx = [105, ] ppm
		level = 0x30;
		flag_ = 1;
		//TCNT1H = 0xfc;		
		//TCNT1L = 0xf3;		//Timer1 overflows in 100 msec
	}
	
	if(!flag_)
		level = 0x00;
		TCNT1H = 0xfc;		
		TCNT1L = 0xf3;			//Timer1 overflows in 100 msec
	}

int main(void) {
		/* IO Settings */
		DDRB = 0xFF;
		DDRC = 0xF0;
	
		TIMSK = (1 << TOIE1);					//Timer1 ,interrupt enable
		TCCR1B =(1<<CS12) | (0<<CS11) | (1<<CS10);		//frequency of Timer1 8MHz/1024
		
		sei();	

while(1){
	
	
flag = keypad();
if(flag){								// if any password was given
	if(flag!=PASSWORD){						// and it was wrong
		for(int i=0; i<4; i++){					// PB7 blinks for 4 secs
		if(level==0x01 | level==0x02){				// and level of CO is also shown at the leds
			PORTB = level+0x80;
			_delay_ms(500);					// safe zones
			PORTB = level;
			_delay_ms(500);		
		}
		
		if (level==0xc | level==0x30){				// alarm zones
			
			PORTB = level+0x80;
			_delay_ms(500);
			PORTB = 0x00;
			_delay_ms(500);
		}
		
		}
	}
	
	if(flag==PASSWORD){				// if the password was correct PB7 is ON for 4 secs and the level of CO is also shown
		
		if (level==0xc | level==0x30){		// if the alarm was ON, closes for 4 secs
			PORTB = 0x80;
			_delay_ms(4000);
		}
		
		unsigned char m=0;
		if(level==0x01 | level==0x02){		// safe levels of CO 
			
		while(m!=8){
			PORTB = 0x80 +level;
			_delay_ms(500);
			m++;
			if ((level==0xc | level==0x30)){		// if within these 4 secs the level of CO goes to alarm zone
				while (m!=8)
				{
					PORTB = 0x80;
					_delay_ms(500);
					//m++;				// show it
					PORTB = level+0x80;
					_delay_ms(500);
					m++;
				
				}
			}
			
		}	

	}
	}
}

// No combo was given, just show the CO levels
else{
	if(level==0x01 | level==0x02){
		PORTB = level;
	}
	
	if(level==0xc | level==0x30){
		for(int i=0; i<2; i++){		// Cx = [71,105] ppm ALARM
			PORTB = level;
			_delay_ms(500);
			PORTB = 0x00;
			_delay_ms(500);
			
		}
	}
}

}

}

void ADC_init(void)
{
	ADMUX = (1<<REFS0);
	ADCSRA = (1<<ADEN)|(1<<ADSC)|(1<<ADIE)|(1<<ADPS2)|(1<<ADPS1)|(1<<ADPS0);
}

unsigned int keypad(void){
	int if_pressed = 0x00;
	unsigned char first, second;
	unsigned int given_combo;
				// wait, until a button is pressed
			first = scan_keypad_rising_edge_sim();
			if( first == 0){
			if_pressed = 0x00;
			return if_pressed;
			}
			
			else{
			first = keypad_to_ascii_sim(first) - 0x30;	 // transform into the right form
			
			do {	// wait until a button is pressed
				second = scan_keypad_rising_edge_sim();
			}while(!second);
			second = keypad_to_ascii_sim(second) - 0x30; 	// transform into the right form
			
			given_combo = first*10 + second;
			scan_keypad_rising_edge_sim();			// no actual need - bug fix
		return given_combo;
			}
}



unsigned char scan_row_sim(int row) {
	volatile unsigned char pressed_row;

	temp = 0x08;
	PORTC = temp << row;
	
	_delay_us(500);
	asm("nop");
	asm("nop");
	pressed_row = PINC & 0x0f;

	return pressed_row;
}


unsigned int scan_keypad_sim(void) {
	unsigned int row1, row2, row3, row4;
	int pressed_button = 0x00;

	row1 = scan_row_sim(1);
	row2 = scan_row_sim(2);
	row3 = scan_row_sim(3);
	row4 = scan_row_sim(4);

	pressed_button = (row1 << 4) | (row2);
	if(pressed_button)
	one_two = 1;
	else {
		one_two = 0;
		pressed_button = (row3 <<4 ) | (row4);
	}
	PORTC = 0x00;
	return pressed_button;
}


unsigned int scan_keypad_rising_edge_sim(void) {
	
	unsigned int button1, button2, current_state, final_state;

	button1 = scan_keypad_sim();
	_delay_ms(SPARK_DELAY);
	button2 = scan_keypad_sim();
	current_state = button1 & button2;
	final_state = current_state & (~ previous_state);
	previous_state = current_state;

	return final_state;
}


unsigned char keypad_to_ascii_sim(unsigned int final_state) {
	
	if(one_two) {
		switch (final_state) {
			case 0x10:
			return '1';
			case 0x20:
			return '2';
			case 0x40:
			return '3';
			case 0x80:
			return 'A';
			case 0x01:
			return '4';
			case 0x02:
			return '5';
			case 0x04:
			return '6';
			case 0x08:
			return 'B';
		}
	}
	else {
		switch(final_state){
			case 0x10:
			return '7';
			case 0x20:
			return '8';
			case 0x40:
			return '9';
			case 0x80:
			return 'C';
			case 0x01:
			return '*';
			case 0x02:
			return '0';
			case 0x04:
			return '#';
			case 0x08:
			return 'D';
		}
	}
}
			
