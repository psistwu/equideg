# # GAP: Compact Lie Group Library
#
# Declaration file of libCompactLieGroup.g
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#


# ### representation(s)
  DeclareRepresentation( "IsCompactLieGroupRep", IsComponentObjectRep and IsAttributeStoringRep, [ ] );
  DeclareRepresentation( "IsOrthogonalGroupOverRealRep", IsCompactLieGroupRep, [ ] );
  DeclareRepresentation( "IsSpecialOrthogonalGroupOverRealRep", IsCompactLieGroupRep, [ ] );
  DeclareRepresentation( "IsCompactLieGroupCCSRep", IsComponentObjectRep and IsAttributeStoringRep and IsConjugacyClassSubgroupsRep, [ ] );
  DeclareRepresentation( "IsCompactLieGroupCCSsRep", IsComponentObjectRep and IsAttributeStoringRep, [ ] );


# ### constructor(s)
  DeclareConstructor( "NewCompactLieGroup", [ IsCompactLieGroupRep, IsPosInt ] );


# ### operation(s)
  DeclareOperation( "OrthogonalGroupOverReal", [ IsPosInt ] );
  DeclareOperation( "SpecialOrthogonalGroupOverReal", [ IsPosInt ] );

