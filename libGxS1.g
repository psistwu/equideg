#-------
# GxS1 GAP Library
#-------
# This library provides functions for determine
# the conjugacy classes of subgroups(CCSs)
# in GxS1 where G is a finite group.
# Also it can perform the addition and
# multiplication of the Euler ring induced by
# GxS1.
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

  # name list of CCSs in S1
  DeclareGlobalVariable( "_Name_CCSs_S1" );
  MakeReadWriteGlobal( "_Name_CCSs_S1" );
  _Name_CCSs_S1 := [ "Z_", "S1" ];
  MakeReadOnlyGlobal( "_Name_CCSs_S1" );

  # the CCSs in GxS1
  DeclareGlobalVariable( "_CCSs_GxS1" );

  # the history of ZN
  DeclareGlobalVariable( "_ZN_History" );
  MakeReadWriteGlobal( "_ZN_History" );
  _ZN_History := [ ];
  MakeReadOnlyGlobal( "_ZN_History" );

  # the dihedral group ZN
  DeclareGlobalVariable( "_ZN" );

  # the list of irreducible ZN-representations
  DeclareGlobalVariable( "_irr_ZN" );

  # GxZN where the subgroup in GxO(2) will be embedded
  DeclareGlobalVariable( "_GxZN" );

  # CCSs of GxZN
  DeclareGlobalVariable( "_CCSs_GxZN" );

  # CCs of GxZN
  DeclareGlobalVariable( "_CCs_GxZN" );

  # the list of irreducible GxZN-representations
  DeclareGlobalVariable( "_irr_GxZN" );

  # the projection map from GxZN to G
  DeclareGlobalVariable( "_Proj_to_G" );

  # the projection map from GxZN to ZN
  DeclareGlobalVariable( "_Proj_to_ZN" );

  # the embedding map from G to GxZN (the other component would be identity)
  DeclareGlobalVariable( "_Embed_from_G" );

  # the embedding map from ZN to GxZN (the other component would be identity)
  DeclareGlobalVariable( "_Embed_from_ZN" );
#---


#-----
# part 1: setup
#-----

#---
# setupG( G ) assigns a finite group to _G,
#---
  setupG := function( G )

  # msglevel: notice
  Print( "G = ", G, "\n" );
  Print( "Setting up G... " );

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
  MakeReadWriteGlobal( "_ZN_History" );

  # assign values
  _G := G;
  _irr_G := Irr( _G );
  _CCs_G := ConjugacyClasses( _G );
  _CCSs_G := ConjugacyClassesSubgroups( _G );
  _Name_CCSs_G := [ 1 .. Size( _CCSs_G ) ];
  _ZN_History := [ ];

  # lock global variables
  MakeReadOnlyGlobal( "_G" );
  MakeReadOnlyGlobal( "_irr_G" );
  MakeReadOnlyGlobal( "_CCs_G" );
  MakeReadOnlyGlobal( "_CCSs_G" );
  MakeReadOnlyGlobal( "_Name_CCSs_G" );
  MakeReadOnlyGlobal( "_ZN_History" );

  # msglevel: notice
  Print( "Done!\n\n" );
  
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
# setupZN( N ) assigns a cyclic group to global variable _ZN;
#	GxZN to global variables _GxZN; also, it sets up the
#	projections and embeddings of the direct product.
#---
  setupZN := function( N, detail )

  # local variable
  local ZN;

  # msglevel: verbose
  Print( "Setting up Z_", N, "... " );

  # check if the global variable _G is already bound
  # msglevel: error
  if not IsGroup( _G ) then
    Error( "Global variable \"_G\" is not yet assigned!" );
  fi;

  # unlock global variables
  MakeReadWriteGlobal( "_ZN_History" );
  MakeReadWriteGlobal( "_ZN" );
  MakeReadWriteGlobal( "_irr_ZN" );
  MakeReadWriteGlobal( "_GxZN" );
  MakeReadWriteGlobal( "_irr_GxZN" );
  MakeReadWriteGlobal( "_Proj_to_G" );
  MakeReadWriteGlobal( "_Proj_to_ZN" );
  MakeReadWriteGlobal( "_Embed_from_G" );
  MakeReadWriteGlobal( "_Embed_from_ZN" );

  if not IsBound( _ZN_History[ N ] ) then
    ZN := pCyclicGroup( N );
    _ZN_History[ N ] := rec( );
    _ZN_History[ N ].ZN := ZN;
    _ZN_History[ N ].GxZN := DirectProduct( _G, ZN );
  fi;

  # assign values
  _ZN := _ZN_History[ N ].ZN;
  _irr_ZN := Irr( _ZN );
  _GxZN := _ZN_History[ N ].GxZN;
  _irr_GxZN := Irr( _GxZN );
  _Proj_to_G := Projection( _GxZN, 1 );
  _Proj_to_ZN := Projection( _GxZN, 2 );
  _Embed_from_G := Embedding( _GxZN, 1 );
  _Embed_from_ZN := Embedding( _GxZN, 2 );

  if ( detail = true ) then
    MakeReadWriteGlobal( "_CCs_GxZN" );
    MakeReadWriteGlobal( "_CCSs_GxZN" );
    _CCs_GxZN := ConjugacyClasses( _GxZN );
    _CCSs_GxZN := ConjugacyClassesSubgroups( _GxZN );
    MakeReadOnlyGlobal( "_CCs_GxZN" );
    MakeReadOnlyGlobal( "_CCSs_GxZN" );
  fi;

  # lock global variables
  MakeReadOnlyGlobal( "_ZN_History" );
  MakeReadOnlyGlobal( "_ZN" );
  MakeReadOnlyGlobal( "_irr_ZN" );
  MakeReadOnlyGlobal( "_GxZN" );
  MakeReadOnlyGlobal( "_irr_GxZN" );
  MakeReadOnlyGlobal( "_Proj_to_G" );
  MakeReadOnlyGlobal( "_Proj_to_ZN" );
  MakeReadOnlyGlobal( "_Embed_from_G" );
  MakeReadOnlyGlobal( "_Embed_from_ZN" );

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
# factorGroupS1( id ) generates factor group in S1
#---
  factorGroupS1 := function( id )

  if IsPosInt( id ) then
    # return Z_n
    return pCyclicGroup( id );

  else
    # unknown type
    Error( "Invalid ID for factor groups." );
  fi;

  end;
#---

#---
# idFactorGroupS1( L ) determines id of L
#---
  idFactorGroupS1 := function( L )

  # determine type of L
  return Order( L );

  end;
#---

#---
# isConjugateEpimorphismsGxS1( phi1, phi2 ) determines whether two
#	epimorphisms phi1 and phi2 are conjugate to each other in GxS1.
#---
  isConjugateEpimorphismsGxS1 := function( phi1, phi2 )

  # define local variables
  local H,		# a subgroup in G
	L,		# a factor group in S1
	id_L,		# id of L
	NH,		# normalizer of H
	elmt_NH,	# element in the normalizer
	conj_phi1,	# twisted phi1 in its domain
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

  # case 2: L = Z_2
  if ( Order( L ) = 2 ) then
    # they are conjugate if their kernels are conjugate
    if IsConjugate( NH, Kernel( phi1 ), Kernel( phi2 ) ) then
      return true;
    fi;
  fi;

  # case 3: L = Z_n, n>2
  for elmt_NH in AsList( NH ) do
    # twist phi1 in its domain
    conj_phi1 := GroupHomomorphismByFunction( H, H, s -> s^elmt_NH, s -> s^( elmt_NH^-1 ) ) * phi1;
 
      # phi1 and phi2 are conjugate if phi2 is equal to twisted phi1
    if ( conj_phi1 = phi2 ) then
      return true;
    fi;
  od;

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
      if isConjugateEpimorphismsGxS1( epi, epi_list[ i ] ) then
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
# conjugacyClassesSubgroupsGxS1() finds all the CCSs in GxS1
#	and store the list in the global variable _CCSs_GxS1.
#---
  conjugacyClassesSubgroupsGxS1 := function( )
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
  #	For 4 and 5, note that we can (closed) subgroups in S1 are
  #	described in the following list.
  #
  #		0: S1
  #		n: Z_n
  #
  #	To specify a certain CCS in GxS1, we use a pair	of numbers:
  #
  #		idccs := [ type, mode ]

  # define local variables
  local ccs,		# a CCS in GxS1
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
    Error( "Sorry <User Name Here>, I cannot let you do this." );
    Error( "Please consider to run setupG first." );
  fi;

  # msglevel: notice
  Print( "Finding all CCSs in GxS1... " );

  # msglevel: verbose
  Print( "\n\n" );

  # initialize CCSs in GxS1
  MakeReadWriteGlobal( "_CCSs_GxS1" );
  _CCSs_GxS1 := [ ];
  ccs := [ ];

  # find CCSs in GxS1 by shuffling H
  for i in [ 1 .. Size( _CCSs_G ) ] do
    # take a representative from a CCS in G
    H := Representative( _CCSs_G[ i ] );
    order_WH := IndexNC( Normalizer( _G, H ), H );

    # msglevel: verbose
    Print( "Finding CCSs in GxS1 related to ", i );
    Print( "-th CCS in G (order ", Order( H ), ") ...\n" );

    # record ID of the CCS in Gamma
    ccs[ 1 ] := i;

    for j in [ 1 .. Order( H ) ] do
      # skip the case that j doesn't divide order_H
      if not ( ( Order( H ) mod j ) = 0 ) then
        continue;
      fi;

      # msglevel: verbose
      Print( "\tTrying L = Z_", j, " ...\n" );

      # Take L as a cyclic group
      id_L := j;
      L := factorGroupS1( id_L );

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
          ccs[ 8 ] := [ 1, order_WH / nccphi ];
          Add( _CCSs_GxS1, ShallowCopy( ccs ) );

          # In addition, if L = Z_1
          if ( j = 1 ) then
            # S1/S1
            ccs[ 4 ] := 0;
            ccs[ 5 ] := 0;
            ccs[ 8 ] := [ 0, order_WH ];
            Add( _CCSs_GxS1, ShallowCopy( ccs ) );
          fi;
        od;
      fi;
    od;

    # msglevel: verbose
    Print( "\n" );

  od;

  # drop phi^{-1}(r) if there is no need to keep this info
  for i in [ 1 .. Size( _CCSs_GxS1 ) ] do
    ccs := _CCSs_GxS1[ i ];
    if ( i > 1 ) then
      ccs_alt := _CCSs_GxS1[ i - 1 ];
      if ( ccs{ [ 1 .. 5 ] } = ccs_alt{ [ 1 .. 5 ] } ) then
        continue;
      fi;
    fi;

    if i < Size( _CCSs_GxS1 ) then
      ccs_alt := _CCSs_GxS1[ i + 1 ];
      if ( ccs{ [ 1 .. 5 ] } = ccs_alt{ [ 1 .. 5 ] } ) then
        continue;
      fi;
    fi;
    ccs[ 7 ] := 0;
  od;

  # Sorting CCSs list
  # msglevel: verbose
  if ( ValueOption( "msglevel" ) > 2 ) then
    Print( "Sorting the List of CCSs in GxS1...\n\n" );
  fi;
  SortBy( _CCSs_GxS1, v -> [ v[ 4 ],		# first by id of K
  			     v[ 5 ],		# second by id of ker_psi
			     v[ 3 ],		# thrid by mode of L
			     v[ 1 ],		# fourth by type of H
			     v[ 2 ],		# fifth by ker_phi
			     v[ 7 ] ] );	# sixth by pre_r
  
  # lock the global varaible _CCSs_GxS1
  MakeReadOnlyGlobal( "_CCSs_GxS1" );

  # msglevel: notice
  Print( "Done!\n\n" );

  end;
#---


#-----
# part 3: burnside ring
#-----

#---
# idSubgroupS1( K ) determine ID of K < ZN in O(2).
#---
  idSubgroupS1 := function( K );

  if not IsSubgroup( _ZN, K ) then
    Error( "K is not a subgroup of D_", Order( _ZN ) / 2 );
  elif ( K = _ZN ) then
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
# embedIntoZN( id_K ) embeds K < S1 corresponds to the given id into ZN
#---
  embedIntoZN := function( id_K )

  # define local variable
  local K;	# a subgroup in ZN

  if ( id_K[ 1 ] = 1 ) and ( Order( _ZN ) > id_K[ 2 ] ) and ( Order( _ZN ) mod id_K[ 2 ] = 0 ) then
    K := SubgroupNC( _ZN, [ Identity( _ZN ), _ZN.1^( Order( _ZN ) / id_K[ 2 ] ) ] );
  elif ( id_K[ 1 ] = 2 ) and ( Order( _ZN ) > id_K[ 2 ] ) and ( Order( _ZN ) mod id_K[ 2 ] = 0 ) then
    K := SubgroupNC( _ZN, [ _ZN.1, _ZN.2^( Order( _ZN ) / id_K[ 2 ] ) ] );
  elif ( id_K[ 1 ] = 3 ) then
    K := _ZN;
  elif ( id_K[ 1 ] = 4 ) then
    K := _ZN;
  else
    Error( "The input ID cannot be embedded into D_", Order( _ZN ) );
  fi;

  return K;

  end;
#---

#---
# embedIntoGxZN( idccs ) embeds a representative of a
#	CCS in GxO(2) into GxZN.
#---
  embedIntoGxZN := function( idccs )

  # define local variables
  local ccs_GxS1,	# the CCS of G x S1 corresponds to the given id
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
	S,		# the embedding in G x ZN
	gen_S;		# generators of S

  # check if _ZN and _GxZN are already assigned
  # msglevel: error
  if not IsBound( _ZN ) then
    Error( "Please run setupZN first." );
  fi;

  # get the CCS
  ccs_GxS1 := _CCSs_GxS1[ idccs[ 1 ] ];

  # extract properties of the CCS
  phi := ccs_GxS1[ 6 ][ 1 ];
  H := PreImage( phi );
  id_L := ccs_GxS1[ 3 ];
  L := factorGroupS1( id_L );
  id_ker_psi := [ ccs_GxS1[ 5 ], idccs[ 2 ] ];
  id_K := [ ccs_GxS1[ 4 ], id_ker_psi[ 2 ]*id_L[ 2 ] ];
  K := embedIntoZN( id_K );

  # msglevel: verbose
  if ( ValueOption( "msglevel" ) > 2 ) then
    Print( "Embedding representative of CCS(ID = ", idccs, ") " );
    Print( "in GxS1 into GxD_", Order( _ZN ) / 2, "... " );
  fi;

  # define psi
  psi := GroupHomomorphismByImagesNC( K, L, GeneratorsOfGroup( K ), GeneratorsOfGroup( L ) );

  # find the generators of S
  gen_S := [ ];
  Append( gen_S, Image( _Embed_from_ZN, GeneratorsOfGroup( Kernel( psi ) ) ) );
  for h in GeneratorsOfGroup( H ) do
    k := PreImage( psi, Image( phi, [ h ] ) )[ 1 ];
    Add( gen_S, Image( _Embed_from_G, h ) * Image( _Embed_from_ZN, k ) );
  od;
  S := SubgroupNC( _GxZN, gen_S );

  # msglevel: verbose
  if ( ValueOption( "msglevel" ) > 2 ) then
    Print( "Done!\n\n" );
  fi;

  return S;

  end;
#---

#---
# idCCSGxZN( S ) finds the id of CCS in GxO(2) to whom S belongs, where
#	S is a subgroup in GxZN.
#---
  idCCSGxZN := function( S )

  # define local variable
  local idccs,			# ID of CCS in G x O(2)
	ccs_GxS1,		# a CCS in G x O(2)
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
  K := Image( _Proj_to_ZN, S );
  ker_psi := Image( _Proj_to_ZN, Intersection( S, Image( _Embed_from_ZN ) ) );
  id_K := idSubgroupS1( K );
  id_ker_psi := idSubgroupS1( ker_psi );

  # find ID of L
  if ( id_K[ 2 ] > 0 ) and ( id_ker_psi[ 2 ] > 0 ) then
    id_L := [ id_K[ 1 ]/id_ker_psi[ 1 ], id_K[ 2 ]/id_ker_psi[ 2 ] ];
  elif ( id_K[ 2 ] = 0 ) and ( id_ker_psi[ 2 ] = 0 ) then
    id_L := [ ( id_K[ 1 ] - 2 )/( id_ker_psi[ 1 ] - 2 ), 1 ];
  else
    return fail;
  fi;
  
  # test which CCS in G x O(2) S belongs to
  for i in [ 1 .. Size( _CCSs_GxS1 ) ] do
    ccs_GxS1 := _CCSs_GxS1[ i ];

    if ( ccs_GxS1[ 4 ] = id_K[ 1 ] ) and	# match type of K
       ( ccs_GxS1[ 5 ] = id_ker_psi[ 1 ] ) and	# match type of ker(psi)
       ( id_L = ccs_GxS1[ 3 ] ) and		# match order of L
       ( H in _CCSs_G[ ccs_GxS1[ 1 ] ] ) then	# match H

      # set up the candidate idccs, embed and compare
      idccs := [ i, id_ker_psi[ 2 ] ];
      if IsConjugate( _GxZN, embedIntoGxZN( idccs ), S ) then

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
  SortBy( b, v -> [-v[ 1 ][ 2 ],	# first by the mode of CCS
		   -v[ 1 ][ 1 ] ] );	# then by the IDCCS 

  end;
#---

#---
#burnsideGenMulGxS1( idccs1, idccs2 ) multiplies two generators of Burnside
#	ring induced by G x O(2)
#---
  burnsideGenMulGxS1 := function( idccs1, idccs2 )

  # define local variable
  local ccs1, ccs2,		# CCSs in G x S1
	mul_GxS1,		# multiplication list in G x O(2)
	mul_tmp,		# temporary multiplication list
	id_L1, id_L2,		# IDs of L1 and L2
	id_K1, id_K2,		# IDs of K1 and K2
	N,			# folding number of the ZN
	S1, S2,			# embedding of ccs1 and ccs2 in G x ZN
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
  mul_GxS1 := [ ];
  mul_tmp := [ ];

  # get CCSs
  ccs1 := _CCSs_GxS1[ idccs1[ 1 ] ];
  ccs2 := _CCSs_GxS1[ idccs2[ 1 ] ];

  if ( ccs1[ 8 ] = infinity ) or ( ccs2[ 8 ] = infinity ) then
    return mul_GxS1;
  fi;

  # extract IDs of L1 and L2
  id_L1 := ccs1[ 3 ];
  id_L2 := ccs2[ 3 ];

  # extract IDs of K1 and K2
  id_K1 := [ ccs1[ 4 ], idccs1[ 2 ]*id_L1[ 2 ] ];
  id_K2 := [ ccs2[ 4 ], idccs2[ 2 ]*id_L2[ 2 ] ];

  # determine into which ZN the two CCSs should be embedded
  N := Lcm( Maximum( 2*id_K1[ 2 ], 1 ), Maximum( 2*id_K2[ 2 ], 1 ) );
  setupZN( N, false );
  
  # embed both orbit types
  S1 := embedIntoGxZN( idccs1 );
  S2 := embedIntoGxZN( idccs2 );

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
  ccS2 := ConjugacyClassSubgroups( _GxZN, S2 );
  for cS2 in ccS2 do
    SS := Intersection( S1, cS2 );
    for ccs_SS in ConjugacyClassesSubgroups( SS ) do
      Add( coll_subgs_SS, Representative( ccs_SS ) );
    od;
  od;

  # remove all but one conjugate subgroups in coll_subgs_SS
  removeExtraConjugateCopy( _GxZN, coll_subgs_SS );

  # from large CCS to small one, use the recursive formula
  # for finding the multiplication list
  for S3 in Reversed( coll_subgs_SS ) do
    # find its ID in CCSs of GxO(2)
    idccs3 := idCCSGxZN( S3 );
    if ( idccs3 = fail ) then
      continue;
    fi;

    # exclude the case that W(S3) is infinite
    ccs3 := _CCSs_GxS1[ idccs3[ 1 ] ];
    if ( ccs3[ 8 ] = infinity ) then
      continue;
    fi;

    # compute n(L,H)
    n_S3_S1 := nLHnumber( _GxZN, S1, S3 );
    # compute n(L,K)
    n_S3_S2 := nLHnumber( _GxZN, S2, S3 );

    # find the coefficient with respect to S3
    coeff_S3 := n_S3_S1*ccs1[ 8 ]*n_S3_S2*ccs2[ 8 ];

    # recursive formula
    for term in mul_tmp do
      S4 := term[ 1 ];
      coeff_S4 := term[ 2 ];
      order_W4 := term[ 3 ];

      # compute n(L,L')
      n_S3_S4 := nLHnumber( _GxZN, S4, S3 );
      coeff_S3 := coeff_S3 - n_S3_S4*coeff_S4*order_W4;
    od;

    # adding a new term to multiplication list
    if not ( coeff_S3 = 0 ) then
      order_W3 := ccs3[ 8 ];
      coeff_S3 := coeff_S3/order_W3;
      Add( mul_tmp, [ S3, coeff_S3, order_W3 ] );
      Add( mul_GxS1, [ idccs3, coeff_S3 ] );
    fi;

  od;

  # normalize the result
  burnsideSimplify( mul_GxS1 );
  return mul_GxS1;

  end;
#---

#---
# burnsideAddGxS1( b1, b2 ) add two elements b1, b2 in the Burnside ring
#	induced by GxO(2)
#---
  burnsideAddGxS1 := function( b1, b2 )

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
# burnsideScalarMulGxS1( b, z ) multiplies an element b by an integer z
#	in the Burnside ring induced by GxO(2)
#---
  burnsideScalarMulGxS1 := function( b, z )

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
#burnsideSubGxS1( b1, b2 ) subtract two elements b1, b2 in the Burnside ring
#	induced by G x O(2)
#---
  burnsideSubGxS1 := function( b1, b2 )

  # define local variable
  local sub;		# subtraction of b1 and b2

  # join b1 and b2
  sub := Concatenation( StructuralCopy( b1 ), burnsideScalarMulGxS1( b2,-1 ) );

  # sort the list according to the size of the subgroups in the CCS
  burnsideSimplify( sub );
  return sub;

  end;
#---

#---
# burnsideMulGxS1( b1, b2 ) multiplies two elements b1, b2 in the Burnside Ring
#	induced by GxO(2)
#---
  burnsideMulGxS1 := function( b1, b2 )

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
      gen_mul := burnsideGenMulGxS1( term_b1[ 1 ], term_b2[ 1 ] );
      gen_mul := burnsideScalarMulGxS1( gen_mul, term_b1[ 2 ]*term_b2[ 2 ] );
      Append( mul, gen_mul );
    od;
  od;

  # sort the list according to the size of the subgroups in the CCS
  burnsideSimplify( mul );
  return mul;

  end;
#---

#---
# foldingDegGxS1( folding_number, deg ) applies folding on the given deg
#---
  foldingDegGxS1 := function( folding_number, deg )

  # local variable
  local term,
	fdeg;

  fdeg := [ ];
  for term in deg do
    Add( fdeg, [ foldingCCSGxS1( folding_number, term[ 1 ] ), term[ 2 ] ] );
  od;
  burnsideSimplify( fdeg );
  return fdeg;

  end;
#---


#-----
# part 4: format output
#-----

#---
# id2nameCCSGxS1( idccs ) convert an ID of CCS to
#	a comprehensive name in GxO(2)
#---
  id2nameCCSGxS1 := function( idccs )

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
    ccs := _CCSs_GxS1[ idccs ];
  elif IsList( idccs ) then
    ccs := _CCSs_GxS1[ idccs[ 1 ] ];
  else
    Error( "Unrecognizable ID of CCS in G x O(2)." );
  fi;

  # extract phi^{-1}(r)
  pre_r := ccs[ 7 ];

  # determine name of H and ker(phi)
  name_H := _Name_CCSs_G[ ccs[ 1 ] ];
  name_ker_phi := _Name_CCSs_G[ ccs[ 2 ] ];

  # determine name of L
  if IsPosInt( ccs[ 3 ] ) then
    name_L := "Z_";
    Append( name_L, String( ccs[ 3 ] ) );
  else
    Error( "Unknown ID for L" );
  fi;

  # append the mode number when K = Z_n or D_n
  if ( ccs[ 4 ] = 0 ) then
    name_K := "S1";
    name_ker_psi := "S1";
  elif IsPosInt( ccs[ 4 ] ) then
    name_K := "Z_";
    name_ker_psi := "Z_";
    # case 1: mode is not specified
    if IsPosInt( idccs ) then
      Append( name_ker_psi, "n" );
      if ( ccs[ 3 ] > 1 ) then
        Append( name_K, String( ccs[ 3 ] ) );
      fi;
      Append( name_K, "n" );

    # case 2: mode is specified
    elif IsList( idccs ) then
      Append( name_ker_psi, String( idccs ) );
      Append( name_K, String( ccs[ 3 ] * idccs[ 2 ] ) );
    fi;
  fi;

  return [ name_H, name_ker_phi, name_L, name_K, name_ker_psi, pre_r ];

  end;
#---

#---
# printCCSsGxS1( ) lists all the CCSs in G x O(2) in a comprehensive format.
#---
  printCCSsGxS1 := function( )

  # define local variable
  local i,		# index
	ccs,		# CCS in G x O(2)
	ccsname,	# name of the CCS
	filename,	# output text file name
	pbrno,		# line break number
	output;		# output stream


  if IsEmpty( _CCSs_GxS1 ) then
    Error( "Please run conjugacyClassesSubgroupsGxS1( ) first." );
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
  for i in [ 1 .. Size( _CCSs_GxS1 ) ] do
    ccsname := id2nameCCSGxS1( i );
    ccs := _CCSs_GxS1[ i ];

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
    Print( term[ 2 ], "\t", id2nameCCSGxS1( term[ 1 ] ), "\n" );
  od;

  end;
#---

#---
# streamCCSsGxS1( ) lists all the CCSs in G times O(2)
#	in a format for streaming.
#---
  streamCCSsGxS1 := function( )

  # define local variable
  local i,		# index
	ccs,		# CCS in G times O(2)
	L,		# the quotient group
	pre_r,		# phi^{-1}(<r>)
	CC_pre_r,	# conjugacy class of preimage of r
        order_w;	# order of Weyl group

  if IsEmpty( _CCSs_GxS1 ) then
    Error( "Please run conjugacyClassesSubgroupsGxS1 first." );
  fi;

  # print all CCSs in G x O(2), one CCS per line
  Print( "[ " );
  for i in [ 1 .. Size( _CCSs_GxS1 ) ] do
    ccs := _CCSs_GxS1[ i ];

    # find quotient group L
    L := factorGroupS1( ccs[ 3 ] );

    # When Wyel group is infinite, use 0 represent the case
    if ( ccs[ 8 ] = infinity ) then
      order_w := 0;
    else
      order_w := ccs[ 8 ];
    fi;

    # print the CCS
    Print( "[ ", ccs[ 1 ], ", ", ccs[ 2 ], ", ", ccs[ 3 ], ", ", ccs[ 4 ], ", ", ccs[ 5 ], ", ", ccs[ 7 ], ", ", order_w, " ]" );
    if not ( i = Size( _CCSs_GxS1 ) ) then
      Print( ",\n" );
    fi;
  od;
  Print( " ]" );

  end;
#---

#---
# idEmbed_G_GxS1 embed CCS in G to GxO(2) and
#	return the id of the image of embedding
#---
  idEmbed_G_GxS1 := function( id )

  return [ Size( _CCSs_GxS1 ) - Size( _CCSs_G ) + id, 0 ];

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
	chi_ZN,
	chi_GxZN,
	CCs_GxZN,
	CCSs_GxZN,
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
      bdeg := List( bdeg, t -> [ idEmbed_G_GxS1( t[ 1 ] ), t[ 2 ] ] );

    # basic degree associated to zero mode -
    elif ( p < 0 ) then
      setupZN( 1, true );
      for chi_GxZN in _irr_GxZN do
        if ( List( _CCs_G, c -> chi_GxZN[ idCC( _CCs_GxZN, Image( _Embed_from_G, Representative( c ) ) ) ] ) = List( chi_G ) ) and ( List( Image( _Embed_from_ZN ), e -> chi_GxZN[ idCC( _CCs_GxZN, e ) ] ) = [ 1, -1 ] * DegreeOfCharacter( chi_G ) ) then
          break;
        fi;
      od;
      for L_ko in Reversed( List( _CCSs_GxZN, Representative ) ) do
        n_ko := (-1)^DimensionOfFixedSet( chi_GxZN, L_ko );
        for term in bdeg do
          L_k := term[ 1 ];
          n_k := term[ 2 ];
          n_ko := n_ko - nLHnumber( _GxZN, L_k, L_ko ) * n_k;
        od;
        if not ( n_ko = 0 ) then
          Add( bdeg, [ L_ko, n_ko ] );
        fi;
      od;
      bdeg := List( bdeg, t -> [ idCCSGxZN( t[ 1 ] ), t[ 2 ] ] );
    fi;

  # basic degree associated to nonzero mode
  else
    # collect all possible orbit types in the basic degree
    clist_idccs := PositionsProperty( _CCSs_GxS1, c -> not IsInfinity( c[ 8 ] ) and not ( c[ 4 ] in [ 3, 4 ] ) );
    Add( clist_idccs, Size( _CCSs_GxS1 ) );
    # setup ZN according to all possible orbit types
    N := 2 * Lcm( _CCSs_GxS1{ clist_idccs }[ 3 ][ 2 ] );
    setupZN( N, true );
    for chi_GxZN in _irr_GxZN do
      if ( List( _CCs_G, c -> chi_GxZN[ idCC( _CCs_GxZN, Image( _Embed_from_G, Representative( c ) ) ) ] ) = 2 * List( chi_G ) ) and ( List( GeneratorsOfGroup( _ZN ) , e -> chi_GxZN[ idCC( _CCs_GxZN, Image( _Embed_from_ZN, e ) ) ] ) = [ 0, E( N )+E( N )^( N-1 ) ] * DegreeOfCharacter( chi_G ) ) then
        break;
      fi;
    od;
    for L_ko in Reversed( List( _CCSs_GxZN , Representative ) ) do
      if not ( ( L_ko = _GxZN ) or ( idSubgroupS1( Image( _Proj_to_ZN, Intersection( L_ko, Image( _Embed_from_ZN ) ) ) )[2] in [ 0, 1 ] ) ) then
        continue;
      fi;
      ko := idCCSGxZN( L_ko );
      if ko = fail or not ( ko[1] in clist_idccs ) then
        continue;
      fi;
      n_ko := ( -1 )^DimensionOfFixedSet( chi_GxZN, L_ko );
      for term in bdeg do
        L_k := term[ 1 ];
        n_k := term[ 2 ];
        n_ko := n_ko - nLHnumber( _GxZN, L_k, L_ko ) * n_k;
      od;
      if not ( n_ko = 0 ) then
        Add( bdeg, [ L_ko, n_ko ] );
      fi;
    od;
    bdeg := List( bdeg, t -> [ idCCSGxZN( t[ 1 ] ), t[ 2 ] ] );
    bdeg := List( bdeg, t -> [ [ t[ 1 ][ 1 ], t[ 1 ][ 2 ] * q ], t[ 2 ] ] );
  fi;

  bdeg := List( bdeg, t -> [ t[ 1 ], t[ 2 ]/_CCSs_GxS1[ t[ 1 ][ 1 ] ][ 8 ] ] );
  burnsideSimplify( bdeg );
  return bdeg;

  end;
#---

#---
# maximalOrbittypesGxS1( orbt_list ) determines maximal orbit types in
#	the given list of orbit types
#---
  maximalOrbittypes := function( orbt_list )

  local maxorbt_list,
	i,
	j,
	orbti,
	orbtj,
	ccstypei,
	ccstypej,
	modei,
	modej,
	id_Li,
	id_Lj,
	Si,
	Sj,
	N;

  maxorbt_list := StructuralCopy( orbt_list );

  i := 1;
  while i < Size( maxorbt_list ) do
    orbti := maxorbt_list[ i ];
    ccstypei := _CCSs_GxS1[ orbti[ 1 ] ];
    modei := orbti[ 2 ];
    id_Li := ccstypei[ 3 ];

    j := i+1;
    while j <= Size( maxorbt_list ) do
      orbtj := maxorbt_list[ j ];
      ccstypej := _CCSs_GxS1[ orbtj[ 1 ] ];
      modej := orbtj[ 2 ];
      id_Lj := ccstypej[ 3 ];

      N := 2*Lcm( modei*id_Li[ 2 ], modej*id_Lj[ 2 ] );
      setupZN( N, false );

      Si := embedIntoGxZN( orbti );
      Sj := embedIntoGxZN( orbtj );

      if isSubgroupUptoConjugacy( _GxZN, Si, Sj ) then
        Remove( maxorbt_list, j );
        continue;
      elif isSubgroupUptoConjugacy( _GxZN, Sj, Si ) then
        Remove( maxorbt_list, i );
        i := i-1;
        break;
      fi;
      j := j+1;
    od;
    i := i+1;
  od;

  return maxorbt_list;

  end;
#---
