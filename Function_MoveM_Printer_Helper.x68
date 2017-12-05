******************The following functions are to used to print the MOVEM instruction.*******************************************

MOVEM_Helper:               **Check if we are looking at a single data register or a list of data registers.
    JSR         Load_Word2
    MOVE.L      #0,D1
    MOVE.L      #0,D2
    MOVE.L      #0,D5       **D5 will be the count
    MOVE.L      #0,D6
    MOVE.L      #31,D7
Check_Single:               ***Here we count the number of set bits to determine if we are dealing with a single register.
    LSL.L       D7,D3
    LSR.L       D7,D3
    CMP.L       #16,D6
    BEQ         List_OR_Single
    CMP.L       #1,D3
    BEQ         Plus_Count
    ADDI        #1,D6
    JSR         Load_Word2
    LSR.L       D6,D3
    BRA         Check_Single
Plus_Count:                 **Keeps track of count of set bits.
    ADDI        #1,D5
    ADDI        #1,D6
    JSR         Load_Word2
    LSR.L       D6,D3
    BRA         Check_Single


********************************************************************************************************************************
***********************Function to discover if we are dealing with a list of registers or a single register.********************
********************************************************************************************************************************
List_OR_Single:
    CMP.L       #1,D5
    BGT         List_Side
    MOVE.L      Word1,D4
    MOVE.L      #24,D7
    LSL.L       D7,D4
    MOVE.L      #28,D7
    LSR.L       D7,D4
    CMP.L       #$E,D4
    BEQ         SinglePreDec
    CMP.L       #$A,D4
    BEQ         SinglePreDec
    BRA         Single


********************************************************************************************************************************
******************************Function to prepare for dealing with a list.******************************************************
********************************************************************************************************************************
List_Side:
    JSR         Pull_Bits_first_half    **D1
    JSR         Pull_Bits_second_half   **D2
    MOVE.L      #0,D5        **D5 is cleared to be used in comparison for D_pink to decide which side the list is on.
    BRA         List_source


********************************************************************************************************************************
**************************Function to load the code needed to decipher which MOVEM we are dealing with.*************************
********************************************************************************************************************************
Load_Word2:
    MOVE.L      #0,D3
    MOVE.L      Word2,D3
    RTS
    
    
********************************************************************************************************************************
**************************Functions to gather first and second half of bits storing them in different registers.****************
********************************************************************************************************************************
Pull_Bits_first_half:
    JSR         Load_Word2
    MOVE.L      #0,D1          **D1 will store the first half of the list bits (Dn's when pre-decremented).
    LSR.L       #8,D3
    MOVE.L      D3,D1
    RTS
Pull_Bits_second_half:
    JSR         Load_Word2
    MOVE.L      #0,D2          **D2 will store the second half of the list bits (An's when pre-decrement).
    LSL.L       #8,D3
    LSL.L       #8,D3
    LSL.L       #8,D3
    LSR.L       #8,D3
    LSR.L       #8,D3
    LSR.L       #8,D3
    MOVE.L      D3,D2
    RTS
    
    
********************************************************************************************************************************
****************************Function to print single NON-predecremented registers.**********************************************
********************************************************************************************************************************
Single:                 **Discover if we are dealing with Dn or An registers.
    MOVE.L      #0,D5
    MOVE.L      #1,D6
    JSR		 Pull_Bits_second_half		**If second half of bits is > 0, its Dn.
    CMP.L       #0,D2
    BGT		 SingleLoop
    JSR         Pull_Bits_first_half
    BRA	 	 An_SingleLoop
SingleLoop:             **Loop to find register of single Dn NON-predecremented.
    JSR         Pull_Bits_second_half
    LSR.L       D5,D2
    CMP.L       #1,D2
    BEQ         PrintDn_usingD5
    ADDI        #1,D5
    BRA         SingleLoop
An_SingleLoop:          **Loop to find register of a single An NON-predecremented.
    JSR         Pull_Bits_first_half
    LSR.L       D5,D1
    CMP.L       #1,D1
    BEQ         PrintAn_usingD5
    ADDI        #1,D5
    BRA         An_SingleLoop


********************************************************************************************************************************
************************Function to print single predecremented registers.******************************************************
********************************************************************************************************************************
SinglePreDec:           **Discovers if we are dealing with predecremented Dn or An registers.
    MOVE.L      #0,D5
    MOVE.L      #7,D6
    JSR         Pull_Bits_first_half
    CMP.L       #0,D1
    BGT         SingleLoopPD
    JSR         Pull_Bits_second_half
    BRA         An_SingleLoopPD
SingleLoopPD:           **Loop to find the register of a single predecremented Dn register.
    LSR.L       D6,D1
    CMP.L       #1,D1
    BEQ         PrintDn_usingD5
    ADDI        #1,D5
    SUBI        #1,D6
    JSR         Pull_Bits_first_half
    BRA         SingleLoopPD
An_SingleLoopPD:        **Loop to find the register of a single predecremented An register.
    LSR.L       D6,D2
    CMP.L       #1,D2
    BEQ         PrintAn_usingD5
    ADDI        #1,D5
    SUBI        #1,D6
    JSR         Pull_Bits_second_half
    BRA         An_SingleLoopPD
    
    
********************************************************************************************************************************
*******************************Functions to figure out if the list is predecremented or not.************************************
********************************************************************************************************************************
List_source:
    MOVE.L      Word1,D4
    JSR         Pull_Bits_first_half
    JSR         Pull_Bits_second_half
    MOVE.L      #24,D7
    LSL.L       D7,D4
    MOVE.L      #28,D7
    LSR.L       D7,D4
    CMP.L       #$A,D4
    BEQ         List_PreDec
    CMP.L       #$D,D4
    BGT		 List_PreDec     *If > $D, its a pre decremented list.
List:
    CMP.L       #0,D1
    BEQ         Print_Dn_List_Source
    CMP.L       #0,D2
    BEQ         Print_An_List_Source
    MOVE.L      #0,D0           **Count for first half of bits.	                    
    MOVE.L      #31,D4          **Used to roll bits to isolate a single bit.
    MOVE.L      #0,D5           **Count for second half of bits.
    MOVE.L      #0,D6           **Times through loop.
    MOVE.L      #0,D7           **Total count of bits set.
    BRA         CheckForSetBits


********************************************************************************************************************************
************************Function to order printing of mixed Dn and An lists (NON-predecremented).*******************************
********************************************************************************************************************************         
Mixed_List:
    JSR		Print_Dn_List_Source
    LEA		Text_Slash,A1
    JSR		PrintTextInA1
    JSR		Print_An_List_Source
    RTS
    
    
********************************************************************************************************************************
***************************Function to see how many bits are set for deciding which type of MOVEM we are looking at.************
********************************************************************************************************************************
CheckForSetBits:            **Checks for set bits in first half of bits.
    LSR.L       D6,D1    
    LSL.L       D4,D1    
    LSR.L       D4,D1
    CMP.L       #1,D1
    BEQ         AddToCountD7
CFSB_Second_half:           **Checks for set bits in second half of bits.
    LSR.L       D6,D2
    LSL.L       D4,D2
    LSR.L       D4,D2
    CMP.L       #1,D2
    BEQ         AddToCountD72
    ADDI        #1,D6
    CMP.L       #8,D6
    BEQ         Decision
    JSR         Pull_Bits_first_half
    JSR         Pull_Bits_second_half
    BRA         CheckForSetBits
    ADDI        #1,D6
    JSR         Load_Word2
    BRA         CheckForSetBits 
AddToCountD7:                   **Keeps track of count for first half of bits.
    ADDI        #1,D7
    ADDI        #1,D0
    JSR         Pull_Bits_first_half
    BRA         CFSB_Second_half
AddToCountD72:                  **Keeps track of count for second half of bits.
    ADDI        #1,D7
    ADDI        #1,D5
    ADDI        #1,D6
    JSR         Pull_Bits_second_half
    CMP.L       #8,D6
    BEQ         Decision
    JSR         Pull_Bits_first_half
    BRA         CheckForSetBits
    
    
*******************************************************************************************************************************
********Function to decide if we are looking at two single registers (Dn,An), a list plus a single register, or two lists.***** 
*******************************************************************************************************************************
Decision:
    CMP.L       #2,D7
    BEQ         SingleMixedDn
    CMP.L       #1,D5
    BEQ         MixedPlusSingle
    CMP.L       #1,D0
    BEQ         MixedPlusSingle
    BRA         Mixed_List


********************************************************************************************************************************
************************Function to decide which type of mixed List plus a Single register.*************************************

*******************************************************************************************************************************
MixedPlusSingle:
    JSR         Pull_Bits_first_half
    JSR         Pull_Bits_second_half
    CMP.L       #1,D5
    BEQ         AList_Dsingle
    BRA         DList_Asingle


********************************************************************************************************************************
*************************Function to print an Dn list and a An single (NON-predecrement).***************************************
********************************************************************************************************************************
DList_Asingle:
    JSR         Print_Dn_List_Source
    LEA         Text_Slash,A1
    JSR         PrintTextInA1
    MOVE.L      #0,D5
    MOVE.L      #7,D6
    JSR         An_SingleLoop
    RTS
    
    
********************************************************************************************************************************
*************************Function to print an An list and a Dn single (NON-predecrement).***************************************
********************************************************************************************************************************
AList_Dsingle:
    MOVE.L      #0,D5
    MOVE.L      #7,D6
    JSR         SingleLoop
    LEA         Text_Slash,A1
    JSR         PrintTextInA1
    JSR         Print_An_List_Source
    RTS


********************************************************************************************************************************
**********************Function to print a mixed list of single Dn and An registers (NON-predecrement).**************************
********************************************************************************************************************************
SingleMixedDn:
    JSR         Single
    LEA         Text_Slash,A1
    JSR         PrintTextInA1
    MOVE.L      #0,D5
    MOVE.L      #1,D6
    JSR         Pull_Bits_first_half
    JSR         An_SingleLoop
    RTS
    
    
    
********************************************************************************************************************************
***************************Function to decide to print a predecremented Dn list or An list.*************************************
********************************************************************************************************************************
List_PreDec:
    JSR     Pull_Bits_first_half
    JSR     Pull_Bits_second_half
    CMP.L	#0,D1
    BEQ		Print_AnList_Src_Predec
    CMP.L	#0,D2
    BEQ		Print_DnList_Src_Predec
    MOVE.L      #0,D0
    MOVE.L      #31,D4
    MOVE.L      #0,D5
    MOVE.L      #0,D6
    MOVE.L      #0,D7
    BRA         CheckForSetBitsPD


********************************************************************************************************************************
**********************Function to order printing of a mixed predecremented lists of Dn and An registers.************************
********************************************************************************************************************************
Mixed_PD:
    JSR		Print_DnList_src_Predec
    LEA		Text_Slash,A1
    JSR		PrintTextInA1
    JSR		Print_AnList_Src_Predec
    RTS
    
    
********************************************************************************************************************************
*****************Function to see how many bits are set, this determines which type of predecremented list we are looking at.****
********************************************************************************************************************************
CheckForSetBitsPD:              **Loop to check for set bits in first half of bits in a predecremented list.
    LSR.L       D6,D1
    LSL.L       D4,D1    
    LSR.L       D4,D1
    CMP.L       #1,D1
    BEQ         AddToCountD7PD
CFSBPD_Second_half:             **Loop to check for set bits in second half of bits in a predecremented list. 
    LSR.L       D6,D2
    LSL.L       D4,D2
    LSR.L       D4,D2
    CMP.L       #1,D2
    BEQ         AddToCountD7PD2
    ADDI        #1,D6
    CMP.L       #8,D6
    BEQ         DecisionPD
    JSR         Pull_Bits_first_half
    JSR         Pull_Bits_second_half
    BRA         CheckForSetBitsPD 

AddToCountD7PD:                 **Keeps track of count for first bits.
    ADDI        #1,D7
    ADDI        #1,D0
    JSR         Pull_Bits_first_half
    BRA         CFSBPD_Second_half
AddToCountD7PD2:                **Keeps track of count for second bits.
    ADDI        #1,D7
    ADDI        #1,D5
    ADDI        #1,D6
    JSR         Pull_Bits_first_half
    JSR         Pull_Bits_second_half
    CMP.L       #8,D6
    BEQ         DecisionPD
    BRA         CheckForSetBitsPD
DecisionPD:                     **Decides which predecremented case we are dealing with.
    CMP.L       #2,D7
    BEQ         SingleMixedPD
    CMP.L       #1,D5
    BEQ         MixedPlusSinglePD
    CMP.L       #1,D0
    BEQ         MixedPlusSinglePD
    BRA         Mixed_PD


********************************************************************************************************************************
********Function to decide if it's a predecremented Dn list and a single An, or a An list and a single Dn***********************
********************************************************************************************************************************
MixedPlusSinglePD:
    JSR         Pull_Bits_first_half
    JSR         Pull_Bits_second_half
    CMP.L       #1,D0
    BGT         DList_AsinglePD
    BRA         AList_DsinglePD


********************************************************************************************************************************
*************************Function for printing a predecremented list of Dn registers, with a single An register*****************
********************************************************************************************************************************
DList_AsinglePD:
    JSR         Print_DnList_src_Predec
    LEA         Text_Slash,A1
    JSR         PrintTextInA1
    MOVE.L      #0,D5
    MOVE.L      #7,D6
    JSR         An_SingleLoopPD
    RTS
    
    
********************************************************************************************************************************
*************************Function for printing a predecremented list of An registers, with a single Dn register*****************
********************************************************************************************************************************
AList_DsinglePD:
    MOVE.L      #0,D5
    MOVE.L      #7,D6
    JSR         SingleLoopPD
    LEA         Text_Slash,A1
    JSR         PrintTextInA1
    JSR         Print_AnList_src_Predec
    RTS


********************************************************************************************************************************
***************Function to order printing for a predecremented, mixed list, with single registers for both Dn and An************
********************************************************************************************************************************

SingleMixedPD:
    JSR         SinglePreDec    
    LEA         Text_Slash,A1
    JSR         PrintTextInA1
    MOVE.L      #0,D5
    MOVE.L      #7,D6
    JSR         Pull_Bits_first_half
    JSR         An_SingleLoopPD
    RTS


********************************************************************************************************************************
************************************Functions for printing Dn register list NON-predecremented**********************************
********************************************************************************************************************************
Print_Dn_List_Source:
    JSR		    Pull_Bits_second_half
    MOVE.L      #0,D5       **Counter for registers in list
    MOVE.L      #31,D7
DnSrcLoop:                  **DnSrcLoop will find the register # for the first Dn register in a NON-predecremented list.
    LSR.L       D5,D2
    LSL.L       D7,D2
    LSR.L       D7,D2
    CMP.L       #1,D2
    BLT         Add_to_Count_src
    JSR         PrintDn_usingD5
    LEA         Text_Dash,A1  
    JSR         PrintTextInA1
    MOVE.L      #0,D5
    MOVE.L      #0,D6 
    JSR         Pull_Bits_second_half
SecondHalf_Loop:            **SecondHalf_Loop will find the register # for the second Dn register in a NON-predecremented list.
    JSR         Pull_Bits_second_half
    LSR.L       D6,D2               
    CMP.L       #1,D2
    BGT         Add_to_Count_two
    ADDI        #1,D6
    CMP.L       #8,D6
    BLT         SecondHalf_Loop
    BRA         PrintDn_usingD5
Add_to_Count_src:           **Keeps count of the count for the first register.
    JSR         Pull_Bits_second_half     
    ADDI        #1,D5             
    BRA         DnSrcLoop
Add_to_Count_two:           **Keeps count of the count for the second register.
    JSR         Pull_Bits_second_half
    ADDI        #1,D5
    ADDI        #1,D6
    BRA         SecondHalf_Loop


********************************************************************************************************************************
*********************************************Functions for printing An register list NON-predecrement**************************
********************************************************************************************************************************
Print_An_List_Source:
    JSR         Pull_Bits_first_half
    MOVE.L      #0,D5       **Counter for registers in list
    MOVE.L      #31,D7
AnSrcLoop:                  **AnSrcLoop will find the register # for the first An register in a NON-predecremented list.
    LSR.L       D5,D1
    LSL.L       D7,D1
    LSR.L       D7,D1
    CMP.L       #0,D1
    BEQ         Add_to_Count_srcAN
    JSR         PrintAn_usingD5
    LEA         Text_Dash,A1  
    JSR         PrintTextInA1
    MOVE.L      #0,D5
    JSR         Pull_Bits_first_half
SecondHalf_LoopAN:         **SecondHalf_LoopAN will find the register # for the second An register in a NON-predecremented list.
    LSR.L       D5,D1                
    CMP.L       #0,D1
    BEQ         SUBone
    CMP.L       #7,D5
    BEQ         PrintAn_usingD5
    BRA         Add_to_Count_twoAN  
Add_to_Count_srcAN:         **Keeps track of the count for the first register.
    JSR         Pull_Bits_first_half     
    ADDI        #1,D5             
    BRA         AnSrcLoop
Add_to_Count_twoAN:         **Keeps track of the count for the second register.
    JSR         Pull_Bits_first_half
    ADDI        #1,D5
    BRA         SecondHalf_LoopAN
    
    

********************************************************************************************************************************
*********************************************Functions for printing Dn registers in a pre-decremented list**********************
********************************************************************************************************************************
Print_DnList_src_Predec:
    JSR         Load_Word2
    MOVE.L      #0,D5       **Counter for registers in list
    MOVE.L      #12,D6
DnSrcLoopPD:                **DnSrcLoopPD will find the register # for the first Dn register in a pre-decremented list.
    LSL.L       D6,D3
    LSR.L       #8,D3
    LSR.L       #8,D3
    LSR.L       #8,D3
    LSR.L       #3,D3
    CMP.L       #1,D3
    BLT         Add_to_Count_srcPD
    JSR         PrintDn_usingD5                   
    LEA         Text_Dash,A1  
    JSR         PrintTextInA1
    MOVE.L      #0,D5
    MOVE.L      #0,D6
    MOVE.L      #7,D6 
    JSR         Load_Word2
SecondHalf_LoopPD:          **SecondHalf_LoopPD will find the register # for the second Dn register in a pre-decremented list.
    LSL.B       D5,D1
    CMP.L       #0,D1
    BEQ         SUBoneDn
    CMP.L       #7,D5
    BEQ         PrintDn_usingD5
    BRA         Add_to_Count_twoPD 
Add_to_Count_srcPD:         **Adds to the count of bits for the first Dn register.
    JSR         Load_Word2     
    ADDI        #1,D5
    ADDI    	      #1,D6             
    BRA         DnSrcLoopPD
Add_to_Count_twoPD:         **Adds to the count of bits for the second Dn register.
    JSR         Pull_Bits_first_half
    ADDI        #1,D5
    BRA         SecondHalf_LoopPD
SUBoneDn:                   **Subtracks one to get the correct register # before printing.
    SUBI        #1,D5
    BRA         PrintDn_usingD5


********************************************************************************************************************************
*****************************************Functions for printing a list of An registers in pre-decremented list******************
********************************************************************************************************************************
Print_AnList_src_Predec:
    JSR         Load_Word2
    MOVE.L      #0,D5       **Counter for registers in list
    MOVE.L      #7,D6       
    MOVE.L      #31,D7
AnSrcLoopPD:                **AnSrcLoopPD will find the register number for the first An in a pre-decremented list.
    LSR.L       D6,D2
    LSL.L       D7,D2
    LSR.L       D7,D2
    CMP.L       #1,D2
    BLT         Add_to_Count_srcANPD
    JSR         PrintAn_usingD5                   
    LEA         Text_Dash,A1  
    JSR         PrintTextInA1
    MOVE.L      #0,D5
    MOVE.L      #1,D6
    MOVE.L      #24,D7 
    JSR         Load_Word2
SecondHalf_LoopANPD:        **SecondHalf_LoopANPD will find the register number for the second An in a pre-decremented list.
    LSL.L       D7,D3
    LSR.L       D7,D3
    LSL.B       D6,D3
    CMP.L       #$00,D3
    BEQ         PrintAn_usingD5
    CMP.L       #7,D5
    BEQ         PrintAn_usingD5
    BRA         Add_to_Count_twoANPD  
Add_to_Count_srcANPD:                   **Keeps track of count of bits for first register number.
    JSR         Pull_Bits_second_half     
    ADDI        #1,D5
    SUBI    	 #1,D6             
    BRA         AnSrcLoopPD
Add_to_Count_twoANPD:                   **Keeps track of count of bits for second register number.
    JSR         Load_Word2
    ADDI        #1,D5
    ADDI        #1,D6
    BRA         SecondHalf_LoopANPD
SUBone:                                 **Subtracks one to get to correct register number before printing.
    SUBI        #1,D5
    BRA         PrintAn_usingD5
    
    
********************************************************************************************************************************
************************************Helper Printer Functions for printing either the D or A, and then the register number. ***** 
********************************************************************************************************************************
PrintDn_usingD5:
    LEA         Text_D,A1
    JSR         PrintTextInA1
    MOVE.L      #0,D1
    MOVE.B      D5,D1
    JSR         PrintOneD1InHex
    RTS

PrintAn_usingD5:
    LEA		 Text_A,A1
    JSR		 PrintTextInA1
    MOVE.L      #0,D1
    MOVE.B      D5,D1
    JSR         PrintOneD1InHex
    RTS


*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
