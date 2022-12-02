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
