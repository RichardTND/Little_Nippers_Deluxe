echo off
del *.prg

rem ACME compiler 

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
 
rem Compress level graphics data with Exomizer

c:\c64\tools\exomizer20\win32\exomizer.exe mem beach1charset.prg,$0800 -o beachcharset1.prg -q
c:\c64\tools\exomizer20\win32\exomizer.exe mem beach1screen.prg,$6800 -o beachscreen1.prg -q
c:\c64\tools\exomizer20\win32\exomizer.exe mem beach1attribs.prg,$6700 -o beachattribs1.prg -q

c:\c64\tools\exomizer20\win32\exomizer.exe mem beach2charset.prg,$0800 -o beachcharset2.prg -q
c:\c64\tools\exomizer20\win32\exomizer.exe mem beach2screen.prg,$6800 -o beachscreen2.prg -q
c:\c64\tools\exomizer20\win32\exomizer.exe mem beach2attribs.prg,$6700 -o beachattribs2.prg -q

c:\c64\tools\exomizer20\win32\exomizer.exe mem beach3charset.prg,$0800 -o beachcharset3.prg -q
c:\c64\tools\exomizer20\win32\exomizer.exe mem beach3screen.prg,$6800 -o beachscreen3.prg -q
c:\c64\tools\exomizer20\win32\exomizer.exe mem beach3attribs.prg,$6700 -o beachattribs3.prg -q

c:\c64\tools\exomizer20\win32\exomizer.exe mem beach4charset.prg,$0800 -o beachcharset4.prg -q
c:\c64\tools\exomizer20\win32\exomizer.exe mem beach4screen.prg,$6800 -o beachscreen4.prg -q
c:\c64\tools\exomizer20\win32\exomizer.exe mem beach4attribs.prg,$6700 -o beachattribs4.prg -q

c:\c64\tools\exomizer20\win32\exomizer.exe mem beach5charset.prg,$0800 -o beachcharset5.prg -q
c:\c64\tools\exomizer20\win32\exomizer.exe mem beach5screen.prg,$6800 -o beachscreen5.prg -q
c:\c64\tools\exomizer20\win32\exomizer.exe mem beach5attribs.prg,$6700 -o beachattribs5.prg -q

java -jar "c:\c64\tools\kickassembler\kickass.jar" littlenippersdx.asm

if not exist littlenippersdx.prg exit

rem *** EXOMIZER - CRUEL CRUNCHER V2.5+/CROSS STYLE ***
c:\c64\tools\exomizer\win32\exomizer.exe sfx $4000 littlenippersdx.prg -o littlenippersdx.exo -s "jsr highest_addr_out" -x "sty $d020 inc $0428" -q
java -jar "c:\c64\tools\kickassembler\kickass.jar" littlenippers-ready.asm
c:\c64\tools\vice\x64sc.exe littlenippers-ready.prg