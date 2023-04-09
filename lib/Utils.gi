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
#O  Abbrv( <obj> )
##
InstallMethod( Abbrv,
  "Get abbreviation of object",
  [ IsComponentObjectRep ],
  function( obj )
    if HasAbbrv( obj ) then
      return obj!.abbrv;
    else
      Error( "Abbrv of the object is yet to be set." );
    fi;
  end
);


#############################################################################
##
#O  SetAbbrv( <obj>, <str> )
##
InstallMethod( SetAbbrv,
  "Set abbreviation of object",
  [ IsComponentObjectRep, IsString ],
  function( obj, str )
    obj!.abbrv := str;
  end
);


#############################################################################
##
#O  HasAbbrv( <obj> )
##
InstallMethod( HasAbbrv,
  "Chcek if an object has abbreviation",
  [ IsComponentObjectRep ],
  obj -> IsBound( obj!.abbrv )
);


#############################################################################
##
#O  ResetAbbrv( <obj> )
##
InstallMethod( ResetAbbrv,
  "Reset abbreviation of object",
  [ IsComponentObjectRep ],
  function( obj )
    Unbind( obj!.abbrv );
  end
);


#############################################################################
##
#O  ViewString( <obj> )
##
InstallMethod( ViewString,
  "View string for object admit abbrv",
  [ IsComponentObjectRep ],
  function( obj )
    if HasAbbrv( obj ) then
      return Abbrv( obj );
    else
      TryNextMethod( );
    fi;
  end
);


#############################################################################
##
#O  PrintObj( <obj> )
##
InstallMethod( PrintObj,
  "",
  [ IsComponentObjectRep ],
  50,
  function( obj )
    if HasString( obj ) then
      Print( String( obj ) );
    else
      TryNextMethod( );
    fi;
  end
);


#############################################################################
##
#O  LaTeXTypesetting( <obj> )
##
# InstallMethod( LaTeXTypesetting,
#   "return LaTeX typesetting of an object",
#   [ IsObject and HasLaTeXString ],
#   function( obj )
#     return LaTeXString( obj );
#   end
# );

#############################################################################
##
#F  ListA( <list1>, <list2>, ..., <listn>, f )
##
InstallGlobalFunction( ListA,
  function( args... )
    local f,
          m,
          i,
          argf,
          result;

    f := Remove( args );
    m := Length( args[ 1 ] );

    if ForAny( args, list -> not ( Length( list ) = m ) ) then
      Error( "<list1>, <list2>, ..., <listn> should have the same length." );
    fi;

    result := [ ];
    for argf in TransposedMat(args) do
      Add( result, CallFuncListWrap( f, argf ) );
    od;
    
    return result;
  end
);

#############################################################################
##
#O  \[\]( <obj>, <list> )
##
InstallOtherMethod( \[\],
  "for multi-component indices",
  [ IsObject, IsList ],
  function( obj, list )
    return CallFuncList( \[\,\], Flat( [ obj, list ] ) );
  end
);

#############################################################################
##
#O  Divides( <m>, <n> )
##
InstallMethod( Divides,
  "test if <m> divides <n>",
  [ IsInt, IsInt ],
  function( m, n )
    if IsZero( m ) then
      return IsZero( n );
    else
      return ( n mod m = 0 );
    fi;
  end
);

#############################################################################
##
#E  Utils.gi . . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
