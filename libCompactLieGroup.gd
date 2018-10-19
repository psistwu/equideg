# # GAP: Compact Lie Group Library
#
# Declaration file of libCompactLieGroup.g
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#


# ### GlobalVariable
  DeclareGlobalVariable( "WORKABLE_ECLGs", "list of fully-functional ECLGs" );


# ### category(s)
  DeclareCategory( "IsCompactLieGroup", IsGroup );
  DeclareCategory( "IsElementaryCompactLieGroup", IsCompactLieGroup );


# ### representation(s)
  DeclareRepresentation( "IsCompactLieGroupRep", IsComponentObjectRep and IsAttributeStoringRep, [ ] );
  DeclareRepresentation( "IsCompactLieGroupCCSRep", IsComponentObjectRep and IsAttributeStoringRep and IsConjugacyClassSubgroupsRep, [ ] );
  DeclareRepresentation( "IsCompactLieGroupCCSsRep", IsComponentObjectRep and IsAttributeStoringRep, [ ] );
  DeclareRepresentation( "IsElementaryCompactLieGroupCCSRep", IsCompactLieGroupCCSRep, [ ] );
  DeclareRepresentation( "IsElementaryCompactLieGroupCCSsRep", IsCompactLieGroupCCSsRep, [ ] );


# ### constructor(s)
  DeclareConstructor( "NewElementaryCompactLieGroup", [ IsGroup, IsPosInt ] );
  DeclareConstructor( "NewCCS", [ IsCompactLieGroupCCSsRep, IsRecord, IsInt ] );


# ### attribute(s)
  DeclareAttribute( "IdECLG", IsElementaryCompactLieGroup );
  DeclareAttribute( "UnderlyingGroup", IsCompactLieGroupCCSsRep );
  DeclareAttribute( "IdCCS", IsCompactLieGroupCCSRep );
  DeclareAttribute( "CCSClasses", IsCompactLieGroupCCSsRep );
  DeclareAttribute( "CCSClassesFiltered", IsCompactLieGroupCCSsRep );
  DeclareAttribute( "CCSId", IsCompactLieGroupCCSsRep );


# ### property(s)
  DeclareProperty( "IsZeroModeCCS", IsCompactLieGroupCCSRep );


# ### operation(s)
  DeclareOperation( "OrthogonalGroupOverReal", [ IsPosInt ] );
  DeclareOperation( "SpecialOrthogonalGroupOverReal", [ IsPosInt ] );
  DeclareOperation( "ECLGId", [ IsList ] );

