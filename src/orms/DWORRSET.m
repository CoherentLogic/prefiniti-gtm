DWORRSET ;PICASSO/JOLLIS - ORMS RECORDSET SUPPORT;9/25/10;src/orms/DWORRSET.m
 ;;3.0;ORMS;9/25/10;1
 ;; $Id: DWORRSET.m 4 2010-10-24 17:30:25Z jollis $

;; QUERY SYNTAX:
;;  QUERY BLOCKTYPE OF FIELDLIST IN CLASNAME(FIELDREF OP VALUE) TO RECORDSET RECORDSETNAME
;;
;;  BLOCKTYPE:
;;   One of the following:
;;    PRIMARIES				Retrieve the Primary Data Blocks for FIELDLIST
;;    JOBS				Retrieve the creating jobs for FIELDLIST
;;    TIMESTAMPS			Retrieve the timestamps for FIELDLIST
;;
;;  FIELDLIST:
;;   A comma-delimited list of fields to retrieve
;;
;;  CLASNAME:
;;   The name of the class through which to query
;;
;;  FIELDREF:
;;   For a top-level field:		FIELDNAME
;;   For a CLASPTR field:      		PTRNAME.FIELDNAME
;;   For a CLASPTR within a CLASPTR:	PTRNAME.PTRNAME.FIELDNAME
;;
;;  OP:
;;   EQ					Equal to
;;   NEQ				Not equal to
;;   CN					Contains
;;   NCN				Does not contain
;;   LT					Less than
;;   GT					Greater than
;;   LE					Less than or equal to
;;   GE					Greater than or equal to
;;   CEQ				Contains or equal to
;;
;;  VALUE:				A quoted string


;;PDOC
;;SUMMARY Build a query from a query string
;;DEFFNC
BLDQRY(QS)
;;ARG 1 QS The query string
;;PDOC/
 S BLKTYPE=$P(QS," ",2)
 S LBLKTYPE=BLKTYPE
 I BLKTYPE="PRIMARIES" S BLKTYPE="DAT"
 I BLKTYPE="JOBS" S BLKTYPE="JOB"
 I BLKTYPE="TIMESTAMPS" S BLKTYPE="DTM"
 S FLDLST=$P(QS," ",4)
 S CLASPART=$P($P(QS," ",6),"(",1)
 S CONDPART=$P($P(QS,"(",2),")",1)
 S FLDREF=$P(CONDPART," ",1)
 S OPPART=$P($P(CONDPART," ",2),"""",1)
 S VALPRT=$P($P(CONDPART,"""",2),"""",1)
 S RSPRT=$P($P(QS,"RECORDSET",2)," ",2)
 S QRYKEY=$$GETNEXT^DWKRFUID()
 S ^DWQ(QRYKEY,"QS")=QS
 S ^DWQ(QRYKEY,"CLS")=CLASPART
 S ^DWQ(QRYKEY,"CND")=CONDPART
 S ^DWQ(QRYKEY,"FLD")=FLDREF
 S ^DWQ(QRYKEY,"OP")=OPPART
 S ^DWQ(QRYKEY,"VAL")=VALPRT
 S ^DWQ(QRYKEY,"RS")=RSPRT
 S ^DWRSET(RSPRT)=1
 S MC=0
 S OB=""
 S OX=""
 F I=0:0 S OB=$O(^DWORMS(OB)) Q:OB=""  D
 .I ^DWORMS(OB,"CLS")=CLASPART D  ; we matched on CLASPART
 ..F I=0:0 S OX=$O(^DWORMS(OB,FLDREF,OX)) Q:OX=""  D
 ...S FLG=0
 ...S CODE="I $$"_OPPART_"("""_$G(^DWORMS(OB,FLDREF,OX,"DAT"))_""","""_VALPRT_""") S FLG=1"
 ...X CODE
 ...I FLG=1 D ; We matched on CONDPART
 ....S MC=MC+1
 ....S ^DWRSET(RSPRT,MC)=OB 
 ....S ^DWRSMETA(RSPRT,"QRYKEY")=QRYKEY
 ....S ^DWRSMETA(RSPRT,"MATCHES")=MC
 ....S ^DWRSMETA(RSPRT,"FIELD")=FLDREF
 ....S ^DWRSMETA(RSPRT,"CODE")=CODE
 ....S ^DWRSET(RSPRT,MC,"REVN")=OX
 ....S FLCNT=$L(FLDLST,",")
 ....S FV=""
 ....F I=1:1:FLCNT D
 .....S TF=$P(FLDLST,",",I)
 .....S FV=FV_$G(^DWORMS(OB,TF,OX,BLKTYPE))_"^~"
 ....S ^DWRSMETA(RSPRT,"FIELDNAMES")=FLDLST
 ....S ^DWRSET(RSPRT,MC,"FIELDS")=FV
 ....S ^DWRSMETA(RSPRT,"SBLOCKTYPE")=BLKTYPE
 ....S ^DWRSMETA(RSPRT,"LBLOCKTYPE")=LBLKTYPE
 Q RSPRT

RSLVFREF(CLASOID,FIELD,REV,BLKTYPE)
 W $L(FIELD,".")
 Q

EQ(V1,V2)
 I V1=V2 Q 1
 Q 0

NEQ(V1,V2)
 I V1'=V2 Q 1
 Q 0

CN(V1,V2)
 I V1[V2 Q 1
 Q 0

NCN(V1,V2)
 I V1'[V2 Q 1
 Q 0

LT(V1,V2)
 I V1<V2 Q 1
 Q 0

GT(V1,V2)
 I V1>V2 Q 1
 Q 0

GE(V1,V2)
 I (V1=V2)!(V1>V2) Q 1
 Q 0

LE(V1,V2)
 I (V1=V2)!(V1<V2) Q 1
 Q 0

CEQ(V1,V2)
 I (V1[V2)!(V1=V2) Q 1
 Q 0
