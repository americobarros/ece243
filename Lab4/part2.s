/* Program that counts consecutive 1's */

		.text                   // executable code follows
		.global _start                  
_start:                             
		MOV     R2, #TEST_NUM   // R2 will point to word data

		MOV     R0, #0          // R0 will hold the result
		MOV		R5, #0			// R5 will hold the result of 1's

NXT_WRD:
		
		LDR     R1, [R2]	    // Ld word into R1
		CMP		R1, #0			// Check to see if we've hit word zero
		BEQ		END				// If zero, end!

		//Counts ONES
		BL		ONES			//Count the ones
		CMP		R5, R0
		MOVLT	R5, R0			// If R5 < R0, load R0 -> R5
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

@ //Requires R7= !Word, Returns R8=count, Uses R3
@ ZEROS:  CMP     R7, #0          // loop until the data contains no more 1's
@ 		BEQ     NXT_WRD      
@ 		LSR     R3, R7, #1      // perform SHIFT, followed by AND
@ 		AND     R7, R7, R3      
@ 		ADD     R8, #1          // count the string length so far
@ 		B       ZEROS

END:    B       END             
								//NUMBER OF 1s
TEST_NUM:   .word   0x103fe00f	//9
		    .word   0x11111111	//1
			.word   0x11111112	//1
			.word   0x11111123	//2
			.word   0x11111234	//2
			.word   0x11112345	//2
			.word   0x11123456	//2
			.word   0xFFFFFFFF	//32
			.word   0xA1123456	//2
			.word   0xAB123456	//2
			.word   0			//0
		    .end                            
