#define GPIO_SWs    0x80001400
#define GPIO_LEDs   0x80001404
#define GPIO_INOUT  0x80001408

#define READ_GPIO(dir) (*(volatile unsigned *)dir)
#define WRITE_GPIO(dir, value) { (*(volatile unsigned *)dir) = (value); }

int main (void) {
    int En_Value = 0xFFFF;
    unsigned int switches_value, negate, temp, count, MSB;

    WRITE_GPIO(GPIO_INOUT, En_Value);       // IO Set
    switches_value = READ_GPIO(GPIO_SWs);   // Read switches value

    while(1) { 

        MSB = switches_value >> 31;                     // keep the MSB switch value
        negate = (switches_value >> 16) ^ (0xFFFF);     // keep and negate the 16 MSB
                                                        // (y XOR 1 = -y)
        temp = negate;                                  // temporary variable
        count = 0;                                      // counts the 1s in the negation

        // counting 1s process
        while(temp) {           // process ends when there are no more 1s
            if(temp & 1)        // if LSB == 1 then count++
                count++;
            temp = temp >> 1;   // get rid of the LSB by shifting left 
        }

        while(count--) {        // loop as many times as the 1s (= count)
            WRITE_GPIO(GPIO_LEDs, negate);  // show negation on LEDs
            // delay
            WRITE_GPIO(GPIO_LEDs, 0);       // turn LEDs OFF
        }

        do {    // keep reading switches until MSB changes from the previous value
            switches_value = READ_GPIO(GPIO_SWs);
        } while(((switches_value & 0x80000000)>>31) == MSB); // checks if new MSB == previous MSB

    }
    return(0);
}