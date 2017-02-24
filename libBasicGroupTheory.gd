# GAP: Basic Group Theory Library #

### Synopsis ###
#---
# Declaration file of libBasicGroupTheory.g
#---

### Author ###
#---
# Hao-pin Wu <hxw132130@utdallas.edu>
#---


## Part 1: Lattice of Conjugacy Classes of Subgroups ##

### category ###
  DeclareCategory( "IsLatticeCCSs", CategoryCollections( CategoryCollections( CategoryCollections( IsMultiplicativeElementWithInverse ) ) ) );

### representation ###
  DeclareRepresentation( "IsLatticeCCSsRep", IsAttributeStoringRep, [ "conjugacyClassesSubgroups", "group" ]);

### constructor ###

#### LatticeCCSs ####
#---
# LatticeCCSs( G ) is the constructor of lattice of CCSs of G.
#	It is also an attribute of G.
#---
  DeclareAttribute( "LatticeCCSs", IsGroup );

### attribute ###
  DeclareAttribute( "MaximalSubCCSsLattice", IsLatticeCCSs );

  DeclareAttribute( "MinimalSupCCSsLattice", IsLatticeCCSs );


## Part 2: general tools ##

### attribute ###
  DeclareAttribute( "CCSubgroups", IsGroup and HasParentAttr );

### operation ###
  DeclareOperation( "nLHnumber", [ IsGroup and HasParentAttr, IsGroup and HasParentAttr ] );

### function ###
  DeclareGlobalFunction( "pCyclicGroup" );

  DeclareGlobalFunction( "pDihedralGroup" );

  DeclareGlobalFunction( "removeExtraConjugateCopies" );

