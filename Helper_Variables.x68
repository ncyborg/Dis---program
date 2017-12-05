
* Put variables and constants here

StartIntro       DC.B    'Please input your start address: ',0
EndIntro         DC.B    'Please input your end address: ',0
InvalidInputMessage DC.B    'INVALID INPUT PLEASE TRY AGAIN. ONLY ACCEPTS HEX NUMBERS',0
Blank            DC.B    '',0

*Branch variable

PrintVariable    DC.L   $00000000

*Start, end variables
BeginStartAddress   DC.L   $00000000    *Used to hold the address before the incrementations by fetchmoreoperands
StartAddress     DC.L   $00000000
EndAddress       DC.L   $00000000
PC          DC.L        $00000000   *Used to represent the pc of the next instruction

*Word1 variables (charaterstics)

FirstHex     DC.L     $00000000

*words for input, 5 total words
Word1        DC.L     $00000000 * first word determines how much more word data to input
Word2        DC.L     $00000000
Word3        DC.L     $00000000
Word4        DC.L     $00000000
Word5        DC.L     $00000000 

*Xn and Mode for both source and destination
Mode_dest    DC.L     $00000000 * stores mode for destination 
Reg_dest     DC.L     $00000000 * stores register for destination 
Mode_src     DC.L     $00000000 * stores mode for source 
Reg_src      DC.L     $00000000 * stores register for source

*An and Dn 
Dn_reg       DC.L     $00000000 * stores data registers 0-7      
An_reg       DC.L     $00000000 * stores address registers 0-7 

*Suffix                         *  B    W    L
S_light      DC.L     $00000000 * 00   01   10
S_mid        DC.L     $00000000 * --    0    1
S_dark       DC.L     $00000000 * 01   11   10

*Directions 
D_pink       DC.L     $00000000 * 1 reg to mem ,0 mem to reg
D_org_grn    DC.L     $00000000 * ORANGE: 0 Dn + <ea> to Dn, 1 <ea> + Dn to <ea> GREEN: 0 right, 1 left

*Miscellaneous
Condition    DC.L     $00000000 * condition is 4 bits long
Displacement DC.L     $00000000 * displacement can be a byte long (8 bits)
Data         DC.L     $00000000 * data is byte long (8 bits)
M_blue       DC.L     $00000000 * used for shifting operations
Rotation     DC.L     $00000000 * used for rotation (count register) holds numbers 0-7, 0 means rotate 8

*Instructions Texts

Text_ADDI   DC.B    'ADDI',0    *ADDI instruction text
Text_SUBI   DC.B    'SUBI',0    *SUBI instruction text
Text_MOVE   DC.B    'MOVE',0    *MOVE instruction text
Text_MOVEA  DC.B    'MOVEA',0   *MOVEA instruction text
Text_MOVEM  DC.B    'MOVEM',0   *MOVEM instruction text
Text_LEA    DC.B    'LEA',0     *LEA instruction text
Text_JSR    DC.B    'JSR',0     *JSR instruction text
Text_RTS    DC.B    'rts',0     *rts instruction text
Text_NOP    DC.B    'NOP',0     *NOP instruction text
Text_ADDQ   DC.B    'ADDQ',0    *ADDQ instruction text
Text_B      DC.B    'B',0       *Begining Branch instruction text
Text_BRA    DC.B    'BRA',0     *BRA branch always instruction text
Text_MOVEQ  DC.B    'MOVEQ',0   *Move quick instruction text
Text_OR     DC.B    'OR',0      *OR instruction text
Text_DIVU   DC.B    'DIVU',0    *Unsigned Divide instruction text
Text_SUB    DC.B    'SUB',0     *SUB instruction text
Text_MULS   DC.B    'MULS',0    *Multiply signed instruction text
Text_AND    DC.B    'AND',0     *AND instruction text
Text_ADD    DC.B    'ADD',0     *ADD instruction text
Text_ADDA   DC.B    'ADDA',0    *ADD Address instruction text
Text_LS     DC.B    'LS',0      *Beginning Logical Shift instruction text
Text_AS     DC.B    'AS',0      *Beginning Arithmetic Shift instruction text
Text_RO     DC.B    'RO',0      *Beginning Roll operation instruction text
Text_DATA   DC.B    'DATA',0    *For case where data is unrecognizable

*Suffix variables
Text_BYTE   DC.B    '.B',0      *Byte Suffix instruction text
Text_WORD   DC.B    '.W',0      *Word Suffix instruction text
Text_LONG   DC.B    '.L',0      *Long Suffix instruction text

*Branch CC variables
*These variables will go with the B instruction text.
Text_CC     DC.B    'CC',0      *Branch CC Carry Clear instruction text
Text_LT     DC.B    'LT',0      *Branch CC Less Than instruction text
Text_GE     DC.B    'GE',0      *Branch CC Greater Than or Equals

*Shift direction variables
*These variables will go along with the LS, AS, and RO instruction text.
Text_Left   DC.B    'L',0       *Shift Left instruction text
Text_Right  DC.B    'R',0       *Shift Right instruction text

*Data and Address register variables
*These will be used in combo with MISC variables.
*NOTE: Numbers that come after D or A will be stored in Reg_Src or Reg_Dest.
Text_D      DC.B    'D',0       *Beginning Data register variable text instruction
Text_A      DC.B    'A',0       *Beginning Address register variable text instruction

*MISC variables
Text_OpenPar    DC.B    '(',0   *Open parenthesis text instruction
Text_ClosePar   DC.B    ')',0   *Close parenthesis text instruction
Text_Comma      DC.B    ',',0   *Comma text instruction
Text_Hashtag    DC.B    '#',0   *Hashtag text instruction
Text_$          DC.B    '$',0   *Hex symbol text instruction
Text_Dash       DC.B    '-',0   *Dash symbol text instruction
Text_Plus       DC.B    '+',0   *Plus symbol text instruction
Text_Percent    DC.B    '%',0   *Percent symbol text instruction
Text_ERROR      DC.B    'ERROR OP CODE NOT FOUND',0 *Error message
Text_Space      DC.B    '   ',0   *Tabs worth of spaces
Text_Slash      DC.B    '/',0     *Slash text instruction

*Print Buffer Variables
Text_Buffer     DC.B    'Press ENTER for more, Press X to exit...',0 *Buffer message prompting user how to display the next screen of data.
Buffer_Count    DC.L    $00000000     *Count for printer buffer.

*Intro banner
Text_Intro1     DC.B '------------------------------------------------------------------------------',0
Text_Intro2     DC.B '  _   _    _    ____  ____       _    ____ ____  _____ __  __ ____  _  __   __',0
Text_Intro3     DC.B ' | | | |  / \  |  _ \|  _ \     / \  / ___/ ___|| ____|  \/  | __ )| | \ \ / /',0
Text_Intro4     DC.B ' | |_| | / _ \ | |_) | | | |   / _ \ \___ \___ \|  _| | |\/| |  _ \| |  \ V / ',0
Text_Intro5     DC.B ' |  _  |/ ___ \|  _ <| |_| |  / ___ \ ___) ___) | |___| |  | | |_) | |___| |  ',0
Text_Intro6     DC.B ' |_| |_/_/   \_|_| \_|____/  /_/   \_|____|____/|_____|_|  |_|____/|_____|_|  ',0
Text_Intro7     DC.B '                                                                              ',0                                                                              
Text_Intro8     DC.B '         type in your 32 bit (0-9, A-F, a-F) starting and ending address      ',0
Text_Intro9     DC.B '                      or press X at any time to exit                          ',0
Text_Intro10    DC.B '------------------------------------------------------------------------------',0

*Outro Banner
Text_Outro1     DC.B ' _______ ___  ___ _______    ___ ',0 
Text_Outro2     DC.B '|   _  "|"  \/"  /"     "|  |"  |',0 
Text_Outro3     DC.B '(. |_)  :\   \  (: ______)  ||  |',0 
Text_Outro4     DC.B '|:     \/ \\  \/ \/    |    |:  |',0 
Text_Outro5     DC.B '(|  _  \\ /   /  // ___)_  _|  / ',0 
Text_Outro6     DC.B '|: |_)  :/   /  (:      "|/ |_/ )',0 
Text_Outro7     DC.B '(_______|___/    \_______(_____/ ',0 









*~Font name~Courier New~
*~Font size~10~
*~Tab type~1~
*~Tab size~4~
