# # GAP: Compact Lie Group Library
#
# Declaration file of libCompactLieGroup.g
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#


# ### category(s)
  DeclareCategory( "IsCompactLieGroup", IsGroup );
  DeclareCategory( "IsOrthogonalGroupOverReal", IsCompactLieGroup and IsMatrixGroup );
  DeclareCategory( "IsSpecialOrthogonalGroupOverReal", IsCompactLieGroup and IsMatrixGroup );


# ### representation(s)
  DeclareRepresentation( "IsCompactLieGroupRep", IsComponentObjectRep and IsAttributeStoringRep, [ ] );
  DeclareRepresentation( "IsCompactLieGroupCCSRep", IsComponentObjectRep and IsAttributeStoringRep and IsConjugacyClassSubgroupsRep, [ ] );
  DeclareRepresentation( "IsCompactLieGroupCCSsRep", IsComponentObjectRep and IsAttributeStoringRep, [ ] );


# ### constructor(s)
  DeclareConstructor( "NewCompactLieGroup", [ IsCompactLieGroup and IsCompactLieGroupRep, IsPosInt ] );
  DeclareConstructor( "NewCCS", [ IsCompactLieGroupCCSRep, IsRecord, IsInt ] );


# ### attribute(s)
  DeclareAttribute( "UnderlyingGroup", IsCompactLieGroupCCSsRep );
  DeclareAttribute( "IdCCS", IsCompactLieGroupCCSRep );
  DeclareAttribute( "CCSClasses", IsCompactLieGroupCCSsRep );
  DeclareAttribute( "CCSId", IsCompactLieGroupCCSsRep );


# ### property(s)
  DeclareProperty( "IsZeroModeCCS", IsCompactLieGroupCCSRep );


# ### operation(s)
  DeclareOperation( "OrthogonalGroupOverReal", [ IsPosInt ] );
  DeclareOperation( "SpecialOrthogonalGroupOverReal", [ IsPosInt ] );


# ### global function(s)
  DeclareGlobalFunction( "CCSTypesFiltered" );

