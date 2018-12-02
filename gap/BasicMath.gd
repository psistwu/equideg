# # GAP: Basic Math Library
#
# Declaration file of libBasic.g
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#


# ## Part 1: Lattice
# ### Representation(s)
  DeclareRepresentation( "IsLatticeRep", IsComponentObjectRep and IsAttributeStoringRep, [ ] );


# ### Constructor(s)
  DeclareConstructor( "Lattice", [ IsLatticeRep, IsHomogeneousList ] );


# ### Attribute(s)
  DeclareAttribute( "MaximalSubElementsLattice", IsCollection and IsLatticeRep );
  # The next attribute is yet to be implemented.
  DeclareAttribute( "MinimalSupElementsLattice", IsCollection and IsLatticeRep );


# ### Operation(s)
  DeclareOperation( "DotFileLattice", [ IsLatticeRep, IsString ] );



# ## Part 2: Poset
# ### Operation(s)
  DeclareOperation( "TopologicalSort", [ IsList and IsMutable, IsFunction ] );
  DeclareOperation( "IsSortedPoset", [ IsList, IsFunction ] );

