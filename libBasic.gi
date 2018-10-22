# # GAP: Basic Library
#
# Implementation file of libBasic.g
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#


# ## Part 1: Lattice
# ### Constructor(s)
# ***
  InstallMethod( Lattice,
    "constructing the lattice of a sorted list",
    [ IsLatticeRep, IsHomogeneousList ],
    function( filter, slist )
      # The constructor is only for sorted lists
      if not IsSortedList( slist ) then
        TryNextMethod( );
      fi;

      return Objectify(
        NewType( FamilyObj( slist ), IsCollection and filter ),
        rec(
          sortedList := slist
        )
      );
    end
  );


# ### Attribute(s)
# ***
  InstallMethod( MaximalSubElementsLattice,
    "return indices of maximal sub-elements of each element in the lattice",
    [ IsCollection and IsLatticeRep ],
    function( lat )
      local i, j,			# indices
            slist,			# sorted list
            subs,			# sub-elements
            maxsub_list;	# return value

      # extract the sorted list
      slist := lat!.sortedList;

      # initialize maxsub_list;
      maxsub_list := [ ];

      # find sub-elements of each element
      for i in Reversed( [ 1 .. Size( slist ) ] ) do
        Add( maxsub_list, [ ], 1 );
        for j in [ 1 .. i-1 ] do
          if ( slist[ j ] < slist[ i ] ) then
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


# ### Operation(s)
# ***
  InstallMethod( DotFileLattice,
    "generate the dot file for the lattice of CCSs",
    [ IsLatticeRep, IsString ],
    function( lat, file )
      local slist,
            node_label_list,
            node_shape_list,
            rank_type,
            rank_list,
            is_rank_reversed,
            maxsub_list,
            outstream,
            legend_list,
            rank,
            node_label,
            node_shape,
            node_link,
            i, j;

      # extract information form the lattice
      slist := lat!.sortedList;
      node_label_list := lat!.nodeLabels;
      node_shape_list := lat!.nodeShapes;
      rank_type := lat!.rankType;
      rank_list := lat!.ranks;
      is_rank_reversed := lat!.isRankReversed;
      maxsub_list := MaximalSubElementsLattice( lat );
      outstream := OutputTextFile( file, false );

      # put the header of the dot file
      AppendTo( outstream, "digraph lattice {\n" );
      AppendTo( outstream, "size = \"6,6\";\n" );

      # put the legend of rank on the left-hand side
      if is_rank_reversed then
        legend_list := Reversed( Set( rank_list ) );
      else
        legend_list := Set( rank_list );
      fi;
      AppendTo( outstream, "\"rt\" [label=\"", rank_type, "\", color=white];\n");
      AppendTo( outstream, "\"rt\" -> ");
      for i in [ 1 .. Size( legend_list ) ] do
        rank := String( legend_list[ i ] );
        AppendTo( outstream, "\"s", rank, "\" [color=white, arrowhead=none];\n" );
        AppendTo( outstream, "\"s", rank, "\" [label=\"", rank, "\", color=white];\n" );
        if ( i < Size( legend_list ) ) then
          AppendTo( outstream, "\"s", rank, "\" -> ");
        fi;
      od;

      # put nodes of elements
      for i in [ 1 .. Size( slist ) ] do
        node_label := node_label_list[ i ];
        node_shape := node_shape_list[ i ];
        AppendTo( outstream, "\"", i, "\" [label=\"", node_label, "\", shape=", node_shape, "];\n" );
        AppendTo( outstream, "{ rank=same; \"s", rank_list[ i ], "\" \"", i, "\"; }\n" );
      od;

      # put links between nodes
      for i in [ 1 .. Size( maxsub_list ) ] do
        for j in [ 1 .. Size( maxsub_list[ i ] ) ] do
          node_link := maxsub_list[ i ][ j ];
          AppendTo( outstream, "\"", i, "\" -> \"", node_link, "\" [arrowhead=none];\n" );
        od;
      od;

      AppendTo( outstream, "}" );
      CloseStream( outstream );
    end
  );



# ## Part 2: Poset
# ### Operation(s)
# ***
  InstallMethod( TopologicalSort,
    "topological sort a poset",
    [ IsList and IsMutable, IsFunction ],
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
        Info( InfoWarning, INFO_LEVEL, "The given list is not a poset." );
        return fail;
      fi;
    end
  );

# ***
  InstallOtherMethod( TopologicalSort,
    "topological sort a poset",
    [ IsList and IsMutable ],
    function( list )
      TopologicalSort( list, \< );
    end
  );

