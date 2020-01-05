#############################################################################
##
#W  OrbitType.gd	GAP Package `EquiDeg' 			    Haopin Wu
##
#Y  Copyright (C) 2017-2018, Haopin Wu
#Y  Department of Mathematics, National Tsing Hua University, Taiwan
##
##  This file contains declarations of procedures related to orbit types.
##
##  Todo:
##    1. Think how to arrange <AlphaCharacteristic> and <IsAGroup>;
##       they are not needed in this package for the time being.
##    2. Fix the naming of components.
##

#############################################################################
##
#R  IsLatticeOrbitTypesRep
##
##  <#GAPDoc Label="IsLatticeOrbitTypesRep">
##  <ManSection>
##  <Filt Name="IsLatticeOrbitTypesRep" Type="representation"/>
##  <Description>
##    This is the representation of lattice of orbit types.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareRepresentation( "IsLatticeOrbitTypesRep", IsLatticeRep, [ ] );

#############################################################################
##
#O  DimensionOfFixedSet( <chi>, <H> )
#O  DimensionOfFixedSet( <chi>, <cH> )
##
##  <#GAPDoc Label="DimensionOfFixedSet">
##  <ManSection>
##  <Oper Name="DimensionOfFixedSet" Arg="chi, H"/>
##  <Oper Name="DimensionOfFixedSet" Arg="chi, cH" Label="ccs"/>
##  <Description>
##    This operation computes dimension of fixed point space
##    of <A>H</A> with respect to character <A>chi</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareOperation( "DimensionOfFixedSet", [ IsCharacter, IsGroup ] );
  DeclareOperation( "DimensionOfFixedSet",
      [ IsCharacter, IsConjugacyClassSubgroupsRep ] );

#############################################################################
##
#A  OrbitTypes( <chi> )
##
##  <#GAPDoc Label="OrbitTypes">
##  <ManSection>
##  <Attr Name="OrbitTypes" Arg="chi"/>
##  <Description>
##    This attribute contains the list of orbit types associated to
##    character <A>chi</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareAttribute( "OrbitTypes", IsCharacter );
  DeclareAttribute( "OrbitTypes", IsLatticeOrbitTypesRep );

#############################################################################
##
#F  NewLatticeOrbitTypes( <chi> )
##
##  <#GAPDoc Label="NewLatticeOrbitTypes">
##  <ManSection>
##  <Func Name="NewLatticeOrbitTypes" Arg="chi"/>
##  <Description>
##    This is the general constructor of lattice of orbit types.
##    The underlying group of character <A>chi</A>
##    need not to be finite.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##  
  DeclareGlobalFunction( "NewLatticeOrbitTypes",
      "constructor of lattice of orbit types" );

#############################################################################
##
#A  LatticeOrbitTypes( <chi> )
##
##  <#GAPDoc Label="LatticeOrbitTypes">
##  <ManSection>
##  <Attr Name="LatticeOrbitTypes" Arg="chi"/>
##  <Description>
##    This attribute contains the lattice of orbit types associated to
##    finite group character <A>chi</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareAttribute( "LatticeOrbitTypes", IsCharacter );

#############################################################################
##
#A  Character( <lat> )
##
  DeclareAttribute( "Character", IsLatticeOrbitTypesRep );

#############################################################################
##
#A  MaximalOrbitTypes( <chi> )
##
##  <#GAPDoc Label="MaximalOrbitTypes">
##  <ManSection>
##  <Attr Name="MaximalOrbitTypes" Arg="chi"/>
##  <Description>
##    This attribute contains the list of maximal orbit types for
##    charater <A>chi</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareAttribute( "MaximalOrbitTypes", IsCharacter );


##  What follows are not needed now

#############################################################################
##
#A  AlphaCharacteristic( <chi> )
##
##  <#GAPDoc Label="AlphaCharacteristic">
##  <ManSection>
##  <Attr Name="AlphaCharacteristic" Arg="chi"/>
##  <Description>
##    This attribute contains the alpha-characteristic for
##    character <A>chi</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
# DeclareAttribute( "AlphaCharacteristic", IsCharacter );

#############################################################################
##
#P  IsAGroup( <grp> )
##
##  <#GAPDoc Label="IsAGroup">
##  <ManSection>
##  <Attr Name="IsAGroup" Arg="grp"/>
##  <Description>
##    This property indicates whether <A>grp</A> is an A-group.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
# DeclareProperty( "IsAGroup", IsGroup );


#############################################################################
##
#E  OrbitType.gd . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
