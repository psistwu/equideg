# # GAP: Burnside Ring Library
#
# Declaration file of libBurnsideRing.g
#
# Author(s):
#   Hao-pin Wu <psistwu@outlook.com>
#


# ## Part 1: Burnside Ring Element
# ### Category(s)
  DeclareCategory( "IsBurnsideRingElement",
      IsRingElementWithOne and IsExtLElement );


# ### Representation(s)
  DeclareRepresentation( "IsBurnsideRingBySmallGroupElementRep",
      IsComponentObjectRep and IsAttributeStoringRep,
      [ "CCSIndices", "coefficients" ] );


# ### Attribute(s)
  DeclareAttribute( "Length", IsBurnsideRingElement );
  DeclareAttribute( "ToDenseList", IsBurnsideRingElement );
  DeclareAttribute( "ToSparseList", IsBurnsideRingElement );



# ## Part 2: Brunside Ring
# ### Category(s)
  DeclareCategory( "IsBurnsideRing",
      CategoryCollections( IsBurnsideRingElement ) and IsRingWithOne and IsFreeLeftModule );


# ### Representation(s)
  DeclareRepresentation( "IsBurnsideRingBySmallGroupRep",
      IsComponentObjectRep and IsAttributeStoringRep, [ ] );


# ### Constructor(s)
  DeclareConstructor( "NewBurnsideRing",
      [ IsBurnsideRing, IsGroup ] );


# ### Attribute(s)
  DeclareAttribute( "BurnsideRing", IsGroup );
  DeclareAttribute( "UnderlyingGroup", IsBurnsideRing );



# ## Part 3: Other Aspects
# ### Attribute(s)
  DeclareAttribute( "BasicDegree", IsCharacter );

