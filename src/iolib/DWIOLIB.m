DWIOLIB

;; $Id: DWIOLIB.m 4 2010-10-24 17:30:25Z jollis $

;;PDOC
;;SUMMARY Initialize the I/O Library
;;DEFFNC
INIT()
;;PDOC/
 S SCWIDTH=$$TRMCOLS^DWKRRNSI()
 S SCHEIGHT=$$TRMLINES^DWKRRNSI()
 S CURRBUF=""
 S PENDBUF=""
 S UPDTFLG=1
 U $P:(NOWRAP:NOCONVERT:NOECHO:NOTERMINATOR)
 D INIT^DWTVT100()
 W $$CLRSCR^DWTVT100()
 ;; Make the current buffer totally different from the pending
 ;; buffer so that the update procedure will redraw everything
 D SETBUF(.PENDBUF,SCWIDTH,SCHEIGHT,"WHITE","BLACK"," ")
 D SETBUF(.CURRBUF,SCWIDTH,SCHEIGHT,"BLACK","WHITE","@")
 D UPDATE()
 D PAUSE^DWPASHL("")
 Q

;;PDOC
;;SUMMARY Set up a screen buffer
;;DEFSUB
SETBUF(BUF,WIDTH,HEIGHT,FORECOLR,BACKCOLR,FILLCHAR)
;;ARG 1 BUF Reference to the buffer array
;;ARG 2 WIDTH The width of the screen
;;ARG 3 HEIGHT The height of the screen
;;ARG 4 FORECOLR The foreground color
;;ARG 5 BACKCOLR The background color
;;ARG 6 FILLCHAR The fill character
;;PDOC/
 N CX S CX=0 ;Current X
 N CY S CY=0 ;Current Y
 N ATTR S ATTR="" ;Attributes at X,Y
 S BUF("WIDTH")=WIDTH
 S BUF("HEIGHT")=HEIGHT
 S BUF("FILLCHAR")=FILLCHAR
 F CX=0:1:WIDTH-1 D
 .F CY=0:1:HEIGHT-1 D
 ..S BUF("SCR",CX,CY,"CHR")=FILLCHAR
 ..S ATTR=$$NOATTR^DWTVT100()
 ..S ATTR=ATTR_$$SETCOLOR^DWTVT100(FORECOLR,BACKCOLR)
 ..S BUF("SCR",CX,CY,"ESC")=ATTR
 Q

;;PDOC
;;SUMMARY Update pending->current and current->screen
;;DEFSUB
UPDATE()
;;PDOC/
 N CX S CX=0 ; Current X
 N CY S CY=0 ; Current Y
 N BW S BW=0
 N BH S BH=0
 S BW=PENDBUF("WIDTH")-1
 S BH=PENDBUF("HEIGHT")-1
 F CX=0:1:BW D
 .F CY=0:1:BH D
 ..I PENDBUF("SCR",CX,CY,"ESC")'=CURRBUF("SCR",CX,CY,"ESC") D
 ...S CURRBUF("SCR",CX,CY,"ESC")=PENDBUF("SCR",CX,CY,"ESC")
 ...W $$SETPOS^DWTVT100(CX,CY),CURRBUF("SCR",CX,CY,"ESC")
 ..I PENDBUF("SCR",CX,CY,"CHR")'=CURRBUF("SCR",CX,CY,"CHR") D
 ...S CURRBUF("SCR",CX,CY,"CHR")=PENDBUF("SCR",CX,CY,"CHR")
 ...W $$SETPOS^DWTVT100(CX,CY),CURRBUF("SCR",CX,CY,"CHR")
 S UPDTFLG=0
 Q
 
;;PDOC
;;SUMMARY Draw a rectangle into the pending buffer
;;DEFFNC
DRAWRECT(XPOS,YPOS,WIDTH,HEIGHT,FORECOLR,BACKCOLR,FILLCHAR)
;;ARG 1 XPOS The horizontal position of the upper-left corner
;;ARG 2 YPOS The vertical position of the upper-left corner
;;ARG 3 WIDTH The width, in characters, of the rectangle. Must be less than XPOS+SCWIDTH
;;ARG 4 HEIGHT The height, in characters, of the rectangle. Must be less than YPOS+SCHEIGHT
;;ARG 5 FORECOLR The foreground color of the rectangle
;;ARG 6 BACKCOLR The background color of the rectangle
;;ARG 7 FILLCHAR The character with which to fill the rectangle
;;PDOC/
 N CX S CX=0 ; Current X
 N CY S CY=0 ; Current Y
 N ATTR S ATTR=""
 N BW S BW=0
 N BH S BH=0
 S BW=PENDBUF("WIDTH")-1
 S BH=PENDBUF("HEIGHT")-1
 I WIDTH>(XPOS+BW+1) Q 0  ; rect too large horizontally
 I HEIGHT>(YPOS+BH+1) Q 0 ; rect too large vertically
 S ATTR=$$NOATTR^DWTVT100()_$$SETCOLOR^DWTVT100(FORECOLR,BACKCOLR)
 F CX=XPOS:1:(XPOS+(WIDTH-1)) D
 .F CY=YPOS:1:(YPOS+(HEIGHT-1)) D
 ..S PENDBUF("SCR",CX,CY,"CHR")=FILLCHAR
 ..S PENDBUF("SCR",CX,CY,"ESC")=ATTR
 S UPDTFLG=1
 Q 1

