#############################################################################
##
#W  Utils.gi		GAP package `EquiDeg'			    Haopin Wu
##
#Y  Copyright (C) 2017-2018, Haopin Wu
#Y  Department of Mathematics, National Tsing Hua University, Taiwan
##
##  This file contains implementations of utilities.
##

#############################################################################
##
#O  LaTeXTypesetting( <obj> )
##
  InstallMethod( LaTeXTypesetting,
    "return LaTeX typesetting of an object",
    [ IsObject ],
    function( obj )
      if HasLaTeXString( obj ) then
        return LaTeXString( obj );
      else
        Info( InfoEquiDeg, INFO_LEVEL_EquiDeg,
            "LaTeXString of the object is not defined." );
        return "";
      fi;
    end
  );

#############################################################################
##
#O  \+( <f>, <g> )
##
  InstallOtherMethod( \+,
    "addition of functions",
    IsIdenticalObj,
    [ IsGeneralMapping, IsGeneralMapping ],
    function( f, g )
      if not IsAdditiveElementCollection( Range( f ) ) then
        TryNextMethod( );
      fi;

      return MappingByFunction( Source( f ), Range( f ),
          x -> Image( f, x ) + Image( g, x ) );
    end
  );

#############################################################################
##
#O  AdditiveInverseOp( <f> )
##
  InstallOtherMethod( AdditiveInverseOp,
    "additive inverse of functions",
    [ IsGeneralMapping ],
    function( f )
      if not IsAdditiveElementWithInverseCollection( Range( f ) ) then
        TryNextMethod( );
      fi;

      return MappingByFunction( Source( f ), Range( f ),
          x -> -Image( f, x ) );
    end
  );

#############################################################################
##
#O  \*( <f>, <g> )
##
  InstallOtherMethod( \*,
    "multiplication of functions",
    IsIdenticalObj,
    [ IsGeneralMapping, IsGeneralMapping ],
    function( f, g )
      if not IsMultiplicativeElementCollection( Range( f ) ) then
        TryNextMethod( );
      fi;

      return MappingByFunction( Source( f ), Range( f ),
          x -> Image( f, x ) * Image( g, x ) );
    end
  );


#############################################################################
##
#E  Utils.gi . . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
