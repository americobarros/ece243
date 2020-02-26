/* Program that counts consecutive 1's, 0's, and alternating 1's and 0's*/
//Chose to implement this using branches
//Because I found it more technically challenging

		.text                   // executable code follows
		.global _start                  
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
		BEQ		END				// If zero, end!

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
