>TYPE   	D
>NAME   	CHECKLNG.d
>CODE   	CHECKLNG.cod
>BY     	@(#)$Author: $
>DATE   	@(#)$Date:  $
>VERSION	@(#)$Revision: $
>ID     	0

>FILES ROWS 0
#type id  name        dbtype mode autoload r0 r1 r2 r3 r4 r5 comment

>TEXTINFO ROWS 0 SIZE 0
#id    value    flags    text


>STACK ROWS 200 SIZE 5000

>FONT ROWS 9
#id Hgt Wth Esc Ori Wgt Ita  Ul Sth Chs Opr Clp Qua Pch Name
1    -9   0   0   0 400   0  0   0   0   0   0   0   0 "Arial"
2   -11   0   0   0 400   0  0   0   0   0   0   0   0 "Arial"
3   -11   0   0   0 400   1  0   0   0   0   0   0   0 "Arial"
4   -11   0   0   0 700   0  0   0   0   0   0   0   0 "Arial"
5   -13   0   0   0 400   0  0   0   0   0   0   0   0 "Arial"
6   -13   0   0   0 400   1  0   0   0   0   0   0   0 "Arial"
7   -13   0   0   0 700   0  0   0   0   0   0   0   0 "Arial"
8   -16   0   0   0 400   0  0   0   0   0   0   0   0 "Arial"
9   -19   0   0   0 400   0  0   0   0   0   0   0   0 "Arial"


>COLOR ROWS 16
#id color	comment
1   0x0        	""
2   0x808080   	""
3   0x80       	""
4   0x8080     	""
5   0x8000     	""
6   0x808000   	""
7   0x800000   	""
8   0x800080   	""
9   0xffffff   	""
A   0xc0c0c0   	""
B   0xff       	""
C   0xffff     	""
D   0xff00     	""
E   0xffff00   	""
F   0xff0000   	""
G   0xff00ff   	""


>BRUSH ROWS 5 SIZE 100
#id type	text
1   0	0xff0000
2   1	pattern
3   2	tegel.bmp
5   4	0xff
6   5	0x0


>APPEVENTS ROWS 0
#id Eventname	ParamList


>WINDOW ROWS 1
#id       x     y    cy    cx sp1	sp2	Bitmap	font	size	caption
5511     10    10   162   338 S	-	-	"-"	  0	"Kontrollera användning av lng_texter"

>FORM MAIN ROWS 4 SIZE 44 "100 Main"
#T   Id    R    C   cy   cx sp	sp1	sp2	Id	Label
T     11   10   10   11  103 -	p	-	-	-	"Ange dialognamn (tex w710.d):"
D     12    8  115   13   60 -	P$!	-	edDialog	-	""
PB    13    8  178   15   50 -	P	-	pbCheckDialog	-	"Kontrollera"
EM    14   30    4  128  329 -	pWZä	-	edResult	-	""

>SOURCE
@global

*define PROGRAM_FILE = 1000

#include std.i

#uselib std

function fvCheckLngTexts()
begin
	str sTextBuffert(500)
	str sLngText
	str sLngs(1000)
	
	ww_textset(edResult,"")
	f_open('PRO:'&ww_textget(edDialog,0)%S%T,PROGRAM_FILE,'r')
	ifl ok
		f_read_line(PROGRAM_FILE) -> sTextBuffert
		while not eof
			ifl sTextBuffert%L9=">TEXTINFO"
				f_read_line(PROGRAM_FILE) -> sTextBuffert
				f_read_line(PROGRAM_FILE) -> sTextBuffert
				while sTextBuffert%L4="IDL_"
					ifl sLngs%T = ""
						sTextBuffert%L7%S%T -> sLngs
					else
						sLngs%S%T & "," & sTextBuffert%L7%S%T -> sLngs
					endifl	
					f_read_line(PROGRAM_FILE) -> sTextBuffert
				wend
			endifl
						
			while sTextBuffert%U ? "IDL_"
				mid(sTextBuffert,I2,7) -> sLngText
				right(sTextBuffert,I2+1)%S%T->sTextBuffert
				ifl ("," & sLngs & ",") ? ("," & sLngText & ",")
					ifl i2 = 1
						right(sLngs,i2+1+len(sLngText)) -> sLngs
					else
						left(sLngs,i2-2) & right(sLngs,i2+len(sLngText)) -> sLngs
					endifl
				endifl	
			wend
			f_read_line(PROGRAM_FILE) -> sTextBuffert
		wend
		f_close(PROGRAM_FILE)
		ifl sLngs<>""
			replace_str(sLngs,",",CHR_CRLF) -> sLngs
			ww_textset(edResult,"Används ej: "&CHR_CRLF&sLngs)
		else
			ww_textset(edResult,"Samtliga texter används")
		endifl	
	else
		error("Kunde inte hitta program "&ww_textget(edDialog,0)%S%T)
	endifl	
end

@preshow
	ww_textset(edDialog,"$.d")

@pbCheckDialog_click
	fvCheckLngTexts()	
