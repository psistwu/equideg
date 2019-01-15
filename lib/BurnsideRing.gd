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
#C  IsBurnsideRingByFiniteGroupElement
##
  DeclareCategory( "IsBurnsideRingByFiniteGroupElement",
      IsBurnsideRingElement );

#############################################################################
##
#C  IsBurnsideRingByCompactLieGroupElement
##
  DeclareCategory( "IsBurnsideRingByCompactLieGroupElement",
      IsBurnsideRingElement );

#############################################################################
##
#V  BurnsideRingElementCategoryList
##
  DeclareGlobalVariable( "EquiDeg_BRNG_ELMT_CAT_LIST" );
  InstallValue( EquiDeg_BRNG_ELMT_CAT_LIST,
      [ IsBurnsideRingByFiniteGroupElement,
        IsBurnsideRingByCompactLieGroupElement ] );

#############################################################################
##
#R  IsBurnsideRingElementRep
##
##  <#GAPDoc Label="IsBurnsideRingElementRep">
##  <ManSection>
##  <Filt Type="representation" Name="IsBurnsideRingElementRep"/>
##  <Description>
##    This is the representation of element in Burnside ring.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareRepresentation( "IsBurnsideRingElementRep",
      IsComponentObjectRep and IsAttributeStoringRep,
      [ "ccsList", "ccsIdList", "coeffList" ] );

#############################################################################
##
#U  NewBurnsideRingElement( IsBurnsideRingElement, <r> )
##
  DeclareConstructor( "NewBurnsideRingElement",
      [ IsBurnsideRingElement, IsRecord ] );

#############################################################################
##
#P  IsBurnsideRingGenerator( <a> )
##
  DeclareProperty( "IsBurnsideRingGenerator", IsBurnsideRingElement );
  InstallImmediateMethod( IsBurnsideRingGenerator,
    "indicate whether a Burnside ring element is a generator",
    IsBurnsideRingElement,
    0,
    a -> a!.coeffList = [ 1 ]
  );

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
  DeclareOperation( "ToDenseList", [ IsBurnsideRingByFiniteGroupElement ] );

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
#C  IsBurnsideRingByFiniteGroup
##
##  <#GAPDoc Label="IsBurnsideRingByFiniteGroup">
##  <ManSection>
##  <Filt Type="category" Name="IsBurnsideRingByFiniteGroup"/>
##  <Description>
##    This is the category of Burnside ring induced by a finite group.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareCategory( "IsBurnsideRingByFiniteGroup",
      IsBurnsideRing and
      CategoryCollections( IsBurnsideRingByFiniteGroupElement ) );

#############################################################################
##
#C  IsBurnsideRingByCompactLieGroup
##
  DeclareCategory( "IsBurnsideRingByCompactLieGroup",
      IsBurnsideRing and
      CategoryCollections( IsBurnsideRingByCompactLieGroupElement ) );

#############################################################################
##
#U  NewBurnsideRing( IsBurnsideRing, <r> )
##
##  <#GAPDoc Label="NewBurnsideRing">
##  <ManSection>
##  <Constr Name="NewBurnsideRing" Arg="filt, r"/>
##  <Description>
##    constructs a Burnside ring object induced by group <A>r.group</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareConstructor( "NewBurnsideRing", [ IsBurnsideRing, IsRecord ] );

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

#############################################################################
##
#P  IsBurnsideRingByCompactLieGroupBasis
##
  DeclareProperty( "IsBurnsideRingByCompactLieGroupBasis",
      CategoryCollections( IsBurnsideRingByCompactLieGroupElement ) );

#############################################################################
##
#U  NewBurnsideRingByCompactLieGroupBasis(
#U      IsBurnsideRingByCompactLieGroupElement, <r> )
##
  DeclareConstructor( "NewBurnsideRingByCompactLieGroupBasis",
      [ IsBurnsideRingByCompactLieGroup, IsRecord ] );


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
  DeclareAttribute( "BasicDegree", IsVirtualCharacter );
  DeclareAttribute( "BasicDegree", IsCompactLieGroupVirtualCharacter );


#############################################################################
##
#E  BurnsideRing.gd . . . . . . . . . . . . . . . . . . . . . . . . ends here
