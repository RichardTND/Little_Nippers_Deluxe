echo off
del *.prg 
del littlenippersdx.prg 
java -jar "c:\kickassembler\kickass.jar" littlenippersdx.asm
if not exist littlenippersdx.prg exit

rem c:\tscrunch\tscrunch\bin\tscrunch.exe -p -x $4000 littlenippersdx.prg littlenippersdx.prg
c:\exomizer20\win32\exomizer.exe sfx $4000 littlenippersdx.prg -o littlenippersdx.prg -x3

c:\c64\tools\vice\x64sc.exe littlenippersdx.prg