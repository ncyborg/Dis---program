FetchInstruction:
      
   MOVEA.L   StartAddress,A2    *retrieve start address

   MOVEA.L   EndAddress,A3
   
   MOVE.L   A2,D4               *store the address 
   
   MOVE.L   A3,D5               *Stores the address for comparison
   
   cmp.L      D5,D4             *D4 greater than or equal to D5 than branch
   
   BGE      GoToStart               *If at the end branch to the start 

   *else read move to word one and increment
   
   MOVE.L   A2,BeginStartAddress         *Used to keep track of instruction location before incrementation 
  
   MOVE.W   (A2)+,D3
   
   MOVE.L   D3,Word1         *Stores it into word 1, Also inrements pointer by a word
   
   MOVE.L   A2,StartAddress *For start address
   
   MOVE.L   A2,PC           *For PC
   
   rts
   
GoToStart:

    MOVEA.L Start,A4
    MOVEA.L A4,A7
    
    jsr     ClearAll
    
    JMP START































*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
