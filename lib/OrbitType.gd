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
##    This is a representation of lattice of orbit types.
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
#A  LatticeOrbitTypes( <chi> )
##
##  <#GAPDoc Label="LatticeOrbitTypes">
##  <ManSection>
##  <Attr Name="LatticeOrbitTypes" Arg="chi"/>
##  <Description>
##    This attribute contains the lattice of orbit types for
##    character <A>chi</A>.
##    Its return object <C>lat</C>
##    admits attributes <C>Character</C>
##    and <Ref Attr="OrbitTypes"/> for
##    retriving underlying character and orbit types,
##    respectively.
##    In addition, one can call <Ref Oper="DotFileLattice"/>
##    on <C>lat</C> to export <C>.dot</C> files,
##    which can be later converted
##    into <C>.eps</C> or <C>.pdf</C> files.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareAttribute( "LatticeOrbitTypes", IsCharacter );

#############################################################################
##
#A  Character( <lat> )
##
##  <#GAPDoc Label="Character">
##  <ManSection>
##  <Attr Name="Character" Arg="lat"/>
##  <Description>
##    returns the underlying character of <A>lat</A>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareAttribute( "Character", IsLatticeOrbitTypesRep );

#############################################################################
##
#O  MaximalOrbitTypes( <chi> )
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
  DeclareOperation( "MaximalOrbitTypes", [ IsCharacter ] );


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
