
		.text                   // executable code follows
		.global _start    


/* Program that counts consecutive 1's, 0's, and alternating 1's and 0's*/
//Chose to implement this using branches
//Because I found it more technically challenging
              
_start:                             
		MOV     R2, #TEST_NUM   // R2 will point to word data
		LDR		R4, [R2], #4	//Store 55555555 into R4, advance memory

		MOV     R0, #0          // R0 will hold the result
		MOV		R5, #0			// R5 will hold the result of 1's
		MOV		R6, #0			// R6 will hold the result of 0's
		MOV		R7, #0			// R6 will hold the result of 0's	

NXT_WRD:
		
		LDR     R1, [R2]	    // Ld word into R1
		CMP		R1, #0			// Check to see if we've hit word zero
		BEQ		DISPLAY		    // If zero, display results!

		//Counts ONES
		BL		ONES			//Count the ones
		CMP		R5, R0
		MOVLT	R5, R0			// If R5 < R0, load R0 -> R5
		MOV     R0, #0			// Reset R0

		//Counts ZEROS
		LDR     R1, [R2]	    // Ld word into R1
		MVN		R1, R1			// Invert
		BL		ONES			//Count the ones - actually counting zeros now
		CMP		R6, R0
		MOVLT	R6, R0			// If R6 < R0, load R0 -> R6
		MOV     R0, #0			// Reset R0

		//Counts ALTERNATE
		LDR     R3, [R2]	    // Ld word into R3
		EOR		R1, R4, R3		// Find string
		BL		ONES			// Count the ones
		CMP		R7, R0
		MOVLT	R7, R0			// If R7 < R0, load R0 -> R7

		LDR     R3, [R2]	    // Ld word into R3
		MVN		R1, R3			// Move Neg of word into R1
		EOR		R1, R4, R1		// Find string
		BL		ONES			// Count the ones - actually counting zeros now
		CMP		R7, R0			// Check if theres more 0's than 1's
		MOVLT	R7, R0			// If R7 < R0, load R0 -> R7
		MOV     R0, #0			// Reset R0

		ADD		R2, #4			//Move to next word
		B		NXT_WRD

//Reqires R1=word, Returns R0=count, Uses R3
ONES:   CMP     R1, #0          // loop until the data contains no more 1's
		MOVEQ   PC, LR
		LSR     R3, R1, #1      // perform SHIFT, followed by AND
		AND     R1, R1, R3      
		ADD     R0, #1          // count the string length so far
		B       ONES



/* Subroutine that converts a binary number to decimal */
DIVIDE:     MOV    R2, #0
CONT:       CMP    R0, #10
            BLT    DIV_END
            SUB    R0, #10
            ADD    R2, #1
            B      CONT
DIV_END:    MOV    R1, R2     // quotient in R1 (remainder in R0)
            MOV    PC, LR

/* Subroutine to convert the digits from 0 to 9 to be shown on a HEX display.
 *    Parameters: R0 = the decimal value of the digit to be displayed
 *    Returns: R0 = bit patterm to be written to the HEX display
 */

SEG7_CODE:  MOV     R1, #BIT_CODES  
            ADD     R1, R0         // index into the BIT_CODES "array"
            LDRB    R0, [R1]       // load the bit pattern (to be returned)
            MOV     PC, LR              

BIT_CODES:  .byte   0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110
            .byte   0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01100111
            .skip   2      // pad with 2 bytes to maintain word alignment



/* Display R5 on HEX1-0, R6 on HEX3-2 and R7 on HEX5-4 */
DISPLAY:    LDR     R8, =0xFF200020 // base address of HEX3-HEX0

            //R6 -> HEX3-2
            MOV     R0, R6          // display R6
            BL      DIVIDE          // ones digit will be in R0; tens
                                    // digit in R1
            MOV     R9, R1          // save the tens digit
            BL      SEG7_CODE       
            MOV     R4, R0          // save bit code
            MOV     R0, R9          // retrieve the tens digit, get bit
                                    // code
            BL      SEG7_CODE       
            LSL     R0, #8          // Shift the bit code of the 10's up to make room for the 1's
            ORR     R4, R0          // Move the 1 bits into their spot

            LSL     R4, #16          // Shift the bit code of R6 up to make room for R6
            
            //R5 -> HEX1-0
            MOV     R0, R5          // display R5 on HEX1-0
            BL      DIVIDE          // ones digit will be in R0; tens
                                    // digit in R1
            MOV     R9, R1          // save the tens digit
            BL      SEG7_CODE       
            ORR     R4, R0          // save bit code
            MOV     R0, R9          // retrieve the tens digit, get bit
                                    // code
            BL      SEG7_CODE       
            LSL     R0, #8          // Shift the bit code of the 10's up to make room for the 1's
            ORR     R4, R0          // Move the 1 bits into their spot

            STR     R4, [R8]        // Move the bits into the HEX register

            //R7 -> HEX5-4
            LDR     R8, =0xFF200030 // base address of HEX5-HEX4

            MOV     R0, R7          // display R7 on HEX5-4
            BL      DIVIDE          // ones digit will be in R0; tens
                                    // digit in R1
            MOV     R9, R1          // save the tens digit
            BL      SEG7_CODE       
            ORR     R4, R0          // save bit code
            MOV     R0, R9          // retrieve the tens digit, get bit
                                    // code
            BL      SEG7_CODE       
            LSL     R0, #8          // Shift the bit code of the 10's up to make room for the 1's
            ORR     R4, R0          // Move the 1 bits into their spot

            STR     R4, [R8]        // display the number from R7

            B       END

END:    B       END             
								//NUM 1s	NUM 0s	Alternating
TEST_NUM:   .word	0x55555555	
			.word   0x103fe00f	//9			8		
		    .word   0x11111111	//1			3
			.word   0x11111112	//1			3
			.word   0x11111123	//2			3
			.word   0x11111234	//2			3
			.word   0x11112345	//2			3
			.word   0x11123456	//2			3
			.word   0xFFFFFFFF	//32		0
			.word   0x00000001	//1			31
			.word   0xAAAAAAAA	//1			1		32
			.word   0			
		    .end               