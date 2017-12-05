
ReadTo_FirstHex             * reads the first 4 bits of Word1 and stores these bits into FirstHex
       
    MOVE.L  Word1,D4        *take word out from the variable store in register
    MOVE.L  #00000000,D5    *clears D5
    
    ROL.W   #4,D4           *moves first 3 bits of word into the right most spot   
    MOVE.B  D4,D5           *moves first 16 bits into D5
    
    LSL.B   #4,D5           *first 16 bits in D5 is ???? ---- (- is the first 4 bits)
    LSR.B   #4,D5           *we have to get rid of the question mark so chop it off by lsl and lsr back by 4 this adds 0's
                            *D5 is now guaranteed to be just ur 4 bits at the end 0000 ----
    
    MOVE.L  D5,FirstHex     *finally move to FirstHex
    
    MOVE.L  D4,Word1        *moves the result rotation to Word1

    rts

ReadTo_Mode_dest:           * reads the first 3 bits of Word1 and stores these bits into Mode_dest 
    
    MOVE.L  Word1,D4        *take word out from the variable store in register
    MOVE.L  #00000000,D5    *clears D5
    
    ROL.W   #3,D4           *moves first 3 bits of word into the right most spot   
    MOVE.B  D4,D5           *moves first 8 bits into D5
    
    LSL.B   #5,D5           *first 8 bits in D5 is ???? ?--- (- is the first 3 bits)
    LSR.B   #5,D5           *we have to get rid of the question mark so chop it off by lsl and lsr back by 5 this adds 0's
                            *D5 is now guaranteed to be just ur 3 bits at the end 0000 0--- 
    
    MOVE.L  D5,Mode_dest    *finally move to Mode_dest
    
    MOVE.L  D4,Word1        *moves the result rotation to Word1
    
    rts
    
ReadTo_Reg_dest:            * reads the first 3 bits of Word1 and stores these bits into Reg_dest  
    
    MOVE.L  Word1,D4        *take word out from the variable store in register
    MOVE.L  #00000000,D5    *clears D5
    
    ROL.W   #3,D4           *moves first 3 bits of word into the right most spot   
    MOVE.B  D4,D5           *moves first 8 bits into D5
    
    LSL.B   #5,D5           *first 8 bits in D5 is ???? ?--- (- is the first 3 bits)
    LSR.B   #5,D5           *we have to get rid of the question mark so chop it off by lsl and lsr back by 5 this adds 0's
                            *D5 is now guaranteed to be just ur 3 bits at the end 0000 0---  
    
    MOVE.L  D5,Reg_dest     *finally move to Reg_dest
    
    MOVE.L  D4,Word1        *moves the result rotation to Word1
    
    rts

ReadTo_Mode_src:            * reads the first 3 bits of Word1 and stores these bits into Mode_src 

    MOVE.L  Word1,D4        *take word out from the variable store in register
    MOVE.L  #00000000,D5    *clears D5
    
    ROL.W   #3,D4           *moves first 3 bits of word into the right most spot   
    MOVE.B  D4,D5           *moves first 8 bits into D5
    
    LSL.B   #5,D5           *first 8 bits in D5 is ???? ?--- (- is the first 3 bits)
    LSR.B   #5,D5           *we have to get rid of the question mark so chop it off by lsl and lsr back by 5 this adds 0's
                            *D5 is now guaranteed to be just ur 3 bits at the end 0000 0--- 
    
    MOVE.L  D5,Mode_src     *finally move to Mode_src

    MOVE.L  D4,Word1        *moves the result rotation to Word1

    rts

ReadTo_Reg_src:             * reads the first 3 bits of Word1 and stores these bits into Reg_src 

    MOVE.L  Word1,D4        *take word out from the variable store in register
    MOVE.L  #00000000,D5    *clears D5
    
    ROL.W   #3,D4           *moves first 3 bits of word into the right most spot   
    MOVE.B  D4,D5           *moves first 8 bits into D5
    
    LSL.B   #5,D5           *first 8 bits in D5 is ???? ?--- (- is the first 3 bits)
    LSR.B   #5,D5           *we have to get rid of the question mark so chop it off by lsl and lsr back by 5 this adds 0's
                            *D5 is now guaranteed to be just ur 3 bits at the end 0000 0--- 
    
    MOVE.L  D5,Reg_src      *finally move to Reg_src

    MOVE.L  D4,Word1        *moves the result rotation to Word1

    rts
    
ReadTo_Dn_reg:              *reads the first 3 bits of Word1 and stores these bits into Dn_reg 
    
    MOVE.L  Word1,D4        *take word out from the variable store in register
    MOVE.L  #00000000,D5    *clears D5
    
    ROL.W   #3,D4           *moves first 3 bits of word into the right most spot   
    MOVE.B  D4,D5           *moves first 8 bits into D5
    
    LSL.B   #5,D5           *first 8 bits in D5 is ???? ?--- (- is the first 3 bits)
    LSR.B   #5,D5           *we have to get rid of the question mark so chop it off by lsl and lsr back by 5 this adds 0's
                            *D5 is now guaranteed to be just ur 3 bits at the end 0000 0--- 
    
    MOVE.L  D5,Dn_reg       *finally move to Dn_reg

    MOVE.L  D4,Word1        *moves the result rotation to Word1
    
    rts
    
ReadTo_An_reg:              *reads the first 3 bits of Word1 and stores these bits into An_reg 

    MOVE.L  Word1,D4        *take word out from the variable store in register
    MOVE.L  #00000000,D5    *clears D5
    
    ROL.W   #3,D4           *moves first 3 bits of word into the right most spot   
    MOVE.B  D4,D5           *moves first 8 bits into D5
    
    LSL.B   #5,D5           *first 8 bits in D5 is ???? ?--- (- is the first 3 bits)
    LSR.B   #5,D5           *we have to get rid of the question mark so chop it off by lsl and lsr back by 5 this adds 0's
                            *D5 is now guaranteed to be just ur 3 bits at the end 0000 0---  
  
    MOVE.L  D5,An_reg       *finally move to An_reg
    
    MOVE.L  D4,Word1        *moves the result rotation to Word1

    rts
    
ReadTo_S_light:             *reads the first 2 bits of Word1 and stores these bits into S_light    
    
    MOVE.L  Word1,D4        *take word out from the variable store in register
    MOVE.L  #00000000,D5    *clears D5
    
    ROL.W   #2,D4           *moves first 2 bits into the right most spot   
    MOVE.B  D4,D5           *moves first 8 bits into D5
    
    LSL.B   #6,D5           *first 8 its in D5 is ???? ??-- (- is the first 2 bits)
    LSR.B   #6,D5           *we have to get rid of the question mark so chop it off by lsl and lsr back by 6 this adds 0's
                            *D5 is now guaranteed to be just ur 2 bits at the end 0000 00--
                            
    MOVE.L  D5,S_light      *finally move to S_light
    
    MOVE.L  D4,Word1        *moves the result rotation to Word1
    
    rts

ReadTo_S_mid:               *reads the first 1 bit of Word1 and stores these bits into S_mid 

    MOVE.L  Word1,D4        *take word out from the variable store in register
    MOVE.L  #00000000,D5    *clears D5
    
    ROL.W   #1,D4           *moves first 1 bits into the right most spot   
    MOVE.B  D4,D5           *moves first 8 bits into D5
    
    LSL.B   #7,D5           *first 8 bits in D5 is ???????- (- is the first 1 bits)
    LSR.B   #7,D5           *we have to get rid of the question mark so chop it off by lsl and lsr back by 7 this adds 0's
                            *D5 is now guaranteed to be just ur 2 bits at the end 0000000-
    
    MOVE.L  D5,S_mid        *finally move to S_mid
    
    MOVE.L  D4,Word1        *moves the result rotation to Word1

    rts
      
ReadTo_S_dark:              *reads the first 2 bits of Word1 and stores these bits into S_dark 

    MOVE.L  Word1,D4        *take word out from the variable store in register
    MOVE.L  #00000000,D5    *clears D5
    
    ROL.W   #2,D4           *moves first 2 bits into the right most spot   
    MOVE.B  D4,D5           *moves first 8 bits into D5
    
    LSL.B   #6,D5           *first 8 bits in D5 is ??????-- (- is the first 2 bits)
    LSR.B   #6,D5           *we have to get rid of the question mark so chop it off by lsl and lsr back by 6 this adds 0's
                            *D5 is now guaranteed to be just ur 2 bits at the end 000000--
    
    MOVE.L  D5,S_dark      *finally move to S_dark
    
    MOVE.L  D4,Word1        *moves the result rotation to Word1

    rts
    
ReadTo_D_pink               *reads the first 1 bit of Word1 and stores these bits into D_pink 

    MOVE.L  Word1,D4        *take word out from the variable store in register
    MOVE.L  #00000000,D5    *clears D5
    
    ROL.W   #1,D4           *moves first 1 bits into the right most spot   
    MOVE.B  D4,D5           *moves first 8 bits into D5
    
    LSL.B   #7,D5           *first 8 bits in D5 is ???????- (- is the first 1 bits)
    LSR.B   #7,D5           *we have to get rid of the question mark so chop it off by lsl and lsr back by 7 this adds 0's
                            *D5 is now guaranteed to be just ur 2 bits at the end 0000000-
    
    MOVE.L  D5,D_pink       *finally move to D_pink
    
    MOVE.L  D4,Word1        *moves the result rotation to Word1

    rts

ReadTo_D_org_grn            *reads the first 1 bit of Word1 and stores these bits into D_org_grn 

    MOVE.L  Word1,D4        *take word out from the variable store in register
    MOVE.L  #00000000,D5    *clears D5
    
    ROL.W   #1,D4           *moves first 1 bits into the right most spot   
    MOVE.B  D4,D5           *moves first 8 bits into D5
    
    LSL.B   #7,D5           *first 8 bits in D5 is ???????- (- is the first 1 bits)
    LSR.B   #7,D5           *we have to get rid of the question mark so chop it off by lsl and lsr back by 7 this adds 0's
                            *D5 is now guaranteed to be just ur 2 bits at the end 0000000-
    
    MOVE.L  D5,D_org_grn    *finally move to D_org_grn
    
    MOVE.L  D4,Word1        *moves the result rotation to Word1

    rts
    
ReadTo_Condition    *Reads first 4 bits of Word1 and stores in Condition 

    MOVE.L  Word1,D4        *take word out from the variable store in register
    MOVE.L  #00000000,D5    *clears D5

    ROL.W   #4,D4           *moves first 1 bits into the right most spot   
    MOVE.B  D4,D5           *moves first 8 bits into D5

    LSL.B   #4,D5           *first 8 bits in D5 is ????---- (- is the first 4 bits)
    LSR.B   #4,D5           *we have to get rid of the question mark so chop it off by lsl and lsr back by 7 this adds 0's
                            *D5 is now guaranteed to be just ur 2 bits at the end 0000----

    MOVE.L  D5,Condition    *finally move to condition

    MOVE.L  D4,Word1         *moves the result rotation to Word1

    rts

ReadTo_Displacement *Reads first 8 bits of Word1 and stores in Displacement

    MOVE.L  Word1,D4        *take word out from the variable store in register
    MOVE.L  #00000000,D5    *clears D5

    ROL.W   #8,D4           *moves first 1 bits into the right most spot   
    MOVE.B  D4,D5           *moves first 8 bits into D5

    MOVE.L  D5,Displacement    *finally move to condition

    MOVE.L  D4,Word1        *moves the result rotation to Word1

    rts

ReadTo_Rotation:    *Reads first 3 bits to rotation

    MOVE.L  Word1,D4        *take word out from the variable store in register
    MOVE.L  #00000000,D5    *clears D5
    
    ROL.W   #3,D4           *moves first 3 bits of word into the right most spot   
    MOVE.B  D4,D5           *moves first 8 bits into D5
    
    LSL.B   #5,D5           *first 8 bits in D5 is ???? ?--- (- is the first 3 bits)
    LSR.B   #5,D5           *we have to get rid of the question mark so chop it off by lsl and lsr back by 5 this adds 0's
                            *D5 is now guaranteed to be just ur 3 bits at the end 0000 0---  
  
    MOVE.L  D5,Rotation     *finally move to Rotation
    
    MOVE.L  D4,Word1        *moves the result rotation to Word1

    rts
    
ReadTo_M_blue:    *Reads first 1 bit to M_blue
    
    MOVE.L  Word1,D4        *take word out from the variable store in register
    MOVE.L  #00000000,D5    *clears D5
    
    ROL.W   #1,D4           *moves first 1 bits into the right most spot   
    MOVE.B  D4,D5           *moves first 8 bits into D5
    
    LSL.B   #7,D5           *first 8 bits in D5 is ???????- (- is the first 1 bits)
    LSR.B   #7,D5           *we have to get rid of the question mark so chop it off by lsl and lsr back by 7 this adds 0's
                            *D5 is now guaranteed to be just ur 2 bits at the end 0000000-
    
    MOVE.L  D5,M_blue       *finally move to M_blue
    
    MOVE.L  D4,Word1        *moves the result rotation to Word1

    rts
    
ReadTo_Data_3bits:    *Reads 3 bits of data to Data_lightblue
    MOVE.L  Word1,D4      *take word out from the variable store in register
    MOVE.L  #00000000,D5  *Clear D5
    
    ROL.W   #3,D4         *Moves 3 bits of word into the right most spot
    MOVE.B  D4,D5           *moves first 8 bits into D5
    
    LSL.B   #5,D5           *first 8 bits in D5 is ???? ?--- (- is the first 3 bits)
    LSR.B   #5,D5           *we have to get rid of the question mark so chop it off by lsl and lsr back by 5 this adds 0's
                            *D5 is now guaranteed to be just ur 3 bits at the end 0000 0---  
  
    MOVE.L  D5,Data       *finally move to Rotation
    
    MOVE.L  D4,Word1        *moves the result rotation to Word1

    rts

ReadTo_Data_word:   *Read 8 bits into Data
    
    MOVE.L  Word1,D4        *Take word from the variable store in register
    MOVE.L  #00000000,D5    *clears D5
    
    ROL.W   #8,D4           *moves first 8 bits into the right most spot   
    MOVE.B  D4,D5           *moves first 8 bits into D5
    
    *Since a byte is in D5, don't need to shift
    *LSL.B   #7,D5           *first 8 bits in D5 is ???????- (- is the first 1 bits)
    *LSR.B   #7,D5           *we have to get rid of the question mark so chop it off by lsl and lsr back by 7 this adds 0's
                            *D5 is now guaranteed to be just ur 2 bits at the end 0000000-
    
    MOVE.L  D5,Data         *finally move to Data
    
    MOVE.L  D4,Word1        *moves the result rotation to Word1

    rts
    










*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
