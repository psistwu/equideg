#############################################################################
##
#W  ElementaryCompactLieGroup.gd	GAP Package `EquiDeg'			    Haopin Wu
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
##    This function creates group <M>O(n)</M>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "OrthogonalGroupOverReal", "returns O(n,R)" );

#############################################################################
##
#F  SpecialOrthogonalGroupOverReal( <n> )
##
##  <#GAPDoc Label="SpecialOrthogonalGroupOverReal">
##  <ManSection>
##  <Func Name="SpecialOrthogonalGroupOverReal" Arg="n"/>
##  <Description>
##    This function creates group SO(n,R).
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "SpecialOrthogonalGroupOverReal", "returns SO(n,R)" );

#############################################################################
##
#F  ElementaryCompactLieGroupById( <id> )
##
##  <#GAPDoc Label="ElementaryCompactLieGroupById">
##  <ManSection>
##  <Func Name="ElementaryCompactLieGroupById" Arg="id"/>
##  <Description>
##    This function creates elementary compact Lie group of given <A>id</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareGlobalFunction( "ElementaryCompactLieGroupById",
    "returns elementary compact Lie group by ID" );

#############################################################################
##
#A  IdOfElementaryCompactLieGroup( <G> )
##
##  <#GAPDoc Label="IdOfElementaryCompactLieGroup">
##  <ManSection>
##  <Attr Name="IdOfElementaryCompactLieGroup" Arg="G"/>
##  <Description>
##    This attribute contains the ID of elementary compact Lie group
##    <A>G</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareAttribute( "IdOfElementaryCompactLieGroup", IsCompactLieGroup );


##  Part 4: CCS of ECLG

#############################################################################
##
#E  ElementaryCompactLieGroup.gd . . . . . . . . . . . . . . . . . . . . . . .  ends here
