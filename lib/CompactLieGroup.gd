#############################################################################
##
#W  CompactLieGroup.gd	GAP Package `EquiDeg'			    Haopin Wu
##
#Y  Copyright (C) 2017-2018, Haopin Wu
#Y  Department of Mathematics, National Tsing Hua University, Taiwan
##
##  This file contains declarations for procedures related to
##  compact Lie group.
##

##  Part 1: Compact Lie Group

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
#R  IsCompactLieGroupCCSRep
##
##  <#GAPDoc Label="IsCompactLieGroupCCSRep">
##  <ManSection>
##  <Filt Name="IsCompactLieGroupCCSRep" Type="representation"/>
##  <Description>
##    This is a representation of CCS of (infinite) compact Lie group.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareRepresentation( "IsCompactLieGroupCCSRep",
      IsConjugacyClassSubgroupsRep, [ ] );

#############################################################################
##
#R  IsCompactLieGroupCCSsRep
##
##  <#GAPDoc Label="IsCompactLieGroupCCSsRep">
##  <ManSection>
##  <Filt Name="IsCompactLieGroupCCSsRep" Type="representation"/>
##  <Description>
##    This is a representation of CCS list of (infinite) compact Lie group.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareRepresentation( "IsCompactLieGroupCCSsRep",
      IsComponentObjectRep and IsAttributeStoringRep, [ ] );

#############################################################################
##
#U  NewCCS( IsCompactLieGroupCCSRep, <r> )
##
##  <#GAPDoc Label="NewCCS">
##  <ManSection>
##  <Constr Name="NewCCS" Arg="IsCompactLieGroupCCSRep, r"/>
##  <Description>
##    This is the constructor of CCS of (infinite) compact Lie group.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareConstructor( "NewCCS", [ IsCompactLieGroupCCSRep, IsRecord ] );

#############################################################################
##
#A  CCSClasses( <CCSs> )
##
  DeclareGlobalFunction( "CCSClasses",
      "returns CCS classes of a compact Lie group" );

#############################################################################
##
#A  CCSId( <CCSs> )
##
  DeclareAttribute( "CCSId", IsCompactLieGroupCCSsRep );

#############################################################################
##
#A  IdCCS( <C> )
##
  DeclareAttribute( "IdCCS", IsCompactLieGroupCCSRep );

#############################################################################
##
#P  IsZeroModeCCS( <C> )
##
  DeclareProperty( "IsZeroModeCCS", IsCompactLieGroupCCSRep );


##  Part 2: Elementary Compact Lie Group

#############################################################################
##
#R  IsElementaryCompactLieGroupRep
##
##  <#GAPDoc Label="IsElementaryCompactLieGroupRep">
##  <ManSection>
##  <Filt Name="IsElementaryCompactLieGroupRep" Type="representation"/>
##  <Description>
##    This is a representation of (infinite) compact Lie group.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareRepresentation( "IsElementaryCompactLieGroupRep",
      IsComponentObjectRep and IsAttributeStoringRep, [ ] );

#############################################################################
##
#R  IsElementaryCompactLieGroupCCSRep
##
##  <#GAPDoc Label="IsElementaryCompactLieGroupCCSRep">
##  <ManSection>
##  <Filt Name="IsElementaryCompactLieGroupCCSRep" Type="representation"/>
##  <Description>
##    This is a representation of CCS of elementary compact Lie group.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareRepresentation( "IsElementaryCompactLieGroupCCSRep",
      IsCompactLieGroupCCSRep, [ ] );

#############################################################################
##
#U  NewElementaryCompactLieGroup( IsCompactLieGroup and
##      IsElementaryCompactLieGroupRep, rec )
##
##  <#GAPDoc Label="NewElementaryCompactLieGroup">
##  <ManSection>
##  <Constr Name="NewElementaryCompactLieGroup"
##      Arg="IsCompactLieGroup and IsElementaryCompactLieGroupRep, n"/>
##  <Description>
##    This is the constructor of elementary compact lie group.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareConstructor( "NewElementaryCompactLieGroup",
      [ IsCompactLieGroup and IsElementaryCompactLieGroupRep, IsRecord ] );

#############################################################################
##
#A  IdECLG( <eclg> )
##
##  <#GAPDoc Label="IdECLG">
##  <ManSection>
##  <Attr Name="IdECLG" Arg="eclg"/>
##  <Description>
##    This attribute contains the ID of elementary compact Lie group
##    <A>eclg</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareAttribute( "IdECLG", IsCompactLieGroup and
      IsElementaryCompactLieGroupRep );

#############################################################################
##
#F  ECLGId( <id> )
##
  DeclareGlobalFunction( "ECLGId", "returns ECLG by ID" );

#############################################################################
##
#F  OrthogonalGroupOverReal( <n> )
##
  DeclareGlobalFunction( "OrthogonalGroupOverReal", "returns O(n,R)" );

#############################################################################
##
#F  SpecialOrthogonalGroupOverReal( <n> )
##
  DeclareGlobalFunction( "SpecialOrthogonalGroupOverReal", "returns SO(n,R)" );


#############################################################################
##
#E  CompactLieGroup.gd . . . . . . . . . . . . . . . . . . . . . .  ends here
