#############################################################################
##
#W  DirectProduct1.gd	GAP Package `EquiDeg'			    Haopin Wu
##
#Y  Copyright (C) 2017-2018, Haopin Wu
#Y  Department of Mathematics, National Tsing Hua University, Taiwan
##
##  This file contains declarations for procedures related to direct proudct
##  of finite groups.
##
##  Todo:
##

#############################################################################
##
#A  DirectProductDecomposition( <G> )
##
  DeclareAttribute( "DirectProductDecomposition", IsGroup );

#############################################################################
##
#A  DirectProductDecomposition( <C> )
##
  DeclareAttribute( "DirectProductDecomposition",
      IsConjugacyClassGroupRep );

#############################################################################
##
#A  TensorProductDecomposition( <chi> )
##
  DeclareAttribute( "TensorProductDecomposition", IsCharacter );

#############################################################################
##
#O  DirectProductDecomposition( <G>, <e> )
##
  DeclareOperation( "DirectProductDecomposition",
      [ IsGroup, IsMultiplicativeElementWithInverse ] );

#############################################################################
##
#A  GoursatInfo( <U> )
#A  GoursatInfo( <C> )
##
  DeclareAttribute( "GoursatInfo", IsGroup and HasParentAttr );
  DeclareAttribute( "GoursatInfo", IsConjugacyClassSubgroupsRep );

#############################################################################
##
#O  AmalgamationSymbol
##
  DeclareOperation( "AmalgamationSymbol",
      [ IsConjugacyClassSubgroupsRep ] );


#############################################################################
##
#E  DirectProduct1.gd . . . . . . . . . . . . . . . . . . . . . . . ends here
