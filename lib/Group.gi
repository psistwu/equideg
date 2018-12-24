#############################################################################
##
#W  Group.gi		GAP Package `EquiDeg'			    Haopin Wu
##
#Y  Copyright (C) 2017-2018, Haopin Wu
#Y  Department of Mathematics, National Tsing Hua University, Taiwan
##
##  This file contains implementations for procedures
##  related to group thoery.
##

## Part 1: Basic Groups

#############################################################################
##
#F  pCyclicGroup( <n> )
##
  InstallGlobalFunction( pCyclicGroup,
    function( n )
      local i,		# index
            gen;	# generator of Z_n

      if not IsPosInt( n ) then
        Error( "n must be a positive integer." );
      fi;

      # take the generator
      gen := ( );
      for i in [ 1 .. n-1 ] do
        gen := ( i, i+1 )*gen;
      od;

      return Group( [ gen ] );
    end
  );

#############################################################################
##
#F  mCyclicGroup( <n> )
##
  InstallGlobalFunction( mCyclicGroup,
    function( n )
      local z, rz, iz,	# a complex number and its real and imaginary parts
            gen_mat;	# generator of Z_n

      if not IsPosInt( n ) then
        Error( "n must be a positive integer." );
      fi;

      z := E( n );
      rz := RealPart( z );
      iz := ImaginaryPart ( z );
      gen_mat := [ [ rz, -iz ], [ iz, rz ] ];

      return GroupByGenerators( [ gen_mat ] );
    end
  );

#############################################################################
##
#F  pDihedralGroup( <n> )
##
  InstallGlobalFunction( pDihedralGroup,
    function( n )
      local i,            # index
            gen1, gen2;   # generators of Dn
                          # gen1 associates to rotation
                          # gen2 associates to reflection

      if not IsPosInt( n ) then
        Error( "n must be a positive integer." );
      fi;

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

#############################################################################
##
#F  mDihedralGroup( <n> )
##
  InstallGlobalFunction( mDihedralGroup,
    function( n )
      local z, rz, iz,     # a complex number and
                           # its real and imaginary parts
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


## Part 2: Group Theory

#############################################################################
##
#O  ConjugacyClassSubgroups( <H> )
##
  InstallOtherMethod( ConjugacyClassSubgroups,
    "return the CCS containing the given subgroup",
    [ IsGroup and HasParentAttr ],
    function( subg )
      local grp,	# the parent group
            ccs_list,	# conjugacy classes of subgroups of <grp>
            ccs;        # conjugacy class of subgroups associated to <subg>

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
#O  \<( <cH1>, <cH2> )
##
  InstallMethod( \<,
    "the partial order of conjugacy classes of subgroups of a finite group",
    [ IsConjugacyClassSubgroupsRep, IsConjugacyClassSubgroupsRep ],
    function( cH1, cH2 )
      return nLHnumber( cH1, cH2 ) > 0;
    end
  );

#############################################################################
##
#A  OrderOfWeylGroup( <H> )
##
  InstallMethod( OrderOfWeylGroup,
    "return order of weyl group",
    [ IsGroup and HasParentAttr ],
    function( H )
      return Order( NormalizerInParent( H ) ) / Order( H );
    end
  );

#############################################################################
##
#A  OrderOfWeylGroup( <cH> )
##
  InstallMethod( OrderOfWeylGroup,
    "return order of weyl group",
    [ IsConjugacyClassSubgroupsRep ],
    function( cH )
      return Order( StabilizerOfExternalSet( cH ) ) /
          Order( Representative( cH ) );
    end
  );

##############################################################################
##
#O  nLHnumber( <L>, <H> )
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
#O  nLHnumber( <cL>, <cH> )
##
  InstallMethod( nLHnumber,
    "return n(L,H)",
    IsIdenticalObj,
    [ IsConjugacyClassSubgroupsRep, IsConjugacyClassSubgroupsRep ],
    function( cL, cH )
      local nLH,         # n(L,H)
            L, H;

      L := Representative( cL );
      H := Representative( cH );
      if not IsZero( Order( H ) mod Order( L ) ) then
        return 0;
      fi;

      nLH := 0;
      for H in cH do
        if IsSubset( H, L ) then
          nLH := nLH+1;
        fi;
      od;

      return nLH;
    end
  );

#############################################################################
##
#A  LatticeCCSs( <grp> )
##
  InstallMethod( LatticeCCSs,
    "returns the lattice of CCSs of <grp>",
    [ IsGroup ],
    function( grp )
      local ccs_list,		# CCS list
            lat,		# lattice of CCSs
            c,			# a CCS
            node_shape_list,	# define the node shape of
				# each CCS in the lattice diagram
				# normal subgroups -> squares
				# others -> circles
            rank_list;		# define the rank of each CCS,
				# which is the order of the subgroup

      ccs_list := ConjugacyClassesSubgroups( grp );
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

      lat := NewLattice( IsLatticeCCSsRep,
        rec(
          poset := ccs_list,
          node_labels := [ 1 .. Size( ccs_list ) ],
          node_shapes := node_shape_list,
          rank_type := "Order",
          ranks := rank_list,
          is_rank_reversed := true,
          group := grp
        )
      );
      SetConjugacyClassesSubgroups( lat, ccs_list );

      return lat;
    end
  );

##  Appendix: Print, View, Display

#############################################################################
##
#A  PrintString( <lat> )
##
  InstallMethod( PrintString,
    "print string for lattice of CCSs",
    [ IsLatticeCCSsRep ],
    function( lat )
      return Concatenation( "LatticeCCSs(", String( lat!.group ), ")" );
    end
  );

#############################################################################
##
#O  PrintObj( <lat> )
##
  InstallMethod( PrintObj,
    "print lattice of CCSs",
    [ IsLatticeCCSsRep ],
    function( lat )
      Print( PrintString( lat ) );
    end
  );

#############################################################################
##
#A  ViewString( <lat> )
##
  InstallMethod( ViewString,
    "view string for lattice of CCSs",
    [ IsLatticeCCSsRep ],
    function( lat )
      return Concatenation( "<CCS lattice of ", ViewString( lat!.group ),
          ", ", String( Size( ConjugacyClassesSubgroups( lat ) ) ),
          " classes>" );
    end
  );


#############################################################################
##
#E  Group.gi . . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
