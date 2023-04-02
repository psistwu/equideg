#############################################################################
##
#W  CompactLieGroup.gd	GAP Package `EquiDeg'			    Haopin Wu
##
#Y  Copyright (C) 2017-2023, Haopin Wu
#Y  Department of Mathematics, National Tsing Hua University, Taiwan
#Y  Department of Mathematical Sciences, the University of Texas at Dallas, USA
##
##  This file contains declarations for procedures related to
##  compact Lie group.
##


##  Part 1: Compact Lie Group (CLG)

#############################################################################
##
#C  IsCompactLieGroup
##
##  <#GAPDoc Label="IsCompactLieGroup">
##  <ManSection>
##  <Filt Name="IsCompcatLieGroup" Type="category"/>
##  <Description>
##  This is the category of (infinite) compact Lie group.
##  Objects in this Category admits the following <E>attribtues</E>
##  and <E>properties</E>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareCategory( "IsCompactLieGroup", IsGroup );

#############################################################################
##
#U  NewCompactLieGroup( filter )
##
##  <#GAPDoc Label="NewCompactLieGroup">
##  <ManSection>
##  <Constr Name="NewCompactLieGroup" Arg="IsCompactLieGroupRep, r"/>
##  <Description>
##    This is the constructor of matrix compact Lie group.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareConstructor( "NewCompactLieGroup",
    [ IsCompactLieGroup, IsInt ] );


##  Part 2: CCS and CCS prototypes of CLG

#############################################################################
##
#R  IsCompactLieGroupConjugacyClassSubgroupsRep
##
##  <#GAPDoc Label="IsCompactLieGroupConjugacyClassSubgroupsRep">
##  <ManSection>
##  <Filt Name="IsCompactLieGroupConjugacyClassSubgroupsRep"
##      Type="representation"/>
##  <Description>
##  This is a representation of CCS of (infinite) compact Lie group.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareRepresentation( "IsCompactLieGroupConjugacyClassSubgroupsRep",
    IsConjugacyClassSubgroupsRep, [ ] );

#############################################################################
##
#U  NewCompactLieGroupConjugacyClassSubgroups( IsGroup, IsGroup, <r> )
##
##  <#GAPDoc Label="NewCompactLieGroupConjugacyClassSubgroups">
##  <ManSection>
##  <Constr Name="NewCompactLieGroupConjugacyClassSubgroups"
##      Arg="IsGroup, G, r"/>
##  <Description>
##  This is the constructor of CCS of (infinite) compact Lie group.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareConstructor( "NewCompactLieGroupConjugacyClassSubgroups",
    [ IsGroup, IsGroup, IsRecord ] );

#############################################################################
##
#O  Refolded( <C>, <l> )
##
DeclareOperation( "Refolded",
    [ IsCompactLieGroupConjugacyClassSubgroupsRep, IsInt ] );

#############################################################################
##
#R  IsCompactLieGroupConjugacyClassesSubgroupsRep
##
##  <#GAPDoc Label="IsCompactLieGroupConjugacyClassesSubgroupsRep">
##  <ManSection>
##  <Filt Name="IsCompactLieGroupConjugacyClassesSubgroupsRep"
##      Type="representation"/>
##  <Description>
##    This is a representation of CCS list of (infinite) compact Lie group.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareRepresentation( "IsCompactLieGroupConjugacyClassesSubgroupsRep",
    IsComponentObjectRep and IsAttributeStoringRep, [ ] );

#############################################################################
##
#U  NewCompactLieGroupConjugacyClassesSubgroups( IsGroup, <G> )
##
##  <#GAPDoc Label="NewCompactLieGroupConjugacyClassesSubgroups">
##  <ManSection>
##  <Constr Name="NewCompactLieGroupConjugacyClassesSubgroups"
##      Arg="IsGroup, G"/>
##  <Description>
##    This is the constructor of list of CCSs of compact Lie group.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareConstructor( "NewCompactLieGroupConjugacyClassesSubgroups",
    [ IsGroup, IsGroup, IsRecord ] );

#############################################################################
##
#O  \[\,\]( <CCSs>, <l>, <j> )
##
##  <#GAPDoc Label="CompactLieGroupConjugacyClassesSubgroupsSelector">
##  <ManSection>
##  <Oper Name="\[\,\]"
##      Arg="CCSs, l, j"/>
##  <Description>
##    This is the selector of list of CCSs of compact Lie group.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareOperation( "[,]",
    [ IsCompactLieGroupConjugacyClassesSubgroupsRep, IsInt, IsPosInt ] );

#############################################################################
##
#O  NumberOfNonzeroModeClasses( <CCSs> )
##
##  <#GAPDoc Label="NumberOfNonzeroModeClasses">
##  <ManSection>
##  <Oper Name="NumberOfNonzeroModeClasses"
##      Arg="CCSs"/>
##  <Description>
##    This operation returns the number of non-zero mode CCSs.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareOperation( "NumberOfNonzeroModeClasses",
    [ IsCompactLieGroupConjugacyClassesSubgroupsRep ] );

#############################################################################
##
#O  NumberOfZeroModeClasses( <CCSs> )
##
##  <#GAPDoc Label="NumberOfZeroModeClasses">
##  <ManSection>
##  <Oper Name="NumberOfZeroModeClasses"
##      Arg="CCSs"/>
##  <Description>
##    This operation returns the number of zero mode CCSs.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareOperation( "NumberOfZeroModeClasses",
    [ IsCompactLieGroupConjugacyClassesSubgroupsRep ] );


##  Part 3: Representation Theory of CLG

#############################################################################
##
#C  IsCompactLieGroupCharacterTable
##
##  <#GAPDoc Label="IsCompactLieGroupCharacterTable">
##  <ManSection>
##  <Filt Name="IsCompactLieGroupCharacterTable"
##      Type="category"/>
##  <Description>
##    This is the category of character table of compact Lie group.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##  
DeclareCategory( "IsCompactLieGroupCharacterTable",
    IsNearlyCharacterTable );

#############################################################################
##
#C  IsCompactLieGroupIrrCollection
##
##  <#GAPDoc Label="IsCompactLieGroupIrrCollection">
##  <ManSection>
##  <Filt Name="IsCompactLieGroupIrrCollection"
##      Type="category"/>
##  <Description>
##    This is the category of collection of irreducible
##    representations of compact Lie group.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareCategory( "IsCompactLieGroupIrrCollection", IsCollection );

#############################################################################
##
#C  IsCompactLieGroupClassFunction
##
##  <#GAPDoc Label="IsCompactLieGroupClassFunction">
##  <ManSection>
##  <Filt Name="IsCompactLieGroupClassFunction"
##      Type="category"/>
##  <Description>
##    This is the category of class function of compact Lie group.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareCategory( "IsCompactLieGroupClassFunction", IsObject );

#############################################################################
##
#U  NewCompactLieGroupClassFunction( IsCompactLieGroupClassFunction, <G> )
##
DeclareConstructor( "NewCompactLieGroupClassFunction",
    [ IsCompactLieGroupClassFunction, IsCompactLieGroup, IsRecord ] );

#############################################################################
##
#P  IsCompactLieGroupCharacter
##
##  <#GAPDoc Label="IsCompactLieGroupCharacter">
##  <ManSection>
##  <Filt Name="IsCompactLieGroupCharacter"
##      Type="property"/>
##  <Description>
##    This is the property of compact Lie group character.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareProperty( "IsCompactLieGroupCharacter",
    IsCompactLieGroupClassFunction );

#############################################################################
##
#P  IsCompactLieGroupVirtualCharacter
##
##  <#GAPDoc Label="IsCompactLieGroupVirtualCharacter">
##  <ManSection>
##  <Filt Name="IsCompactLieGroupVirtualCharacter"
##      Type="property"/>
##  <Description>
##    This is the property of compact Lie group virtual character.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareProperty( "IsCompactLieGroupVirtualCharacter",
    IsCompactLieGroupClassFunction );
InstallTrueMethod( IsCompactLieGroupVirtualCharacter,
    IsCompactLieGroupCharacter );

#############################################################################
##
#P  IsIrreducibleCharacter( <chi> )
##
##  <#GAPDoc Label="IsIrreducibleCharacter">
##  <ManSection>
##  <Filt Name="IsIrreducibleCharacter"
##      Type="property"/>
##  <Description>
##    This is the property of compact Lie group irreducible character.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareProperty( "IsIrreducibleCharacter", IsCompactLieGroupClassFunction );
InstallTrueMethod( IsCompactLieGroupCharacter,
    IsCompactLieGroupClassFunction and IsIrreducibleCharacter );

#############################################################################
##
#A  IdCompactLieGroupClassFunction( <chi> )
##
##  <#GAPDoc Label="IdCompactLieGroupClassFunction">
##  <ManSection>
##  <Attr Name="IdCompactLieGroupClassFunction" Arg="chi"/>
##  <Description>
##    This attribute contains the id of compact Lie group class function
##    <A>chi</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareAttribute( "IdCompactLieGroupClassFunction",
    IsCompactLieGroupClassFunction );

#############################################################################
##
#O  \[\]( <irrs>, <l> )
##
##  <#GAPDoc Label="CompactLieGroupIrrsCollectionSelector">
##  <ManSection>
##  <Oper Name="\[\]"
##      Arg="col_irrs, l"/>
##  <Description>
##    This is the selector of collection of compact Lie group
##    irreducible representations.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareOperation( "[]", [ IsCompactLieGroupIrrCollection, IsInt ] );

#############################################################################
##
#A  IdIrr( <chi> )
##
##  <#GAPDoc Label="CLG_IdIrr">
##  <ManSection>
##  <Attr Name="IdIrr" Arg="chi"/>
##  <Description>
##    This attribute contains the id of compact Lie group
##    irreducbile representation <A>chi</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareAttribute( "IdIrr", IsCompactLieGroupCharacter );

#############################################################################
##
#O  Refolded( <chi>, <l> )
##
DeclareOperation( "Refolded",
    [ IsCompactLieGroupClassFunction and IsIrreducibleCharacter, IsInt ] );

#############################################################################
##
#A  DegreeOfCharacter( <chi> )
##
DeclareAttribute( "DegreeOfCharacter", IsCompactLieGroupVirtualCharacter );

#############################################################################
##
#O  DimensionOfFixedSet( <chi>, <H> );
#O  DimensionOfFixedSet( <chi>, <C> );
##
##  <#GAPDoc Label="clg_DimensionOfFixedSet">
##  <ManSection Label="DimensionOfFixedSet:clg">
##  <Heading>DimensionOfFixedSet</Heading>
##  <Oper Name="DimensionOfFixedSet" Label="clg subgroup"
##      Arg="chi, H"/>
##  <Oper Name="DimensionOfFixedSet" Label="clg CCS"
##      Arg="chi, C"/>
##  <Description>
##    This operation returns the dimension of fixed set
##    of subgroup <A>H</A> or conjugacy class of subgroups
##    <A>C</A> with repect to character <A>chi</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareOperation( "DimensionOfFixedSet",
  [ IsCompactLieGroupCharacter, IsGroup ] );
DeclareOperation( "DimensionOfFixedSet",
  [ IsCompactLieGroupCharacter,
    IsCompactLieGroupConjugacyClassSubgroupsRep ] );

#############################################################################
##
#A  OrbitTypes( <chi> )
##
DeclareAttribute( "OrbitTypes", IsCompactLieGroupCharacter );

#############################################################################
##
#A  MaximalOrbitTypes( <chi> )
##
DeclareAttribute("MaximalOrbitTypes", IsCompactLieGroupCharacter);

#############################################################################
##
#A  LatticeOrbitTypes( <chi> )
##
DeclareAttribute( "LatticeOrbitTypes", IsCompactLieGroupCharacter );


#############################################################################
##
#E  CompactLieGroup.gd . . . . . . . . . . . . . . . . . . . . . .  ends here
