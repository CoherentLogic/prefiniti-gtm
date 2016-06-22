DWDOCS ;PICASSO/JOLLIS - DOCUMENTATION GENERATOR;9/21/10;src/docs/DWDOCS.m
;;3.0;DOCS;9/21/10;1
 D DWTIGPDI($ZCMD)

;;PDOC
;;SUMMARY Generate texinfo from PDI input file
;;DEFSUB
DWTIGPDI(INFILE)
;;ARG 1 INFILE Specifies the PDI file to convert
;;PDOC/
 U 0
 S (PKGNAME,SLASHES,BASENAME,RT,LN,FTYPE,ARGCNT,TAG,LBL,SUMMARY)=""
 W $$DWTIINPT(),!,$$DWTISOH(),!
 W $$DWTISFN("api_guide.info"),!
 W $$DWTISTTL("Prefiniti API Guide"),!
 W $$DWTIEOH(),!,!
 W "@copying",!
 W "This manual describes the Prefiniti v3 API",!,!
 W "Copyright (C) 2010 Coherent Logic Development LLC",!
 W "@end copying",!,! 
 W !,"@titlepage",!,"@title Prefiniti API Guide",!,"@page",!,"@vskip 0pt plus 1filll",!
 W "@end titlepage",!,!
 W "@contents",!
 W "@ifnottex",!,"@node Top",!,"@top Prefiniti API Guide",!,!
 W "@insertcopying",!
 W "@end ifnottex",!,!
 W "@menu",!
 S FH=INFILE
 S IFH=INFILE
 S LSTPKG=""
 OPEN IFH:(readonly)
 F  U IFH:exception="GOTO MEOF" R LN D
 .I $E(LN,1,7)="PACKAGE" D
 ..S PKGNAME=$E(LN,9,$L(LN))
 ..I LSTPKG'=PKGNAME D
 ...U 0 W "* ",PKGNAME,"::",! 
 ...S LSTPKG=PKGNAME
MEOF
 U 0 W !,"* Concepts Index::",!
 U 0 W "* Routines Index::",!
 U 0 W "@end menu",!,! 
 CLOSE IFH
 OPEN FH:(readonly)
 F  U FH:exception="GOTO EOF" R LN D
 .I $E(LN,1,7)="PACKAGE" D
 ..S PKGNAME=$E(LN,9,$L(LN))
 ..U 0 W !,$$DWTINODE(PKGNAME),!,$$DWTICHAP(PKGNAME),!,!
 .I $E(LN,1,4)="FILE" D
 ..S SLASHES=$L(LN,"/") S BASENAME=$P(LN,"/",SLASHES) S RT=$P(BASENAME,".",1)
 .I $E(LN,1,7)="SUMMARY" S SUMMARY=$E(LN,9,$L(LN))
 .I $E(LN,1,6)="DEFFNC" S FTYPE="FCN"
 .I $E(LN,1,6)="DEFSUB" S FTYPE="SUB"
 .I ($L(LN,"(")=2)&($L(LN,")")=2) D
 ..S FP=$P($P(LN,"(",2),")",1)
 ..S ARGCNT=$L(LN,",")
 ..S TAG=$P(LN,"(",1)
 ..S LBL=TAG_"^"_RT_"("_FP_")"
 ..I FTYPE="FCN" S LBL="$$"_TAG_"^"_RT_"("_FP_")"
 ..I FTYPE="SUB" S LBL=TAG_"^"_RT_"("_FP_")"
 ..U 0 W $$CINDEX(SUMMARY),!
 ..U 0 W $$FINDEX(LBL),!
 ..U 0 W $$DWTISC(SUMMARY),!
 ..U 0 W $$DWTISSC($$DWTICODE(LBL)),!
 .I $E(LN,1,3)="ARG" U 0 W $$ARGDESC(LN),!
 ;;.I $E(LN,1,5)="PDOC/" S (PKGNAME,SLASHES,BASENAME,RT,LN,FTYPE,ARGCNT,TAG,LBL,SUMMARY)=""
EOF CLOSE FH
 U 0
 W $$DWTINODE("Concepts Index"),!
 W "@unnumbered Concepts Index",!,!
 W "@printindex cp",!,!
 W $$DWTINODE("Routines Index"),!
 W "@unnumbered Routines Index",!,!
 W "@printindex fn",!,!
 W "@bye",!
 H

;;PDOC
;;SUMMARY Return an Argument description
;;DEFFNC
ARGDESC(TEXT)
;;ARG 1 TEXT The PDI argument line to parse and display
;;PDOC/
 S BLK=""
 S ARGNO=+$P(TEXT," ",2)
 S ARGNAME=$P(TEXT," ",3)
 S BLK="@* @emph{"_ARGNAME_"}:  "
 S PC=$L(TEXT," ")
 F I=4:1:PC S BLK=BLK_$P(TEXT," ",I)_" "
 Q BLK_" @*"

;;PDOC
;;SUMMARY Return a texinfo chapheading
;;DEFFNC
CHAPHEAD(TEXT)
;;ARG 1 TEXT The text of the chapter heading
;;PDOC/
 Q "@chapheading "_TEXT

;;PDOC
;;SUMMARY Return a texinfo majorheading
;;DEFFNC
MAJRHEAD(TEXT)
;;ARG 1 TEXT The text of the major heading
;;PDOC/
 Q "@majorheading "_TEXT

;;PDOC
;;SUMMARY Return a texinfo cindex tag
;;DEFFNC
CINDEX(TEXT)
;;ARG 1 TEXT The text of the index entry
;;PDOC/
 Q "@cindex "_TEXT

;;PDOC
;;SUMMARY Return a texinfo findex tag
;;DEFFNC
FINDEX(TEXT)
;;ARG 1 TEXT The text of the index entry
;;PDOC/
 Q "@findex "_TEXT

;;PDOC
;;SUMMARY Return a texinfo input tag
;;DEFFNC
DWTIINPT()
;;PDOC/
 Q "\input textinfo    @c -*-textinfo-*-"

;;PDOC
;;SUMMARY Return a texinfo start of header
;;DEFFNC
DWTISOH()
;;PDOC/
 Q "@c %**start of header"

;;PDOC
;;SUMMARY Return a texinfo setfilename tag
;;DEFFNC 
DWTISFN(NAME)
;;ARG 1 NAME The file to which the makeinfo output will be sent
;;PDOC/
 Q "@setfilename "_NAME

;;PDOC
;;SUMMARY Return a texinfo settitle tag
;;DEFFNC
DWTISTTL(NAME)
;;ARG 1 NAME The title of the document
;;PDOC/
 Q "@settitle "_NAME

;;PDOC
;;SUMMARY Return a texinfo end of header
;;DEFFNC
DWTIEOH()
;;PDOC/
 Q "@c %**end of header"


;;PDOC
;;SUMMARY Return a texinfo node tag
;;DEFFNC
DWTINODE(NAME)
;;ARG 1 NAME The name of the node
;;PDOC/
 Q "@node "_NAME

;;PDOC
;;SUMMARY Return a texinfo chapter tag
;;DEFFNC
DWTICHAP(NAME)
;;ARG 1 NAME The name of the chapter
;;PDOC/
 Q "@chapter "_NAME

;;PDOC
;;SUMMARY Return a texinfo code tag
;;DEFFNC
DWTICODE(CODE)
;;ARG 1 CODE The code to quote
;;PDOC/
 Q "@code{"_CODE_"}"

;;PDOC
;;SUMMARY Return a texinfo section tag
;;DEFFNC
DWTISC(NAME)
;;ARG 1 NAME The name of the section
;;PDOC/
 Q "@section "_NAME

;;PDOC
;;SUMMARY Return a texinfo subsection tag
;;DEFFNC
DWTISSC(NAME)
;;ARG 1 NAME The name of the subsection
;;PDOC/
 Q "@subsection "_NAME

;;PDOC
;;SUMMARY Return a texinfo subsubsection tag
;;DEFFNC
DWTISSSC(NAME)
;;ARG 1 NAME The name of the subsubsection
;;PDOC/
 Q "@subsubsection "_NAME


