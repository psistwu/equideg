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
#O  Projection( <G>, <k> )
##
  InstallMethod( Projection,
    "projection of direct product with CLG",
    [ IsCompactLieGroup and HasDirectProductInfo, IsPosInt ],
    function( G, k )
      local info,	# direct product info
            comp,	# the codomain of the projection
            proj;	# projection from <G> to its component

      info := DirectProductInfo( G );
      comp := info.groups[ k ];

      if not IsBound( info.projections[ k ] ) then
        proj := GroupHomomorphismByFunction( G, comp, e -> e[ k ] );
        SetIsSurjective( proj, true );
        info.projections[ k ] := proj;
      fi;

      return info.projections[ k ];
    end
  );

#############################################################################
##
#O  Embedding( <G>, <k> )
##
  InstallMethod( Embedding,
    "embedding of direct product with ECLG",
    [ IsCompactLieGroup and HasDirectProductInfo, IsPosInt ],
    function( G, k )
      local info,	# direct product info
            comp,	# the codomain of the projection
            ones,	# identities of direct product components of <G>
            embed;	# projection from <G> to its component

      info := DirectProductInfo( G );
      comp := info.groups[ k ];

      if not IsBound( info.embeddings[ k ] ) then
        ones := List( info.groups, One );
        embed := GroupHomomorphismByFunction( comp, G,
          function( e )
            local a;

            a := ShallowCopy( ones );
            a[ k ] := e;

            return DirectProductElement( a );
          end
        );
        SetIsInjective( embed, true );
        info.embeddings[ k ] := embed;
      fi;

      return info.embeddings[ k ];
    end
  );

#############################################################################
##
#A  DimensionOfCompactLieGroup( <G> )
##
  InstallImmediateMethod( DimensionOfCompactLieGroup,
    "",
    IsCompactLieGroup and HasDirectProductInfo,
    0,
    G -> Sum( List( DirectProductInfo( G ).groups,
         DimensionOfCompactLieGroup ) )
  );

#############################################################################
##
#A  RankOfCompactLieGroup( <G> )
##
  InstallImmediateMethod( RankOfCompactLieGroup,
    "",
    IsCompactLieGroup and HasDirectProductInfo,
    0,
    G -> Sum( List( DirectProductInfo( G ).groups,
         RankOfCompactLieGroup ) )
  );


##  Part 2: CCS of Direct Product of Compact Lie Groups

#############################################################################
##
#A  OrderOfRepresentative( <C> )
##
  InstallMethod( OrderOfRepresentative,
    "",
    [ IsCompactLieGroupConjugacyClassSubgroupsRep and HasGoursatInfo ],
    function( C )
      local info;

      info := GoursatInfo( C );

      return OrderOfRepresentative( info.C1 )*
             OrderOfRepresentative( info.C2 )/
             Order( info.L );
    end
  );

#############################################################################
##
#O  nLHnumber( <A>, <B> )
##
  InstallOtherMethod( nLHnumber,
    "n(L,H) number for CCSs of ECLGxG",
    IsIdenticalObj,
    [ IsCompactLieGroupConjugacyClassSubgroupsRep and HasGoursatInfo,
      IsCompactLieGroupConjugacyClassSubgroupsRep and HasGoursatInfo  ],
    function( A, B )
      local G,
            decomp,
            Ga,
            x,
            infoA,
            infoB,
            nLH1,
            nLH2,
            nLH,
            AH2,
            BH2,
            BH2_,
            Aepi1,
            Aepi2,
            Bepi1,
            Bepi2,
            Bepi1_list,
            Bepi2_list,
            g,
            y,
            h1,
            h2,
            iso,
            flag;

      G := ActingDomain( A );
      decomp := DirectProductInfo( G ).groups;
      Ga := decomp[ 2 ];

      if not ( ActingDomain( B ) = G ) then
        Error( "C1 and C2 are not from the same group." );
      fi;

      x := X( Integers, "x" );
      infoA := GoursatInfo( A );
      infoB := GoursatInfo( B );

      nLH1 := nLHnumber( infoA.C1, infoB.C1 );
      nLH2 := nLHnumber( infoA.C2, infoB.C2 );
      if IsZero( nLH1 ) or IsZero( nLH2 ) then
        return Zero( x );
      fi;

      AH2 := Representative( infoA.C2 );
      BH2 := Representative( infoB.C2 );
      Aepi1 := Representative( infoA.epi1_list );
      Aepi2 := Representative( infoA.epi2_list );
      Bepi1_list := infoB.epi1_list;
      Bepi2_list := infoB.epi2_list;

      if not IsSubset( BH2, AH2 ) then
        for BH2_ in infoB.C2 do
          if IsSubset( BH2_, AH2 ) then
            g := RepresentativeAction( Ga, BH2_, BH2 );
            iso := ConjugatorIsomorphism( BH2_, g );
            Bepi2_list := iso*Bepi2_list;
            break;
          fi;
        od;
      fi;

      nLH := Zero( x );
      for Bepi1 in Bepi1_list do
        if not IsSubset( Kernel( Bepi1 ), Kernel( Aepi1 ) ) then
          continue;
        fi;

        for Bepi2 in Bepi2_list do
          if not IsSubset( Kernel( Bepi2 ), Kernel( Aepi2 ) ) then
            continue;
          fi;

          flag := true;
          for y in GeneratorsOfGroup( infoA.L ) do
            if IsOne( y ) then
              continue;
            fi;

            h1 := PreImagesRepresentative( Aepi1, y );
            h2 := PreImagesRepresentative( Aepi2, y );

            if not ( Image( Bepi1, h1 ) = Image( Bepi2, h2 ) ) then
              flag := false;
              continue;
            fi;
          od;

          if flag then
            nLH := nLH + 1;
          fi;
        od;
      od;

      return nLH * nLH1 * nLH2;
    end
  );


##  Part 3: CCSs for O(2)xGa

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
            
            # The following local variables are related to CCS classes
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
            LL_to_L,
            class,
            proto;
            
      # test if <G> is a direct product of two groups
      decomp := DirectProductInfo( G ).groups;
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
              
              class	:= rec(
                is_zero_mode		:= true,
                order_of_weyl_group	:= 2*OrderOfWeylGroup( C2 ),
                abbrv			:= StringFormatted( "(SO(2) x {})", name_H2 ),
                goursat_info		:= rec( C1		:= C1,
                                                C2		:= C2,
                                                epi1_list	:= epi1_list,
                                                epi2_list	:= epi2_list,
                                                L		:= L		) );
              proto		:= NewCompactLieGroupConjugacyClassSubgroups(
                                   IsMatrixGroup, G, class );
              class.proto	:= proto;
              Add( data.ccsClasses, class );

              # H1 = Z1 = O(2)
              C1 := CCSs_O2[ 0, 2 ];
              H1 := Representative( C1 );
              epi1_list := [ ];
              epi1 := GroupHomomorphismByFunction( H1, L,
                  g -> One( L ), false, y -> One( H1 ) );
              SetKernelOfMultiplicativeGeneralMapping( epi1, H1 );
              Add( epi1_list, epi1 );

              class := rec(
                is_zero_mode		:= true,
                order_of_weyl_group	:= OrderOfWeylGroup( C2 ),
                abbrv			:= StringFormatted( "(O(2) x {})", name_H2 ),
                goursat_info		:= rec( C1		:= C1,
                                                C2		:= C2,
                                                epi1_list	:= epi1_list,
                                                epi2_list	:= epi2_list,
                                                L		:= L		) );
              class.proto := NewCompactLieGroupConjugacyClassSubgroups(
                             IsMatrixGroup, G, class );
              Add( data.ccsClasses, class );

              # H1 = Z1 = Z_l
              C1 := CCSs_O2[ 1, 1 ];
              H1 := Representative( C1 );
              epi1_list := [ GroupHomomorphismByImagesNC( H1, L ) ];

              class := rec(
                is_zero_mode		:= false,
                order_of_weyl_group	:= 2*OrderOfWeylGroup( C2 )*x,
                abbrv			:= StringFormatted( "(Z_{{}} x {})", name_H2 ),
                goursat_info		:= rec( C1		:= C1,
                                                C2		:= C2,
                                                epi1_list	:= epi1_list,
                                                epi2_list	:= epi2_list,
                                                L		:= L		) );
              class.proto := NewCompactLieGroupConjugacyClassSubgroups(
                             IsMatrixGroup, G, class );
              Add( data.ccsClasses, class );

              # H1 = Z1 = D_l
              C1 := CCSs_O2[ 1, 2 ];
              H1 := Representative( C1 );
              epi1_list := [ GroupHomomorphismByImagesNC( H1, L, [ L.1, L.1 ] ) ];

              class := rec(
                is_zero_mode		:= false,
                order_of_weyl_group	:= 2*OrderOfWeylGroup( C2 ),
                abbrv			:= StringFormatted( "(D_{{}} x {})", name_H2 ),
                goursat_info		:= rec( C1		:= C1,
                                                C2		:= C2,
                                                epi1_list	:= epi1_list,
                                                epi2_list	:= epi2_list,
                                                L		:= L		) );
              class.proto := NewCompactLieGroupConjugacyClassSubgroups(
                             IsMatrixGroup, G, class );
              Add( data.ccsClasses, class );

            # L = Z_k (k>1)
            else
              # H1 = Z_{kl}, Z1 = Z_l
              C1 := CCSs_O2[ k, 1 ];
              H1 := Representative( C1 );
              epi1_list := [ GroupHomomorphismByImages( H1, L ) ];

              class := rec(
                is_zero_mode		:= false,
                order_of_weyl_group	:= 2*OrderOfWeylGroup( C2 )/Size( epi2_list )*x,
                abbrv			:= StringFormatted( "(Z_{{}}|Z_{{}} x {}|{})",
                                                            name_Z2, name_H2 ),
                goursat_info		:= rec( C1		:= C1,
                                                C2		:= C2,
                                                epi1_list	:= epi1_list,
                                                epi2_list	:= epi2_list,
                                                L		:= L		) );
              class.proto := NewCompactLieGroupConjugacyClassSubgroups(
                             IsMatrixGroup, G, class );
              Add( data.ccsClasses, class );

              if ( k = 2 ) then
                # H1 = D_{2l}, Z1 = D_l
                C1 := CCSs_O2[ 2, 2 ];
                H1 := Representative( C1 );
                epi1_list := [
                  GroupHomomorphismByImages( H1, L, [ L.1, One( L ) ] ),
                  GroupHomomorphismByImages( H1, L, [ L.1, L.1 ] )
                ];

                class := rec(
                  is_zero_mode		:= false,
                  order_of_weyl_group	:= 2*OrderOfWeylGroup( C2 )/Size( epi2_list ),
                  abbrv			:= StringFormatted( "(D_{{}}|D_{{}} x {}|{})",
                                                            name_Z2, name_H2 ),
                  goursat_info		:= rec( C1		:= C1,
                                                C2		:= C2,
                                                epi1_list	:= epi1_list,
                                                epi2_list	:= epi2_list,
                                                L		:= L		) );
                class.proto := NewCompactLieGroupConjugacyClassSubgroups(
                               IsMatrixGroup, G, class );
                Add( data.ccsClasses, class );
              fi;
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
                  g -> (L.2)^((1-DeterminantMat( g ))/2),
                  false, y -> H1.(Order(y)) );
              SetKernelOfMultiplicativeGeneralMapping( epi1,
                  Representative( CCSs_O2[ 0, 1 ] ) );
              Add( epi1_list, epi1 );

              class := rec(
                is_zero_mode		:= true,
                order_of_weyl_group	:= 2*OrderOfWeylGroup( C2 )/Size( epi2_list ),
                abbrv			:= StringFormatted( "(O(2)|SO(2) x {}|{})",
                                                            name_Z2, name_H2 ),
                goursat_info		:= rec( C1		:= C1,
                                                C2		:= C2,
                                                epi1_list	:= epi1_list,
                                                epi2_list	:= epi2_list,
                                                L		:= L		) );
              class.proto := NewCompactLieGroupConjugacyClassSubgroups(
                             IsMatrixGroup, G, class );
              Add( data.ccsClasses, class );
            fi;

            # K = D_{jl}, Z_l (l >= 1)
            C1 := CCSs_O2[ j, 2 ];
            H1 := Representative( C1 );
            epi1_list := [ GroupHomomorphismByImages( H1, L ) ];

            class := rec(
              is_zero_mode		:= false,
              order_of_weyl_group	:= 2*j*OrderOfWeylGroup( C2 )/Size( epi2_list ),
              abbrv			:= StringFormatted( "(D_{{}}|Z_{{}} x {}|{})",
                                                            name_Z2, name_H2 ),
              goursat_info		:= rec( C1		:= C1,
                                                C2		:= C2,
                                                epi1_list	:= epi1_list,
                                                epi2_list	:= epi2_list,
                                                L		:= L		) );
            class.proto := NewCompactLieGroupConjugacyClassSubgroups(
                           IsMatrixGroup, G, class );
            Add( data.ccsClasses, class );
          od;
        od;
      od;

      # sort ccs_classes
      PSort( data.ccsClasses, { cl1, cl2 } -> cl1.proto < cl2.proto );

      return NewCompactLieGroupConjugacyClassesSubgroups( IsGroup, G, data );
    end
  );


##  Part 4: Character and Representation Theory

#############################################################################
##
#O  \[\]( <irrs>, <l>, <j> )
##
  InstallOtherMethod( \[\],
    "",
    [ IsCompactLieGroupIrrCollection, IsInt, IsInt ],
    function( irrs, l, j )
      local G,
            decomp,
            G1,
            G2,
            chi_G1,
            chi_G2,
            CCs_G2,
            cat,
            fun,
            chi;

      G := UnderlyingGroup( irrs );
      decomp := DirectProductDecomposition( G );

      if not ( Size( decomp ) = 2 ) then
        TryNextMethod( );
      fi;

      G1 := decomp[ 1 ];
      G2 := decomp[ 2 ];

      # it works for <G1> = SO(2) or O(2)
      if not HasIdElementaryCompactLieGroup( G1 ) or
         not ( IdElementaryCompactLieGroup( G1 ) in [ [ 1, 2 ], [ 2, 2 ] ] ) then
        TryNextMethod( );
      fi;

      # ... and <G2> is finite
      if not IsFinite( G2 ) then
        TryNextMethod( );
      fi;

      chi_G1 := Irr( G1 )[ l ];
      chi_G2 := Irr( G2 )[ j ];
      CCs_G2 := ConjugacyClasses( CharacterTable( G2 ) );

      cat := IsCompactLieGroupClassFunction;
      fun := function( e )
        local k;

        k := Position( CCs_G2, C -> e[ 2 ] in C );
        
        return chi_G2[ k ]*Image( chi_G1, e[ 1 ] );
      end;
      chi := NewCompactLieGroupClassFunction( cat, G, rec( fun := fun ) );

      SetIsCompactLieGroupCharacter( chi, true );
      SetIsGeneratorsOfSemigroup( chi, true );
      SetIdIrr( chi, [ l, j ] );
      ResetFilterObj( chi, HasAbbrv );
      ResetFilterObj( chi, HasString );
      SetString( chi, StringFormatted(
        "DirectProduct( {}, Character( CharacterTable( {} ), {} ) )",
        String( chi_G1 ), String( G2 ), String( chi_G2 )
      ) );
      SetAbbrv( chi, StringFormatted(
        "Character( CharacterTable( {} ), irreducible, id = {} )",
        ViewString( G ), [ l, j ]
      ) );
      return chi;

    end
  );


#############################################################################
##
#E  DirectProduct2.gi . . . . . . . . . . . . . . . . . . . . . . . ends here
