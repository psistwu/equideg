#############################################################################
##
#W  DirerctProduct2.gi	GAP Package `EquiDeg'			    Haopin Wu
##
#Y  Copyright (C) 2017-2019, Haopin Wu
#Y  Department of Mathematics, National Tsing Hua University, Taiwan
##
##  This file contains implementations for procedures related to
##  direct product of compact Lie groups (including finite groups).
##

##  Part 1: Direct Product of finite groups and compact Lie groups

#############################################################################
##
#O  DirectProductOp( <list>, <CLG> )
##
  InstallMethod( DirectProductOp,
    "Operation for direct product of ECLG and a finite group",
    [ IsList, IsCompactLieGroup ],
    function( list, CLG )
      local ones,	# list of identities
            fam,	# family of the direct product
            cat,	# category of the direct product
            rep,	# representation of the direct product
            D;		# the direct product

      # generate direct product of compact Lie groups
      ones := List( list, One );
      fam := CollectionsFamily( DirectProductElementsFamily(
          List( ones, FamilyObj ) ) );
      rep := IsComponentObjectRep and IsAttributeStoringRep;
      cat := IsCompactLieGroup;
      D := Objectify( NewType( fam, cat and rep ), rec( ) );

      # setup property(s) and attribute(s) of the product group
      SetDirectProductInfo( D, rec(
          groups := list,
          embeddings := [ ],
          projections := [ ]
      ) );
      SetOneImmutable( D, DirectProductElement( ones ) );
      SetString( D, StringFormatted(
        "DirectProduct( {} )",
        JoinStringsWithSeparator( list, ", " )
      ) );
      SetAbbrv( D, StringFormatted(
        "DirectProduct( {} )",
        JoinStringsWithSeparator( List( list, ViewString ), ", " )
      ) );
        

      return D;
    end
  );

#############################################################################
##
#A  ViewString( <G> )
##
# InstallMethod( ViewString,
#   "view string of compact Lie group with direct product info",
#   [ IsCompactLieGroup and HasDirectProductInfo ],
#   function( G )
#     local list;	# direct product components of <G>

#     list := DirectProductDecomposition( G );

#     return StringFormatted( "DirectProduct( {} )",
#         JoinStringsWithSeparator( List( list, ViewString ), ", " ) );
#   end
# );

#############################################################################
##
#A  DimensionOfCompactLieGroup( <G> )
##
  InstallImmediateMethod( DimensionOfCompactLieGroup,
    "",
    IsCompactLieGroup and HasDirectProductInfo,
    0,
    function( G )
      local list;	# direct product components of G

      list := Filtered( DirectProductDecomposition( G ), IsCompactLieGroup );

      return Sum( List( list, DimensionOfCompactLieGroup ) );
    end
  );

#############################################################################
##
#A  RankOfCompactLieGroup( <G> )
##
  InstallImmediateMethod( RankOfCompactLieGroup,
    "",
    IsCompactLieGroup and HasDirectProductInfo,
    0,
    function( G )
      local list;

      list := Filtered( DirectProductDecomposition( G ), IsCompactLieGroup );

      return Sum( List( list, RankOfCompactLieGroup ) );
    end
  );


##  CCS of Direct Product of Compact Lie Groups

# InstallMethod( NewCCS,
#   "CCS constructor of DPwCLG",
#   [ IsDirectProductWithECLGCCSsRep, IsRecord, IsInt ],
#   function( filter, ccs_class, mode )
#     local fam_ccs,            # family of CCS
#           cat_ccs,            # category of CCS
#           rep_ccs,            # representation of CCS
#           ccs,                # the CCS
#           dpinfo,             # direct product info
#           eclg,               # the ECLG component of the group
#           ccss_eclg,          # CCS list of the ECLG component
#           subg,               # a representative of CCS
#           phi,                # an epimorphism from H to L
#           psi,                # an epimorphism from K to L
#           cH, cK,             # conjugacy classes of subgroups
#           H, ZH, K, ZK, L,    # five essential subgroups related to subg
#           idK,                # id of K
#           gens_K,             # generotors of K
#           gens_L,             # generators of L
#           gens_subg,          # generators of subg
#           eL, eH, eK;         # elements in L, H and K

#     # test consistency between ccs_class and mode
#     if ( mode < 0 ) or ( ccs_class.is_zero_mode <> ( mode = 0 ) ) then
#       Error( "Illegel mode for the selected CCS class." );
#     fi;

#     # extract the direct product info
#     dpinfo := DirectProductInfo( ccs_class.group );

#     # it works only when the ECLG component is SO(2) or O(2)
#     if not ( IdECLG( dpinfo.eclg ) in [ [ 1, 1 ], [ 2, 1 ] ] ) then
#       TryNextMethod( );
#     fi;

#     # objectify the CCS
#     fam_ccs := CollectionsFamily( FamilyObj( ccs_class.group ) );
#     cat_ccs := CategoryCollections( IsGroup );
#     rep_ccs := IsDirectProductWithECLGCCSRep;
#     ccs := Objectify( NewType( fam_ccs, cat_ccs and rep_ccs ), rec( ) );

#     # extract ccss_eclg, cH, cK, H, ZH, L and K
#     ccss_eclg := ConjugacyClassesSubgroups( dpinfo.eclg );
#     cH := ccs_class.cH;
#     phi := Representative( ccs_class.phi_list );
#     H := Source( phi );
#     ZH := Kernel( phi );
#     L := Range( phi );
#     idK := [ ccs_class.idK[ 1 ], ccs_class.idK[ 2 ]*mode ];
#     cK := CCSId( ccss_eclg )( idK );
#     K := Representative( cK );

#     # generate the representative of CCS
#     # for CCS of zero mode
#     if ccs_class.is_zero_mode then
#       if ( Size( L ) = 1 ) then
#         subg := DirectProduct( K, H );
#         psi := GroupHomomorphismByFunction( K, L, elmt -> One( L ), false, elmt -> One( K ) );
#         SetKernelOfMultiplicativeGeneralMapping( psi, K );
#       else
#         subg := Objectify( NewType( FamilyObj( ccs_class.group ), IsGroup ), rec( ) );
#         psi := GroupHomomorphismByFunction( K, L, elmt -> L.2^( ( 1-DeterminantMat( elmt ) )/2 ), false, elmt -> DiagonalMat( [ 1, (-1)^( Order( elmt )-1 ) ] ) );
#         SetKernelOfMultiplicativeGeneralMapping( psi, Representative( CCSId( ccss_eclg )( [ 1, 0 ] ) ) );
#       fi;
#     # for CCS of non-zero mode
#     else
#       # setup homomorphism from K to L
#       gens_L := GeneratorsOfGroup( L );
#       gens_K := GeneratorsOfGroup( K );
#       if ( Size( gens_K ) > Size( gens_L ) ) then
#         psi := GroupHomomorphismByImages( K, L, [ L.1, One( L ) ] );
#       elif ( Size( gens_K ) = Size( gens_L ) ) then
#         psi := GroupHomomorphismByImages( K, L );
#       fi;

#       if ( Size( L ) = 1 ) then
#         subg := DirectProduct( K, H );
#       else
#         # extract ZK
#         ZK := Kernel( psi );

#         # generate a representative of the CCS
#         gens_subg := ShallowCopy( GeneratorsOfGroup( DirectProduct( ZK, ZH ) ) );
#         for eL in gens_L do
#           eH := Representative( PreImages( phi, eL ) );
#           eK := Representative( PreImages( psi, eL ) );
#           Add( gens_subg, DirectProductElement( [ eK, eH ] ) );
#         od;
#         subg := Group( gens_subg );
#       fi;
#     fi;

#     SetParentAttr( subg, ccs_class.group );
#     SetOrderOfWeylGroup( subg, ccs_class.order_of_weyl_group );
#     SetIsZeroModeCCS( ccs, ccs_class.is_zero_mode );
#     SetRepresentative( ccs, subg );
#     SetActingDomain( ccs, ccs_class.group );
#     SetOrderOfWeylGroup( ccs, ccs_class.order_of_weyl_group );
#     SetGoursatInfo( ccs, rec( cH := cH,
#         cK := cK,
#         phi_list := ccs_class.phi_list,
#         psi := psi,
#         idL := ccs_class.idL,
#     ) );

#     return ccs;
#   end
# );

#############################################################################
##
#A  ConjugacyClassesSubgroups( <G> )
##
  InstallMethod( ConjugacyClassesSubgroups,
    "return CCS list of O2xGamma",
    [ IsCompactLieGroup and HasDirectProductInfo ],
    function( G )
      local decomp,		# direct product decomposition of <G>
            Ga,			# finite group
            O2,			# O(2)
            CCSs_Ga,		# CCS list of gamma
            CCSs_O2,		# CCS list of O(2)
            
            # The following local variables are related to ccs_classes
            data,
            epis,
            epi2_classes,
            epi2_list,
            epi2,
            epi1_list,
            epi1,
            C1,
            C2,
            H1,
            H2,
            Z2,
            CZ2,
            name_H2,
            name_Z2,
            L,
            NH2,
            NL,
            NLxNH2,
            actfunc,
            x,
            k,
            j,
            LL,
            L_to_LL,
            LL_to_L;
            
      # test if <G> is a direct product of two groups
      decomp := DirectProductDecomposition( G );
      if not ( Length( decomp ) = 2 ) then
        TryNextMethod( );
      fi;

      # test if the first component is O(2)
      O2 := decomp[ 1 ];
      if not ( IdElementaryCompactLieGroup( O2 ) = [ 2, 2 ] ) then
        TryNextMethod( );
      fi;

      # test if the second component is a finite group
      Ga := decomp[ 2 ];
      if not ( IsFinite( Ga ) ) then
        TryNextMethod( );
      fi;

      # objectify CCSs of the group
      CCSs_O2 := ConjugacyClassesSubgroups( O2 );
      CCSs_Ga := ConjugacyClassesSubgroups( Ga );

      # setup CCS classes
      data := rec( ccsClasses := [ ] );
      x := X( Integers, "x" );

      for C2 in CCSs_Ga do
        # take a representative from a given CCS
        H2 := Representative( C2 );
        if HasAbbrv( C2 ) then
          name_H2 := ShallowCopy( Abbrv( C2 ) );
          RemoveCharacters( name_H2, "()" );
        else
          name_H2 := String( H2 );
        fi;
        NH2 := NormalizerInParent( H2 );

        for k in DivisorsInt( Order( H2 ) ) do
          # when L is a cyclic group
          L := pCyclicGroup( k );

          # find all epimorphisms from H2 to L
          epis := GQuotients( H2, L );
          if not IsEmpty( epis ) then
            epis := ListX( epis, AllAutomorphisms( L ), \* );

            # Take NL to be the group generate by kappa (reflection)
            NL := pDihedralGroup( k );
            NL := Group( NL.2 );

            # Take the direct product of <NL> and <NH2>
            NLxNH2 := DirectProduct( NL, NH2 );

            # define <NLxNH2> action on <epis>
            actfunc := function( epi, g )
              local dg,
                    aut_H2,
                    aut_L;

              dg := DirectProductDecomposition( NLxNH2, g );
              aut_L  := ConjugatorAutomorphism( L, dg[ 1 ] );
              aut_H2 := ConjugatorAutomorphism( H2, Inverse( dg[ 2 ] ) );

              return aut_H2*epi*aut_L;
            end;

            # divide epimorphisms into conjugacy classes
            epi2_classes := Orbits( NLxNH2, epis, actfunc );
          else
            epi2_classes := [ ];
          fi;

          for epi2_list in epi2_classes do
            epi2 := Representative( epi2_list );
            Z2 := Kernel( epi2 );
            CZ2 := First( CCSs_Ga, C -> Z2 in C );
            if HasAbbrv( CZ2 ) then
              name_Z2 := ShallowCopy( Abbrv( CZ2 ) );
              RemoveCharacters( name_Z2, "()" );
            else
              name_Z2 := String( Z2 );
            fi;

            # L = Z_1
            if ( k = 1 ) then
              # H1 = Z1 = SO(2)
              C1 := CCSs_O2[ 0, 1 ];
              H1 := Representative( C1 );
              epi1_list := [ ];
              epi1 := GroupHomomorphismByFunction( H1, L,
                  g -> One( L ), false, y -> One( H1 ) );
              SetKernelOfMultiplicativeGeneralMapping( epi1, H1 );
              Add( epi1_list, epi1 );

              Add( data.ccsClasses, rec(
                is_zero_mode		:= true,
                order_of_weyl_group	:= 2*OrderOfWeylGroup( C2 ),
                abbrv			:= StringFormatted( "(SO(2) x {})", name_H2 ),
                goursat_info		:= rec( C1		:= C1,
                                                C2		:= C2,
                                                epi1_list	:= epi1_list,
                                                epi2_list	:= epi2_list,
                                                L		:= L		)
              ) );

              # H1 = Z1 = O(2)
              C1 := CCSs_O2[ 0, 2 ];
              H1 := Representative( C1 );
              epi1_list := [ ];
              epi1 := GroupHomomorphismByFunction( H1, L,
                  x -> One( L ), false, y -> One( H1 ) );
              SetKernelOfMultiplicativeGeneralMapping( epi1, H1 );
              Add( epi1_list, epi1 );

              Add( data.ccsClasses, rec(
                is_zero_mode		:= true,
                order_of_weyl_group	:= OrderOfWeylGroup( C2 ),
                abbrv			:= StringFormatted( "(O(2) x {})", name_H2 ),
                goursat_info		:= rec( C1		:= C1,
                                                C2		:= C2,
                                                epi1_list	:= epi1_list,
                                                epi2_list	:= epi2_list,
                                                L		:= L		)
              ) );

              # H1 = Z1 = Z_l
              C1 := CCSs_O2[ 1, 1 ];
              H1 := Representative( C1 );
              epi1_list := [ GroupHomomorphismByImagesNC( H1, L ) ];

              Add( data.ccsClasses, rec(
                is_zero_mode		:= false,
                order_of_weyl_group	:= 2*OrderOfWeylGroup( C2 )*x,
                abbrv			:= StringFormatted( "(Z_{{}} x {})", name_H2 ),
                goursat_info		:= rec( C1		:= C1,
                                                C2		:= C2,
                                                epi1_list	:= epi1_list,
                                                epi2_list	:= epi2_list,
                                                L		:= L		)
              ) );

              # H1 = Z1 = D_l
              C1 := CCSs_O2[ 1, 2 ];
              H1 := Representative( C1 );
              epi1_list := [ GroupHomomorphismByImagesNC( H1, L, [ L.1, L.1 ] ) ];

              Add( data.ccsClasses, rec(
                is_zero_mode		:= false,
                order_of_weyl_group	:= 2*OrderOfWeylGroup( C2 ),
                abbrv			:= StringFormatted( "(D_{{}} x {})", name_H2 ),
                goursat_info		:= rec( C1		:= C1,
                                                C2		:= C2,
                                                epi1_list	:= epi1_list,
                                                epi2_list	:= epi2_list,
                                                L		:= L		)
              ) );

            # L = Z_2
            elif ( k = 2 ) then
              # H1 = Z_{2l}, Z1 = Z_l
              C1 := CCSs_O2[ 2, 1 ];
              H1 := Representative( C1 );
              epi1_list := [ GroupHomomorphismByImages( H1, L ) ];

              Add( data.ccsClasses, rec(
                is_zero_mode		:= false,
                order_of_weyl_group	:= 2*OrderOfWeylGroup( C2 )/Size( epi2_list )*x,
                abbrv			:= StringFormatted( "(Z_{{}}|Z_{{}} x {}|{})",
                                                            name_Z2, name_H2 ),
                goursat_info		:= rec( C1		:= C1,
                                                C2		:= C2,
                                                epi1_list	:= epi1_list,
                                                epi2_list	:= epi2_list,
                                                L		:= L		)
              ) );

              # H1 = D_{2l}, Z1 = D_l
              C1 := CCSs_O2[ 2, 2 ];
              H1 := Representative( C1 );
              epi1_list := [
                GroupHomomorphismByImages( H1, L, [ L.1, One( L ) ] ),
                GroupHomomorphismByImages( H1, L, [ L.1, L.1 ] )
              ];

              Add( data.ccsClasses, rec(
                is_zero_mode		:= false,
                order_of_weyl_group	:= 2*OrderOfWeylGroup( C2 )/Size( epi2_list ),
                abbrv			:= StringFormatted( "(D_{{}}|D_{{}} x {}|{})",
                                                            name_Z2, name_H2 ),
                goursat_info		:= rec( C1		:= C1,
                                                C2		:= C2,
                                                epi1_list	:= epi1_list,
                                                epi2_list	:= epi2_list,
                                                L		:= L		)
              ) );

            # L = Z_k, k>=3
            else
              # H1 = Z_{kl}, Z1 = Z_l
              C1 := CCSs_O2[ k, 1 ];
              H1 := Representative( C1 );
              epi1_list := [ GroupHomomorphismByImages( H1, L ) ];

              Add( data.ccsClasses, rec(
                is_zero_mode		:= false,
                order_of_weyl_group	:= 2*OrderOfWeylGroup( C2 )/Size( epi2_list )*x,
                abbrv			:= StringFormatted( "(Z_{{}}|Z_{{}} x {}|{})",
                                                            name_Z2, name_H2 ),
                goursat_info		:= rec( C1		:= C1,
                                                C2		:= C2,
                                                epi1_list	:= epi1_list,
                                                epi2_list	:= epi2_list,
                                                L		:= L		)
              ) );
            fi;
          od;

          # when L is a dihedral group
          if IsEvenInt( k ) then
            j := k/2;
          else
            continue;
          fi;

          L := pDihedralGroup( j );
          NL := pDihedralGroup( 2*j );
          LL := Subgroup( NL, [ (NL.1)^2, NL.2 ] );
          L_to_LL := GroupHomomorphismByImagesNC( L, LL );
          LL_to_L := GroupHomomorphismByImagesNC( LL, L );

          epis := GQuotients( H2, L );
          if not IsEmpty( epis ) then
            epis := ListX( epis, AllAutomorphisms( L ), \* );

            # Take NH and the direct product of NL and NH
            NLxNH2 := DirectProduct( NL, NH2 );

            # define NLxNH action on phis
            actfunc := function( epi, g )
              local dg,
                    aut_H2,
                    aut_L;

              dg := DirectProductDecomposition( NLxNH2, g );
              aut_L := L_to_LL*ConjugatorAutomorphism( LL, dg[ 1 ] )*LL_to_L;
              aut_H2 := ConjugatorAutomorphism( H2, Inverse( dg[ 2 ] ) );

              return aut_H2*epi*aut_L;
            end;

            # divide epimorphisms into conjugacy classes
            epi2_classes := Orbits( NLxNH2, epis, actfunc );
          else
            epi2_classes := [ ];
          fi;

          for epi2_list in epi2_classes do
            epi2 := Representative( epi2_list );
            Z2 := Kernel( epi2 );
            CZ2 := First( CCSs_Ga, C -> Z2 in C );
            if HasAbbrv( CZ2 ) then
              name_Z2 := ShallowCopy( Abbrv( CZ2 ) );
              RemoveCharacters( name_Z2, "()" );
            else
              name_Z2 := String( Z2 );
            fi;

            # L = D_1
            if ( j = 1 ) then
              # H1 = O(2), Z1 = SO(2)
              C1 := CCSs_O2[ 0, 2 ];
              H1 := Representative( C1 );
              epi1_list := [ ];
              epi1 := GroupHomomorphismByFunction( H1, L,
                  g -> (L.2)^(1-DeterminantMat( g ))/2 );
              SetKernelOfMultiplicativeGeneralMapping( epi1,
                  Representative( CCSs_O2[ 0, 1 ] ) );
              Add( epi1_list, epi1 );

              Add( data.ccsClasses, rec(
                is_zero_mode		:= true,
                order_of_weyl_group	:= 2*OrderOfWeylGroup( C2 )/Size( epi2_list ),
                abbrv			:= StringFormatted( "(O(2)|SO(2) x {}|{})",
                                                            name_Z2, name_H2 ),
                goursat_info		:= rec( C1		:= C1,
                                                C2		:= C2,
                                                epi1_list	:= epi1_list,
                                                epi2_list	:= epi2_list,
                                                L		:= L		)
              ) );
            fi;

            # K = D_{jl}, Z_l (l >= 1)
            C1 := CCSs_O2[ j, 2 ];
            H1 := Representative( C1 );
            epi1_list := [ GroupHomomorphismByImages( H1, L ) ];

            Add( data.ccsClasses, rec(
              is_zero_mode		:= false,
              order_of_weyl_group	:= 2*j*OrderOfWeylGroup( C2 )/Size( epi2_list ),
              abbrv			:= StringFormatted( "(D_{{}}|Z_{{}} x {}|{})",
                                                            name_Z2, name_H2 ),
              goursat_info		:= rec( C1		:= C1,
                                                C2		:= C2,
                                                epi1_list	:= epi1_list,
                                                epi2_list	:= epi2_list,
                                                L		:= L		)
            ) );
          od;
        od;
      od;
      # sort ccs_classes
#     ccs_pairs := List( ccs_classes, cl -> [ NewCCS( rep_ccss, cl ), cl ] );
#     PSort( ccs_pairs );

      return NewCompactLieGroupConjugacyClassesSubgroups( IsGroup, G, data );
    end
  );

#############################################################################
##
#O  Projection( <G>, <k> )
##
# InstallMethod( Projection,
#   "projection of direct product with ECLG",
#   [ IsCompactLieGroup and HasDirectProductInfo, IsPosInt ],
#   function( G, k )
#     local info,
#           proj,      # projection from the direct product to its component
#           proj1,     # projection from gamma to its component
#           dpinfo;    # direct product info

#     info := DirectProductInfo( G );

#     if ( ind = 1 ) then
#       proj := GroupHomomorphismByFunction( grp, dpinfo.eclg, elmt -> elmt[ 1 ] );
#     else
#       proj1 := Projection( dpinfo.gamma, ind-1 );
#       proj := GroupHomomorphismByFunction( grp, dpinfo.groups[ ind ], elmt -> Image( proj1, elmt[ 2 ] ) );
#     fi;
#     SetImagesSource( proj, dpinfo.groups[ ind ] );

#     return proj;
#   end
# );

#############################################################################
##
#O  Embedding( <G>, <k> )
##
# InstallMethod( Embedding,
#   "embedding of direct product with ECLG",
#   [ IsDirectProductWithECLG, IsPosInt ],
#   function( grp, ind )
#     local embed,     # embedding to the direct product from its component
#           embed1,    # embedding to gamma from its component
#           dpinfo;    # direct product info

#     dpinfo := DirectProductInfo( grp );

#     if ( ind = 1 ) then
#       embed := GroupHomomorphismByFunction( dpinfo.eclg, grp, elmt -> DirectProductElement( [ elmt, One( dpinfo.gamma ) ] ) );
#       SetImagesSource( embed, DirectProduct( dpinfo.eclg, Group( One( dpinfo.gamma ) ) ) );
#     else
#       embed1 := Embedding( dpinfo.gamma, ind-1 );
#       embed := GroupHomomorphismByFunction( dpinfo.gamma, grp, elmt -> DirectProductElement( [ One( dpinfo.eclg ), Image( embed1, elmt ) ] ) );
#       SetImagesSource( embed, DirectProduct( Group( One( dpinfo.eclg ) ), Image( embed1 ) ) );
#     fi;

#     return embed;
#   end
# );

#############################################################################
##
#O  nLHnumber( <C1>, <C2> )
##
# InstallMethod( nLHnumber,
#   "n(L,H) number for CCSs of GxECLG",
#   IsIdenticalObj,
#   [ IsDirectProductWithECLGCCSRep, IsDirectProductWithECLGCCSRep ],
#   function( ccs1, ccs2 )
#     local gamma,
#           nLH_gamma,
#           nLH_eclg,
#           info1, info2,
#           H1, ZH1, L1, K1, ZK1, phi1,
#           H2, HH2, L2, K2, ZK2, phi2,
#           iso_HH2_H2,
#           phi_list2,
#           nLH;

#     if not ( ActingDomain( ccs1 ) = ActingDomain( ccs2 ) ) then
#       Error( "ccs1 and ccs2 are not from the same group." );
#     fi;

#     info1 := GoursatInfo( ccs1 );
#     gamma := ActingDomain( info1.cH );
#     H1 := Representative( info1.cH );
#     phi1 := Representative( info1.phi_list );
#     ZH1 := Kernel( phi1 );
#     K1 := Representative( info1.cK );
#     ZK1 := Kernel( info1.psi );
#     L1 := Range( info1.psi );

#     info2 := GoursatInfo( ccs2 );
#     H2 := Representative( info2.cH );
#     K2 := Representative( info2.cK );
#     ZK2 := Kernel( info2.psi );
#     L2 := Range( info2.psi );

#     nLH_eclg := nLHnumber( info1.cK, info2.cK );
#     if IsZero( nLH_eclg ) then
#       return 0;
#     elif not IsSubset( ZK2, ZK1 ) then
#       return 0;
#     fi;

#     nLH_gamma := nLHnumber( info1.cH, info2.cH );
#     if IsZero( nLH_gamma ) then
#       return 0;
#     elif IsPosInt( nLH_gamma ) then
#       nLH := 0;
#       HH2 := First( info2.cH, subg -> IsSubset( subg, H1 ) );
#       iso_HH2_H2 := ConjugatorIsomorphism( HH2, RepresentativeAction( gamma, HH2, H2 ) );
#       phi_list2 := iso_HH2_H2*info2.phi_list;

#       for phi2 in phi_list2 do
#         if not ForAll( GeneratorsOfGroup( ZH1 ), gen -> ( Image( phi2, gen ) = One( L2 ) ) ) then
#           continue;
#         elif ( Size( L1 ) > 1 ) and not ForAll( GeneratorsOfGroup( L1 ), gen -> ( Image( info2.psi, Representative( PreImages( info1.psi, gen ) ) ) = Image( phi2, Representative( PreImages( phi1, gen ) ) ) ) ) then
#           continue;
#         fi;
#         nLH := nLH+1;
#       od;
#     fi;
#     nLH := nLH_gamma*nLH_eclg*nLH;

#     return nLH;
#   end
# );


##  Print, View and Display


#############################################################################
##
#E  DirectProduct2.gi . . . . . . . . . . . . . . . . . . . . . . . ends here
