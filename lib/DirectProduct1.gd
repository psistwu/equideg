# # GAP: Direct Product Library
#
# Declaration file of libDirectProduct.g
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#


# ## Attribute(s)
  DeclareAttribute( "DirectProductComponents", IsGroup );
  DeclareAttribute( "GoursatInfo", IsGroup and HasParentAttr );
  DeclareAttribute( "DirectProductDecomposition", IsConjugacyClassGroupRep );
  DeclareAttribute( "DirectProductDecomposition", IsCharacter );


# ## Operation(s)
  DeclareOperation( "DirectProductDecomposition",
      [ IsGroup, IsMultiplicativeElementWithInverse ] );
  DeclareOperation( "AmalgamationSymbol",
      [ IsConjugacyClassSubgroupsRep ] );

