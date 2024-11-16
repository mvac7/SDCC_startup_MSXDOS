;--- crt0.asm for MSX-DOS - by Konamiman (11/2004)
;    Update to SDCC (4.1.12) Z80 calling conventions (11/2024)
;    Advanced version: allows "char main(char argc, char** argv)",
;    - the returned value will be passed to _TERM on DOS 2,
;	   Error code for termination (0=No error)
;      
;    - argv is always 0x100 (the startup code memory is recycled).
;
;    Compile programs with --code-loc 0x180 --data-loc X
;    X=0  -> global vars will be placed immediately after code
;    X!=0 -> global vars will be placed at address X
;            (make sure that X>0x100+code size)

	.module crt0_MSXDOSadv
	.globl	_main

    .globl  l__INITIALIZER
    .globl  s__INITIALIZED
    .globl  s__INITIALIZER

	.area _HEADER (ABS)
    .org    0x0100  ;MSX-DOS .COM programs start address
init:
    ;--- Step 1: Initialize globals
    call    gsinit

    ;--- Step 2: Build the parameter pointers table on 0x100,
    ;    and terminate each parameter with 0.
    ;    MSX-DOS places the command line length at 0x80 (one byte),
    ;    and the command line itself at 0x81 (up to 127 characters).

    ;* Check if there are any parameters at all
    ld      A,(#0x80)
    or      A
	ld      E,A
    jr      Z,cont     ;if there are no parameters goto cont
        
    ;* Terminate command line with 0
    ;  (DOS 2 does this automatically but DOS 1 does not)
    ld      HL,#0x81
    ld      BC,(#0x80)   ;Parameter string length
    ld      B,#0
    add     HL,BC
    ld      (HL),#0
        
    ;* Copy the command line processing code to 0xC000 and
    ;  execute it from there, this way the memory of the original code
    ;  can be recycled for the parameter pointers table.
    ;  (The space from 0x100 up to "cont" can be used,
    ;   this is room for about 40 parameters.
    ;   No real world application will handle so many parameters.)        
    ld      HL,#parloop
    ld      DE,#0xC000
    ld      BC,#parloopend-#parloop
    ldir
        
    ;* Initialize registers and jump to the loop routine
        
    ld      HL,#0x81        ;Command line pointer
    ld      E,#0            ;Number of params found
    ld      IX,#0x100       ;Params table pointer
        
    ld      BC,#cont        ;To continue execution at "cont"
    push    BC              ;when the routine RETs
    jp      0xC000
        
    ;>>> Command line processing routine begin
        
    ;* Loop over the command line: skip spaces
        
parloop: 
    ld      A,(HL)
    or      A           ;Command line end found?
    ret     Z

    cp      #32
    jr      NZ,parfnd
    inc     HL
    jr      parloop

    ;* Parameter found: add its address to params table...

parfnd: 
    ld      (IX),L
    ld      1(IX),H
    inc     IX
    inc     IX
    inc     E
        
    ld      A,E         ;protection against too many parameters
    cp      #40
    ret     NC
        
    ;* ...and skip chars until finding a space or command line end
        
parloop2:
    ld      A,(HL)
    or      A           ;Command line end found?
    ret     Z
        
    cp      #32
    jr      NZ,nospc    ;If space found, set it to 0
                        ;(string terminator)...
    ld      (HL),#0
    inc     HL
    jr      parloop     ;...and return to space skipping loop

nospc:
    inc     HL
    jr      parloop2
parloopend:
        
    ;>>> Command line processing routine end
        
    ;* Command line processing done. Here, E=number of parameters.

cont:   
    ;--- Step 3: Call the "main" function
;	push    DE
	ld      BC,#_HEAP_start
	ld      (_heap_top),BC
;	pop     DE

	ld      A,E			;char   argc
	ld      DE,#0x100   ;char** argv
	call    _main

    ;--- Step 4: Program termination.
    ;    Termination code for DOS 2 was returned on A                
    ld      C,#0x62   ;DOS 2 function for program termination (_TERM)
    ld      B,A       ;Error code for termination (0=No error)
    call    5         ;On DOS 2 this terminates; on DOS 1 this returns...
    ld      C,#0x0
    jp      5      ;...and then this one terminates
                   ;(DOS 1 function for program termination).

    ;--- Program code and data (global vars) start here

	;* Place data after program code, and data init code after data

	.area	_CODE
	.area	_DATA
_heap_top::
	.dw 0

    .area   _GSINIT
gsinit::
    ld      BC,#l__INITIALIZER
    ld      A,B
    or      A,C
    jp      Z,gsinext
    ld      DE,#s__INITIALIZED
    ld      HL,#s__INITIALIZER
    ldir
gsinext:
    .area   _GSFINAL
    ret


	;* These don't seem to be necessary... (?)

    ;.area  _OVERLAY
    ;.area	_HOME
    ;.area  _BSS
    .area	_HEAP

_HEAP_start::
