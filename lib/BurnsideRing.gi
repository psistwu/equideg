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
#A  Length( <a> )
##
# InstallMethod( Length,
#   "length of the summand in a Burnside ring element",
#   [ IsBurnsideRingElement and IsBurnsideRingBySmallGroupElementRep ],
#   a -> Length( a!.ccsIndices )
# );

#############################################################################
##
#O  ToSparseList( <a> )
##
  InstallMethod( ToSparseList,
    "convert a Burnside ring element to a sparse list",
    [ IsBurnsideRingElement and IsBurnsideRingBySmallGroupElementRep ],
    a -> ListN( a!.ccsIndices, a!.coefficients, { x, y } -> [ x, y ] )
  );

#############################################################################
##
#O  ToDenseList( <a> )
##
  InstallMethod( ToDenseList,
    "convert a Burnside ring element to a dense list",
    [ IsBurnsideRingElement and IsBurnsideRingBySmallGroupElementRep ],
    function( a )
      local list,   # the return list
            fam,    # the family of the Burnside ring element
            dim;    # dimension of the Burnside module (ring)

      fam := FamilyObj( a );
      dim := fam!.dimension;
      list := ZeroOp( [ 1 .. dim ] );
      list{ a!.ccsIndices } := a!.coefficients;

      return list;
    end
  );

#############################################################################
##
#O  ZeroMutable( <a> )
##
  InstallMethod( ZeroMutable,
    "additive identity of a Burnside ring",
    [ IsBurnsideRingElement and IsBurnsideRingBySmallGroupElementRep ],
    function( a )
      return ZeroImmutable( FamilyObj( a ) );
    end
  );

#############################################################################
##
#O  OneMutable( <a> )
##
  InstallMethod( OneMutable,
    "multiplicative identity of a Burnside ring",
    [ IsBurnsideRingElement and IsBurnsideRingBySmallGroupElementRep ],
    function( a )
      return OneImmutable( FamilyObj( a ) );
    end
  );

#############################################################################
##
#O  AdditiveInverseMutable( <a> )
##
  InstallMethod( AdditiveInverseMutable,
    "additive inverse in a Burnside ring",
    [ IsBurnsideRingElement and IsBurnsideRingBySmallGroupElementRep ],
    function( a )
      local fam,
            minusa;

      fam := FamilyObj( a );

      minusa := Objectify(
        NewType( fam, IsBurnsideRingElement and
            IsBurnsideRingBySmallGroupElementRep ),
            rec( ccss         :=  a!.ccss,
                 ccsIndices   :=  a!.ccsIndices,
                 coefficients := -a!.coefficients )

      );
      SetLength( minusa, Length( a ) );

      return minusa;
    end
  );

#############################################################################
##
#O  \=( <a>, <b> )
##
  InstallMethod( \=,
    "identical relation in a Burnside ring",
    IsIdenticalObj,
    [ IsBurnsideRingElement and IsBurnsideRingBySmallGroupElementRep,
      IsBurnsideRingElement and IsBurnsideRingBySmallGroupElementRep ],
    function( a, b )
      return ( a!.ccss         = b!.ccss         ) and
             ( a!.ccsIndices   = b!.ccsIndices   ) and
             ( a!.coefficients = b!.coefficients );
    end
  );

#############################################################################
##
#O  \+( <a>, <b> )
##
  InstallMethod( \+,
    "addition in a Burnside ring",
    IsIdenticalObj,
    [ IsBurnsideRingElement and IsBurnsideRingBySmallGroupElementRep,
      IsBurnsideRingElement and IsBurnsideRingBySmallGroupElementRep ],
    function( a, b )
      local sum_dense_list,
            fam,
            sum_ccs_list,
            sum_ccs_index_list,
            sum_coefficient_list,
            aplusb;

      fam := FamilyObj( a );

      sum_dense_list       := ToDenseList( a ) + ToDenseList( b );
      sum_ccs_index_list   := PositionsProperty( sum_dense_list,
                              x -> not IsZero( x ) );
      sum_ccs_list         := fam!.ccss{ sum_ccs_index_list };
      sum_coefficient_list := sum_dense_list{ sum_ccs_index_list };

      aplusb := Objectify(
        NewType( fam,
                 IsBurnsideRingElement and
                 IsBurnsideRingBySmallGroupElementRep ),
            rec( ccss         := sum_ccs_list,
                 ccsIndices   := sum_ccs_index_list,
                 coefficients := sum_coefficient_list )
      );
      SetLength( aplusb, Length( sum_ccs_index_list ) );

      return aplusb;
    end
  );

#############################################################################
##
#O  \*( <n>, <a> )
##
  InstallMethod( \*,
    "scalar multiplication in a Burnside ring",
    [ IsInt, IsBurnsideRingElement and IsBurnsideRingBySmallGroupElementRep ],
    function( n, a )
      local fam,
            na;		# result

      fam := FamilyObj( a );

      if IsZero( n ) then
        na := Zero( a );
      else
        na := Objectify(
          NewType( fam, IsBurnsideRingElement and
              IsBurnsideRingBySmallGroupElementRep ),
              rec( ccss         := a!.ccss,
                   ccsIndices   := a!.ccsIndices,
                   coefficients := n*a!.coefficients )
        );
        SetLength( na, Length( a ) );
      fi;

      return na;
    end
  );

#############################################################################
##
#O  \*( <a>, <b> )
##
  InstallMethod( \*,
    "multiplication in a Burnside ring",
    IsIdenticalObj,
    [ IsBurnsideRingElement and IsBurnsideRingBySmallGroupElementRep,
      IsBurnsideRingElement and IsBurnsideRingBySmallGroupElementRep ],
    function( a, b )
      local fam,		# family of Burnside ring elements
            G,			# group
            ccs_list,		# CCSs
            A,			# Burnside ring
            basis,		# basis of Burnside ring
            indCa,		# index of CCS a (when a is in the basis )
            indCb,		# index of CCS b (when b is in the basis )
            Ca,			# CCS of a (when a is in the basis)
            Cb,			# CCS of b (when b is in the basis)
            len,		# length of the product
            ab_ccs_list,	# ccs list of the product
            ab_ccs_index_list,	# ccs index list of the product
            ab_coeff_list,	# coefficient list of the product
            coeff,		# a coefficient in the product
            i, j,		# indices
            Ci, Cj;		# i-th and j-th CCSs

      fam := FamilyObj( a );
      G := fam!.group;
      A := fam!.burnsideRing;
      basis := Basis( A );
      ccs_list := fam!.ccss;

      if ( a in basis ) and ( b in basis ) then
        indCa := a!.ccsIndices[ 1 ];
        indCb := b!.ccsIndices[ 1 ];
        Ca := a!.ccss[ 1 ];
        Cb := b!.ccss[ 1 ];
        ab_ccs_list := [ ];
        ab_ccs_index_list := [ ];
        ab_coeff_list := [ ];

        for i in Reversed( [ 1 .. Minimum( indCa, indCb ) ] ) do
          Ci := ccs_list[ i ];
          if not ( ( Ci <= Ca ) and ( Ci <= Cb ) ) then
            continue;
          fi;

          coeff := nLHnumber( Ci, Ca ) * OrderOfWeylGroup( Ca ) *
                   nLHnumber( Ci, Cb ) * OrderOfWeylGroup( Cb );

          for j in [ 1 .. Size( ab_ccs_list ) ] do
            Cj := ab_ccs_list[ j ];
            coeff := coeff - nLHnumber( Ci, Cj )*ab_coeff_list[ j ];
          od;

          if not IsZero( coeff ) then
            Add( ab_ccs_list, Ci, 1 );
            Add( ab_ccs_index_list, i, 1 );
            Add( ab_coeff_list, coeff, 1 );
          fi;
        od;
        ab_coeff_list := ListN( ab_coeff_list,
                         List( ab_ccs_list, OrderOfWeylGroup ), \/ );
        return Sum( ListN( ab_coeff_list, basis{ ab_ccs_index_list }, \* ) );
      else
        return Sum( ListX( ToSparseList( a ), ToSparseList( b ),
          { x, y } -> x[ 2 ] * y[ 2 ] * ( basis[ x[ 1 ] ] * basis[ y[ 1 ] ] )
        ) );
      fi;
    end
  );


##  Part 2: Burnside ring

#############################################################################
##
#U  NewBurnsideRing( IsBurnsideRing and IsBurnsideRingBySmallGroupRep, <G> )
##
  InstallMethod( NewBurnsideRing,
    "create a Burnside ring induced by a small group",
    [ IsBurnsideRing and IsBurnsideRingBySmallGroupRep, IsGroup ],
    function( filt, G )
      local fam_elmt,	# family of the Burnside ring elements
            filt_elmt,	# filter of the Burnside ring elements
            A,		# the Burnside ring
            ccs_list,	# conjugacy classes of subgroups
            d,		# dimension of the module (ring)
            zero,	# zero of the Burnside ring
            b,          # an element in the basis
            basis,	# basis of the module (ring)
            i, j;	# indices

      # extract info of <G>
      ccs_list := ConjugacyClassesSubgroups( G );
      d        := Size( ccs_list );

      # declare the family and filter of elements of the Burnside ring
      filt_elmt := IsBurnsideRingElement and
                   IsBurnsideRingBySmallGroupElementRep;
      fam_elmt  := NewFamily( Concatenation( "BurnsideRing(",
                   ViewString( G ), ")Family" ), filt_elmt );

      # objectify the Burnside ring
      A := Objectify( NewType( CollectionsFamily( fam_elmt ),
           filt ), rec( ) );
      SetIsWholeFamily( A, true );

      # assign attributes to the family of elements
      fam_elmt!.group        := G;
      fam_elmt!.ccss         := ccs_list;
      fam_elmt!.dimension    := d;
      fam_elmt!.burnsideRing := A;

      # generate zero of the Burnside ring
      zero := Objectify(
        NewType( fam_elmt, filt_elmt ),
        rec( ccss        := [ ],
             ccsIndices  := [ ],
             coefficient := [ ]  )
      );
      SetLength( zero, 0 );
      SetZeroImmutable( fam_elmt, zero );
      SetZeroImmutable( A, zero );

      # generate the basis of the Burnside ring
      SetDimension( A, d );
      basis := [ ];
      for i in [ 1 .. d ] do
        b := Objectify(
          NewType( fam_elmt, filt_elmt ),
          rec( ccss         := ccs_list{ [ i ] },
               ccsIndices   := [ i ],
               coefficients := [ 1 ]  )
        );
        SetLength( b, 1 );
        Add( basis, b );
      od;
      SetBasis( A, basis );
      SetGeneratorsOfRing( A, basis );
      SetOneImmutable( fam_elmt, basis[ d ] );
      SetOneImmutable( A, basis[ d ] );

      # other attributes related to its module structure
      SetLeftActingDomain( A, Integers );
      SetIsFiniteDimensional( A, true );

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
    "return the Burnside ring induced by a group",
    [ IsGroup and IsFinite ],
    G -> NewBurnsideRing( IsBurnsideRing and
                          IsBurnsideRingBySmallGroupRep, G )
  );


##  Part 3: Other Aspects

##!##########################################################################
##
#A  BasicDegree( <chi> )
##
  InstallMethod( BasicDegree,
    "return the Basic Degree of the representation",
    [ IsCharacter ],
    function( chi )
      local G,				# group
            ccs_list,			# CCSs
            A,				# Burnside ring
            basis,			# basis of Burnside ring
            lat,			# lattice of orbit types
            orbt_list,			# orbit types
            orbt_index_list,		# Indices of orbit types
            fixeddim_list,		# dimension of fixed point space
            coeff,			# coefficent
            i, j,			# indices
            Oi, Oj,			# orbit types
            bdeg_ccs_list,
            bdeg_ccs_index_list,	# indices of basic degree
            bdeg_coeff_list;		# coefficient of basic degree

      G := UnderlyingGroup( chi );
      ccs_list := ConjugacyClassesSubgroups( G );
      A := BurnsideRing( G );
      basis := Basis( A );
      lat := LatticeOrbitTypes( chi );
      orbt_list := OrbitTypes( chi );
      orbt_index_list := List( orbt_list, orbt -> Position( ccs_list, orbt ) );
      fixeddim_list := lat!.ranks;
      bdeg_ccs_list := [ ];
      bdeg_ccs_index_list := [ ];
      bdeg_coeff_list := [ ];

      for i in Reversed( [ 1 .. Size( orbt_list ) ] ) do
        Oi := orbt_list[ i ];
        coeff := (-1)^fixeddim_list[ i ];
        for j in [ 1 .. Size( bdeg_ccs_list ) ] do
          Oj := bdeg_ccs_list[ j ];
          coeff := coeff - bdeg_coeff_list[ j ]*nLHnumber( Oi, Oj );
        od;
        if not IsZero( coeff ) then
          Add( bdeg_ccs_list, Oi, 1 );
          Add( bdeg_ccs_index_list, orbt_index_list[ i ], 1 );
          Add( bdeg_coeff_list, coeff, 1 );
        fi;
      od;
      bdeg_coeff_list := ListN( bdeg_coeff_list,
                         List( bdeg_ccs_list, OrderOfWeylGroup ), \/ );
      return Sum( ListN( bdeg_coeff_list, basis{ bdeg_ccs_index_list }, \* ) );
    end
  );


##  Appendix: Print, View and Display

#############################################################################
##
#A  String( <a> )
##
  InstallMethod( String,
    "string of a Burnside ring element",
    [ IsBurnsideRingElement ],
    function( a )
      local i,		# index
            coeff,	# coefficient
            ccs_index,	# index of CCS
            ccs_list,	# CCSs of the underlying group
            ccs_name,	# name of CCS
            str;	# name string

      ccs_list := FamilyObj( a )!.ccss;
      str := "";
      for i in [ 1 .. Length( a ) ] do
        coeff     := a!.coefficients[ i ];
        ccs_index := a!.ccsIndices[ i ];

        # determine the name of CCS
        if HasName( ccs_list[ ccs_index ] ) then
          ccs_name := Name( ccs_list[ ccs_index ] );
        else
          ccs_name := String( ccs_index );
        fi;

        # append coefficient and name of CCS
        if ( i > 1 ) and ( coeff > 0 ) then
          Append( str, "+" );
        fi;
        Append( str, String( coeff ) );
        Append( str, StringFormatted("({})", ccs_name ) );
      od;

      return StringFormatted("<{}>", str );
    end
  );

#############################################################################
##
#A  ViewString( <a> )
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
#A  PrintString( <a> )
##
  InstallMethod( PrintString,
    "print string of a Burnside ring element",
    [ IsBurnsideRingElement ],
    function( a )
      local A;     # the Burnside ring

      A := FamilyObj( a )!.burnsideRing;

      return Concatenation( String( a ), " in ", PrintString( A ) );
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
            ccs_index,	# index of CCS
            ccs_list,	# CCSs of the underlying group
            ccs_name,	# name of CCS
            str;	# name string

      ccs_list := FamilyObj( a )!.ccss;
      str := "";
      for i in [ 1 .. Length( a ) ] do
        coeff     := a!.coefficients[ i ];
        ccs_index := a!.ccsIndices[ i ];

        # determine the name of CCS
        if HasLaTeXString( ccs_list[ ccs_index ] ) then
          ccs_name := LaTeXString( ccs_list[ ccs_index ] );
        else
          ccs_name := String( ccs_index );
        fi;

        # append coefficient and name of CCS
        if ( i > 1 ) and ( coeff > 0 ) then
          Append( str, "+" );
        fi;
        Append( str, String( coeff ) );
        Append( str, StringFormatted("({})", ccs_name ) );
      od;

      return str;
    end
  );

#############################################################################
##
#A  ViewString( <A> )
##
  InstallMethod( ViewString,
    "view string of a Burnside ring",
    [ IsBurnsideRing ],
    A -> Concatenation("Brng( ",
         ViewString( UnderlyingGroup( A ) ), " )" )
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
#A  PrintString( <A> )
##
  InstallMethod( PrintString,
    "print string of a Burnside ring",
    [ IsBurnsideRing ],
    A -> Concatenation(
      "BurnsideRing( ",
      PrintString( UnderlyingGroup( A ) ),
      " )"
    )
  );

#############################################################################
##
#O  PrintObj( <A> )
##
  InstallMethod( PrintObj,
    "print a Burnside ring",
    [ IsBurnsideRing ],
    function( A )
      Print( PrintString( A ) );
    end
  );


#############################################################################
##
#E  BurnsideRing.gi . . . . . . . . . . . . . . . . . . . . . . . . ends here
