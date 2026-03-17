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
#F  OrthogonalGroupOverReal( <n> )
##
##  <#GAPDoc Label="OrthogonalGroupOverReal">
##  <ManSection>
##  <Func Name="OrthogonalGroupOverReal" Arg="n"/>
##  <Description>
##    This function creates group <M>O(n,R)</M>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareGlobalFunction( "OrthogonalGroupOverReal" );

#############################################################################
##
#F  SpecialOrthogonalGroupOverReal( <n> )
##
##  <#GAPDoc Label="SpecialOrthogonalGroupOverReal">
##  <ManSection>
##  <Func Name="SpecialOrthogonalGroupOverReal" Arg="n"/>
##  <Description>
##    This function creates group <M>SO(n,R)</M>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareGlobalFunction( "SpecialOrthogonalGroupOverReal" );

#############################################################################
##
#F  ElementaryCLGId( <id> )
##
##  <#GAPDoc Label="ElementaryCLGId">
##  <ManSection>
##  <Func Name="ElementaryCLGId" Arg="id"/>
##  <Description>
##    This function creates elementary compact Lie group of given <A>id</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareGlobalFunction( "ElementaryCLGId" );

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
