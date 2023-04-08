#############################################################################
##
#W  Lattice.gi		GAP Package `EquiDeg'			    Haopin Wu
##
#Y  Copyright (C) 2017-2018, Haopin Wu
#Y  Department of Mathematics, National Tsing Hua University, Taiwan
##
##  This file contains implementations of procedures related to lattice.
##

##  Part 1: Poset

#############################################################################
##
#O  IsPSortedList( <list>, <func> )
##
InstallOtherMethod( IsPSortedList,
  "check whether <list> is sorted with respect to partial order <func>",
  [ IsHomogeneousList, IsFunction ],
  function( list, func )
    local i, j;

    for i in [ 1 .. Size( list ) ] do
      if ForAny( [ i+1 .. Size( list ) ],
          j -> func( list[ j ], list[ i ] ) ) then
        return false;
      fi;
    od;
    return true;
  end
);

#############################################################################
##
#O  IsPSortedList( <list> )
##
InstallMethod( IsPSortedList,
  "checks whether <list> is sorted with respect to \\<",
  [ IsHomogeneousList ],
  list -> IsPSortedList( list, \< )
);

#############################################################################
##
#O  IsPoset( <list>, <func> )
##
InstallOtherMethod( IsPoset,
  "checks whether <list> is a poset with respect to partial order <func>",
  [ IsHomogeneousList, IsFunction ],
  { list, func } -> IsPSortedList( list, func ) and IsDuplicateFree( list )
);

#############################################################################
##
#O  IsPoset( <list> )
##
InstallMethod( IsPoset,
  "checks whether <list> is a poset with respect to \\<",
  [ IsHomogeneousList ],
  list -> IsPoset( list, \< )
);

#############################################################################
##
#O  PSort( <list>, <func> )
##
InstallOtherMethod( PSort,
  "sorts <list> with respect to partial order <func>",
  [ IsHomogeneousList and IsMutable, IsFunction ],
  function( list, lt )
    local E,
          S,
          v, vv,
          i,
          slist;

    # find all (directed) edges
    E := [ ];
    for v in list do
      for vv in list do
        if not IsIdenticalObj( v, vv ) and lt( v, vv ) then
          Add( E, [ v, vv ] );
        fi;
      od;
    od;

    # find all start nodes
    S := [ ];
    for v in list do
      if ForAll( E, e -> not IsIdenticalObj( v, e[ 2 ] ) ) then
        Add( S, v );
      fi;
    od;

    slist := [ ];
    while not IsEmpty( S ) do
      v := Remove( S );
      Add( slist, v );

      i := PositionProperty( E, e -> IsIdenticalObj( e[ 1 ], v ) );
      while ( i <> fail ) do
        vv := Remove( E, i )[ 2 ];
        if ForAll( E, e -> not IsIdenticalObj( e[ 2 ], vv ) ) then
          Add( S, vv );
        fi;

        i := PositionProperty( E, e -> IsIdenticalObj( e[ 1 ], v ) );
      od;
    od;

    if IsEmpty( E ) then
      list{ [ 1 .. Size( list ) ] } := slist;
    else
      Info( InfoEquiDeg, INFO_LEVEL_EquiDeg,
          "( <list>, <lt> ) do not form a poset." );
      return fail;
    fi;
  end
);

#############################################################################
##
#O  PSort( <list> )
##
InstallMethod( PSort,
  "sorts <list> with respect to \\<",
  [ IsHomogeneousList and IsMutable ],
  function( list )
    PSort( list, \< );
  end
);

#############################################################################
##
#O  PSortedList( <list>, <func> )
##
InstallOtherMethod( PSortedList,
  "returns a shallow copy of <list> sorted with respect to partial order <func>",
  [ IsHomogeneousList, IsFunction ],
  function( list, func )
    local tmp;

    tmp := ShallowCopy( list );
    PSort( tmp, func );

    return tmp;
  end
);

#############################################################################
##
#O  PSortedList( <list> )
##
InstallMethod( PSortedList,
  "returns a shallow copy of <list> sorted with respect to partial order \\<",
  [ IsHomogeneousList ],
  list -> PSortedList( list, \< )
);

#############################################################################
##
#O  MaximalElements( <list>, <func> )
##
InstallOtherMethod( MaximalElements,
  "returns the list of maximal elements in <list> with respect to partial order <func>",
  [ IsList, IsFunction ],
  function( list, func )
    local flag,
          i, j,
          list2,
          a, b;

    # duplicate <list>
    list2 := ShallowCopy( list );

    i := 1;
    while ( i <= Length( list2 ) ) do
      a := list2[ i ];
      # assume <a> is a maximal element
      flag := true;

      j := 1;
      # compare to other elements in <list2>
      while ( j <= Length( list2 ) ) do
        b := list2[ j ];
        if ( a = b ) then
          j := j + 1;
          continue;
        elif func( a, b ) then
          # remove <a> from <list2> if <a> is less than <b>
          Remove( list2, i );
          flag := false;
          break;
        elif func( b, a ) then
          # remove <b> from <list2> if <b> is less then <a>
          Remove( list2, j );
        else
          # keep both <a> and <b> if they are not comparable
          j := j + 1;
        fi;
      od;

      if flag then
        i := i + 1;
      fi;
    od;

    return list2;
  end
);

#############################################################################
##
#O  MaximalElements( <list> )
##
InstallOtherMethod( MaximalElements,
  "returns the list of maximal elements in <list> with respect to \\<",
  [ IsList ],
  list -> MaximalElements( list, \< )
);


#############################################################################
##
#E  Poset.gi . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
