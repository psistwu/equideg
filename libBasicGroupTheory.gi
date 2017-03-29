# Implementation file of libBasicGroupTheory.g


## part 1: lattice of conjugacy classes of subgroups ##

### constructor ###

#---
# LatticeCCSs( G ) is the constructor of lattice of CCSs of G.
#	It is also an attribute of G.
#---
  InstallMethod( LatticeCCSs,
    "find lattice of CCSs of G",
    [ IsGroup ],
    function( G )
      local fam;

      fam := NewFamily( "LatticeCCSs", IsLatticeCCSs );

      return Objectify( NewType( fam, IsLatticeCCSs and IsLatticeCCSsRep ),
          rec( group := G,
               conjugacyClassesSubgroups := ConjugacyClassesSubgroups( G )
          )
      );
    end
  );
#---

### attribute ###

#---
# MaximalSubCCSsLattice( lat ) finds maximal subCCSs of
#	each CCS in the lattice.
#---
  InstallMethod( MaximalSubCCSsLattice,
    "find maximal subCCSs of each CCS in the lattice",
    [ IsLatticeCCSs and IsLatticeCCSsRep ],
    function( lat )
      local i, j,		# indices
            ccs_list,		# CCSs
            max_subccs_list;	# output

      # extract the conjugacy classes of subgroups
      ccs_list := lat!.conjugacyClassesSubgroups;

      # initialize max_subccs_list;
      max_subccs_list := [ ];

      # find subCCSs of each CCS
      for i in Reversed( [ 1 .. Size( ccs_list ) ] ) do
        Add( max_subccs_list, [ ], 1 );
        for j in [ 1 .. i-1 ] do
          if ( ccs_list[ j ] < ccs_list[ i ] ) then
            Add( max_subccs_list[ 1 ], j );
          fi;
        od;
      od;

      # remove subCCSs of each CCS which are not maximal
      for i in Reversed( [ 1 .. Size( ccs_list ) ] ) do
        j := 0;
        while ( j < Size( max_subccs_list[ i ] ) - 1 ) do
          SubtractSet( max_subccs_list[ i ], max_subccs_list[ max_subccs_list[ i ][ Size( max_subccs_list[ i ] ) - j ] ] );
          j := j + 1;
        od;
      od;

      return max_subccs_list;
    end
  );
#---

#---
# MinimalSupCCSsLattice( lat ) finds minimal supCCSs of
#	each CCS in the lattice.
#---
  InstallMethod( MinimalSupCCSsLattice,
    "find minimal supCCSs of each CCS in the lattice",
    [ IsLatticeCCSs and IsLatticeCCSsRep ],
    function( lat )
      local i, j,		# indices
            ccs_list,		# CCSs
            min_supccs_list;  # output

      # extract the conjugacy classes of subgroups
      ccs_list := lat!.conjugacyClassesSubgroups;

      # initialize min_supccs_list;
      min_supccs_list := [ ];

      # find supCCSs of each CCS
      for i in [ 1 .. Size( ccs_list ) ] do
        Add( min_supccs_list, [ ] );
        for j in [ i+1 .. Size( ccs_list ) ] do
          if ( ccs_list[ i ] < ccs_list[ j ] ) then
            Add( min_supccs_list[ Size( min_supccs_list ) ], j );
          fi;
        od;
      od;

      # remove supCCSs of each CCS which are not minimal
      for i in [ 1 .. Size( ccs_list ) ] do
        j := 1;
        while ( j < Size( min_supccs_list[ i ] ) ) do
          SubtractSet( min_supccs_list[ i ], min_supccs_list[ min_supccs_list[ i ][ j ] ] );
          j := j + 1;
        od;
      od;

      return min_supccs_list;
    end
  );
#---

### method ###

#---
# PrintObj
#---
  InstallMethod( PrintObj,
    "for lattice of CCSs",
    [ IsLatticeCCSs and IsLatticeCCSsRep ],
    function( lat )
      Print( "LatticeCCSs(", String( lat!.group ), ")\n" );
    end
  );
#---

#---
# ViewObj
#---
  InstallMethod( ViewObj,
    "for lattice of CCSs",
    [ IsLatticeCCSs and IsLatticeCCSsRep ],
    function( lat )
      Print( "<CCS lattice of ", ViewString( lat!.group ), ", ", Size( lat!.conjugacyClassesSubgroups), " classes>" );
    end
  );
#---

#---
# DotFileLatticeCCSs( lat, file ) export the lattice of CCSs as a dot file
#---
  InstallMethod( DotFileLatticeCCSs,
    "export lattice as a dot file",
    [ IsLatticeCCSs and IsLatticeCCSsRep, IsString ],
    function( lat, file )
      local G,
            ccs_list,
            ccs_order_list,
            ccs_number_list,
            max_subccs_list,
            outstream,
            i, j,
            nodelabel,
            nodeshape,
            linknode;

      G := lat!.group;
      ccs_list := lat!.conjugacyClassesSubgroups;
      ccs_order_list := List( ccs_list, c -> Order( Representative( c ) ) );
      ccs_number_list := List( ccs_list, c -> Size( c ) );
      max_subccs_list := MaximalSubCCSsLattice( lat );
      outstream := OutputTextFile( file, false );

      # put the head of the dot file
      AppendTo( outstream, "digraph lattice {\n" );
      AppendTo( outstream, "size = \"6,6\";\n" );

      # put label of order (bigger ones are in the higher position)
      for i in Reversed( Set( ccs_order_list ) ) do
        if ( i < Order( G ) ) then
          AppendTo( outstream, "\"s", i, "\" [color=white,arrowhead=none];\n" );
        fi;
        AppendTo( outstream, "\"s", i, "\" [label=\"", i, "\", color=white];\n" );
        if ( i > 1 ) then
          AppendTo( outstream, "\"s", i, "\"->");
        fi;
      od;

      # put CCSs
      for i in [ 1 .. Size( ccs_list ) ] do
        if HasName( ccs_list[ i ] ) then
          nodelabel := Name( ccs_list[ i ] );
        else
          nodelabel := i;
        fi;
        if ( ccs_number_list[ i ] = 1 ) then
          nodeshape := "box";
        else
          nodeshape := "circle";
        fi;
        AppendTo( outstream, "\"", i, "\" [label=\"", nodelabel, "\", shape=", nodeshape, "];\n" );
        AppendTo( outstream, "{ rank=same; \"s", ccs_order_list[ i ], "\" \"", i, "\"; }\n" );
      od;

      # put links among CCSs
      for i in [ 1 .. Size( max_subccs_list ) ] do
        for j in [ 1 .. Size( max_subccs_list[ i ] ) ] do
          linknode := max_subccs_list[ i ][ j ];
          AppendTo( outstream, "\"", i, "\" -> \"", linknode, "\" [arrowhead=none];\n" );
        od;
      od;

      AppendTo( outstream, "}" );
      CloseStream( outstream );

    end
  );
#---


## part 2: general tools ##

### attribute ###

#---
# CCSubgroups( subg ) returns the CCS which contains subg
#---
  InstallMethod( CCSubgroups,
    "the CCS containing the given subgroup",
    [ IsGroup and HasParentAttr ],
    function( subg )

      local g,		# the parent group
            ccs_list,	# conjugacy classes of subgroups of g
            ccs;	# conjugacy class of subgroups which contains h

      g := ParentAttr( subg );
      ccs_list := ConjugacyClassesSubgroups( g );

      for ccs in ccs_list do
        if ( subg in ccs ) then
          return ccs;
        fi;
      od;

    end
  );
#---

### method ###

#---
# "<" for Conjugacy Classes of Subgroups
#---
  InstallMethod( \<,
    "the partial order of conjugacy classes of subgroups",
    [ IsConjugacyClassSubgroupsRep, IsConjugacyClassSubgroupsRep ],
    function( ccs1, ccs2 )

    # local variables
    local s1,		# subgroup in c1
          s2;		# subgroup in c2

    s1 := Representative( ccs1 );

    for s2 in ccs2 do
      if IsSubgroup( s2, s1 ) then
        return true;
      fi;
    od;

    return false;
        
    end
  );
#---

#---
# aConjugacyClassSubgroups( G, H ) returns the CCS of H with respect to G
#---
  InstallMethod( aConjugacyClassSubgroups,
    "CCS of H with respect to G",
    [ IsGroup, IsGroup ],
    function( G, H )

      local ccs_list,
            c;		# CCS

      Print( "Finding CCSs of G.\n" );
      Print( HasConjugacyClassesSubgroups( G ), "\n" );
      ccs_list := ConjugacyClassesSubgroups( G );
      Print( "\n\n" );

      for c in ccs_list do
        if ( H in c ) then
          return c;
        fi;
      od;

      return fail;

    end
  );
#---

#---
# nLHnumber( G, H, L ) finds n_G(L,H), i.e., the number of subgroups conjugate
#	to H which contain L
#---
  InstallMethod( nLHnumber,
    "the n_G(L,H) number",
    [ IsGroup, IsGroup, IsGroup ],
    function( G, H, L )

    # local variables
    local cH,		# subgroups conjugate to H
          nLH;		# n(L,H)

    nLH := 0;

    if not ( Order( H ) mod Order( L ) = 0 ) then
      return nLH;
    fi;

    for cH in ConjugacyClassSubgroups( G, H ) do
      if IsSubset( cH, L ) then
        nLH := nLH + 1;
      fi;
    od;

    return nLH;

    end
  );
#---

### function ###

#---
# pCyclicGroup( n ) creates permutational Z_n
#---
  InstallGlobalFunction( pCyclicGroup,
    function( n )

    # local variable(s)
    local i,		# index
          gen;		# generator of Zn

    # return error if n is not a positive integer
    if not IsPosInt( n ) then
      Info( ERROR, MSGLEVEL, "n is not a positive integer." );
      Error( );
    fi;

    # take the generator
    gen := ( );
    for i in [ 1 .. n-1 ] do
      gen := ( i, i+1 )*gen;
    od;

    return Group( [ ( ), gen ] );

    end
  );
#---

#---
# pDihedralGroup( n ) creates permutational D_n
#---
  InstallGlobalFunction( pDihedralGroup,
    function(n)

    # local variable(s)
    local i,		# index
          gen1, gen2;	# generators of Dn

    # exclude the case n is not a positive integer
    if not IsPosInt( n ) then
      Info( ERROR, MSGLEVEL, "n is not a positive integer." );
      Error( );
    fi;

    # case 1: n = 1
    if ( n = 1 ) then
      gen1 := ( 1, 2 );
      gen2 := ( );

    # case 2: n = 2
    elif ( n = 2 ) then
      gen1 := ( 1, 2 );
      gen2 := ( 3, 4 );

    # case 3: n > 2
    else
      gen1 := ( );
      for i in [ 1 .. Int( n/2 ) ] do
        gen1 := ( i, n+1-i )*gen1;
      od;

      gen2 := ( );
      for i in [ 1 .. n-1 ] do
        gen2 := ( i, i+1 )*gen2;
      od;
    fi;

    return Group( [ gen1, gen2 ] );

    end
  );
#---


## part 3: archaic functions (will be removed in the future) ##

#---
# idCCS(ccsslist, subg) finds the ID of the CCS contains subg
#---
  idCCS := function( ccs_list, subg )

  # define local variable
  local i;	# the index

  # check which CCS contains subg
  for i in [ 1 .. Size( ccs_list ) ] do
    if subg in ccs_list[ i ] then
      return i;
    fi;
  od;

  # if none, print the WARN message and return fail
  Info( WARN, MSGLEVEL, "subg is not in any of the CCSs." );
  return fail;

  end;
#---

#---
# idCC( cc_list, e ) finds the ID of the CC contains element e
#---
  idCC := function( cc_list, e )

  # define local variable
  local i;	# the index

  # check which CCS contains subg
  for i in [ 1 .. Size( cc_list ) ] do
    if e in cc_list[ i ] then
      return i;
    fi;
  od;

  # if none, print the WARN message and return fail
  Info( WARN, MSGLEVEL, "e is not in any of the CCs." );
  return fail;

  end;
#---

#---
# isSubgroupUptoConjugacy( G, supg, subg )
#---
  isSubgroupUptoConjugacy := function( G, supg, subg )

  # local variables
  local ccs_subg,		# CCS contains subg
        csubg;			# subgroup conjugate to subg

  if ( Order( supg ) mod Order( subg ) = 0 ) then
    ccs_subg := ConjugacyClassSubgroups( G, subg );
    for csubg in ccs_subg do
      if IsSubset( supg, csubg ) then
        return true;
      fi;
    od;
  fi;

  return false;

  end;
#---

#---
# removeExtraConjugateCopy(G, subg_list) removes all but one conjugate
#	subgroups in the given collection of subgroups.
#---
  removeExtraConjugateCopy := function( G, subg_list )

  # local variables
  local i, j;		# indexes

  # sort the collection of subgroups by their order
  SortBy( subg_list, v -> Order( v ) );

  # remove all but one conjugate subgroups
  i := 1;
  while i < Size( subg_list ) do
    j := i + 1;
    while j <= Size( subg_list ) do
      if ( Order( subg_list[ j ] ) > Order( subg_list[ i ] ) ) then
        break;
      elif IsConjugate( G, subg_list[ i ], subg_list[ j ] ) then
        Remove( subg_list, j );
      else
        j := j+1;
      fi;
    od;
    i := i+1;
  od;

  end;
#---

