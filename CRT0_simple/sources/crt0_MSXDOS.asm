;--- crt0.asm for MSX-DOS - by Konamiman & Avelino (11/2004)
;    add exit to DOS (11/2024)
;    Simple version: allows "int main(void)"
;    the returned value will be passed to _TERM on DOS 2,
;	   Error code for termination (0=No error)
;
;    Compile programs with --code-loc 0x108 --data-loc X
;    X=0  -> global vars will be placed immediately after code
;    X!=0 -> global vars will be placed at address X
;            (make sure that X>0x100+code size)


	.module crt0_MSXDOS
	.globl	_main

    .globl  l__INITIALIZER
    .globl  s__INITIALIZED
    .globl  s__INITIALIZER

	.area _HEADER (ABS)
	.org    0x0100  ;MSX-DOS .COM programs start address
init:
    ;--- Initialize globals and jump to "main"   
    call gsinit
	jp   __pre_main
	
	
	;--- Program code and data (global vars) start here

	;* Place data after program code, and data init code after data

	.area	_CODE

__pre_main:
	;push de
	ld de,#_HEAP_start
	ld (_heap_top),de
	;pop de
	;jp _main

	call    _main

    ;--- Program termination.
    ;    Termination code for DOS 2 was returned on A                
    ld      C,#0x62   ;DOS 2 function for program termination (_TERM)
    ld      B,A       ;Error code for termination (0=No error)
    call    5         ;On DOS 2 this terminates; on DOS 1 this returns...
    ld      C,#0x0
    jp      5      ;...and then this one terminates
                   ;(DOS 1 function for program termination).

    ;--- Program code and data (global vars) start here

	.area	_DATA
_heap_top::
	.dw 0

    .area   _GSINIT
    ; Explicitly initialized global variables.
gsinit::
    ld      BC,#l__INITIALIZER
    ld      A,B
    or      A,C
    jp      Z,gsinext            ;There are no global variables
    ld      DE,#s__INITIALIZED
    ld      HL,#s__INITIALIZER
    ldir                         ;copy values
gsinext:
    .area   _GSFINAL
    ret


	;* These don't seem to be necessary... (?)

    ;.area  _OVERLAY
    ;.area	_HOME
    ;.area  _BSS
    .area	_HEAP

_HEAP_start::
