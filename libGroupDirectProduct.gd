#-------
# GAP: Group Direct Product Library
#-------
# Declaration file of libGroupDirectProduct.g
#
# Author: Hao-pin Wu <hxw132130@utdallas.edu>
# Last update: 2016-11-01
#-------

#-----
# global variable(s)
#-----

#-----
# attribute(s)
#-----

#---
  if IsReadOnlyGlobal( "SubgroupDirectProductInfo" ) then
    MakeReadWriteGlobal( "SubgroupDirectProductInfo" );
    MakeReadWriteGlobal( "SetSubgroupDirectProductInfo" );
    MakeReadWriteGlobal( "HasSubgroupDirectProductInfo" );
    UnbindGlobal( "SubgroupDirectProductInfo" );
    UnbindGlobal( "SetSubgroupDirectProductInfo" );
    UnbindGlobal( "HasSubgroupDirectProductInfo" );
  fi;
  DeclareAttribute( "SubgroupDirectProductInfo", IsGroup );
#---

#-----
# property(s)
#-----

#-----
# operation(s)
#-----

#-----
# function(s)
#-----

