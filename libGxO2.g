#-------
# GxO2 GAP Library
#-------
# This library provides functions for determine
# the conjugacy classes of subgroups(CCSs)
# in G\times O(2) where G is a finite group.
# Also it can perform the addition and
# multiplication of the Burnside ring induced by
# Gamma times O(2).
#-------

#-----
# part 0: declaration
#-----

#---
# dependent library
#---
  Read( Filename( GAPEL_DIR, "libSys.g" ) );
  Read( Filename( GAPEL_DIR, "libBasicGroupTheory.g" ) );
  Read( Filename( GAPEL_DIR, "libOrbitTypes.g" ) );
#---

#---
# options
#---
  # set message level (2 in default)
  # there are four message levels: 1->error, 2->notice, 3->verbose, 4->debug
  PushOptions( rec( msglevel := 2 ) );
#---

#---
# global variable
#---
  # the finite group G
  DeclareGlobalVariable( "_G" );

  # the list of irreducible G-representations
  DeclareGlobalVariable( "_irr_G" );

  # the CCs in G
  DeclareGlobalVariable( "_CCs_G" );

  # the CCSs in G
  DeclareGlobalVariable( "_CCSs_G" );

  # name list of CCSs in G
  DeclareGlobalVariable( "_Name_CCSs_G" );

  # name list of CCSs in O(2)
  DeclareGlobalVariable( "_Name_CCSs_O2" );
  MakeReadWriteGlobal( "_Name_CCSs_O2" );
  _Name_CCSs_O2 := [ "Z_", "D_", "SO(2)", "O(2)" ];
  MakeReadOnlyGlobal( "_Name_CCSs_O2" );

  # the CCSs in GxO(2)
  DeclareGlobalVariable( "_CCSs_GxO2" );

  # the history of DN
  DeclareGlobalVariable( "_DN_History" );
  MakeReadWriteGlobal( "_DN_History" );
  _DN_History := [ ];
  MakeReadOnlyGlobal( "_DN_History" );

  # the dihedral group DN
  DeclareGlobalVariable( "_DN" );

  # the list of irreducible DN-representations
  DeclareGlobalVariable( "_irr_DN" );

  # the cyclic group ZN
  DeclareGlobalVariable( "_ZN" );

  # GxDN where the subgroup in GxO(2) will be embedded
  DeclareGlobalVariable( "_GxDN" );

  # CCSs of GxDN
  DeclareGlobalVariable( "_CCSs_GxDN" );

  # CCs of GxDN
  DeclareGlobalVariable( "_CCs_GxDN" );

  # the list of irreducible GxDN-representations
  DeclareGlobalVariable( "_irr_GxDN" );

  # the projection map from GxDN to G
  DeclareGlobalVariable( "_Proj_to_G" );

  # the projection map from GxDN to DN
  DeclareGlobalVariable( "_Proj_to_DN" );

  # the embedding map from G to GxDN (the other component would be identity)
  DeclareGlobalVariable( "_Embed_from_G" );

  # the embedding map from DN to GxDN (the other component would be identity)
  DeclareGlobalVariable( "_Embed_from_DN" );
#---


#-----
# part 1: setup
#-----

#---
# setupG( G ) assigns a finite group to _G,
#---
  setupG := function( G )

  # msglevel: notice
  if ( ValueOption( "msglevel" ) > 1 )  then
    Print( "G = ", G, "\n" );
    Print( "Setting up G... " );
  fi;

  # check if the argument is a group
  # msglevel: error
  if not IsGroup( G ) then
    Error( "The given argument is not a group!" );
  fi;

  # unlock global variables
  MakeReadWriteGlobal( "_G" );
  MakeReadWriteGlobal( "_irr_G" );
  MakeReadWriteGlobal( "_CCs_G" );
  MakeReadWriteGlobal( "_CCSs_G" );
  MakeReadWriteGlobal( "_Name_CCSs_G" );
  MakeReadWriteGlobal( "_DN_History" );

  # assign values
  _G := G;
  _irr_G := Irr( _G );
  _CCs_G := ConjugacyClasses( _G );
  _CCSs_G := ConjugacyClassesSubgroups( _G );
  _Name_CCSs_G := [ 1 .. Size( _CCSs_G ) ];
  _DN_History := [ ];

  # lock global variables
  MakeReadOnlyGlobal( "_G" );
  MakeReadOnlyGlobal( "_irr_G" );
  MakeReadOnlyGlobal( "_CCs_G" );
  MakeReadOnlyGlobal( "_CCSs_G" );
  MakeReadOnlyGlobal( "_Name_CCSs_G" );
  MakeReadOnlyGlobal( "_DN_History" );

  # msglevel: notice
  if ( ValueOption( "msglevel" ) > 1 ) then
    Print( "Done!\n\n" );
  fi;
  
  end;
#---

#---
# setupNameCCSsG( namelist ) sets up name list of CCSs in G
#---
  setNameCCSsG := function( namelist )

  # check if G is already assigned
  if IsEmpty( _CCSs_G ) then
    Error( "Please run setupG first." );
  fi;

  # check if the length of name list matches the number of CCSs in G
  if not ( Size( namelist ) = Size( _CCSs_G ) ) then
    Error( "The length of name list does not match the number of CCSs in G." );
  fi;

  # unlock global variables
  MakeReadWriteGlobal( "_Name_CCSs_G" );
  
  # assign values
  _Name_CCSs_G := namelist;

  # lock global variables
  MakeReadOnlyGlobal( "_Name_CCSs_G" );

  end;
#---

#---
# setupDN( N ) assigns a dihedral group to global variable _DN;
#	G times DN to global variables _GxDN; also, it sets up the
#	projections and embeddings of the direct product.
#---
  setupDN := function( N, detail )

  # local variable
  local DN;

  # msglevel: verbose
  if ( ValueOption( "msglevel" ) > 2 ) then
    Print( "Setting up D_", N, "... " );
  fi;

  # check if the global variable _G is already bound
  # msglevel: error
  if not IsGroup( _G ) then
    Error( "Global variable \"_G\" is not yet assigned!" );
  fi;

  # unlock global variables
  MakeReadWriteGlobal( "_DN_History" );
  MakeReadWriteGlobal( "_DN" );
  MakeReadWriteGlobal( "_irr_DN" );
  MakeReadWriteGlobal( "_ZN" );
  MakeReadWriteGlobal( "_GxDN" );
  MakeReadWriteGlobal( "_CCs_GxDN" );
  MakeReadWriteGlobal( "_CCSs_GxDN" );
  MakeReadWriteGlobal( "_irr_GxDN" );
  MakeReadWriteGlobal( "_Proj_to_G" );
  MakeReadWriteGlobal( "_Proj_to_DN" );
  MakeReadWriteGlobal( "_Embed_from_G" );
  MakeReadWriteGlobal( "_Embed_from_DN" );

  if not IsBound( _DN_History[ N ] ) then
    DN := pDihedralGroup( N );
    _DN_History[ N ] := rec( );
    _DN_History[ N ].DN := DN;
    _DN_History[ N ].GxDN := DirectProduct( _G, DN );
    _DN_History[ N ].ZN := SubgroupNC( DN, [ Identity( DN ), DN.2 ] );
  fi;

  # assign values
  _DN := _DN_History[ N ].DN;
  _irr_DN := Irr( _DN );
  _ZN := _DN_History[ N ].ZN;
  _GxDN := _DN_History[ N ].GxDN;
  _irr_GxDN := Irr( _GxDN );
  _Proj_to_G := Projection( _GxDN, 1 );
  _Proj_to_DN := Projection( _GxDN, 2 );
  _Embed_from_G := Embedding( _GxDN, 1 );
  _Embed_from_DN := Embedding( _GxDN, 2 );

  if ( detail = true ) then
    _CCs_GxDN := ConjugacyClasses( _GxDN );
    _CCSs_GxDN := ConjugacyClassesSubgroups( _GxDN );
  fi;

  # lock global variables
  MakeReadOnlyGlobal( "_DN_History" );
  MakeReadOnlyGlobal( "_DN" );
  MakeReadOnlyGlobal( "_irr_DN" );
  MakeReadOnlyGlobal( "_ZN" );
  MakeReadOnlyGlobal( "_GxDN" );
  MakeReadOnlyGlobal( "_CCs_GxDN" );
  MakeReadOnlyGlobal( "_CCSs_GxDN" );
  MakeReadOnlyGlobal( "_irr_GxDN" );
  MakeReadOnlyGlobal( "_Proj_to_G" );
  MakeReadOnlyGlobal( "_Proj_to_DN" );
  MakeReadOnlyGlobal( "_Embed_from_G" );
  MakeReadOnlyGlobal( "_Embed_from_DN" );

  # msglevel: verbose
  if ( ValueOption( "msglevel" ) > 2 ) then
    Print( "Done!\n\n" );
  fi;

  end;
#---


#-----
# part 2: finding CCSs
#-----

#---
# factorGroupO2( id ) generates factor group in O(2)
#---
  factorGroupO2 := function( id )

  # local variables
  local d;	# the dihedral group

  # generate D_n
  d := pDihedralGroup( id[ 2 ] );

  # return Z_n
  if ( id[ 1 ] = 1 ) then
    return SubgroupNC( d, [ Identity( d ), d.2 ] );

  # return D_n
  elif ( id[ 1 ] = 2 ) then
    return d;

  # unknown type
  else
    Error( "Unknown type of factor group." );
  fi;

  end;
#---

#---
# idFactorGroupO2( L ) determines id of L
#---
  idFactorGroupO2 := function( L )

  # determine type of L
  if ( Order( L ) = 2 ) then
    # determine that L is Z_2 or D_1
    if ( L = factorGroupO2( [ 1, 2 ] ) ) then
      return [ 1, 2 ];
    elif ( L = factorGroupO2( [ 2, 1 ] ) ) then
      return [ 2, 1 ];
    fi;

  elif ( IdGroup( L ) = IdGroup( CyclicGroup( Order( L ) ) ) ) then
    return [ 1, Order( L ) ];

  elif ( IdGroup( L ) = IdGroup( DihedralGroup( Order( L ) ) ) ) then
    return [ 2, Order( L ) / 2 ];

  else
    Error( "L is not of type Z_n nor D_n." );
  fi;

  end;
#---

#---
# isConjugateEpimorphismsGxO2( phi1, phi2 ) determines whether two
#	epimorphisms phi1 and phi2 are conjugate to each other in GxO(2).
#---
  isConjugateEpimorphismsGxO2 := function( phi1, phi2 )

  # define local variables
  local H,		# a subgroup in G
	L,		# a factor group in O2
	id_L,		# id of L
	NH,		# normalizer of H
	elmt_NH,	# element in the normalizer
	conj_phi1,	# twisted phi1 in its domain
	conj_phi1_conj,	# twisted phi1 in both its domain and codomain
	i, j;		# indexes

  # extract H and L
  H := PreImage( phi1 );
  L := Image( phi1 );

  # check if phi1 and phi2 have the same domain and codomain
  if not ( ( PreImage( phi2 ) = H ) and ( Image( phi2 ) = L ) ) then
    return false;
  fi;

  # case 1: L = Z_1
  if ( Order( L ) = 1 ) then
    return true;
  fi;

  # find NH
  NH := Normalizer( _G, H );

  # case 2: L = Z_2 or D_1
  if ( Order( L ) = 2 ) then
    # they are conjugate if their kernels are conjugate
    if IsConjugate( NH, Kernel( phi1 ), Kernel( phi2 ) ) then
      return true;
    fi;
  fi;

  # get id of L and reconstruct L by its id
  id_L := idFactorGroupO2(L);
  L := factorGroupO2(id_L);

  # case 3: L = Z_n, n>2
  if ( id_L[ 1 ] = 1 ) then
    for elmt_NH in AsList( NH ) do
      # twist phi1 in its domain
      conj_phi1 := GroupHomomorphismByFunction( H, H, s -> s^elmt_NH, s -> s^( elmt_NH^-1 ) ) * phi1;
 
      for i in [ 1, -1 ] do
        # and also, twist phi1 in its codomain
        conj_phi1_conj := conj_phi1 * GroupHomomorphismByFunction( L, L, s -> s^i, s -> s^i );

        # phi1 and phi2 are conjugate if phi2 is equal to twisted phi1
        if ( conj_phi1_conj = phi2 ) then
          return true;
        fi;
      od;
    od;

  # case 4: L = D_n, n>1
  elif ( id_L[ 1 ] = 2 ) then
    for elmt_NH in AsList( NH ) do
      # twist phi1 in its domain
      conj_phi1 := GroupHomomorphismByFunction( H, H, s -> s^elmt_NH, s -> s^( elmt_NH^-1 ) ) * phi1;

      for i in [ -1, 1 ] do
        for j in [ 0 .. id_L[ 2 ] - 1 ] do
          # and also, twist phi1 in its codomain
          conj_phi1_conj := conj_phi1*GroupHomomorphismByImagesNC( L, L, [ L.1, L.2 ], [ L.1*L.2^j, L.2^i ] );

          # phi1 and phi2 are conjugate if phi2 is equal to twisted phi1
          if ( conj_phi1_conj = phi2 ) then
            return true;
          fi;
        od;
      od;
    od;
  fi;

  # if all attempts fail, return false
  return false;

  end;
#---

#---
# conjugacyClassesEpimorphisms( epi_list ) classifies epimorphisms
#	in epi_list by conjugation
#---
  conjugacyClassesEpimorphisms := function( epi_list )

  # define local variables
  local epi,		# epimorphism
	ccepis,		# conjugacy classes of epimorphisms
	i;		# index

  # initialize conjugacy classes of epimorphisms
  ccepis := [ ];
  while not IsEmpty( epi_list ) do
    # pop a epimorphism from the list to form a new conjugacy class
    Add( ccepis, [ ] );
    epi := Remove( epi_list, 1 );
    Add( ccepis[ Size( ccepis ) ], epi );

    # pop epimorphisms in the list to the same conjugacy class
    # which are conjugate to the epimorphism above
    i := 1;
    while i <= Size( epi_list ) do
      if isConjugateEpimorphismsGxO2( epi, epi_list[ i ] ) then
        Add( ccepis[ Size( ccepis ) ], Remove( epi_list, i ) );
      else
        i := i + 1;
      fi;
    od;
  od;

  return ccepis;

  end;
#---

#---
# conjugacyClassesSubgroupsGxO2() finds all the CCSs in GxO(2)
#	and store the list in the global variable _CCSs_GxO2.
#---
  conjugacyClassesSubgroupsGxO2 := function( )
  #	Strictly speaking, each term in the list represent a type of CCSs.
  #	For example, (V_4 x D_n) for arbitrary n would be considered as
  #	only one type.
  #
  #	Suppose S = amal( H, phi, L, psi, K ) is a representative of a CCS. Then
  #	this CCS is described by seven components:
  #
  #		1. ID of H
  #		2. ID of ker(phi)
  #		3. ID of L
  #		4. ID of K
  #		5. ID of ker(psi)
  #		6. list of phi:H->L
  #		7. ID of \phi^{-1}(<r>)
  #		8. |W|
  #
  #	For 4 and 5, note that we can classify (closed) subgroups in O(2) into
  #	the following four categories:
  #
  #		1: Z_n
  #		2: D_n
  #		3: SO(2)
  #		4: O(2)
  #
  #	To specify a certain CCS in G x O(2), we use a pair
  #	of numbers:
  #
  #		idccs := [ type, mode ]

  # define local variables
  local ccs,		# a CCS in G x O(2)
	ccs_alt,	# another CCS
	H,		# a representative of a CCS in G
	order_WH,	# order of W(H)
	L,		# a factor group
	id_pre_r,	# ID of phi^{-1}(<r>)
	id_L,		# ID of L
	epi_over_auto,	# the list of all epimorphisms up to automorphisms of the image
	auto_list,	# the list of all automorphisms
	phi_list,	# the list of epimorphisms
	ccsphi,		# conjugacy classes of phi
	ccphi,		# conjugacy class of phi
	nccphi,		# number of epimorphisms in a CCE
	i, j, k;	# indexes

  # check if _G and _CCSs_G is already set up
  # msglevel: error
  if not IsGroup( _G ) then
    Error( "Please run setupG first." );
  fi;

  # msglevel: notice
  if ( ValueOption( "msglevel" ) > 1 ) then
    Print( "Finding all CCSs in GxO(2)... " );
  fi;

  # msglevel: verbose
  if ( ValueOption( "msglevel" ) > 2 ) then
    Print( "\n\n" );
  fi;

  # initialize CCSs in G x O(2)
  MakeReadWriteGlobal( "_CCSs_GxO2" );
  _CCSs_GxO2 := [ ];
  ccs := [ ];

  # find CCSs in G x O(2) by shuffling H
  for i in [ 1 .. Size( _CCSs_G ) ] do
    # take a representative from a CCS in Gamma
    H := Representative( _CCSs_G[ i ] );
    order_WH := IndexNC( Normalizer( _G, H ), H );

    # msglevel: verbose
    if ( ValueOption( "msglevel" ) > 2 ) then
      Print( "Finding CCSs in G x O(2) related to ", i );
      Print( "-th CCS in G (order ", Order( H ), ") ...\n" );
    fi;

    # record ID of the CCS in Gamma
    ccs[ 1 ] := i;

    for j in [ 1 .. Order( H ) ] do
      # skip the case that j doesn't divide order_H
      if not ( ( Order( H ) mod j ) = 0 ) then
        continue;
      fi;

      # msglevel: verbose
      if ( ValueOption( "msglevel" ) > 2 ) then
        Print( "\tTrying L = Z_", j, " ...\n" );
      fi;

      # case 1: L is a cyclic group
      id_L := [ 1, j ];
      L := factorGroupO2( id_L );

      # check if there is an epimorphism from H to L
      epi_over_auto := GQuotients( H, L );
      if not IsEmpty( epi_over_auto ) then
        # store L
        ccs[ 3 ] := id_L;

        # find all epimorphisms
        auto_list := AllAutomorphisms( L );
        phi_list := [ ];
        for k in [ 1 .. Size( epi_over_auto ) ] do
          Append( phi_list, epi_over_auto[ k ] * auto_list );
        od;

        # classify epimorphisms by conjugation
        ccsphi := conjugacyClassesEpimorphisms( phi_list );
        for k in [ 1 .. Size( ccsphi ) ] do
          # store the ker(phi) and the conjugate epimorphisms
          ccphi := ccsphi[ k ];
          ccs[ 6 ] := ccphi;
          ccs[ 2 ] := idCCS( _CCSs_G, Kernel( ccphi[ 1 ] ) );
          nccphi := Size( ccphi );

          # extract pre_r
          if L.2 = Identity( L ) then
            id_pre_r := 0;
          else
            id_pre_r := idCCS( _CCSs_G, PreImage( ccphi[ 1 ], Subgroup( L, [ L.2 ] ) ) );
          fi;
          ccs[ 7 ] := id_pre_r;

          # store type of K, type of ker(psi) and |W|
          # case 1-0: for any j
          # Z_jn/Z_n
          ccs[ 4 ] := 1;
          ccs[ 5 ] := 1;
          ccs[ 8 ] := infinity;
          Add( _CCSs_GxO2, ShallowCopy( ccs ) );

          # case 1-1: L = Z_1
          if ( j = 1 ) then
            # D_n/D_n
            ccs[ 4 ] := 2;
            ccs[ 5 ] := 2;
            ccs[ 8 ] := order_WH * 2 * j / nccphi;
            Add( _CCSs_GxO2, ShallowCopy( ccs ) );
           
            # SO(2)/SO(2)
            ccs[ 4 ] := 3;
            ccs[ 5 ] := 3;
            ccs[ 8 ] := order_WH * 2 * j / nccphi;
            Add( _CCSs_GxO2, ShallowCopy( ccs ) );

            # O(2)/O(2)
            ccs[ 4 ] := 4;
            ccs[ 5 ] := 4;
            ccs[ 8 ] := order_WH * 1 * j / nccphi;
            Add( _CCSs_GxO2, ShallowCopy( ccs ) );

          # case 1-2: L = Z_2
          elif ( j = 2 ) then
            # D_2n/D_n
            ccs[ 4 ] := 2;
            ccs[ 5 ] := 2;
            ccs[ 8 ] := order_WH * 1 * j / nccphi;
            Add( _CCSs_GxO2, ShallowCopy( ccs ) );
          fi;
        od;
      fi;

      # case 2: the factor group is a dihedral group
      if not IsEvenInt( j ) then
        continue;
      fi;

      # msglevel: verbose
      if ( ValueOption( "msglevel" ) > 2 ) then
        Print( "\tTrying L = D_", j/2, " ...\n" );
      fi;

      # let L = D_(j/2)
      id_L := [ 2, j/2 ];
      L := factorGroupO2( id_L );

      # check if there is an epimorphism from H to L
      epi_over_auto := GQuotients( H, L );
      if not IsEmpty( epi_over_auto ) then
        # store L
        ccs[ 3 ] := id_L;

        # find all epimorphisms
        auto_list := AllAutomorphisms( L );
        phi_list := [ ];
        for k in [ 1 .. Size( epi_over_auto ) ] do
          Append( phi_list, epi_over_auto[ k ] * auto_list );
        od;

        # classify epimorphisms by conjugation
        ccsphi := conjugacyClassesEpimorphisms( phi_list );
        for k in [ 1 .. Size( ccsphi ) ] do
          # store the ker(phi), the conjugate epimorphisms and |W|
          ccphi := ccsphi[ k ];
          ccs[ 6 ] := ccphi;
          ccs[ 2 ] := idCCS( _CCSs_G, Kernel( ccphi[ 1 ] ) );
          nccphi := Size( ccphi );

          # extract pre_r
          if L.2 = Identity( L )  then
            id_pre_r := 0;
          else
            id_pre_r := idCCS( _CCSs_G, PreImage( ccphi[ 1 ], Subgroup( L, [ L.2 ] ) ) );
          fi;
          ccs[ 7 ] := id_pre_r;
            
          # D_((j/2)n)/Z_n
          ccs[ 4 ] := 2;
          ccs[ 5 ] := 1;
          ccs[ 8 ] := order_WH * 2 * j / nccphi;
          Add( _CCSs_GxO2, ShallowCopy( ccs ) );

          # store type of K and ker(psi)
          if ( j = 2 ) then
            # O(2)/SO(2)
            ccs[ 4 ] := 4;
            ccs[ 5 ] := 3;
            ccs[ 8 ] := order_WH * 1 * j / nccphi;
            Add( _CCSs_GxO2, ShallowCopy( ccs ) );
          fi;
        od;
      fi;
    od;

    # msglevel: verbose
    if ( ValueOption( "msglevel" ) > 2 ) then
      Print( "\n" );
    fi;

  od;

  # drop phi^{-1}(r) if there is no need to keep this info
  for i in [ 1 .. Size( _CCSs_GxO2 ) ] do
    ccs := _CCSs_GxO2[ i ];
    if ( i > 1 ) then
      ccs_alt := _CCSs_GxO2[ i - 1 ];
      if ( ccs{ [ 1 .. 5 ] } = ccs_alt{ [ 1 .. 5 ] } ) then
        continue;
      fi;
    fi;

    if i < Size( _CCSs_GxO2 ) then
      ccs_alt := _CCSs_GxO2[ i + 1 ];
      if ( ccs{ [ 1 .. 5 ] } = ccs_alt{ [ 1 .. 5 ] } ) then
        continue;
      fi;
    fi;
    ccs[ 7 ] := 0;
  od;

  # Sorting CCSs list
  # msglevel: verbose
  if ( ValueOption( "msglevel" ) > 2 ) then
    Print( "Sorting the List of CCSs in GxO(2)...\n\n" );
  fi;
  SortBy( _CCSs_GxO2, v -> [ v[ 4 ],		# first by id of K
  			     v[ 5 ],		# second by id of ker_psi
			     v[ 3 ][ 2 ],	# thrid by mode of L
			     v[ 1 ],		# fourth by type of H
			     v[ 2 ],		# fifth by ker_phi
			     v[ 7 ] ] );	# sixth by pre_r
  
  # lock the global varaible _CCSs_GxO2
  MakeReadOnlyGlobal("_CCSs_GxO2");

  # msglevel: notice
  if ( ValueOption( "msglevel" ) > 1 ) then
    Print( "Done!\n\n" );
  fi;

  end;
#---

#---
#foldingCCSGxO2( folding_number, idccs ) perform folding
#	homomorphism of order n to the given CCS
#	in G x O(2) and return the resulting CCS.
#---
  foldingCCSGxO2 := function( folding_number, idccs )

  # define local variables
  local ccs,			# the given CCS
	id_H,			# ID of H
	L,			# L
	id_L,			# ID of L
	id_ker_psi,		# ID of kernel of psi
	phi,			# phi
	foldingL,		# folding map on L
	fphi,			# folded phi
	fid_ker_phi,		# ID of folded kernel of phi
	fid_L,			# ID of folded L
	fid_pre_r,		# ID of folded phi^{-1}(<r>)
	n, m,			# folding number for mode and L, respectively
	fccs,			# resulting CCS
	fidccs,			# ID of resulting CCS
	i;			# counter
	
  # extract CCS
  ccs := _CCSs_GxO2[ idccs[ 1 ] ];
  # if K is SO(2) or O(2), folding homomorphism will do nothing
  if ccs[ 5 ] in [ 3, 4 ] then
    return idccs;
  fi;

  # find folding number for mode
  n := Gcd( folding_number, idccs[ 2 ] );
  # find folding number for L
  id_L := ccs[ 3 ];
  L := factorGroupO2( id_L );
  m := Gcd( folding_number / n, id_L[ 2 ] );
  # case 1: no folding on L
  if ( m = 1 ) then
    fidccs := [ idccs[ 1 ], idccs[ 2 ] / n ];
    return fidccs;
  fi;

  # case 2: nontrivial folding on L
  # find id of folded L and the folding map on L
  fid_L := [ id_L[ 1 ], id_L[ 2 ] / m];
  foldingL := GroupHomomorphismByImagesNC( L, L, [ L.1, L.2 ], [ L.1, L.2^m ] );
  
  # properties of CCS which won't be changed by folding
  id_H := ccs[ 1 ];
  id_ker_psi := ccs[ 5 ];

  # properties which will be changed by folding
  # find id of folded kernel of phi
  phi := ccs[ 6 ][ 1 ];
  fphi := phi * foldingL;
  fid_ker_phi := idCCS( _CCSs_G, Kernel( fphi ) );
  fid_pre_r := idCCS( _CCSs_G, PreImage( fphi, Subgroup( L, [ L.2 ] ) ) );

  # compare to CCSs in CCS list to find the result
  for i in [ 1 .. Size( _CCSs_GxO2 ) ] do
    fccs := _CCSs_GxO2[ i ];
    if ( fccs[ 1 ] = id_H ) and
       ( fccs[ 2 ] = fid_ker_phi ) and
       ( fccs[ 3 ] = fid_L ) and
       ( fccs[ 5 ] = id_ker_psi ) and
       ( fccs[ 7 ] in [ 0, fid_pre_r ] ) then
      fidccs := [ i, idccs[ 2 ] / n ];
      return fidccs;
    fi;
  od;

  end;
#---


#-----
# part 3: burnside ring
#-----

#---
# idSubgroupO2( K ) determine ID of K < DN in O(2).
#---
  idSubgroupO2 := function( K );

  if not IsSubgroup( _DN, K ) then
    Error( "K is not a subgroup of D_", Order( _DN ) / 2 );
  elif ( K = _DN ) then
    return [ 4, 0 ];
  elif ( K = _ZN ) then
    return [ 3, 0 ];
  elif IsSubset( _ZN, K ) then
    return [ 1, Order( K ) ];
  else
    return [ 2, Order( K ) / 2 ];
  fi;

  end;
#---

#---
# embedIntoDN( id_K ) embeds K < O2 corresponds to the given id into DN
#---
  embedIntoDN := function( id_K )

  # define local variable
  local K;	# a subgroup in DN

  if ( id_K[ 1 ] = 1 ) and ( Order( _ZN ) > id_K[ 2 ] ) and ( Order( _ZN ) mod id_K[ 2 ] = 0 ) then
    K := SubgroupNC( _ZN, [ Identity( _ZN ), _ZN.1^( Order( _ZN ) / id_K[ 2 ] ) ] );
  elif ( id_K[ 1 ] = 2 ) and ( Order( _ZN ) > id_K[ 2 ] ) and ( Order( _ZN ) mod id_K[ 2 ] = 0 ) then
    K := SubgroupNC( _DN, [ _DN.1, _DN.2^( Order( _ZN ) / id_K[ 2 ] ) ] );
  elif ( id_K[ 1 ] = 3 ) then
    K := _ZN;
  elif ( id_K[ 1 ] = 4 ) then
    K := _DN;
  else
    Error( "The input ID cannot be embedded into D_", Order( _ZN ) );
  fi;

  return K;

  end;
#---

#---
# embedIntoGxDN( idccs ) embeds a representative of a
#	CCS in GxO(2) into GxDN.
#---
  embedIntoGxDN := function( idccs )

  # define local variables
  local ccs_GxO2,	# the CCS of G x O2 corresponds to the given id
	phi,		# the epimorphism from H to L
	H,		# a subgroup in G
        h,		# an element in H
        K,		# a subgroup in O(2)
	id_K,		# ID of K
	k,		# an element in K
	L,		# the factor group
	id_L,		# ID of L
	psi,		# the epimorphism from K to L
	id_ker_psi,	# type of ker(psi)
	S,		# the embedding in G x DN
	gen_S;		# generators of S

  # check if _DN and _GxDN are already assigned
  # msglevel: error
  if not IsBound( _DN ) then
    Error( "Please run setupDN first." );
  fi;

  # get the CCS
  ccs_GxO2 := _CCSs_GxO2[ idccs[ 1 ] ];

  # extract properties of the CCS
  phi := ccs_GxO2[ 6 ][ 1 ];
  H := PreImage( phi );
  id_L := ccs_GxO2[ 3 ];
  L := factorGroupO2( id_L );
  id_ker_psi := [ ccs_GxO2[ 5 ], idccs[ 2 ] ];
  id_K := [ ccs_GxO2[ 4 ], id_ker_psi[ 2 ]*id_L[ 2 ] ];
  K := embedIntoDN( id_K );

  # msglevel: verbose
  if ( ValueOption( "msglevel" ) > 2 ) then
    Print( "Embedding representative of CCS(ID = ", idccs, ") " );
    Print( "in GxO2 into GxD_", Order( _DN ) / 2, "... " );
  fi;

  # define psi
  psi := GroupHomomorphismByImagesNC( K, L, GeneratorsOfGroup( K ), GeneratorsOfGroup( L ) );

  # find the generators of S
  gen_S := [ ];
  Append( gen_S, Image( _Embed_from_DN, GeneratorsOfGroup( Kernel( psi ) ) ) );
  for h in GeneratorsOfGroup( H ) do
    k := PreImage( psi, Image( phi, [ h ] ) )[ 1 ];
    Add( gen_S, Image( _Embed_from_G, h ) * Image( _Embed_from_DN, k ) );
  od;
  S := SubgroupNC( _GxDN, gen_S );

  # msglevel: verbose
  if ( ValueOption( "msglevel" ) > 2 ) then
    Print( "Done!\n\n" );
  fi;

  return S;

  end;
#---

#---
# idCCSGxDN( S ) finds the id of CCS in GxO(2) to whom S belongs, where
#	S is a subgroup in GxDN.
#---
  idCCSGxDN := function( S )

  # define local variable
  local idccs,			# ID of CCS in G x O(2)
	ccs_GxO2,		# a CCS in G x O(2)
	H,			# a subgroup in G
	K,			# a subgroup in O(2) which is a dihedral group
	id_K,			# ID of K
	ker_psi,		# kenrel of psi
	id_ker_psi,		# ID of kernel of psi
	id_L,			# ID of L
	i;			# indexes

  # msglevel: verbose
  if ( ValueOption( "msglevel" ) > 2 ) then
    Print( "Identifying ID of CCS in GxO(2) to whom S belongs... " );
  fi;

  # extract property of the CCS
  H := Image( _Proj_to_G, S );
  K := Image( _Proj_to_DN, S );
  ker_psi := Image( _Proj_to_DN, Intersection( S, Image( _Embed_from_DN ) ) );
  id_K := idSubgroupO2( K );
  id_ker_psi := idSubgroupO2( ker_psi );

  # find ID of L
  if ( id_K[ 2 ] > 0 ) and ( id_ker_psi[ 2 ] > 0 ) then
    id_L := [ id_K[ 1 ]/id_ker_psi[ 1 ], id_K[ 2 ]/id_ker_psi[ 2 ] ];
  elif ( id_K[ 2 ] = 0 ) and ( id_ker_psi[ 2 ] = 0 ) then
    id_L := [ ( id_K[ 1 ] - 2 )/( id_ker_psi[ 1 ] - 2 ), 1 ];
  else
    return fail;
  fi;
  
  # test which CCS in G x O(2) S belongs to
  for i in [ 1 .. Size( _CCSs_GxO2 ) ] do
    ccs_GxO2 := _CCSs_GxO2[ i ];

    if ( ccs_GxO2[ 4 ] = id_K[ 1 ] ) and	# match type of K
       ( ccs_GxO2[ 5 ] = id_ker_psi[ 1 ] ) and	# match type of ker(psi)
       ( id_L = ccs_GxO2[ 3 ] ) and		# match order of L
       ( H in _CCSs_G[ ccs_GxO2[ 1 ] ] ) then	# match H

      # set up the candidate idccs, embed and compare
      idccs := [ i, id_ker_psi[ 2 ] ];
      if IsConjugate( _GxDN, embedIntoGxDN( idccs ), S ) then

        # msglevel: verbose
        if ( ValueOption( "msglevel" ) > 2 ) then
          Print( "Done!\n\n" );
        fi;

        return idccs;

      fi;
    fi;
  od;

  return fail;

  end;
#---

#---
# burnsideSimplify( b ) simplifies the form of an element b in
#	the Burnside ring induced by GxO(2)
#---
  burnsideSimplify := function( b )

  # define local variable
  local term1, term2,	# terms in b
	i, j;		# index

  # merge terms with the same idccs and remove terms with zero coefficient
  i := 1;
  while not ( i > Size( b ) ) do
    term1 := b[ i ];

    j := i + 1;
    while not ( j > Size( b ) ) do
      term2 := b[ j ];
      if ( term1[ 1 ] = term2[ 1 ] ) then
        term1[ 2 ] := term1[ 2 ] + term2[ 2 ];
        Remove( b, j );
      else
        j := j + 1;
      fi;
    od;

    if (term1[ 2 ] = 0) then
      Remove(b, i);
    else
      i := i + 1;
    fi;
  od;

  # sort the result
  SortBy( b, v -> [ v[ 1 ][ 2 ],	# first by the mode of CCS
		   -v[ 1 ][ 1 ] ] );	# then by the IDCCS 

  end;
#---

#---
#burnsideGenMulGxO2( idccs1, idccs2 ) multiplies two generators of Burnside
#	ring induced by G x O(2)
#---
  burnsideGenMulGxO2 := function( idccs1, idccs2 )

  # define local variable
  local ccs1, ccs2,		# CCSs in G x O2
	mul_GxO2,		# multiplication list in G x O(2)
	mul_tmp,		# temporary multiplication list
	id_L1, id_L2,		# IDs of L1 and L2
	id_K1, id_K2,		# IDs of K1 and K2
	N,			# folding number of the DN
	S1, S2,			# embedding of ccs1 and ccs2 in G x DN
	SS,			# intersection of S1 and S2
	coll_subgs_SS,		# collection of subgroups in SS
	ccs_SS,			# CCS in SS
	ccS2,			# CCS contains S2
	cS2,			# a subgroup conjugate to S2
	S3,			# A subgroup less than S1 and S2
	n_S3_S1,		# n(S3, S1)
	n_S3_S2,		# n(S3, S2)
	idccs3,			# ID of CCS contains S3 in G x O(2)
	ccs3,			# CCS contains S3 in G x O(2)
	order_W3,		# order of W(S3)
	coeff_S3,		# coeff related to S3
	term,			# a term in the multiplication array
	S4,			# A subgroup which is already in the multiplication list
	order_W4,		# order W(S4)
	coeff_S4,		# the coefficient in S4
	n_S3_S4;		# n(S3, S4)

  # initiate multiplication list
  mul_GxO2 := [ ];
  mul_tmp := [ ];

  # get CCSs
  ccs1 := _CCSs_GxO2[ idccs1[ 1 ] ];
  ccs2 := _CCSs_GxO2[ idccs2[ 1 ] ];

  if ( ccs1[ 8 ] = infinity ) or ( ccs2[ 8 ] = infinity ) then
    return mul_GxO2;
  fi;

  # extract IDs of L1 and L2
  id_L1 := ccs1[ 3 ];
  id_L2 := ccs2[ 3 ];

  # extract IDs of K1 and K2
  id_K1 := [ ccs1[ 4 ], idccs1[ 2 ]*id_L1[ 2 ] ];
  id_K2 := [ ccs2[ 4 ], idccs2[ 2 ]*id_L2[ 2 ] ];

  # determine into which DN the two CCSs should be embedded
  N := Lcm( Maximum( 2*id_K1[ 2 ], 1 ), Maximum( 2*id_K2[ 2 ], 1 ) );
  setupDN( N, false );
  
  # embed both orbit types
  S1 := embedIntoGxDN( idccs1 );
  S2 := embedIntoGxDN( idccs2 );

  # swap S1 and S2 such that S1 is the larger
  if ( Order( S2 ) > Order( S1 ) ) then
    SS := S1;
    S1 := S2;
    S2 := SS;
  fi;

  # shuffle cS2 with all possible conjugates of S2
  # and take SS as the intersection of S1 and cS2
  # let ccss_SS be the union of all CCSs in all these SS
  coll_subgs_SS := [ ];
  ccS2 := ConjugacyClassSubgroups( _GxDN, S2 );
  for cS2 in ccS2 do
    SS := Intersection( S1, cS2 );
    for ccs_SS in ConjugacyClassesSubgroups( SS ) do
      Add( coll_subgs_SS, Representative( ccs_SS ) );
    od;
  od;

  # remove all but one conjugate subgroups in coll_subgs_SS
  removeExtraConjugateCopy( _GxDN, coll_subgs_SS );

  # from large CCS to small one, use the recursive formula
  # for finding the multiplication list
  for S3 in Reversed( coll_subgs_SS ) do
    # find its ID in CCSs of GxO(2)
    idccs3 := idCCSGxDN( S3 );
    if ( idccs3 = fail ) then
      continue;
    fi;

    # exclude the case that W(S3) is infinite
    ccs3 := _CCSs_GxO2[ idccs3[ 1 ] ];
    if ( ccs3[ 8 ] = infinity ) then
      continue;
    fi;

    # compute n(L,H)
    n_S3_S1 := nLHnumber( _GxDN, S1, S3 );
    # compute n(L,K)
    n_S3_S2 := nLHnumber( _GxDN, S2, S3 );

    # find the coefficient with respect to S3
    coeff_S3 := n_S3_S1*ccs1[ 8 ]*n_S3_S2*ccs2[ 8 ];

    # recursive formula
    for term in mul_tmp do
      S4 := term[ 1 ];
      coeff_S4 := term[ 2 ];
      order_W4 := term[ 3 ];

      # compute n(L,L')
      n_S3_S4 := nLHnumber( _GxDN, S4, S3 );
      coeff_S3 := coeff_S3 - n_S3_S4*coeff_S4*order_W4;
    od;

    # adding a new term to multiplication list
    if not ( coeff_S3 = 0 ) then
      order_W3 := ccs3[ 8 ];
      coeff_S3 := coeff_S3/order_W3;
      Add( mul_tmp, [ S3, coeff_S3, order_W3 ] );
      Add( mul_GxO2, [ idccs3, coeff_S3 ] );
    fi;

  od;

  # normalize the result
  burnsideSimplify( mul_GxO2 );
  return mul_GxO2;

  end;
#---

#---
# burnsideAddGxO2( b1, b2 ) add two elements b1, b2 in the Burnside ring
#	induced by GxO(2)
#---
  burnsideAddGxO2 := function( b1, b2 )

  # define local variable
  local sum;		# summation of b1 and b2

  # join b1 and b2
  sum := Concatenation( StructuralCopy( b1 ), StructuralCopy( b2 ) );

  # sort the list according to the size of the subgroups in the CCS
  burnsideSimplify( sum );
  return sum;

  end;
#---

#---
# burnsideScalarMulGxO2( b, z ) multiplies an element b by an integer z
#	in the Burnside ring induced by GxO(2)
#---
  burnsideScalarMulGxO2 := function( b, z )

  # define local variable
  local term_mul,	# term of multiplication
	mul;		# multiplication of b by z

  # msglevel: error
  if not IsInt( z ) then
    Error( "The scalar should be an integer." );
  fi;

  if z = 0 then
    return [ ];
  fi;

  mul := StructuralCopy( b );

  # multiply the coefficient by the scalar term by term
  for term_mul in mul do
    term_mul[ 2 ] := term_mul[ 2 ]*z;
  od;

  # return the result
  return mul;

  end;
#---

#---
#burnsideSubGxO2( b1, b2 ) subtract two elements b1, b2 in the Burnside ring
#	induced by G x O(2)
#---
  burnsideSubGxO2 := function( b1, b2 )

  # define local variable
  local sub;		# subtraction of b1 and b2

  # join b1 and b2
  sub := Concatenation( StructuralCopy( b1 ), burnsideScalarMulGxO2( b2,-1 ) );

  # sort the list according to the size of the subgroups in the CCS
  burnsideSimplify( sub );
  return sub;

  end;
#---

#---
# burnsideMulGxO2( b1, b2 ) multiplies two elements b1, b2 in the Burnside Ring
#	induced by GxO(2)
#---
  burnsideMulGxO2 := function( b1, b2 )

  # define local variable
  local term_b1,	# term in b1
	term_b2,	# term in b2
	gen_mul,	# multiplication of two generators
	mul;		# multiplication of b1 and b2

  # initiate the multiplication
  mul := [ ];

  # apply the distributibe law
  for term_b1 in b1 do
    for term_b2 in b2 do
      gen_mul := burnsideGenMulGxO2( term_b1[ 1 ], term_b2[ 1 ] );
      gen_mul := burnsideScalarMulGxO2( gen_mul, term_b1[ 2 ]*term_b2[ 2 ] );
      Append( mul, gen_mul );
    od;
  od;

  # sort the list according to the size of the subgroups in the CCS
  burnsideSimplify( mul );
  return mul;

  end;
#---

#---
# foldingDegGxO2( folding_number, deg ) applies folding on the given deg
#---
  foldingDegGxO2 := function( folding_number, deg )

  # local variable
  local term,
	fdeg;

  fdeg := [ ];
  for term in deg do
    Add( fdeg, [ foldingCCSGxO2( folding_number, term[ 1 ] ), term[ 2 ] ] );
  od;
  burnsideSimplify( fdeg );
  return fdeg;

  end;
#---


#-----
# part 4: format output
#-----

#---
# id2nameCCSGxO2( idccs ) convert an ID of CCS to
#	a comprehensive name in GxO(2)
#---
  id2nameCCSGxO2 := function( idccs )

  # define local variable
  local ccs,		# CCS
        id_L,		# ID of L
	pre_r,		# phi^{-1}(<r>)
	name_H,		# name of H
	name_ker_phi,	# name of ker(phi)
	name_L,		# name of L
	name_K,		# name of K
	name_ker_psi;	# name of ker(psi)

  if IsPosInt( idccs ) then
    ccs := _CCSs_GxO2[ idccs ];
  elif IsList( idccs ) then
    ccs := _CCSs_GxO2[ idccs[ 1 ] ];
  else
    Error( "Unrecognizable ID of CCS in G x O(2)." );
  fi;

  # extract phi^{-1}(r)
  pre_r := ccs[ 7 ];

  # determine name of H and ker(phi)
  name_H := _Name_CCSs_G[ ccs[ 1 ] ];
  name_ker_phi := _Name_CCSs_G[ ccs[ 2 ] ];

  # determine name of L
  id_L := ccs[ 3 ];
  if ( id_L[ 1 ] = 1 ) then
    name_L := "Z_";
  elif ( id_L[ 1 ] = 2 ) then
    name_L := "D_";
  else
    Error( "Unrecognizable ID of L." );
  fi;
  Append( name_L, String( id_L[ 2 ] ) );

  # determine name of K and ker(psi)
  name_K := ShallowCopy( _Name_CCSs_O2[ ccs[ 4 ] ] );
  name_ker_psi := ShallowCopy( _Name_CCSs_O2[ ccs[ 5 ] ] );

  # append the mode number when K = Z_n or D_n
  if ( ccs[ 4 ] in [ 1, 2 ] ) then
    # case 1: mode is not specified
    if IsPosInt( idccs ) then
      Append( name_ker_psi, "n" );
      if ( id_L[ 2 ] > 1 ) then
        Append( name_K, String( id_L[ 2 ] ) );
      fi;
      Append( name_K, "n" );

    # case 2: mode is specified
    elif IsList( idccs ) then
      Append( name_ker_psi, String( idccs[ 2 ] ) );
      Append( name_K, String( id_L[ 2 ]*idccs[ 2 ] ) );
    fi;
  fi;

  return [ name_H, name_ker_phi, name_L, name_K, name_ker_psi, pre_r ];

  end;
#---

#---
# printCCSsGxO2( ) lists all the CCSs in G x O(2) in a comprehensive format.
#---
  printCCSsGxO2 := function( )

  # define local variable
  local i,		# index
	ccs,		# CCS in G x O(2)
	ccsname,	# name of the CCS
	filename,	# output text file name
	pbrno,		# line break number
	output;		# output stream


  if IsEmpty( _CCSs_GxO2 ) then
    Error( "Please run conjugacyClassesSubgroupsGxO2( ) first." );
  fi;

  # set up line break number, default: 20
  pbrno := ValueOption( "pbrno" );
  if ( pbrno = fail ) then
    pbrno := 20;
  fi;

  # set up output stream, default: screen
  filename := ValueOption( "filename" );
  if not ( filename = fail ) then
    output := OutputTextFile( filename, false );
  else
    output := OutputTextUser( );
  fi;

  # print all CCSs in G x O(2), one CCS per line
  for i in [ 1 .. Size( _CCSs_GxO2 ) ] do
    ccsname := id2nameCCSGxO2( i );
    ccs := _CCSs_GxO2[ i ];

    # print headings for every certain lines
    if ( i mod pbrno = 1 ) then
      AppendTo( output, "-----------------------------------------------------------------\n" );
      AppendTo( output, "ID\tH\tker_phi\tL\tK\tker_psi\tpre_r\t|W|\n" );
      AppendTo( output, "-----------------------------------------------------------------\n" );
    fi;

    # print the CCS
    AppendTo( output, i, "\t", ccsname[ 1 ], "\t", ccsname[ 2 ], "\t", ccsname[ 3 ], "\t", ccsname[ 4 ], "\t", ccsname[ 5 ], "\t", ccsname[ 6 ], "\t", ccs[ 8 ], "\n" );
  od;

  # close the output stream
  CloseStream( output );

  end;
#---

#---
# printBurnsideElemet( b ) prints the comprehensive form of an element
#	in the Burnside Ring induced by GxO(2)
#---
  printBurnsideElement := function( b )

  # define local variable
  local term;	# a term in the summation which describes a element in A(GxO(2))

  if b = [ ] then
    Print( "0\n" );
  fi;
 
  for term in b do
    Print( term[ 2 ], "\t", id2nameCCSGxO2( term[ 1 ] ), "\n" );
  od;

  end;
#---

#---
# streamCCSsGxO2( ) lists all the CCSs in G times O(2)
#	in a format for streaming.
#---
  streamCCSsGxO2 := function( )

  # define local variable
  local i,		# index
	ccs,		# CCS in G times O(2)
	L,		# the quotient group
	pre_r,		# phi^{-1}(<r>)
	CC_pre_r,	# conjugacy class of preimage of r
        order_w;	# order of Weyl group

  if IsEmpty( _CCSs_GxO2 ) then
    Error( "Please run conjugacyClassesSubgroupsGxO2 first." );
  fi;

  # print all CCSs in G x O(2), one CCS per line
  Print( "[ " );
  for i in [ 1 .. Size( _CCSs_GxO2 ) ] do
    ccs := _CCSs_GxO2[ i ];

    # find quotient group L
    L := factorGroupO2( ccs[ 3 ] );

    # When Wyel group is infinite, use 0 represent the case
    if ( ccs[ 8 ] = infinity ) then
      order_w := 0;
    else
      order_w := ccs[ 8 ];
    fi;

    # print the CCS
    Print( "[ ", ccs[ 1 ], ", ", ccs[ 2 ], ", ", ccs[ 3 ], ", ", ccs[ 4 ], ", ", ccs[ 5 ], ", ", ccs[ 7 ], ", ", order_w, " ]" );
    if not ( i = Size( _CCSs_GxO2 ) ) then
      Print( ",\n" );
    fi;
  od;
  Print( " ]" );

  end;
#---

#---
# idEmbed_G_GxO2 embed CCS in G to GxO(2) and
#	return the id of the image of embedding
#---
  idEmbed_G_GxO2 := function( id )

  return [ Size( _CCSs_GxO2 ) - Size( _CCSs_G ) + id, 0 ];

  end;
#---

#---
# basicDegree( p, q ) computes the basic degree of GxO(2)
#	assoicated to p-th irreducible representation of G
#	and q-th mode
#---
  basicDegree := function( p, q )

  local N,
	i,
	c,
	flag,
	bdeg,
	clist_idccs,
	chi_G,
	chi_DN,
	chi_GxDN,
	CCs_GxDN,
	CCSs_GxDN,
	term,
	ko,
	k,
	L_ko,
	L_k,
        n_ko,
	n_k;

  bdeg := [ ];
  chi_G := _irr_G[ AbsInt( p ) ];

  # basic degree associated to zero mode
  if ( q = 0 ) then
    # basic degree associated to zero mode +
    if ( p > 0 ) then
      for ko in Reversed( [ 1 .. Size( _CCSs_G ) ] ) do
        L_ko := Representative( _CCSs_G[ ko ] );
        n_ko := (-1)^DimensionOfFixedSet( chi_G, L_ko );
        for term in bdeg do
          k := term[ 1 ];
          n_k := term[ 2 ];
          L_k := Representative( _CCSs_G[ k ] );
          n_ko := n_ko - nLHnumber( _G, L_k, L_ko ) * n_k;
        od;
        if not ( n_ko = 0 ) then
          Add( bdeg, [ ko, n_ko ] );
        fi;
      od;
      bdeg := List( bdeg, t -> [ idEmbed_G_GxO2( t[ 1 ] ), t[ 2 ] ] );

    # basic degree associated to zero mode -
    elif ( p < 0 ) then
      setupDN( 1, true );
      for chi_GxDN in _irr_GxDN do
        if ( List( _CCs_G, c -> chi_GxDN[ idCC( _CCs_GxDN, Image( _Embed_from_G, Representative( c ) ) ) ] ) = List( chi_G ) ) and ( List( Image( _Embed_from_DN ), e -> chi_GxDN[ idCC( _CCs_GxDN, e ) ] ) = [ 1, -1 ] * DegreeOfCharacter( chi_G ) ) then
          break;
        fi;
      od;
      for L_ko in Reversed( List( _CCSs_GxDN, Representative ) ) do
        n_ko := (-1)^DimensionOfFixedSet( chi_GxDN, L_ko );
        for term in bdeg do
          L_k := term[ 1 ];
          n_k := term[ 2 ];
          n_ko := n_ko - nLHnumber( _GxDN, L_k, L_ko ) * n_k;
        od;
        if not ( n_ko = 0 ) then
          Add( bdeg, [ L_ko, n_ko ] );
        fi;
      od;
      bdeg := List( bdeg, t -> [ idCCSGxDN( t[ 1 ] ), t[ 2 ] ] );
    fi;

  # basic degree associated to nonzero mode
  else
    clist_idccs := PositionsProperty( _CCSs_GxO2, c -> not IsInfinity( c[ 8 ] ) and not ( c[ 4 ] in [ 3, 4 ] ) );
    Add( clist_idccs, Size( _CCSs_GxO2 ) );
    N := 2 * Lcm( _CCSs_GxO2{ clist_idccs }[ 3 ][ 2 ] );
    setupDN( N, true );
    for chi_GxDN in _irr_GxDN do
      if ( List( _CCs_G, c -> chi_GxDN[ idCC( _CCs_GxDN, Image( _Embed_from_G, Representative( c ) ) ) ] ) = 2 * List( chi_G ) ) and ( List( GeneratorsOfGroup( _DN ) , e -> chi_GxDN[ idCC( _CCs_GxDN, Image( _Embed_from_DN, e ) ) ] ) = [ 0, E( N )+E( N )^( N-1 ) ] * DegreeOfCharacter( chi_G ) ) then
        break;
      fi;
    od;
    for L_ko in Reversed( List( _CCSs_GxDN , Representative ) ) do
      if not ( ( L_ko = _GxDN ) or ( idSubgroupO2( Image( _Proj_to_DN, Intersection( L_ko, Image( _Embed_from_DN ) ) ) )[2] in [ 0, 1 ] ) ) then
        continue;
      fi;
      ko := idCCSGxDN( L_ko );
      if ko = fail or not ( ko[1] in clist_idccs ) then
        continue;
      fi;
      n_ko := ( -1 )^DimensionOfFixedSet( chi_GxDN, L_ko );
      for term in bdeg do
        L_k := term[ 1 ];
        n_k := term[ 2 ];
        n_ko := n_ko - nLHnumber( _GxDN, L_k, L_ko ) * n_k;
      od;
      if not ( n_ko = 0 ) then
        Add( bdeg, [ L_ko, n_ko ] );
      fi;
    od;
    bdeg := List( bdeg, t -> [ idCCSGxDN( t[ 1 ] ), t[ 2 ] ] );
    bdeg := List( bdeg, t -> [ [ t[ 1 ][ 1 ], t[ 1 ][ 2 ] * q ], t[ 2 ] ] );
  fi;

  bdeg := List( bdeg, t -> [ t[ 1 ], t[ 2 ]/_CCSs_GxO2[ t[ 1 ][ 1 ] ][ 8 ] ] );
  return bdeg;

  end;
#---

