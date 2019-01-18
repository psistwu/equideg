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
#O  IsPSortedListBy( <list>, <func> )
##
  InstallMethod( IsPSortedListBy,
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
#P  IsPSortedList( <list> )
##
  InstallMethod( IsPSortedList,
    "checks whether <list> is sorted with respect to partial order \<",
    [ IsHomogeneousList ],
    list -> IsPSortedListBy( list, \< )
  );

#############################################################################
##
#P  IsPoset( <list> )
##
  InstallMethod( IsPoset,
    "checks whether <list> is a poset with respect to partial order \<",
    [ IsHomogeneousList ],
    list -> IsPSortedList( list ) and IsDuplicateFree( list )
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
            "The given list and the relation do not represent a poset." );
        return fail;
      fi;
    end
  );

#############################################################################
##
#O  PSort( <list> )
##
  InstallMethod( PSort,
    "sorts <list> with respect to partial order \<",
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
      return PSort( ShallowCopy( list ), func );
    end
  );

#############################################################################
##
#O  PSortedList( <list> )
##
  InstallMethod( PSortedList,
    "returns a shallow copy of <list> sorted with respect to partial order \<",
    [ IsHomogeneousList ],
    function( list )
      return PSort( ShallowCopy( list ), \< );
    end
  );


##  Part 2: Lattice

#############################################################################
##
#U  NewLattice( <filter>, <r> )
##
  InstallMethod( NewLattice,
    "constructing the lattice of a poset",
    [ IsLatticeRep and IsLatticeCCSsRep and IsLatticeOrbitTypesRep,
      IsRecord ],
    function( filter, r )
      local n,		# the size of the poset
            lat;	# the lattice

      # check the components in <r>
      if not IsPoset( r.poset ) then
        Error( "<r.poset> must be a poset." );
      fi;

      n := Size( r.poset );

      if not ( IsHomogeneousList( r.node_labels ) and
          Size( r.node_labels ) = n ) then
        Error( "<r.node_labels> must be a list having the same size as <r.poset>." );
      fi;

      if not ( IsHomogeneousList( r.node_shapes ) and
          Size( r.node_shapes ) = n ) then
        Error( "<r.node_shapes> must be a list having the same size as <r.poset>." );
      fi;

      if not IsString( r.rank_type ) then
        Error( "<r.rank_type> must be a string." );
      fi;

      if not ( IsHomogeneousList( r.ranks ) and
          Size( r.ranks ) = n ) then
        Error( "<r.ranks> must be a list having the same size as <r.poset>." );
      fi;

      if not IsBool( r.is_rank_reversed ) then
        Error( "<r.is_rank_reversed> must take true/false value." );
      fi;

      # generate the lattice object
      lat := Objectify(
        NewType( FamilyObj( r.poset ), IsCollection and filter ),
        r
      );

      return lat;
    end
  );

#############################################################################
##
#A  Poset( <lat> )
##
  InstallMethod( Poset,
    "returns poset of a lattice",
    [ IsLatticeRep ],
    lat -> lat!.poset
  );

#############################################################################
##
#A  MaximalSubElementsLattice( <lat> )
##
  InstallMethod( MaximalSubElementsLattice,
    "return list of indices of maximal sub-elements",
    [ IsCollection and IsLatticeRep ],
    function( lat )
      local i, j,		# indices
            poset,		# poset
            subs,		# sub-elements
            maxsub_list;	# return value

      # extract the sorted list
      poset := Poset( lat );

      # initialize maxsub_list;
      maxsub_list := [ ];

      # find sub-elements of each element
      for i in Reversed( [ 1 .. Size( poset ) ] ) do
        Add( maxsub_list, [ ], 1 );
        for j in [ 1 .. i-1 ] do
          if ( poset[ j ] < poset[ i ] ) then
            Add( maxsub_list[ 1 ], j );
          fi;
        od;
      od;

      # remove indices of non-maximal sub-elements of each element
      for subs in Reversed( maxsub_list ) do
        j := 0;
        while ( j < Size( subs )-1 ) do
          SubtractSet( subs, maxsub_list[ subs[ Size( subs )-j ] ] );
          j := j+1;
        od;
      od;

      return maxsub_list;
    end
  );

#############################################################################
##
#O  DotFileLattice( <lat>, <filename> )
##
  InstallMethod( DotFileLattice,
    "generate the dot file of <lat>",
    [ IsCollection and IsLatticeRep, IsString ],
    function( lat, file )
      local maxsub_list,
            outstream,
            legend_list,
            rank,
            node_label,
            node_shape,
            node_link,
            i, j;

      # extract information form the lattice
      maxsub_list := MaximalSubElementsLattice( lat );
      outstream := OutputTextFile( file, false );

      # put the header of the dot file
      AppendTo( outstream, "digraph lattice {\n" );
      AppendTo( outstream, "size = \"6,6\";\n" );

      # put the legend of ranks on the left-hand side
      if lat!.is_rank_reversed then
        legend_list := Reversed( Set( lat!.ranks ) );
      else
        legend_list := Set( lat!.ranks );
      fi;
      AppendTo( outstream,
          "\"rt\" [label=\"", lat!.rank_type, "\", color=white];\n");
      AppendTo( outstream, "\"rt\" -> ");
      for i in [ 1 .. Size( legend_list ) ] do
        rank := String( legend_list[ i ] );
        AppendTo( outstream,
            "\"s", rank, "\" [color=white, arrowhead=none];\n" );
        AppendTo( outstream,
            "\"s", rank, "\" [label=\"", rank, "\", color=white];\n" );
        if ( i < Size( legend_list ) ) then
          AppendTo( outstream, "\"s", rank, "\" -> ");
        fi;
      od;

      # put nodes of elements
      for i in [ 1 .. Size( Poset( lat ) ) ] do
        node_label := lat!.node_labels[ i ];
        node_shape := lat!.node_shapes[ i ];
        AppendTo( outstream,
            "\"", i, "\" [label=\"", node_label, "\", shape=",
            node_shape, "];\n" );
        AppendTo( outstream,
            "{ rank=same; \"s", lat!.ranks[ i ],
            "\" \"", i, "\"; }\n" );
      od;

      # put links between nodes
      for i in [ 1 .. Size( maxsub_list ) ] do
        for j in [ 1 .. Size( maxsub_list[ i ] ) ] do
          node_link := maxsub_list[ i ][ j ];
          AppendTo( outstream,
              "\"", i, "\" -> \"", node_link, "\" [arrowhead=none];\n" );
        od;
      od;

      AppendTo( outstream, "}" );
      CloseStream( outstream );
    end
  );


#############################################################################
##
#E  Lattice.gi . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
