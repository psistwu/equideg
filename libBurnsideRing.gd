# # GAP: Burnside Ring Library
#
# Declaration file of libBurnsideRing.g
#
# Author(s):
#   Hao-pin Wu <psistwu@outlook.com>
#


# ## Part 1: Burnside Ring Element
# ### category(s)
  DeclareCategory( "IsBurnsideRingElement", IsRingElementWithOne and IsExtLElement );


# ### representation(s)
  DeclareRepresentation( "IsBurnsideRingBySmallGroupElementRep", IsComponentObjectRep and IsAttributeStoringRep, [ "CCSIndices", "coefficients" ] );


# ### attribute(s)
  DeclareAttribute( "Length", IsBurnsideRingElement );
  DeclareAttribute( "ToDenseList", IsBurnsideRingElement );
  DeclareAttribute( "ToSparseList", IsBurnsideRingElement );


# ### function(s)
# %%%
# DeclareGlobalFunction( "DuoListsToIndex" );
# DeclareGlobalFunction( "IndexToDuoLists" );


# ## Part 2: Brunside Ring
# ### category(s)
  DeclareCategory( "IsBurnsideRing", CategoryCollections( IsBurnsideRingElement ) and IsRingWithOne and IsFreeLeftModule );


# ### representation(s)
  DeclareRepresentation( "IsBurnsideRingBySmallGroupRep", IsComponentObjectRep and IsAttributeStoringRep, [ ] );


# ### constructor(s)
  DeclareConstructor( "NewBurnsideRing", [ IsBurnsideRing, IsGroup ] );


# ### attribute(s)
  DeclareAttribute( "BurnsideRing", IsGroup );
  DeclareAttribute( "UnderlyingGroup", IsBurnsideRing );


# ## Part 3: Other Aspects
# ### attribute(s)
  DeclareAttribute( "BasicDegree", IsCharacter );

