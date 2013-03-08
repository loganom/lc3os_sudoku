	.ORIG x4000

;;; ONLY POSSIBILITY - The only choice subroutine will take a starting address and 
;;;		proceed through the next 8 addresses, and if a cell among a region
;;;		has a digit for a possibility and is the only cell with said
;;;		possibility, it will set the cardinality to 0, [15] to 1, and set
;;;		the appropriate bit location to 1.
;;; 	
;;;		Starting address in R5.
;;;	 	Return in R5. Value returned is total # of cells solved.
;;;		
;;;		NOTE: 
;;;		[15] = [1 | 0] = [set | not set]
;;;		[14:11] = cardinality of cell
;;;		[0:8] = [n+1] as a possibility
;;;
;;;		RECALL:
;;;		TRAP_R_SHIFT x31
;;;		R0 => value to be bit shifted
;;;		R1 => number of times to shift
;;;		return: R0 => the shifted value
;;;
;;;		TRAP_GET_CARDINALITY x1E
;;;		R0 => value
;;;		return: R0 => number of bits set in [0:8]
;;; 		return: R0 => negative if solved [15] = 1

	ST R0,SAVE_R0
	ST R1,SAVE_R1 		; store starting address for save keeping
	ST R2.SAVE_R2

	LD R1,INDEX_RANGE 	; used for the next_set_bit trap routine
 
GET_CELL_TO_CHECK
	LDR R0,R5,#0 		; put value at location (post-incremented) into R0
	TRAP x1E			; get cardinality of value, result in R0
	BRn GOTO_NEXT		; if the value is 8xxx then it is solved
				; do not use it for comparison

	LDR R2,R5,#0 		; otherwise, use it for comparison

COMPARE_TO_OTHERS
	LDR R0,R5,#0
	TRAP x1E

	ADD R0,R0,#-1
	BRp GOTO_NEXT 		; will be z if it has cardinality of 1

	LDR R0,R5,#1		; reload (R0 is lost in TRAP x1E)
	TRAP x1F 		; this returns the next set bit of the solved value

	; we then need to load a mask, mask the value in R2, 
	; then set bit [15] = 1, set [14:11] = 0b0001 and re-store it.
				
	AND R2,R2,#0		; clear
				; if bit 5 is set, load appropriate value, add to R2
				; set bit [15] = 1
				; [14:11] = 0b0001
	STR R2,R5,#0		; store

	; wrap to initial location when you reach initial location +9
	; finished when the locations compared are equal

GOTO_NEXT
	ADD R5,R5,#1
	; check to see if we are done 
	; otherwise
	BRnzp GET_CELL_TO_CHECK	;set nzp to? (we need an exit check)

	HALT
INDEX_RANGE	.FILL x0900
SAVE_R0	.BLKW 1
SAVE_R1	.BLKW 1
SAVE_R2	.BLKW 1
SAVE_R3	.BLKW 1
SAVE_R4	.BLKW 1
SAVE_R5	.BLKW 1
SAVE_R6	.BLKW 1
SAVE_R7	.BLKW 1
	.END