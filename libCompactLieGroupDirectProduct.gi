# # GAP: Compact Lie Group Library
#
# Implementation file of libCompactLieGroupDirectProduct.g
#
# Author:
# Haopin Wu <psistwu@outlook.com>
#

# ### Constructor(s)
# ***
  InstallMethod( NewCCS,
    "CCS constructor of DPwCLG",
    [ IsDirectProductWithCompactLieGroupCCSRep, IsRecord, IsInt ],
    function( filter, ccs_class, mode )
      local fam_ccs,            # family of CCS
            cat_ccs,            # category of CCS
            ccs,                # the CCS
            dpinfo,             # direct product info
            clg,                # the CLG component of the group
            ccss_clg,           # CCS list of the CLG component
            subg,               # a representative of CCS
            phi,                # an epimorphism from H to L
            psi,                # an epimorphism from K to L
            cH, cK,             # conjugacy classes of subgroups
            H, ZH, K, ZK, L,    # five essential subgroups related to subg
            idK,                # id of K
            gens_K,             # generotors of K
            gens_L,             # generators of L
            gens_subg,          # generators of subg
            eL, eH, eK;         # elements in L, H and K

      # test consistency between ccs_class and mode
      if ( mode < 0 ) or ( ccs_class.is_zero_mode <> ( mode = 0 ) ) then
        Error( "Illegel mode for the selected CCS class." );
      fi;

      # objectify the CCS
      fam_ccs := CollectionsFamily( FamilyObj( ccs_class.group ) );
      cat_ccs := CategoryCollections( IsGroup );
      ccs := Objectify( NewType( fam_ccs, cat_ccs and filter ), rec( ) );

      # extract the CLG component of the group
      dpinfo := DirectProductInfo( ccs_class.grp );
      clg := dpinfo.clg;
      ccss_clg := ConjugacyClassesSubgroups( clg );

      # extract cH, cK, H, ZH, L and K
      cH := ccs_class.cH;
      phi := Representative( ccs_class.phi_list );
      H := Source( phi );
      ZH := Kernel( phi );
      L := Range( phi );
      idK := [ ccs_class.idK[ 1 ], ccs_class.idK[ 2 ]*mode ];
      cK := CCSId( ccss_clg )( idK );
      K := Representative( cK );

      # generate the representative of CCS
      if ccs_class.is_zero_mode then
        if ( Size( L ) = 1 ) then
          subg := DirectProduct( K, H );
          psi := GroupHomomorphismByFunction( K, L, elmt -> One( L ), false, elmt -> One( K ) );
          SetKernelOfMultiplicativeGeneralMapping( psi, K );
        else
          subg := Objectify( NewType( FamilyObj( ccs_class.group ), IsGroup ), rec( ) );
          psi := GroupHomomorphismByFunction( K, L, elmt -> L.2^( ( 1-DeterminantMat( elmt ) )/2 ), false, elmt -> DiagonalMat( [ 1, (-1)^( Order( elmt )-1 ) ] ) );
          SetKernelOfMultiplicativeGeneralMapping( psi, Representative( CCSId( ccss_clg )( [ 1, 0 ] ) ) );
        fi;
      else
        # setup homomorphism from K to L
        gens_L := GeneratorsOfGroup( L );
        gens_K := GeneratorsOfGroup( K );
        if ( Size( gens_K ) > Size( gens_L ) ) then
          psi := GroupHomomorphismByImages( K, L, [ L.1, One( L ) ] );
        elif ( Size( gens_K ) = Size( gens_L ) ) then
          psi := GroupHomomorphismByImages( K, L );
        fi;

        if ( Size( L ) = 1 ) then
          subg := DirectProduct( K, H );
        else
          # extract ZK
          ZK := Kernel( psi );

          # generate a representative of the CCS
          gens_subg := ShallowCopy( GeneratorsOfGroup( DirectProduct( ZK, ZH ) ) );
          for eL in gens_L do
            eH := Representative( PreImages( phi, eL ) );
            eK := Representative( PreImages( psi, eL ) );
            Add( gens_subg, DirectProductElement( [ eK, eH ] ) );
          od;
          subg := Group( gens_subg );
        fi;
      fi;

      SetParentAttr( subg, ccs_class.group );
      SetOrderOfWeylGroup( subg, ccs_class.order_of_weyl_group );
      SetIsZeroModeCCS( ccs, ccs_class.is_zero_mode );
      SetRepresentative( ccs, subg );
      SetActingDomain( ccs, ccs_class.group );
      SetOrderOfWeylGroup( ccs, ccs_class.order_of_weyl_group );
      SetGoursatInfo( ccs, rec( cH := cH,
          cK := cK,
          phi_list := ccs_class.phi_list,
          psi := psi,
          idL := ccs_class.idL,
      ) );

      return ccs;
    end
  );


# ### Attribute(s)
# ***
  InstallMethod( ConjugacyClassesSubgroups,
    "return CCS list of direct product with O(2)",
    [ IsDirectProductWithOrthogonalGroupOverReal ],
    function( grp )
      local d,                   # dimension of matrices in the group
            fam_ccss,            # family of CCSs of the group
            cat_ccss,            # category of CCSs of the group
            clg,                 # O(2) component of the group
            gamma,               # gamma component of the group
            ccss_grp,            # CCS list of the group
            ccss_gamma,          # CCS list of gamma
            ccss_clg,            # CCS list of O(2)
            dpinfo,              # direct product info of the group
            make_ccs_classes;    # procedure generating List of CCS types

      # Extract gamma component and O(2) component
      dpinfo := DirectProductInfo( grp );
      clg := dpinfo.clg;
      gamma := dpinfo.gamma;

      # it only works for groups of type Gamma x O(2)
      if not ( DimensionOfMatrixGroup( clg ) = 2 ) then
        TryNextMethod( );
      fi;

      # setup families and categories
      fam_ccss := CollectionsFamily( CollectionsFamily( FamilyObj( grp ) ) );
      cat_ccss := CategoryCollections( CategoryCollections( IsGroup ) );

      # objectify CCSs of the group
      ccss_clg := ConjugacyClassesSubgroups( clg );
      ccss_gamma := ConjugacyClassesSubgroups( gamma );
      ccss_grp := Objectify( NewType( fam_ccss, cat_ccss and IsDirectProductWithCompactLieGroupCCSsRep ),
          rec( ccss_gamma := ccss_gamma, ccss_clg := ccss_clg ) );
      SetUnderlyingGroup( ccss_grp, grp );
      SetIsFinite( ccss_grp, false );

      # setup CCS types
      make_ccs_classes := function( )
        local ccs_classes,              # CCS classes of the group
              ccs_class,                # CCS class of the group
              L,                        # a factor group
              NL,                       # the normalizer of L w.r.t. O(2)
              LL,                       # L embedded in NL
              L_to_LL,                  # isomorphism from L to LL
              LL_to_L,                  # isomorphism from LL to L
              H,                        # a subgroup of gamma
              cH,                       # the CCS contains H
              NH,                       # the normalizer of H w.r.t. gamma
              NLxNH,                    # the direct product of NL and NH
              phis,                     # all epimorphisms from H to L
              actfunc,                  # acting function
              ccs_phis,                 # conjugacy classes of epimorphisms
              cc_phis,                  # a conjugacy class of epimorphisms
              order_of_weyl_group,      # the order of Weyl group
              i, j, k;                  # indices

        ccs_classes := [ ];
        ccs_class := rec( group := grp );

        for cH in ccss_gamma do
          # take a representative from a given CCS
          ccs_class.cH := cH;
          H := Representative( cH );

          # when L is a cyclic group
          for k in DivisorsInt( Size( H ) ) do
            L := pCyclicGroup( k );
            ccs_class.idL := [ 1, k ];

            # find all epimorphisms from H to L
            phis := GQuotients( H, L );
            if IsEmpty( phis ) then
              continue;
            fi;
            phis := Flat( List( phis, e -> List( AllAutomorphisms( L ), a -> e*a ) ) );

            # Take NL to be the group generate by kappa (reflection)
            NL := pDihedralGroup( k );
            NL := Group( GeneratorsOfGroup( NL )[ 2 ] );

            # Take NH to be the normalizer of H
            NH := NormalizerInParent( H );

            # Take the direct product of NL and NH
            NLxNH := DirectProduct( NL, NH );

            # define NLxNH action on phis
            actfunc := function( phi, g )
              local dg,
                    aut_H,
                    aut_L;

              dg := DirectProductDecomposition( NLxNH, g );
              aut_L := ConjugatorAutomorphism( L, dg[ 1 ] );
              aut_H := ConjugatorAutomorphism( H, Inverse( dg[ 2 ] ) );

              return aut_H*phi*aut_L;
            end;

            # divide epimorphisms into conjugacy classes
            ccs_phis := Orbits( NLxNH, phis, actfunc );

            for cc_phis in ccs_phis do
              ccs_class.phi_list := cc_phis;

              # L = Z_1
              if ( k = 1 ) then
                # case 1: K = ZK = SO(2)
                ccs_class.idK := [ 1, 0 ];
                ccs_class.idZK := [ 1, 0 ];
                ccs_class.is_zero_mode := true;
                ccs_class.order_of_weyl_group := [ 2*OrderOfWeylGroup( H ), 0 ];
                Add( ccs_classes, ShallowCopy( ccs_class ) );

                # case 2: K = ZK = O(2)
                ccs_class.idK := [ 2, 0 ];
                ccs_class.idZK := [ 2, 0 ];
                ccs_class.is_zero_mode := true;
                ccs_class.order_of_weyl_group := [ OrderOfWeylGroup( H ), 0 ];
                Add( ccs_classes, ShallowCopy( ccs_class ) );

                # case 3: K = ZK = Z_m
                ccs_class.idK := [ 1, 1 ];
                ccs_class.idZK := [ 1, 1 ];
                ccs_class.is_zero_mode := false;
                ccs_class.order_of_weyl_group := [ 2*OrderOfWeylGroup( H ), 1 ];
                Add( ccs_classes, ShallowCopy( ccs_class ) );

                # case 4: K = ZK = D_m
                ccs_class.idK := [ 2, 1 ];
                ccs_class.idZK := [ 2, 1 ];
                ccs_class.is_zero_mode := false;
                ccs_class.order_of_weyl_group := [ 2*OrderOfWeylGroup( H ), 0 ];
                Add( ccs_classes, ShallowCopy( ccs_class ) );

              # L = Z_2
              elif ( k = 2 ) then
                # case 1: K = Z_2m, ZK = Z_m
                ccs_class.idK := [ 1, 2 ];
                ccs_class.idZK := [ 1, 1 ];
                ccs_class.is_zero_mode := false;
                ccs_class.order_of_weyl_group := [ 2*OrderOfWeylGroup( H )/Size( cc_phis ), 1 ];
                Add( ccs_classes, ShallowCopy( ccs_class ) );

                # case 2: K = Z_2m, ZK = Z_m
                ccs_class.idK := [ 2, 2 ];
                ccs_class.idZK := [ 2, 1 ];
                ccs_class.is_zero_mode := false;
                ccs_class.order_of_weyl_group := [ 2*OrderOfWeylGroup( H )/Size( cc_phis ), 0 ];
                Add( ccs_classes, ShallowCopy( ccs_class ) );

              # L = Z_k, k>=3
              else
                # case 1: K = Z_km, ZK = Z_m
                ccs_class.idK := [ 1, k ];
                ccs_class.idZK := [ 1, 1 ];
                ccs_class.is_zero_mode := false;
                ccs_class.order_of_weyl_group := [ 2*OrderOfWeylGroup( H )/Size( cc_phis ), 1 ];
                Add( ccs_classes, ShallowCopy( ccs_class ) );
              fi;
            od;
          od;

          # when L is a dihedral group
          for j in DivisorsInt( Size( H ) ) do
            # skip when j is not even
            if not IsEvenInt( j ) then
              continue;
            fi;
            k := j/2;
            ccs_class.idL := [ 2, k ];

            # arrange L, NL and the canonical mappings between them
            L := pDihedralGroup( k );
            NL := pDihedralGroup( 2*k );
            LL := Subgroup( NL, [ (NL.1)^2, NL.2 ] );
            L_to_LL := GroupHomomorphismByImagesNC( L, LL );
            LL_to_L := GroupHomomorphismByImagesNC( LL, L );

            phis := GQuotients( H, L );
            if IsEmpty( phis ) then
              continue;
            fi;
            phis := Flat( List( phis, e -> List( AllAutomorphisms( L ), a -> e*a ) ) );

            # Take NH and the direct product of NL and NH
            NH := NormalizerInParent( H );
            NLxNH := DirectProduct( NL, NH );

            # define NLxNH action on phis
            actfunc := function( phi, g )
              local dg,
                    aut_H,
                    aut_L;

              dg := DirectProductDecomposition( NLxNH, g );
              aut_L := L_to_LL*ConjugatorAutomorphism( LL, dg[ 1 ] )*LL_to_L;
              aut_H := ConjugatorAutomorphism( H, Inverse( dg[ 2 ] ) );

              return aut_H*phi*aut_L;
            end;

            # divide epimorphisms into conjugacy classes
            ccs_phis := Orbits( NLxNH, phis, actfunc );

            for cc_phis in ccs_phis do
              ccs_class.phi_list := cc_phis;

              # L = D_1
              if ( k = 1 ) then
                # case 1: K = O(2), ZK = SO(2)
                ccs_class.idK := [ 2, 0 ];
                ccs_class.idZK := [ 1, 0 ];
                ccs_class.is_zero_mode := true;
                ccs_class.order_of_weyl_group := [ 2*OrderOfWeylGroup( H )/Size( cc_phis ), 0 ];
                Add( ccs_classes, ShallowCopy( ccs_class ) );

                # case 2: K = D_m, ZK = Z_m
                ccs_class.idK := [ 2, 1 ];
                ccs_class.idZK := [ 1, 1 ];
                ccs_class.is_zero_mode := false;
                ccs_class.order_of_weyl_group := [ 4*OrderOfWeylGroup( H )/Size( cc_phis ), 0 ];
                Add( ccs_classes, ShallowCopy( ccs_class ) );

              # L = D_k, k>=2
              else
                # case 1: K = D_km, Z_m
                ccs_class.idK := [ 2, k ];
                ccs_class.idZK := [ 1, 1 ];
                ccs_class.is_zero_mode := false;
                ccs_class.order_of_weyl_group := [ 4*j*OrderOfWeylGroup( H )/Size( cc_phis ), 0 ];
                Add( ccs_classes, ShallowCopy( ccs_class ) );
              fi;
            od;
          od;
        od;

        return ccs_classes;
      end;
      SetCCSClasses( ccss_grp, make_ccs_classes( ) );

      return ccss_grp;
    end
  );

# ***
# InstallMethod( ConjugacyClassesSubgroups,
#   "return CCS list of direct product with SO(2)",
#   [ IsDirectProductWithSpecialOrthogonalGroupOverReal ],
#   function( grp )
#     local d,                            # dimension of matrices in the group
#           fam_ccs,                      # family of CCS of the group
#           fam_ccss,                     # family of CCSs of the group
#           cat_ccs,                      # category of CCS of the group
#           cat_ccss,                     # category of CCSs of the group
#           clg,                          # SO(2) component of the group
#           gamma,                        # gamma component of the group
#           ccss_grp,                     # CCS list of the group
#           ccss_gamma,                   # CCS list of gamma
#           ccss_clg,                     # CCS list of SO(2)
#           dpinfo,                       # direct product info of the group
#           make_ccs_types,               # procedure generating List of CCS types
#           ccs_id;                       # function CCSId

#     # Extract gamma component and SO(2) component
#     dpinfo := DirectProductInfo( grp );
#     clg := dpinfo.clg;
#     gamma := dpinfo.gamma;

#     # it only works for groups of type Gamma x O(2)
#     if not ( DimensionOfMatrixGroup( clg ) = 2 ) then
#       TryNextMethod( );
#     fi;

#     # setup families and categories
#     fam_ccs := CollectionsFamily( FamilyObj( grp ) );
#     fam_ccss := CollectionsFamily( fam_ccs );
#     cat_ccs := CategoryCollections( IsGroup );
#     cat_ccss := CategoryCollections( cat_ccs );

#     # objectify CCSs of the group
#     ccss_clg := ConjugacyClassesSubgroups( clg );
#     ccss_gamma := ConjugacyClassesSubgroups( gamma );
#     ccss_grp := Objectify( NewType( fam_ccss, cat_ccss and IsCompactLieGroupCCSsRep ), rec( ccss_gamma := ccss_gamma, ccss_clg := ccss_clg ) );
#     SetUnderlyingGroup( ccss_grp, grp );
#     SetIsFinite( ccss_grp, false );

#     # setup CCS types
#     make_ccs_types := function( )
#       local ccs_types,                    # CCS types of the group
#             ccs_type,                     # CCS type of the group
#             L,                            # a factor group
#             H,                            # a subgroup of gamma
#             cH,                           # the CCS contains H
#             NH,                           # the normalizer of H w.r.t. gamma
#             phis,                         # all epimorphisms from H to L
#             actfunc,                      # acting function
#             ccs_phis,                     # conjugacy classes of epimorphisms
#             cc_phis,                      # a conjugacy class of epimorphisms
#             order_of_weyl_group,          # the order of Weyl group
#             i, j, k;                      # indices

#       ccs_types := [ ];
#       ccs_type := rec( );

#       for cH in ccss_gamma do
#         # take a representative from a given CCS
#         ccs_type.cH := cH;
#         H := Representative( cH );

#         # when L is a cyclic group
#         for k in DivisorsInt( Size( H ) ) do
#           L := pCyclicGroup( k );
#           ccs_type.idL := [ 1, k ];

#           # find all epimorphisms from H to L
#           phis := GQuotients( H, L );
#           if IsEmpty( phis ) then
#             continue;
#           fi;
#           phis := Flat( List( phis, e -> List( AllAutomorphisms( L ), a -> e*a ) ) );

#           # Take NH to be the normalizer of H
#           NH := NormalizerInParent( H );

#           # define NH action on phis
#           actfunc := function( phi, g )
#             local aut_H;

#             aut_H := ConjugatorAutomorphism( H, Inverse( g ) );

#             return aut_H*phi;
#           end;

#           # divide epimorphisms into conjugacy classes
#           ccs_phis := Orbits( NH, phis, actfunc );

#           for cc_phis in ccs_phis do
#             ccs_type.phi_list := cc_phis;
#             ccs_type.idZH := PositionProperty( ccss_gamma, ccs -> Kernel( Representative( cc_phis ) ) in ccs );

#             # L = Z_1
#             if ( k = 1 ) then
#               # case 1: K = ZK = SO(2)
#               ccs_type.idK := [ 1, 0 ];
#               ccs_type.idZK := [ 1, 0 ];
#               ccs_type.is_zero_mode := true;
#               ccs_type.order_of_weyl_group := [ OrderOfWeylGroup( H ), 0 ];
#               Add( ccs_types, ShallowCopy( ccs_type ) );

#               # case 3: K = ZK = Z_m
#               ccs_type.idK := [ 1, 1 ];
#               ccs_type.idZK := [ 1, 1 ];
#               ccs_type.is_zero_mode := false;
#               ccs_type.order_of_weyl_group := [ OrderOfWeylGroup( H ), 1 ];
#               Add( ccs_types, ShallowCopy( ccs_type ) );

#             # L = Z_k, k>=2
#             else
#               # case 1: K = Z_km, ZK = Z_m
#               ccs_type.idK := [ 1, k ];
#               ccs_type.idZK := [ 1, 1 ];
#               ccs_type.is_zero_mode := false;
#               ccs_type.order_of_weyl_group := [ OrderOfWeylGroup( H )/Size( cc_phis ), 1 ];
#               Add( ccs_types, ShallowCopy( ccs_type ) );
#             fi;
#           od;
#         od;
#       od;

#       return ccs_types;
#     end;
#     SetCCSTypes( ccss_grp, make_ccs_types( ) );

#     return ccss_grp;
#   end
# );

# ***
  InstallMethod( CCSId,
    "return CCSId attribute of a compact Lie group CCS list",
    [ IsDirectProductWithCompactLieGroupCCSsRep ],
    ccss -> function( id )
      local ccs_class,
            ccs_classes_filtered,
            ccs;

      ccs_classes_filtered := CCSClassesFiltered( ccss );

      if ( id[ 2 ] = 0 ) then
        ccs_class := ccs_classes_filtered( "zero_mode" )[ id[ 1 ] ];
      elif IsPosInt( id[ 2 ] ) then
        ccs_class := ccs_classes_filtered( "nonzero_mode" )[ id[ 1 ] ];
      else
        return fail;
      fi;

      ccs := NewCCS( IsDirectProductWithCompactLieGroupCCSRep, ccs_class, id[ 2 ] );
      SetIdCCS( ccs, id );

      return ccs;
    end
  );


# ### Operation(s)
# ***
  InstallMethod( DirectProductOp,
    "Operation for direct product of CLG and a finite group",
    [ IsList, IsCompactLieGroup ],
    function( list, clg )
      local gamma_cpnts,                 # the list of all finite group components
            gamma,                       # the direct product of all finite group components
            gamma_clg,                   # the product group
            gamma_cpnts_elmt_fam_list,   # list of elements family of each group in the group list
            cat_gamma_clg,               # the category of the direct product
            fam_gamma_clg;               # the family of the direct product

      gamma_cpnts := ShallowCopy( list );
      Remove( gamma_cpnts, 1 );

      # all but the first component of the direct product should be fininte
      if not ForAll( gamma_cpnts, IsFinite ) then
        TryNextMethod( );
      fi;

      # determine the category of the direct product
      if IsOrthogonalGroupOverReal( clg ) then
        cat_gamma_clg := IsDirectProductWithOrthogonalGroupOverReal;
      elif IsSpecialOrthogonalGroupOverReal( clg ) then
        cat_gamma_clg := IsDirectProductWithSpecialOrthogonalGroupOverReal;
      else
        TryNextMethod( );
      fi;

      # generate direct product of all finite groups in the list
      gamma := DirectProduct( gamma_cpnts );

      # generate direct product with CLG
      gamma_cpnts_elmt_fam_list := List( list, cpnt -> ElementsFamily( FamilyObj( cpnt ) ) );
      fam_gamma_clg := CollectionsFamily( DirectProductElementsFamily( gamma_cpnts_elmt_fam_list ) );
      gamma_clg := Objectify( NewType( fam_gamma_clg, IsDirectProductWithOrthogonalGroupOverReal and IsDirectProductWithCompactLieGroupRep ), rec( ) );

      # setup property(s) and attribute(s) of the product group
      SetDirectProductInfo( gamma_clg, rec(
          gamma := gamma,
          clg := clg,
          groups := list,
          embeddings := [ ],
          projections := [ ]
      ) );
      SetOneImmutable( gamma_clg, DirectProductElement( List( list, One ) ) );
      SetDimension( gamma_clg, Dimension( clg ) );

      return gamma_clg;
    end
  );

# ***
  InstallMethod( Projection,
    "projection of direct product with a compact Lie group",
    [ IsDirectProductWithCompactLieGroup, IsPosInt ],
    function( grp, ind )
      local proj,
            proj1,
            dpinfo;

      dpinfo := DirectProductInfo( grp );

      if ( ind = 1 ) then
        proj := GroupHomomorphismByFunction( grp, dpinfo.clg, elmt -> elmt[ 1 ] );
      else
        proj1 := Projection( dpinfo.gamma, ind-1 );
        proj := GroupHomomorphismByFunction( grp, dpinfo.groups[ ind ], elmt -> Image( proj1, elmt[ 2 ] ) );
      fi;
      SetImagesSource( proj, dpinfo.groups[ ind ] );

      return proj;
    end
  );

# ***
  InstallMethod( Embedding,
    "embedding of direct product with a compact Lie group",
    [ IsDirectProductWithCompactLieGroup, IsPosInt ],
    function( grp, ind )
      local embed,
            embed1,
            dpinfo;

      dpinfo := DirectProductInfo( grp );

      if ( ind = 1 ) then
        embed := GroupHomomorphismByFunction( dpinfo.clg, grp, elmt -> DirectProductElement( [ elmt, One( dpinfo.gamma ) ] ) );
        SetImagesSource( embed, DirectProduct( dpinfo.clg, Group( One( dpinfo.gamma ) ) ) );
      else
        embed1 := Embedding( dpinfo.gamma, ind-1 );
        embed := GroupHomomorphismByFunction( dpinfo.gamma, grp, elmt -> DirectProductElement( [ One( dpinfo.clg ), Image( embed1, elmt ) ] ) );
        SetImagesSource( embed, DirectProduct( Group( One( dpinfo.clg ) ), Image( embed1 ) ) );
      fi;

      return embed;
    end
  );

# ***
  InstallMethod( nLHnumber,
    "n(L,H) number for CCSs of GxCL",
    IsIdenticalObj,
    [ IsDirectProductWithCompactLieGroupCCSRep, IsDirectProductWithCompactLieGroupCCSRep ],
    function( ccs1, ccs2 )
      local gamma,
            nLH_gamma,
            nLH_clg,
            info1, info2,
            H1, ZH1, L1, K1, ZK1, phi1,
            H2, HH2, L2, K2, ZK2, phi2,
            iso_HH2_H2,
            phi_list2,
            nLH;

      if not ( ActingDomain( ccs1 ) = ActingDomain( ccs2 ) ) then
        Error( "ccs1 and ccs2 are not from the same group." );
      fi;

      info1 := GoursatInfo( ccs1 );
      gamma := ActingDomain( info1.cH );
      H1 := Representative( info1.cH );
      phi1 := Representative( info1.phi_list );
      ZH1 := Kernel( phi1 );
      K1 := Representative( info1.cK );
      ZK1 := Kernel( info1.psi );
      L1 := Range( info1.psi );

      info2 := GoursatInfo( ccs2 );
      H2 := Representative( info2.cH );
      K2 := Representative( info2.cK );
      ZK2 := Kernel( info2.psi );
      L2 := Range( info2.psi );

      nLH_clg := nLHnumber( info1.cK, info2.cK );
      if IsZero( nLH_clg ) then
        return 0;
      elif not IsSubset( ZK2, ZK1 ) then
        return 0;
      fi;

      nLH_gamma := nLHnumber( info1.cH, info2.cH );
      if IsZero( nLH_gamma ) then
        return 0;
      elif IsPosInt( nLH_gamma ) then
        nLH := 0;
        HH2 := First( info2.cH, subg -> IsSubset( subg, H1 ) );
        iso_HH2_H2 := ConjugatorIsomorphism( HH2, RepresentativeAction( gamma, HH2, H2 ) );
        phi_list2 := iso_HH2_H2*info2.phi_list;

        for phi2 in phi_list2 do
          if not ForAll( GeneratorsOfGroup( ZH1 ), gen -> ( Image( phi2, gen ) = One( L2 ) ) ) then
            continue;
          elif ( Size( L1 ) > 1 ) and not ForAll( GeneratorsOfGroup( L1 ), gen -> ( Image( info2.psi, Representative( PreImages( info1.psi, gen ) ) ) = Image( phi2, Representative( PreImages( phi1, gen ) ) ) ) ) then
            continue;
          fi;
          nLH := nLH+1;
        od;
      fi;
      nLH := nLH_gamma*nLH_clg*nLH;

      return nLH;
    end
  );

# ### Print, View and Display
  InstallMethod( String,
    "print string of direct product with Lie group",
    [ IsDirectProductWithCompactLieGroup ],
    function( grp )
      local info,            # direct product info
            g,               # direct product component
            str;             # return string

      str := "DirectProduct(";
      info := DirectProductInfo( grp );
      for g in info.groups do
        Append( str, " " );
        Append( str, String( g ) );
        Append( str, "," );
      od;
      Remove( str );
      Append( str, " )" );

      return str;
    end
  );

# ***
  InstallMethod( PrintObj,
    "print direct product with compact Lie group",
    [ IsDirectProductWithCompactLieGroup ],
    function( grp )
      Print( String( grp ) );
    end
  );

# ***
  InstallMethod( ViewString,
    "view string of direct product with compact Lie group",
    [ IsDirectProductWithCompactLieGroup ],
    function( grp )
      local info,            # direct product info
            g,               # direct product component
            str;             # return string

      str := "DirectProduct(";
      info := DirectProductInfo( grp );
      for g in info.groups do
        Append( str, " " );
        Append( str, ViewString( g ) );
        Append( str, "," );
      od;
      Remove( str );
      Append( str, " )" );

      return str;
    end
  );

# ***
  InstallMethod( ViewObj,
    "view direct product with comapct Lie group",
    [ IsDirectProductWithCompactLieGroup ],
    function( grp )
      Print( ViewString( grp ) );
    end
  );

