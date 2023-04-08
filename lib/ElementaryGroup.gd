#############################################################################
##
#W  Group.gd		GAP Package `EquiDeg'			    Haopin Wu
##
#Y  Copyright (C) 2017-2023, Haopin Wu
##
##  This file contains declarations for procedures related to group theory.
##
##  Todo:
##

## Part 1: Special Groups

#############################################################################
##
#F  pCyclicGroup( <n> )
#F  mCyclicGroup( <n> )
#F  pDihedralGroup( <n> )
#F  mDihedralGroup( <n> )
##
##  <#GAPDoc Label="BasicGroups">
##  <ManSection>
##  <Heading>Basic Groups</Heading>
##  <Func Name="pCyclicGroup" Arg="n"/>
##  <Func Name="mCyclicGroup" Arg="n"/>
##  <Func Name="pDihedralGroup" Arg="n"/>
##  <Func Name="mDihedralGroup" Arg="n"/>
##  <Description>
##  These global functions implement cyclic groups and dihedral groups
##  in two different ways: they either consist of
##  permutations (<C>pCyclicGroup</C> and <C>pDihedralGroup</C>) or
##  2-by-2 matrices (<C>mCyclicGroup</C> and <C>mDihedralGroup</C>).
##  <P/>
##
##  Each implementation has its own advantage:
##  while computation related to permutations
##  is performed more efficiently,
##  matrix implementation allows a natural embedding
##  from a smaller group into a bigger one.
##  Here is an example.
##  <Example>
##  gap> G1 := pCyclicGroup( 4 );;
##  gap> List( G1 );
##  [ (), (1,3)(2,4), (1,4,3,2), (1,2,3,4) ]
##  gap> G2 := mCyclicGroup( 4 );;
##  gap> List( G2 );
##  [ [ [ -1, 0 ], [ 0, -1 ] ], [ [ 0, -1 ], [ 1, 0 ] ], [ [ 0, 1 ], [ -1, 0 ] ],
##  [ [ 1, 0 ], [ 0, 1 ] ] ]
##  gap> G3 := pCyclicGroup( 2 );;
##  gap> G4 := mCyclicGroup( 2 );;
##  gap> IsSubgroup( G1, G3 );
##  false
##  gap> IsSubgroup( G2, G4 );
##  true
##  </Example>
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareGlobalFunction( "pCyclicGroup",
      "generates a cyclic group which consists of permutations" );
  DeclareGlobalFunction( "mCyclicGroup",
      "generates a cyclic group which consists of 2-by-2 matrices" );
  DeclareGlobalFunction( "pDihedralGroup",
      "generates a dihedral group which consists of permutations." );
  DeclareGlobalFunction( "mDihedralGroup",
      "generates a dihedral group which consists of 2-by-2 matices." );


#############################################################################
##
#E  ElementaryGroup.gd . . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
