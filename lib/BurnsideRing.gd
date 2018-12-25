#############################################################################
##
#W  BurnsideRing.gd	GAP Package `EquiDeg'			    Haopin Wu
##
#Y  Copyright (C) 2017-2018, Haopin Wu
#Y  Department of Mathematics, National Tsing Hua University, Taiwan
##
##  This file contains declarations for procedures related to Burnside ring.
##

##  Part 1: Burnside Ring Element

#############################################################################
##
#C  IsBurnsideRingElement
##
##  <#GAPDoc Label="IsBurnsideRingElement">
##  <ManSection>
##  <Filt Type="category" Name="IsBurnsideRingElement"/>
##  <Description>
##    This is the category of element in a Burnside ring.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareCategory( "IsBurnsideRingElement",
      IsRingElementWithOne and IsExtLElement );

#############################################################################
##
#R  IsBurnsideRingBySmallGroupElementRep
##
##  <#GAPDoc Label="IsBurnsideRingBySmallGroupElementRep">
##  <ManSection>
##  <Filt Type="representation" Name="IsBurnsideRingBySmallGroupElementRep"/>
##  <Description>
##    This is the representation of element in Burnside ring
##    induced by a small group.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareRepresentation( "IsBurnsideRingBySmallGroupElementRep",
      IsComponentObjectRep and IsAttributeStoringRep,
      [ "ccss", "ccsIndices", "coefficients" ] );

#############################################################################
##
#A  Length( <a> )
##
##  <#GAPDoc Label="Length">
##  <ManSection>
##  <Attr Name="Length" Arg="a"/>
##  <Description>
##    This attribute of Burnside ring element <A>a</A>
##    contains the length of its summation representative.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareAttribute( "Length", IsBurnsideRingElement );

#############################################################################
##
#O  ToDenseList( <a> )
##
##  <#GAPDoc Label="ToDenseList">
##  <ManSection>
##  <Oper Name="ToDenseList" Arg="a"/>
##  <Description>
##    returns a dense list representing Burnside ring element <A>a</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareOperation( "ToDenseList", [ IsBurnsideRingElement ] );

#############################################################################
##
#O  ToSparseList( <a> )
##
##  <#GAPDoc Label="ToSparseList">
##  <ManSection>
##  <Oper Name="ToSparseList" Arg="a"/>
##  <Description>
##    returns a sparse list representing Burnside ring element <A>a</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareOperation( "ToSparseList", [ IsBurnsideRingElement ] );


##  Part 2: Brunside Ring

#############################################################################
##
#C  IsBurnsideRing
##
##  <#GAPDoc Label="IsBurnsideRing">
##  <ManSection>
##  <Filt Type="category" Name="IsBurnsideRing"/>
##  <Description>
##    This is the category of Burnside ring.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareCategory( "IsBurnsideRing",
      CategoryCollections( IsBurnsideRingElement ) and
      IsRingWithOne and
      IsFreeLeftModule );

#############################################################################
##
#R  IsBurnsideRingBySmallGroupRep
##
##  <#GAPDoc Label="IsBurnsideRingBySmallGroupRep">
##  <ManSection>
##  <Filt Type="representation" Name="IsBurnsideRingBySmallGroupRep"/>
##  <Description>
##    This is the representaiton of Burnside ring induced by a small group.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareRepresentation( "IsBurnsideRingBySmallGroupRep",
      IsComponentObjectRep and
      IsAttributeStoringRep, [ ] );

#############################################################################
##
#U  NewBurnsideRing( IsBurnsideRing, <G> )
##
##  <#GAPDoc Label="NewBurnsideRing">
##  <ManSection>
##  <Constr Name="NewBurnsideRing" Arg="filt, G"/>
##  <Description>
##    constructs a Burnside ring object induced by group <A>G</A>,
##    where <A>filt</A> should imply category
##    <Ref Filt="IsBurnsideRing"/>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareConstructor( "NewBurnsideRing",
      [ IsBurnsideRing, IsGroup ] );

#############################################################################
##
#A  BurnsideRing( <G> )
##
##  <#GAPDoc Label="BurnsideRing">
##  <ManSection>
##  <Attr Name="BurnsideRing" Arg="G"/>
##  <Description>
##    This attribute contains the Burnside ring induced by group <A>G</A>.
##    The returned Burnside ring admits attribute <C>UnderlyingGroup</C>,
##    by which one can retrieve <A>G</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareAttribute( "BurnsideRing", IsGroup );

#############################################################################
##
#A  UnderlyingGroup( <A> )
##
##  <#GAPDoc Label="UnderlyingGroup">
##  <ManSection>
##  <Attr Name="UnderlyingGroup" Arg="A"/>
##  <Description>
##    This attribute contains the underlying group of Burnside ring
##    <A>A</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareAttribute( "UnderlyingGroup", IsBurnsideRing );


##  Part 3: Other Aspects

#############################################################################
##
#A  BasicDegree( <chi> )
##
##  <#GAPDoc Label="BasicDegree">
##  <ManSection>
##  <Attr Name="BasicDegree" Arg="chi"/>
##  <Description>
##    This attribute contains the basic degree associated to character
##    <A>chi</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareAttribute( "BasicDegree", IsCharacter );


#############################################################################
##
#E  BurnsideRing.gd . . . . . . . . . . . . . . . . . . . . . . . . ends here
