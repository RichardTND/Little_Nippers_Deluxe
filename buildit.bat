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
 
rem Compress level graphics data with Exomizer

c:\c64\tools\exomizer20\win32\exomizer.exe mem beach1charset.prg,$0800 -o beachcharset1.prg 
c:\c64\tools\exomizer20\win32\exomizer.exe mem beach1screen.prg,$6800 -o beachscreen1.prg 
c:\c64\tools\exomizer20\win32\exomizer.exe mem beach1attribs.prg,$6700 -o beachattribs1.prg 

c:\c64\tools\exomizer20\win32\exomizer.exe mem beach2charset.prg,$0800 -o beachcharset2.prg 
c:\c64\tools\exomizer20\win32\exomizer.exe mem beach2screen.prg,$6800 -o beachscreen2.prg 
c:\c64\tools\exomizer20\win32\exomizer.exe mem beach2attribs.prg,$6700 -o beachattribs2.prg 

c:\c64\tools\exomizer20\win32\exomizer.exe mem beach3charset.prg,$0800 -o beachcharset3.prg 
c:\c64\tools\exomizer20\win32\exomizer.exe mem beach3screen.prg,$6800 -o beachscreen3.prg 
c:\c64\tools\exomizer20\win32\exomizer.exe mem beach3attribs.prg,$6700 -o beachattribs3.prg 

java -jar "c:\c64\tools\kickassembler\kickass.jar" littlenippersdx.asm

if not exist littlenippersdx.prg exit

c:\c64\tools\exomizer\win32\exomizer.exe sfx $4000 littlenippersdx.prg -o littlenippersdx.exo -s "jsr highest_addr_out" -n  
java -jar "c:\c64\tools\kickassembler\kickass.jar" littlenippers-ready.asm
c:\c64\tools\vice\x64sc.exe littlenippers-ready.prg