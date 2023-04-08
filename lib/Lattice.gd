#############################################################################
##
#W  Lattice.gd		GAP Package `EquiDeg'			    Haopin Wu
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
#R  IsLatticeRep
##
##  <#GAPDoc Label="IsLatticeRep">
##  <ManSection>
##  <Filt Name="IsLatticeRep" Type="representation"/>
##  <Description>
##    This is a lattice representation of a poset,
##    which allows visualization of its hierarchy structure.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareRepresentation( "IsLatticeRep",
    IsComponentObjectRep and IsAttributeStoringRep, [ ] );

#############################################################################
##
#F  NewLattice( <filter>, <r> )
##
##  <#GAPDoc Label="NewLattice">
##  <ManSection>
##  <Func Name="NewLattice" Arg="filter, r"/>
##  <Description>
##    generates the lattice representation of a poset.
##    Record <A>r</A> must contain the following fields:
##    <List>
##    <Mark><C>poset</C></Mark>
##    <Item>
##      A sorted poset.
##    </Item>
##    <Mark><C>node_labels</C></Mark>
##    <Item>
##      A list of node labels for elements in the poset.
##      The order of the list corresponds to that of <C>poset</C>.
##    </Item>
##    <Mark><C>node_shapes</C></Mark>
##    <Item>
##      A list of node shapes for elements in the poset.
##      The order of the list corresponds to that of <C>poset</C>.
##    </Item>
##    <Mark><C>rank_label</C></Mark>
##    <Item>
##      A string indicating the type of the rank of the lattice.
##      For example, for a CCS lattice of a group,
##      a type of rank can be order of subgroup;
##      for a orbit type lattice of a group representation,
##      a type of rank can be dimension of fixed space.
##    </Item>
##    <Mark><C>ranks</C></Mark>
##    <Item>
##      A list of rank for elements in the poset.
##      The order of the list corresponds to that of <C>poset</C>.
##    </Item>
##    <Mark><C>is_rank_reversed</C></Mark>
##    <Item>
##      A booling value which indicates how the lattice will be
##      organized: either putting low rank elements above
##      (if the value is <C>false</C>) or
##      putting high rank elements above
##      (if the value is <C>true</C>).
##    </Item>
##    </List>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
DeclareGlobalFunction( "NewLattice", "constructor of Lattice" );

#############################################################################
##
#A  UnderlyingPoset( <lat> )
##
##  <#GAPDoc Label="UnderlyingPoset">
##  <ManSection>
##  <Attr Name="UnderlyingPoset" Arg="lat"/>
##  <Description>
##    returns the underlying poset of <A>lat</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareAttribute( "UnderlyingPoset", IsLatticeRep );

#############################################################################
##
#A  MaximalSubElementsLattice( <lat> )
##
##  <#GAPDoc Label="MaximalSubElementsLattice">
##  <ManSection>
##  <Attr Name="MaximalSubElementsLattice" Arg="lat"/>
##  <Description>
##    For lattice <A>lat</A>, this attribute contains the
##    list of maximal sub-elements, which is described by
##    indices corresponding to <C>UnderlyingPoset( <A>lat</A> )</C>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareAttribute( "MaximalSubElementsLattice",
    IsCollection and IsLatticeRep );

#############################################################################
##
#A  MinimalSupElementsLattice( <lat> )	(not yet implemented)
##
##  <#GAPDoc Label="MinimalSupElementsLattice">
##  <ManSection>
##  <Attr Name="MinimalSupElementsLattice" Arg="lat"/>
##  <Description>
##    For a lattice <A>lat</A>, this attribute contains the
##    list of minimal sup-elements, which is a list of indices
##    corresponding to <A>lat!.silst</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
# DeclareAttribute( "MinimalSupElementsLattice",
#     IsCollection and IsLatticeRep );

#############################################################################
##
#O  DotFileLattice( <lat>, <filename> )
##
##  <#GAPDoc Label="DotFileLattice">
##  <ManSection>
##  <Oper Name="DotFileLattice" Arg="lat, filename"/>
##  <Description>
##    This function produces graphical representation of the CCSs
##    lattice <A>lat</A> in file <A>filename</A>.
##    The output is in <C>.dot</C> format.
##    For details and information about this format,
##    please see <URL>https://www.graphviz.org</URL>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareOperation( "DotFileLattice", [ IsLatticeRep, IsString ] );


#############################################################################
##
#E  Lattice.gd . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
