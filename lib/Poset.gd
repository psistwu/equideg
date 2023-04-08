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
#O  IsPSortedList( <list>[, <func>] )
##
##  <#GAPDoc Label="IsPSortedList">
##  <ManSection>
##  <Oper Name="IsPSortedList" Arg="list[, func]"/>
##  <Description>
##    checks whether <A>list</A> is sorted
##    with respect to partial order <A>func</A>
##    (or <C>&bslash;&lt;</C> if <A>func</A>
##    is not given).
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareOperation( "IsPSortedList", [ IsHomogeneousList ] );

#############################################################################
##
#O  IsPoset( <list> )
##
##  <#GAPDoc Label="IsPoset">
##  <ManSection>
##  <Oper Name="IsPoset" Arg="list[, func]"/>
##  <Description>
##    checks whether <A>list</A> is a poset, i.e.,
##    a non-repeating sorted homogeneous list,
##    with respect to partial order <A>func</A>
##    (or <C>&bslash;&lt;</C> if <A>func</A> is not given).
##    In other words, it is a synonym for
##    <C>IsPSortedList and IsDuplicateFree</C>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareOperation( "IsPoset", [ IsHomogeneousList ] );

#############################################################################
##
#O  PSort( <list>[, <func>] )
##
##  <#GAPDoc Label="PSort">
##  <ManSection>
##  <Oper Name="PSort" Arg="list[, func]"/>
##  <Description>
##    sorts <A>list</A> with respect to partial order <A>func</A>
##    (or <C>&bslash;&lt;</C> if <A>func</A> is not given).
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareOperation( "PSort", [ IsHomogeneousList and IsMutable ] );

#############################################################################
##
#O  PSortedList( <list>[, <func>] )
##
##  <#GAPDoc Label="PSortedList">
##  <ManSection>
##  <Oper Name="PSortedList" Arg="list[, func]"/>
##  <Description>
##    returns a shallow copy of <A>list</A>
##    which is sorted
##    with respect to partial order <A>func</A>
##    (or <C>&bslash;&lt;</C> if <A>func</A> is not given).
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareOperation( "PSortedList", [ IsHomogeneousList ] );

#############################################################################
##
#O  MaximalElements( <list>[, <func>] )
##
##  <#GAPDoc Label="MaximalElements">
##  <ManSection>
##  <Oper Name="MaximalElements" Arg="list[, func]"/>
##  <Description>
##    returns the list of maximal elements in <A>list</A>
##    with respect to partial order <A>func</A>
##    (or <C>&bslash;&lt;</C> if <A>func</A> is not given).
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareOperation( "MaximalElements", [ IsList ] );


#############################################################################
##
#E  Poset.gd . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
