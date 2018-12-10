# # GAP: Burnside Ring Library
#
# Implementation file of libBurnsideRing.g
#
# Author:
#   Hao-pin Wu <hxw132130@utdallas.edu>
#


# ## Part 1: Burnside ring element
# ### attribute(s)
  InstallMethod( Length,
    "length of the summand in a Burnside ring element",
    [ IsBurnsideRingElement and IsBurnsideRingBySmallGroupElementRep ],
    e -> Length( e!.CCSIndices )
  );

# ***
  InstallMethod( ToSparseList,
    "convert a Burnside ring element to a sparse list",
    [ IsBurnsideRingElement and IsBurnsideRingBySmallGroupElementRep ],
    e -> List( [ 1 .. Length( e ) ], k -> [ e!.CCSIndices[ k ], e!.Coefficients[ k ] ] )
  );

# ***
  InstallMethod( ToDenseList,
    "convert a Burnside ring element to a dense list",
    [ IsBurnsideRingElement and IsBurnsideRingBySmallGroupElementRep ],
    function( e )
      local list,   # the return list
            fam,    # the family of the Burnside ring element
            dim;    # dimension of the Burnside module (ring)

      fam := FamilyObj( e );
      dim := fam!.DIMENSION;
      list := ZeroOp( [ 1 .. dim ] );
      list{ e!.CCSIndices } := e!.Coefficients;

      return list;
    end
  );


# ### operation(s)
# ***
  InstallMethod( \=,
    "identical relation in a Burnside ring",
    IsIdenticalObj,
    [ IsBurnsideRingElement and IsBurnsideRingBySmallGroupElementRep,
      IsBurnsideRingElement and IsBurnsideRingBySmallGroupElementRep ],
    function( a, b )
      return ( a!.CCSIndices = b!.CCSIndices ) and ( a!.Coefficients = b!.Coefficients );
    end
  );

# ***
  InstallMethod( ZeroOp,
    "additive identity of a Burnside ring",
    [ IsBurnsideRingElement and IsBurnsideRingBySmallGroupElementRep ],
    function( a )
      local fam;

      fam := FamilyObj( a );

      return Objectify(
        NewType( fam, IsBurnsideRingElement and IsBurnsideRingBySmallGroupElementRep ),
        rec( CCSIndices := [ ],
             Coefficients := [ ] )
      );
    end
  );

# ***
  InstallMethod( OneOp,
    "multiplicative identity of a Burnside ring",
    [ IsBurnsideRingElement and IsBurnsideRingBySmallGroupElementRep ],
    function( a )
      local fam,
            dim;

      fam := FamilyObj( a );
      dim := fam!.DIMENSION;

      return Objectify(
        NewType( fam, IsBurnsideRingElement and IsBurnsideRingBySmallGroupElementRep ),
        rec( CCSIndices := [ dim ], Coefficients := [ 1 ] )
      );
    end
  );

# ***
  InstallMethod( AdditiveInverseOp,
    "additive inverse in a Burnside ring",
    [ IsBurnsideRingElement and IsBurnsideRingBySmallGroupElementRep ],
    function( a )
      local fam;

      fam := FamilyObj( a );

      return Objectify(
        NewType( fam, IsBurnsideRingElement and IsBurnsideRingBySmallGroupElementRep ),
        rec( CCSIndices := a!.CCSIndices,
             Coefficients := -a!.Coefficients )
      );
    end
  );

# ***
  InstallMethod( \+,
    "addition in a Burnside ring",
    IsIdenticalObj,
    [ IsBurnsideRingElement and IsBurnsideRingBySmallGroupElementRep,
      IsBurnsideRingElement and IsBurnsideRingBySmallGroupElementRep ],
    function( a, b )
      local sum_dense_list,
            fam,
            sum_ccs_index_list,
            sum_coefficient_list;

      fam := FamilyObj( a );

      sum_dense_list := ToDenseList( a ) + ToDenseList( b );
      sum_ccs_index_list := PositionsProperty( sum_dense_list, x -> not IsZero( x ) );
      sum_coefficient_list := sum_dense_list{ sum_ccs_index_list };

      return Objectify(
        NewType( fam, IsBurnsideRingElement and IsBurnsideRingBySmallGroupElementRep ),
        rec( CCSIndices := sum_ccs_index_list,
             Coefficients := sum_coefficient_list )
      );
    end
  );

# ***
  InstallMethod( \*,
    "scalar multiplication in a Burnside ring",
    [ IsInt, IsBurnsideRingElement and IsBurnsideRingBySmallGroupElementRep ],
    function( r, a )
      local fam;

      fam := FamilyObj( a );

      return Objectify(
        NewType( fam, IsBurnsideRingElement and IsBurnsideRingBySmallGroupElementRep ),
        rec( CCSIndices := a!.CCSIndices, Coefficients := r*a!.Coefficients )
      );
    end
  );

# ***
  InstallMethod( \*,
    "multiplication in a Burnside ring",
    IsIdenticalObj,
    [ IsBurnsideRingElement and IsBurnsideRingBySmallGroupElementRep, IsBurnsideRingElement and IsBurnsideRingBySmallGroupElementRep ],
    function( a, b )
      local fam,                    # family of Burnside ring elements
            grp,                    # group
            ccs_list,               # CCSs
            ring,                   # Burnside ring
            basis,                  # basis of Burnside ring
            indCa,                  # index of CCS a (when a is in the basis )
            indCb,                  # index of CCS b (when b is in the basis )
            Ca,                     # CCS a (when a is in the basis)
            Cb,                     # CCS b (when b is in the basis)
            len,                    # length of the product
            prod,                   # product
            prod_index_list,        # indices of the product
            prod_coefficient_list,  # coefficients of the product
            coeff,                  # a coefficient in the product
            i, j,                   # indices
            Ci, Cj;                 # i-th and j-th CCSs

      fam := FamilyObj( a );
      grp := fam!.GROUP;
      ring := fam!.BurnsideRing;
      basis := Basis( ring );
      ccs_list := fam!.CCSs;

      if ( a in basis ) and ( b in basis ) then
        indCa := a!.CCSIndices[ 1 ];
        indCb := b!.CCSIndices[ 1 ];
        Ca := ccs_list[ indCa ];
        Cb := ccs_list[ indCb ];
        len := 0;
        prod_index_list := [ ];
        prod_coefficient_list := [ ];

        for i in Reversed( [ 1 .. Minimum( indCa, indCb ) ] ) do
          Ci := ccs_list[ i ];
          if not ( ( Ci <= Ca ) and ( Ci <= Cb ) ) then
            continue;
          fi;
          coeff := nLHnumber( Ci, Ca ) * OrderOfWeylGroup( Ca ) * nLHnumber( Ci, Cb ) * OrderOfWeylGroup( Cb );
          for j in [ 1 .. len ] do
            Cj := ccs_list[ prod_index_list[ j ] ];
            coeff := coeff - nLHnumber( Ci, Cj )*prod_coefficient_list[ j ];
          od;
          if not IsZero( coeff ) then
            Add( prod_index_list, i, 1 );
            Add( prod_coefficient_list, coeff, 1 );
            len := len+1;
          fi;
        od;

        return Sum( List( [ 1 .. len ], i -> ( prod_coefficient_list[ i ]/OrderOfWeylGroup( ccs_list[ prod_index_list[ i ] ] ) * basis[ prod_index_list[ i ] ] ) ) );
      else
        prod := Zero( ring );
        for i in [ 1 .. Length( a ) ] do
          for j in [ 1 .. Length( b ) ] do
            prod := prod +
                a!.Coefficients[ i ]*
                b!.Coefficients[ j ]*
                ( basis[ a!.CCSIndices[ i ] ]*
                basis[ b!.CCSIndices[ j ] ] );
          od;
        od;

        return prod;
      fi;
    end
  );


# ### Print, View and Display
# ***
  InstallMethod( String,
    "string of a Burnside ring element",
    [ IsBurnsideRingElement ],
    function( e )
      local i,        # index
            coeff,    # coefficient
            ccsind,   # index of CCS
            ccss,     # CCSs of the underlying group
            ccs_name, # name of CCS
            str;      # name string

      ccss := FamilyObj( e )!.CCSs;
      str := "";
      for i in [ 1 .. Length( e ) ] do
        coeff := e!.Coefficients[ i ];
        ccsind := e!.CCSIndices[ i ];

        # determine the name of CCS
        if HasName( ccss[ ccsind ] ) then
          ccs_name := Name( ccss[ ccsind ] );
        else
          ccs_name := String( ccsind );
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

# ***
  InstallMethod( ViewString,
    "view string of a Burnside ring element",
    [ IsBurnsideRingElement ],
    function( e )
      local fam,      # the family of Burnside ring elements
            ring;     # the Burnside ring

      fam := FamilyObj( e );
      ring := fam!.BurnsideRing;

      return Concatenation( String( e ), " in ", ViewString( ring ) );
    end
  );

# ***
  InstallMethod( PrintString,
    "print string of a Burnside ring element",
    [ IsBurnsideRingElement ],
    function( e )
      local fam,      # the family of Burnside ring elements
            ring;     # the Burnside ring

      fam := FamilyObj( e );
      ring := fam!.BurnsideRing;

      return Concatenation( String( e ), " in ", PrintString( ring ) );
    end
  );

# ***
  InstallMethod( LaTeXTypesetting,
    "return LaTeX typesetting of an element in the Burnside ring",
    [ IsBurnsideRingElement ],
    function( e )
      local i,        # index
            coeff,    # coefficient
            ccsind,   # index of CCS
            ccss,     # CCSs of the underlying group
            ccs_name, # name of CCS
            str;      # name string

      ccss := FamilyObj( e )!.CCSs;
      str := "";
      for i in [ 1 .. Length( e ) ] do
        coeff := e!.Coefficients[ i ];
        ccsind := e!.CCSIndices[ i ];

        # determine the name of CCS
        if HasLaTeXString( ccss[ ccsind ] ) then
          ccs_name := LaTeXString( ccss[ ccsind ] );
        else
          ccs_name := String( ccsind );
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



# ## Part 2: Burnside ring
# ### constructor(s)
  InstallMethod( NewBurnsideRing,
    "create a Burnside ring induced by a small group",
    [ IsBurnsideRing and IsBurnsideRingBySmallGroupRep, IsGroup ],
    function( filter, grp )
      local elemfam,     # family of the Burnside ring elements
            elemfil,     # filter of the Burnside ring elements
            gid,         # group id
            ring,        # the Burnside ring
            enumerator,  # enumerator of the Burnside ring
            ccs_list,    # conjugacy classes of subgroups
            d,           # dimension of the module (ring)
            basis,       # basis of the module (ring)
            i, j;        # indices

      # extract info of grp
      ccs_list := ConjugacyClassesSubgroups( grp );
      d := Size( ccs_list );

      # create the family with corresponding data
      elemfil := IsBurnsideRingElement and IsBurnsideRingBySmallGroupElementRep;
      elemfam := NewFamily( Concatenation( "BurnsideRing(", ViewString( grp ), ")Family" ), elemfil );
      elemfam!.GROUP := grp;
      elemfam!.CCSs := ccs_list;
      elemfam!.DIMENSION := d;

      # use basis to generate the Burnside ring
      ring := Objectify( NewType( CollectionsFamily( elemfam ), filter ), rec( ) );
      elemfam!.BurnsideRing := ring;
      SetDimension( ring, d );
      basis := [ ];
      for i in [ 1 .. d ] do
        Add( basis, Objectify(
          NewType( elemfam, elemfil ),
          rec( CCSIndices := [ i ], Coefficients := [ 1 ] ) )
        );
      od;

      # attributes related to its ring structure
      SetGeneratorsOfRing( ring, basis );
      SetIsWholeFamily( ring, true );
      SetZeroImmutable( ring, Objectify(
        NewType( elemfam, elemfil ),
        rec( CCSIndices := [ ], Coefficients := [ ] ) )
      );
      SetOneImmutable( ring, basis[ d ] );

      # attributes related to its module structure
      SetBasis( ring, basis );
      SetLeftActingDomain( ring, Integers );
      SetIsFiniteDimensional( ring, true );

      # attributes related to its Burnside ring sturcture
      SetUnderlyingGroup( ring, grp );

      return ring;
    end
  );


# ### attribute(s)
# ***
  InstallMethod( BurnsideRing,
    "return the Burnside ring induced by a group",
    [ IsGroup ],
    grp -> NewBurnsideRing( IsBurnsideRing and IsBurnsideRingBySmallGroupRep, grp )
  );


# ## Print, View and Display
# ***
  InstallMethod( ViewString,
    "view string of a Burnside ring",
    [ IsBurnsideRing ],
    ring -> Concatenation("BurnsideRing( ", ViewString( UnderlyingGroup( ring ) ), " )" )
  );

# ***
  InstallMethod( ViewObj,
    "view a Burnside ring",
    [ IsBurnsideRing ],
    function( ring )
      Print( ViewString( ring ) );
    end
  );

# ***
  InstallMethod( PrintString,
    "print string of a Burnside ring",
    [ IsBurnsideRing ],
    ring -> Concatenation("BurnsideRing( ", PrintString( UnderlyingGroup( ring ) ), " )" )
  );

# ***
  InstallMethod( PrintObj,
    "print a Burnside ring",
    [ IsBurnsideRing ],
    function( ring )
      Print( PrintString( ring ) );
    end
  );


# ## Part 3: Other Aspects
# ### attribute(s)
  InstallMethod( BasicDegree,
    "return the Basic Degree of the representation",
    [ IsCharacter ],
    function( chi )
      local grp,                    # group
            ccs_list,               # CCSs
            ring,                   # Burnside ring
            basis,                  # basis of Burnside ring
            lat,                    # lattice of orbit types
            orbittype_index_list,   # Indices of orbit types
            fixeddim_list,          # dimension of fixed point space
            coeff,                  # coefficent
            i, j,                   # indices
            n,                      # number of orbit types
            len,                    # length of basic degree
            Oi, Oj,                 # orbit types
            bdeg_index_list,        # indices of basic degree
            bdeg_coefficient_list;  # coefficient of basic degree

      grp := UnderlyingGroup( chi );
      ccs_list := ConjugacyClassesSubgroups( grp );
      ring := BurnsideRing( grp );
      basis := Basis( ring );
      lat := LatticeOrbitTypes( chi );
      orbittype_index_list := OrbitTypes( chi );
      fixeddim_list := lat!.ranks;
      bdeg_index_list := [ ];
      bdeg_coefficient_list := [ ];
      len := 0;

      n := Size( orbittype_index_list );
      for i in Reversed( [ 1 .. n ] ) do
        Oi := ccs_list[ orbittype_index_list[ i ] ];
        coeff := (-1)^fixeddim_list[ i ];
        for j in [ 1 .. len ] do
          Oj := ccs_list[ bdeg_index_list[ j ] ];
          coeff := coeff - bdeg_coefficient_list[ j ]*nLHnumber( Oi, Oj );
        od;
        if not IsZero( coeff ) then
          Add( bdeg_index_list, orbittype_index_list[ i ], 1 );
          Add( bdeg_coefficient_list, coeff, 1 );
          len := len+1;
        fi;
      od;

      return Sum( List( [ 1 .. len ], i -> ( bdeg_coefficient_list[ i ]/OrderOfWeylGroup( ccs_list[ bdeg_index_list[ i ] ] ) ) * basis[ bdeg_index_list[ i ] ] ) );
    end
  );

