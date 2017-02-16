#-------
# GAP: 2-transitive Group Library
#-------
# Declaration file of lib2transitiveGroup.g
#
# Author: Hao-pin Wu <hxw132130@utdallas.edu>
# Last update: 2016-11-24
#-------

#-----
# global variable(s)
#-----

#-----
# attribute(s)
#-----

#---
# 2transitivity
#---
  if IsReadOnlyGlobal( "2transitivity" ) then
    MakeReadWriteGlobal( "2transitivity" );
    MakeReadWriteGlobal( "Set2transitivity" );
    MakeReadWriteGlobal( "Has2transitivity" );
    UnbindGlobal( "2transitivity" );
    UnbindGlobal( "Set2transitivity" );
    UnbindGlobal( "Has2transitivity" );
  fi;
  DeclareAttribute( "2transitivity", IsGroup );
#---

#-----
# property(s)
#-----

#---
# Is2transitiveGroup
#---
  if IsReadOnlyGlobal( "Is2transitiveGroup" ) then
    MakeReadWriteGlobal( "Is2transitiveGroup" );
    MakeReadWriteGlobal( "SetIs2transitiveGroup" );
    MakeReadWriteGlobal( "HasIs2transitiveGroup" );
    UnbindGlobal( "Is2transitiveGroup" );
    UnbindGlobal( "SetIs2transitiveGroup" );
    UnbindGlobal( "HasIs2transitiveGroup" );
  fi;
  DeclareProperty( "Is2transitiveGroup", IsGroup );
#---

#-----
# operation(s)
#-----

#-----
# function(s)
#-----

