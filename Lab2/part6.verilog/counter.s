.define LED_ADDRESS 0x1000
.define SW_ADDRESS 0x3000
// r1 - used to store LED counter VALUE
// r2 - used to store LED ADD
// r3 - used for shortest delay timer
// r4 - used to store previous SW value
// r5 - used to store SW ADD
// r6 - used for largest delay counter (counts down from SW values)
// r7 - pc
MAIN:   mvt     r2, #LED_ADDRESS
		mvt     r5, #SW_ADDRESS
		mv     r1, #0

SET:    ld      r1, [r2]	//Set the LEDs to the counter value
		add     r1, #1		//Set up next number to be displayed on LEDs

RESET:  st      r4, [r5]	//Store current SW values
		st      r6, [r5]	//Store current SW values
		add		r6, #1		//in order for the counter to still count even when SW is 0, add 1

COUNT:	sub     r6, #1		//Decrease from current SW values
		bcs     #SET 		//R6 is -1, and must be set back to the SW Value

DELAY:  st      r3, #48875	//R6 is not yet -1, and short delay loop shall continue
DELAY_L:sub     r3, #1		//Count through short loop
		beq     #COUNT 		//go back to set once counter is zero, not right
		mv		pc, #DELAY_L
		