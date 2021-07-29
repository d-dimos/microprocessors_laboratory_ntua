#define GPIO_SWs    0x80001400
#define GPIO_LEDs   0x80001404
#define GPIO_INOUT  0x80001408

#define READ_GPIO(dir) (*(volatile unsigned *)dir)
#define WRITE_GPIO(dir, value) { (*(volatile unsigned *)dir) = (value); }

int main (void) {
  int En_Value=0xFFFF, switches_value;
  unsigned int four_MSB, four_LSB, result, overflow = 0;

  WRITE_GPIO(GPIO_INOUT, En_Value);

  while(1) { 
    switches_value = READ_GPIO(GPIO_SWs);   // read switches

    four_MSB = (switches_value & 0xF0000000) >> 28;  // isolate 4 MSBs 
    four_LSB = (switches_value & 0x000F0000) >> 16;  // isolate 4 LSBs

    result = four_MSB + four_LSB;           // calculate result
    overflow = (result & 0x00000010) >> 4;  // check overflow

    if(overflow) {   // if we got an overflow: LED4 = ON (and only)
      WRITE_GPIO(GPIO_LEDs, 0x10);
    }
    else            // else show result
      WRITE_GPIO(GPIO_LEDs, result);
  }

  return(0);
}