DWKRRNSI ;PICASSO/JOLLIS - TERMINAL INPUT;9/13/10;src/krnl/DWKRRNSI.m
;;3.0;KRNL;9/13/10;1
;; $Id: DWKRRNSI.m 4 2010-10-24 17:30:25Z jollis $

;;PDOC
;;SUMMARY Return a multi-line input
;;DEFFCN
MLTILINE()
;;PDOC/
 W "MULTI-LINE INPUT:  END WITH ""."" ON A LINE BY ITSELF",!,!
 S CR="#"
 S SVAL=""
 S RVAL=""
 S LINE=1
ANOTHER
 W !,LINE,": " 
 R SVAL 
 I SVAL="." G ALLDONE
 I LINE'=1 S RVAL=RVAL_CR_SVAL 
 I LINE=1 S RVAL=SVAL
 S LINE=LINE+1
 G ANOTHER
ALLDONE
 Q RVAL

;;PDOC
;;SUMMARY Get terminal height in lines
;;DEFFNC
TRMLINES()
;;PDOC/
;; syntax for $$RETURN^%ZOSV thanks to dlw
 Q $$RETURN^%ZOSV("tput lines")

;;PDOC
;;SUMMARY Get terminal width in columns
;;DEFFNC
TRMCOLS()
;;PDOC/
;; syntax for $$RETURN^%ZOSV thanks to dlw
 Q $$RETURN^%ZOSV("tput cols")

;;PDOC
;;SUMMARY Write a multi-line global
;;DEFSUB
WMLTLINE(GLOB)
;;ARG 1 GLOB The global to be written
;;PDOC/
 S LC=$L(GLOB,"#")
 F I=1:1:LC  W $P(GLOB,"#",I),!
 Q

;;PDOC
;;SUMMARY Send escape sequence
;;DEFSUB
ESCAPE(SEQ)
;;ARG 1 SEQ The escape sequence
;;PDOC/
 U $P:ESCAPE W $C(27)_"["_SEQ
 Q

;;PDOC
;;SUMMARY Clear the screen
;;DEFSUB
CLRSCR()
;;PDOC/
 D ESCAPE("2J") W #
 Q

;;PDOC
;;SUMMARY Set colors
;;DEFSUB
COLOR(FG,BG)
;;ARG 1 FG The foreground color
;;ARG 2 BG The background color
;;PDOC/
 S ^DWPREF("FG","P")=^DWPREF("FG")
 S ^DWPREF("BG","P")=^DWPREF("BG")
 S ^DWPREF("FG")=FG
 S ^DWPREF("BG")=BG
 S FGC=^DWPREF("COLORS","FOREGROUND",FG)
 S BGC=^DWPREF("COLORS","BACKGROUND",BG)
 S ESEQ=FGC_";"_BGC_"m"
 D ESCAPE(ESEQ)
 Q

;;PDOC
;;SUMMARY Restore the previous colors
;;DEFSUB
RESTRCLR()
;;PDOC/
 D COLOR(^DWPREF("FG","P"),^DWPREF("BG","P"))
 Q

;;PDOC
;;SUMMARY Locate the cursor to X,Y
;;DEFSUB
LOCATE(X,Y)
;;ARG 1 X The horizontal coordinate
;;ARG 2 Y The vertical coordinate
;;PDOC/
 S $X=X
 S $Y=Y
 S ^DWPREF("XPOS","P")=^DWPREF("XPOS")
 S ^DWPREF("YPOS","P")=^DWPREF("YPOS")
 S ^DWPREF("XPOS")=X S ^DWPREF("YPOS")=Y
 S ESEQ=Y_";"_X_"H"
 D ESCAPE(ESEQ)
 Q

;;PDOC
;;SUMMARY Restore previous cursor position
;;DEFSUB
RESTORXY()
;;PDOC/
 D LOCATE(^DWPREF("XPOS","P"),^DWPREF("YPOS","P"))
 Q

;;PDOC
;;SUMMARY Write a bar across the screen
;;DEFSUB
HDRBAR(FG,BG,LENGTH)
;;ARG 1 FG Foreground Color
;;ARG 2 BG Background Color
;;ARG 3 LENGTH Length of the bar
;;PDOC/
 D LOCATE(0,0) D COLOR(FG,BG)
 F I=1:1:LENGTH W " "
 D RESTRCLR()
 D RESTORXY()
 Q

;;PDOC
;;SUMMARY Write TEXT at X,Y coordinates
;;DEFSUB
WRITEAT(X,Y,TEXT)
;;ARG 1 X X coordinate
;;ARG 2 Y Y coordinate
;;ARG 3 TEXT Text to be written
;;PDOC/
 D LOCATE(X,Y) W TEXT
 Q

;;PDOC
;;SUMMARY Reset the screen
;;DEFSUB
RESET()
 D COLOR("WHITE","BLACK")
 D CLRSCR()
 Q