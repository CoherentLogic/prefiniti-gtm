DWORINST ;PICASSO/JOLLIS - INSTALL ORMS CLASS DEF;9/18/10;src/orms/ORMSINST.m
;;3.0;ORMS;9/18/10;1
;; $Id: DWORINST.m 4 2010-10-24 17:30:25Z jollis $
 S INFILE=$ZCMD
 D COMPILE^DWORINST(INFILE)
 Q

;;PDOC
;;SUMMARY Compile an external CLASDEFN into ORMS-native format
;;DEFSUB
COMPILE(FH)
;;ARG 1 FH The file to compile
;;PDOC/
 W !,"Prefiniti 3.0",!
 W " Object Record Management System Class Compiler",!
 W !,!,"Copyright (C) 2010 Coherent Logic Development LLC",!
 W !,"This program is licensed under the terms of the",!
 W "GNU Affero General Public License v3. See file COPYING",!
 W "in the root of your Prefiniti installation for details.",!,!,!
 W "Compiling file:  ",FH,!
 O FH:(readonly)
 U FH:exception="GOTO FILEDONE"
 S PD=":"
 S LD="#"
 S PDB=""
 S LTYP=""
 F  R LN D
 .I $E(LN,1,2)'=";;" D ; ignore comments
 ..I $L(LN,":")=4 S LTYP="HDR"
 ..I $L(LN,":")=6 S LTYP="FLD"
 ..I LTYP="HDR" D
 ...S CLASNAME=$P(LN,PD,1)
 ...S PK=$P(LN,PD,4)
 ...S PDB=PDB_LN_LD
 ..I LTYP="FLD" D
 ...S PDB=PDB_LN_LD
FILEDONE
 U 0
 S NEWCLS=1
 I $$RETRIEVE^DWORCLAS(CLASNAME)'="" S NEWCLS=0
 I NEWCLS=1 D
 .S CID=$$CREATE^DWORCLAS(CLASNAME,PDB)
 .D SETPK^DWORCLAS(CLASNAME,PK)
 I NEWCLS=0 D 
 .S OID=$$RETRIEVE^DWORCLAS(CLASNAME)
 .D UPDATE^DWORCLAS(OID,PDB)
 Q
