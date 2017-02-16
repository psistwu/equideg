#-------
# GAP: Lattice of Orbit Types Library
#-------
# Declaration file of libLatticeOrbitTypes.g
#
# Author: Hao-pin Wu <hxw132130@utdalls.edu>
# Last update: 2016-12-15
#-------

#-----
# global variable(s)
#-----

#-----
# attribute(s)
#-----

#---
# OrbitTypes
#---
  if IsReadOnlyGlobal( "OrbitTypes" ) then
    MakeReadWriteGlobal( "OrbitTypes" );
    MakeReadWriteGlobal( "SetOrbitTypes" );
    MakeReadWriteGlobal( "HasOrbitTypes" );
    UnbindGlobal( "OrbitTypes" );
    UnbindGlobal( "SetOrbitTypes" );
    UnbindGlobal( "HasOrbitTypes" );
  fi;
  DeclareAttribute( "OrbitTypes", IsCharacter );
#---

#---
# AlphaCharacteristic
#---
  if IsReadOnlyGlobal( "AlphaCharacteristic" ) then
    MakeReadWriteGlobal( "AlphaCharacteristic" );
    MakeReadWriteGlobal( "SetAlphaCharacteristic" );
    MakeReadWriteGlobal( "HasAlphaCharacteristic" );
    UnbindGlobal( "AlphaCharacteristic" );
    UnbindGlobal( "SetAlphaCharacteristic" );
    UnbindGlobal( "HasAlphaCharacteristic" );
  fi;
  DeclareAttribute( "AlphaCharacteristic", IsCharacter );
#---

#---
# LatticeOrbitTypes
#---
  if IsReadOnlyGlobal( "LatticeOrbitTypes" ) then
    MakeReadWriteGlobal( "LatticeOrbitTypes" );
    MakeReadWriteGlobal( "SetLatticeOrbitTypes" );
    MakeReadWriteGlobal( "HasLatticeOrbitTypes" );
    UnbindGlobal( "LatticeOrbitTypes" );
    UnbindGlobal( "SetLatticeOrbitTypes" );
    UnbindGlobal( "HasLatticeOrbitTypes" );
  fi;
  DeclareAttribute( "LatticeOrbitTypes", IsCharacter );
#---

#-----
# property(s)
#-----

#---
# IsAGroup
#---
  if IsReadOnlyGlobal( "IsAGroup" ) then
    MakeReadWriteGlobal( "IsAGroup" );
    MakeReadWriteGlobal( "SetIsAGroup" );
    MakeReadWriteGlobal( "HasIsAGroup" );
    UnbindGlobal( "IsAGroup" );
    UnbindGlobal( "SetIsAGroup" );
    UnbindGlobal( "HasIsAGroup" );
  fi;
  DeclareAttribute( "IsAGroup", IsGroup );
#---

#-----
# operation(s)
#-----

#---
# DimensionOfFixedSet
#---
  if IsReadOnlyGlobal( "DimensionOfFixedSet" ) then
    MakeReadWriteGlobal( "DimensionOfFixedSet" );
    UnbindGlobal( "DimensionOfFixedSet" );
  fi;
  DeclareOperation( "DimensionOfFixedSet", [ IsCharacter, IsGroup ] );
  DeclareOperation( "DimensionOfFixedSet", [ IsCharacter, IsConjugacyClassSubgroupsRep] );
#---

#-----
# function(s)
#-----

