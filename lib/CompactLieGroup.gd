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

#############################################################################
##
#C  IsCompactLieGroup
##
##  <#GAPDoc Label="IsCompactLieGroup">
##  <ManSection>
##  <Filt Name="IsCompcatLieGroup" Type="category"/>
##  <Description>
##    This is the category of compact Lie group.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareCategory( "IsCompactLieGroup", IsGroup );

#############################################################################
##
#C  IsElementaryCompactLieGroup
##
##  <#GAPDoc Label="IsElementaryCompactLieGroup">
##  <ManSection>
##  <Filt Name="IsElementaryCompcatLieGroup" Type="category"/>
##  <Description>
##    This is the category of elementary compact Lie group,
##    including SO(2), O(2) and other
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareCategory( "IsElementaryCompactLieGroup", IsCompactLieGroup );

#############################################################################
##
#R  IsCompactLieGroupRep
##
  DeclareRepresentation( "IsCompactLieGroupRep",
      IsComponentObjectRep and IsAttributeStoringRep, [ ] );

#############################################################################
##
#R  IsCompactLieGroupCCSRep
##
  DeclareRepresentation( "IsCompactLieGroupCCSRep",
      IsComponentObjectRep and IsAttributeStoringRep and
      IsConjugacyClassSubgroupsRep, [ ] );

#############################################################################
##
#R  IsCompactLieGroupCCSsRep
##
  DeclareRepresentation( "IsCompactLieGroupCCSsRep",
      IsComponentObjectRep and IsAttributeStoringRep, [ ] );

#############################################################################
##
#R  IsElementaryCompactLieGroupCCSRep
##
  DeclareRepresentation( "IsElementaryCompactLieGroupCCSRep", IsCompactLieGroupCCSRep, [ ] );

#############################################################################
##
#R  IsElementaryCompactLieGroupCCSsRep
##
  DeclareRepresentation( "IsElementaryCompactLieGroupCCSsRep", IsCompactLieGroupCCSsRep, [ ] );

#############################################################################
##
#R  NewElementaryCompactLieGroup( IsGroup, <n> )
##
  DeclareConstructor( "NewElementaryCompactLieGroup", [ IsGroup, IsPosInt ] );

#############################################################################
##
#R  NewCCS( IsCompactLieGroupCCSsRep, <rec>, <n> )
##
  DeclareConstructor( "NewCCS",
      [ IsCompactLieGroupCCSsRep, IsRecord, IsInt ] );

#############################################################################
##
#A  IdECLG( <eclg> )
##
  DeclareAttribute( "IdECLG", IsElementaryCompactLieGroup );

#############################################################################
##
#A  IdECLG( <ccss_clg> )
##
  DeclareAttribute( "UnderlyingGroup", IsCompactLieGroupCCSsRep );

#############################################################################
##
#A  IdCCS( <ccs_clg> )
##
  DeclareAttribute( "IdCCS", IsCompactLieGroupCCSRep );

#############################################################################
##
#A  CCSClasses( <ccss_clg> )
##
  DeclareAttribute( "CCSClasses", IsCompactLieGroupCCSsRep );

#############################################################################
##
#A  CCSClassesFiltered( <ccss_clg> )
##
  DeclareAttribute( "CCSClassesFiltered", IsCompactLieGroupCCSsRep );

#############################################################################
##
#A  CCSId( <ccss_clg> )
##
  DeclareAttribute( "CCSId", IsCompactLieGroupCCSsRep );

#############################################################################
##
#P  IsZeroModeCCS( <ccs_clg> )
##
  DeclareProperty( "IsZeroModeCCS", IsCompactLieGroupCCSRep );

#############################################################################
##
#F  OrthogonalGroupOverReal( <n> )
##
  DeclareOperation( "OrthogonalGroupOverReal", [ IsPosInt ] );

#############################################################################
##
#F  SpecialOrthogonalGroupOverReal( <n> )
##
  DeclareOperation( "SpecialOrthogonalGroupOverReal", [ IsPosInt ] );

#############################################################################
##
#F  ECLGId( <type>, <mode> )
##
  DeclareOperation( "ECLGId", [ IsList ] );


#############################################################################
##
#E  CompactLieGroup.gd . . . . . . . . . . . . . . . . . . . . . .  ends here
