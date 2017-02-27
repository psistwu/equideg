# GAP: Basic Group Theory Library #

### Synopsis ###
#---
# Declaration file of libBasicGroupTheory.g
#---

### Author ###
#---
# Hao-pin Wu <hxw132130@utdallas.edu>
#---


## Section 1: Lattice of Conjugacy Classes of Subgroups ##

### category ###

  DeclareCategory( "IsLatticeCCSs", CategoryCollections( CategoryCollections( CategoryCollections( IsMultiplicativeElementWithInverse ) ) ) );


### representation ###

  DeclareRepresentation( "IsLatticeCCSsRep", IsAttributeStoringRep, [ "conjugacyClassesSubgroups", "group" ]);


### constructor ###

#---
# LatticeCCSs( G ) is the constructor of lattice of CCSs of G.
#	It is also an attribute of G.
#---
  DeclareAttribute( "LatticeCCSs", IsGroup );

### attribute ###

#---
#MaximalSubCCSsLattice( lat ) finds maximal subCCSs of
#	each CCS in the lattice.
#---
  DeclareAttribute( "MaximalSubCCSsLattice", IsLatticeCCSs );

#---
#MinimalSupCCSsLattice( lat ) finds minimal supCCSs of
#	each CCS in the lattice.
#---
  DeclareAttribute( "MinimalSupCCSsLattice", IsLatticeCCSs );

### method ###

#---
#DotFileLatticeCCSs( lat, file ) export the lattice of CCSs as a dot file
#---
  DeclareOperation( "DotFileLatticeCCSs", [ IsLatticeCCSs, IsString ] );


## Section 2: general tools ##

### attribute ###
  DeclareAttribute( "CCSubgroups", IsGroup and HasParentAttr );

### operation ###
  DeclareOperation( "nLHnumber", [ IsGroup and HasParentAttr, IsGroup and HasParentAttr ] );

### function ###
  DeclareGlobalFunction( "pCyclicGroup" );

  DeclareGlobalFunction( "pDihedralGroup" );

  DeclareGlobalFunction( "removeExtraConjugateCopies" );

