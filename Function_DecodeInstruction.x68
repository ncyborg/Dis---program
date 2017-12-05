*everything below this is for the branching for updating the Word1Variables 

DecodeInstruction:           *reads the different parts of the Word and determines which part of the Word 1 variables should be updated
    
    Move.L  Word1,D3            *retrieves Word1 and places into D3 
    
    jsr     ReadTo_FirstHex     *puts first 4 bits into FirstHex
    
    MOVE.L  FirstHex,D5
    
    CMP     #$00000000,D5                  *Compare 0 to first hex, if equal its SUBI or ADDI
    BEQ     Branch_FirstHex0               *equal to 0? Branch, else go on
    
    CMP     #$00000001,D5                  *Compare 1 to first hex, if equal its MOVE
    BEQ     Branch_FirstHex1_MOVE          *equal to 1? Branch, else go on
    
    CMP     #$00000002,D5                  *compares 2 to 2 (Checking for MOVE and MOVEA)
    BEQ     Branch_Check_MOVEorMOVEA       *Need to see more bits to see which move instruction it is
    
    CMP    #$00000003,D5                   *compares to 3 (Checking for MOVE and MOVEA)
    BEQ     Branch_Check_MOVEorMOVEA       *Need to see more bits to see if it's move
    
    CMP     #$00000004,D5                  *either movem lea jsr, rts or nop
    BEQ     Branch_FirstHex4               *equal to 4 so go to hex 4 branch
    
    CMP     #$00000005,D5
    BEQ     Branch_FirstHex5               *equal to 5 so go to hex 5 branch

    CMP     #$00000006,D5
    BEQ     Branch_FirstHex6               *equal to 6 so go to hex 4 branch
    
    CMP     #$00000007,D5
    BEQ     Branch_FirstHex7               *equal to 7 so go to hex 7 branch

    CMP     #$00000008,D5                  *compares to 8
    BEQ     Branch_FirstHex8               *equal to 8 then branch else go on
    
    CMP     #$00000009,D5
    BEQ     Branch_FirstHex9               *equal to 9 so go to hex 9 branch
    
    CMP     #$0000000C,D5                  *compares to C
    BEQ     Branch_FirstHexC               *equal to C then branch else go on

    CMP     #$0000000D,D5                  *compares to D
    BEQ     Branch_FirstHexD               *equal to D then branch else go on
    
    CMP     #$0000000E,D5                  *compares to E
    BEQ     Branch_FirstHexE               *equal to E then branch else go on
    
    *CASES IN WHICH IT DID NOT HIT ANYTHING, FIRST HEX = A,B and C
    CMP     #$0000000A,D5                  *First hex is A
    
    BEQ     Branch_InvalidData
    
    CMP     #$0000000B,D5                  *First hex is B
    
    BEQ     Branch_InvalidData
    
    CMP     #$0000000F,D5                  *Final case F therefore its gonna be data 
   
    BEQ     Branch_InvalidData              
 
    rts
    
*------------------------------------------------------------
*0*     Branch_FirstHex0_ADDIandSUBI and supporting functions
*------------------------------------------------------------
*       ADDI, SUBI
*------------------------------------------------------------
Branch_FirstHex0:
    CLR         D6
    CLR         D7
    
    jsr         ReadTo_Condition *Condition not actually used for ADDI or SUBI, this is just to store the next 4 bits
    
    MOVE.L      Condition,D6     *Retrieves condition
    
    cmp         #4,D6            *If condition = 4 then its SUBI else if 6 its ADDI else error
    *If equal to 4 
    BEQ         Branch_FirstHex0_SUBI 
    
    cmp         #6,D6  
    *else if = 6
    BEQ         Branch_FirstHex0_ADDI
    *
    BRA         Branch_InvalidData
    
Branch_FirstHex0_Next:

    jsr         ReadTo_S_light      *2 bits to S_light
    
    jsr         ReadTo_Mode_dest    *3 bits to Mode_dest
    
    jsr         ReadTo_Reg_dest     *3 bits to Reg_Dest

    BRA         Mode_Dest_Is_Valid

Branch_FirstHex0_SUBI:

    MOVE.L      #1,PrintVariable *1 = SUBI for printing

    jmp         Branch_FirstHex0_Next   *continue

Branch_FirstHex0_ADDI:
    
    MOVE.L      #0,PrintVariable *0 = ADDI for printing

    jmp         Branch_FirstHex0_Next   *continue

*-------------------------------------------------------------
*1*     Branch_FirstHex1 function and supporting sub functions
        *Also used for *2* and *3* 
*-------------------------------------------------------------
*       MOVE
*-------------------------------------------------------------
Branch_FirstHex1_MOVE
    CLR     D6      *clear for future use
    CLR     D7
    
    MOVE.B  D5,D6   *move first byte of D5 which contains S dark into move 6
    
    LSL.L   #5,D6           *first 8 bits in D5 is ???? ?--- (- is the first 3 bits)
    LSR.L   #5,D6           *we have to get rid of the question mark so chop it off by lsl and lsr back by 5 this adds 0's
                            *D5 is now guaranteed to be just ur 3 bits at the end 0000 0--- 
   
    MOVE.B  D6,S_dark       *Move whats in D6 into S_dark, D6 contains .b, .w, .l variables
    
    CMP     #0,D6
    
    BEQ     Branch_InvalidData
    
move_rest_data
    jsr     ReadTo_Reg_dest       *reads 3 bits to Dn register (destination register)
    jsr     ReadTo_Mode_dest      *reads 3 bits to Mode_dest
    
    jsr     ReadTo_Mode_src      *Move 3 bits to  Mode_reg
    jsr     ReadTo_Reg_src       *reads 3 bits to Reg_dest
    
    MOVE.L  #3,PrintVariable
 
    CLR     D6      *clear before next use
    
    JSR     Mode_Src_Is_Valid
    
    BRA     Mode_Dest_Is_Valid
    
*---------------------------------------------------------------
*2/3*    Branch_FirstHex1 function and supporting sub functions
         *Also used for *3*    
*---------------------------------------------------------------
*        MOVE,MOVEA
*---------------------------------------------------------------
Branch_FirstHex2_MOVEA
    CLR     D6      *clear for future use
    CLR     D7   
    
    MOVE.B  D5,D6   *move first byte of D5 which contains S dark into move 6
    
    LSL.L   #5,D6           *first 8 bits in D5 is ???? ?--- (- is the first 3 bits)
    LSR.L   #5,D6           *we have to get rid of the question mark so chop it off by lsl and lsr back by 5 this adds 0's
                            *D5 is now guaranteed to be just ur 3 bits at the end 0000 0--- 
   
    CMP     #0,D6
    
    BEQ     Branch_InvalidData
   
    MOVE.B  D6,S_dark       *Move whats in D6 into S_dark, D6 contains .b, .w, .l variables
    
    *Basically the same as MOVE except different number
    jsr     ReadTo_Reg_dest       *reads 3 bits to Dn register (destination register)
    jsr     ReadTo_Mode_dest      *reads 3 bits to Mode_dest
    
    jsr     ReadTo_Mode_src      *Move 3 bits to  Mode_reg
    jsr     ReadTo_Reg_src       *reads 3 bits to Reg_dest
    
    MOVE.L  #2,PrintVariable
 
    JSR     Mode_Src_Is_Valid
    
    BRA     Mode_Dest_Is_Valid

Branch_Check_MOVEorMOVEA
    CLR     D6          *Make sure it's empty before using
    MOVE.L  Word1,D6

    ROL.W   #6,D6           *# bits after first 4 are both registers, need to check mode, so ROL 6 times
                            *Puts destination mode into right most spot
                        
    LSL.B   #5,D6           *first 8 bits in D5 is ???? ?--- (- is the first 3 bits)
                            *we have to get rid of the question mark so chop it off by lsl and lsr back by 5 this adds 0's
    LSR.B   #5,D6           *D5 is now guaranteed to be just ur 3 bits at the end 0000 0--- 
                            
    MOVE.B  D6,D7           *Only need last 3 bits
    
    CMP     #$00000001,D7   *If this equals 1, then it is MOVEA
    BEQ     Branch_FirstHex2_MOVEA    *If equal it is MOVEA, go to MOVEA
    BRA     Branch_FirstHex1_MOVE    *If not equal it is MOVE 
    
    rts
    
*-------------------------------------------------------------
*4*     Branch_FirstHex4 function and supporting sub functions
*-------------------------------------------------------------
*       MOVEM,LEA,JSR,RTS,NOP
*-------------------------------------------------------------
Branch_FirstHex4:

    jsr     ReadTo_Dn_reg      *Not actually needed, just used to store the first 3 bits for comparison
    
    MOVE.L  Word1,D5
    
    ROR.W   #2,D5               *Used for D-Pink
    
    MOVE.L  D5,Word1            *Used for storing back in for reading
    
    jsr     ReadTo_D_pink
    
    MOVE.L  Word1,D5            *Retrieve for rotation one more
    
    ROL.W   #1,D5           
    
    MOVE.L  D5,Word1            *Store for next 
    
    CLR     D5
    
    MOVE.L  Dn_reg,D5          *Retrieve Dn_reg
    
    cmp     #7,D5              *If 7 go to first set else go to second set
    *If 7
    BEQ     Branch_FirstHex4_FirstSet
    *else
    BRA     Branch_FirstHex4_SecondSet     

Branch_FirstHex4_Next: 

    jsr     ReadTo_Mode_dest    *3 bits to Mode_dest
    
    jsr     ReadTo_Reg_dest     *3 bits to Reg_dest
    
    BRA     Mode_Dest_Is_Valid

Branch_FirstHex4_FirstSet:  *Either LEA,JSR,RTS,NOP
    
    jsr     ReadTo_An_reg   *Not used for any of these functions, Just to store 3 bits
    
    CLR     D5
    
    MOVE.L  An_reg,D5       *Retrieves An_reg
    
    cmp     #1,D5           *If 1 (RTS or NOP) else if 2 (JSR) else if 7 (LEA) else invalid
    *If 1 
    BEQ     Branch_FirstHex4_RTS_OR_NOP
    
    cmp     #2,D5
    *else if 2
    BEQ     Branch_FirstHex4_JSR 
    
    cmp     #7,D5
    *else if 7
    BEQ     Branch_FirstHex4_LEA
    *else
    BRA     Branch_InvalidData
    
Branch_FirstHex4_SecondSet: *Either LEA or MOVEM
    
    CLR     D6 *used to hold total
    
    jsr     ReadTo_M_blue     *Not used just rol 1 bit
    
    CLR     D5          *Clears for after jsr
    
    MOVE.L  M_blue,D5   *Retrieving M_blue 
    
    LSL.L   #1,D5       *Shift left by one for adding
    
    ADD.L   D5,D6       *Adds
                           
    jsr     ReadTo_M_blue   *Not used just
    
    CLR     D5          *Clears for after jsr
    
    MOVE.L  M_blue,D5   *Retrieving M_blue
    
    ADD.L   D5,D6       *Adds now to D6
    
    LSL.L   #1,D6       *Shift left by one for adding
    
    jsr     ReadTo_S_mid       *Only used for MOVEM
    
    CLR     D5          *Test
    
    MOVE.L  S_mid,D5    *Retrieving S_mid
    
    ADD.L   D5,D6       *Adds both to see whats in the 3 bits total
    
    cmp     #7,D6       *If 7 LEA else if (4 or 3) MOVEM else error
    *If 7 
    BEQ     Branch_FirstHex4_LEA 

    cmp     #2,D6 
    *Else if 4
    BEQ     Branch_FirstHex4_MOVEM

    cmp     #3,D6 
    *Else if 3
    BEQ     Branch_FirstHex4_MOVEM
    
    BRA     Branch_InvalidData
    
Branch_FirstHex4_RTS_OR_NOP:

    jsr     ReadTo_M_blue      *1 bits (NOT ACTUALLY USED IN INSTRUCTION JUST USED FOR INCREMENT 1)
    MOVE.L  M_blue,D6
    ROL.L   #1,D6
    jsr     ReadTo_M_blue      *1 bits (NOT ACTUALLY USED IN INSTRUCTION JUST USED FOR INCREMENT 1)
    MOVE.L  M_blue,D4
    ADD.L   D4,D6   

    CMP     #3,D6
    *Only pass if the 2 bits are 3 
    BEQ     Branch_FirstHex4_RTS_OR_NOP_Nx
    
    BRA     Branch_InvalidData
    
Branch_FirstHex4_RTS_OR_NOP_Nx:    
    
    jsr     ReadTo_Condition   *Used to increment 4 bits and store the bits, Condition not required

    MOVE.L  Condition,D5        *Retrieve condition

    cmp     #5,D5               *If 5 (RTS) else if 1  (NOP) else error
    *If 5
    BEQ     Branch_FirstHex4_RTS
    
    cmp     #1,D5
    *Else if 1
    BEQ     Branch_FirstHex4_NOP
    
    BRA     Branch_InvalidData
 
Branch_FirstHex4_MOVEM:

    MOVE.L  Dn_reg,D5
    
    CMP     #4,D5
    
    BEQ     Branch_FirstHex4_MOVEM_next
    
    CMP     #6,D5

    BEQ     Branch_FirstHex4_MOVEM_next
    
    BRA     Branch_InvalidData

    Branch_FirstHex4_MOVEM_next:

    MOVE.L  #4,PrintVariable    *4 = MOVEM

    jmp     Branch_FirstHex4_Next   
    
Branch_FirstHex4_LEA:

    MOVE.L  #5,PrintVariable

    jmp     Branch_FirstHex4_Next

Branch_FirstHex4_JSR:

    MOVE.L  #6,PrintVariable

    jmp     Branch_FirstHex4_Next

Branch_FirstHex4_RTS:

    MOVE.L  #7,PrintVariable

    rts     *Return because over
    
Branch_FirstHex4_NOP:

    MOVE.L  #8,PrintVariable

    rts     *Return because over
    
*---------------------------------------------------------   
*5*     Branch_FirstHex5 function and supporting functions
*---------------------------------------------------------
*       ADDQ
*---------------------------------------------------------
Branch_FirstHex5:  
    MOVE.L  #9,PrintVariable

    jsr     ReadTo_Data_3bits  *Reads 3 bits into Data 
    jsr     ReadTo_M_blue      *Read the 0 bit after data to M_blue (Omar Note: Not sure were else to put this lone bit
    jsr     ReadTo_S_light     *Read 2 bits into S_light to show size
    jsr     ReadTo_Mode_src    *Read 3 bits into Mode_src variable
    jsr     ReadTo_Reg_src     *Read 3 bits into Reg_src
    
    BRA     Mode_src_Is_Valid

*---------------------------------------------------------
*6*     Branch_FirstHex6 function and supporting functions
*---------------------------------------------------------
*       Bcc, BRA
*---------------------------------------------------------
Branch_FirstHex6: 

    jsr     ReadTo_Condition    *reads first 4 bits
    
    MOVE.L  Condition,D5    *For comparison
    
    cmp     #0,D5           *If condition is 0 then its BRA else if (4||C||D) its Bcc else ERROR
    
    BEQ     Branch_FirstHex6_BRA

    cmp     #4,D5

    BEQ     Branch_FirstHex6_Bcc

    cmp     #$C,D5
    
    BEQ     Branch_FirstHex6_Bcc
    
    cmp     #$D,D5
    
    BEQ     Branch_FirstHex6_Bcc
    
    BRA     Branch_InvalidData
    

Branch_FirstHex6_Next:
    
    jsr     ReadTo_Displacement    *reads first 8 bits
    
    rts
    
Branch_FirstHex6_BRA:
    
    MOVE.L  #$B,PrintVariable   *B = Bcc
 
    jmp     Branch_FirstHex6_Next
 
Branch_FirstHex6_Bcc:

    MOVE.L  #$A,PrintVariable   *A = BRA
    
    jmp     Branch_FirstHex6_Next

*-------------------------------------------------------------
*7*     Branch_FirstHex7 function and supporting sub functions
*-------------------------------------------------------------
*       MOVEQ
*-------------------------------------------------------------
Branch_FirstHex7   

    MOVE.L  #$C,PrintVariable

    jsr     ReadTo_Dn_reg    *read 3 bits into Dn_reg
    jsr     ReadTo_M_blue    *read lone 0 bit into M_blue variable
    
    MOVE.L  M_blue,D5
    CMP     #1,D5                   *If M_Blue 1 then its invalid data 
    BEQ     Branch_InvalidData
    
    jsr     ReadTo_Data_word *read 8 bits into data
    
    rts
    
*-------------------------------------------------------------    
*8*     Branch_FirstHex8 function and supporting sub functions
*-------------------------------------------------------------
*       DIVU, OR
*-------------------------------------------------------------
Branch_FirstHex8:  
    
    jsr     ReadTo_Dn_reg       *reads 3 bits to Dn_reg
    
    jsr     ReadTo_D_org_grn    *reads 1 bit to D_org_grn
   
    jsr     ReadTo_S_light      *reads 2 bits to S_light
    
    *If S_light is 3 then its DIVU, else its OR
    
    CLR     D5
    
    MOVE.L  S_light,D5
    
    cmp     #3,D5
    
    BEQ     Branch_FirstHex8_DIVU   *if 3 DIVU
    
    BRA     Branch_FirstHex8_OR     *Else OR
    
Branch_FirstHex8_Next:
    
    jsr     ReadTo_Mode_src    *reads 3 bits to Mode_src
    
    jsr     ReadTo_Reg_src     *reads 3 bits to Reg_src
    
    BRA     Mode_src_Is_Valid

Branch_FirstHex8_DIVU:

    MOVE.L  #$E,PrintVariable       *E = DIVU
    
    jmp     Branch_FirstHex8_Next   *jump back to finish reading

Branch_FirstHex8_OR:
                            
    MOVE.L  #$D,PrintVariable       *D = OR
    
    jmp     Branch_FirstHex8_Next    
    
*-------------------------------------------------------------
*9*     Branch_FirstHex9 function and supporting sub functions
*-------------------------------------------------------------
*       SUB
*-------------------------------------------------------------
Branch_FirstHex9: 

    MOVE.L  #$F,PrintVariable

    jsr     ReadTo_Dn_reg   *Read 3 bits to Dn_reg
    jsr     ReadTo_D_org_grn *read 1 bit into D_org_grn
    jsr     ReadTo_S_light   *Read 2 bits into S_light
    
    MOVE.L  S_light,D5
    CMP     #3,D5
    BEQ     Branch_InvalidData
    
    jsr     ReadTo_Mode_src *Read 3 bits into Mode_src
    jsr     ReadTo_Reg_src  *Read 3 bits into Reg_src
    
    BRA     Mode_src_Is_valid
 
*-------------------------------------------------------------   
*C*     Branch_FirstHexC function and supporting sub functions
*-------------------------------------------------------------
*       MULS, AND
*-------------------------------------------------------------
Branch_FirstHexC:   
    
    jsr     ReadTo_Dn_Reg         *reads first 3 bits stores in Dn_Reg
    
    jsr     ReadTo_D_org_grn      *reads first 1 bit stores in D_org_grn
    
    jsr     ReadTo_S_light        *Reads first 2 bits to S_light
    
    CLR     D5
    
    MOVE.L  S_light,D5            *For comparison
    
    cmp     #3,D5                 *If 3 then its MULS else its and AND
    
    BEQ     Branch_FirstHexC_MULS  

    BRA     Branch_FirstHexC_AND   
    
Branch_FirstHexC_Next

    jsr     ReadTo_Mode_src
    
    jsr     ReadTo_Reg_src

    BRA     Mode_src_Is_Valid

Branch_FirstHexC_MULS
    
    MOVE.L  #$10,PrintVariable
    
    jmp     Branch_FirstHexC_Next
    
Branch_FirstHexC_AND
    
    MOVE.L  #$11,PrintVariable
    
    jmp     Branch_FirstHexC_Next

*-------------------------------------------------------------
*D*     Branch_FirstHexD function and supporting sub functions
*-------------------------------------------------------------
*       ADD, ADDA
*-------------------------------------------------------------
Branch_FirstHexD: 

    jsr     ReadTo_Dn_Reg       *First read 3 bits to Dn for ADD
    
    CLR     D5
    
    MOVE.L  WORD1,D5            *have to re rotate word1 back by 3
    ROR.W   #3,D5
    MOVE.L  D5,WORD1            *Reloads word1
    
    jsr     ReadTo_An_Reg       *Reads to 3 bitsAn_Reg for ADDA
    
    jsr     ReadTo_D_org_grn    *read 1 bit to D_org_grn for ADD 

    MOVE.L  WORD1,D5            *have to re rotate word1 back by 1
    ROR.W   #1,D5
    MOVE.L  D5,WORD1            *Reloads word1

    jsr     ReadTo_S_mid        *Read 1 bit to S_mid for ADDA
    
    jsr     ReadTo_S_light      *Read 2 bits to S_light for ADD
    
    CLR     D5
    
    MOVE.L  S_light,D5          *Move out for comparison

    cmp     #3,D5               *if S_light is 3 then its ADDA else its ADD
    
    BEQ     Branch_FirstHexD_ADDA

    BRA     Branch_FirstHexD_ADD     
    
Branch_FirstHexD_Next:

    jsr     ReadTo_Mode_src    *Reads 3 bits to Mode_dest
    
    jsr     ReadTo_Reg_src      *Reads 3 bits to Reg_dest

    BRA     Mode_src_Is_Valid   

Branch_FirstHexD_ADD:

    MOVE.L  #00000000,S_mid     *Clears S_mid since its not used

    MOVE.L  #$12,PrintVariable   *C = ADD

    jmp     Branch_FirstHexD_Next

Branch_FirstHexD_ADDA:
    
    MOVE.L  #00000000,S_light   *resets S_light since its the one not used
    
    MOVE.L  #$13,PrintVariable   *D = ADDA
    
    jmp     Branch_FirstHexD_Next
    
*-------------------------------------------------------------    
*E*     Branch_FirstHexE function and supporting sub functions
*-------------------------------------------------------------
*       ASd, LSd, ROd
*-------------------------------------------------------------
Branch_FirstHexE:

    jsr     ReadTo_Rotation     *Reads first 3 bits to rotation
    
    jsr     ReadTo_D_org_grn    *Reads first 2 bits to D_org_grn
    
    jsr     ReadTo_S_light      *Reads first 2 bits to S_light
       
    MOVE.L  S_light,D5           *Retrieve S_light as comparison
    
    
    cmp     #3,D5               *If = 3 then go to second set else go to first set (immediate shifting)
    *if = 3
    BEQ     Branch_FirstHexE_FirstSet
    *else
    BRA     Branch_FirstHexE_SecondSet    
    

Branch_FirstHexE_FirstSet:

    MOVE.L  Rotation,D5       *Retrieves Rotation

    cmp     #0,D5           *If 0 Asd else if 1 LSd else if 3 ROd else invalid
    *If = 0
    BEQ     Branch_FirstHexE_FirstSet_ASd   
    
    cmp     #1,D5
    *else if = 1
    BEQ     Branch_FirstHexE_FirstSet_LSd
    
    cmp     #3,D5
    *else if = 3 
    BEQ     Branch_FirstHexE_FirstSet_ROd
    *else
    BRA     Branch_InvalidData
    
Branch_FirstHexE_FirstSet_Next: 

    jsr     ReadTo_Mode_dest    *Reads 3 bits to Mode_dest
    
    jsr     ReadTo_Reg_dest     *Reads 3 bits to Reg_dest
       
    BRA     Mode_Dest_Is_Valid

Branch_FirstHexE_SecondSet: *Not immediate addressing

    jsr     ReadTo_M_blue   *Read 1 bit to M_blue
    
    jsr     ReadTo_S_dark   *data not required, just used to store the next 2 bits 
    
    clr     D5
    
    MOVE.L  S_dark,D5       *Retrieves data

    MOVE.L  #00000000,S_dark    *resets the value of S_Dark

    cmp     #0,D5           *If 0 Asd else if 1 LSd else if 3 ROd else invalid
    *If = 0
    BEQ     Branch_FirstHexE_SecondSet_ASd 
    
    cmp     #1,D5
    *else if = 1
    BEQ     Branch_FirstHexE_SecondSet_LSd
    
    cmp     #3,D5
    *else if = 3 
    BEQ     Branch_FirstHexE_SecondSet_ROd
    *else
    BRA     Branch_InvalidData
    
Branch_FirstHexE_SecondSet_Next:    

    jsr     ReadTo_Dn_reg       *Read next 3 bits to Dn_reg
    
    rts

Branch_FirstHexE_FirstSet_ASd:

    MOVE.L  #$14,PrintVariable   *14 = ASd

    jmp     Branch_FirstHexE_FirstSet_Next     

Branch_FirstHexE_FirstSet_LSd:

    MOVE.L  #$15,PrintVariable   *15 = LSd

    jmp     Branch_FirstHexE_FirstSet_Next   

Branch_FirstHexE_FirstSet_ROd:

    MOVE.L  #$16,PrintVariable   *16 = ROd

    jmp     Branch_FirstHexE_FirstSet_Next

Branch_FirstHexE_SecondSet_ASd:

    MOVE.L  #$17,PrintVariable   *17 = ASd

    jmp     Branch_FirstHexE_SecondSet_Next     

Branch_FirstHexE_SecondSet_LSd:

    MOVE.L  #$18,PrintVariable   *18 = LSd

    jmp     Branch_FirstHexE_SecondSet_Next   

Branch_FirstHexE_SecondSet_ROd:

    MOVE.L  #$19,PrintVariable   *19 = ROd

    jmp     Branch_FirstHexE_SecondSet_Next   

*EMPTY CASES A,B,F and any invalid data, SET printVariable to #$20 = DATA 

Branch_InvalidData:

    MOVE.L  #$1A,PrintVariable      *#2 = DATA
    
    rts
    


































































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
