DWORMETA ;PICASSO/JOLLIS - ORMS META STREAM SUPPORT;9/15/10;src/orms/ORMSMETA.m
;;3.0;ORMS;9/15/10;1
;; $Id: DWORMETA.m 4 2010-10-24 17:30:25Z jollis $

;;PDOC
;;SUMMARY Create/set meta stream STREAM at position POS to VAL on OID
;;DEFSUB
SET(OID,KEY,STREAM,POS,VAL)
;;ARG 1 OID The OID of the record to attach to
;;ARG 2 KEY The key of the record to attach to
;;ARG 3 STREAM The metadata stream's name
;;ARG 4 POS The numeric index of this stream element
;;ARG 5 VAL The value of STREAM at POS
;;PDOC/
 S ^DWORMS(OID,KEY,"MTA",STREAM,POS)=VAL
 Q

;;PDOC
;;SUMMARY Get meta stream STREAM at position POS on OID
;:DEFFCN
GET(OID,KEY,STREAM,POS)
;;ARG 1 OID The OID of the record to read from
;;ARG 2 KEY The key of the record to read stream from
;;ARG 3 STREAM The metadata stream's name
;;ARG 4 POS The numeric index of this stream element
;;PDOC/
 Q ^DWORMS(OID,KEY,"MTA",STREAM,POS)


