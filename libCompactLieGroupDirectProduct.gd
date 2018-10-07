# # GAP: Compact Lie Group Library
#
# Declaration file of libCompactLieGroupDirectProduct.g
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#


# ### category(s)
  DeclareCategory( "IsDirectProductWithCompactLieGroup", IsCompactLieGroup );
  DeclareCategory( "IsDirectProductWithOrthogonalGroupOverReal", IsDirectProductWithCompactLieGroup );
  DeclareCategory( "IsDirectProductWithSpecialOrthogonalGroupOverReal", IsDirectProductWithCompactLieGroup );


# ### representation(s)
  DeclareRepresentation( "IsDirectProductWithCompactLieGroupRep", IsComponentObjectRep and IsAttributeStoringRep, [ ] );
  DeclareRepresentation( "IsDirectProductWithCompactLieGroupCCSRep", IsCompactLieGroupCCSRep and IsComponentObjectRep and IsAttributeStoringRep, [ ] );


# ### constructor(s)


# ### attribute(s)
  DeclareAttribute( "GoursatInfo", IsDirectProductWithCompactLieGroupCCSRep );


# ### operation(s)


# ### global function(s)

