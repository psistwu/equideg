#############################################################################
##
#W  Lattice.gi		GAP Package `EquiDeg'			    Haopin Wu
##
#Y  Copyright (C) 2017-2018, Haopin Wu
#Y  Department of Mathematics, National Tsing Hua University, Taiwan
##
##  This file contains implementations of procedures related to lattice.
##


#############################################################################
##
#F  NewLattice( <filter>, <r> )
##
InstallGlobalFunction( NewLattice,
  function( filter, r )
    local n;		# size of the poset

    # check input arguments
    if not IsFilter( filter ) then
      Error( "The first argument should be a filter." );
    elif not IsRecord( r ) then
      Error( "The second argument should be a record." );
    fi;

    # check the components in <r>
    if not IsPoset( r.poset ) then
      Error( "<r.poset> must be a poset." );
    fi;

    n := Size( r.poset );

    if not IsHomogeneousList( r.node_labels ) then
      Error( "<r.node_labels> must be a list." );
    elif not ( Size( r.node_labels ) = n ) then
      Error( "<r.node_labels> and <r.poset> must be of the same size." );
    fi;

    if not IsHomogeneousList( r.node_shapes ) then
      Error( "<r.node_shapes> must be a list." );
    elif not ( Size( r.node_shapes ) = n ) then
      Error( "<r.node_shapes> and <r.poset> must be of the same size." );
    fi;

    if not IsString( r.rank_label ) then
      Error( "<r.rank_label> must be a string." );
    fi;

    if not ( IsHomogeneousList( r.ranks ) and
        Size( r.ranks ) = n ) then
      Error( "<r.ranks> must be a list having the same size as <r.poset>." );
    fi;

    if not IsBool( r.is_rank_reversed ) then
      Error( "<r.is_rank_reversed> must be true or false." );
    fi;

    # generate the lattice object
    return Objectify( NewType( FamilyObj( r.poset ), filter ), r );
  end
);


#############################################################################
##
#A  String( <lat> )
##
# InstallMethod( String,
#   "string of lattice",
#   [ IsLatticeRep ],
#   lat -> "<lattice>"
# );


#############################################################################
##
#A  UnderlyingPoset( <lat> )
##
InstallImmediateMethod( UnderlyingPoset,
  "returns underlying poset of a lattice",
  IsLatticeRep,
  0,
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
    poset := UnderlyingPoset( lat );

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
        "\"rt\" [label=\"", lat!.rank_label, "\", color=white];\n");
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
    for i in [ 1 .. Size( UnderlyingPoset( lat ) ) ] do
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
