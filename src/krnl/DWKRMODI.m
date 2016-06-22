DWKRMODI ;PICASSO/JOLLIS - INSTALL MODULE;9/13/10;src/krnl/DWKRMODI.m
;;3.0;KRNL;9/13/10;1
;; $Id: DWKRMODI.m 4 2010-10-24 17:30:25Z jollis $
 S CMD=$P($ZCMD," ",1)
 S MOD=$P($ZCMD," ",2)
 S MOD=$P(MOD,".",1) ; strip off the .m
 I CMD="-I" D INSTALL^DWKRMODI(MOD)
 I CMD="-R" D REMOVE^DWKRMODI(MOD)
 I CMD="-V" D MODINFO^DWKRMODI(MOD)
 Q

;;PDOC
;;SUMMARY Installs a kernel module into a Prefiniti instance
;;DEFSUB
INSTALL(MODULE)
;;ARG 1 MODULE The module to be installed
;;PDOC/
 I $$QRYMOD^DWKRMODI(MODULE)=1 Q
 W "KRNL:  INSTALLING MODULE ",MODULE,!
 S REGCMD="D REGISTER^"_MODULE
 X REGCMD
 S ^DWMODL(MODULE)="INSTALLED"
 Q

;;PDOC
;;SUMMARY Removes a kernel module from this instance
;;DEFSUB
REMOVE(MODULE)
;;ARG 1 MODULE The module to be removed
;;PDOC/
 I $$QRYMOD^DWKRMODI(MODULE)=0 Q
 W "KRNL:  REMOVING MODULE ",MODULE,!
 S UNREGCMD="D UNREGSTR^"_MODULE
 X REGCMD
 S ^DWMODL(MODULE)="REMOVED"
 Q

;;PDOC
;;SUMMARY Prints a module's info line
;;DEFSUB
MODINFO(MODULE)
;;ARG 1 MODULE The module for which to print the info line
;;PDOC/
 S INFOCMD="D MODINFO^"_MODULE
 X INFOCMD
 Q

;;PDOC
;;SUMMARY Prints a list of installed modules
;;DEFSUB
MODULES()
;;PDOC/
 S MOD=""
 S MODLIST=""
 F I=0:0 S MOD=$O(^DWMODL(MOD)) Q:MOD=""  D
 .S MODLIST=MODLIST_MOD_" "
 Q MODLIST

;;PDOC
;;SUMMARY Queries whether a module is installed
;;DEFFNC
QRYMOD(MODULE)
;;ARG 1 MODULE The module to be queried
;;PDOC/
 I $G(^DWMODL(MODULE))="INSTALLED" Q 1
 I $G(^DWMODL(MODULE))'="INSTALLED" Q 0
 Q 0
