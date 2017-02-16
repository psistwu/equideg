#-------
# GAP: Basic Group Theory Library
#-------
# Declaration file of libBasicGroupTheory.g
#
# Author: Hao-pin Wu <hxw132130@utdallas.edu>
# Last update:  2016-11-24
#-------

#-----
# global variable(s)
#-----

#-----
# attribute(s)
#-----

#---
# CCSubgroups
#---
  if IsReadOnlyGlobal( "CCSubgroups" ) then
    MakeReadWriteGlobal( "CCSubgroups" );
    MakeReadWriteGlobal( "SetCCSubgroups" );
    MakeReadWriteGlobal( "HasCCSubgroups" );
    UnbindGlobal( "CCSubgroups" );
    UnbindGlobal( "SetCCSubgroups" );
    UnbindGlobal( "HasCCSubgroups" );
  fi;
  DeclareAttribute( "CCSubgroups", IsGroup );
#---

#---
# CCSubgroups
#---
  if IsReadOnlyGlobal( "CCSubgroups" ) then
    MakeReadWriteGlobal( "CCSubgroups" );
    MakeReadWriteGlobal( "SetCCSubgroups" );
    MakeReadWriteGlobal( "HasCCSubgroups" );
    UnbindGlobal( "CCSubgroups" );
    UnbindGlobal( "SetCCSubgroups" );
    UnbindGlobal( "HasCCSubgroups" );
  fi;
  DeclareAttribute( "CCSubgroups", IsGroup );
#---

#-----
# property(s)
#-----

#-----
# method(s)
#-----

#-----
# function(s)
#-----

#---
# pCyclicGroup
#---
  if IsBound( pCyclicGroup ) then
    Unbind( pCyclicGroup );
  fi;
#---

#---
# pDihedralGroup
#---
  if IsBound( pDihedralGroup ) then
    Unbind( pDihedralGroup );
  fi;
#---

#---
# idCCS
#---
  if IsBound( idCCS ) then
    Unbind( idCCS );
  fi;
#---

#---
# isSubgroupUptoConjugacy
#---
  if IsBound( isSubgroupUptoConjugacy ) then
    Unbind( isSubgroupUptoConjugacy );
  fi;
#---

#---
# nLHnumber
#---
  if IsBound( nLHnumber ) then
    Unbind( nLHnumber );
  fi;
#---

#---
# removeExtraConjugateCopy
#---
  if IsBound( removeExtraConjugateCopy ) then
    Unbind( removeExtraConjugateCopy );
  fi;
#---

