# # GAP: Basic Math Library
#
# Declaration file of libBasic.g
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#


# ## part 1: Lattice
# ### representation(s)
  DeclareRepresentation( "IsLatticeRep", IsComponentObjectRep and IsAttributeStoringRep, [ ] );


# ### constructor(s)
  DeclareConstructor( "Lattice", [ IsLatticeRep, IsHomogeneousList ] );


# ### attribute(s)
  DeclareAttribute( "MaximalSubElementsLattice", IsCollection and IsLatticeRep );
  # The next attribute is yet to be implemented.
  DeclareAttribute( "MinimalSupElementsLattice", IsCollection and IsLatticeRep );


# ### operation(s)
  DeclareOperation( "DotFileLattice", [ IsLatticeRep, IsString ] );

