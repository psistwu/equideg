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
#E  Utils.gi . . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
