#############################################################################
##
#W  Basic.gi		GAP Package `EquiDeg'			    Haopin Wu
##
#Y  Copyright (C) 2017-2018, Haopin Wu
#Y  Department of Mathematics, National Tsing Hua University, Taiwan
##
##  This file contains implementations for basic math procedures.
##

##  Part 1: Poset

#############################################################################
##
#O  IsSortedPoset( <list>, <func> )
##
  InstallMethod( IsSortedPoset,
    "check whether a list is topological sorted with specified order",
    [ IsList, IsFunction ],
    function( list, lt )
      local i, j;

      for i in [ 1 .. Size( list ) ] do
        if ForAny( [ i+1 .. Size( list ) ],
            j -> lt( list[ j ], list[ i ] ) ) then
          return false;
        fi;
      od;
      return true;
    end
  );

#############################################################################
##
#O  IsSortedPoset( <list> )
##
  InstallOtherMethod( IsSortedPoset,
    "check whether a list is topological sorted with default order",
    [ IsList ],
    function( list )
      return IsSortedPoset( list, \< );
    end
  );

#############################################################################
##
#O  TopologicalSort( <list>, <func> )
##
  InstallMethod( TopologicalSort,
    "topological sort a poset with specified order",
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
        Info( InfoEquiDeg, INFO_LEVEL_EquiDeg,
            "The given list and the relation do not represent a poset." );
        return fail;
      fi;
    end
  );

#############################################################################
##
#O  TopologicalSort( <list> )
##
  InstallOtherMethod( TopologicalSort,
    "topological sort a poset with default order",
    [ IsList and IsMutable ],
    function( list )
      TopologicalSort( list, \< );
    end
  );


##  Part 2: Lattice

#############################################################################
##
#C  Lattice( <filter>, <list> )
##
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

#############################################################################
##
#A  MaximalSubElementsLattice( <lat> )
##
  InstallMethod( MaximalSubElementsLattice,
    "return indices of maximal sub-elements of each element in the lattice",
    [ IsCollection and IsLatticeRep ],
    function( lat )
      local i, j,		# indices
            slist,		# sorted list
            subs,		# sub-elements
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

#############################################################################
##
#O  DotFileLattice( <lat>, <filename> )
##
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
      AppendTo( outstream,
          "\"rt\" [label=\"", rank_type, "\", color=white];\n");
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
      for i in [ 1 .. Size( slist ) ] do
        node_label := node_label_list[ i ];
        node_shape := node_shape_list[ i ];
        AppendTo( outstream,
            "\"", i, "\" [label=\"", node_label, "\", shape=",
            node_shape, "];\n" );
        AppendTo( outstream,
            "{ rank=same; \"s", rank_list[ i ],
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
#C  Lattice( <filter>, <list> )
##
  InstallMethod( Lattice,
    "constructing the lattice of a sorted list",
    [ IsLatticeOrbitTypesRep, IsHomogeneousList ],
    function( filter, orbittype_list )
      local c,                # a conjugacy class of subgroups
            node_shape_list;  # define the node shape of
                              # each CCS in the lattice diagram
                              # normal subgroups -> squares
                              # other subgroups -> circles

      node_shape_list := [ ];
      for c in orbittype_list do
        if ( Size( c ) = 1 ) then
          Add( node_shape_list, "square" );
        else
          Add( node_shape_list, "circle" );
        fi;
      od;

      return Objectify(
        NewType( FamilyObj( orbittype_list ), IsCollection and filter ),
        rec(
          sortedList := orbittype_list,
          rankType := "Dim",
          nodeShapes := node_shape_list,
          isRankReversed := false
        )
      );
    end
  );


# ## Part 3: Group Theory

#############################################################################
##
#A  ConjugacyClassSubgroups( <subg> )
##
  InstallOtherMethod( ConjugacyClassSubgroups,
    "return the CCS containing the given subgroup",
    [ IsGroup and HasParentAttr ],
    function( subg )
      local grp,	    # the parent group
            ccs_list,	# conjugacy classes of subgroups of g
            ccs;        # conjugacy class of subgroups which contains h

      grp := ParentAttr( subg );
      ccs_list := ConjugacyClassesSubgroups( grp );

      for ccs in ccs_list do
        if ( subg in ccs ) then
          return ccs;
        fi;
      od;
    end
  );

#############################################################################
##
#O  \<( <ccsubg1>, <ccsubg2> )
##
  InstallMethod( \<,
    "the partial order of conjugacy classes of subgroups of a finite group",
    [ IsConjugacyClassSubgroupsRep, IsConjugacyClassSubgroupsRep ],
    function( ccs1, ccs2 )

      # local variables
      local s1,		# subgroup in c1
            s2;		# subgroup in c2

      s1 := Representative( ccs1 );
      s2 := Representative( ccs2 );
      if not IsZero( Order( s2 ) mod Order( s1 ) ) then
        return false;
      fi;

      for s1 in ccs1 do
        if IsSubset( s2, s1 ) then
          return true;
        fi;
      od;

      return false;
    end
  );

#############################################################################
##
#A  OrderOfWeylGroup( <subg> )
##
  InstallMethod( OrderOfWeylGroup,
    "return order of weyl group",
    [ IsGroup and HasParentAttr ],
    function( subg )
      return Order( NormalizerInParent( subg ) ) / Order( subg );
    end
  );

#############################################################################
##
#A  OrderOfWeylGroup( <ccsubg> )
##
  InstallMethod( OrderOfWeylGroup,
    "return order of weyl group",
    [ IsConjugacyClassSubgroupsRep ],
    function( ccs )
      return Order( StabilizerOfExternalSet( ccs ) ) / Order( Representative( ccs ) );
    end
  );

##############################################################################
##
#O  nLHnumber( <subg1>, <subg2> )
##
  InstallMethod( nLHnumber,
    "return n(L,H)",
    [ IsGroup and HasParentAttr, IsGroup and HasParentAttr ],
    function( L, H )
      local G,		# the parent group
            HH,		# subgroup conjugate to H
            nLH;	# n(L,H)

      if not ( ParentAttr( L ) = ParentAttr( H ) ) then
        Error( "L and H need to have the same parent group." );
      fi;

      if not IsZero( Order( H ) mod Order( L ) ) then
        return 0;
      fi;

      nLH := 0;

      for HH in ConjugacyClassSubgroups( H ) do
        if IsSubset( HH, L ) then
          nLH := nLH+1;
        fi;
      od;

      return nLH;
    end
  );

#############################################################################
##
#O  nLHnumber( <ccsubg1>, <ccsubg2> )
##
  InstallMethod( nLHnumber,
    "return n(L,H)",
    IsIdenticalObj,
    [ IsConjugacyClassSubgroupsRep, IsConjugacyClassSubgroupsRep ],
    function( ccs1, ccs2 )
      local nLH,         # n(L,H)
            L, H;

      L := Representative( ccs1 );
      H := Representative( ccs2 );
      if not IsZero( Order( H ) mod Order( L ) ) then
        return 0;
      fi;

      nLH := 0;
      for H in ccs2 do
        if IsSubset( H, L ) then
          nLH := nLH+1;
        fi;
      od;

      return nLH;
    end
  );

# ***
  InstallMethod( pCyclicGroup,
    "return a permutational cyclic group Z_n",
    [ IsPosInt ],
    function( n )
      local i,		# index
            gen;	# generator of Z_n

      # take the generator
      gen := ( );
      for i in [ 1 .. n-1 ] do
        gen := ( i, i+1 )*gen;
      od;

      return Group( [ gen ] );
    end
  );

# ***
  InstallMethod( pDihedralGroup,
    "return a permutational Dihedral group D_n",
    [ IsPosInt ],
    function( n )
      local i,            # index
            gen1, gen2;   # generators of Dn
                          # gen1 associates to rotation
                          # gen2 associates to reflection

      # case 1: n = 1
      if ( n = 1 ) then
        gen1 := ( );
        gen2 := ( 3, 4 );

      # case 2: n = 2
      elif ( n = 2 ) then
        gen1 := ( 1, 2 );
        gen2 := ( 3, 4 );

      # case 3: n > 2
      else
        gen1 := ( );
        for i in [ 1 .. n-1 ] do
          gen1 := ( i, i+1 )*gen1;
        od;

        gen2 := ( );
        for i in [ 1 .. Int( n/2 ) ] do
          gen2 := ( i, n+1-i )*gen2;
        od;
      fi;

      return Group( [ gen1, gen2 ] );
    end
  );

# ***
  InstallMethod( mCyclicGroup,
    "return Z_n as a matrix group",
    [ IsPosInt ],
    function( n )
      local z, rz, iz,          # a complex number and its real and imaginary parts
            gen_mat;            # generator of Z_n

      z := E( n );
      rz := RealPart( z );
      iz := ImaginaryPart ( z );
      gen_mat := [ [ rz, -iz ], [ iz, rz ] ];

      return GroupByGenerators( [ gen_mat ] );
    end
  );

# ***
  InstallMethod( mDihedralGroup,
    "return D_n as a matrix group",
    [ IsPosInt ],
    function( n )
      local z, rz, iz,     # a complex number and its real and imaginary parts
            gen1, gen2;    # generators of D_n
                           # gen1 associates to rotation
                           # gen2 associates to reflection

      z := E( n );
      rz := RealPart( z );
      iz := ImaginaryPart ( z );
      gen1 := [ [ rz, -iz ], [ iz, rz ] ];
      gen2 := [ [ 1, 0 ], [ 0, -1 ] ];

      return GroupByGenerators( [ gen1, gen2 ] );
    end
  );


# ## Part 2: Lattice of Conjugacy Classes of Subgroups
# ### Constructor(s)
# ***
  InstallMethod( Lattice,
    "constructing the lattice of a sorted list",
    [ IsLatticeCCSsRep, IsHomogeneousList ],
    function( filter, ccs_list )
      local c,                # a conjugacy class of subgroups
            node_shape_list,  # define the node shape of each CCS in the lattice diagram
                              # normal subgroups -> squares
                              # other subgroups -> circles
            rank_list;        # define the rank of each CCS, which is the order of the subgroup

      node_shape_list := [ ];
      rank_list := [ ];
      for c in ccs_list do
        if ( Size( c ) = 1 ) then
          Add( node_shape_list, "square" );
        else
          Add( node_shape_list, "circle" );
        fi;
        Add( rank_list, Order( Representative( c ) ) );
      od;

      return Objectify(
        NewType( FamilyObj( ccs_list ), IsCollection and filter ),
        rec(
          sortedList := ccs_list,
          rankType := "Order",
          ranks := rank_list,
          nodeLabels := [ 1 .. Size( ccs_list ) ],
          nodeShapes := node_shape_list,
          isRankReversed := true
        )
      );
    end
  );


# ### Attribute(s)
# ***
  InstallMethod( LatticeCCSs,
    "return lattice of CCSs of G",
    [ IsGroup ],
    function( grp )
      local ccs_list,    # conjugacy classes of subgroups
            lat;         # lattice of CCSs

      ccs_list := ConjugacyClassesSubgroups( grp );
      lat := Lattice( IsLatticeCCSsRep, ccs_list );
      lat!.group := grp;
      SetConjugacyClassesSubgroups( lat, ccs_list );
      return lat;
    end
  );

# ***
  InstallMethod( LatticeSubgroups,
    "return lattice of subgroups",
    [ IsLatticeCCSsRep ],
    function( lat )
      return LatticeSubgroups( lat!.group );
    end
  );


# ### Print, View and Display
# ***
  InstallMethod( PrintString,
    "print string for lattice of CCSs",
    [ IsLatticeCCSsRep ],
    function( lat )
      return Concatenation( "LatticeCCSs(", String( lat!.group ), ")" );
    end
  );

# ***
  InstallMethod( ViewString,
    "view string for lattice of CCSs",
    [ IsLatticeCCSsRep ],
    function( lat )
      return Concatenation( "<CCS lattice of ", ViewString( lat!.group ), ", ", String( Size( ConjugacyClassesSubgroups( lat ) ) ), " classes>" );
    end
  );

