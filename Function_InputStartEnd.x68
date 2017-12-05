InputStartEnd:
    JSR     Print_Intro_Banner  
    MOVE.L  #00000000,D0        *clears start and end addresses
    MOVE.L  #00000000,Buffer_Count  *reset buffer count
    MOVE.L  D0,StartAddress
    MOVE.L  D0,EndAddress  
      
    LEA     StartIntro,A1
    MOVE.B  #14,D0  *for trap task 14
    TRAP    #15     *prints the message 
    
    
    jsr     InputHexNumber  *should take in 4 hex number and store at D3
    MOVE.L  D3,StartAddress   *Moves D3 into variable StartAdress
    
    jsr     PrintNewLine
    
     LEA    EndIntro,A1
    MOVE.B  #14,D0  *for trap task 14
    TRAP    #15     *prints the message 
    
    MOVE.L  #00000000, D3
    MOVE.L  #00000000, D4
    
    jsr     InputHexNumber  *should take in 4 hex number and store at D3
    MOVE.L  D3,EndAddress   *Moves D3 into variable Word1
    
    jsr     PrintNewLine

    rts
    
InputHexNumber:
    
    TopInputHexNumber:
    
        MOVE.B  #5,D0   *trap task 5
        TRAP    #15
        
        CMP.B   #$58,D1             *If x then print outro banner and end program
        BEQ     Print_Outro_Banner
        CMP.B   #$78,D1             *If X then prints outro banner and end program
        BEQ     Print_Outro_Banner   
        
        JSR     TestIfInputIsValid  *Tests to see if input is a 0 to F hex number if not restart the program 
        
        jsr     ConvertD1AsciiToHex
        
        ADD.L   D1,D3   *adds to whatever is in D3
    
        CMP     #7,D4   *only loops 8 times if equal
    
        BEQ     EndInputHexNumber   *if equal to 7 then break the loop as this is the last one 
    
        ADD.L   #1,D4               *increment D4
    
        ROL.L   #4,D3               *move one decimal spot over
    
        JMP     TopInputHexNumber
    
    EndInputHexNumber:
        
        MOVE.L  #$00000000,D4     *reset D4
        
        rts
    
ConvertD1AsciiToHex:
    
    SUB.B   #48,D1  *firstly subtract 48
    
    CMP     #49,D1    *subtract 39 if its negative
    
    BPL     SubThirtyNineD1 *lower case number so subtract an additional 39
    
    CMP     #10,D1  *if the result is 0 to 9 then keep
    
    BPL     SubSevenD1 * else its A - F so subtract 7 to make it look like A or F
    
    rts
    
SubThirtyNineD1:
    
    SUB.B   #39,D1
    
    rts
    
SubSevenD1:

    SUB.B   #7,D1

    rts    
*************************************
TestIfInputIsValid:  *Tests to see if input is a 0 to F hex number if not restart the program 
    
*    if (num <= 57)
*   	if (num < 48)
*   		error
*	    else
*    		good
*   else if (num <= 70)
*   	if (num < 65)
*   		error
*   	else
*   		good
*   else if (num <= 102)	
*   	if (num < 97)
*   		error
*   	else	
*   		good
*   else
*   	error
    
    CMP #57,D1
    
    BLE TestIfInputIsValid_57 
    
    CMP #70,D1
    
    BLE TestIfInputIsValid_70

    CMP #102,D1

    BLE TestIfInputIsValid_102       
    
    BRA Print_Invalid_Input_message

TestIfInputIsValid_57:

    CMP #48,D1
    
    BLT Print_Invalid_Input_message
    
    rts *good

TestIfInputIsValid_70:

    CMP #65,D1
    
    BLT Print_Invalid_Input_message
    
    rts *good
    
TestIfInputIsValid_102:
    
    CMP #97,D1
    
    BLT Print_Invalid_Input_message
    
    rts *good

*****************************    
Print_Invalid_Input_message:

    JSR     PrintNewLine
    LEA     InvalidInputMessage,A1
    JSR     PrintTextInA1
    
    MOVEA.L Start,A4
    MOVEA.L A4,A7
    
    JSR     CLEARALL
    JMP     Start

Print_Intro_Banner:
    JSR     PrintNewLine
    LEA     Text_Intro1,A1
    JSR     PrintTextInA1
    JSR     PrintNewLine
    LEA     Text_Intro2,A1
    JSR     PrintTextInA1
    JSR     PrintNewLine
    LEA     Text_Intro3,A1
    JSR     PrintTextInA1
    JSR     PrintNewLine    
    LEA     Text_Intro4,A1
    JSR     PrintTextInA1
    JSR     PrintNewLine
    LEA     Text_Intro5,A1
    JSR     PrintTextInA1
    JSR     PrintNewLine    
    LEA     Text_Intro6,A1
    JSR     PrintTextInA1
    JSR     PrintNewLine    
    LEA     Text_Intro7,A1
    JSR     PrintTextInA1
    JSR     PrintNewLine    
    LEA     Text_Intro8,A1
    JSR     PrintTextInA1
    JSR     PrintNewLine
    LEA     Text_Intro9,A1
    JSR     PrintTextInA1
    JSR     PrintNewLine
    LEA     Text_Intro10,A1
    JSR     PrintTextInA1
    JSR     PrintNewLine
    rts

Print_Outro_Banner:
    JSR     PrintNewLine
    LEA     Text_Outro1,A1
    JSR     PrintTextInA1
    JSR     PrintNewLine
    LEA     Text_Outro2,A1
    JSR     PrintTextInA1
    JSR     PrintNewLine
    LEA     Text_Outro3,A1
    JSR     PrintTextInA1
    JSR     PrintNewLine    
    LEA     Text_Outro4,A1
    JSR     PrintTextInA1
    JSR     PrintNewLine
    LEA     Text_Outro5,A1
    JSR     PrintTextInA1
    JSR     PrintNewLine    
    LEA     Text_Outro6,A1
    JSR     PrintTextInA1
    JSR     PrintNewLine    
    LEA     Text_Outro7,A1
    JSR     PrintTextInA1
    JSR     PrintNewLine    

    BRA     END











*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
