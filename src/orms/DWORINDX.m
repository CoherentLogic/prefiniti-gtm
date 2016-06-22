DWORINDX ;JOLLIS/PICASSO - ORMS INDEX ROUTINES;9/23/10;src/orms/DWORINDX.m
;;3.0;ORMS;9/23/10;1
;; $Id: DWORINDX.m 4 2010-10-24 17:30:25Z jollis $

;;PDOC
;;SUMMARY Index a record by three terms
;;DEFSUB
SIDX3(PRILKP,SECLKP,TERLKP,VAL)
;;ARG 1 PRILKP The primary lookup term
;;ARG 2 SECLKP The secondary lookup term
;;ARG 3 TERLKP The tertiary lookup term
;;ARG 4 VAL The value to be indexed
;;PDOC/
 S ^DWIND(PRILKP,SECLKP,TERLKP)=VAL
 Q

;;PDOC
;;SUMMARY Lookup a record by three terms
;;DEFFNC
LIDX3(PRILKP,SECLKP,TERLKP)
;;ARG 1 PRILKP The primary lookup term
;;ARG 2 SECLKP The secondary lookup term
;;ARG 3 TERLKP The tertiary lookup term
;;PDOC/
 Q $G(^DWIND(PRILKP,SECLKP,TERLKP))