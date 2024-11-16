# SDCC MSX-DOS startup files (CRT)


## Description

Project with the necessary elements to create MSX-DOS (v1 or v2) executables using the SDCC compiler.<br/>
It does not include functions for disk access. For it I have projected the development of a specific library.

Includes Startup files (CRT) programmed by [Konamiman](https://github.com/Konamiman/MSX/tree/master/SRC/SDCC/crt0-msxdos) and [Avelino Herrera](http://msx.avelinoherrera.com/index_en.html#sdccmsxdos). 
They have been adapted (Z80 calling conventions) and compiled for SDCC version 4.4.

This project includes the files:
- `crt0_MSXDOS.rel` **Simple CRT** For applications without parameters.
- `crt0_MSXDOS_advanced.rel` **Advanced CRT** For applications with parameter input.
- `MAKEFILE.BAT` Add this script to your project with the proposed structure and edit it to include the libraries you need.
- `msxDOS.h` Includes the definitions necessary to develop applications that need to access the BDOS. Includes DOS2 error [message codes](docs/MSXDOS2_Error_messages.md).

In the project you will also find example applications of both CRTs for testing and learning purposes.

CRT Features:
- Initialization of global variables.
- Passes command line parameters to main (only in advanced)
- Includes return to DOS.

<br/>

---

## History of versions

- (11/2024) Update to SDCC Z80 calling conventions (by mvac7)
- (11/2004) Initial version (by Konamiman and Avelino)


<br/>

---
 

## Requirements

- [Small Device C Compiler (SDCC) v4.4](http://sdcc.sourceforge.net/)
- [Hex2bin v2.5](http://hex2bin.sourceforge.net/)


<br/>

---
  


## How to use the CRTs

Depending on the CRT you use, you will have to add a specific value with the code location address and program the appropriate main.

<br/>

### Simple

The simple version of the CRT is designed for executables that do not require parameters. 
The main advantage over the advanced version is that 128 bytes of memory are gained.

To compile you must set the start address to 0x0108 using the code-loc parameter.


```
sdcc -mz80 --code-loc 0x0108 --data-loc 0 --use-stdout --no-std-crt0 crt0_MSXDOS.rel C_FILE_NAME.c
```

<br/>

While the main should be as follows:

```c
#include "../include/msxDOS.h"

char main(void) 
{
  PRINT("Test crt0 MSXDOS simple\n\r");
    
  return DOS2ERR_BADCM; //return to DOS with BADCM message error
}
```

<br/>

### Advanced

This CRT allows the input of parameters from the command line that will be provided in an array of strings to the __main__ of our main source code.

The __main__ has two input parameters:
- `argc` (char) Number of parameters
- `argv` (char**) Parameters

To compile you must set the start address to 0x0180 using the code-loc parameter.

```
sdcc -mz80 --code-loc 0x0180 --data-loc 0 --use-stdout --no-std-crt0 crt0_MSXDOS_advanced.rel C_FILE_NAME.c
```

<br/>

While the main should be as follows:

```c
char main(char argc, char** argv) 
{
  char i;
  
  if (argc!=0)
  {
    for(i=0;i<argc;i++) PRINT(argv[i]);
  }else{
    PRINT("There are no parameters.");
  }
    
  return 0; //return to DOS 
}
```

<br/>

### Generate a ending binary file

To finish you will need to convert the compiler output (.ihx) to a binary file, using the hex2bin application.

```
hex2bin -e COM C_FILE_NAME.ihx
```



<br/>

---

## Project Structure

I recommend using this structure:

```
src\      <--- sources
include\  <--- headers (.h) files
libs\     <--- libraries or object (.rel) files.
build\    <--- output files from compilator (No need to create directory. It is created by the script)
bin\      <--- result ROM file (No need to create directory. It is created by the script)
```
**Note:** It is not necessary to create the `build\` and `bin\` directories. 
When you run the script they will be created if they are not available. 


<br/>

---

## How to use the scripts

You must adapt the script to your project by modifying the following variables:

1. Put the sourcecode file name without extension at `CFILENAME` field.
2. Put the output COM file name without extension at `OUTPUTFILENAME` field (maximum 8 characters.). 
3. Add the file paths of the objects you need in the `LIBn` fields.

Example:

```bat
SET CFILENAME=TestLib
SET OUTPUTFILENAME=TESTLIB
SET CRT=libs\crt0_MSXDOS.rel
SET LIB0=libs\textmode_MSXDOS.rel
SET LIB1=
SET LIB2=
SET LIB3=
SET LIB4=
SET LIB5=
SET LIB6=
SET LIB7=
SET LIB8=
SET LIB9=
SET LIB10=
SET LIB11=
SET LIB12=
```

<br/>

---

## References

- [The History of MSX-DOS](https://www.msx.org/wiki/The_History_of_MSX-DOS) (by MSX Resource Center)
- [MSX-DOS](https://en.wikipedia.org/wiki/MSX-DOS) (Wikipedia)
- [MSX-DOS Wiki](https://www.msx.org/wiki/MSX-DOS) (by MSX Resource Center)
- MSX2 TECHNICAL HANDBOOK > [CHAPTER 3 - MSX-DOS](https://konamiman.github.io/MSX2-Technical-Handbook/md/Chapter3.html) (by Konamiman)
- MSX-DOS 2 [Program Interface Specification](https://map.grauw.nl/resources/dos2_environment.php) (by MSX Assembly Page)
- MSX-DOS 2 [Function Specification](https://map.grauw.nl/resources/dos2_functioncalls.php) (by MSX Assembly Page)
