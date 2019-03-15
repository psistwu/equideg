#############################################################################
##
#W  CompactLieGroup.gd	GAP Package `EquiDeg'			    Haopin Wu
##
#Y  Copyright (C) 2017-2019, Haopin Wu
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
##    This is the category of (infinite) compact Lie group.
##    Objects in this Category admits the following <E>attribtues</E>
##    and <E>properties</E>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareCategory( "IsCompactLieGroup", IsGroup );

#############################################################################
##
#U  NewCompactLieGroup( filter, <r> )
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
      [ IsCompactLieGroup, IsRecord ] );


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


##  Part 3: Representation Theory of CLG

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
#P  IsIrreducibleCharacter( <chi> )
##
  DeclareProperty( "IsIrreducibleCharacter", IsCompactLieGroupClassFunction );
  InstallTrueMethod( IsCompactLieGroupCharacter,
      IsCompactLieGroupClassFunction and IsIrreducibleCharacter );

#############################################################################
##
#A  IdCompactLieGroupClassFunction( <chi> )
##
  DeclareAttribute( "IdCompactLieGroupClassFunction",
    IsCompactLieGroupClassFunction );

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
#V  DimensionOfFixedSetHandler
##
  DeclareOperation( "DimensionOfFixedSet",
    [ IsCompactLieGroupCharacter, IsGroup ] );
  DeclareOperation( "DimensionOfFixedSet",
    [ IsCompactLieGroupCharacter,
      IsCompactLieGroupConjugacyClassSubgroupsRep ] );
  BindGlobal( "DIMENSION_OF_FIXED_SET_HANDLER", rec( ) );

#############################################################################
##
#A  OrbitTypes( <chi> )
##
  DeclareAttribute( "OrbitTypes", IsCompactLieGroupCharacter );

#############################################################################
##
#A  LatticeOrbitTypes( <chi> )
##
  DeclareAttribute( "LatticeOrbitTypes", IsCompactLieGroupCharacter );


#############################################################################
##
#E  CompactLieGroup.gd . . . . . . . . . . . . . . . . . . . . . .  ends here
