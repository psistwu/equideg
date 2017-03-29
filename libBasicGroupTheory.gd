# Declaration file of libBasicGroupTheory.g


## part 1: lattice of conjugacy classes of subgroups ##

### category ###
#---
  DeclareCategory( "IsLatticeCCSs", CategoryCollections( CategoryCollections( CategoryCollections( IsMultiplicativeElementWithInverse ) ) ) );
#---

### representation ###
#---
  DeclareRepresentation( "IsLatticeCCSsRep", IsAttributeStoringRep, [ "conjugacyClassesSubgroups", "group" ]);
#---

### constructor ###

#---
# LatticeCCSs( G ) is the constructor of lattice of CCSs of G.
#	It is also an attribute of G.
#---
  DeclareAttribute( "LatticeCCSs", IsGroup );
#---

### attribute ###

#---
# MaximalSubCCSsLattice( lat ) finds maximal subCCSs of
#	each CCS in the lattice.
#---
  DeclareAttribute( "MaximalSubCCSsLattice", IsLatticeCCSs );
#---

#---
# MinimalSupCCSsLattice( lat ) finds minimal supCCSs of
#	each CCS in the lattice.
#---
  DeclareAttribute( "MinimalSupCCSsLattice", IsLatticeCCSs );
#---

### method ###

#---
# DotFileLatticeCCSs( lat, file ) export the lattice of CCSs as a dot file
#---
  DeclareOperation( "DotFileLatticeCCSs", [ IsLatticeCCSs, IsString ] );
#---


## part 2: general tools ##

### attribute ###

#---
# CCSubgroups( subg ) returns the CCS which contains subg
#---
  DeclareAttribute( "CCSubgroups", IsGroup and HasParentAttr );
#---

### operation ###

#---
# aConjugacyClassSubgroups( G, H ) returns the CCS of H with respect to G
#---
  DeclareOperation( "aConjugacyClassSubgroups", [ IsGroup, IsGroup ] );
#---

#---
#nLHnumber( L, H ) finds n(L,H), i.e.,	the number of subgroups
#	conjugate to H which contain L
#---
  DeclareOperation( "nLHnumber", [ IsGroup, IsGroup, IsGroup ] );
#---

### function ###

#---
# pCyclicGroup( n ) creates permutational Z_n
#---
  DeclareGlobalFunction( "pCyclicGroup" );

  DeclareGlobalFunction( "pDihedralGroup" );

