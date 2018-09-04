# # GAP: Group Theory Library
#
# Declaration file of libGroup.g
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#


# ## part 1: general tools
# ### attribute(s)
  # ConjugacyClassSubgroups( subg ) returns the CCS which contains subg
  DeclareAttribute( "ConjugacyClassSubgroups", IsGroup and HasParentAttr );

  # order Of Weyl group
  DeclareAttribute( "OrderOfWeylGroup", IsGroup and HasParentAttr );
  DeclareAttribute( "OrderOfWeylGroup", IsConjugacyClassSubgroupsRep );


# ### operation(s)
  # nLHnumber( L, H ) returns the number of subgroups conjugate to H which contain L
  DeclareOperation( "nLHnumber", [ IsGroup and HasParentAttr, IsGroup and HasParentAttr ] );
  DeclareOperation( "nLHnumber", [ IsConjugacyClassSubgroupsRep, IsConjugacyClassSubgroupsRep ] );

  # pCyclicGroup( n ) generates permutational Z_n
  DeclareOperation( "pCyclicGroup", [ IsPosInt ] );

  # mCyclicGroup( n ) generates Z_n as a matrix group
  DeclareOperation( "mCyclicGroup", [ IsPosInt ] );

  # pDihedralGroup( n ) generates permutational D_n
  DeclareOperation( "pDihedralGroup", [ IsPosInt ] );

  # mDihedralGroup( n ) generates D_n as a matrix group
  DeclareOperation( "mDihedralGroup", [ IsPosInt ] );


# ## part 2: lattice of conjugacy classes of subgroups
# ### representation(s)
  DeclareRepresentation( "IsLatticeCCSsRep", IsLatticeRep, [ ] );

# ### attribute(s)
  DeclareAttribute( "LatticeCCSs", IsGroup );
  DeclareAttribute( "ConjugacyClassesSubgroups", IsLatticeCCSsRep );
  DeclareAttribute( "LatticeSubgroups", IsLatticeCCSsRep );
