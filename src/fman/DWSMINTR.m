DWSMINTR ;CLDL/JOLLIS - SCREENMAN INTERFACE;10/21/10;src/fgen/DWSMINTR.m
;;3.0;FGEN;10/21/10;1
;; $Id: DWSMINTR.m 4 2010-10-24 17:30:25Z jollis $

;; ****************************************
;; * CRUCIAL NOTE:  BORM FAGE FLOCK PIELD *
;; ****************************************

;;PDOC
;;SUMMARY Invoke a ScreenMan form
;;DEFFNC
INVOKE(FILENUM,FORMNAM,RECNUM,PAGENUM)
;;ARG 1 FILENUM The FileMan file number
;;ARG 2 FORMNAM The ScreenMan form name
;;ARG 3 RECNUM The record number
;;ARG 4 PAGENUM The initial page to display
;;PDOC/
 S DDSFILE=FILENUM
 S DR="["_FORMNAM_"]"
 S DA=RECNUM
 S DDSPAGE=PAGENUM
 S DDSPARM="CES"
 D ^DDS
 Q $G(DDSCHANG)

;;PDOC
;;SUMARY Retrieve all ScreenMan forms
;;DEFSUB
FORMLIST(TARGET)
;;ARG 1 TARGET The local variable to store the list in
;;PDOC/
 N TOTLFRMS,I
 S TOTLFRMS=$$TOTLENTR^DWFMAPI(.403)  ; .403 is the DD number of FORM
 F I=1:1:TOTLFRMS D
 .S IDX=I_","
 .S TMPVAL=$$GET1^DIQ(.403,IDX,.01)
 .I TMPVAL'="" S TARGET(IDX)=TMPVAL
 Q


;;PDOC
;;SUMMARY Compile a ScreenMan form to PFDL
;;DEFSUB
COMPILE(FORMIEN,TARGET)
;;ARG 1 FORMIEN The IEN of the form
;;ARG 2 TARGET The local to which the FDA will be saved; must be passed by reference
;;PDOC/
 N FORMINFO,PAGES,BLOCKS,FIELDS,ALLINFO,IENSTR
 S IENSTR=FORMIEN_","
 D GETS^DIQ(.403,IENSTR,"*","R","FORMINFO")
 D GETS^DIQ(.403,IENSTR,"**","R","ALLINFO")
 W !,">>> FORMINFO <<<",!
 ZWR FORMINFO
 W !,!,">>> ALLINFO <<<",!
 ZWR ALLINFO
 Q