#############################################################################
##
#W  Polynomial.gd	GAP Package `EquiDeg'			    Haopin Wu
##
#Y  Copyright (C) 2017-2019, Haopin Wu
#Y  Department of Mathematics, National Tsing Hua University, Taiwan
##
##  This file contains declarations for procedures related to polynomial.
##

#############################################################################
##
#A  LowestDegree( <lpol> )
##
##  <#GAPDoc Label="LowestDegree">
##  <ManSection>
##  <Attr Name="LowestDegree" Arg="lpol"/>
##  <Description>
##  This is an attribute of a Laurent which
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareAttribute( "LowestDegree", IsLaurentPolynomial );

#############################################################################
##
#O  Coefficient( <lpol>, <n> )
##
  DeclareOperation( "Coefficient", [ IsLaurentPolynomial, IsInt ] );


#############################################################################
##
#E  Group.gd . . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
