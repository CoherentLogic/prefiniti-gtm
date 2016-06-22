DWORHOOK ;PICASSO/JOLLIS - ORMS HOOK SUPPORT;9/12/10;src/orms/ORMSHOOK.m
;;3.0;ORMS;9/12/10;1
;; $Id: DWORHOOK.m 4 2010-10-24 17:30:25Z jollis $

;;PDOC
;;SUMMARY Register a new ORMS class hook
;;DEFSUB
REGISTER(MODULE,CLASNAME,EVNTMASK,CALLBACK)
;;ARG 1 MODULE The kernel module to which the hook belongs
;;ARG 2 CLASNAME The class name we are hooking
;;ARG 3 EVNTMASK Format "CRD" C=Create,R=Revise,D=Delete 1 for true, 0 for false
;;ARG 4 CALLBACK The MUMPS routine to be called when the hook is run
;;PDOC/
 ;;W "REGISTERING HOOK ",CALLBACK," FOR CLASS ",CLASNAME
 S HOOKID=$$GETNEXT^DWKRFUID()
 TS
 S ^DWHOOKS(MODULE,CLASNAME,HOOKID)=CALLBACK
 S ^DWHOOKS(MODULE,CLASNAME,HOOKID,"EVNTMASK")=EVNTMASK
 TC
 Q

;;PDOC
;;SUMMARY Run hooks for CLASNAME on OID
;;DEFSUB
RUNHOOKS(CLASNAME,EVTYPE,OID,KEY,REVN,DATA)    
;;ARG 1 CLASNAME Class name
;;ARG 2 EVTYPE CREATE, REVISE, DELETE
;;ARG 3 OID The record's OID
;;ARG 4 KEY The key of the updated field
;;ARG 5 REVN The revision number
;;ARG 6 DATA The new data
;;PDOC/
   S (CH,HL,NS)=""
   F I=0:0 S CH=$O(^DWHOOKS(CH)) Q:CH=""  D GI
   Q
GI F I=0:0 S NS=$O(^DWHOOKS(CH,NS)) Q:NS=""  D GH
   Q
GH F I=0:0 S HL=$O(^DWHOOKS(CH,NS,HL)) Q:HL=""  D
   .S BASEROUT=^DWHOOKS(CH,NS,HL)
   .S EVMASK=^DWHOOKS(CH,NS,HL,"EVNTMASK")  
   .I EVTYPE="CREATE" D
   ..I $E(EVMASK,1)="1" D
   ...J DOHOOK^DWORHOOK(BASEROUT,EVTYPE,OID,KEY,REVN,DATA)
   .I EVTYPE="REVISE" D
   ..I $E(EVMASK,2)="1" D
   ...J DOHOOK^DWORHOOK(BASEROUT,EVTYPE,OID,KEY,REVN,DATA)
   .I EVTYPE="DELETE" D
   ..I $E(EVMASK,3)="1" D
   ...J DOHOOK^DWORHOOK(BASEROUT,EVTYPE,OID,KEY,REVN,DATA)
   Q

;;PDOC
;;SUMMARY Internal subroutine called by RUNHOOKS^DWORHOOK
;;DEFSUB
DOHOOK(BASEROUT,EVTYPE,OID,KEY,REVN,DATA)
;;PDOC/
 TS
 S ^DWORSTAT("HOOKSRUN")=^DWORSTAT("HOOKSRUN")+1
 TC
 S RS=""
 S RS="D "_BASEROUT_"("""_EVTYPE_""","""_OID_""","""_KEY_""","_REVN_","""_DATA_""")"
 X RS
 Q
