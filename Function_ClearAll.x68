ClearAll:   *clears data registers 0-7, Address registers 0-6 and all variables
    
    jsr     ClearDataRegisters
    
    jsr     ClearAddressRegisters
    
    jsr     ClearAllVariables
    
    rts

ClearDataRegisters:

    clr.l   D0
    clr.l   D1
    clr.l   D2
    clr.l   D3
    clr.l   D4
    clr.l   D5
    clr.l   D6
    clr.l   D7

    rts
    
ClearAddressRegisters:

    MOVE.L  D0,A0
    MOVE.L  D0,A1
    MOVE.L  D0,A2
    MOVE.L  D0,A3
    MOVE.L  D0,A4
    MOVE.L  D0,A5
    MOVE.L  D0,A6

    rts
    
ClearAllVariables:

*Word1 variables (charaterstics)

    MOVE.L  D0,FirstHex 
*Variable for printing 
    MOVE.L  D0,PrintVariable
   
*words for input, 5 total words
    MOVE.L  D0,Word1  
    MOVE.L  D0,Word2      
    MOVE.L  D0,Word3     
    MOVE.L  D0,Word4        
    MOVE.L  D0,Word5    

*Xn and Mode for both source and destination
    MOVE.L  D0,Mode_dest  
    MOVE.L  D0,Reg_dest    
    MOVE.L  D0,Mode_src    
    MOVE.L  D0,Reg_src      
*An and Dn 
    MOVE.L  D0,Dn_reg         
    MOVE.L  D0,An_reg   

*Suffix 
    MOVE.L  D0,S_light     
    MOVE.L  D0,S_mid        
    MOVE.L  D0,S_dark      
*Directions 
    MOVE.L  D0,D_pink     
    MOVE.L  D0,D_org_grn  
  
*Miscellaneous
    MOVE.L  D0,Displacement 
    MOVE.L  D0,Data       
    MOVE.L  D0,Condition        
    MOVE.L  D0,Rotation
    MOVE.L  D0,M_blue       
    MOVE.L  D0,Data 
    
    rts













*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
