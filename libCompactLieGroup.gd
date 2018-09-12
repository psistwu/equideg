# # GAP: Compact Lie Group Library
#
# Declaration file of libCompactLieGroup.g
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#


# ### category(s)
  DeclareCategory( "IsOrthogonalGroupOverReal", IsGroup );
  DeclareCategory( "IsSpecialOrthogonalGroupOverReal", IsGroup );
  DeclareCategory( "IsOrthogonalGroupOverRealCCSs", IsCollection );
  DeclareCategory( "IsSpecialOrthogonalGroupOverRealCCSs", IsCollection );


# ### representation(s)
  DeclareRepresentation( "IsCompactLieGroupRep", IsComponentObjectRep and IsAttributeStoringRep, [ ] );
  DeclareRepresentation( "IsCompactLieGroupCCSsRep", IsComponentObjectRep and IsAttributeStoringRep, [ ] );


# ### constructor(s)
  DeclareConstructor( "NewCompactLieGroup", [ IsCompactLieGroupRep, IsPosInt ] );


# ### attribute(s)
  DeclareAttribute( "UnderlyingGroup", IsCompactLieGroupCCSsRep );
  DeclareAttribute( "IdCCS", IsConjugacyClassSubgroupsRep );


# ### operation(s)
  DeclareOperation( "OrthogonalGroupOverReal", [ IsPosInt ] );
  DeclareOperation( "SpecialOrthogonalGroupOverReal", [ IsPosInt ] );
  DeclareOperation( "\[\]", [ IsCompactLieGroupCCSsRep, IsPosInt ] );
  DeclareOperation( "CCSId", [ IsCompactLieGroupCCSsRep, IsList ] );
# DeclareOperation( "Position", [ IsCompactLieGroupCCSsRep, IsObject ] );

