LOGSUPT ;PICASSO/JOLLIS - SYSTEM LOG MODULE;9/14/10;src/mods/LOGSUPT.m
;;3.0;MODS;9/14/10;1
;; $Id: DWLGSUPT.m 4 2010-10-24 17:30:25Z jollis $

REGISTER
 I $$QRYMOD^DWKRMODI("LOGSUPT")=1 Q
 S CID=$$CREATE^DWORCLAS("SYSLOG","0")
 D REGISTER^DWORHOOK("LOGSUPT","SYSLOG","100","LOGCREAT^DWLGSUPT")
 D REGISTER^DWORHOOK("LOGSUPT","SYSLOG","010","LOGREVIS^DWLGSUPT")
 Q

UNREGSTR
 I $$QRYMOD^DWKRMODI("LOGSUPT")=0 Q
 Q

MODINFO
 W "Supports system logging features. Should be installed on every Prefiniti instance.",!
 Q

LOGCREAT(EVTYPE,OID,KEY,REVN,DATA)
 Q

LOGREVIS(EVTYPE,OID,KEY,REVN,DATA)
 Q