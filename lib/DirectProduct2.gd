#############################################################################
##
#W  DirectProduct2.gd	GAP Package `EquiDeg'			    Haopin Wu
##
#Y  Copyright (C) 2017-2018, Haopin Wu
#Y  Department of Mathematics, National Tsing Hua University, Taiwan
##
##  This file contains declarations for procedures related to direct proudct
##  of a finite group and an elementary compact Lie group (ECLG).
##
##  Todo:
##

#############################################################################
##
#C  IsDirectProductWithECLG
##
  DeclareCategory( "IsDirectProductWithECLG", IsCompactLieGroup );

#############################################################################
##
#R  IsDirectProductWithECLGCCSRep
##
  DeclareRepresentation( "IsDirectProductWithECLGCCSRep", IsCompactLieGroupCCSRep, [ ] );

#############################################################################
##
#R  IsDirectProductWithECLGCCSsRep
##
  DeclareRepresentation( "IsDirectProductWithECLGCCSsRep", IsCompactLieGroupCCSsRep, [ ] );

#############################################################################
##
#A  GoursatInfo( <C> )
##
  DeclareAttribute( "GoursatInfo", IsDirectProductWithECLGCCSRep );


#############################################################################
##
#E  DirectProduct2.gd . . . . . . . . . . . . . . . . . . . . . . . ends here
