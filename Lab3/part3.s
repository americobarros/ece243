/* Program that finds the largest number in a list of integers	*/

            .text                   // executable code follows
            .global _start                  
_start:                             
            MOV     R4, #RESULT     // R4 points to result location
            LDR     R0, [R4, #4]    // R0 holds the number of elements in the list
            MOV     R1, #NUMBERS    // R1 points to the start of the list
            LDR     R3, [R4]        // R3 Holds the max value so far
            BL      LARGE           
            STR     R0, [R4]        // R0 holds the subroutine return value

END:        B       END             

/* Subroutine to find the largest integer in a list
 * Parameters: R0 has the number of elements in the list
 *             R1 has the address of the start of the list
 * Returns: R0 returns the largest item in the list
 */
LARGE:    
		 SUBS     R0, #1        // decrement the loop counter
         BEQ      DONE          // if result is equal to 0, branch
         ADD      R1, #4        // R1 points to the next number
         LDR      R2, [R1]      // get the next number and store it into R2
         CMP      R3, R2        // check if larger number found
         BGE      LARGE
         MOV      R3, R2        // update the largest number
         B        LARGE
		 
DONE:    
		 MOV      R0, R3      // move largest number into result location
         MOV      PC, LR      // go back to where subroutines branch began in _start

RESULT:     .word   0           
N:          .word   7           // number of entries in the list
NUMBERS:    .word   4, 5, 3, 6  // the data
            .word   1, 8, 2                 

            .end                            

