#include "address_map_nios2.h"
/********************************************************************************
 * This program demonstrates the use of the Accelerometer in the Computer
*System.
 *
 * It performs the following:
 *  1. Reads the x-axis value from the accelerometer
 *  2. Finds the change in the x-axis
 *  3. Displays the associated tilt of the board on the LEDs
********************************************************************************/

void ADXL345_WRITE(char, char);
char ADXL345_READ(char);
int LED_val(int x_axis, int signed_bit);

/*
 * The base address for the accelerometer registers.
 * The address register is at a +0 offset. The data register is at a +1 offset.
 * Use a volatile pointer for I/O registers (volatile means that IO load
 * and store instructions will be used to access these pointer locations,
 * instead of regular memory loads and stores).
 */
volatile char * AccelerometerBase = (volatile char *)ACCELEROMETER_BASE;

// Writes 'data' to the given register ('reg') of the ADXL345 accelerometer.
void ADXL345_WRITE(char reg, char data) {
    *(AccelerometerBase)     = reg;
    *(AccelerometerBase + 1) = data;
}

// Reads the data from the given register ('reg') of the ADXL345 accelerometer.
char ADXL345_READ(char reg) {
    *(AccelerometerBase) = reg;
    return *(AccelerometerBase + 1);
}

// Returns the associated LED value from the x_axis value
int LED_val(int x_axis, int signed_bit) {
    switch (x_axis) {
    case 0x0:
        return 0x18;
    case 0x1:
        return signed_bit ? 0x8 : 0x10;
    case 0x2:
        return signed_bit ? 0xc : 0x30;
    case 0x3:
        return signed_bit ? 0x4 : 0x20;
    case 0x4:
        return signed_bit ? 0x6 : 0x60;
    case 0x5:
        return signed_bit ? 0x2 : 0x40;
    case 0x6:
        return signed_bit ? 0x3 : 0xc0;
    default:
        return signed_bit ? 0x1 : 0x80;
    }
}

int main(void) {
    volatile int * LEDs = (volatile int *)LED_BASE;

    // Read the device ID from the accelerometer. Should be 0xE5.
    int device_id = ADXL345_READ(0x00) & 0x00FF;
    *LEDs         = device_id;

    int temp, x_axis, signed_bit, abs_select_high;

    // Change the activity threshold of the accelerometer
    ADXL345_WRITE(0x24, 0x08);

    while (1) {
        // Read from the INT_SOURCE register and check for ACTIVITY.
        if (ADXL345_READ(0x30) & 0x10) {
            // Select and read the lower-order byte of the x-axis value
            x_axis = ADXL345_READ(0x32) & 0x00FF;

            // Select and read the higher-order byte of the x-axis value
            temp = ADXL345_READ(0x33) & 0x0003;

            // Combine the two x-axis bytes
            x_axis = ((temp << 8) | x_axis);

            // Only take the sign + 4 MSB
            x_axis     = (x_axis & 0x03E0) >> 5;
            signed_bit = (x_axis & 0x10) >> 4;

            // Take the absolute value of the x-axis value
            if (signed_bit)
                x_axis = ~x_axis & 0xF;

            // Write to LED display
            *LEDs = LED_val(x_axis, signed_bit);
        }
    }

    return 0;
}
