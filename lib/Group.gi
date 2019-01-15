#############################################################################
##
#W  Group.gi		GAP Package `EquiDeg'			    Haopin Wu
##
#Y  Copyright (C) 2017-2019, Haopin Wu
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
#A  IdCC( <c> )
##
  InstallMethod( IdCC,
    "contains id of CC",
    [ IsConjugacyClassGroupRep ],
    function( c )
      local G,
            CCs;

      G := ActingDomain( c );
      if IsFinite( G ) then
        CCs := ConjugacyClasses( G );
        return Position( CCs, c );
      else
        TryNextMethod( );
      fi;
    end
  );

#############################################################################
##
#A  IdCCS( <C> )
##
  InstallMethod( IdCCS,
    "contains id of CCS",
    [ IsConjugacyClassSubgroupsRep ],
    function( C )
      local G,
            CCSs;

      G := ActingDomain( C );
      if IsFinite( G ) then
        CCSs := ConjugacyClassesSubgroups( G );
        return Position( CCSs, C );
      else
        TryNextMethod( );
      fi;
    end
  );

#############################################################################
##
#O  IdCCSPartialOrder( <id1>, <id2> )
##
  InstallGlobalFunction( IdCCSPartialOrder,
    function( id1, id2 )
      if IsPosInt( id1 ) and IsPosInt( id2 ) then
        return ( id1 < id2 );
      elif IsHomogeneousList( id1 ) and IsHomogeneousList( id2 ) and
          ( Length( id1 ) = Length( id2 ) ) then
        if ( id1[ 1 ] > 0 ) and ( id2[ 1 ] = 0 ) then
          return true;
        elif ( id1[ 1 ] = 0 ) and ( id2[ 1 ] > 0 ) then
          return false;
        else
          return id1 < id2;
        fi;
      else
        Error( "<id1> and <id2> should have the same format." );
      fi;
    end
  );

#############################################################################
##
#O  ConjugacyClassSubgroups( <U> )
##
  InstallOtherMethod( ConjugacyClassSubgroups,
    "return the CCS containing the given subgroup",
    [ IsGroup and HasParentAttr ],
    function( U )
      local G,		# the parent group
            CCSs;	# conjugacy classes of subgroups of <grp>

      G := ParentAttr( U );
      CCSs := ConjugacyClassesSubgroups( G );

      return First( CCSs, C -> U in C );
    end
  );

##############################################################################
##
#O  nLHnumber( <L>, <H> )
##
  InstallMethod( nLHnumber,
    "return n(L,H)",
    IsIdenticalObj,
    [ IsGroup and HasParentAttr, IsGroup and HasParentAttr ],
    function( L, H )
      local G,		# the parent group
            x,		# indeterminate
            CH;		# Conjugacy Class of H

      G := ParentAttr( L );
      x := X( Integers, "x" );

      if not ( ParentAttr( H ) = G ) then
        Error( "L and H need to have the same parent group." );
      fi;

      if not IsFinite( G ) then
        TryNextMethod( );
      fi;

      if not IsZero( Order( H ) mod Order( L ) ) then
        return Zero( x );
      else
        CH := ConjugacyClassSubgroups( G, H );
        return Number( CH, U -> IsSubset( U, L ) )*One( x );
      fi;
    end
  );

#############################################################################
##
#O  nLHnumber( <CL>, <CH> )
##
  InstallMethod( nLHnumber,
    "return n(L,H)",
    IsIdenticalObj,
    [ IsConjugacyClassSubgroupsRep, IsConjugacyClassSubgroupsRep ],
    function( CL, CH )
      local G,		# the group
            L, H,	# representatives of CL and CH
            x;		# indeterminate

      G := ActingDomain( CL );
      x := X( Integers, "x" );

      if not ( ActingDomain( CH ) = G ) then
        Error( "<CL> and <CH> have to be CCSs of the same group." );
      fi;

      if not IsFinite( G ) then
        TryNextMethod( );
      fi;

      L := Representative( CL );
      H := Representative( CH );

      if not IsZero( Order( H ) mod Order( L ) ) then
        return Zero( x );
      else
        return Number( CH, U -> IsSubset( U, L ) )*One( x );
      fi;
    end
  );

#############################################################################
##
#O  \<( <C1>, <C2> )
##
  InstallMethod( \<,
    "the partial order of conjugacy classes of subgroups of a finite group",
    [ IsConjugacyClassSubgroupsRep, IsConjugacyClassSubgroupsRep ],
    function( C1, C2 )
      return IsPosInt( nLHnumber( C1, C2 ) );
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
      local x;

      x := X( Integers, "x" );

      return Order( NormalizerInParent( H ) ) / Order( H ) * One( x );
    end
  );

#############################################################################
##
#A  OrderOfWeylGroup( <C> )
##
  InstallMethod( OrderOfWeylGroup,
    "return order of weyl group",
    [ IsConjugacyClassSubgroupsRep ],
    function( C )
      local x;

      x := X( Integers, "x" );

      return Order( StabilizerOfExternalSet( C ) ) /
          Order( Representative( C ) ) * One( x );
    end
  );

#############################################################################
##
#A  LatticeCCSs( <G> )
##
  InstallMethod( LatticeCCSs,
    "returns the lattice of CCSs of <grp>",
    [ IsGroup ],
    function( G )
      local CCSs,		# CCS list
            lat,		# lattice of CCSs
            C,			# a CCS
            node_shape_list,	# define the node shape of
				# each CCS in the lattice diagram
				# normal subgroups -> squares
				# others -> circles
            rank_list;		# define the rank of each CCS,
				# which is the order of the subgroup

      CCSs := ConjugacyClassesSubgroups( G );
      node_shape_list := [ ];
      rank_list := [ ];
      for C in CCSs do
        if ( Size( C ) = 1 ) then
          Add( node_shape_list, "square" );
        else
          Add( node_shape_list, "circle" );
        fi;
        Add( rank_list, Order( Representative( C ) ) );
      od;

      lat := NewLattice( IsLatticeCCSsRep,
        rec(
          poset := CCSs,
          node_labels := [ 1 .. Size( CCSs ) ],
          node_shapes := node_shape_list,
          rank_type := "Order",
          ranks := rank_list,
          is_rank_reversed := true,
          group := G
        )
      );
      SetConjugacyClassesSubgroups( lat, CCSs );

      return lat;
    end
  );

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
