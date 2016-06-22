DWFGBLD ;PICASSO/JOLLIS - FORM GENERATOR BUILD;9/17/10;src/fgen/DWFGBLD.m
;;3.0;FGEN;9/17/10;1
;; $Id: DWFGBLD.m 2 2010-10-22 21:08:28Z jollis $

;;PDOC
;;SUMMARY Compiles forms for a class into EWD pages
;;DEFSUB
COMPILE(CLASNAME,REVN,ACTION,TARGET)
;;ARG 1 CLASNAME The class to compile
;;ARG 2 REVN The revision to compile
;;ARG 3 ACTION The type of form to generate, ADD or EDIT
;;ARG 4 TARGET The file to compile to, defaults to STDOUT
;;PDOC/
 S REVV=REVN
 S DEFNOID=$$RETRIEVE^DWORCLAS(CLASNAME)
 I REVN="NEWEST" S REVV=$$NEWEST^DWORREC(DEFNOID,"CLASDEFN")
 S CLASDEFN=$$INPUT^DWORREC(DEFNOID,"CLASDEFN",REVV)
 I TARGET="" G STDOUT
 O TARGET
 U TARGET
STDOUT
 S LDEL="#"
 S PDEL=":"
 S HDRLINE=$P(CLASDEFN,LDEL,1)
 S CLASLABL=$P(HDRLINE,PDEL,3)
 S CSSCLASS=$P(HDRLINE,PDEL,2)
 I ACTION="ADD" G EWDADD
 I ACTION="EDIT" G EWDEDIT
EWDADD
 S PAGETITLE="Add New "_CLASLABL
 S FLDCNT=+$L(CLASDEFN,LDEL)
 W $$EWDHDR^DWFGBLD("false",""),!
 W $$HTMLOPEN^DWFGBLD(),!
 W $$HEADSECN^DWFGBLD(PAGETITLE),!
 W $$BODYOPEN^DWFGBLD(),!
 W $$HDRTXT^DWFGBLD(PAGETITLE,1),!
 W $$FORMOPEN^DWFGBLD("post","ewd"),!
 W $$INPFLD^DWFGBLD("hidden","CLSOID",DEFNOID)
 W $$TBLOPEN^DWFGBLD(),!
 F I=2:1:FLDCNT D
 .S CURFLD=$P(CLASDEFN,LDEL,I)
 .S RECORDKEY=$P(CURFLD,PDEL,1)
 .S TYPEFLD=$P(CURFLD,PDEL,2)
 .S PRITYPE=$P(TYPEFLD,",",1)
 .S SUBTYPE=$P(TYPEFLD,",",2)
 .S ATTRS=$P(CURFLD,PDEL,3)
 .S RULE=$P(CURFLD,PDEL,4)
 .S DEFAULT=$P(CURFLD,PDEL,5)
 .S LABEL=$P(CURFLD,PDEL,6)
 .S FIELDNAM=DEFNOID_RECORDKEY
 .I PRITYPE="TEXT" D 
 ..S TEXTBOX=$$INPFLD^DWFGBLD("text",FIELDNAM,DEFAULT)
 ..S INPFB=$$FLDBLK^DWFGBLD(LABEL,TEXTBOX)
 ..W INPFB,!
 S FIELDNAM=DEFNOID_"SUBMIT"
 S SUBBTN=$$SUBFLD^DWFGBLD(FIELDNAM,"Submit","","")
 S SUBFB=$$FLDBLK^DWFGBLD("",SUBBTN)
 W SUBFB,!
 W $$TBLCLS^DWFGBLD(),!
 W $$FORMCLS^DWFGBLD(),!
 W $$BODYCLS^DWFGBLD(),!
 W $$HTMLCLS^DWFGBLD(),!
 G CMPLDONE
EWDEDIT 
 G CMPLDONE
CMPLDONE
 I TARGET'="" D
 .CLOSE TARGET
 .U 0
 Q 

;;PDOC
;;SUMMARY Return an XML attribute
;;DEFFNC
XMLATTR(KEY,VAL)
;;ARG 1 KEY The attribute's key
;;ARG 2 KEY The attribute's value
;;PDOC/
 Q KEY_"="""_VAL_""""

;;PDOC
;;SUMMARY Return start of an xml tag TAG
;;DEFFNC
XMLST(TAG)
;;ARG 1 TAG The tag to open
;;PDOC/
 Q "<"_TAG

;;PDOC
;;SUMMARY Return a closing brace in a single line xml tag
;;DEFFNC
XMLSLCL()
;;PDOC/
 Q ">"

;;PDOC
;;SUMMARY Return a closing brace in a multi line xml tag TAG
;;DEFFNC
XMLMLCL(TAG)
;;ARG 1 TAG The tag to close
;;PDOC/
 Q "</"_TAG_">"

;;PDOC
;;SUMMARY Return an <hLEVEL>TEXT</hLEVEL> block
;;DEFFNC
HDRTXT(TEXT,LEVEL)
;;ARG 1 TEXT The text to place in the block
;;ARG 2 LEVEL The level of the heading
;;PDOC/
 Q "<h"_LEVEL_">"_TEXT_"</h"_LEVEL_">"

;;PDOC
;;SUMMARY Return a field block LABEL: CONT
;;DEFFNC
FLDBLK(LABEL,CONT)
;;ARG 1 LABEL The label of the block
;;ARG 2 CONT The contents of the block
;;PDOC/
 S COLON=""
 I LABEL'="" S COLON=":"
 Q "<tr><td>"_LABEL_COLON_"</td><td>"_CONT_"</td></tr>"

;;PDOC
;;SUMMARY Return a form input field
;;DEFFNC
INPFLD(TYPE,NAME,VALUE)
;;ARG 1 TYPE The HTML input field type
;;ARG 2 NAME The DOM name of the field
;;ARG 3 VALUE The initial value of the field
;;PDOC/
 S STFRG=$$XMLST^DWFGBLD("input")_" "
 S TYPFRG=$$XMLATTR^DWFGBLD("type",TYPE)
 S NAMFRG=$$XMLATTR^DWFGBLD("name",NAME)
 S VALFRG=$$XMLATTR^DWFGBLD("value",VALUE)
 S EFRG=$$XMLSLCL^DWFGBLD()
 Q STFRG_TYPFRG_" "_NAMFRG_" "_VALFRG_EFRG

;;PDOC
;;SUMMARY Return an HTML submit button 
;;DEFFNC
SUBFLD(NAME,LABEL,ACTION,NEXTPAGE)
;;ARG 1 NAME The DOM name of the button
;;ARG 2 LABEL The label on the button
;;ARG 3 ACTION The MUMPS action script to run
;;ARG 4 NEXTPAGE The page to go to after submit
;;PDOC/
 S STFRG=$$XMLST^DWFGBLD("input")_" "
 S TYPFRG=$$XMLATTR^DWFGBLD("type","submit")
 S NAMFRG=$$XMLATTR^DWFGBLD("name",NAME)
 S VALFRG=$$XMLATTR^DWFGBLD("value",LABEL)
 S ACTFRG=$$XMLATTR^DWFGBLD("action",ACTION)
 S NPFRG=$$XMLATTR^DWFGBLD("nextpage",NEXTPAGE)
 S EFRG=$$XMLSLCL^DWFGBLD()
 Q STFRG_TYPFRG_" "_NAMFRG_" "_VALFRG_" "_ACTFRG_" "_NPFRG_EFRG

;;PDOC
;;SUMMARY Return opening of an HTML table tag
;;DEFFNC
TBLOPEN()
;;PDOC/
 S STFRG=$$XMLST^DWFGBLD("table")_" "
 S BDFRG=$$XMLATTR^DWFGBLD("border","0")
 S EFRG=$$XMLSLCL^DWFGBLD()
 Q STFRG_BDFRG_EFRG

;;PDOC
;;SUMMARY Return ending of an HTML table tag
;;DEFFNC
TBLCLS()
;;PDOC/
 Q $$XMLMLCL^DWFGBLD("table")

;;PDOC
;;SUMMARY Return opening of an HTML form tag
;;DEFFNC
FORMOPEN(METHOD,ACTION)
;;ARG 1 METHOD The method, either post or get, to submit this form
;;ARG 2 ACTION The action to perform, usually ewd
;;PDOC/
 S STFRG=$$XMLST^DWFGBLD("form")_" "
 S MTHFRG=$$XMLATTR^DWFGBLD("method",METHOD)
 S ACTFRG=$$XMLATTR^DWFGBLD("action",ACTION)
 S EFRG=$$XMLSLCL^DWFGBLD()
 Q STFRG_MTHFRG_" "_ACTFRG_EFRG

;;PDOC
;;SUMMARY Return ending of an HTML form tag
;;DEFFNC
FORMCLS()
;;PDOC/
 Q $$XMLMLCL^DWFGBLD("form")

;;PDOC
;;SUMMARY Return an ewd config tag
;;DEFFNC
EWDHDR(FRSTPAGE,PREPAGE)
;;ARG 1 FRSTPAGE Is this the first page of the app, true or false
;;ARG 2 PREPAGE The pre-page script to call
;;PDOC/
 S STFRG=$$XMLST^DWFGBLD("ewd:config")_" "
 S FPFRG=$$XMLATTR^DWFGBLD("isFirstPage",FRSTPAGE)
 S PPFRG=$$XMLATTR^DWFGBLD("prePageScript",PREPAGE)
 S EFRG=$$XMLSLCL^DWFGBLD()
 I PREPAGE'="" Q STFRG_FPFRG_" "_PPFRG_EFRG
 S FTAG=STFRG_FPFRG_EFRG
 Q FTAG

;;PDOC
;;SUMMARY Return an html tag
;;DEFFNC
HTMLOPEN()
;;PDOC/
 Q $$XMLST^DWFGBLD("html")_">"
 
;;PDOC
;;SUMMARY Return head section
;;DEFFNC
HEADSECN(PGTITLE)
;;ARG 1 PGTITLE The title of the page
;;PDOC/
 S HEADFRG=$$XMLST^DWFGBLD("head")_">"
 S TITLEFRG=$$XMLST^DWFGBLD("title")_">"_PGTITLE_$$XMLMLCL^DWFGBLD("title")
 S HCFRG=$$XMLMLCL^DWFGBLD("head")
 Q HEADFRG_TITLEFRG_HCFRG

;;PDOC
;;SUMMARY Return the body section
;;DEFFNC
BODYOPEN()
;;PDOC/
 Q "<body>"

;;PDOC
;;SUMMARY Close the body section
BODYCLS()
;;PDOC/
 Q "</body>"

;;PDOC
;;SUMMARY Close the <html> section
;;DEFFNC
HTMLCLS()
;;PDOC/
 Q "</html>"



 