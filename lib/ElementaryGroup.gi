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


## Part 1: Special Groups

#############################################################################
##
#F  pCyclicGroup( <n> )
##
InstallGlobalFunction( pCyclicGroup,
  function( n )
    local i,		  # index
          gen,    # generator of Z_n
          result;

    if not IsPosInt( n ) then
      Error( "n must be a positive integer." );
    fi;

    gen := ( );
    for i in [ 1 .. n-1 ] do
      gen := ( i, i+1 )*gen;
    od;

    result := Group( gen );

    SetString( result, StringFormatted( "pCyclicGroup( {} )", n ) );

    return result;
  end
);


#############################################################################
##
#F  mCyclicGroup( <n> )
##
InstallGlobalFunction( mCyclicGroup,
  function( n )
    local z, rz, iz,	# a complex number and its real and imaginary parts
          gen_mat,    # generator of Z_n
          result;

    if not IsPosInt( n ) then
      Error( "n must be a positive integer." );
    fi;

    z := E( n );
    rz := RealPart( z );
    iz := ImaginaryPart ( z );
    gen_mat := [ [ rz, -iz ], [ iz, rz ] ];

    result := Group( gen_mat );
    SetString( result, StringFormatted( "mCyclicGroup( {} )", n ) );

    return result;
  end
);


#############################################################################
##
#F  pDihedralGroup( <n> )
##
InstallGlobalFunction( pDihedralGroup,
  function( n )
    local i,            # index
          gen1, gen2,   # generators of Dn
                        # gen1 associates to rotation
                        # gen2 associates to reflection
          result;

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

    result := Group( [ gen1, gen2 ] );
    SetString( result, StringFormatted( "pDihedralGroup( {} )", n ) );

    return result;
  end
);


#############################################################################
##
#F  mDihedralGroup( <n> )
##
InstallGlobalFunction( mDihedralGroup,
  function( n )
    local z, rz, iz,    # a complex number and
                        # its real and imaginary parts
          gen1, gen2,   # generators of D_n
                        # gen1 associates to rotation
                        # gen2 associates to reflection
          result;

    z := E( n );
    rz := RealPart( z );
    iz := ImaginaryPart ( z );
    gen1 := [ [ rz, -iz ], [ iz, rz ] ];
    gen2 := [ [ 1, 0 ], [ 0, -1 ] ];

    result := Group( [ gen1, gen2 ] );
    SetString( result, StringFormatted( "mDihedralGroup( {} )", n ) );

    return result;
  end
);


#############################################################################
##
#E  ElementaryGroup.gi . . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
