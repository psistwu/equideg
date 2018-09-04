# # GAP: Direct Product Library
#
# Declaration file of libDirectProduct.g
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#


# ## attribute(s)
  DeclareAttribute( "DirectProductComponents", IsGroup );
  DeclareAttribute( "SubgroupDirectProductInfo", IsGroup and HasParentAttr );
  DeclareAttribute( "AmalgamationQuadruple", IsConjugacyClassSubgroupsRep );
  DeclareAttribute( "DirectProductDecomposition", IsConjugacyClassGroupRep );
  DeclareAttribute( "DirectProductDecomposition", IsCharacter );


# ## operation(s)
  DeclareOperation( "DirectProductDecomposition",
      [ IsGroup, IsMultiplicativeElementWithInverse and IsAssociativeElement ] );
  DeclareOperation( "AmalgamationNotation", [ IsConjugacyClassSubgroupsRep ] );
