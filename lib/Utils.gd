#############################################################################
##
#W  Utils.gd		GAP package `EquiDeg'			    Haopin Wu
##
#Y  Copyright (C) 2017-2018, Haopin Wu
#Y  Department of Mathematics, National Tsing Hua University, Taiwan
##
##  This file contains declarations for utilities.
##

#############################################################################
##
#A  Abbrv( <obj> )
##
##  <#GAPDoc Label="Abbrv">
##  <ManSection>
##  <Attr Name="Abbrv" Arg="obj"/>
##  <Description>
##  This is an attribute of new objects defined in this package
##  which provides minimal amount of information.
##  This attribute can be assigned to an object <A>obj</A> manually
##  by <C>SetAbbrv(<A>obj</A>,<A>val</A>)</C>.
##  However, it is generated automatically for
##  certain types of objects.
##  If object <A>obj</A> has this attribute,
##    <C>ViewString(<A>obj</A>)</C> will simply return
##    <C>Abbrv(<A>obj</A>)</C>.
##  </Description>
##  </ManSection>
##  <#/GAPDoc>
##

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
##    As higher value results in more detailed feedback,
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

#############################################################################
##
#A  Abbrv( <obj> )
##
  DeclareAttribute( "Abbrv", IsObject );

#############################################################################
##
#A  Detail( <obj> )
##
  DeclareAttribute( "Detail", IsObject );

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
#F  ListA( <list1>, <list2>, ..., <listn>, <f> )
##
  DeclareGlobalFunction( "ListA",
      "Apply action (function with no return value on list of arguments" );

#############################################################################
##
#O  Divides( <m>, <n> )
##
  DeclareOperation( "Divides", [ IsInt, IsInt ] );


#############################################################################
##
#E  Utils.gd . . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
