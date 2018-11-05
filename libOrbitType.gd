# # GAP: Orbit Types Library
#
# Declaration file of libOrbitType.g
#
# Author:
# Hao-pin Wu <psistwu@outlook.com>
#


# ### representation(s)
  DeclareRepresentation( "IsLatticeOrbitTypesRep", IsLatticeRep, [ ] );


# ### attribute(s)
  DeclareAttribute( "OrbitTypes", IsCharacter );
  DeclareAttribute( "MaximalOrbitTypes", IsCharacter );
  DeclareAttribute( "LatticeOrbitTypes", IsCharacter );
  DeclareAttribute( "AlphaCharacteristic", IsCharacter );


# ### property(s)
  DeclareProperty( "IsAGroup", IsGroup );


# ### operation(s)
  DeclareOperation( "DimensionOfFixedSet", [ IsCharacter, IsGroup ] );
  DeclareOperation( "DimensionOfFixedSet", [ IsCharacter, IsConjugacyClassSubgroupsRep] );

