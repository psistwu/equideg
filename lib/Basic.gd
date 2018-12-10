#############################################################################
##
#W  Basic.gd		GAP Package `EquiDeg'			    Haopin Wu
##
#Y  Copyright (C) 2017-2018, Haopin Wu
#Y  Department of Mathematics, National Tsing Hua University, Taiwan
##
##  This file contains declarations for basic math procedures.
##

##  Part 1: Poset

#############################################################################
##
#O  IsSortedPoset( <list>[, <func>] )
##
##  <#GAPDoc Label="IsSortedPoset">
##  <ManSection>
##  <Oper Name="IsSortedPoset" Arg="list[, func]"/>
##  <Description>
##    checks whether <A>list</A> is a sorted poset.
##    It uses either the partial order specified by <A>func</A>,
##    or the default one <C>&bslash;&lt;</C>
##    when <A>func</A> is not given.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareOperation( "IsSortedPoset", [ IsList, IsFunction ] );

#############################################################################
##
#O  TopologicalSort( <list>[, <func>] )
##
##  <#GAPDoc Label="TopologicalSort">
##  <ManSection>
##  <Oper Name="TopologicalSort" Arg="list[, func]"/>
##  <Description>
##    performs topological sort on <A>list</A>.
##    It uses either the partial order specified by <A>func</A>,
##    or the default one <C>&bslash;&lt;</C>
##    when <A>func</A> is not given.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##

  DeclareOperation( "TopologicalSort",
      [ IsList and IsMutable, IsFunction ] );


##  Part 2: Lattice

#############################################################################
##
#R  IsLatticeRep
##
##  <#GAPDoc Label="IsLatticeRep">
##  <ManSection>
##  <Filt Name="IsLatticeRep" Type="Representation"/>
##  <Description>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareRepresentation( "IsLatticeRep",
      IsComponentObjectRep and IsAttributeStoringRep, [ ] );

#############################################################################
##
#C  Lattice( <filter>, <list> )
##
##  <#GAPDoc Label="Lattice">
##  <ManSection>
##  <Constr Name="Lattice" Arg="IsLatticeRep, list"/>
##  <Description>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
  DeclareConstructor( "Lattice", [ IsLatticeRep, IsHomogeneousList ] );

#############################################################################
##
#A  MaximalSubElementsLattice( <lat> )
#A  MinimalSupElementsLattice( <lat> )	(not yet implemented)
##
##  <#GAPDoc Label="MinSupAndMaxSub">
##  <ManSection>
##  <Attr Name="MaximalSubElementsLattice" Arg="lat"/>
##  <Attr Name="MinimalSupElementsLattice" Arg="lat" Comm="not yet implemented"/>
##  <Description>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareAttribute( "MaximalSubElementsLattice",
      IsCollection and IsLatticeRep );
# DeclareAttribute( "MinimalSupElementsLattice",
#     IsCollection and IsLatticeRep );

#############################################################################
##
#O  DotFileLattice( <lat>, <filename> )
##
  DeclareOperation( "DotFileLattice", [ IsLatticeRep, IsString ] );


## Part 2: Group Theory

#############################################################################
##
#A  ConjugacyClassSubgroups( <subg> )
##
  DeclareAttribute( "ConjugacyClassSubgroups", IsGroup and HasParentAttr );

#############################################################################
##
#A  OrderOfWeylGroup( <subg> )
#A  OrderOfWeylGroup( <ccsubg> )
##
  DeclareAttribute( "OrderOfWeylGroup", IsGroup and HasParentAttr );
  DeclareAttribute( "OrderOfWeylGroup", IsConjugacyClassSubgroupsRep );

#############################################################################
##
#O  nLHnumber( <subg1>, <subg2> )
#O  nLHnumber( <ccsubg1>, <ccsubg2> )
##
  DeclareOperation( "nLHnumber",
      [ IsGroup and HasParentAttr, IsGroup and HasParentAttr ] );
  DeclareOperation( "nLHnumber",
      [ IsConjugacyClassSubgroupsRep, IsConjugacyClassSubgroupsRep ] );

#############################################################################
##
#O  pCyclicGroup( <n> )
#O  mCyclycGroup( <n> )
#O  pDihedralGroup( <n> )
#O  mDihedralGroup( <n> )
##
  DeclareOperation( "pCyclicGroup", [ IsPosInt ] );
  DeclareOperation( "mCyclicGroup", [ IsPosInt ] );
  DeclareOperation( "pDihedralGroup", [ IsPosInt ] );
  DeclareOperation( "mDihedralGroup", [ IsPosInt ] );

#############################################################################
##
#R  IsLatticeCCSsRep
##
  DeclareRepresentation( "IsLatticeCCSsRep", IsLatticeRep, [ ] );

#############################################################################
##
#A  LatticeCCSs( <grp> )
##
  DeclareAttribute( "LatticeCCSs", IsGroup );
  DeclareAttribute( "ConjugacyClassesSubgroups", IsLatticeCCSsRep );
  DeclareAttribute( "LatticeSubgroups", IsLatticeCCSsRep );

#############################################################################
##
#E  Basic.gd . . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
