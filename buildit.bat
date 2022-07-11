echo off

REM *** REMOVE ALL OLD COMPILED DATA ***

del *.prg

REM *** COMPILE RAW LEVEL GRAPHICS BINARY DATA AS C64 PROGRAMS ***

c:\c64\tools\acme\acme.exe b1a.txt
c:\c64\tools\acme\acme.exe b1b.txt
c:\c64\tools\acme\acme.exe b1c.txt
c:\c64\tools\acme\acme.exe b2a.txt
c:\c64\tools\acme\acme.exe b2b.txt
c:\c64\tools\acme\acme.exe b2c.txt
c:\c64\tools\acme\acme.exe b3a.txt
c:\c64\tools\acme\acme.exe b3b.txt
c:\c64\tools\acme\acme.exe b3c.txt
c:\c64\tools\acme\acme.exe b4a.txt
c:\c64\tools\acme\acme.exe b4b.txt 
c:\c64\tools\acme\acme.exe b4c.txt
c:\c64\tools\acme\acme.exe b5a.txt 
c:\c64\tools\acme\acme.exe b5b.txt 
c:\c64\tools\acme\acme.exe b5c.txt
 
REM *** COMPRESS ALL LEVEL GRAPHICS USING EXOMIZER V2.0 (V3 IS NOT COMPATIBLE FOR THE DECRUNCH SOURCE I USE) ***

c:\c64\tools\exomizer20\win32\exomizer.exe mem beach1charset.prg,$0800 -o beachcharset1.prg -q
c:\c64\tools\exomizer20\win32\exomizer.exe mem beach1screen.prg,$6800 -o beachscreen1.prg -q
c:\c64\tools\exomizer20\win32\exomizer.exe mem beach1attribs.prg,$6c00 -o beachattribs1.prg -q

c:\c64\tools\exomizer20\win32\exomizer.exe mem beach2charset.prg,$0800 -o beachcharset2.prg -q
c:\c64\tools\exomizer20\win32\exomizer.exe mem beach2screen.prg,$6800 -o beachscreen2.prg -q
c:\c64\tools\exomizer20\win32\exomizer.exe mem beach2attribs.prg,$6c00 -o beachattribs2.prg -q

c:\c64\tools\exomizer20\win32\exomizer.exe mem beach3charset.prg,$0800 -o beachcharset3.prg -q
c:\c64\tools\exomizer20\win32\exomizer.exe mem beach3screen.prg,$6800 -o beachscreen3.prg -q
c:\c64\tools\exomizer20\win32\exomizer.exe mem beach3attribs.prg,$6c00 -o beachattribs3.prg -q

c:\c64\tools\exomizer20\win32\exomizer.exe mem beach4charset.prg,$0800 -o beachcharset4.prg -q
c:\c64\tools\exomizer20\win32\exomizer.exe mem beach4screen.prg,$6800 -o beachscreen4.prg -q
c:\c64\tools\exomizer20\win32\exomizer.exe mem beach4attribs.prg,$6c00 -o beachattribs4.prg -q

c:\c64\tools\exomizer20\win32\exomizer.exe mem beach5charset.prg,$0800 -o beachcharset5.prg -q
c:\c64\tools\exomizer20\win32\exomizer.exe mem beach5screen.prg,$6800 -o beachscreen5.prg -q
c:\c64\tools\exomizer20\win32\exomizer.exe mem beach5attribs.prg,$6c00 -o beachattribs5.prg -q

REM *** ASSEMBLE MAIN GAME PROJECT ***

java -jar "c:\c64\tools\kickassembler\kickass.jar" littlenippersdx.asm

if not exist littlenippersdx.prg exit

REM *** EXOMIZER - CRUEL CRUNCHER DECRUNCH STYLE ***
c:\c64\tools\exomizer\win32\exomizer.exe sfx $4000 littlenippersdx.prg -o littlenippersdx.exo -s "jsr highest_addr_out" -x "inc $d800"
java -jar "c:\c64\tools\kickassembler\kickass.jar" littlenippers-ready.asm
java -jar "c:\c64\tools\kickassembler\kickass.jar" littlenippersintro.asm 
c:/c64/tools/exomizer/win32/exomizer.exe sfx $080d littlenippersintro.PRG -o littlenippersdisk.exo -s "jsr highest_addr_out" -x "inc $d800"
java -jar "c:\c64\tools\kickassembler\kickass.jar" littlenippersdisk.asm

REM *** BUILD TND INTRO LINKER RELEASE FOR DISK *** 
c:/c64/tools/exomizer/win32/exomizer.exe sfx $0810 tndlinker.rcb littlenippersdisk.prg,$2c00 -o little_nippers_disk.prg -s "lda #$a0 sta $0400" -x "inc $d800"

REM *** BUILD TND INTRO LINKER RELEASE FOR TAPE ***

c:/c64/tools/exomizer/win32/exomizer.exe sfx $0810 tndlinker.rcb littlenippers-ready.prg,$2c00 -o little_nippers_tape.prg -s "lda #$a0 sta $0400" -x "inc $d800"
REM *** RUN DISK IN VICE ***
c:\c64\tools\vice\x64sc.exe little_nippers_disk.prg

echo "COMPLETE BUILD FINISHED ..."