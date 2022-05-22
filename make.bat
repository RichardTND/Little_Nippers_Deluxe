echo off
del *.prg 
del littlenippersdx.prg 
java -jar "c:\kickassembler\kickass.jar" littlenippersdx.asm
if not exist littlenippersdx.prg exit

c:\exomizer\win32\exomizer.exe sfx $4000 littlenippersdx.prg -o littlenippersdx.prg -n

c:\c64\tools\vice\x64sc.exe littlenippersdx.prg