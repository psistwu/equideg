# # GAP: Compact Lie Group Library
#
# Declaration file of libCompactLieGroupDirectProduct.g
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#


# ### category(s)
  DeclareCategory( "IsDirectProductWithECLG", IsCompactLieGroup );


# ### representation(s)
  DeclareRepresentation( "IsDirectProductWithECLGCCSRep", IsCompactLieGroupCCSRep, [ ] );
  DeclareRepresentation( "IsDirectProductWithECLGCCSsRep", IsCompactLieGroupCCSsRep, [ ] );


# ### attribute(s)
  DeclareAttribute( "GoursatInfo", IsDirectProductWithECLGCCSRep );

