# # GAP: Group Theory Library
#
# Implementation file of libGroup.g
#
# Author:
# Haopin Wu <psistwu@outlook.com>
#


# ## part 1: general tools
# ### attribute(s)
# ***
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

# ***
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

# ***
  InstallMethod( OrderOfWeylGroup,
    "return order of weyl group",
    [ IsGroup and HasParentAttr ],
    function( subg )
      return Order( NormalizerInParent( subg ) ) / Order( subg );
    end
  );

# ***
  InstallMethod( OrderOfWeylGroup,
    "return order of weyl group",
    [ IsConjugacyClassSubgroupsRep ],
    function( ccs )
      return Order( StabilizerOfExternalSet( ccs ) ) / Order( Representative( ccs ) );
    end
  );


# ### operator(s)
# ***
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

# ***
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


# ## part 2: lattice of conjugacy classes of subgroups
# ### constructor(s)
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


# ### attribute(s)
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


# ### print, view and display
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
