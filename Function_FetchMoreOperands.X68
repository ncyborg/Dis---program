FetchMoreOperands:
     MOVE.L     PrintVariable,D7    *Move printvariable to D4 in order to compare
     MOVEA.L    StartAddress,A2      *Move current address into A2 in order to grab more information
     CLR        D1                      *clears it 
    
    *Omar Note: Not all of these use addresses, so we don't need all the branches
               *right now every branch is commented since I havn't created all necessary labels yet
               
*Branching arguments - Check if more data is needed from memory (addresses and immediate data)
    CMP    #0,D7                          *Checking if it's ADDI or SUBI   
    BNE    check_SUBI         *equal to 0? Branch, else go on
    MOVE.L S_light,D1           *Move S_light into D1 if data is stored as long or as word.
    BRA    test_src_immediate_S_dark_long *Check if data is stored as long
    
check_SUBI
    CMP     #1,D7                  *Checking if it's ADDI or SUBI
    BNE     check_rest          *equal to 1? Branch, else go on
    MOVE.L  S_light,D1           *Move S_light to D1 to check if data is being stored as word or long.
    BRA     test_src_immediate_S_dark_long *Check if data is stored as long
    
check_rest
    CMP     #2,D7                  *Compare 2 to first hex, if equal its MOVEA
    BEQ     test_immediate_S_dark         *equal to 2? Branch, else go on
    
    CMP     #3,D7                  *Compare 3 to first hex, if equal its MOVE
    BEQ     test_immediate_S_dark          *equal to 4? Branch, else go on
    
    CMP     #4,D7                  *compares 4 to D7 (Checking for MOVEM)(MOVEM can't have immediate data)
    BEQ     test_MOVE_FUNCTION      *Equal to 4? Branch, else go on
    
    CMP     #5,D7                   *compares to 5 to D7(Checking for LEA) (LEA doesn't have immediate data)
    BEQ     Check_for_moreOperands       *Equal to 5? Branch, else go on
    
    CMP     #6,D7                   *Compares 6 to D7 (Checking for jSR) (JSR doesn't have immediate data)
    BEQ     Mode_dest_check                    *JSR doesn't need additional data, move on
    
    CMP     #7,D7                   *Comapre 7 to D7 (Checking for RTS) 
    BEQ     return                  *RTS doesn't need additional data move on 

    CMP     #8,D7
    BEQ     return                 *equal to 6 so go to hex 4 branch
    
    CMP     #9,D7                   *Testing for ADDQ 
    BEQ     test_immediate_S_light    *equal to 7 so go to hex 7 branch

    CMP     #$A,D7                      *compares 10 to D7 (Checking for Bcc)
    BEQ     test_for_Bcc_and_Bra                      *Bcc doesn't need additional data
   
    CMP     #$B,D7                      *Compares B (11) to D7 (Checking for BRA)
    BEQ     test_for_Bcc_and_Bra                        *equal to 10, go to return (BRA doesn't have an address)
    
    CMP     #$C,D7                      *compares to C (Checking for MOVEQ)
    BEQ     return                      *equal to C then branch else go on

    CMP     #$D,D7                      *Compares D to D7 (Checking for OR)
    BEQ     test_immediate_S_light       *equal to D then branch else go on
    
    CMP     #$E,D7                      *compares to E (Checking for DIVU)
    BEQ     Check_for_moreOperands      *equal to E then branch else go on
    
    CMP     #$F,D7                      *compares to E (Checking for SUB)
    BEQ     test_immediate_S_light      *equal to E then branch else go on
    
    CMP     #$10,D7                      *compares to 0x10 (Checking for MULS)
    BEQ     Check_for_moreOperands       *equal to 0x10 then branch else go on
    
    CMP     #$11,D7                      *compares to 0x11 (Checking for AND)
    BEQ     test_immediate_S_light       *equal to 0x11 then branch else go on
    
    CMP     #$12,D7                      *compares to 0x12 (Checking for ADD)
    BEQ     test_immediate_S_light       *equal to 0x12 then branch else go on
    
    CMP     #$13,D7                      *compares to 0x13 (Checking for ADDA)
    BEQ     test_immediate_S_med         *equal to 0x13 then branch else go on
    
    CMP     #$14,D7                      *compares to 0x14 (Checking for LSd)
    BEQ     Check_for_moreOperands      *equal to 0x14 then branch else go on
    
    CMP     #$15,D7                      *compares to 0x15 (Checking for ASd)
    BEQ     Check_for_moreOperands      *equal to 0x15 then branch else go on
    
    CMP     #$16,D7                      *compares to 0x16 (Checking for ROd)
    BEQ     Check_for_moreOperands      *equal to 0x16 then branch else go on
    
    rts
    
**********************************************HELPER FUNCTION/SUBROUTINES FOR GETTING MORE OPERANDS*****************************************************
*USED BY FOR OPCODES THAT ARE SIMILAR, OPCODES THAT ARE SPECIAL IN HAVING HARD CODED ADDRESSES AND IMMEDIATE DATA WILL HAVE THEIR OWN SPECIAL FUNCTIONS* 
*-------------------------------------------------------------------------------------------------------------------------------------------------------
*Test if functions need to get more operands
Check_for_moreOperands
    MOVE.L  Mode_src,D1 *Move mode src to check if source is an address
    *MOVE.L  Mode_dest,D2 *Move mode src to check if destination is an address
    
    CMP #7,D1 *If equal, source is an address, else check destination
    BNE Mode_dest_check
    MOVE.L  Reg_src,D1
    JSR test_Reg_src_word *Check if address is word long, if not will jump to check if long or immediate data
   
Mode_dest_check
    MOVE.L  Mode_dest,D2    *Move mode src to check if destination is an Address
    CMP #7,D2 *If equal, destination is an address, else return
    BNE return
    MOVE.L  Reg_dest,D2
    JSR test_Reg_dest_word *Check if address is word, if not check if long, if not, returns
    BRA return

*--------------------------------------------------------------------------------------
*Test for Reg_src word
test_Reg_src_word
    CMP     #0,D1 *Test if Reg_src contains 000 (or 0 in other words)
                                *this shows that it's word.
    BNE     test_Reg_src_long
    *If not equal then branch else continue
    
    CLR     D4
    MOVE.W  (A2)+,D4 *Store next word of data which is an address
    MOVE.L  D4,Word2
    jsr     return
    rts
*Test for Reg_dest word
test_Reg_dest_word
    CMP     #0,D2 *Test if Mode_src contains 000, this shows it's a word address
    BNE     test_Reg_dest_long
    CLR     D4
    MOVE.W  (A2)+,D4
    MOVE.L  D4,Word4
    jsr     return
    rts
    
*Test for Reg_src longa
test_Reg_src_long
    CMP     #1,D1  *Test if Reg_src contains 001 (or 1 in other words)
    BEQ     direct_storage_long
direct_storage_word
    CLR     D4
    MOVE.W  (A2)+,D4
    MOVE.L  D4,Word2
    jsr     return
    rts

direct_storage_long
    CLR     D4             *this shows that it's long.
    MOVE.W  (A2)+,D4       *Check next two words of data for long address
    MOVE.L  D4,Word2       *Moves back in
    CLR     D4
    MOVE.W  (A2)+,D4
    MOVE.L  D4,Word3
    jsr     return
    rts

*Test for Reg_dest long
test_Reg_dest_long
    CLR     D4             *this shows that it's long.
    MOVE.W  (A2)+,D4       *Check next two words of data for long address
    MOVE.L  D4,Word4       *Moves back in
    CLR     D4
    MOVE.W  (A2)+,D4
    MOVE.L  D4,Word5
    jsr     return
    rts
    
*------------------------------------------------------------------------------------------
*Test for #<immediate> (S_light)
test_immediate_S_light
    MOVE.L  Mode_src,D1
    CMP     #7,D1
    BNE     Check_for_moreOperands *if Mode_src isn't an address or immediate data, but Mode_dest might still be
    
    MOVE.L  Reg_src,D1 *Need to check if Reg_src is equal to 4 if it's not then not immediate data
    CMP     #4,D1
    BNE     Check_for_moreOperands
    
    MOVE.L  S_light,D1 *If D1 is equal to 4 then can proceed to check what S_light is
test_src_immediate_S_light_long     
    CMP     #2,D1 *Test if Reg_src contains 10 (or 2 in other words)
                                *this shows that it's long.
    BNE     test_src_immediate_S_light_BorW     *Branch if not equal
    *MOVE.W  (A2)+,Word2 *move a variable into Word2
    *MOVE.W  (A2)+,Word3 
    JSR      direct_storage_long
    
    *Now that src has been saved time to get dest
    BRA     Mode_dest_check *Go and check if dest is an address 

test_src_immediate_S_light_BorW
    *If D1 not equal to 2 then get byte/word of data
    JSR    direct_storage_word  *get byte/word of data
    
    *Now that src has been saved time to get dest
    BRA     Mode_dest_check *Go and check if dest is an address
    
*____________________________________________________________________
*Test for #<immediate> (S_med)
test_immediate_S_med
    *Move in order to compare
    MOVE.L  Mode_src,D1
    CMP     #7,D1
    BNE     Check_for_moreOperands *if D1 contains 7, then source is immediate data, else branch
    
    *Check if Reg_src is 4, if not then branch away else store data
    MOVE.L  Reg_src,D1 *Need to check if Reg_src is equal 4 if it's not then not immediate data
    CMP     #4,D1
    BNE     Check_for_moreOperands
    
    *store the data if not a word the branch to long
    MOVE.L  S_mid,D1 *If D1 is equal to 7 then check for how much data to grab.
    CMP     #0,D1 *If 0 is equal to D1 then it's a word of data (since S_med)
    BNE     test_src_immediate_S_med_long
  
    *If S_mid was equak to 0 the store word into Word2 and then move to check destination
    JSR     direct_storage_word
    BRA     Mode_dest_check *Go and check if dest is an address

test_src_immediate_S_med_long
    *If S_mid wasn't equal to 0 then can only be long so store 2 words of data from memory
    JSR     direct_storage_long
    
    *Now that src has been saved time to get dest
    BRA     Mode_dest_check *Go and check if dest is an address
    
*_____________________________________________________________________
*Test for #<immediate> (S_dark)
test_immediate_S_Dark
    *Move mode source in order to check if data might be immediate
    MOVE.L  Mode_src,D1
    CMP     #7,D1
    BNE     Check_for_moreOperands *if Mode_src isn't an address or immediate data, but Mode_dest might still be
    
    *If mode source was 7 check if register source is 4 for immediate data
    MOVE.L  Reg_src,D1 *Need to check if Reg_src is equal to 4 if it's not then not immediate data
    CMP     #4,D1
    BNE     Check_for_moreOperands
    
    *Move S_dark to D1 to compare
    MOVE.B  S_dark,D1 *If D1 is equal to 4 then can proceed to check what S_light is
    
test_src_immediate_S_dark_long   
    *Compare 2 to D1 to check if it's long address  
    CMP     #2,D1 *Test if Reg_src contains 10 (or 2 in other words)
                                *this shows that it's long.
    BNE     test_src_immediate_S_dark_BorW     *Branch if not equal
    
    *If D1 equal to 2 then store the long address in word2 and word3 and then check if destination is an address
    JSR     direct_storage_long 
    BRA     Mode_dest_check *Since you got the source (immediate data) no need to check it again. 

test_src_immediate_S_dark_BorW
    *If D1 not equal to 2 then get byte/word of data
    JSR direct_storage_word *get byte/word of data
    
    *Now that src has been saved time to get dest
    BRA     Mode_dest_check *Go and check if dest is an address
    
*_________________________________________________________________________
test_for_Bcc_and_Bra
    *Check if displacement is 0 if it is then get a word from memory, else don't
    MOVE.L  Displacement,D1
    CMP     #$00,D1
    BNE     return *If discplacement isn't 0 then return without grabbing from memory
  
    *If displacement is equal to 0 grab data from memory and then return.
    MOVE.W  (A2)+,D4 *Store next word of data which is an address
    MOVE.W  D4,Word2
    BRA     return
*------------------------------------------------------------------------------------------------------------------------------------------------------------
 
**********************************************************************************************************************************
return
    MOVE.L  A2,StartAddress *Update StartAddress so as to not lose A2
    rts

*******************************************************************
*For MOVEM 
*******************************************************************

test_MOVE_FUNCTION:
*Take in a word then test Mode dest if take in more

    jsr test_Reg_src_word
    
    jsr Mode_dest_check
    
    rts






















*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
