PrintInstruction:
    MOVE.B  Buffer_Count,D7
    CMP     #19,D7              *Check to see if output window is full.
    BEQ     Print_Buffer        *If ouput is full, branch to print buffer.
    ADDI.B  #1,Buffer_Count     *Add one to buffer count.

    MOVE.L  PrintVariable,D2    *Move to register
    MOVE.L  D3,D7               *saves address 4 hex for Invalid_data functions
    
    jsr     Print_Address        *Prints the address of the instruction (Address print)
    
    CMP     #26,D2              *If D3 is 26 (HEX_1A), branch to data, Print_DATA
    BEQ     Print_Invalid_DATA          *This is done first so we can put an address print after 
    
    MOVE.L  PrintVariable,D2    *Move back to register after address printing 
    
    CMP     #0,D2               *If D3 is 0, then branch ADDI
    BEQ     Print_ADDI 
    
    CMP     #1,D2
    BEQ     Print_SUBI          *If D3 is 1, branch SUBI
    
    CMP     #2,D2               *If D3 is 2, then branch MOVEA
    BEQ     Print_MOVEA
    
    CMP     #3,D2               *If D3 is 3, then branch MOVE
    BEQ     Print_MOVE
    
    CMP     #4,D2               *If D3 is 4, branch MOVEM
    BEQ     Print_MOVEM
    
    CMP     #5,D2               *If D3 is 5, branch LEA
    BEQ     Print_LEA
    
    CMP     #6,D2               *If D3 is 6, branch JSR
    BEQ     Print_JSR
    
    CMP     #7,D2               *If D3 is 7, branch RTS
    BEQ     Print_RTS

    cmp     #8,D2               *if D3 is 6 then NOP
    BEQ     Print_NOP           *go to NOP branch if 6 else keep going 

    CMP     #9,D2               *If D3 is 9, branch ADDQ
    BEQ     Print_ADDQ
    
    CMP     #10,D2              *If D3 is 10 (HEX_A), branch BCC
    BEQ     Print_BCC

    CMP     #11,D2              *If D3 is 11 (HEX_B), branch BRA
    BEQ     Print_BRA

    CMP     #12,D2              *If D3 is 12 (HEX_C), branch MOVEQ   
    BEQ     Print_MOVEQ 
    
    CMP     #13,D2              *If D3 is 13 (HEX_D), branch OR
    BEQ     Print_OR
    
    CMP     #14,D2              *If D3 is 14 (HEX_E), branch DIVU
    BEQ     Print_DIVU
    
    CMP     #15,D2              *If D3 is 15 (HEX_F), branch SUB
    BEQ     Print_SUB
    
    CMP     #16,D2              *If D3 is 16 (HEX_10), branch MULS
    BEQ     Print_MULS
    
    CMP     #17,D2              *If D3 is 17 (HEX_11), branch AND
    BEQ     Print_AND
    
    CMP     #18,D2              *If D3 is 18 (HEX_12), branch ADD
    BEQ     Print_ADD
    
    CMP     #19,D2              *If D3 is 19 (HEX_13), branch ADDA
    BEQ     Print_ADDA
    
    CMP     #20,D2              *If D3 is 20 (HEX_14), branch ASD
    BEQ     Print_ASD_First
    
    CMP     #21,D2              *If D3 is 21 (HEX_15), branch LSD
    BEQ     Print_LSD_First
    
    CMP     #22,D2              *If D3 is 22 (HEX_16), branch ROD
    BEQ     Print_ROD_First
    
    CMP     #23,D2  *(TODO GET SET 2 WORKING) *If D3 is 23 (Hex_17), branch ASD *USES NEW SHEET
    BEQ     Print_ASD_Second
    
    CMP     #24,D2              *If D3 is 24 (HEX_19), branch LSD   *USES NEW SHEET
    BEQ     Print_LSD_Second
    
    CMP     #25,D2              *If D3 is 25 (HEX_16), branch ROD   *USES NEW SHEET
    BEQ     Print_ROD_Second

    JSR     Print_ERROR         *If print variable doesn't match any of the above, jump to print error message.    
    rts        

Print_Buffer:
    MOVE.B  #0,Buffer_Count     *Reset buffer count.
    LEA     Text_Buffer,A1      *Print text for user instructions on how to display more, i.e. 'F'.
    JSR     PrintTextInA1
    MOVE.B  #5,D0
    Trap    #15
    JSR     PrintNewLine
    CMP.B   #$D,D1              *Checks to see if user entered ENTER
    BEQ     PrintInstruction
    CMP.B   #$58,D1             *If x then print outro banner and end program
    BEQ     Print_Outro_Banner
    CMP.B   #$78,D1             *If X then prints outro banner and end program
    BEQ     Print_Outro_Banner   
    BRA     Print_Buffer        *Else, loop through print buffer again to attempt at correct user input.
    
*opcode checkers
Print_AddI:
    LEA     Text_ADDI,A1
    JSR     PrintTextInA1
    JSR     Print_S_light
    CLR     D7     *indicates its a src for the next functions
    JSR     Print_Immediate_Address
    LEA     Text_Comma,A1
    JSR     PrintTextInA1
    JSR     Print_Mode_dest
    JSR     PrintNewLine
    RTS  
    
Print_SubI:
    LEA     Text_SUBI,A1
    JSR     PrintTextInA1
    JSR     Print_S_light
    CLR     D7     *indicates its a src for the next functions
    JSR     Print_Immediate_Address
    LEA     Text_Comma,A1
    JSR     PrintTextInA1
    JSR     Print_Mode_dest
    JSR     PrintNewLine
    RTS

Print_MoveA:
    LEA     Text_MOVEA,A1
    JSR     PrintTextInA1
    JSR     Print_S_dark
    JSR     Print_Mode_src
    *JSR     Print_Reg_src
    LEA     Text_Comma,A1
    JSR     PrintTextInA1
    JSR     Print_Mode_dest
    *JSR     Print_Reg_dest
    JSR     PrintNewLine
    RTS

Print_Move:
    LEA     Text_Move,A1
    JSR     PrintTextInA1
    JSR     Print_S_dark
    JSR     Print_Mode_src
    *JSR     Print_Reg_src
    LEA     Text_Comma,A1
    JSR     PrintTextInA1
    JSR     Print_Mode_dest
    *JSR     Print_Reg_dest
    JSR     PrintNewLine
    RTS
    
    **STUB: This is almost working, but the direction doesn't seem to be stored correctly in D_pink.
Print_MoveM:
    LEA     Text_MoveM,A1
    JSR     PrintTextInA1
    JSR     Print_S_mid
    JSR     Print_D_pink
    JSR     PrintNewLine
    RTS
    
**STUB: This is almost working, but I'm not sure where the Source is being stored.
Print_LEA:
    LEA     Text_LEA,A1
    JSR     PrintTextInA1
    LEA     Text_Space,A1
    JSR     PrintTextInA1
    JSR     PrintTextInA1
    JSR     Print_Mode_dest
    LEA     Text_Comma,A1
    JSR     PrintTextInA1
    JSR     Print_An_reg
    JSR     PrintNewLine    
    RTS
    
Print_JSR:
    LEA     Text_JSR,A1
    JSR     PrintTextInA1
    LEA     Text_Space,A1
    JSR     PrintTextInA1
    JSR     Print_Mode_dest
    JSR     PrintNewLine
    RTS
    
Print_NOP:    
    *rts instruction hex is 4E71
    MOVE.L  Word1,D3
    LEA     Text_NOP,A1     *Loads "NOP" into A1 for printing
    jsr     PrintTextInA1   *print "NOP"
    JSR     PrintNewLine
    rts

Print_rts: 

    *rts instruction hex is 4E75
    MOVE.L  Word1,D3
    LEA     Text_rts,A1     *Loads "rts" into A1 for printing
    jsr     PrintTextInA1   *print "rts"
    JSR     PrintNewLine
    
    rts
    
    **STUB: Still need to get addresses working once fetchMore functions are complete.
Print_ADDQ:
    LEA     Text_ADDQ,A1
    JSR     PrintTextInA1
    JSR     Print_S_light
    LEA     Text_Space,A1
    JSR     PrintTextInA1
    LEA     Text_Hashtag,A1
    JSR     PrintTextInA1  
    JSR     Print_data_3bit
    LEA     Text_Comma,A1
    JSR     PrintTextInA1
    JSR     Print_Mode_src
    JSR     PrintNewLine
    RTS

**STUB: BCC & BRA need displacement before we can implement fully.
Print_BCC:
    LEA     Text_B,A1
    JSR     PrintTextInA1
    JSR     Print_Condition
    LEA     Text_Space,A1
    JSR     PrintTextInA1
    LEA     Text_$,A1
    JSR     PrintTextInA1
    JSR     Print_Short_First_Four_0
    JSR     Print_Displacement   
    JSR     PrintNewLine
    RTS
    
Print_BRA:
    LEA     Text_BRA,A1
    JSR     PrintTextInA1
    LEA     Text_Space,A1
    JSR     PrintTextInA1
    LEA     Text_$,A1
    JSR     PrintTextInA1
    JSR     Print_Short_First_Four_0     
    JSR     Print_Displacement
    JSR     PrintNewLine      
    RTS
    
    **STUB: Need to still test for if there's more than just #1.
Print_MOVEQ:
    LEA     Text_MoveQ,A1
    JSR     PrintTextInA1
    JSR     Print_L
    LEA     Text_Hashtag,A1
    JSR     PrintTextInA1
    LEA     Text_$,A1
    JSR     PrintTextInA1
    JSR     Print_data
    LEA     Text_Comma,A1
    JSR     PrintTextInA1
    JSR     Print_Dn_Reg     
    JSR     PrintNewLine
    RTS
    
Print_OR:
    LEA     Text_OR,A1
    JSR     PrintTextInA1
    JSR     Print_S_light
    LEA     Text_Space,A1
    JSR     PrintTextInA1
    MOVE.L  D_org_grn,D3
    CMP     #1,D3
    BEQ     Dn_to_Ea
    BRA     Ea_to_Dn
Dn_to_EA:
    JSR     Print_Dn_reg
    LEA     Text_Comma,A1
    JSR     PrintTextInA1
    JSR     Print_Mode_src
    JSR     PrintNewLine
    RTS
Ea_to_Dn:
    JSR     Print_Mode_src
    LEA     Text_Comma,A1
    JSR     PrintTextInA1
    JSR     Print_Dn_Reg
    JSR     PrintNewLine
    RTS
    
Print_DIVU:
    LEA     Text_DIVU,A1
    JSR     PrintTextInA1
    JSR     Print_W
    LEA     Text_Space,A1
    JSR     PrintTextInA1
    JSR     Print_Mode_src  *Source
    LEA     Text_Comma,A1   *Comma
    JSR     PrintTextInA1
    JSR     Print_Dn_Reg 
    JSR     PrintNewLine
    RTS
    
Print_SUB:
    LEA     Text_SUB,A1
    JSR     PrintTextInA1
    JSR     Print_S_light
    LEA     Text_Space,A1
    JSR     PrintTextInA1
    MOVE.L  D_org_grn,D3
    CMP     #1,D3
    BEQ     Dn_to_Ea
    BRA     Ea_to_Dn
    
Print_MULS:
    LEA     Text_MULS,A1
    JSR     PrintTextInA1
    JSR     Print_W         *.W
    LEA     Text_Space,A1      *Space
    JSR     PrintTextInA1    
    JSR     Print_Mode_src  *Source
    LEA     Text_Comma,A1   *Comma
    JSR     PrintTextInA1
    JSR     Print_Dn_Reg 
    JSR     PrintNewLine
    RTS
    
Print_AND:
    LEA     Text_AND,A1
    JSR     PrintTextInA1
    JSR     Print_S_light
    LEA     Text_Space,A1
    JSR     PrintTextInA1
    
    MOVE.L  D_org_grn,D1
    CMP     #0,D1              *Used to determine which way to print, If 0 then prints EA, Dn
                               *else 1 then prints Dn, EA
                               
    BEQ     Print_And_EAtoDn
    
    BRA     Print_And_DntoEA
    
Print_AND_EAtoDn:    *Case where D_org_grn is 0 
        
    jsr     Print_Mode_src
    LEA     Text_Comma,A1
    JSR     PrintTextInA1
    JSR     Print_Dn_Reg
    JSR     PrintNewLine
    rts

Print_AND_DntoEA:    *Case where D_org_grn is 1     
    JSR     Print_Dn_Reg
    LEA     Text_Comma,A1
    JSR     PrintTextInA1
    jsr     Print_Mode_src
    jsr     PrintNewLine
    rts
    
Print_ADD:
    LEA     Text_ADD,A1
    JSR     PrintTextInA1
    JSR     Print_S_light
    LEA     Text_Space,A1
    JSR     PrintTextInA1
    MOVE.L  D_org_grn,D1
    CMP     #1,D1   
    BEQ	      Dn_to_Ea
    BRA	    Ea_to_Dn   
    
Print_ADDA:
    LEA     Text_ADDA,A1
    JSR     PrintTextInA1
    JSR     Print_S_mid     *S_mid
    LEA     Text_Space,A1
    JSR     PrintTextInA1   *Src
    JSR     Print_Mode_src
    LEA     Text_Comma,A1   *Comma
    JSR     PrintTextInA1    
    JSR     Print_An_Reg 
    JSR     PrintNewLine
    RTS
*First sets     
Print_ASD_First:
    LEA     Text_AS,A1
    JSR     PrintTextInA1
    JSR     Print_D_grn
    JSR     Print_W
    LEA     Text_Space,A1
    JSR     PrintTextInA1
    JSR     Print_Mode_dest
    JSR     PrintNewLine
    RTS
    
Print_LSD_First:
    LEA     Text_LS,A1
    JSR     PrintTextInA1
    JSR     Print_D_grn
    JSR     Print_W
    LEA     Text_Space,A1
    JSR     PrintTextInA1
    JSR     Print_Mode_dest
    JSR     PrintNewLine
    RTS
    
Print_ROD_First:
    LEA     Text_RO,A1
    JSR     PrintTextInA1
    JSR     Print_D_grn
    JSR     Print_W
    LEA     Text_Space,A1
    JSR     PrintTextInA1
    JSR     Print_Mode_dest
    JSR     PrintNewLine
    RTS

*Second sets
*Print Name
*if M_blue == 0 
*   print # then $ then rotation
*else{
*   print D then Rotation
*print comma     
*Print mode dest 
*print new line

Print_ASD_Second:
    LEA     Text_AS,A1
    JSR     PrintTextInA1
    JSR     Print_D_grn
    JSR     Print_S_light
    LEA     Text_Space,A1
    JSR     PrintTextInA1
    
    MOVE.L  M_blue,D1
    cmp     #0,D1
    BEQ     Print_Second_set_M_0

    BRA     Print_Second_set_M_1
    
Print_LSD_Second:
    LEA     Text_LS,A1
    JSR     PrintTextInA1
    JSR     Print_D_grn
    JSR     Print_S_light
    LEA     Text_Space,A1
    JSR     PrintTextInA1
    
    MOVE.L  M_blue,D1
    cmp     #0,D1
    BEQ     Print_Second_set_M_0

    BRA     Print_Second_set_M_1
       
Print_ROD_Second:
    LEA     Text_RO,A1
    JSR     PrintTextInA1
    JSR     Print_D_grn
    JSR     Print_S_light
    LEA     Text_Space,A1
    JSR     PrintTextInA1
    
    MOVE.L  M_blue,D1
    cmp     #0,D1
    BEQ     Print_Second_set_M_0

    BRA     Print_Second_set_M_1
        
Print_Second_set_M_0: *Just prints #$Rotation
    JSR     Print_Rotation_Immediate
    LEA     Text_Comma,A1   *Comma
    JSR     PrintTextInA1
    JSR     Print_Dn_reg
    JSR     PrintNewLine
    RTS
    
Print_Second_set_M_1: *Just prints D Rotation
    JSR     Print_Rotation_Register
    LEA     Text_Comma,A1   *Comma
    JSR     PrintTextInA1
    JSR     Print_Dn_reg
    JSR     PrintNewLine
    RTS
*******************
*Invalid data case*
*******************
Print_Invalid_DATA:          *This is done first so we can put an address print after 
    LEA     Text_data,A1
    JSR     PrintTextInA1
    LEA     Text_Space,A1
    JSR     PrintTextInA1
    LEA     Text_$,A1
    JSR     PrintTextInA1
    MOVE.L  D7,D1
    JSR     PrintD1InHex
    JSR     PrintNewLine
    rts

*Note Nico:I moved the printLine, Print error and print_text_in_A1 functions to the helper print function file    






































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
