*****************************
*
*
* Created 2/18/2016
*
* Test program
*
*****************************

start		EQU	$00007000	* ORG and END address

* ORG the program so that it straddles the address boundary $00007FFF to $00008000

		ORG	start

* NOP and similar instructions. Should clearly differentiate NOP and RTS from others.

		MOVE.B  D0,D0
		MOVE.B  D0,D1
		MOVE.B  D0,D4
		MOVE.B  D0,D7		
		MOVE.W  A0,D0
		MOVE.W  A4,D0
		MOVE.W  A7,D0
                MOVE.B  (A0),D0
		MOVE.B  (A4),D0
		MOVE.B  D0,(A7)
		MOVE.B  -(A0),D0
		MOVE.B  -(A4),D0
		MOVE.B  D0,-(A7)
		MOVE.B  (A0)+,D0
		MOVE.B  (A4)+,D0
		MOVE.B  D0,(A7)+
                
		
		NOP			*Required
		RTS			*Required
		
		MOVEM.L D0-D7,-(A7)
		MOVEM.L (A7)+,D0-D7
		
		LEA     Hello,A1
		
		jsr     BRANCH
		
		ADDI.W  #$1000,D0
		SUBI.B  #$10,D0
BRANCH:		
		ADDQ.L  #$1,D0
	        MOVEQ.L #$1,D0
	        SUB.L   D1,D0
		
		OR.W    D0,D1		
		DIVU.W  D0,D1
	
		BEQ     START
		BRA     START
		
		AND.W   D0,D1
		MULS.W  D0,D1
		
		ADD.W     D0,D1
	        ADDA.W    D0,A1
	        
	        LSL.B     D1,D0
                LSL.W     D1,D0
                LSL.L     D1,D0
                
                ASL.B     D1,D0
	        ASL.W     D1,D0
	        ASL.L     D1,D0
	        
	        ROL.B     D1,D0
	        ROL.W     D1,D0
                ROL.L     D1,D0
                         
		
		STOP	#$2000  	* Not required instruction

* This is a group of ADD instructions

Hello           DC.B    'Hello',0

add_start	ADDI.W	#$4000,D0	
		
* This is a group of SUB instructions
subtracts	SUBA.W	(A4),A6

* Group is random data

data1		DC.B		$FF,$AA,$45,$0A

* Move instructions

moves		MOVE.B	D0,D1

data5		DC.B	'Here is some interspersed data'
		
* Divide and multiple optional instructions
	
ands		AND.B	#$01,$4568

shifts		ASL.B	D0,D0

rolls		ROL.L	D2,D3

clear		CLR	D4

load_addr	LEA	$DC00FF00,A2

* random data	
		DC.W	2949,0411,2848,7869

compares	CMP.B	(A3),D5

* Branches	
		

* Jump and branch instructions

jmplabel	BCC	compares		
		BGT	compares		
		BLE	compares	
		
*These are not required instructions
multiply	MULS	D0,D3
		DIVU	(A3),D5	*Optional instruction

		END	start



























*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~8~
