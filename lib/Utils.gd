#############################################################################
##
#W  Utils.gd		GAP package `EquiDeg'			    Haopin Wu
##
#Y  Copyright (C) 2017-2018, Haopin Wu
#Y  Department of Mathematics, National Tsing Hua University, Taiwan
##
##  This file contains declarations for utilities.
##

##  Part 1: EquiDeg Info Class

#############################################################################
##
#V  INFO_LEVEL_EquiDeg
##
##  <#GAPDoc Label="INFO_LEVEL_EquiDeg">
##  <ManSection>
##  <Var Name="INFO_LEVEL_EquiDeg"/>
##  <Description>
##    is the info level regarding the usage of
##    <Ref BookName="Reference" Func="Info"/> throughout the package;
##    its default value is 1.
##    Since higher value results in more detailed feedback,
##    one can increase the value for debugging purpose.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  BindGlobal( "INFO_LEVEL_EquiDeg", 1 );

#############################################################################
##
#I  InfoEquiDeg
##
##  <#GAPDoc Label="InfoEquiDeg">
##  <ManSection>
##  <InfoClass Name="InfoEquiDeg"/>
##  <Description>
##    is the default info class throughout the package.
##    Its default info level is 1.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareInfoClass( "InfoEquiDeg" );
  SetInfoLevel( InfoEquiDeg, 1 );


##  Part 2: LaTeX Typesettings

#############################################################################
##
#A  LaTeXString( <obj> )
##
##  <#GAPDoc Label="LaTeXString">
##  <ManSection>
##  <Attr Name="LaTeXString" Arg="obj"/>
##  <Description>
##    stores the LaTeX representation of an object.
##    This attribute is supposed to be assigned manually.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareAttribute( "LaTeXString", IsObject );

#############################################################################
##
#O  LaTeXTypesetting( <obj> )
##
##  <#GAPDoc Label="LaTeXTypesetting">
##  <ManSection>
##  <Attr Name="LaTeXTypesetting" Arg="obj"/>
##  <Description>
##    returns the LaTeX typesetting of an object.
##    In default, it simply calls <Ref Attr="LaTeXString"/>.
##    However, it may behave differently for
##    objects of different categories.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##
  DeclareOperation( "LaTeXTypesetting", [ IsObject ] );

#############################################################################
##
#E  Utils.gd . . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
