#############################################################################
##
#W  OrbitType.gd	GAP Package `EquiDeg' 			    Haopin Wu
##
#Y  Copyright (C) 2017-2018, Haopin Wu
#Y  Department of Mathematics, National Tsing Hua University, Taiwan
##
##  This file contains declarations for procedure related to orbit types.
##

#############################################################################
##
#R  IsLatticeOrbitTypesRep
##
  DeclareRepresentation( "IsLatticeOrbitTypesRep", IsLatticeRep, [ ] );

#############################################################################
##
#A  OrbitTypes( <chi> )
##
  DeclareAttribute( "OrbitTypes", IsCharacter );

#############################################################################
##
#A  MaximalOrbitTypes( <chi> )
##
  DeclareAttribute( "MaximalOrbitTypes", IsCharacter );

#############################################################################
##
#A  LatticeOrbitTypes( <chi> )
##
  DeclareAttribute( "LatticeOrbitTypes", IsCharacter );

#############################################################################
##
#A  AlphaCharacteristic( <chi> )
##
  DeclareAttribute( "AlphaCharacteristic", IsCharacter );

#############################################################################
##
#P  IsAGroup( <grp> )
##
  DeclareProperty( "IsAGroup", IsGroup );

#############################################################################
##
#O  DimensionOfFixedSet( <chi>, <subg> )
#O  DimensionOfFixedSet( <chi>, <ccsubg> )
##
  DeclareOperation( "DimensionOfFixedSet", [ IsCharacter, IsGroup ] );
  DeclareOperation( "DimensionOfFixedSet", [ IsCharacter, IsConjugacyClassSubgroupsRep] );

#############################################################################
##
#E  LatticeAndOrbitType.gd . . . . . . . . . . . . . . . . . . . .  ends here
