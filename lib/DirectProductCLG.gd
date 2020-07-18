#############################################################################
##
#W  DirectProductCLG.gd	GAP Package `EquiDeg'			    Haopin Wu
##
#Y  Copyright (C) 2017-2018, Haopin Wu
#Y  Department of Mathematics, National Tsing Hua University, Taiwan
##
##  This file contains declarations for procedures related to direct proudct
##  of a finite group and an elementary compact Lie group (ECLG).
##

#############################################################################
##
#O  DirectProduct( <ECLG>, <G1>[, <G2>, ....] )
##
##  <#GAPDoc Label="clg_DirectProduct">
##  <ManSection>
##  <Oper Name="DirectProduct" Label="compact Lie group"
##      Arg="ECLG, G1[, G2, ...]"/>
##  <Description>
##    This operation returns the direct product of a compact Lie group
##    <A>ECLG</A> and finite group(s) <A>G1</A> (and <A>G2</A>,...).
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##

#############################################################################
##
#O  \[\,\]( <irrs>, <l>, <j> )
##
##  <#GAPDoc Label="CompactLieGroupIrrCollectionSelector">
##  <ManSection>
##  <Oper Name="\[\,\]"
##      Arg="irrs, l, j"/>
##  <Description>
##    This is the selector of complete list of irreducible representations
##    of a compact Lie group.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
DeclareOperation( "[,]",
    [ IsCompactLieGroupIrrCollection, IsInt, IsPosInt ] );

#############################################################################
##
#E  DirectProductCLG.gd . . . . . . . . . . . . . . . . . . . . . . ends here
