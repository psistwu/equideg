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
#O  DirectProductDecomposition( <G> )
##
  DeclareOperation( "DirectProductDecomposition", [ IsGroup ] );

#############################################################################
##
#O  DirectProductDecomposition( <C> )
##
  DeclareOperation( "DirectProductDecomposition",
      [ IsConjugacyClassGroupRep ] );

#############################################################################
##
#O  DirectProductDecomposition( <chi> )
##
  DeclareOperation( "DirectProductDecomposition", [ IsCharacter ] );

#############################################################################
##
#O  DirectProductDecomposition( <G>, <e> )
##
  DeclareOperation( "DirectProductDecomposition",
      [ IsGroup, IsMultiplicativeElementWithInverse ] );

#############################################################################
##
#A  GoursatInfo( <U> )
##
  DeclareAttribute( "GoursatInfo", IsGroup and HasParentAttr );

#############################################################################
##
#O  AmalgamationSymbol
##
  DeclareOperation( "AmalgamationSymbol",
      [ IsConjugacyClassSubgroupsRep ] );


#############################################################################
##
#E  DirectProduct1.gd . . . . . . . . . . . . . . . . . . . . . . . ends here
