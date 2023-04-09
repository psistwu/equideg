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
#O  ViewString( <obj> )
##
InstallMethod( ViewString,
  "View string for object admit abbrv",
  [ IsComponentObjectRep and HasAbbrv ],
  function( obj )
    return Abbrv( obj );
  end
);


#############################################################################
##
#O  PrintObj( <obj> )
##
InstallMethod( PrintObj,
  "",
  [ IsComponentObjectRep and HasString ],
  50,
  function( obj )
    Print( String( obj ) );
  end
);


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
