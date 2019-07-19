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
##    This is an attribute of a Burnside ring element <A>a</A>
##    which stores the length of its summation form.
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
##    This operation returns a dense list represention of
##    Burnside ring element <A>a</A>.
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
##    This operation returns a sparse list represention of
##    Burnside ring element <A>a</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareOperation( "ToSparseList", [ IsBurnsideRingElement ] );

#############################################################################
##
#O  MaximalCCSs( <a> )
##
##  <#GAPDoc Label="MaximalCCSs">
##  <ManSection>
##  <Oper Name="MaximalOrbitTypes"
##      Arg="a"/>
##  <Description>
##    This operation returns the maximal CCSs in <A>a</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
  DeclareOperation( "MaximalCCSs", [ IsBurnsideRingElement ] );
  

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
##  constructs a Burnside ring object induced by group <A>r.group</A>.
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
##  This is an attribute of a group <A>G</A> which
##  contains the induced Burnside ring <E>A</E>.
##  The additive and multiplicative identities of <E>A</E>
##  are stored in attributes
##  <Ref BookName="Reference" Attr="ZeroImmutable"/>
##  and <Ref BookName="Reference" Attr="OneImmutable"/>,
##  respectively.
##  Here is an example of creating a Burnside ring
##  induced by a finite group and printing
##  its additive and multiplicative idenities.
##  <Example>
##  gap> G := SymmetricGroup( 4 );
##  Sym( [ 1 .. 4 ] )
##  gap> A := BurnsideRing( G );
##  Brng( Sym( [ 1 .. 4 ] ) )
##  gap> Zero(A);
##  &lt;&gt; in Brng( Sym( [ 1 .. 4 ] ) )
##  gap> One(A);
##  &lt;1(11)&gt; in Brng( Sym( [ 1 .. 4 ] ) )
##  </Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareAttribute( "BurnsideRing", IsGroup );

#############################################################################
##
#A  Basis( <A> )
##
##  <#GAPDoc Label="brng_Basis">
##  <ManSection>
##  <Attr Name="Basis" Label="Burnside ring" Arg="A"/>
##  <Description>
##  This is an attribute of a Burnside ring <A>A</A>
##  which stores its basis.
##  Here is an example of selecting certain element
##  in the basis of <A>A</A> induced by a finite group.
##  <Example>
##  gap> B := Basis( A );;
##  gap> b := B[2];
##  &lt;1(2)&gt; in Brng( Sym( [ 1 .. 4 ] ) )
##  </Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>

#############################################################################
##
#A  UnderlyingGroup( <A> )
##
##  <#GAPDoc Label="brng_UnderlyingGroup">
##  <ManSection>
##  <Attr Name="UnderlyingGroup" Label="Burnside ring" Arg="A"/>
##  <Description>
##    This is an attribute of a Burnside ring <A>A</A>
##    which contains the group <E>G</E> from which <A>A</A>
##    is induced.
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
##  This is an attribute of a character <A>chi</A>
##  which stores the associated basic degree.
##  Here is an example.
##  <Example>
##  gap> G := SymmetricGroup(4);;
##  gap> chi := Irr(G)[3];
##  Character( CharacterTable( Sym( [ 1 .. 4 ] ) ), [ 2, 0, 2, -1, 0 ] )
##  gap> BasicDegree(chi);
##  &lt;1(5)-2(9)+1(11)&gt; in Brng( Sym( [ 1 .. 4 ] ) )
##  </Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareAttribute( "BasicDegree", IsVirtualCharacter );
  DeclareAttribute( "BasicDegree", IsCompactLieGroupVirtualCharacter );


#############################################################################
##
#E  BurnsideRing.gd . . . . . . . . . . . . . . . . . . . . . . . . ends here
