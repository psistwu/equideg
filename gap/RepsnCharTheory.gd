#-------
# GAP: Representation and Character Theory Library
#-------
# Declaration file of libRepresentationCharacterTheory.g
#
# Author: Hao-pin Wu <hxw132130@utdallas.edu>
# Last update: 2016-11-27
#-------

#-----
# global variable(s)
#-----

#-----
# attribute(s)
#-----

#---
# SchurIndicator
#---
  if IsReadOnlyGlobal( "SchurIndicator" ) then
    MakeReadWriteGlobal( "SchurIndicator" );
    MakeReadWriteGlobal( "HasSchurIndicator" );
    MakeReadWriteGlobal( "SetSchurIndicator" );
    UnbindGlobal( "SchurIndicator" );
    UnbindGlobal( "HasSchurIndicator" );
    UnbindGlobal( "SetSchurIndicator" );
  fi;
  DeclareAttribute( "SchurIndicator", IsIrreducibleCharacter );
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

