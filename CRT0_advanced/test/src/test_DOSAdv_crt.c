/* =============================================================================
   HelloWorld.c
   v2.0 (5/02/2018)
   Description:
    Test SDCC MSXDOS CRT
============================================================================= */

#include "../include/newTypes.h"
#include "../include/msxSystemVariables.h"
#include "../include/msxBIOS.h"
#include "../include/msxDOS.h"


// MSX-DOS Calls ---------------------------------------------------------------





char Gvar_Test0 = 128;

char PrintNumber_Digits;

char RNDSEED;

char vers_major;
char vers_minor;


// Function Declarations -------------------------------------------------------
void System(char code);
void ReadDOSversion(void);
char ReadinBIOS(uint addr);
char INKEY(void);
char PEEK(uint address);
uint WPEEK(uint address);

void PRINT(char* text);
void PrintNumber(unsigned int value);
void bchput(char value);

char Random(void);


// -----------------------------------------------------------------------------

      

char main(char argc, char** argv) 
{
  char i;
  char A=0;
  
  ReadDOSversion();

  PRINT("Test crt0 MSXDOS advanced");
  
  if (argc!=0)
  {
	PRINT("\n\rThere are ");
	PrintNumber(argc);
    PRINT(" parameters:");
	
    for(i=0;i<argc;i++){
      PRINT("\n\r");
	  PrintNumber(i);
      PRINT("> ");
      PRINT(argv[i]);
    }  
  }else{
    PRINT("\n\rThere are no parameters.");
  }
  
  PRINT("\n\rTest Global variables:");
  if(Gvar_Test0==128) PRINT("Ok");
  else PRINT("ERROR");
  
   if(vers_major>1)
  {
     //generate a random DOS2 Error code
     A=Random() & 0b01111111; //(0-127)
	 A+=127;
  
     PRINT("\n\rReturn DOS2 error code:");
     PrintNumber(A);
  }
  
  return A; //return to DOS 
}



/* =============================================================================
   call system functions 
   see MSX Assembly Page > MSX-DOS 2 function calls
   http://map.grauw.nl/resources/dos2_functioncalls.php
============================================================================= */
void System(char code) __naked
{
code;	//A
__asm
  ld   C,A
  jp   BDOS
__endasm; 
}




/* =============================================================================
Read one byte in BIOS. For reading system constants in MSXDOS environment.
============================================================================= */
char ReadinBIOS(uint addr) __naked
{
addr;
__asm
  push IX

  ld   A,(#EXPTBL)
  call BIOS_RDSLT
  ei

  pop  IX
  ret
__endasm;
}



void ReadDOSversion(void) __naked
{
__asm
  ld   C,#DOS2_DOSVER   ;Get MSX-DOS version number
  call BDOS
  ld   A,B  
  cp   #2
  jr   C,DOSvers1
  
  ld   (#_vers_major),A
  ld   A,C

setMinorVers:
  ld   (#_vers_minor),A
  ret
  
DOSvers1:
  ld   A,#1
  ld   (#_vers_major),A
  xor  A
  jr   setMinorVers
__endasm;	
}



char INKEY(void) __naked
{
__asm   
  push IX
  
  ld   IX,#BIOS_CHGET
  ld   IY,(EXPTBL-1)
  call BIOS_CALSLT
  ei
  
  pop  IX
  ret
__endasm;
}



/* =============================================================================
   PEEK
 
   Function : Read a 8 bit value from the RAM.
   Input    : [unsigned int] RAM address
   Output   : [char] value
============================================================================= */
char PEEK(unsigned int address) __naked
{
address;	//HL
__asm

  ld   A,(HL)

  ret
__endasm;
}



uint WPEEK(uint address) __naked
{
address;	//HL
__asm
  
  ld   L,(HL)
  inc  HL
  ld   H,(HL)
  
  ret
__endasm;
}



void PRINT(char* text)
{
  while(*(text)) bchput(*(text++));
}




/* =============================================================================
   Displays one character (BIOS)
   value (char) - char value
============================================================================= */
void bchput(char value) __naked
{
value;	//A
__asm
  push IX
  ld   IX,#0
  add  IX,SP
   
  ld   IX,#BIOS_CHPUT
  ld   IY,(EXPTBL-1)
  call BIOS_CALSLT
  ei
  
  pop  IX
  ret
__endasm;
}



/* =============================================================================
 PrintNumber

 Description: 
           Displays an unsigned integer at the current cursor position.
			
 Input:    (unsigned int) or (char) numeric value          
 Output:   -
============================================================================= */
void PrintNumber(unsigned int value) __naked
{
	value;
//  PrintFNumber(value,0,5); 
__asm
  push IX

; HL = value
  ld   D,#0
  ld   E,#5 
  call PRNUM$
  
  ei
  pop  IX
  ret



; ------------------------------------------------ 
; 16-bit Integer to ASCII (decimal)
; Based on num2Dec16 by baze
; https://baze.sk/3sc/misc/z80bits.html#5.1 
;  HL = value
;  D  = zero/empty Char (0,32,48)
;  E  = length
PRNUM$:

  ld   A,#5
  ld   (_PrintNumber_Digits),A
  
  ld   IX,#BIOS_CHPUT
  ld   IY,(#EXPTBL-1)
  
;for a future version with negative numbers  
;if (HL<0) Print "-" 
;   ld   A,#45
;   call $Num4

  	
  ld   BC,#-10000
  call $Num1
  ld   BC,#-1000
  call $Num1
  ld   BC,#-100
  call $Num1
  ld   C,#-10
  call $Num1

;Last figure
  ld   C,B
  ld   D,#48          ;"0"

;  call $Num1
;  ei
;  ret   ; END
    
$Num1:	
  ld   A,#47     ;"0" ASCII code - 1
   
$Num2:
  inc  A
  add  HL,BC
  jr   C,$Num2
	
  sbc  HL,BC
	
  cp   #48       ;"0" ASCII code    
  jr   NZ,$Num3  ;if A!=48 then goto $Num3
	
  ld   A,D  ;(DE)
  jr   $Num4


$Num3:
  ;change space for 0 zero ASCII code
  ld   D,#48
	
$Num4:
  push AF
  ld   A,(_PrintNumber_Digits)
  dec  A
  ld   (_PrintNumber_Digits),A
  cp   E  
  jr  NC,$next5

  pop  AF
  or   A
  ret  Z  ;only print A>0
  
  call BIOS_CALSLT
;  ei
  ret

$next5:
  pop  AF
  ret  
; ------------------------------------------------ 
  
__endasm;
}



char Random(void) __naked
{
__asm

	ld   A,(_RNDSEED)	;get the Seed
				
	ld   B,A	
	ld   A,R  
	add  A,B		;add the value of R to the Seed

	ld   B,A
	ld   A,R
	rlca			;rotation to the left
	sub	 A,B		;and subtracts it from the value 

	ld   (_RNDSEED),A	;save as Seed 

	ret
__endasm;
} 