// Microprocessors Laboratory - Flow Y [7th Semester]
// Abatzi Nafsika - 031 17 198 - nafsika.abatzi@gmail.com
// Dimos Dimitris - 031 17 165 - dimitris.dimos647@gmail.com
// Lab Exercise Set 3 - Exercise 1


#define F_CPU 8000000UL
#define SPARK_DELAY 15
#define PASSWORD 13

#include <avr/io.h>
#include <util/delay.h>

unsigned char scan_row_sim(int);
unsigned int scan_keypad_sim(void);
unsigned int scan_keypad_rising_edge_sim(void);
unsigned char keypad_to_ascii_sim(unsigned int);

unsigned char temp;
unsigned int previous_state = 0;
unsigned char one_two;

int main(void) {
	
	unsigned char first, second;
	unsigned int given_combo;
	
	/* IO Settings */
	DDRB = 0xFF;
	DDRC = 0xF0;
	
	/* Main Loop */
	while(1) {
		
		do {	// wait, until a button is pressed
			first = scan_keypad_rising_edge_sim();
		}while(!first);
		first = keypad_to_ascii_sim(first) - 0x30;	 // transform into the right form
		
		do {	// wait until a button is pressed
			second = scan_keypad_rising_edge_sim();
		}while(!second);
		second = keypad_to_ascii_sim(second) - 0x30; // transform into the right form
		
		given_combo = first*10 + second;
		if(given_combo == PASSWORD) {	// given combo: correct -> LEDs: ON
			PORTB = 0xff;
			_delay_ms(4000);
			PORTB = 0x00;
		}
		else {	// given combo: incorrect -> LEDs blink for 4 secs
			for(int i = 0; i < 4; ++i) {
				PORTB = 0xff;
				_delay_ms(500);
				PORTB = 0x00;
				_delay_ms(500);
			}
		}
		scan_keypad_rising_edge_sim();	// no actual need - bug fix
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