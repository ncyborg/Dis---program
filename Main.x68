*-----------------------------------------------------------
* Title      :
* Written by :
* Date       :
* Description:
*-----------------------------------------------------------
    ORG    $1000
    
    
    *Helper variables and methods 
    INCLUDE "Helper_Variables.X68"
    INCLUDE "Helper_PrintFunctions.x68"
    INCLUDE "Helper_StorageFunctions.X68"
    
    *Main functions and their subroutines
    INCLUDE "Function_InputStartEnd.X68"
    INCLUDE "Function_ClearAll.X68"
    INCLUDE "Function_FetchInstruction.X68"
    INCLUDE "Function_DecodeInstruction.X68"
    INCLUDE "Function_FetchMoreOperands.X68"
    INCLUDE "Function_PrintInstruction.X68"
    INCLUDE "Function_MoveM_Printer_Helper.X68"
    
START:                  ; first instruction of program

    jsr     InputStartEnd

    StartLoop:

        jsr     ClearAll                *clears all registers and variables

        jsr     FetchInstruction        *Takes in an word hexadecimal number
        
        jsr     DecodeInstruction       *decodes and updates variables to determine what the instruction is 
       
        jsr     FetchMoreOperands       *Fetches more operands if needed and stores in Word2 to Word5
    
        jsr     PrintInstruction        *determines which function and prints what characteristics to use 
    
        jmp     StartLoop
    
    END:
    
    SIMHALT             ; halt simulator

    END    START        ; last line of source
    

*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
