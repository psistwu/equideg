#############################################################################
##
#W  Poset.gd		GAP Package `EquiDeg'			    Haopin Wu
##
#Y  Copyright (C) 2017-2018, Haopin Wu
#Y  Department of Mathematics, National Tsing Hua University, Taiwan
##
##  This file contains declarations of procedures related to lattice.
##
##  Todo:
##    1. Fix the naming of components.
##


#############################################################################
##
#P  IsPoset( <list> )
##
##  <#GAPDoc Label="IsPoset">
##  <ManSection>
##  <Prop Name="IsPoset" Arg="list[, func]"/>
##  <Description>
##    checks whether <A>list</A> is a poset, i.e.,
##    a duplicate-free sorted homogeneous list,
##    with respect to partial order <A>func</A>
##    (or <C>&bslash;&lt;</C> if <A>func</A> is not given).
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareProperty( "IsPoset", IsList );


#############################################################################
##
#O  Poset( <list>[, <func>] )
##
##  <#GAPDoc Label="PSort">
##  <ManSection>
##  <Oper Name="PSort" Arg="list[, func]"/>
##  <Description>
##    Return a poset based on <A>list</A> with respect to partial order
##    <A>func</A> (or <C>&bslash;&lt;</C> if <A>func</A> is not given).
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareOperation( "Poset", [ IsList ] );


#############################################################################
##
#P  MaximalElements( <list>[, <func>] )
##
##  <#GAPDoc Label="MaximalElements">
##  <ManSection>
##  <Prop Name="MaximalElements" Arg="list[, func]"/>
##  <Description>
##    returns the list of maximal elements in <A>list</A>
##    with respect to partial order <A>func</A>
##    (or <C>&bslash;&lt;</C> if <A>func</A> is not given).
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareProperty( "MaximalElements", IsList );


#############################################################################
##
#E  Poset.gd . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
