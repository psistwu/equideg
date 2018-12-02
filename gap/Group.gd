# # GAP: Group Theory Library
#
# Declaration file of libGroup.g
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#

# ## Part 1: General Tools
# ### attribute(s)
  DeclareAttribute( "ConjugacyClassSubgroups", IsGroup and HasParentAttr );
  DeclareAttribute( "OrderOfWeylGroup", IsGroup and HasParentAttr );
  DeclareAttribute( "OrderOfWeylGroup", IsConjugacyClassSubgroupsRep );


# ### Operation(s)
  DeclareOperation( "nLHnumber",
      [ IsGroup and HasParentAttr, IsGroup and HasParentAttr ] );
  DeclareOperation( "nLHnumber",
      [ IsConjugacyClassSubgroupsRep, IsConjugacyClassSubgroupsRep ] );
  DeclareOperation( "pCyclicGroup", [ IsPosInt ] );
  DeclareOperation( "mCyclicGroup", [ IsPosInt ] );
  DeclareOperation( "pDihedralGroup", [ IsPosInt ] );
  DeclareOperation( "mDihedralGroup", [ IsPosInt ] );



# ## Part 2: Lattice of Conjugacy Classes of Subgroups
# ### representation(s)
  DeclareRepresentation( "IsLatticeCCSsRep", IsLatticeRep, [ ] );


# ### Attribute(s)
  DeclareAttribute( "LatticeCCSs", IsGroup );
  DeclareAttribute( "ConjugacyClassesSubgroups", IsLatticeCCSsRep );
  DeclareAttribute( "LatticeSubgroups", IsLatticeCCSsRep );

