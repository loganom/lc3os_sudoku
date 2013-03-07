	.ORIG x4000

;;; ONLY CHOICE - The only choice subroutine will take a starting address and 
;;;		proceed through the next 8 addresses, and if a cell among a region
;;;		has a digit for a possibility and is the only cell with said
;;;		possibility, it will set the cardinality to 0, [15] to 1, and set
;;;		the appropriate bit location to 1.
;;; 	
;;;		Starting address in R0.
;;;	 	Return in R0. Value returned is total # of cells solved.
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

	; place all 9 values on the stack.
	; pick the first one
	; compare it to all the other values
	; get the next value
	; compare it to all the other values
	; repeat until all comparisons made

	; description of each comparison
		; if the value being compared cardinality != 1, move on
		; if cardinality == 1
			; find next set bit
			; set location to 0 in set
			; repeat
	; when finished, move on to next

	; range of values per region
	; xYY00 - xYY08

	; wrap xYY09 to xYY00
	; do not compare xYYWW to xYYWW
	
	TRAP x1E

	HALT

SAVE_R0	.BLKW 1
SAVE_R1	.BLKW 1
SAVE_R2	.BLKW 1
SAVE_R3	.BLKW 1
SAVE_R4	.BLKW 1
SAVE_R5	.BLKW 1
SAVE_R6	.BLKW 1
SAVE_R7	.BLKW 1
	.END