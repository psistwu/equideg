#############################################################################
##
#W  Group.gd		GAP Package `EquiDeg'			    Haopin Wu
##
#Y  Copyright (C) 2017-2019, Haopin Wu
#Y  Department of Mathematics, National Tsing Hua University, Taiwan
##
##  This file contains declarations for procedures related to group theory.
##
##  Todo:
##    1. Fix the naming of components.
##

## Part 1: Basic Groups

#############################################################################
##
#F  pCyclicGroup( <n> )
##
##  <#GAPDoc Label="pCyclicGroup">
##  <ManSection>
##  <Func Name="pCyclicGroup" Arg="n"/>
##  <Description>
##    generates a cyclic group <M>Z_n</M>
##    which consists of permutations.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareGlobalFunction( "pCyclicGroup",
      "generates a cyclic group which consists of permutations" );

#############################################################################
##
#F  mCyclicGroup( <n> )
##
##  <#GAPDoc Label="mCyclicGroup">
##  <ManSection>
##  <Func Name="mCyclicGroup" Arg="n"/>
##  <Description>
##    generates a cyclic group <M>Z_n</M>
##    which consists of 2-by-2 matrices.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareGlobalFunction( "mCyclicGroup",
      "generates a cyclic group which consists of 2-by-2 matrices" );

#############################################################################
##
#F  pDihedralGroup( <n> )
##
##  <#GAPDoc Label="pDihedralGroup">
##  <ManSection>
##  <Func Name="pDihedralGroup" Arg="n"/>
##  <Description>
##    generates a dihedral group <M>D_n</M>
##    which consists of permutations.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareGlobalFunction( "pDihedralGroup",
      "generates a dihedral group which consists of permutations." );

#############################################################################
##
#F  mDihedralGroup( <n> )
##
##  <#GAPDoc Label="mDihedralGroup">
##  <ManSection>
##  <Func Name="mDihedralGroup" Arg="n"/>
##  <Description>
##    generates a dihedral group <M>D_n</M>
##    which consists of 2-by-2 matices.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareGlobalFunction( "mDihedralGroup",
      "generates a dihedral group which consists of 2-by-2 matices." );


## Part 2: Group Theory

#############################################################################
##
#A  IdCC( <c> )
##
  DeclareAttribute( "IdCC", IsConjugacyClassGroupRep );

#############################################################################
##
#A  IdCCS( <C> )
##
  DeclareAttribute( "IdCCS", IsConjugacyClassSubgroupsRep );

#############################################################################
##
#F  IdCCSPartialOrder( <id1>, <id2> )
##
  DeclareGlobalFunction( "IdCCSPartialOrder",
      "partial order of id of CCS" );

#############################################################################
##
#O  ConjugacyClassSubgroups( <H> )
##
##  <#GAPDoc Label="ConjugacyClassSubgroups">
##  <ManSection>
##  <Oper Name="ConjugacyClassSubgroups" Arg="H"/>
##  <Description>
##    This is a modified version of
##    <Ref Oper="ConjugacyClassSubgroups" BookName="Reference"/>,
##    which returns
##    <C>ConjugacyClassSubgroups( <A>H</A>,
##    ParentAttr( <A>H</A> ) )</C>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##

#############################################################################
##
#A  OrderOfRepresentative( <C> )
##
  DeclareAttribute( "OrderOfRepresentative", IsConjugacyClassSubgroupsRep );

#############################################################################
##
#O  nLHnumber( <L>, <H> )
#O  nLHnumber( <CL>, <CH> )
##
##  <#GAPDoc Label="nLHnumber">
##  <ManSection>
##  <Oper Name="nLHnumber" Arg="L, H"/>
##  <Oper Name="nLHnumber" Arg="CL, CH" Label="ccs"/>
##  <Description>
##    This operation computes <M>n(<A>L</A>,<A>H</A>)</M>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareOperation( "nLHnumber",
      [ IsGroup and HasParentAttr, IsGroup and HasParentAttr ] );
  DeclareOperation( "nLHnumber",
      [ IsConjugacyClassSubgroupsRep, IsConjugacyClassSubgroupsRep ] );

#############################################################################
##
#O  \<( <C1>, <C2> )
##
##  <#GAPDoc Label="LessThan">
##  <ManSection>
##  <Oper Name="&bslash;&lt;" Arg="C1, C2"/>
##  <Description>
##    This is the standard partial order relation defined
##    on the collection of CCSs.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##

#############################################################################
##
#A  OrderOfWeylGroup( <U> )
#A  OrderOfWeylGroup( <C> )
##
##  <#GAPDoc Label="OrderOfWeylGroup">
##  <ManSection>
##  <Attr Name="OrderOfWeylGroup" Arg="U"/>
##  <Attr Name="OrderOfWeylGroup" Arg="C" Label="ccs"/>
##  <Description>
##    This attribute contains the order of the Weyl group for given
##    subgroup <A>U</A> or CCS <A>C</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareAttribute( "OrderOfWeylGroup", IsGroup and HasParentAttr );
  DeclareAttribute( "OrderOfWeylGroup", IsConjugacyClassSubgroupsRep );


#############################################################################
##
#R  IsLatticeCCSsRep
##
##  <#GAPDoc Label="IsLatticeCCSsRep">
##  <ManSection>
##  <Filt Name="IsLatticeCCSsRep"/>
##  <Description>
##    This is the representation of lattice of CCSs.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareRepresentation( "IsLatticeCCSsRep", IsLatticeRep, [ ] );

#############################################################################
##
#A  LatticeCCSs( <grp> )
##
##  <#GAPDoc Label="LatticeCCSs">
##  <ManSection>
##  <Attr Name="LatticeCCSs" Arg="grp"/>
##  <Description>
##    This attribute contains lattice of CCSs of <A>grp</A>.
##    Its return object <C>lat</C> admits attribute
##    <Ref Attr="ConjugacyClassesSubgroups" BookName="Reference"/>
##    for retriving the underlying CCS list.
##    In addition, one can call <Ref Oper="DotFileLattice"/>
##    on <C>lat</C> to export <C>.dot</C> files,
##    which can be later converted
##    into <C>.eps</C> or <C>.pdf</C> files.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareAttribute( "LatticeCCSs", IsGroup );

#############################################################################
##
#A  ConjugacyClassesSubgroups( lat_ccss )
##
  DeclareAttribute( "ConjugacyClassesSubgroups", IsLatticeCCSsRep );


##  Character and Representation Theory

#############################################################################
##
#A  IdIrr( chi )
##
  DeclareAttribute( "IdIrr", IsCharacter );


#############################################################################
##
#E  Group.gd . . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
