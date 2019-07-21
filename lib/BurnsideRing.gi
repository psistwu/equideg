#############################################################################
##
##  BurnsideRing.gi	GAP Package `EquiDeg'			    Haopin Wu
##
#Y  Copyright (C) 2017-2018, Haopin Wu
#Y  Department of Mathematics, National Tsing Hua University, Taiwan
##
##  This file contains implementations for procedures
##  related to Burnside ring.
##

##  Part 1: Burnside ring element

#############################################################################
##
#U  NewBurnsideRingElement( <filt>, <r> )
##
  InstallMethod( NewBurnsideRingElement,
    "constructs Burnside ring element",
    [ IsBurnsideRingByFiniteGroupElement and
      IsBurnsideRingByCompactLieGroupElement,
      IsRecord ],
    function( filt, r )
      local fam,
            cat,
            rep;

            fam := r.fam;
            cat := filt;
            rep := IsBurnsideRingElementRep;

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
    "string of a Burnside ring element",
    [ IsBurnsideRingElement ],
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
    "view string of a Burnside ring element",
    [ IsBurnsideRingElement ],
    function( a )
      local A;     # the Burnside ring

      A := FamilyObj( a )!.burnsideRing;

      return Concatenation( String( a ), " in ", ViewString( A ) );
    end
  );

#############################################################################
##
#O  PrintObj( <a> )
##
  InstallMethod( PrintObj,
    "display a Burnside ring element",
    [ IsBurnsideRingElement ],
    function( a )
      local i,			# index
            ccs,
            ccs_id,		# id of CCS
            ccs_id_formatted,	# id of CCS
            coeff,		# coefficient
            ccs_name,		# name of CCS
            str;		# name string

      Print( ViewString( FamilyObj( a )!.burnsideRing ), " element:\n" );
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
    "return LaTeX typesetting of an element in the Burnside ring",
    [ IsBurnsideRingElement ],
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
    "length of a Burnside ring element",
    [ IsBurnsideRingElement ],
    a -> Length( a!.ccsList )
  );

#############################################################################
##
#O  ToSparseList( <a> )
##
  InstallMethod( ToSparseList,
    "convert a Burnside ring element to a sparse list",
    [ IsBurnsideRingElement ],
    a -> ListN( a!.ccsIdList, a!.coeffList, { x, y } -> [ x, y ] )
  );

#############################################################################
##
#O  ToDenseList( <a> )
##
  InstallMethod( ToDenseList,
    "convert a Burnside ring element to a dense list",
    [ IsBurnsideRingByFiniteGroupElement ],
    function( a )
      local list,	# the return list
            dim;	# dimension of the Burnside module (ring)

      dim := FamilyObj( a )!.dimension;
      list := ZeroOp( [ 1 .. dim ] );
      list{ a!.ccsIdList } := a!.coeffList;

      return list;
    end
  );

#############################################################################
##
#O  ZeroOp( <a> )
##
  InstallMethod( ZeroOp,
    "additive identity of a Burnside ring",
    [ IsBurnsideRingElement ],
    function( a )
      return ZeroAttr( FamilyObj( a ) );
    end
  );

#############################################################################
##
#O  OneOp( <a> )
##
  InstallMethod( OneOp,
    "multiplicative identity of a Burnside ring",
    [ IsBurnsideRingElement ],
    function( a )
      return OneAttr( FamilyObj( a ) );
    end
  );

#############################################################################
##
#O  AdditiveInverseOp( <a> )
##
  InstallMethod( AdditiveInverseOp,
    "additive inverse in a Burnside ring",
    [ IsBurnsideRingElement ],
    function( a )
      local fam,
            cat,
            rep,
            addinv;

      fam := FamilyObj( a );
      cat := First( EquiDeg_BRNG_ELMT_CAT_LIST, filt -> filt( a ) );

      addinv := NewBurnsideRingElement( cat,
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
    "identical relation in a Burnside ring",
    IsIdenticalObj,
    [ IsBurnsideRingElement, IsBurnsideRingElement ],
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
    "addition in a Burnside ring",
    IsIdenticalObj,
    [ IsBurnsideRingElement, IsBurnsideRingElement ],
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
      cat := First( EquiDeg_BRNG_ELMT_CAT_LIST, filt -> filt( a ) );

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

      sum := NewBurnsideRingElement( cat,
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
    "scalar multiplication in a Burnside ring",
    [ IsInt, IsBurnsideRingElement ],
    function( n, a )
      local fam,
            cat,
            rep,
            mul;	# result

      fam := FamilyObj( a );
      cat := First( EquiDeg_BRNG_ELMT_CAT_LIST, filt -> filt( a ) );
      rep := IsBurnsideRingElementRep;

      if IsZero( n ) then
        return Zero( a );
      else
        return NewBurnsideRingElement(
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
    "multiplication in a Burnside ring",
    IsIdenticalObj,
    [ IsBurnsideRingByFiniteGroupElement,
      IsBurnsideRingByFiniteGroupElement  ],
    function( a, b )
      local fam,		# family of Burnside ring element
            cat,		# category of Burnside ring element
            G,			# group
            A,			# Burnside ring
            CCSs,		# CCSs of G
            basis,		# basis of Burnside ring
            idCa,		# id of CCS a (when a is in the basis )
            idCb,		# id of CCS b (when b is in the basis )
            Ca,			# CCS of a (when a is in the basis)
            Cb,			# CCS of b (when b is in the basis)
            ccs_list,		# ccs list of the product
            ccs_id_list,	# ccs id list of the product
            coeff_list,		# coefficient list of the product
            coeff,		# a coefficient in the product
            i, j,		# indices
            Ci, Cj;		# i-th and j-th CCSs

      fam := FamilyObj( a );
      cat := IsBurnsideRingByFiniteGroupElement;

      G := fam!.group;
      A := fam!.burnsideRing;
      CCSs := fam!.CCSs;
      basis := Basis( A );

      if IsBurnsideRingGenerator( a ) and IsBurnsideRingGenerator( b ) then
        idCa	:= a!.ccsIdList[ 1 ];
        idCb	:= b!.ccsIdList[ 1 ];
        Ca	:= a!.ccsList[ 1 ];
        Cb	:= b!.ccsList[ 1 ];

        ccs_list := [ ];
        ccs_id_list := [ ];
        coeff_list := [ ];

        for i in Reversed( [ 1 .. Minimum( idCa, idCb ) ] ) do
          Ci := CCSs[ i ];
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
            Add( ccs_id_list, i, 1 );
            Add( coeff_list, coeff, 1 );
          fi;
        od;
        coeff_list := ListN( coeff_list, List( ccs_list, OrderOfWeylGroup ), \/ );
        coeff_list := List( coeff_list, LeadingCoefficient );

        return NewBurnsideRingElement( cat,
          rec( fam		:= fam,
               ccs_list		:= ccs_list,
               ccs_id_list 	:= ccs_id_list,
               coeff_list 	:= coeff_list   )
        );
      else
        return Sum( ListX( ToSparseList( a ), ToSparseList( b ),
          { x, y } -> x[ 2 ] * y[ 2 ] * ( basis[ x[ 1 ] ] * basis[ y[ 1 ] ] )
        ) );
      fi;
    end
  );

#############################################################################
##
#O  \*( <a>, <b> )
##
  InstallMethod( \*,
    "multiplication in a Burnside ring",
    IsIdenticalObj,
    [ IsBurnsideRingByCompactLieGroupElement,
      IsBurnsideRingByCompactLieGroupElement  ],
    function( a, b )
      local fam,		# family of Burnside ring element
            cat,		# category of Burnside ring element
            G,			# group
            A,			# Burnside ring
            CCSs,		# CCSs of G
            basis,		# basis of Burnside ring
            idCa,		# id of CCS a (when a is in the basis )
            idCb,		# id of CCS b (when b is in the basis )
            idmin,
            Ca,			# CCS of a (when a is in the basis)
            Cb,			# CCS of b (when b is in the basis)
            l,			# mode of the product
            imax,
            ccs_list,		# ccs list of the product
            ccs_id_list,	# ccs id list of the product
            coeff_list,		# coefficient list of the product
            coeff,		# a coefficient in the product
            i, j,		# indices
            Ci, Cj;		# i-th and j-th CCSs

      fam := FamilyObj( a );
      cat := IsBurnsideRingByCompactLieGroupElement;

      G := fam!.group;
      A := fam!.burnsideRing;
      CCSs := fam!.CCSs;
      basis := Basis( A );

      if IsBurnsideRingGenerator( a ) and IsBurnsideRingGenerator( b ) then
        idCa	:= a!.ccsIdList[ 1 ];
        idCb	:= b!.ccsIdList[ 1 ];
        Ca	:= a!.ccsList[ 1 ];
        Cb	:= b!.ccsList[ 1 ];

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

        ccs_list := [ ];
        ccs_id_list := [ ];
        coeff_list := [ ];

        for i in Reversed( [ 1 .. imax ] ) do
          Ci := CCSs[ l, i ];
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

        return NewBurnsideRingElement( cat,
          rec( fam:= fam,
               ccs_list		:= ccs_list,
               ccs_id_list 	:= ccs_id_list,
               coeff_list 	:= coeff_list   )
        );
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
    [ IsBurnsideRingElement ],
    function( a )
      local A,
            G,
            ccs_list,
            C,
            n;

      A := FamilyObj( a )!.burnsideRing;

      ccs_list := ShallowCopy( a!.ccsList );
      C := One( A )!.ccsList[ 1 ];
      n := Position( ccs_list, C );
      if not ( n = fail ) then
        Remove( ccs_list, n );
      fi;

      return MaximalElements( ccs_list );
    end
  );


##  Part 2: Burnside ring

#############################################################################
##
#U  NewBurnsideRing( IsBurnsideRingByFiniteGroup and
#U      IsBurnsideRingByCompactLieGroup, <r> )
##
  InstallMethod( NewBurnsideRing,
    "create a Burnside ring induced by a small group",
    [ IsBurnsideRingByFiniteGroup and IsBurnsideRingByCompactLieGroup,
      IsRecord ],
    function( filt, r )
      local G,		# the group
            CCSs,	# conjugacy classes of subgroups
            d,		# dimension of the module (ring)
            fam_elmt,	# family of Burnside ring element
            rep,	# representation of Burnside ring
            A,		# the Burnside ring
            zero;	# zero of the Burnside ring

      # extract info of <G>
      G		:= r.group;
      CCSs	:= ConjugacyClassesSubgroups( G );
      d         := Size( CCSs );
      fam_elmt	:= ElementsFamily( r.fam );

      # objectify the Burnside ring
      rep := IsComponentObjectRep and IsAttributeStoringRep;
      A := Objectify( NewType( r.fam, filt and rep ), rec( ) );
      SetIsWholeFamily( A, true );
      SetString( A, StringFormatted( "BurnsideRing( {} )", String( G ) ) );

      # assign values to instance variables of the family of element
      fam_elmt!.group		:= G;
      fam_elmt!.CCSs		:= CCSs;
      fam_elmt!.dimension	:= d;
      fam_elmt!.burnsideRing	:= A;

      # other attributes related to its module structure
      SetLeftActingDomain( A, Integers );

      # other attributes related to its Burnside ring sturcture
      SetUnderlyingGroup( A, G );

      return A;
    end
  );

#############################################################################
##
#A  BurnsideRing( <G> )
##
  InstallMethod( BurnsideRing,
    "This attribute contains the Burnside ring induced by finite group <G>",
    [ IsGroup and IsFinite ],
    function( G )
      local CCSs,	# CCSs of <G>
            d,		# size of <CCSs>
            fam_elmt,   # family of Burnside ring elements
            cat_elmt,	# category of Burnside ring elements
            fam,	# family of the Burnside ring
	    cat,	# category of the Burnside ring
            A,		# the Burnside ring
            zero,	# zero of the Burnside ring
            basis;	# basis of the module (ring)

      # extract info of <G>
      CCSs	:= ConjugacyClassesSubgroups( G );
      d		:= Size( CCSs );

      # family and category of Burnside ring element
      cat_elmt := IsBurnsideRingByFiniteGroupElement;
      fam_elmt := NewFamily(
        StringFormatted( "BurnsideRing( {} )Family", String( G ) ),
        cat_elmt
      );

      # family and category of the Burnside ring
      cat := IsBurnsideRingByFiniteGroup;
      fam := CollectionsFamily( fam_elmt );

      # construct the Burnside ring
      A := NewBurnsideRing(
        cat,
        rec( group	:= G,
             fam	:= fam )
      );

      # generate zero of the Burnside ring
      zero := NewBurnsideRingElement(
        cat_elmt,
        rec( fam		:= fam_elmt,
             ccs_list		:= [ ],
             ccs_id_list	:= [ ],
             coeff_list		:= [ ]       )
      );

      # generate the basis of the Burnside ring
      basis := List( [ 1 .. d ],
        i -> NewBurnsideRingElement(
          cat_elmt,
          rec( fam		:= fam_elmt,
               ccs_list		:= [ CCSs[ i ] ],
               ccs_id_list	:= [ i ],
               coeff_list	:= [ 1 ]          )
        )
      );

      # other attributes related to its module structure
      SetDimension( A, d );
      SetIsFiniteDimensional( A, true );
      SetBasis( A, basis );

      # other attributes related to its Burnside ring sturcture
      SetZeroAttr( fam_elmt, zero );
      SetZeroAttr( A, zero );
      SetOneImmutable( fam_elmt, basis[ d ] );
      SetOneImmutable( A, basis[ d ] );
      SetGeneratorsOfRing( A, basis );

      return A;
    end
  );

#############################################################################
##
#U  NewBurnsideRingByCompactLieGroupBasis( 
#U      IsBurnsideRingByCompactLieGroup, <r> )
##
  InstallMethod( NewBurnsideRingByCompactLieGroupBasis,
    "constructs basis of a Burnside ring induced by a compact Lie group",
    [ IsBurnsideRingByCompactLieGroup, IsRecord ],
    function( filt, r )
      local fam,
            cat,
            rep,
            A,
            G,
            basis;

      A := r.burnside_ring;
      G := UnderlyingGroup( A );

      fam := FamilyObj( A );
      cat := CategoryCollections( IsBurnsideRingByCompactLieGroupElement );
      rep := IsComponentObjectRep and IsAttributeStoringRep;
      
      basis := Objectify( NewType( fam, cat and rep ), rec( ) );
      SetString( basis, StringFormatted( "Basis( {} )", String( A ) ) );
      SetIsBurnsideRingByCompactLieGroupBasis( basis, true );

      return( basis );
    end
  );

#############################################################################
##
#O  \[\]( <basis>, <l>, <j> )
##
  InstallOtherMethod( \[\],
    "",
    [ CategoryCollections( IsBurnsideRingByCompactLieGroupElement ) and
      IsBurnsideRingByCompactLieGroupBasis, IsInt, IsInt ],
    function( basis, l, j )
      local fam,
            G,
            CCSs,
            C;

      fam := ElementsFamily( FamilyObj( basis ) );
      G := fam!.group;
      CCSs := ConjugacyClassesSubgroups( G );
      C := CCSs[ l, j ];
      if ( Degree( OrderOfWeylGroup( C ) ) > 0 ) then
        return fail;
      fi;

      return NewBurnsideRingElement(
        IsBurnsideRingByCompactLieGroupElement,
        rec( fam := fam,
             ccs_list		:= [ CCSs[ l, j ] ],
             ccs_id_list	:= [ [ l, j ] ],
             coeff_list		:= [ 1 ] )
      );
    end
  );

#############################################################################
##
#A  BurnsideRing( <G> )
##
  InstallMethod( BurnsideRing,
    "This attribute contains the Burnside ring induced by compact Lie group <G>",
    [ IsCompactLieGroup ],
    function( G )
      local CCSs,	# CCSs of <G>
            d,		# size of <CCSs>
            fam_elmt,   # family of Burnside ring elements
            cat_elmt,	# category of Burnside ring elements
            fam,	# family of the Burnside ring
	    cat,	# category of the Burnside ring
            A,		# the Burnside ring
            zero,	# zero of the Burnside ring
            basis;	# basis of the module (ring)

      # extract info of <G>
      CCSs	:= ConjugacyClassesSubgroups( G );
      d		:= Size( CCSs );

      # family and category of Burnside ring element
      cat_elmt := IsBurnsideRingByCompactLieGroupElement;
      fam_elmt := NewFamily(
        StringFormatted( "BurnsideRing( {} )Family", String( G ) ),
        cat_elmt
      );

      # family and category of the Burnside ring
      cat := IsBurnsideRingByCompactLieGroup;
      fam := CollectionsFamily( fam_elmt );

      # construct the Burnside ring
      A := NewBurnsideRing(
        cat,
        rec( group	:= G,
             fam	:= fam )
      );

      # generate zero of the Burnside ring
      zero := NewBurnsideRingElement(
        cat_elmt,
        rec( fam		:= fam_elmt,
             ccs_list		:= [ ],
             ccs_id_list	:= [ ],
             coeff_list		:= [ ]       )
      );

      # generate the basis of the Burnside ring
      basis := NewBurnsideRingByCompactLieGroupBasis(
        IsBurnsideRingByCompactLieGroup,
        rec( burnside_ring := A )
      );

      # other attributes related to its module structure
      SetDimension( A, d );
      SetIsFiniteDimensional( A, false );
      SetBasis( A, basis );

      # other attributes related to its Burnside ring sturcture
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
  InstallMethod( BasicDegree,
    "return the basic degree associated to finite group character <chi>",
    [ IsCharacter ],
    function( chi )
      local G,			# group
            CCSs,		# CCSs
            A,			# Burnside ring
            orbts,		# orbit types
            coeff,		# coefficent
            j,			# index
            n,			# dimension factor
            Oi, Oj,		# orbit types
            ccs_list,		# CCS list of basic degree
            ccs_id_list,	# CCS id list of basic degree
            coeff_list;		# coefficient list of basic degree

      if not IsIrreducibleCharacter( chi ) then
        TryNextMethod( );
      fi;

      G := UnderlyingGroup( chi );
      CCSs := ConjugacyClassesSubgroups( G );
      A := BurnsideRing( G );
      orbts := OrbitTypes( chi );

      if not ( SchurIndicator( chi, 2 ) = 1 ) then
        return OneImmutable( A );
      fi;

      ccs_list := [ ];
      ccs_id_list := [ ];
      coeff_list := [ ];

      for Oi in Reversed( orbts ) do
        coeff := (-1)^DimensionOfFixedSet( chi, Oi );
        for j in [ 1 .. Size( ccs_list ) ] do
          Oj := ccs_list[ j ];
          coeff := coeff - coeff_list[ j ]*nLHnumber( Oi, Oj );
        od;

        if not IsZero( coeff ) then
          Add( ccs_list, Oi, 1 );
          Add( ccs_id_list, IdCCS( Oi ), 1 );
          Add( coeff_list, coeff, 1 );
        fi;
      od;

      coeff_list := ListN( coeff_list,
          List( ccs_list, OrderOfWeylGroup ), \/ );
      coeff_list := List( coeff_list, LeadingCoefficient );

      return NewBurnsideRingElement(
        IsBurnsideRingByFiniteGroupElement,
        rec( fam		:= ElementsFamily( FamilyObj( A ) ),
             ccs_list		:= ccs_list,
             ccs_id_list	:= ccs_id_list,
             coeff_list		:= coeff_list                       )
      );
    end
  );

#############################################################################
##
#A  BasicDegree( <chi> )
##
  InstallMethod( BasicDegree,
    "return the Basic Degree associated to compact Lie group character <chi>",
    [ IsCompactLieGroupCharacter ],
    function( chi )
      local G,			# group
            CCSs,		# CCSs
            A,			# Burnside ring
            orbts,		# orbit types
            coeff,		# coefficent
            j,			# index
            Oi, Oj,		# orbit types
            ccs_list,		# ccs_list of the basic degree
            ccs_id_list,	# indices of basic degree
            coeff_list;		# coefficient of basic degree

      G := UnderlyingGroup( chi );
      CCSs := ConjugacyClassesSubgroups( G );
      A := BurnsideRing( G );
      orbts := OrbitTypes( chi );

      ccs_list := [ ];
      ccs_id_list := [ ];
      coeff_list := [ ];

      for Oi in Reversed( orbts ) do
        if ( Degree( OrderOfWeylGroup( Oi ) ) > 0 ) then
          continue;
        fi;

        coeff := (-1)^DimensionOfFixedSet( chi, Oi );
        for j in [ 1 .. Size( ccs_list ) ] do
          Oj := ccs_list[ j ];
          coeff := coeff - coeff_list[ j ]*nLHnumber( Oi, Oj );
        od;

        if not IsZero( coeff ) then
          Add( ccs_list, Oi, 1 );
          Add( ccs_id_list, IdCCS( Oi ), 1 );
          Add( coeff_list, coeff, 1 );
        fi;
      od;

      coeff_list := ListN( coeff_list,
          List( ccs_list, OrderOfWeylGroup ), \/ );
      coeff_list := List( coeff_list, LeadingCoefficient );

      return NewBurnsideRingElement(
        IsBurnsideRingByCompactLieGroupElement,
        rec( fam		:= ElementsFamily( FamilyObj( A ) ),
             ccs_list		:= ccs_list,
             ccs_id_list	:= ccs_id_list,
             coeff_list		:= coeff_list                       )
      );
    end
  );


##  Appendix: Print, View and Display

#############################################################################
##
#A  ViewString( <A> )
##
  InstallMethod( ViewString,
    "view string of a Burnside ring",
    [ IsBurnsideRing ],
    A -> StringFormatted( "Brng( {} )", ViewString( UnderlyingGroup( A ) ) )
  );

#############################################################################
##
#O  ViewObj( <A> )
##
  InstallMethod( ViewObj,
    "view a Burnside ring",
    [ IsBurnsideRing ],
    function( A )
      Print( ViewString( A ) );
    end
  );

#############################################################################
##
#O  PrintObj( <A> )
##
  InstallMethod( PrintObj,
    "print a Burnside ring",
    [ IsBurnsideRing ],
    function( A )
      Print( String( A ) );
    end
  );

#############################################################################
##
#O  ViewString( <basis> )
##
  InstallMethod( ViewString,
    "view string of basis of Burnside ring induced by a compact Lie group",
    [ IsBurnsideRingByCompactLieGroupBasis ],
    function( basis )
      local A,
            fam_elmt;

      fam_elmt := ElementsFamily( FamilyObj( basis ) );
      A := fam_elmt!.burnsideRing;

      return StringFormatted( "Basis( {} )", ViewString( A ) );
    end
  );


#############################################################################
##
#E  BurnsideRing.gi . . . . . . . . . . . . . . . . . . . . . . . . ends here
