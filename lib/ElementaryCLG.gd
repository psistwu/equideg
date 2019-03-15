#############################################################################
##
#W  ElementaryCLG.gd	GAP Package `EquiDeg'			    Haopin Wu
##
#Y  Copyright (C) 2017-2019, Haopin Wu
#Y  Department of Mathematics, National Tsing Hua University, Taiwan
#Y  Department of Mathematical Sciences, the University of Texas at Dallas, USA
##
##  This file contains declarations for procedures related to
##  elementary compact Lie group.
##

##  Part 1: Group and Subgroup

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
#F  ElementaryCLGId( <id> )
##
##  <#GAPDoc Label="ElementaryCLGId">
##  <ManSection>
##  <Func Name="ElementaryCLGId" Arg="id"/>
##  <Description>
##    returns elementary compact Lie group for given <A>id</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareGlobalFunction( "ElementaryCLGId",
      "returns elementary compact Lie group by ID" );

#############################################################################
##
#A  IdElementaryCLG( <G> )
##
##  <#GAPDoc Label="IdElementaryCLG">
##  <ManSection>
##  <Attr Name="IdElementaryCLG" Arg="G"/>
##  <Description>
##    This attribute contains the ID of elementary compact Lie group
##    <A>G</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareAttribute( "IdElementaryCLG", IsCompactLieGroup );


##  Part 4: CCS of ECLG

#############################################################################
##
#E  ElementaryCLG.gd . . . . . . . . . . . . . . . . . . . . . . .  ends here
