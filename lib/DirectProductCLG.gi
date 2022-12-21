#############################################################################
##
#W  DirectProductCLG.gi	GAP Package `EquiDeg'			    Haopin Wu
##
#Y  Copyright (C) 2017-2019, Haopin Wu
#Y  Department of Mathematics, National Tsing Hua University, Taiwan
##
##  This file contains implementations for procedures related to
##  direct product of compact Lie groups (including finite groups).
##

##  Part 1: Group operation and attributes

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


##  Part 2: CCS operations and attributes

#############################################################################
##
#A  Representative( <C> )
##
  InstallMethod( Representative,
    "representative of a conjugacy class of subgroups of finite order",
    [ IsCompactLieGroupConjugacyClassSubgroupsRep and HasGoursatInfo ],
    function( C )
      local G,
            info,
            epi1,
            epi2,
            Z1,
            Z2,
            gens,
            l,
            e1,
            e2;

      G := ActingDomain( C );

      if IsZero( IdCCS( C )[ 1 ] ) then
        TryNextMethod( );
      fi;

      info := GoursatInfo( C );
      epi1 := Representative( info.epi1_list );
      epi2 := Representative( info.epi2_list );
      Z1 := Kernel( epi1 );
      Z2 := Kernel( epi2 );

      gens := ShallowCopy( GeneratorsOfGroup( DirectProduct( Z1, Z2 ) ) );
      for l in GeneratorsOfGroup( info.L ) do
        e1 := PreImagesRepresentative( epi1, l );
        e2 := PreImagesRepresentative( epi2, l );
        Add( gens, [ e1, e2 ] );
      od;
      gens := List( gens, DirectProductElement );

      return Subgroup( G, gens );
    end
  );

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

      nLH := Zero( x );
      for Bepi1 in infoB.epi1_list do
        if not IsSubset( Kernel( Bepi1 ), Kernel( Aepi1 ) ) then
          continue;
        fi;

        for Bepi2 in infoB.epi2_list do
          if not IsSubset( Source( Bepi2 ), Source( Aepi2 ) ) then
            continue;
          elif not IsSubset( Kernel( Bepi2 ), Kernel( Aepi2 ) ) then
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

      return nLH * nLH1;
    end
  );


##  Part 3: CCSs computation

#############################################################################
##
#A  ConjugacyClassesSubgroups( <G> )
##
  InstallMethod( ConjugacyClassesSubgroups,
    "return CCS list of O2xGamma",
    [ IsCompactLieGroup and HasDirectProductInfo ],
    function( G )
      local decomp,   # direct product decomposition of <G>
            Ga,       # finite group
            O2,       # O(2)
            CCSs_Ga,  # CCS list of gamma
            CCSs_O2,  # CCS list of O(2)
            
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
            CZ1,
            Z2,
            CZ2,
            name_H2,
            name_Z2,
            L,
            NL,
            NLxGa,
            actfunc1,
            actfunc2,
            x,
            k,
            j,
            LL,
            L_to_LL,
            LL_to_L,
            class,
            amal,
            proto;
            
      # test if <G> is a direct product of two groups
      decomp := DirectProductInfo( G ).groups;
      if not ( Length( decomp ) = 2 ) then
        TryNextMethod( );
      fi;

      # test if the first component is O(2)
      O2 := decomp[ 1 ];
      if not ( IdElementaryCLG( O2 ) = [ 2, 2 ] ) then
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

      # define amalgamation template
      amal := "\\amal{{{{{}}}}}{{{{{}}}}}{{{{{}}}}}{{{{{}}}}}{{{{{}}}}}";

      # define <NLxGa> action on <epis> when L=Z_n
      actfunc1 := function( epi, g )
        local dg,
              iso_H2,
              aut_L;

        dg := DirectProductDecomposition( NLxGa, g );
        aut_L  := ConjugatorAutomorphism( L, dg[ 1 ] );
        iso_H2 := ConjugatorIsomorphism( Source( epi ), dg[ 2 ] );

        return InverseGeneralMapping( iso_H2 )*epi*aut_L;
      end;

      # define <NLxNH> action on <epis> when L=D_n
      actfunc2 := function( epi, g )
        local dg,
              iso_H2,
              aut_L;

        dg := DirectProductDecomposition( NLxGa, g );
        aut_L := L_to_LL*ConjugatorAutomorphism( LL, dg[ 1 ] )*LL_to_L;
        iso_H2 := ConjugatorIsomorphism( Source( epi ), dg[ 2 ] );

        return InverseGeneralMapping( iso_H2 )*epi*aut_L;
      end;

      for C2 in CCSs_Ga do
        H2 := Representative( C2 );
        # take a representative from a given CCS
        if HasAbbrv( C2 ) then
          name_H2 := Abbrv( C2 );
        else
          name_H2 := String( H2 );
        fi;

        for k in DivisorsInt( Order( H2 ) ) do
          # when L is a cyclic group
          L := pCyclicGroup( k );

          # find all epimorphisms from H2 to L
          epis := [ ];
          for H2 in C2 do
            Append( epis, GQuotients( H2, L ) );
          od;
            
          if not IsEmpty( epis ) then
            epis := ListX( epis, AllAutomorphisms( L ), \* );

            # Take NL to be the group generate by kappa (reflection)
            NL := pDihedralGroup( k );
            NL := Group( NL.2 );

            # Take the direct product of <NL> and <Ga>
            NLxGa := DirectProduct( NL, Ga );

            # divide epimorphisms into conjugacy classes
            epi2_classes := Orbits( NLxGa, epis, actfunc1 );
          else
            epi2_classes := [ ];
          fi;

          for epi2_list in epi2_classes do
            epi2 := Representative( epi2_list );
            Z2   := Kernel( epi2 );
            CZ2  := First( CCSs_Ga, C -> Z2 in C );
            if HasAbbrv( CZ2 ) then
              name_Z2 := Abbrv( CZ2 );
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
                  g -> One( pCyclicGroup( 1 ) ),
                  false, y -> One( Representative( CCSs_O2[ 0, 1 ] ) ) );
              SetKernelOfMultiplicativeGeneralMapping( epi1, H1 );
              Add( epi1_list, epi1 );
              
              class	:= rec(
                is_zero_mode := true,
                order_of_weyl_group	:= 2*OrderOfWeylGroup( C2 ),
                abbrv := StringFormatted( "{} x {}", Abbrv( C1 ), name_H2 ),
                goursat_info := rec( C1  := C1,
                                     CZ1 := C1,
                                     C2  := C2,
                                     CZ2 := CZ2,
                                     epi1_list := epi1_list,
                                     epi2_list := epi2_list,
                                     L := L ) );
              if ForAll( [ C2, CZ2 ], HasLaTeXString ) then
                class.latex_string := StringFormatted( StringFormatted( amal, "\\mathrm{{SO}}(2)", "", "", "", LaTeXString( C2 ) ) );
              fi;
              class.proto	:= NewCompactLieGroupConjugacyClassSubgroups(
                                   IsMatrixGroup, G, class );
              Add( data.ccsClasses, class );

              # H1 = Z1 = O(2)
              C1 := CCSs_O2[ 0, 2 ];
              H1 := Representative( C1 );
              epi1_list := [ ];
              epi1 := GroupHomomorphismByFunction( H1, L,
                  g -> One( pCyclicGroup( 1 ) ),
                  false, y -> One( Representative( CCSs_O2[ 0, 2 ] ) ) );
              SetKernelOfMultiplicativeGeneralMapping( epi1, H1 );
              Add( epi1_list, epi1 );

              class := rec(
                is_zero_mode := true,
                order_of_weyl_group	:= OrderOfWeylGroup( C2 ),
                abbrv := StringFormatted( "{} x {}", Abbrv( C1 ), name_H2 ),
                goursat_info := rec( C1  := C1,
                                     CZ1 := C1,
                                     C2  := C2,
                                     CZ2 := CZ2,
                                     epi1_list := epi1_list,
                                     epi2_list := epi2_list,
                                     L := L ) );
              if ForAll( [ C2, CZ2 ], HasLaTeXString ) then
                class.latex_string := StringFormatted( StringFormatted( amal, "\\mathrm{{O}}(2)", "", "", "", LaTeXString( C2 ) ) );
              fi;
              class.proto := NewCompactLieGroupConjugacyClassSubgroups(
                             IsMatrixGroup, G, class );
              Add( data.ccsClasses, class );

              # H1 = Z1 = Z_l
              C1 := CCSs_O2[ 1, 1 ];
              H1 := Representative( C1 );
              epi1_list := [ GroupHomomorphismByImagesNC( H1, L ) ];

              class := rec(
                is_zero_mode := false,
                order_of_weyl_group	:= 2*x*OrderOfWeylGroup( C2 ),
                abbrv := StringFormatted( "{} x {}", "Z_{}", name_H2 ),
                goursat_info := rec( C1  := C1,
                                     CZ1 := C1,
                                     C2  := C2,
                                     CZ2 := CZ2,
                                     epi1_list := epi1_list,
                                     epi2_list := epi2_list,
                                     L := L ) );
              if ForAll( [ C2, CZ2 ], HasLaTeXString ) then
                class.latex_string := StringFormatted( amal, "\\bbZ_{}", "", "", "", LaTeXString( C2 ) );
              fi;
              class.proto := NewCompactLieGroupConjugacyClassSubgroups(
                             IsMatrixGroup, G, class );
              Add( data.ccsClasses, class );

              # H1 = Z1 = D_l
              C1 := CCSs_O2[ 1, 2 ];
              H1 := Representative( C1 );
              epi1_list := [ GroupHomomorphismByImagesNC( H1, L, [ One( L ), One( L ) ] ) ];

              class := rec(
                is_zero_mode := false,
                order_of_weyl_group	:= 2*OrderOfWeylGroup( C2 ),
                abbrv := StringFormatted( "{} x {}", "D_{}", name_H2 ),
                goursat_info := rec( C1        := C1,
                                     CZ1       := C1,
                                     C2        := C2,
                                     CZ2       := CZ2,
                                     epi1_list := epi1_list,
                                     epi2_list := epi2_list,
                                     L         := L ) );
              if ForAll( [ C2, CZ2 ], HasLaTeXString ) then
                class.latex_string := StringFormatted( amal, "D_{}", "", "", "", LaTeXString( C2 ) );
              fi;
              class.proto := NewCompactLieGroupConjugacyClassSubgroups(
                             IsMatrixGroup, G, class );
              Add( data.ccsClasses, class );

            # L = Z_k (k>1)
            else
              # H1 = Z_{kl}, Z1 = Z_l
              C1  := CCSs_O2[ k, 1 ];
              CZ1 := CCSs_O2[ 1, 1 ];
              H1  := Representative( C1 );
              epi1_list := [ GroupHomomorphismByImages( H1, L ) ];

              class := rec(
                is_zero_mode := false,
                order_of_weyl_group	:= 2*x*OrderOfWeylGroup( C2 )/
                                           Number( epi2_list, epi -> Source( epi ) = H2 ),
                abbrv := StringFormatted( "{}|{} x {}|{}", "Z_{}", "Z_{}", name_Z2, name_H2 ),
                goursat_info  := rec( C1        := C1,
                                      CZ1       := CZ1,
                                      C2        := C2,
		                                  CZ2       := CZ2,
                                      epi1_list	:= epi1_list,
                                      epi2_list	:= epi2_list,
                                      L         :=  L ) );
              if ForAll( [ C2, CZ2 ], HasLaTeXString ) then
                class.latex_string := StringFormatted( amal, "\\bbZ_{}", "\\bbZ_{}", "", LaTeXString( CZ2 ), LaTeXString( C2 ) );
              fi;
              class.proto := NewCompactLieGroupConjugacyClassSubgroups(
                             IsMatrixGroup, G, class );
              Add( data.ccsClasses, class );

              if ( k = 2 ) then
                # H1 = D_{2l}, Z1 = D_l
                C1  := CCSs_O2[ 2, 2 ];
		            CZ1 := CCSs_O2[ 2, 1 ];
                H1  := Representative( C1 );
                epi1_list := [
                  GroupHomomorphismByImages( H1, L, [ L.1, One( L ) ] ),
                  GroupHomomorphismByImages( H1, L, [ L.1, L.1 ] )
                ];

                class := rec(
                  is_zero_mode  := false,
                  order_of_weyl_group	:=  2*OrderOfWeylGroup( C2 )/
                                          Number( epi2_list, epi -> Source( epi ) = H2 ),
                  abbrv := StringFormatted( "{}|{} x {}|{}", "D_{}", "D_{}", name_Z2, name_H2 ),
                  goursat_info := rec( C1        := C1,
                                       CZ1       := CZ1,
                                       C2        := C2,
		                                   CZ2       := CZ2,
                                       epi1_list := epi1_list,
                                       epi2_list := epi2_list,
                                       L         := L ) );
                if ForAll( [ C2, CZ2 ], HasLaTeXString ) then
                  class.latex_string := StringFormatted( amal, "D_{}", "D_{}", "", LaTeXString( CZ2 ), LaTeXString( C2 ) );
                fi;
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

          L  := pDihedralGroup( j );
          NL := pDihedralGroup( 2*j );
          LL := Subgroup( NL, [ (NL.1)^2, NL.2 ] );
          L_to_LL := GroupHomomorphismByImagesNC( L, LL );
          LL_to_L := GroupHomomorphismByImagesNC( LL, L );

          epis := [ ];
          for H2 in C2 do
            Append( epis, GQuotients( H2, L ) );
          od;
            
          if not IsEmpty( epis ) then
            epis := ListX( epis, AllAutomorphisms( L ), \* );

            # Take NH and the direct product of NL and NH
            NLxGa := DirectProduct( NL, Ga );

            # divide epimorphisms into conjugacy classes
            epi2_classes := Orbits( NLxGa, epis, actfunc2 );
          else
            epi2_classes := [ ];
          fi;

          for epi2_list in epi2_classes do
            epi2 := Representative( epi2_list );
            Z2   := Kernel( epi2 );
            CZ2  := First( CCSs_Ga, C -> Z2 in C );
            if HasAbbrv( CZ2 ) then
              name_Z2 := Abbrv( CZ2 );
            else
              name_Z2 := String( Z2 );
            fi;

            # L = D_1
            if ( j = 1 ) then
              # H1 = O(2), Z1 = SO(2)
              C1  := CCSs_O2[ 0, 2 ];
              CZ1 := CCSs_O2[ 0, 1 ];
              H1  := Representative( C1 );
              epi1_list := [ ];
              epi1 := GroupHomomorphismByFunction( H1, L,
                  g -> ( pDihedralGroup( 2 ).2 )^( ( 1-DeterminantMat( g ) )/2 ),
                  false, y -> Representative( CCSs_O2[ 0, 2 ] ).( Order(y) ) );
              SetKernelOfMultiplicativeGeneralMapping( epi1,
                  Representative( CCSs_O2[ 0, 1 ] ) );
              Add( epi1_list, epi1 );

              class := rec(
                is_zero_mode := true,
                order_of_weyl_group	:= 2*OrderOfWeylGroup( C2 )/
                                           Number( epi2_list, epi -> Source( epi ) = H2 ),
                abbrv := StringFormatted( "{}|{} x {}|{}", "O(2)", "SO(2)", name_Z2, name_H2 ),
                goursat_info := rec( C1  := C1,
						                         CZ1 := CZ1,
                                     C2  := C2,
						                         CZ2 := CZ2,
                                     epi1_list := epi1_list,
                                     epi2_list := epi2_list,
                                     L := L ) );
              if ForAll( [ C2, CZ2 ], HasLaTeXString ) then
                class.latex_string := StringFormatted( StringFormatted( amal, "\\mathrm{{O}}(2)", "\\mathrm{{SO}}(2)", "", LaTeXString( CZ2 ), LaTeXString( C2 ) ) );
              fi;
              class.proto := NewCompactLieGroupConjugacyClassSubgroups(
                             IsMatrixGroup, G, class );
              Add( data.ccsClasses, class );
            fi;

            # K = D_{jl}, Z_l (l >= 1)
            C1  := CCSs_O2[ j, 2 ];
            CZ1 := CCSs_O2[ 1, 1 ];
            H1  := Representative( C1 );
            epi1_list := [ GroupHomomorphismByImages( H1, L ) ];

            class := rec(
              is_zero_mode		:= false,
              order_of_weyl_group	:= 2*j*OrderOfWeylGroup( C2 )/
                                           Number( epi2_list, epi -> Source( epi ) = H2 ),
              abbrv := StringFormatted( "{}|{} x {}|{}", "D_{}", "Z_{}", name_Z2, name_H2 ),
              goursat_info := rec( C1  := C1,
	                                 CZ1 := CZ1,
                                   C2  := C2,
			                             CZ2 := CZ2,
                                   epi1_list := epi1_list,
                                   epi2_list := epi2_list,
                                   L := L ) );
            if ForAll( [ C2, CZ2 ], HasLaTeXString ) then
              class.latex_string := StringFormatted( amal, "D_{}", "\\bbZ_{}", "", LaTeXString( CZ2 ), LaTeXString( C2 ) );
            fi;
            class.proto := NewCompactLieGroupConjugacyClassSubgroups(
                           IsMatrixGroup, G, class );
            Add( data.ccsClasses, class );
          od;
        od;
      od;

      # sort ccs_classes
      PSort( data.ccsClasses, { cl1, cl2 } -> cl1.proto < cl2.proto );
      StableSort( data.ccsClasses, { cl1, cl2 } ->
          OrderOfRepresentative( cl1.proto ) < OrderOfRepresentative( cl2.proto ) );

      return NewCompactLieGroupConjugacyClassesSubgroups( IsGroup, G, data );
    end
  );


########################################################################
##
#A  ConjugacyClassesSubgroups( <G> )
##
  InstallMethod( ConjugacyClassesSubgroups,
    "return CCS list of SO(2)xGamma",
    [ IsCompactLieGroup and HasDirectProductInfo ],
    function( G )
      local decomp,   # direct product decomposition of <G>
            Ga,       # finite group
            SO2,      # O(2)
            CCSs_Ga,  # CCS list of gamma
            CCSs_SO2, # CCS list of SO(2)
            
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
            CZ1,
            Z2,
            CZ2,
            name_H2,
            name_Z2,
            L,
            NL,
            NLxGa,
            actfunc,
            x,
            k,
            j,
            LL,
            L_to_LL,
            LL_to_L,
            class,
            amal,
            proto;
            
      # test if <G> is a direct product of two groups
      decomp := DirectProductInfo( G ).groups;
      if not ( Length( decomp ) = 2 ) then
        TryNextMethod( );
      fi;

      # test if the first component is SO(2)
      SO2 := decomp[ 1 ];
      if not ( IdElementaryCLG( SO2 ) = [ 1, 2 ] ) then
        TryNextMethod( );
      fi;

      # test if the second component is a finite group
      Ga := decomp[ 2 ];
      if not ( IsFinite( Ga ) ) then
        TryNextMethod( );
      fi;

      # objectify CCSs of the group
      CCSs_SO2 := ConjugacyClassesSubgroups( SO2 );
      CCSs_Ga := ConjugacyClassesSubgroups( Ga );

      # setup CCS classes
      data := rec( ccsClasses := [] );
      x := X( Integers, "x" );

      # define amalgamation template
      amal := "\\amal{{{{{}}}}}{{{{{}}}}}{{{{{}}}}}{{{{{}}}}}{{{{{}}}}}";

      # define <NLxGa> action on <epis> when L=Z_n
      actfunc := function( epi, g )
        local dg,
              iso_H2;

        dg := DirectProductDecomposition( NLxGa, g );
        iso_H2 := ConjugatorIsomorphism( Source( epi ), dg[ 2 ] );

        return InverseGeneralMapping( iso_H2 )*epi;
      end;


      for C2 in CCSs_Ga do
        H2 := Representative( C2 );
        # take a representative from a given CCS
        if HasAbbrv( C2 ) then
          name_H2 := Abbrv( C2 );
        else
          name_H2 := String( H2 );
        fi;

        for k in DivisorsInt( Order( H2 ) ) do
          # when L is a cyclic group
          L := pCyclicGroup( k );

          # find all epimorphisms from H2 to L
          epis := [ ];
          for H2 in C2 do
            Append( epis, GQuotients( H2, L ) );
          od;
            
          if not IsEmpty( epis ) then
            epis := ListX( epis, AllAutomorphisms( L ), \* );

            # Take NL to be the trivial subgroup of L
            NL := TrivialSubgroup( L );

            # Take the direct product of <NL> and <Ga>
            NLxGa := DirectProduct( NL, Ga );

            # divide epimorphisms into conjugacy classes
            epi2_classes := Orbits( NLxGa, epis, actfunc );
          else
            epi2_classes := [ ];
          fi;

          for epi2_list in epi2_classes do
            epi2 := Representative( epi2_list );
            Z2 := Kernel( epi2 );
            CZ2 := First( CCSs_Ga, C -> Z2 in C );
            if HasAbbrv( CZ2 ) then
              name_Z2 := Abbrv( CZ2 );
            else
              name_Z2 := String( Z2 );
            fi;

            # L = Z_1
            if ( k = 1 ) then
              # H1 = Z1 = SO(2)
              C1 := CCSs_SO2[ 0, 1 ];
              H1 := Representative( C1 );
              epi1_list := [ ];
              epi1 := GroupHomomorphismByFunction( H1, L,
                  g -> One( pCyclicGroup( 1 ) ),
                  false, y -> One( Representative( CCSs_SO2[ 0, 1 ] ) ) );
              SetKernelOfMultiplicativeGeneralMapping( epi1, H1 );
              Add( epi1_list, epi1 );
              
              class	:= rec(
                is_zero_mode := true,
                order_of_weyl_group	:= OrderOfWeylGroup( C2 ),
                abbrv := StringFormatted( "{} x {}", Abbrv( C1 ), name_H2 ),
                goursat_info := rec( C1  := C1,
                                     CZ1 := C1,
                                     C2  := C2,
						                         CZ2 := CZ2,
                                     epi1_list := epi1_list,
                                     epi2_list := epi2_list,
                                     L := L ) );
              if ForAll( [ C2, CZ2 ], HasLaTeXString ) then
                class.latex_string := StringFormatted( StringFormatted( amal, "\\mathrm{{SO}}(2)", "", "", "", LaTeXString( C2 ) ) );
              fi;
              class.proto	:= NewCompactLieGroupConjugacyClassSubgroups(
                                   IsMatrixGroup, G, class );
              Add( data.ccsClasses, class );

              # H1 = Z1 = Z_l
              C1 := CCSs_SO2[ 1, 1 ];
              H1 := Representative( C1 );
              epi1_list := [ GroupHomomorphismByImagesNC( H1, L ) ];

              class := rec(
                is_zero_mode := false,
                order_of_weyl_group := x*OrderOfWeylGroup( C2 ),
                abbrv := StringFormatted( "{} x {}", "Z_{}", name_H2 ),
                goursat_info := rec( C1  := C1,
                                     CZ1 := C1,
                                     C2  := C2,
						                         CZ2 := CZ2,
                                     epi1_list := epi1_list,
                                     epi2_list := epi2_list,
                                     L := L ) );
              if ForAll( [ C2, CZ2 ], HasLaTeXString ) then
                class.latex_string := StringFormatted( amal, "\\bbZ_{}", "", "", "", LaTeXString( C2 ) );
              fi;
              class.proto := NewCompactLieGroupConjugacyClassSubgroups(
                             IsMatrixGroup, G, class );
              Add( data.ccsClasses, class );

            # L = Z_k (k>1)
            else
              # H1 = Z_{kl}, Z1 = Z_l
              C1  := CCSs_SO2[ k, 1 ];
              CZ1 := CCSs_SO2[ 1, 1 ];
              H1  := Representative( C1 );
              epi1_list := [ GroupHomomorphismByImages( H1, L ) ];

              class := rec(
                is_zero_mode		:= false,
                order_of_weyl_group	:= x*OrderOfWeylGroup( C2 )/
                                           Number( epi2_list, epi -> Source( epi ) = H2 ),
                abbrv := StringFormatted( "{}|{} x {}|{}", "Z_{}", "Z_{}", name_Z2, name_H2 ),
                goursat_info := rec( C1  := C1,
                                     CZ1 := CZ1,
                                     C2  := C2,
				                             CZ2 := CZ2,
                                     epi1_list := epi1_list,
                                     epi2_list := epi2_list,
                                     L := L ) );
              if ForAll( [ C2, CZ2 ], HasLaTeXString ) then
                class.latex_string := StringFormatted( amal, "\\bbZ_{}", "\\bbZ_{}", "", LaTeXString( CZ2 ), LaTeXString( C2 ) );
              fi;
              class.proto := NewCompactLieGroupConjugacyClassSubgroups(
                             IsMatrixGroup, G, class );
              Add( data.ccsClasses, class );
            fi;
          od;
        od;
      od;

      # sort ccs_classes
      PSort( data.ccsClasses, { cl1, cl2 } -> cl1.proto < cl2.proto );
      StableSort( data.ccsClasses, { cl1, cl2 } ->
          OrderOfRepresentative( cl1.proto ) < OrderOfRepresentative( cl2.proto ) );

      return NewCompactLieGroupConjugacyClassesSubgroups( IsGroup, G, data );
    end
  );


#############################################################################
##
#O  LaTeXTypesetting( <C>, <str> )
##
# InstallOtherMethod( LaTeXTypesetting,
#   "LaTeX typesetting of CCS of direct product of C x G, where C = O(2) or SO(2) and G is a finite group",
#   [ IsCompactLieGroupConjugacyClassSubgroupsRep, IsString ],
#   function( C, str )
#     local G,
#           U,
#           info,
#           latex_list;

#     G := ActingDomain( C );
#     if not ( Size( DirectProductDecomposition( G ) ) = 2 ) then
#       TryNextMethod( );
#     fi;

#     info := GoursatInfo( C );
#     CZ1 := ;
#     latex_list := List( [ infoU.H1, infoU.Z1, infoU.Z2, infoU.H2 ],
#         S -> LaTeXString( ConjugacyClassSubgroups( S ) ) );

#     return StringFormatted( "\\amal{{{}}}{{{}}}{{{}}}{{{}}}{{{}}}",
#       latex_list[ 1 ],
#       latex_list[ 2 ],
#       str,
#       latex_list[ 3 ],
#       latex_list[ 4 ]  );
#   end
# );

##  Part 4: Character and Representation Theory

#############################################################################
##
#O  \[\,\]( <irrs>, <l>, <j> )
##
  InstallMethod( \[\,\],
    "",
    [ IsCompactLieGroupIrrCollection, IsInt, IsPosInt ],
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
      if not HasIdElementaryCLG( G1 ) or
         not ( IdElementaryCLG( G1 ) in [ [ 1, 2 ], [ 2, 2 ] ] ) then
        TryNextMethod( );
      fi;

      # ... and <G2> is finite
      if not IsFinite( G2 ) then
        TryNextMethod( );
      fi;

      chi_G1 := Irr( G1 )[ l ];
      chi_G2 := Irr( G2 )[ j ];

      cat := IsCompactLieGroupClassFunction;
      fun := e -> ImageElm( chi_G2, e[ 2 ] )*Image( chi_G1, e[ 1 ] );
      chi := NewCompactLieGroupClassFunction( cat, G, rec( fun := fun ) );

      SetIsCompactLieGroupCharacter( chi, true );
      SetIsGeneratorsOfSemigroup( chi, true );
      SetIdIrr( chi, [ l, j ] );
      SetIsIrreducibleCharacter( chi, true );
      SetTensorProductDecomposition( chi, [ chi_G1, chi_G2 ] );
      ResetFilterObj( chi, HasString );
      SetString( chi, StringFormatted(
        "TensorProduct( Irr( {} )[ {} ], Character( CharacterTable( {} ), {} ) )",
        ViewString( G1 ), l, ViewString( G2 ), String( chi_G2 )
      ) );
      return chi;

    end
  );

#############################################################################
##
#O  DimensionOfFixedSet( <chi>, <C> )
##
  InstallOtherMethod( DimensionOfFixedSet,
    "DimensionOfFixedSet",
    [ IsCompactLieGroupCharacter and HasTensorProductDecomposition,
      IsCompactLieGroupConjugacyClassSubgroupsRep and HasGoursatInfo ],
    function( chi, C )
      local G,
            decomp_G,
            G1,
            G2,
            decomp_chi,
            chi1,
            chi2,
            info,
            Z1,
            Z2,
            epi1,
            epi2,
            dfsH1,
            dfsH2,
            dfsZ1,
            dfsZ2;

      G := UnderlyingGroup( chi );
      if not ( ActingDomain( C ) = G ) then
        Error( "<C> is not a CCS of the underlying group of <chi>." );
      fi;

      decomp_G := DirectProductInfo( G ).groups;
      G2 := decomp_G[ 2 ];
      if not IsFinite( G2 ) then
        TryNextMethod( );
      fi;

      G1 := decomp_G[ 1 ];
      if G1 = OrthogonalGroupOverReal( 2 ) then
      elif G1 = SpecialOrthogonalGroupOverReal( 2 ) then
      else
        TryNextMethod( );
      fi;

      if not ( IdCCS( C )[ 1 ] = 0 ) then
        TryNextMethod( );
      fi;

      decomp_chi := TensorProductDecomposition( chi );
      chi1 := decomp_chi[ 1 ];
      chi2 := decomp_chi[ 2 ];
      info := GoursatInfo( C );

      if ( Order( info.L ) = 1 ) then
        return DimensionOfFixedSet( chi1, info.C1 ) *
               DimensionOfFixedSet( chi2, info.C2 );
      elif ( Order( info.L ) = 2 ) then
        epi1 := Representative( info.epi1_list );
        epi2 := Representative( info.epi2_list );
        Z1 := Kernel( epi1 );
        Z2 := Kernel( epi2 );

        dfsH1 := DimensionOfFixedSet( chi1, info.C1 );
        dfsZ1 := DimensionOfFixedSet( chi1, Z1 );
        dfsH2 := DimensionOfFixedSet( chi2, info.C2 );
        dfsZ2 := DimensionOfFixedSet( chi2, Z2 );

        return ( 4*dfsH1*dfsH2 + 2*dfsZ1*dfsZ2
                 - 2*dfsH1*dfsZ2 - 2*dfsH2*dfsZ1 )/2;
      fi;
    end
  );

#############################################################################
##
#A  OrbitTypes( <chi> );
##
  InstallOtherMethod( OrbitTypes,
    "orbit types of character of an elementary compact Lie group",
    [ IsCompactLieGroupCharacter and
      IsIrreducibleCharacter and
      HasTensorProductDecomposition ],
    function( chi )
      local G,
            decomp_G,
            CCSs,
            id,
            ccs_list,
            is_orbittype,
            orbt_list,
            fixeddim_list,
            i, j;

      G := UnderlyingGroup( chi );
      decomp_G := DirectProductDecomposition( G );
      if not ( Size( decomp_G ) = 2 ) then
        TryNextMethod( );
      fi;

      id := IdIrr( chi );
      CCSs := ConjugacyClassesSubgroups( G );

      if ( id[ 1 ] <= 0 ) then
        ccs_list := List( [ 1 .. NumberOfZeroModeClasses( CCSs ) ], j -> CCSs[ 0, j ] );
      else
        ccs_list := List( [ 1 .. NumberOfNonzeroModeClasses( CCSs ) ], j -> CCSs[ 1, j ] );
        Add( ccs_list, CCSs[ 0, NumberOfZeroModeClasses( CCSs ) ] );
      fi;
      fixeddim_list := List( ccs_list, C -> DimensionOfFixedSet( Refolded( chi, 1 ), C ) );

      orbt_list := [ ];
      for i in Reversed( [ 1 .. Size( ccs_list ) ] ) do
        is_orbittype := true;
        for j in [ i+1 .. Size( ccs_list ) ] do
          if ( fixeddim_list[ i ] = fixeddim_list[ j ] ) and
              ( ccs_list[ i ] < ccs_list[ j ] ) then
            is_orbittype := false;
            break;
          fi;
        od;
        if is_orbittype then
          Add( orbt_list, ccs_list[ i ], 1 );
        fi;
      od;

      return List( orbt_list, C -> Refolded( C, id[ 1 ] ) );
    end
  );

#############################################################################
##
#E  DirectProductCLG.gi . . . . . . . . . . . . . . . . . . . . . . ends here
