#############################################################################
##
##  EulerRing.gi	GAP Package `EquiDeg'			    Haopin Wu
##
#Y  Copyright (C) 2017-2022, Haopin Wu
##
##  This file contains implementations for procedures
##  related to Euler ring.
##

##  Part 1: Euler ring element

#############################################################################
##
#U  NewEulerRingElement( <filt>, <r> )
##
  InstallMethod( NewEulerRingElement,
    "constructs Euler ring element",
    [ IsEulerRingByCompactLieGroupElement,
      IsRecord ],
    function( filt, r )
      local fam,
            cat,
            rep;

            fam := r.fam;
            cat := filt;
            rep := IsEulerRingElementRep;

      return Objectify( NewType( fam, cat and rep ),
        rec( ccsList	:= r.ccs_list,
             ccsIdList	:= r.ccs_id_list,
             coeffList	:= r.coeff_list   )
      );
    end
  );

#############################################################################
##
#A  String( <a> )
##
  InstallMethod( String,
    "string of a Euler ring element",
    [ IsEulerRingElement ],
    function( a )
      local i,		# index
            ccs,
            ccs_id,	# id of CCS
            coeff,	# coefficient
            ccs_name,	# name of CCS
            str;	# name string

      str := "";
      for i in [ 1 .. Length( a ) ] do
        coeff	:= a!.coeffList[ i ];
        ccs_id	:= a!.ccsIdList[ i ];
        ccs	:= a!.ccsList[ i ];

        ccs_name := StringFormatted(
          "({})",
          JoinStringsWithSeparator( Flat( [ ccs_id ] ), "," )
        );

        # append coefficient and name of CCS
        if ( i > 1 ) and ( coeff > 0 ) then
          Append( str, "+" );
        fi;
        Append( str, String( coeff ) );
        Append( str, ccs_name );
      od;

      return StringFormatted( "<{}>", str );
    end
  );

#############################################################################
##
#O  ViewString( <a> )
##
  InstallMethod( ViewString,
    "view string of a Euler ring element",
    [ IsEulerRingElement ],
    function( a )
      local A;     # the Euler ring

      A := FamilyObj( a )!.ring;

      return Concatenation( String( a ), " in ", ViewString( A ) );
    end
  );

#############################################################################
##
#O  PrintObj( <a> )
##
  InstallMethod( PrintObj,
    "display a Euler ring element",
    [ IsEulerRingElement ],
    function( a )
      local i,			# index
            ccs,
            ccs_id,		# id of CCS
            ccs_id_formatted,	# id of CCS
            coeff,		# coefficient
            ccs_name,		# name of CCS
            str;		# name string

      Print( ViewString( FamilyObj( a )!.ring ), " element:\n" );
      for i in [ 1 .. Length( a ) ] do
        coeff	:= a!.coeffList[ i ];
        ccs_id	:= a!.ccsIdList[ i ];
        ccs_id_formatted := StringFormatted(
          "({})",
          JoinStringsWithSeparator( Flat( [ ccs_id ] ), "," )
        );
        ccs	:= a!.ccsList[ i ];

        # determine the name of CCS
        if HasAbbrv( ccs ) then
          ccs_name := Concatenation( ccs_id_formatted, "\t", Abbrv( ccs ) );
        else
          ccs_name := ccs_id_formatted;
        fi;

        # append coefficient and name of CCS
        Print( StringFormatted( "{}\t{}\n", coeff, ccs_name ) );
      od;
    end
  );

#############################################################################
##
#O  LaTeXTypesetting( <a> )
##
  InstallMethod( LaTeXTypesetting,
    "return LaTeX typesetting of an element in the Euler ring",
    [ IsEulerRingElement ],
    function( a )
      local i,		# index
            coeff,	# coefficient
            ccs_id,	# id of CCS
            ccs_list,	# CCSs of the underlying group
            ccs_name,	# name of CCS
            str;	# name string

      ccs_list := FamilyObj( a )!.CCSs;
      str := "";
      for i in [ 1 .. Length( a ) ] do
        coeff     := a!.coeffList[ i ];
        ccs_id := a!.ccsIdList[ i ];

        # determine the name of CCS
        if HasLaTeXString( ccs_list[ ccs_id ] ) then
          ccs_name := LaTeXString( ccs_list[ ccs_id ] );
        else
          ccs_name := StringFormatted(
            "({})",
            JoinStringsWithSeparator( Flat( [ ccs_id ] ), "," )
          );
        fi;

        # append coefficient and name of CCS
        if ( i > 1 ) and ( coeff > 0 ) then
          Append( str, "+" );
        fi;
        Append( str, String( coeff ) );
        Append( str, StringFormatted( "({})", ccs_name ) );
      od;

      return str;
    end
  );

#############################################################################
##
#A  Length( <a> )
##
  InstallMethod( Length,
    "length of a Euler ring element",
    [ IsEulerRingElement ],
    a -> Length( a!.ccsList )
  );

#############################################################################
##
#O  ToSparseList( <a> )
##
  InstallMethod( ToSparseList,
    "convert a Euler ring element to a sparse list",
    [ IsEulerRingElement ],
    a -> ListN( a!.ccsIdList, a!.coeffList, { x, y } -> [ x, y ] )
  );

#############################################################################
##
#O  ZeroOp( <a> )
##
  InstallMethod( ZeroOp,
    "additive identity of a Euler ring",
    [ IsEulerRingElement ],
    function( a )
      return ZeroAttr( FamilyObj( a ) );
    end
  );

#############################################################################
##
#O  OneOp( <a> )
##
  InstallMethod( OneOp,
    "multiplicative identity of a Euler ring",
    [ IsEulerRingElement ],
    function( a )
      return OneAttr( FamilyObj( a ) );
    end
  );

#############################################################################
##
#O  AdditiveInverseOp( <a> )
##
  InstallMethod( AdditiveInverseOp,
    "additive inverse in a Euler ring",
    [ IsEulerRingElement ],
    function( a )
      local fam,
            cat,
            rep,
            addinv;

      fam := FamilyObj( a );
      cat := First( EquiDeg_ERNG_ELMT_CAT_LIST, filt -> filt( a ) );

      addinv := NewEulerRingElement( cat,
        rec( fam := fam,
             ccs_list		:=  a!.ccsList,
             ccs_id_list	:=  a!.ccsIdList,
             coeff_list		:= -a!.coeffList  )

      );

      return addinv;
    end
  );

#############################################################################
##
#O  \=( <a>, <b> )
##
  InstallMethod( \=,
    "identical relation in a Euler ring",
    IsIdenticalObj,
    [ IsEulerRingElement, IsEulerRingElement ],
    function( a, b )
      return ( a!.ccsIdList	= b!.ccsIdList	) and
             ( a!.coeffList	= b!.coeffList 	);
    end
  );

#############################################################################
##
#O  \+( <a>, <b> )
##
  InstallMethod( \+,
    "addition in a Euler ring",
    IsIdenticalObj,
    [ IsEulerRingElement, IsEulerRingElement ],
    function( a, b )
      local fam,
            cat,
            a_sparse_list,
            b_sparse_list,
            sum_sparse_list,
            a_term,
            b_term,
            coeff,
            sum,
            ccs_list,
            ccs_id_list,
            coeff_list;

      fam := FamilyObj( a );
      cat := First( EquiDeg_ERNG_ELMT_CAT_LIST, filt -> filt( a ) );

      a_sparse_list := ToSparseList( a );
      b_sparse_list := ToSparseList( b );
      sum_sparse_list := [ ];

      while not IsEmpty( a_sparse_list ) and not IsEmpty( b_sparse_list ) do
        a_term := First( a_sparse_list, x -> true );
        b_term := First( b_sparse_list, x -> true );

        if ( a_term[ 1 ] = b_term[ 1 ] ) then
          coeff := a_term[ 2 ] + b_term[ 2 ];
          if not ( coeff = 0 ) then
            Add( sum_sparse_list, [ a_term[ 1 ], coeff ] );
          fi;
          Remove( a_sparse_list, 1 );
          Remove( b_sparse_list, 1 );
        elif IdCCSPartialOrder( a_term[ 1 ], b_term[ 1 ] ) then
          Add( sum_sparse_list, a_term );
          Remove( a_sparse_list, 1 );
        elif IdCCSPartialOrder( b_term[ 1 ], a_term[ 1 ] ) then
          Add( sum_sparse_list, b_term );
          Remove( b_sparse_list, 1 );
        fi;
      od;
      Append( sum_sparse_list, a_sparse_list );
      Append( sum_sparse_list, b_sparse_list );

      ccs_id_list := List( sum_sparse_list, x -> x[ 1 ] );
      ccs_list := List( ccs_id_list, id -> \[\]( fam!.CCSs, id ) );
      coeff_list := List( sum_sparse_list, x -> x[ 2 ] );

      sum := NewEulerRingElement( cat,
        rec( fam		:= fam,
             ccs_list		:= ccs_list,
             ccs_id_list	:= ccs_id_list,
             coeff_list		:= coeff_list   )
      );

      return sum;
    end
  );

#############################################################################
##
#O  \*( <n>, <a> )
##
  InstallMethod( \*,
    "scalar multiplication in a Euler ring",
    [ IsInt, IsEulerRingElement ],
    function( n, a )
      local fam,
            cat,
            rep,
            mul;	# result

      fam := FamilyObj( a );
      cat := First( EquiDeg_ERNG_ELMT_CAT_LIST, filt -> filt( a ) );
      rep := IsEulerRingElementRep;

      if IsZero( n ) then
        return Zero( a );
      else
        return NewEulerRingElement(
          cat,
          rec( fam		:= fam,
               ccs_list		:= a!.ccsList,
               ccs_id_list	:= a!.ccsIdList,
               coeff_list	:= n*a!.coeffList )
        );
      fi;
    end
  );

#############################################################################
##
#O  \*( <a>, <b> )
##
  InstallMethod( \*,
    "multiplication in a Euler ring",
    IsIdenticalObj,
    [ IsEulerRingByCompactLieGroupElement,
      IsEulerRingByCompactLieGroupElement  ],
    function( a, b )
      local fam,		      # family of Euler ring element
            cat,		      # category of Euler ring element
            grp,		      # group
            erng,		      # Euler ring
            ccss,		      # CCSs of G
            basis,	      # basis of Euler ring
            idCa,		      # id of CCS a (when a is in the basis )
            idCb,		      # id of CCS b (when b is in the basis )
            idmin,
            Ca,			      # CCS of a (when a is in the basis)
            Cb,			      # CCS of b (when b is in the basis)
            l,			      # mode of the product
            imax,
            ccs_list,		  # ccs list of the product
            ccs_id_list,	# ccs id list of the product
            coeff_list,		# coefficient list of the product
            coeff,		    # a coefficient in the product
            i, j,		      # indices
            Ci, Cj;		    # i-th and j-th CCSs

      fam := FamilyObj( a );
      cat := IsEulerRingByCompactLieGroupElement;

      grp := fam!.group;
      erng := fam!.ring;
      ccss := fam!.CCSs;
      basis := Basis( erng );

      # apply only on SO(2)
      if not ( IdElementaryCLG( grp ) = [ 1, 2 ] ) then
         TryNextMethod( );
      fi;

      # multiplication for two generators
      if IsEulerRingGenerator( a ) and IsEulerRingGenerator( b ) then
        idCa	:= a!.ccsIdList[ 1 ];
        idCb	:= b!.ccsIdList[ 1 ];
        Ca	:= a!.ccsList[ 1 ];
        Cb	:= b!.ccsList[ 1 ];

        ccs_list := [ ];
        ccs_id_list := [ ];
        coeff_list := [ ];

        if Degree( OrderOfWeylGroup( Ca ) ) = 1 and Degree( OrderOfWeylGroup( Cb ) ) = 1 then
          # two 1-dim case
          ;
        elif Degree( OrderOfWeylGroup( Ca ) ) = 0 and Degree( OrderOfWeylGroup( Cb ) ) = 0 then
          # two 0-dim case
          Add( ccs_list, Ca );
          Add( ccs_id_list, idCa );
          Add( coeff_list, 1 );
        elif ( Degree( OrderOfWeylGroup( Ca ) ) = 1 ) then
          # one 1-dim, one 0-dim case
          Add( ccs_list, Ca );
          Add( ccs_id_list, idCa );
          Add( coeff_list, 1 );
        elif ( Degree( OrderOfWeylGroup( Cb ) ) = 1 ) then
          # one 0-dim, one 1-dim case
          Add( ccs_list, Cb );
          Add( ccs_id_list, idCb );
          Add( coeff_list, 1 );
        fi;

        return NewEulerRingElement( cat,
          rec( fam:= fam,
               ccs_list		:= ccs_list,
               ccs_id_list 	:= ccs_id_list,
               coeff_list 	:= coeff_list   )
        );
      # recursive computation for other cases
      else
        return Sum( ListX( ToSparseList( a ), ToSparseList( b ),
          { x, y } -> ( x[ 2 ] * y[ 2 ] ) *
                      ( basis[ x[ 1 ] ] * basis[ y[ 1 ] ] )
        ) );
      fi;
    end
  );

#############################################################################
##
#O  \*( <a>, <b> )
##
  InstallMethod( \*,
    "multiplication in a Euler ring",
    IsIdenticalObj,
    [ IsEulerRingByCompactLieGroupElement,
      IsEulerRingByCompactLieGroupElement  ],
    function( a, b )
      local fam,		      # family of Euler ring element
            cat,		      # category of Euler ring element
            grp,		      # group
            erng,		      # Euler ring
            ccss,		      # CCSs of G
            basis,	      # basis of Euler ring
            decomp,       # decomposition of direct product
            SO2,          # compact Lie group SO(2)
            Ga,           # Finite group
            idCa,		      # id of CCS a (when a is in the basis )
            idCb,		      # id of CCS b (when b is in the basis )
            idmin,
            Ca,			      # CCS of a (when a is in the basis)
            Cb,			      # CCS of b (when b is in the basis)
            l,			      # mode of the product
            imax,
            ccs_list,		  # ccs list of the product
            ccs_id_list,	# ccs id list of the product
            coeff_list,		# coefficient list of the product
            coeff,		    # a coefficient in the product
            i, j,		      # indices
            Ci, Cj;		    # i-th and j-th CCSs

      fam := FamilyObj( a );
      cat := IsEulerRingByCompactLieGroupElement;

      grp := fam!.group;
      erng := fam!.ring;
      ccss := fam!.CCSs;
      basis := Basis( erng );

      # apply only on SO(2)xGamma where Gamma is a finite group
      if not (IsCompactLieGroup(grp) and HasDirectProductInfo(grp)) then
         TryNextMethod( );
      fi;

      decomp := DirectProductInfo( grp ).groups;
      if not ( Length( decomp ) = 2 ) then
        # check if there are exactly 2 direct product components
        TryNextMethod( );
      elif not ( IdElementaryCLG( decomp[ 1 ] ) = [ 2, 1 ] ) then
        # check if the first component of direct project is SO(2)
        TryNextMethod( );
      elif not IsFinite( decomp[ 2 ] ) then
        # check if the second component of direct project is a finite group
        TryNextMethod( );
      fi;

      SO2 := decomp[ 1 ];
      Ga := decomp[ 2 ];

      # multiplication for two generators
      if IsEulerRingGenerator( a ) and IsEulerRingGenerator( b ) then
        idCa	:= a!.ccsIdList[ 1 ];
        idCb	:= b!.ccsIdList[ 1 ];
        Ca	:= a!.ccsList[ 1 ];
        Cb	:= b!.ccsList[ 1 ];

        ccs_list := [ ];
        ccs_id_list := [ ];
        coeff_list := [ ];

        if Degree( OrderOfWeylGroup( Ca ) ) > 0 and Degree( OrderOfWeylGroup( Cb ) ) > 0 then
          # two 1-dimensional case
          ;
        elif Degree( OrderOfWeylGroup( Ca ) ) = 0 and Degree( OrderOfWeylGroup( Cb ) ) = 0 then
          # two 0-dimensional case
          l := Gcd( idCa[ 1 ], idCb[ 1 ] );
          if IsPosInt( l ) then
            if IsPosInt( idCa[ 1 ] ) and IsPosInt( idCb[ 1 ] ) then
              imax := Minimum( idCa[ 2 ], idCb[ 2 ] );
            elif IsZero( idCa[ 1 ] ) then
              imax := idCb[ 2 ];
            elif IsZero( idCb[ 1 ] ) then
              imax := idCa[ 2 ];
            fi;
          else
            imax := Minimum( idCa[ 2 ], idCb[ 2 ] );
          fi;

          for i in Reversed( [ 1 .. imax ] ) do
            Ci := ccss[ l, i ];
            if ( Degree( OrderOfWeylGroup( Ci ) ) > 0 ) then
              continue;
            fi;
            coeff := nLHnumber( Ci, Ca ) * OrderOfWeylGroup( Ca ) *
                    nLHnumber( Ci, Cb ) * OrderOfWeylGroup( Cb );

            if IsZero( coeff ) then
              continue;
            fi;

            for j in [ 1 .. Size( ccs_list ) ] do
              Cj := ccs_list[ j ];
              coeff := coeff - nLHnumber( Ci, Cj )*coeff_list[ j ];
            od;

            if not IsZero( coeff ) then
              Add( ccs_list, Ci, 1 );
              Add( ccs_id_list, [ l, i ], 1 );
              Add( coeff_list, coeff, 1 );
            fi;
          od;
          coeff_list := ListN( coeff_list,
              List( ccs_list, C -> OrderOfWeylGroup( C ) ), \/ );
          coeff_list := List( coeff_list, LeadingCoefficient );
        elif Degree( OrderOfWeylGroup( Ca ) ) * Degree( OrderOfWeylGroup( Cb ) ) = 0 then
          # one 1-dimensional, one 0-dimensional case
          ;
        fi;

        return NewEulerRingElement( cat,
          rec( fam:= fam,
               ccs_list		:= ccs_list,
               ccs_id_list 	:= ccs_id_list,
               coeff_list 	:= coeff_list   )
        );
      # recursive computation for other cases
      else
        return Sum( ListX( ToSparseList( a ), ToSparseList( b ),
          { x, y } -> ( x[ 2 ] * y[ 2 ] ) *
                      ( basis[ x[ 1 ] ] * basis[ y[ 1 ] ] )
        ) );
      fi;
    end
  );

#############################################################################
##
#O  MaximalCCSs( <a> )
##
  InstallMethod( MaximalCCSs,
    "",
    [ IsEulerRingElement ],
    function( a )
      local A,
            G,
            ccs_list,
            C,
            n;

      A := FamilyObj( a )!.ring;

      ccs_list := ShallowCopy( a!.ccsList );
      C := One( A )!.ccsList[ 1 ];
      n := Position( ccs_list, C );
      if not ( n = fail ) then
        Remove( ccs_list, n );
      fi;

      return MaximalElements( ccs_list );
    end
  );


##  Part 2: Euler ring

#############################################################################
##
#U  NewEulerRing( IsEulerRingByCompactLieGroup, <r> )
##
  InstallMethod( NewEulerRing,
    "create a Euler ring induced by a small group",
    [ IsEulerRingByCompactLieGroup,
      IsRecord ],
    function( filt, r )
      local grp,		# the group
            ccss,	# conjugacy classes of subgroups
            d,		# dimension of the module (ring)
            fam_elmt,	# family of Euler ring element
            rep,	# representation of Euler ring
            erng,		# the Euler ring
            zero;	# zero of the Euler ring

      # extract info of <G>
      grp		:= r.group;
      ccss	:= ConjugacyClassesSubgroups( grp );
      d         := Size( ccss );
      fam_elmt	:= ElementsFamily( r.fam );

      # objectify the Euler ring
      rep := IsComponentObjectRep and IsAttributeStoringRep;
      erng := Objectify( NewType( r.fam, filt and rep ), rec( ) );
      SetIsWholeFamily( erng, true );
      SetString( erng, StringFormatted( "EulerRing( {} )", String( grp ) ) );

      # assign values to instance variables of the family of element
      fam_elmt!.group		:= grp;
      fam_elmt!.CCSs		:= ccss;
      fam_elmt!.dimension	:= d;
      fam_elmt!.ring	:= erng;

      # other attributes related to its module structure
      SetLeftActingDomain( erng, Integers );

      # other attributes related to its Euler ring sturcture
      SetUnderlyingGroup( erng, grp );

      return erng;
    end
  );

#############################################################################
##
#U  NewEulerRingByCompactLieGroupBasis( 
#U      IsEulerRingByCompactLieGroup, <r> )
##
  InstallMethod( NewEulerRingByCompactLieGroupBasis,
    "constructs basis of a Euler ring induced by a compact Lie group",
    [ IsEulerRingByCompactLieGroup, IsRecord ],
    function( filt, r )
      local fam,
            cat,
            rep,
            A,
            G,
            basis;

      A := r.ring;
      G := UnderlyingGroup( A );

      fam := FamilyObj( A );
      cat := CategoryCollections( IsEulerRingByCompactLieGroupElement );
      rep := IsComponentObjectRep and IsAttributeStoringRep;
      
      basis := Objectify( NewType( fam, cat and rep ), rec( ) );
      SetString( basis, StringFormatted( "Basis( {} )", String( A ) ) );
      SetIsEulerRingByCompactLieGroupBasis( basis, true );

      return( basis );
    end
  );

#############################################################################
##
#O  \[\,\]( <basis>, <l>, <j> )
##
  InstallOtherMethod( \[\,\],
    "",
    [ CategoryCollections( IsEulerRingByCompactLieGroupElement ) and
      IsEulerRingByCompactLieGroupBasis, IsInt, IsInt ],
    function( basis, l, j )
      local fam,
            G,
            CCSs,
            C;

      fam := ElementsFamily( FamilyObj( basis ) );
      G := fam!.group;
      CCSs := ConjugacyClassesSubgroups( G );
      C := CCSs[ l, j ];

      return NewEulerRingElement(
        IsEulerRingByCompactLieGroupElement,
        rec( fam := fam,
             ccs_list		:= [ CCSs[ l, j ] ],
             ccs_id_list	:= [ [ l, j ] ],
             coeff_list		:= [ 1 ] )
      );
    end
  );

#############################################################################
##
#A  EulerRing( <G> )
##
  InstallMethod( EulerRing,
    "This attribute contains the Euler ring induced by compact Lie group <G>",
    [ IsCompactLieGroup ],
    function( G )
      local CCSs,	# CCSs of <G>
            d,		# size of <CCSs>
            fam_elmt,   # family of Euler ring elements
            cat_elmt,	# category of Euler ring elements
            fam,	# family of the Euler ring
	          cat,	# category of the Euler ring
            A,		# the Euler ring
            zero,	# zero of the Euler ring
            basis;	# basis of the module (ring)

      # extract info of <G>
      CCSs	:= ConjugacyClassesSubgroups( G );
      d		:= Size( CCSs );

      # family and category of Euler ring element
      cat_elmt := IsEulerRingByCompactLieGroupElement;
      fam_elmt := NewFamily(
        StringFormatted( "EulerRing( {} )Family", String( G ) ),
        cat_elmt
      );

      # family and category of the Euler ring
      cat := IsEulerRingByCompactLieGroup;
      fam := CollectionsFamily( fam_elmt );

      # construct the Euler ring
      A := NewEulerRing(
        cat,
        rec( group	:= G,
             fam	:= fam )
      );

      # generate zero of the Euler ring
      zero := NewEulerRingElement(
        cat_elmt,
        rec( fam		:= fam_elmt,
             ccs_list		:= [ ],
             ccs_id_list	:= [ ],
             coeff_list		:= [ ]       )
      );

      # generate the basis of the Euler ring
      basis := NewEulerRingByCompactLieGroupBasis(
        IsEulerRingByCompactLieGroup,
        rec( ring := A )
      );

      # other attributes related to its module structure
      SetDimension( A, d );
      SetIsFiniteDimensional( A, false );
      SetBasis( A, basis );

      # other attributes related to its Euler ring sturcture
      SetZeroAttr( fam_elmt, zero );
      SetZeroAttr( A, zero );
      SetOneImmutable( fam_elmt, basis[ 0, NumberOfZeroModeClasses( CCSs ) ] );
      SetOneImmutable( A, basis[ 0, NumberOfZeroModeClasses( CCSs ) ] );
      SetGeneratorsOfRing( A, basis );

      return A;
    end
  );


##  Part 3: Other Aspects

#############################################################################
##
#A  BasicDegree( <chi> )
##
  # InstallMethod( BasicDegree,
  #   "return the Basic Degree associated to compact Lie group character <chi>",
  #   [ IsCompactLieGroupCharacter ],
  #   function( chi )
  #     local G,			# group
  #           CCSs,		# CCSs
  #           A,			# Euler ring
  #           orbts,		# orbit types
  #           coeff,		# coefficent
  #           j,			# index
  #           Oi, Oj,		# orbit types
  #           ccs_list,		# ccs_list of the basic degree
  #           ccs_id_list,	# indices of basic degree
  #           coeff_list;		# coefficient of basic degree

  #     G := UnderlyingGroup( chi );
  #     CCSs := ConjugacyClassesSubgroups( G );
  #     A := EulerRing( G );
  #     orbts := OrbitTypes( chi );

  #     ccs_list := [ ];
  #     ccs_id_list := [ ];
  #     coeff_list := [ ];

  #     for Oi in Reversed( orbts ) do
  #       if ( Degree( OrderOfWeylGroup( Oi ) ) > 0 ) then
  #         continue;
  #       fi;

  #       coeff := (-1)^DimensionOfFixedSet( chi, Oi );
  #       for j in [ 1 .. Size( ccs_list ) ] do
  #         Oj := ccs_list[ j ];
  #         coeff := coeff - coeff_list[ j ]*nLHnumber( Oi, Oj );
  #       od;

  #       if not IsZero( coeff ) then
  #         Add( ccs_list, Oi, 1 );
  #         Add( ccs_id_list, IdCCS( Oi ), 1 );
  #         Add( coeff_list, coeff, 1 );
  #       fi;
  #     od;

  #     coeff_list := ListN( coeff_list,
  #         List( ccs_list, OrderOfWeylGroup ), \/ );
  #     coeff_list := List( coeff_list, LeadingCoefficient );

  #     return NewEulerRingElement(
  #       IsEulerRingByCompactLieGroupElement,
  #       rec( fam		:= ElementsFamily( FamilyObj( A ) ),
  #            ccs_list		:= ccs_list,
  #            ccs_id_list	:= ccs_id_list,
  #            coeff_list		:= coeff_list                       )
  #     );
  #   end
  # );


##  Appendix: Print, View and Display

#############################################################################
##
#A  ViewString( <A> )
##
  InstallMethod( ViewString,
    "view string of a Euler ring",
    [ IsEulerRing ],
    A -> StringFormatted( "Erng( {} )", ViewString( UnderlyingGroup( A ) ) )
  );

#############################################################################
##
#O  ViewObj( <A> )
##
  InstallMethod( ViewObj,
    "view a Euler ring",
    [ IsEulerRing ],
    function( A )
      Print( ViewString( A ) );
    end
  );

#############################################################################
##
#O  PrintObj( <A> )
##
  InstallMethod( PrintObj,
    "print a Euler ring",
    [ IsEulerRing ],
    function( A )
      Print( String( A ) );
    end
  );

#############################################################################
##
#O  ViewString( <basis> )
##
  InstallMethod( ViewString,
    "view string of basis of Euler ring induced by a compact Lie group",
    [ IsEulerRingByCompactLieGroupBasis ],
    function( basis )
      local A,
            fam_elmt;

      fam_elmt := ElementsFamily( FamilyObj( basis ) );
      A := fam_elmt!.ring;

      return StringFormatted( "Basis( {} )", ViewString( A ) );
    end
  );


#############################################################################
##
#E  EulerRing.gi . . . . . . . . . . . . . . . . . . . . . . . . ends here
