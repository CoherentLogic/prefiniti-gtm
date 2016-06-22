DWCLWTCH ;PICASSO/JOLLIS - CLASS WATCHER;9/13/10;src/mods/CLASWTCH.m
;;3.0;MODS;9/13/10;1
;; $Id: DWCLWTCH.m 4 2010-10-24 17:30:25Z jollis $

;;PDOC
;;SUMMARY Register this module with the instance
;;DEFSUB
REGISTER
;;PDOC/
 I $$QRYMOD^DWKRMODI("CLASWTCH")=1 Q 
 D REGISTER^DWORHOOK("CLASWTCH","CLASDEFN","100","CLSCREAT^DWCLWTCH")
 D REGISTER^DWORHOOK("CLASWTCH","CLASDEFN","010","CLSREVIS^DWCLWTCH")
 Q

;;PDOC
;;SUMMARY Unregister this module with the instance
;;DEFSUB
UNREGSTR
;;PDOC/
 I $$QRYMOD^DWKRMODI("CLASWTCH")=0 Q
 Q

;;PDOC
;;SUMMARY Print the info line for this module
;;DEFSUB
MODINFO
;;PDOC/
 W "Compiles/Recompiles ORMS classes when they are created or revised.",!
 Q

;;PDOC
;;SUMMARY Fires when any class is created
;;DEFSUB
CLSCREAT(EVTYPE,OID,KEY,REVN,DATA)
;;ARG 1 EVTYPE The event type
;;ARG 2 OID The record's OID
;;ARG 3 KEY The key
;;ARG 4 REVN The revision of the record
;;ARG 5 DATA The PDB of the record
;;PDOC/
 D CLSCOMP^DWCLWTCH(OID,REVN)
 Q

;;PDOC
;;SUMMARY Fires when any class is revised
;;DEFSUB
CLSREVIS(EVTYPE,OID,KEY,REVN,DATA)
;;ARG 1 EVTYPE The event type
;;ARG 2 OID The record's OID
;;ARG 3 KEY The key
;;ARG 4 REVN The revision of the record
;;ARG 5 DATA The PDB of the record
;;PDOC/
 D CLSCOMP^DWCLWTCH(OID,REVN)
 Q

;;PDOC
;;SUMMARY Runs form generation for the class and compiles the EWD pages
;;DEFSUB
CLSCOMP(OID,REVN)
;;ARG 1 OID The object's OID
;;ARG 2 REVN The revision of the object
;;PDOC/
 S CLSNAME=$$INPUT^DWORREC(OID,"CLASNAME",$$NEWEST^DWORREC(OID,"CLASNAME"))
 S FNAME="/A-"_CLSNAME_"-"_REVN
 S FEXT=".ewd"
 W "CLASWTCH:  RECOMPILING FORMS FOR ",CLSNAME,";",REVN,!
 S TARGET=^DWPREF("EWDROOT")_FNAME_FEXT
 D COMPILE^DWFGBLD(CLSNAME,REVN,"ADD",TARGET)
 W "CLASWTCH:  RECOMPILING EWD DESIGN PAGE ",TARGET,!
 D compilePage^%zewdAPI("prefiniti",FNAME)
 Q