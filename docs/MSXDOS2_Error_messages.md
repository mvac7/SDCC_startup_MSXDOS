# MSX-DOS2 Error Messages Guide 

This guide has been constructed to make it easier to consult the error message code definitions included in msxDOS.h.<br/>
It has been created with the help of documents published on the MSX Resource Center wiki and on the MSX Assembly Page. 

If you need to consult the complete information, I attach links to the original versions in the References section.

<br/>

## Notes:

The error code labels used are those published in the MSX Assembly Page document, with the addition of the prefix 'DOS2ERR_'. 

At the time of writing this guide, I don't know if they belong to an official definition. 
In other publications consulted I have not found any reference to them.

Codes 0, 126, 127 and 183 did not contain a name, so I have provided them with one trying to follow the style of the documented ones.

<br/>

---

## References

- MSX Resource Center · Wiki · [MSX-DOS 2 Error Messages](https://www.msx.org/wiki/Category:MSX-DOS_2_Error_Messages)
- MSX Assembly Page · MSX-DOS 2 Program Interface Specification · [Errors](https://map.grauw.nl/resources/dos2_environment.php#c6)

<br/>

---

## General errors

| Value   | Message               |
| ---:    | :---                  |
| 1-63    |                       |
| 32-63   | User error <number>   |
| 64-125  | System error <number> |
| 144-154 | System error <number> |
| 160-182 | System error <number> |
| 224-239 | System error <number> |
| 128     |                       |

<br/>

---

## Undefined errors

| Value | Label  | Message | Notes |
| ---:  | :---   | :---    | :---  |
| 0     | DOS2ERR_NOERR  |         | No Error (2) |
| 126   | DOS2ERR_ANYKEY | Press any key to continue...   | (2) | 
| 127   | DOS2ERR_INSDSK | Insert MSX-DOS disk in drive : | (2) | 

<br/>

---

## Command errors

| Value | Label  | Message | Notes |
| ---: | :---   | :---    | :---  |
|  129 | DOS2ERR_OVDEST | Cannot overwrite previous destination file |  |
|  130 | DOS2ERR_COPY   | File cannot be copied onto itself |  |
|  131 | DOS2ERR_BADEST | Cannot create destination file |  |
|  132 | DOS2ERR_NOCAT  | Cannot concatenate destination file |  |
|  133 | DOS2ERR_BADVER | Wrong version of MSX-DOS |  |
|  134 | DOS2ERR_NOHELP | File for HELP not found |  |
|  135 | DOS2ERR_BADNO  | Invalid number |  |
|  136 | DOS2ERR_IOPT   | Invalid option |  |
|  137 | DOS2ERR_NOPAR  | Missing parameter |  |
|  138 | DOS2ERR_INP    | Too many parameters |  |
|  139 | DOS2ERR_IPARM  | Invalid parameter |  |
|  140 | DOS2ERR_OKCMD  |                   | COMMAND Internal error (1) |
|  141 | DOS2ERR_BUFUL  | Command too long  |  |
|  142 | DOS2ERR_BADCM  | Unrecognized command |  |
|  143 | DOS2ERR_BADCOM | Wrong version of COMMAND |  |

<br/>

---

## Program termination errors

| Value | Label  | Message | Notes |
| ---: | :---   | :---    | :---  |
| 155  | DOS2ERR_INERR  |         | Error on standard input (1) |
| 156  | DOS2ERR_OUTERR |         | Error on standard output (1) |
| 157  | DOS2ERR_ABORT  | Disk operation aborted |  |
| 158  | DOS2ERR_CTRLC  | Ctrl-C pressed         |  |
| 159  | DOS2ERR_STOP   | Ctrl-STOP pressed      |  |

<br/>

---

## MSX-DOS Function Errors		

| Value | Label  | Message | Notes |
| ---: | :---   | :---    | :---  |	
| 183  | DOS2ERR_IFCBK | Invalid File Control Block | (2) |
| 184  | DOS2ERR_ISBFN | Invalid sub-function number |  |
| 185  | DOS2ERR_EOL   | System Error 185 | MSX-DOS Function Internal error (1)	
| 186  | DOS2ERR_HDEAD | File handle has been deleted |  |
| 187  | DOS2ERR_NRAMD | RAM disk does not exist |  |
| 188  | DOS2ERR_RAMDX | RAM disk (drive H:) already exists |  |
| 189  | DOS2ERR_ITIME | Invalid time |  |
| 190  | DOS2ERR_IDATE | Invalid date |  |
| 191  | DOS2ERR_ELONG | Invalid string too long |  |
| 192  | DOS2ERR_IENV  | Invalid environment string |  |
| 193  | DOS2ERR_IDEV  | Invalid device operation |  |
| 194  | DOS2ERR_NOPEN | File handle not open |  |
| 195  | DOS2ERR_IHAND | Invalid file handle |  |
| 196  | DOS2ERR_NHAND | No spare file handles |  |
| 197  | DOS2ERR_IPROC | Invalid process id |  |
| 198  | DOS2ERR_ACCV  | File access violation |  |
| 199  | DOS2ERR_EOF   | End of file |  |
| 200  | DOS2ERR_FILE  | File allocation error |  |
| 201  | DOS2ERR_OV64K | Cannot transfer above 64K |  |
| 202  | DOS2ERR_FOPEN | File already in use |  |
| 203  | DOS2ERR_FILEX | File exists |  |
| 204  | DOS2ERR_DIRX  | Directory exists |  |
| 205  | DOS2ERR_SYSX  | System file exists |  |
| 206  | DOS2ERR_DOT   | Invalid . or .. operation |  |
| 207  | DOS2ERR_IATTR | Invalid attributes |  |
| 208  | DOS2ERR_DIRNE | Directory not empty |  |
| 209  | DOS2ERR_FILRO | Read only file |  |
| 210  | DOS2ERR_DIRE  | Invalid directory move |  |
| 211  | DOS2ERR_DUPF  | Duplicate filename |  |
| 212  | DOS2ERR_DKFUL | Disk full |  |
| 213  | DOS2ERR_DRFUL | Root directory full |  |
| 214  | DOS2ERR_NODIR | Directory not found |  |
| 215  | DOS2ERR_NOFIL | File not found |  |
| 216  | DOS2ERR_PLONG | Pathname too long |  |
| 217  | DOS2ERR_IPATH | Invalid pathname |  |
| 218  | DOS2ERR_IFNM  | Invalid filename |  |
| 219  | DOS2ERR_IDRV  | Invalid drive |  |
| 220  | DOS2ERR_IBDOS | Invalid MSX-DOS call |  |
| 221  |       | System Error 221 |  |
| 222  | DOS2ERR_NORAM | Not enough memory |  |
| 223  | DOS2ERR_INTER | Internal error |  |

<br/>

---

## Disk errors

| Value  | Label  | Message | Notes |
| ---: | :---   | :---    | :---  |
| 240  | DOS2ERR_IFORM  | Cannot format this drive |  |
| 241  | DOS2ERR_NOUPB  | System Error 241 | Disk change Internal error (1) |
| 242  | DOS2ERR_IFAT   | Bad file allocation table |  |
| 243  | DOS2ERR_SEEK   | Seek error |  |
| 244  | DOS2ERR_WFILE  | Wrong disk for file |  |
| 245  | DOS2ERR_WDISK  | Wrong disk |  |
| 246  | DOS2ERR_NDOS   | Not a DOS disk |  |
| 247  | DOS2ERR_UFORM  | Unformatted disk |  |
| 248  | DOS2ERR_WPROT  | Write protected disk |  |
| 249  | DOS2ERR_RNF    | Sector not found |  |
| 250  | DOS2ERR_DATA   | Data error |  |
| 251  | DOS2ERR_VERFY  | Verify error |  |
| 252  | DOS2ERR_NRDY   | Not ready |  |
| 253  | DOS2ERR_DISK   | Disk error |  |
| 254  | DOS2ERR_WRERR  | Write error |  |
| 255  | DOS2ERR_NCOMP  | Incompatible disk |  |

<br/>

---

__(1) Don't display an error message, although they correspond to an internal error.__<br/>
__(2) Undocumented labels.__
