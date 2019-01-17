#############################################################################
##
#W  CompactLieGroup.gd	GAP Package `EquiDeg'			    Haopin Wu
##
#Y  Copyright (C) 2017-2019, Haopin Wu
#Y  Department of Mathematics, National Tsing Hua University, Taiwan
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
##    This is the category of (infinite) compact Lie group.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareCategory( "IsCompactLieGroup", IsGroup );

#############################################################################
##
#U  NewCompactLieGroup( IsCompactLieGroup, <r> )
##
##  <#GAPDoc Label="NewCompactLieGroup">
##  <ManSection>
##  <Constr Name="NewCompactLieGroup"
##      Arg="IsCompactLieGroupRep, r"/>
##  <Description>
##    This is the constructor of compact Lie group.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareConstructor( "NewCompactLieGroup",
      [ IsCompactLieGroup, IsRecord ] );

#############################################################################
##
#A  DimensionOfCompactLieGroup
##
  DeclareAttribute( "DimensionOfCompactLieGroup", IsCompactLieGroup );
  DeclareAttribute( "Dimension", IsCompactLieGroup );

#############################################################################
##
#A  RankOfCompactLieGroup
##
  DeclareAttribute( "RankOfCompactLieGroup", IsCompactLieGroup );


##  Part 2: CCS of CLG

#############################################################################
##
#R  IsCompactLieGroupConjugacyClassSubgroupsRep
##
##  <#GAPDoc Label="IsCompactLieGroupConjugacyClassSubgroupsRep">
##  <ManSection>
##  <Filt Name="IsCompactLieGroupConjugacyClassSubgroupsRep"
##      Type="representation"/>
##  <Description>
##    This is a representation of CCS of (infinite) compact Lie group.
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
##    This is the constructor of CCS of (infinite) compact Lie group.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareConstructor( "NewCompactLieGroupConjugacyClassSubgroups",
      [ IsGroup, IsGroup, IsRecord ] );

#############################################################################
##
#A  IsZeroModeCCS( <C> )
##
  DeclareAttribute( "IsZeroModeCCS",
      IsCompactLieGroupConjugacyClassSubgroupsRep );

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
#U  NewCompactLieGroupConjugacyClassesSubgroups(
#U      IsGroup, G )
##
  DeclareConstructor( "NewCompactLieGroupConjugacyClassesSubgroups",
      [ IsGroup, IsGroup, IsRecord ] );

#############################################################################
##
#O  \[\]( <CCSs>, <l>, <j> )
##
  DeclareOperation( "\[\]",
      [ IsCompactLieGroupConjugacyClassesSubgroupsRep, IsInt, IsInt ] );

#############################################################################
##
#U  NewCCSClass( IsGroup, IsFilter, IsRecord )
##
# DeclareConstructor( "NewCCSClass", [ IsGroup, IsOperation, IsRecord ] );

#############################################################################
##
#F  CCSClasses( <CCSs> )
##
  DeclareGlobalFunction( "CCSClasses",
      "returns CCS classes of a compact Lie group" );

#############################################################################
##
#O  NumberOfNonzeroModeClasses( <CCSs> )
##
  DeclareOperation( "NumberOfNonzeroModeClasses",
      [ IsCompactLieGroupConjugacyClassesSubgroupsRep ] );

#############################################################################
##
#O  NumberOfNonzeroModeClasses( <CCSs> )
##
  DeclareOperation( "NumberOfZeroModeClasses",
      [ IsCompactLieGroupConjugacyClassesSubgroupsRep ] );


##  Part 3: Elementary Compact Lie Group (ECLG)

#############################################################################
##
#C  IsOrthogonalGroupOverReal
##
  DeclareCategory( "IsOrthogonalGroupOverReal",
      IsCompactLieGroup and IsMatrixGroup );

#############################################################################
##
#F  OrthogonalGroupOverReal( <n> )
##
  DeclareGlobalFunction( "OrthogonalGroupOverReal", "returns O(n,R)" );

#############################################################################
##
#C  IsSpecialOrthogonalGroupOverReal
##
  DeclareCategory( "IsSpecialOrthogonalGroupOverReal",
      IsCompactLieGroup and IsMatrixGroup );

#############################################################################
##
#F  SpecialOrthogonalGroupOverReal( <n> )
##
  DeclareGlobalFunction( "SpecialOrthogonalGroupOverReal", "returns SO(n,R)" );

#############################################################################
##
#F  ElementaryCompactLieGroupId( <id> )
##
  DeclareGlobalFunction( "ElementaryCompactLieGroupId",
      "returns elementary compact Lie group by ID" );

#############################################################################
##
#A  IdElementaryCompactLieGroup( <G> )
##
##  <#GAPDoc Label="IdElementaryCompactLieGroup">
##  <ManSection>
##  <Attr Name="IdElementaryCompactLieGroup" Arg="G"/>
##  <Description>
##    This attribute contains the ID of elementary compact Lie group
##    <A>G</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareAttribute( "IdElementaryCompactLieGroup", IsCompactLieGroup );


##  Part 4: CCS of ECLG


##  Part 5: Representation Theory of CLG

#############################################################################
##
#C  IsCompactLieGroupCharacterTable
##
  DeclareCategory( "IsCompactLieGroupCharacterTable",
      IsNearlyCharacterTable );

#############################################################################
##
#C  IsCompactLieGroupIrrCollection
##
  DeclareCategory( "IsCompactLieGroupIrrCollection", IsCollection );

#############################################################################
##
#C  IsCompactLieGroupClassFunction
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
  DeclareProperty( "IsCompactLieGroupCharacter",
      IsCompactLieGroupClassFunction );

#############################################################################
##
#P  IsCompactLieGroupVirtualCharacter
##
  DeclareProperty( "IsCompactLieGroupVirtualCharacter",
      IsCompactLieGroupClassFunction );
  InstallTrueMethod( IsCompactLieGroupVirtualCharacter,
      IsCompactLieGroupCharacter );

#############################################################################
##
#O  \[\]( <irrs>, <l> )
##
  DeclareOperation( "\[\]", [ IsCompactLieGroupIrrCollection, IsInt ] );

#############################################################################
##
#A  IdIrr( <irr> )
##
  DeclareAttribute( "IdIrr", IsCompactLieGroupCharacter );

#############################################################################
##
#O  DimensionOfFixedSet( <chi>, <H> );
##
  DeclareOperation( "DimensionOfFixedSet",
    [ IsCompactLieGroupCharacter, IsGroup ] );

#############################################################################
##
#A  OrbitTypes( <chi> )
##
  DeclareAttribute( "OrbitTypes", IsCompactLieGroupCharacter );


#############################################################################
##
#E  CompactLieGroup.gd . . . . . . . . . . . . . . . . . . . . . .  ends here
