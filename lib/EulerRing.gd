#############################################################################
##
#W  EulerRing.gd	GAP Package `EquiDeg'			    Haopin Wu
##
#Y  Copyright (C) 2017-2022, Haopin Wu
##
##  This file contains declarations of procedures related to Euler ring.
##

##  Part 1: Euler ring element

#############################################################################
##
#C  IsEulerRingElement
##
##  <#GAPDoc Label="IsEulerRingElement">
##  <ManSection>
##  <Filt Type="category" Name="IsEulerRingElement" />
##  <Description>
##    This is the category of element in a Euler ring.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareCategory( "IsEulerRingElement",
      IsRingElementWithOne and IsExtLElement );

#############################################################################
##
#C  IsEulerRingByCompactLieGroupElement
##
  DeclareCategory( "IsEulerRingByCompactLieGroupElement",
      IsEulerRingElement );

#############################################################################
##
#V  EulerRingElementCategoryList
##
  DeclareGlobalVariable( "EquiDeg_ERNG_ELMT_CAT_LIST" );
  InstallValue( EquiDeg_ERNG_ELMT_CAT_LIST,
      [ IsEulerRingByCompactLieGroupElement ] );

#############################################################################
##
#R  IsEulerRingElementRep
##
##  <#GAPDoc Label="IsEulerRingElementRep">
##  <ManSection>
##  <Filt Type="representation" Name="IsEulerRingElementRep"/>
##  <Description>
##    This is the representation of element in Euler ring.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareRepresentation( "IsEulerRingElementRep",
      IsComponentObjectRep and IsAttributeStoringRep,
      [ "ccsList", "ccsIdList", "coeffList" ] );

#############################################################################
##
#U  NewEulerRingElement( IsEulerRingElement, <r> )
##
  DeclareConstructor( "NewEulerRingElement",
      [ IsEulerRingElement, IsRecord ] );

#############################################################################
##
#P  IsEulerRingGenerator( <a> )
##
  DeclareProperty( "IsEulerRingGenerator", IsEulerRingElement );
  InstallImmediateMethod( IsEulerRingGenerator,
    "indicate whether a Euler ring element is a generator",
    IsEulerRingElement,
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
##    This is an attribute of a Euler ring element <A>a</A>
##    which stores the length of its summation form.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareAttribute( "Length", IsEulerRingElement );

#############################################################################
##
#O  ToSparseList( <a> )
##
##  <#GAPDoc Label="ToSparseList">
##  <ManSection>
##  <Oper Name="ToSparseList" Arg="a"/>
##  <Description>
##    This operation returns a sparse list represention of
##    Euler ring element <A>a</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareOperation( "ToSparseList", [ IsEulerRingElement ] );

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
  DeclareOperation( "MaximalCCSs", [ IsEulerRingElement ] );


##  Part 2: Brunside Ring

#############################################################################
##
#C  IsEulerRing
##
##  <#GAPDoc Label="IsEulerRing">
##  <ManSection>
##  <Filt Type="category" Name="IsEulerRing"/>
##  <Description>
##    This is the category of Euler ring.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareCategory( "IsEulerRing",
      CategoryCollections( IsEulerRingElement ) and
      IsRingWithOne and
      IsFreeLeftModule );

#############################################################################
##
#C  IsEulerRingByCompactLieGroup
##
  DeclareCategory( "IsEulerRingByCompactLieGroup",
      IsEulerRing and
      CategoryCollections( IsEulerRingByCompactLieGroupElement ) );

#############################################################################
##
#U  NewEulerRing( IsEulerRing, <r> )
##
##  <#GAPDoc Label="NewEulerRing">
##  <ManSection>
##  <Constr Name="NewEulerRing" Arg="filt, r"/>
##  <Description>
##  constructs a Euler ring object induced by group <A>r.group</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareConstructor( "NewEulerRing", [ IsEulerRing, IsRecord ] );

#############################################################################
##
#A  EulerRing( <G> )
##
##  <#GAPDoc Label="EulerRing">
##  <ManSection>
##  <Attr Name="EulerRing" Arg="G"/>
##  <Description>
##  This is an attribute of a group <A>G</A> which
##  contains the induced Euler ring <E>A</E>.
##  The additive and multiplicative identities of <E>A</E>
##  are stored in attributes
##  <Ref BookName="Reference" Attr="ZeroImmutable"/>
##  and <Ref BookName="Reference" Attr="OneImmutable"/>,
##  respectively.
##  Here is an example of creating a Euler ring
##  induced by a finite group and printing
##  its additive and multiplicative idenities.
##  <Example>
##  gap> G := SymmetricGroup( 4 );
##  Sym( [ 1 .. 4 ] )
##  gap> A := EulerRing( G );
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
  DeclareAttribute( "EulerRing", IsGroup );

#############################################################################
##
#A  Basis( <A> )
##
##  <#GAPDoc Label="brng_Basis">
##  <ManSection>
##  <Attr Name="Basis" Label="Euler ring" Arg="A"/>
##  <Description>
##  This is an attribute of a Euler ring <A>A</A>
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
##  <Attr Name="UnderlyingGroup" Label="Euler ring" Arg="A"/>
##  <Description>
##    This is an attribute of a Euler ring <A>A</A>
##    which contains the group <E>G</E> from which <A>A</A>
##    is induced.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareAttribute( "UnderlyingGroup", IsEulerRing );

#############################################################################
##
#P  IsEulerRingByCompactLieGroupBasis
##
  DeclareProperty( "IsEulerRingByCompactLieGroupBasis",
      CategoryCollections( IsEulerRingByCompactLieGroupElement ) );

#############################################################################
##
#U  NewEulerRingByCompactLieGroupBasis(
#U      IsEulerRingByCompactLieGroupElement, <r> )
##
  DeclareConstructor( "NewEulerRingByCompactLieGroupBasis",
      [ IsEulerRingByCompactLieGroup, IsRecord ] );


##  Part 3: Other Aspects

#############################################################################
##
#A  TwistedBasicDegree( <chi> )
##
##  <#GAPDoc Label="BasicDegree">
##  <ManSection>
##  <Attr Name="TwistedBasicDegree" Arg="chi"/>
##  <Description>
##  This is an attribute of a character <A>chi</A>
##  which stores the associated twisted basic degree.
##  Here is an example.
##  <Example>
##  gap> G := SymmetricGroup(4);;
##  gap> chi := Irr(G)[3];
##  Character( CharacterTable( Sym( [ 1 .. 4 ] ) ), [ 2, 0, 2, -1, 0 ] )
##  gap> TwistedBasicDegree(chi);
##  &lt;1(5)-2(9)+1(11)&gt; in Brng( Sym( [ 1 .. 4 ] ) )
##  </Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareAttribute( "TwistedBasicDegree", IsVirtualCharacter );
  DeclareAttribute( "TwistedBasicDegree", IsCompactLieGroupVirtualCharacter );


#############################################################################
##
#E  EulerRing.gd . . . . . . . . . . . . . . . . . . . . . . . . ends here