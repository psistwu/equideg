#############################################################################
##
#W  Group.gd		GAP Package `EquiDeg'			    Haopin Wu
##
#Y  Copyright (C) 2017-2023, Haopin Wu
##
##  This file contains declarations for procedures related to group theory.
##
##  Todo:
##


## Part 2: Conjugacy Class of Elements

#############################################################################
##
#A  IdCC( <c> )
##
##  <#GAPDoc Label="IdCC">
##  <ManSection>
##  <Attr Name="IdCC" Arg="c"/>
##  <Description>
##  This is an attribute of a <E>conjugacy class</E> <A>c</A>
##  of a <E>finite group</E> <A>G</A> which stores its id
##  with respect to <C>ConjugacyClasses( <A>G</A> )</C>.
##  The following example illustrates what it does.
##  <Example>
##  gap> G := SymmetricGroup( 4 );;
##  gap> c := (1,2,3)^G;; # take a conjugacy class in &lt;g&gt;
##  gap> IdCC( c );
##  4
##  gap> CCs := ConjugacyClasses( G );;
##  gap> CCs[ 4 ] = c;
##  true
##  </Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareAttribute( "IdCC", IsConjugacyClassGroupRep );


## Part 3: Conjugacy Class of Subgroups

#############################################################################
##
#U  NewConjugacyClassSubgroups( filt, grp )
##
##  <#GAPDoc Label="NewConjugacyClassSubgroups">
##  <ManSection>
##  <Constr Name="NewConjugacyClassSubgroups"
##      Arg="filt, grp"/>
##  <Description>
##    This is the constructor of CCS.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareConstructor( "NewConjugacyClassSubgroups",
    [ IsConjugacyClassSubgroupsRep, IsGroup ] );

#############################################################################
##
#A  IdCCS( <C> )
##
##  <#GAPDoc Label="IdCCS">
##  <ManSection>
##  <Attr Name="IdCCS" Arg="C"/>
##  <Description>
##  This is an attribute of a <E>conjugacy class of subgroups</E>
##  <A>C</A> of a group <A>G</A> which stores its id with respect to
##  <C>ConjugacyClassesSubgroups( <A>G</A> )</C>.
##  The following example illustrates what it does.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareAttribute( "IdCCS", IsConjugacyClassSubgroupsRep );

#############################################################################
##
#A  OrderOfRepresentative( <C> )
##
DeclareAttribute( "OrderOfRepresentative", IsConjugacyClassSubgroupsRep );

#############################################################################
##
#F  OrderForIdCCS( <id1>, <id2> )
##
DeclareGlobalFunction( "OrderForIdCCS", "Order for id of CCS" );

#############################################################################
##
#O  SetCCSsLaTeXString( <G>, <namelist> )
##
# DeclareOperation( "SetCCSsLaTeXString",
    # [ IsGroup, IsHomogeneousList ] );

#############################################################################
##
#O  nLHnumber( <L>, <H> )
#O  nLHnumber( <CL>, <CH> )
##
##  <#GAPDoc Label="nLHnumber">
##  <ManSection>
##  <Oper Name="nLHnumber" Arg="L, H"/>
##  <Oper Name="nLHnumber" Arg="CL, CH" Label="ccs"/>
##  <Description>
##    This operation computes <M>n(<A>L</A>,<A>H</A>)</M>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareOperation( "nLHnumber",
    [ IsGroup and HasParentAttr, IsGroup and HasParentAttr ] );
DeclareOperation( "nLHnumber",
    [ IsConjugacyClassSubgroupsRep, IsConjugacyClassSubgroupsRep ] );

#############################################################################
##
#O  \<( <C1>, <C2> )
##
##  <#GAPDoc Label="LessThan">
##  <ManSection>
##  <Oper Name="&bslash;&lt;" Arg="C1, C2"/>
##  <Description>
##    This is the standard partial order relation defined
##    on the collection of CCSs.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##

#############################################################################
##
#A  OrderOfWeylGroup( <U> )
#A  OrderOfWeylGroup( <C> )
##
##  <#GAPDoc Label="OrderOfWeylGroup">
##  <ManSection>
##  <Attr Name="OrderOfWeylGroup" Arg="U"/>
##  <Attr Name="OrderOfWeylGroup" Arg="C" Label="ccs"/>
##  <Description>
##    This attribute contains the order of the Weyl group for given
##    subgroup <A>U</A> or CCS <A>C</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareAttribute( "OrderOfWeylGroup", IsGroup and HasParentAttr );
DeclareAttribute( "OrderOfWeylGroup", IsConjugacyClassSubgroupsRep );


##  Part

#############################################################################
##
#U  NewConjugacyClassesSubgroups( IsGroup, <G> )
##
##  <#GAPDoc Label="NewConjugacyClassesSubgroups">
##  <ManSection>
##  <Constr Name="NewConjugacyClassesSubgroups"
##      Arg="IsGroup, G"/>
##  <Description>
##    This is the constructor of list of CCSs of compact Lie group.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareConstructor( "NewConjugacyClassesSubgroups", [ IsObject, IsGroup ] );


#############################################################################
##
#R  IsLatticeCCSsRep
##
##  <#GAPDoc Label="IsLatticeCCSsRep">
##  <ManSection>
##  <Filt Name="IsLatticeCCSsRep"/>
##  <Description>
##    This is the representation of lattice of CCSs.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareRepresentation( "IsLatticeCCSsRep", IsLatticeRep, [ ] );

#############################################################################
##
#A  LatticeCCSs( <grp> )
##
##  <#GAPDoc Label="LatticeCCSs">
##  <ManSection>
##  <Attr Name="LatticeCCSs" Arg="grp"/>
##  <Description>
##  This attribute contains lattice of CCSs of <A>grp</A>.
##  Its return object <C>lat</C> admits attribute
##  <Ref Attr="ConjugacyClassesSubgroups" BookName="Reference"/>
##  for retriving the underlying CCS list.
##  In addition, one can call <Ref Oper="DotFileLattice"/>
##  on <C>lat</C> to export <C>.dot</C> files,
##  which can be later converted
##  into <C>.eps</C> or <C>.pdf</C> files.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareAttribute( "LatticeCCSs", IsGroup );

#############################################################################
##
#A  ConjugacyClassesSubgroups( <lat_ccss> )
##
DeclareAttribute( "ConjugacyClassesSubgroups", IsLatticeCCSsRep );


##  Part 3: Character and Representation Theory

#############################################################################
##
#A  IdIrr( <chi> )
##
DeclareAttribute( "IdIrr", IsIrreducibleCharacter );

#############################################################################
##
#O  ImageElm( <chi>, <e> )
##
DeclareOperation( "ImageElm",
    [ IsClassFunction, IsMultiplicativeElementWithInverse ] );

#############################################################################
##
#O  SchurIndicator( <chi>, <n> )
##
DeclareOperation( "SchurIndicator", [ IsCharacter, IsInt ] );


##  Part 4: Concepts Related to Compact Lie Group

#############################################################################
##
#A  DimensionOfCompactLieGroup( <G> )
##
DeclareAttribute( "DimensionOfCompactLieGroup", IsGroup );

#############################################################################
##
#A  RankOfCompactLieGroup( <G> )
##
DeclareAttribute( "RankOfCompactLieGroup", IsGroup );


#############################################################################
##
#E  Group.gd . . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
