*prints out the letter/word(s) depending on the mode    
Print_Mode_dest: CMP.L     #0,Mode_dest *Must have an instruction or an error (Not sure why)

    MOVE.L  #1,D7          *Set D7 as 1 to signify this is dest
    MOVE.L  Reg_dest,D1    *used for printing the reg
    
    CMP.L     #0,Mode_dest  *Have the instruction again as it wasnt recognizing the first (Not sure why)
    BEQ     Print_Dn
    CMP.L     #1,Mode_dest
    BEQ     Print_An
    CMP.L     #2,Mode_dest
    BEQ     Print_Indirect_Address
    CMP.L     #3,Mode_dest
    BEQ     Print_Postincrement
    CMP.L     #4,Mode_dest
    BEQ     Print_Predecrement
    CMP.L     #7,Mode_dest
    BEQ     Short_Long_Immediate
    rts 
   
Print_Mode_src:     *prints out the letter/word(s) depending on the mode

    MOVE.L  #0,D7          *Set D7 as 0 to signify this is src
    MOVE.L  Reg_src,D1     *used for printing the reg
    MOVE.L  PrintVariable,D3
    CMP     #4,D3
    BEQ     Move_Dn_to_Reg_src
    BRA     Cont
Move_Dn_to_Reg_src:
    MOVE.L  Mode_dest,D1
Cont:
    CMP.L   #0,Mode_src
    BEQ     Print_Dn
    CMP.L   #1,Mode_src
    BEQ     Print_An
    CMP.L   #2,Mode_src
    BEQ     Print_Indirect_Address
    CMP.L   #3,Mode_src
    BEQ     Print_Postincrement
    CMP.L   #4,Mode_src
    BEQ     Print_Predecrement
    CMP.L   #7,Mode_src
    BEQ     Short_Long_Immediate
    rts    
   
Print_Dn:
    
    LEA     Text_D,A1
    JSR     PrintTextInA1
    *MOVE.L  Dn_reg,D1
    JSR     PrintOneD1InHex
    
    rts 

Print_Dn_Reg:
    LEA     Text_D,A1
    JSR     PrintTextInA1
    MOVE.L  Dn_reg,D1
    JSR     PrintOneD1InHex 
    RTS 

Print_An:   
 
    LEA     Text_A,A1
    JSR     PrintTextInA1
    JSR     PrintOneD1InHex *Prints the hex of D1 
    rts
    
Print_An_Reg:
    LEA     Text_A,A1
    JSR     PrintTextInA1
    MOVE.L  An_reg,D1
    JSR     PrintOneD1InHex
    RTS
 
Print_Indirect_Address: *(An)
    LEA     Text_OpenPar,A1
    JSR     PrintTextInA1
    JSR     Print_An
    LEA     Text_ClosePar,A1
    JSR     PrintTextInA1
    RTS

Print_Postincrement: *(An)+
    JSR     Print_Indirect_Address
    LEA     Text_Plus,A1
    JSR     PrintTextInA1
    RTS
       
Print_Predecrement: *-(An)
    LEA     Text_Dash,A1
    JSR     PrintTextInA1
    JSR     Print_Indirect_Address
    RTS
       
Short_Long_Immediate: *Decides whether it is short,long or immediate value
    CMP.L   #0,D1   *D1 has the reg_src/reg_dest
    BEQ     Print_Short
    CMP.L   #1,D1
    BEQ     Print_Long
    CMP.L   #4,D1
    BEQ     Print_Immediate_Address
    RTS
    
Print_Immediate_Address: *#$->B/W/L in S_light depends on what to print next
    
    LEA     Text_Hashtag,A1 *have the $ and # printing in here in case it is directly called 
    JSR     PrintTextInA1   
    MOVE.L  S_light,D1
    cmp     #0,D1      *IF 0 then its .b
    BEQ     Print_Immediate_B
    cmp     #1,D1
    BEQ     Print_Immediate_W     *Else if 1 its .w
    
    BRA     Print_Immediate_L      *Else its 2 so its .L 
 
Print_Immediate_B:  *If src(D7 = 0) print byte of word2, else print byte of word 4
    LEA     Text_$,A1
    JSR     PrintTextInA1
    MOVE.L  Word2,D7
    LSL.W   #8,D7 *chopes off and leaves 8 bits for printing 
    LSR.W   #8,D7 
    MOVE.L  D7,Word2
    
    MOVE.L     Word2,D1            *Printing
    LSR.L      #4,D1               *For the first number     
    jsr     PrintOneD1InHex
    MOVE.L     Word2,D1            *Printing
    jsr     PrintOneD1InHex
    
    rts

Print_Immediate_W:
    LEA     Text_$,A1
    JSR     PrintTextInA1
    MOVE.L  Word2,D1       *Reput into D1
    jsr     PrintD1InHex
    rts     

Print_Immediate_L:

    LEA     Text_$,A1
    JSR     PrintTextInA1
    MOVE.L      Word2,D1
    JSR         PrintD1InHex
    MOVE.L      Word3,D1
    JSR         PrintD1InHex
    rts

Print_Short: *Prints word 2 or 4 depending on whats in D7 (if D7 0 then src else its dest)
        
    cmp     #0,D7   
    BEQ     Print_Short_src
    BRA     Print_Short_dest

Print_Short_src: *D7 is 0 so its source so print word 2

    LEA     Text_$,A1
    JSR     PrintTextInA1
    MOVE.L  Word2,D1
    JSR     Print_Short_First_Four
    MOVE.L  Word2,D1       *Reput into D1
    jsr     PrintD1InHex
    rts

Print_Short_dest: *D7 is 1 so its destination so print word 4

    LEA     Text_$,A1
    JSR     PrintTextInA1
    MOVE.L   Word4,D1
    JSR     Print_Short_First_Four
    MOVE.L   Word4,D1    
    jsr      PrintD1InHex

    rts 

Print_Long: *Prints word 2,3 or 4,5 depending on whats in D7 (if D7 0 then src else its dest)
    cmp     #0,D7
    BEQ     Print_Long_src
    BRA     Print_Long_dest
 
Print_Long_src:

    LEA     Text_$,A1
    JSR     PrintTextInA1
    MOVE.L      Word2,D1
    JSR         PrintD1InHex
    MOVE.L      Word3,D1
    JSR         PrintD1InHex
    rts
 
Print_Long_dest:

    LEA     Text_$,A1
    JSR     PrintTextInA1
    MOVE.L      Word4,D1
    JSR         PrintD1InHex
    MOVE.L      Word5,D1
    JSR         PrintD1InHex
    RTS
    
Print_Short_First_Four:
    *if (D1 < 8000)
        *print 4 0's
    *else
        *print Four f's

    cmp     #$8000,D1
    BGT     Print_Short_First_Four_0
    
    CLR     D1
    MOVE.L  #$FFFF,D1
    Jsr     PrintD1InHex
    rts 
    
Print_Short_First_Four_0:
        
    CLR     D1  *All 0's
    JSR     PrintD1InHex
    rts
    
***********************        
*Printing of variables 
***********************   
Print_S_light:       *Prints out B/W/L based on S_light (00,01,10)

    CMP.L   #$00,S_light  *Compares S_light to 00, 01, and 10 and branches to print B/W/L.
    BEQ     Print_B
    CMP.L   #$01,S_light
    BEQ     Print_W
    CMP.L   #$02,S_light
    BEQ     Print_L
    rts
    
Print_S_mid:         *Prints out W/L based on S_mid  (0,1)
    CMP.L   #0,S_mid
    BEQ     Print_W
    CMP.L   #1,S_mid
    BEQ     Print_L
    rts
    
Print_S_dark:        *Prints out B/W/L based on S_dark (01,11,10)
    CMP.B   #$01,S_dark
    BEQ     Print_B     *Branch if S_dark == 01
    CMP.B   #$03,S_dark   
    BEQ     Print_W     *Branch if S_dark == 11
    CMP.B   #$02,S_dark
    BEQ     Print_L     *Branch if S_dark == 10
    rts    
Print_B:

    MOVE.L  #0,S_light     *S_light Used for deciding what size this instruction is, for immediate value printing

    LEA     Text_BYTE,A1
    JSR     PrintTextInA1
    LEA     Text_Space,A1
    JSR     PrintTextInA1
    RTS
Print_W:

    MOVE.L  #1,S_light     *S_light Used for deciding what size this instruction is, for immediate value printing

    LEA     Text_WORD,A1
    JSR     PrintTextInA1
    LEA     Text_Space,A1
    JSR     PrintTextInA1
    RTS
Print_L:

    MOVE.L  #2,S_light     *S_light Used for deciding what size this instruction is, for immediate value printing

    LEA     Text_LONG,A1
    JSR     PrintTextInA1
    LEA     Text_Space,A1
    JSR     PrintTextInA1
    RTS     


Print_D_grn:         *Prints out R/L based on D_org_grn  (0,1)
    MOVE.L  D_org_grn,D3
    CMP.B   #0,D3
    BEQ     Print_R      *If D_org_grn is the same as 0, branch to print R. Else, print L.
    LEA     Text_Left,A1
    JSR     PrintTextInA1 
    RTS
Print_R:
    LEA     Text_Right,A1
    JSR     PrintTextInA1
    RTS


Print_D_pink:
    MOVE.L  D_pink,D2
    CMP.B   #0,D2
    BEQ     Mem2Reg
    BRA     Reg2Mem
Mem2Reg:
    JSR     MOVEM_Helper 
    MOVE.L  D_pink,D2
    CMP     #0,D2
    BEQ     Comma
    RTS
Reg2Mem:
    JSR     Print_Mode_dest
    CMP     #1,D2
    BEQ     Comma
    RTS
Comma:
    LEA     Text_Comma,A1
    JSR     PrintTextInA1
    CMP     #0,D2
    BEQ     Reg2Mem
    BRA     Mem2Reg
Print_End_Parenth:
    LEA     Text_ClosePar,A1
    JSR     PrintTextInA1
    RTS
****************************    
*Code for printing rotation    
****************************

Print_Rotation_Immediate:
*if (Rotation == 0)
*   print 8
*else
*   print data
    LEA     Text_Hashtag,A1
    jsr     printTextinA1
    LEA     Text_$,A1
    jsr     printTextinA1
    MOVE.L  Rotation,D2
    cmp     #0,D2
    BEQ     Print_Rotation_8
    MOVE.L  D2,D1 *for printing
    JSR     PrintOneD1Inhex
    rts
Print_Rotation_8:
    MOVE.L  D2,D1 *for printing
    ADD.L   #8,D1   *Adds 8
    JSR     PrintOneD1Inhex *prints    
    rts   
 
Print_Rotation_Register:
    LEA     Text_D,A1
    JSR     printTextInA1
    MOVE.L  Rotation,D1
    JSR     PrintOneD1Inhex
    rts
    
*Code for printing the displacement
Print_Displacement:
    *If (Displacement == 0)
    *   Print out PC + Displacement
    *Else 
    *   Find the 2's complement of PC
    *   Print out PC - 2's complement of PC
    MOVE.L  Displacement,D1
    CMP     #0,D1
    BEQ     Print_Displacement_Forw     
    BRA     Print_Displacement_Back
Print_Displacement_Forw:
    MOVE.W  WORD2,D1
    ADD.L   PC,D1
    jsr     printD1InHex
    rts
    
Print_Displacement_Back:
    
    NOT.B   D1  *Flips all the bits
    ADD.B   #1,D1   *For 2's complement
    MOVE.W  D1,Displacement *Moves back into the variable temporarily
    MOVE.L  PC,D1
    MOVE.W  Displacement,D2
    SUB.W   D2,D1  
    jsr     printD1InHex
    rts
******************************************    
*Data functions    
******************************************
Print_Data:
*get data 
*print the first two hex values
    MOVE.L  Data,D2
    MOVE.L  D2,D1   *for first printing
    LSR.L   #4,D1   *for printing the left most hex first
    jsr     printOneD1Inhex
    MOVE.L  D2,D1   *for printing
    LSL.B   #4,D1   
    LSR.B   #4,D1   *for chopping off the left hex 
    jsr     printOneD1Inhex
    rts
    
Print_Data_3bit:
    MOVE.L  data,D1
    JSR     PrintOneD1Inhex
    rts
  
******************************************
*Print conditional and supporting functions
****************************************** 
Print_Condition: *CC, LT, GE
    MOVE.L  Condition,D1
    *If 4 its CC
    cmp     #4,D1
    BEQ     Print_Condition_CC
    *else if d its LT 
    cmp     #$D,D1
    BEQ     Print_Condition_LT    
    *else its GE
    BRA     Print_Condition_GE
    
Print_Condition_CC:
    LEA     Text_CC,A1
    jsr     printTextInA1
    rts

Print_Condition_LT:

    LEA     Text_LT,A1    
    jsr     printTextInA1
    rts


Print_Condition_GE:

    LEA     Text_GE,A1
    jsr     printTextInA1
    rts
 
*Printing for words  
Print_Word2:        *prints out the 16 bit hex in Word2
    MOVE.L  Word2,D1
    JSR     PrintD1InHex
    rts 
    
Print_Word3:        *prints out the 16 bit hex in Word3     
    MOVE.L  Word3,D1
    JSR     PrintD1InHex    
    rts

Print_Word4:        *prints out the 16 bit hex in Word4         
    MOVE.L  Word4,D1
    JSR     PrintD1InHex 
    rts

Print_Word5:        *prints out the 16 bit hex in Word5
    MOVE.L  Word5,D1
    JSR     PrintD1InHex     
    rts   
*********************************
*Micellaneous functions
*********************************
PrintNewLine:
    LEA     Blank,A1    
    MOVE.B  #13,D0  *print out nextline
    TRAP    #15 
    rts

PrintTextInA1:
    MOVE.B  #14,D0  *for trap task 14
    TRAP    #15     *prints the message
    *jsr     PrintNewLine    *prints out new line
    rts
    
Print_ERROR:
    LEA     Text_DATA,A1
    JSR     PrintTextInA1
    JSR     PrintNewLine
    RTS

*BELOW ARE ALL METHODS FOR PRINTING THE ADDRESS
Print_Address:  *Prints out the address before all incrementations
                *Loops through 4 hex and prints them 
    CLR     D3
    CLR     D4
    CLR     D5
    MOVE.L  BeginStartAddress,D5
    MOVE.L  #8,D4   *for the for loop

StartOfLoop:    
    *if > 10 add 55 else Add 48
    ROL.L   #4,D5
    MOVE.B  D5,D3
    LSL.B   #4,D3   *Chop off bits so just 4 bits remain
    LSR.B   #4,D3
    
    CMP     #10,D3
    BGE     Convert_10UP
 
    ADDI.B  #48,D3 
    
    JMP     NextOfloop
    
Convert_10UP:
    
    ADDI.B  #55,D3 
 
NextofLoop:
    MOVE.B  D3,D1
    MOVE.B  #6,D0
    TRAP    #15
 
    SUBI.L  #1,D4   *end of for loop
    CMP     #0,D4
    BEQ     EndLoop     *if 0 end else restart loop
    jmp     StartOfLoop 
    
EndLoop:
 
    LEA     Text_Space,A1
    jsr     PrintTextInA1
 
    rts
*ABOVE IS FOR PRINTING THE ADRESS

*Below is for printing word of hex number function
                *Loops through 4 hex and prints them 
                
PrintD1InHex:

    CLR     D3
    CLR     D4
    CLR     D5
    MOVE.L  D1,D5
    MOVE.L  #4,D4   *for the for loop

Hex_StartOfLoop:    
    *if > 10 add 55 else Add 48
    ROL.W   #4,D5
    MOVE.B  D5,D3
    LSL.B   #4,D3   *Chop off bits so just 4 bits remain
    LSR.B   #4,D3
    
    CMP     #10,D3
    BGE     Hex_Convert_10UP
 
    ADDI.B  #48,D3 
    
    JMP     Hex_NextOfloop
    
Hex_Convert_10UP:
    
    ADDI.B  #55,D3 
 
Hex_NextofLoop:
    MOVE.B  D3,D1
    MOVE.B  #6,D0
    TRAP    #15
 
    SUBI.L  #1,D4   *end of for loop
    CMP     #0,D4
    BEQ     Hex_EndLoop     *if 0 end else restart loop
    jmp     Hex_StartOfLoop 
    
Hex_EndLoop:

    rts

*Above is for printing the hex function 

PrintOneD1InHex:    *converts first 4 bits to ascii then prints it 

    CLR     D3
    MOVE.L  D1,D3
    LSL.B   #4,D3   *Chop off bits so just 4 bits remain
    LSR.B   #4,D3   
    ADDI.B  #48,D3   *Add 4 to the remaining in D3
    CMP     #57,D3   *if more than #57 than its a character 
    BGT     PrintOneD1InHexMore
    
    BRA     PrintOneD1InHexNext
    
PrintOneD1InHexMore:    *To add some more to D3 
    ADDI.B  #7,D3    
PrintOneD1InHexNext:
    MOVE.L  D3,D1   *Move back to D1 for priinting 
    MOVE.B  #6,D0
    TRAP    #15

    rts

Mode_Src_Is_Valid:

    MOVE.L  Mode_Src,D5
    
    CMP     #0,D5
    BEQ     Valid_Return
    
    CMP     #1,D5
    BEQ     Valid_Return
    
    CMP     #2,D5
    BEQ     Valid_Return
    
    CMP     #3,D5
    BEQ     Valid_Return
    
    CMP     #4,D5
    BEQ     Valid_Return
    
    CMP     #7,D5
    BEQ     Reg_Src_Is_Valid
    
    BRA     Branch_InvalidData

Reg_Src_Is_Valid:

    MOVE.L  Reg_Src,D5
    
    CMP     #0,D5
    BEQ     Valid_Return
    
    CMP     #1,D5
    BEQ     Valid_Return
    
    CMP     #4,D5
    BEQ     Valid_Return
    
    BRA     Branch_InvalidData

Mode_Dest_Is_Valid:

   MOVE.L  Mode_Dest,D5
    
    CMP     #0,D5
    BEQ     Valid_Return
    
    CMP     #1,D5
    BEQ     Valid_Return
    
    CMP     #2,D5
    BEQ     Valid_Return
    
    CMP     #3,D5
    BEQ     Valid_Return
    
    CMP     #4,D5
    BEQ     Valid_Return
    
    CMP     #7,D5
    BEQ     Reg_Dest_Is_Valid
    
    BRA     Branch_InvalidData


Reg_Dest_Is_Valid:

    MOVE.L  Reg_Dest,D5
    
    CMP     #0,D5
    BEQ     Valid_Return
    
    CMP     #1,D5
    BEQ     Valid_Return
    
    CMP     #4,D5
    BEQ     Valid_Return
    
    BRA     Branch_InvalidData
   
Valid_Return:

    rts


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
