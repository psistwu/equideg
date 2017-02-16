#-------
# GAP: Extended System Library
#-------
# Declaration file of libSys.g
#
# Author: Hao-pin Wu <hxw132130@utdallas.edu>
# Last update:  2016-11-24
#-------

#-----
# global variable(s)
#-----
  if IsReadOnlyGlobal( "MSGLEVEL" ) then
    MakeReadWriteGlobal( "MSGLEVEL" );
    UnbindGlobal( "MSGLEVEL" );
  fi;
  MSGLEVEL := 3;
  MakeReadOnlyGlobal( "MSGLEVEL" );

#-----
# attribute(s)
#-----

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
# SetMsgLevel
#---
  if IsBound( SetMsgLevel ) then
    Unbind( SetMsgLevel );
  fi;
#---

