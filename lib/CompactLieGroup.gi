# # GAP: Compact Lie Group Library
#
# Implementation file of libCompactLieGroup.g
#
# Author:
# Haopin Wu <psistwu@outlook.com>
#


# ### constructor(s)
# ***
  InstallOtherMethod( NewElementaryCompactLieGroup,
    "constructor of a matrix-ECLG",
    [ IsElementaryCompactLieGroup and IsMatrixGroup and IsCompactLieGroupRep, IsPosInt ],
    function( filter, d )
      local one,          # identity of the ECLG
            fam_eclg,     # family of the ECLG
            eclg;         # elementary compact Lie group

      # generate the identity of the ECLG (a d-by-d identity matrix)
      one := One( List( [ 1 .. d ], i -> List( [ 1 .. d ], j -> 0 ) ) );

      # define the family of the group
      fam_eclg := CollectionsFamily( FamilyObj( one ) );

      # objectify the (special) orthogonal group
      eclg := Objectify( NewType( fam_eclg, filter ), rec() );

      # setup properties of the (special) orthogonal group
      SetIsFinite( eclg, false );
      SetOneImmutable( eclg, one );
      SetDimensionOfMatrixGroup( eclg, d );

      return eclg;
    end
  );

# ***
  InstallMethod( OrthogonalGroupOverReal,
    "generate an orthogonal group over real numbers",
    [ IsPosInt ],
    function( d )
      local eclg;              # the orthogonal group

      # objectify the group
      eclg := NewElementaryCompactLieGroup( IsElementaryCompactLieGroup and IsMatrixGroup and IsCompactLieGroupRep, d );

      # setup property(s) and attribute(s) of the group
      SetIsAbelian( eclg, false );
      SetDimension( eclg, d*(d-1)/2 );
      SetIdECLG( eclg, [ 2, d*(d-1)/2 ] );

      # the follow clause is an ad hoc approach for
      # comparing epimorphisms from O(2) to a finite group
      # certainly, the given set does not generate O(2)
      if ( d = 2 ) then
        SetGeneratorsOfGroup( eclg, [ [ [ 0, -1 ],[ 1, 0 ] ], [ [ 1, 0 ], [ 0, -1 ] ] ] );
      fi;

      return eclg;
    end
  );

# ***
  InstallMethod( SpecialOrthogonalGroupOverReal,
    "generate a special orthogonal group over real numbers",
    [ IsPosInt ],
    function( d )
      local eclg;              # the special orthogonal group

      # objectify the group
      eclg := NewElementaryCompactLieGroup( IsElementaryCompactLieGroup and IsMatrixGroup and IsCompactLieGroupRep, d );

      # setup property(s) and attribute(s) of the group
      SetIsAbelian( eclg, true );
      SetDimension( eclg, d*(d-1)/2 );
      SetIdECLG( eclg, [ 1, d*(d-1)/2 ] );

      # the follow clause is an ad hoc approach for
      # comparing epimorphisms from O(2) to a finite group
      # certainly, the given set does not generate SO(2)
      if ( d = 2 ) then
        SetGeneratorsOfGroup( eclg, [ [ [ 0, -1 ],[ 1, 0 ] ] ] );
      fi;

      return eclg;
    end
  );

# ***
  InstallMethod( ECLGId,
    "generate elementary compact Lie group of given ID",
    [ IsList ],
    function( id )
      local eclg;

      if ( id = [ 1, 1 ] ) then
        eclg := SpecialOrthogonalGroupOverReal( 2 );
      elif ( id = [ 2, 1 ] ) then
        eclg := OrthogonalGroupOverReal( 2 );
      else
        Info( InfoEquiDeg, INFO_LEVEL_EquiDeg, "Unrecognizable ID for ECLG." );
        return fail;
      fi;
      # SetIdECLG( eclg, id );

      return eclg;
    end
  );

# ***
  InstallMethod( NewCCS,
    "CCS constructor of SO(2) or O(2)",
    [ IsElementaryCompactLieGroupCCSsRep, IsRecord, IsInt ],
    function( filter, ccs_class, mode )
      local eclg,
            ccs,
            subg,
            fam_ccs,
            rep_ccs,
            cat_ccs;

      if not ( IdECLG( ccs_class.group ) in [ [ 1, 1 ], [ 2, 1 ] ] ) then
        TryNextMethod( );
      fi;

      if ( mode < 0 ) or ( ccs_class.is_zero_mode <> ( mode = 0 ) ) then
        Error( "Illegel mode for the selected CCS class." );
      fi;

      # find representative subgroup and its normalizer
      if ( ccs_class.id = [ 1, 0 ] ) then
        subg := ECLGId( [ 1, 1 ] );
      elif ( ccs_class.id = [ 2, 0 ] ) then
        subg := ECLGId( [ 2, 1 ] );
      elif ( ccs_class.id = [ 1, 1 ] ) then
        subg := mCyclicGroup( mode );
      elif ( ccs_class.id = [ 2, 1 ] ) then
        subg := mDihedralGroup( mode );
      else
        return fail;
      fi;

      # objectify the CCS
      fam_ccs := CollectionsFamily( FamilyObj( ccs_class.group ) );
      cat_ccs := CategoryCollections( IsMatrixGroup );
      rep_ccs := IsElementaryCompactLieGroupCCSRep;
      ccs := Objectify( NewType( fam_ccs, cat_ccs and rep_ccs ), rec( ) );

      # setup attributes of CCS
      SetParentAttr( subg, ccs_class.group );
      SetOrderOfWeylGroup( subg, ccs_class.order_of_weyl_group );
      SetIsZeroModeCCS( ccs, ccs_class.is_zero_mode );
      SetActingDomain( ccs, ccs_class.group );
      SetOrderOfWeylGroup( ccs, ccs_class.order_of_weyl_group );
      SetRepresentative( ccs, subg );

      return ccs;
    end
  );

# ***
  InstallOtherMethod( NewCCS,
    "CCS constructor of CLG",
    [ IsElementaryCompactLieGroupCCSsRep, IsRecord ],
    function( filter, ccs_class )
      local mode;

      if ccs_class.is_zero_mode then
        mode := 0;
      else
        mode := 1;
      fi;

      return NewCCS( filter, ccs_class, mode );
    end
  );


# ### Attribute(s)
# ***
  InstallMethod( ConjugacyClassesSubgroups,
    "CCSs of O(2)",
    [ IsElementaryCompactLieGroup and IsCompactLieGroupRep ],
    function( eclg )
      local fam_ccss,          # family of CCSs
            cat_ccss,          # category of CCSs
            rep_ccss,          # representation of CCSs
            ccss,              # CCSs
            make_ccs_classes;  # procedure generating CCS classes

      # it works only for SO(2) and O(2)
      if not ( IdECLG( eclg ) in [ [ 1, 1 ], [ 2, 1 ] ] ) then
        TryNextMethod( );
      fi;

      # define families and collections
      fam_ccss := CollectionsFamily( CollectionsFamily( FamilyObj( eclg ) ) );
      cat_ccss := CategoryCollections( CategoryCollections( IsMatrixGroup ) );
      rep_ccss := IsElementaryCompactLieGroupCCSsRep;

      # objectify CCSs of the group
      ccss := Objectify( NewType( fam_ccss, cat_ccss and rep_ccss ), rec( ) );
      SetUnderlyingGroup( ccss, eclg );
      SetIsFinite( ccss, false );

      # generate CCS classes
      make_ccs_classes := function( )
        local ccs_list,          # list of CCSs
              perm,              # sorting permutation
              ccs_classes;

        ccs_classes := [ ];
        if ( IdECLG( eclg ) = [ 1, 1 ] ) then
          # add SO(2)
          Add( ccs_classes, rec(
            group := eclg,
            is_zero_mode := true,
            id := [ 1, 0 ],
            order_of_weyl_group := [ 1, 0 ],
          ) );
          # add Z_m
          Add( ccs_classes, rec(
            group := eclg,
            is_zero_mode := false,
            id := [ 1, 1 ],
            order_of_weyl_group := [ 1, 1 ],
          ) );
        elif ( IdECLG( eclg ) = [ 2, 1 ] ) then
          # add SO(2)
          Add( ccs_classes, rec(
            group := eclg,
            is_zero_mode := true,
            id := [ 1, 0 ],
            order_of_weyl_group := [ 2, 0 ],
          ) );
          # add O(2)
          Add( ccs_classes, rec(
            group := eclg,
            is_zero_mode := true,
            id := [ 2, 0 ],
            order_of_weyl_group := [ 1, 0 ],
          ) );
          # add Z_m
          Add( ccs_classes, rec(
            group := eclg,
            is_zero_mode := false,
            id := [ 1, 1 ],
            order_of_weyl_group := [ 2, 1 ],
          ) );
          # add D_m
          Add( ccs_classes, rec(
            group := eclg,
            is_zero_mode := false,
            id := [ 2, 1 ],
            order_of_weyl_group := [ 2, 0 ],
          ) );
        fi;

        # sort ccs_classes
        ccs_list := List( ccs_classes, cl -> NewCCS( rep_ccss, cl ) );
        perm := SortingPerm( ccs_list );

        return Permuted( ccs_classes, perm );
      end;
      SetCCSClasses( ccss, make_ccs_classes( ) );

      return ccss;
    end
  );

# ***
  InstallMethod( CCSClassesFiltered,
    "return a function which gives a filtered CCS classes",
    [ IsCompactLieGroupCCSsRep ],
    ccss -> function( args... )
      local arg_count,
            term,
            d,
            filtered_ccs_classes;

      filtered_ccs_classes := CCSClasses( ccss );
      arg_count := 0;

      while not IsEmpty( args ) do
        term := Remove( args, 1 );
        arg_count := arg_count+1;

        if ( term = "nonzero_mode" ) then
          filtered_ccs_classes := Filtered( filtered_ccs_classes, cl -> not cl.is_zero_mode );
        elif ( term = "zero_mode" ) then
          filtered_ccs_classes := Filtered( filtered_ccs_classes, cl -> cl.is_zero_mode );
        elif ( term = "with_m-dim_weyl_group" ) then
          d := Remove( args, 1 );
          arg_count := arg_count+1;
          if not IsInt( d ) or ( d < 0 ) then
            Error( "Dimension for ", arg_count, "-th term is invalid." );
          fi;
          filtered_ccs_classes := Filtered( filtered_ccs_classes, cl -> ( cl.order_of_weyl_group[ 2 ] = d ) );
        else
          Error( arg_count, "-th term is invalid." );
        fi;
      od;

      return filtered_ccs_classes;
    end
  );

# ***
  InstallMethod( CCSId,
    "return CCSId attribute of a compact Lie group CCS list",
    [ IsCompactLieGroupCCSsRep ],
    ccss -> function( id )
      local rep_ccss,
            ccs_class,
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

      # extract representation of the given CCSs
      rep_ccss := EvalString( Remove( ShallowCopy( RepresentationsOfObject( ccss ) ) ) );

      ccs := NewCCS( rep_ccss, ccs_class, id[ 2 ] );
      SetIdCCS( ccs, id );

      return ccs;
    end
  );

# ### Operation(s)
# #### for ECLG
# ***
  InstallMethod( \=,
    "equivalence relation of ECLGs",
    [ IsElementaryCompactLieGroup, IsElementaryCompactLieGroup ],
    function( eclg1, eclg2 )
      return IdECLG( eclg1 ) = IdECLG( eclg2 );
    end
  );

# ***
  InstallMethod( \in,
    "Membership test for SO(n)",
    [ IsObject, IsElementaryCompactLieGroup and IsMatrixGroup ],
    function( obj, eclg )
      local d;

      d := DimensionOfMatrixGroup( eclg );
      if not ( eclg = SpecialOrthogonalGroupOverReal( d ) ) then
        TryNextMethod( );
      fi;

      if IsIdenticalObj( CollectionsFamily( FamilyObj( obj ) ), FamilyObj( eclg ) ) and ( TransposedMat( obj ) * obj = One( eclg ) ) and ( Determinant( obj ) = 1 ) then
        return true;
      else
        return false;
      fi;
    end
  );

# ***
  InstallMethod( \in,
    "Membership test for O(n)",
    [ IsObject, IsElementaryCompactLieGroup and IsMatrixGroup ],
    function( obj, eclg )
      local d;

      d := DimensionOfMatrixGroup( eclg );
      if not ( eclg = OrthogonalGroupOverReal( d ) ) then
        TryNextMethod( );
      fi;

      if IsIdenticalObj( CollectionsFamily( FamilyObj( obj ) ), FamilyObj( eclg ) ) and ( TransposedMat( obj ) * obj = One( eclg ) ) then
        return true;
      else
        return false;
      fi;
    end
  );

# ***
  InstallMethod( IsSubset,
    "Test if a finite group is a subgroup of a ECLG",
    [ IsElementaryCompactLieGroup, IsGroup ],
    function( eclg, grp )
      local elmt;

      if not IsFinite( grp ) then
        TryNextMethod( );
      fi;

      for elmt in List( grp ) do
        if not ( elmt in eclg ) then
          return false;
        fi;
      od;

      return true;
    end
  );

# ***
  InstallMethod( IsSubset,
    "Test if an ECLG is a subgroup of a finite group",
    [ IsGroup, IsElementaryCompactLieGroup ],
    function( grp, eclg )
      if IsFinite( grp ) then
        return false;
      else
        TryNextMethod( );
      fi;
    end
  );

# ***
  InstallMethod( IsSubset,
    "Test if an ECLG is a subset of another ECLG",
    [ IsElementaryCompactLieGroup, IsElementaryCompactLieGroup ],
    function( eclg1, eclg2 )
      # one should change the rule when adding more ECLGs into the library
      return IsZero( IdECLG( eclg1 ) mod IdECLG( eclg2 ) );
    end
  );

# #### for CCS of ECLG
# ***
  InstallMethod( \=,
    "the equivalence relation of CCSs of ECLG",
    IsIdenticalObj,
    [ IsCompactLieGroupCCSRep, IsCompactLieGroupCCSRep ],
    function( ccs1, ccs2 )
      return ( ActingDomain( ccs1 ) = ActingDomain( ccs2 ) ) and
      ( Representative( ccs1 ) = Representative( ccs2 ) );
    end
  );

# ***
  InstallMethod( nLHnumber,
    "return n(L,H) number for CCSs of ECLG",
    IsIdenticalObj,
    [ IsElementaryCompactLieGroupCCSRep, IsElementaryCompactLieGroupCCSRep ],
    function( ccs1, ccs2 )
      local eclg,           # underlying group of ccs1 and ccs2
            workable_clg,   # workable group list
            is_supported,   # flag indicating whether the underlying group is supported
            subg1, subg2,   # representatives
            k;              # the reflection

      eclg := ActingDomain( ccs1 );
      if not ( eclg = ActingDomain( ccs2 ) ) then
        Error( "ccs1 and ccs2 must be from the same ECLG." );
      fi;

      is_supported := false;
      if not ( IdECLG( eclg ) in [ [ 1, 1 ], [ 2, 1 ] ] ) then
        Info( InfoEquiDeg, INFO_LEVEL_EquiDeg, "The underlying group of the CCSs is not supported." );
        return fail;
      fi;

      subg1 := Representative( ccs1 );
      subg2 := Representative( ccs2 );

      if IsSubset( subg2, subg1 ) then
        k := [ [ 1, 0 ], [ 0, -1 ] ];
        if ( k in subg2 ) and not ( k in subg1 ) then
          return infinity;
        else
          return 1;
        fi;
      else
        return 0;
      fi;
    end
  );

# ***
  InstallMethod( \<,
    "the partial order oe the conjugacy classes of subgroups of a compact Lie group",
    IsIdenticalObj,
    [ IsCompactLieGroupCCSRep, IsCompactLieGroupCCSRep ],
    function( ccs1, ccs2 )
      return ( nLHnumber( ccs1, ccs2 ) > 0 );
    end
  );


# ### Print, View and Display
# #### for ECLG
# ***
  InstallMethod( String,
    "string of ECLG",
    [ IsElementaryCompactLieGroup ],
    function( eclg )
      local string;

      if ( IdECLG( eclg ) = [ 1, 1 ] ) then
        string := "SpecialOrthogonalOverReal( 2 )";
      elif ( IdECLG( eclg ) = [ 2, 1 ] ) then
        string := "OrthogonalGroupOverReal( 2 )";
      fi;

      return string;
    end
  );

# ***
  InstallMethod( PrintObj,
    "print ECLG",
    [ IsElementaryCompactLieGroup ],
    10,
    function( eclg )
      Print( String( eclg ) );
    end
  );

# ***
  InstallMethod( ViewString,
    "view string of ECLG",
    [ IsElementaryCompactLieGroup ],
    10,
    function( eclg )
      local string;

      if ( IdECLG( eclg ) = [ 1, 1 ] ) then
        string := "SO(2,R)";
      elif ( IdECLG( eclg ) = [ 2, 1 ] ) then
        string := "O(2,R)";
      fi;

      return string;
    end
  );

# ***
  InstallMethod( ViewObj,
    "view ECLG",
    [ IsElementaryCompactLieGroup ],
    10,
    function( eclg )
      Print( ViewString( eclg ) );
    end
  );

# ***
  InstallMethod( DisplayString,
    "display string of ECLG",
    [ IsElementaryCompactLieGroup ],
    function( eclg )
      local string;

      if ( IdECLG( eclg ) = [ 1, 1 ] ) then
        string := "<group of 2x2 special orthogonal matrices over real>";
      elif ( IdECLG( eclg ) = [ 2, 1 ] ) then
        string := "<group of 2x2 orthogonal matrices over real>";
      fi;

      return string;
    end
  );

# ***
  InstallMethod( Display,
    "display ECLG",
    [ IsElementaryCompactLieGroup ],
    10,
    function( eclg )
      Print( DisplayString( eclg ) );
    end
  );

# #### for CCSs of ECLG
# ***
  InstallMethod( PrintString,
    "print string of CCS list of clg",
    [ IsCollection and IsCompactLieGroupCCSsRep ],
    function( ccss )
      local clg;

      clg := UnderlyingGroup( ccss );
      return Concatenation( "ConjugacyClassesSubgroups( ", String( clg ), " )" );
    end
  );

# ***
  InstallMethod( PrintObj,
    "print CCS list of compact Lie group",
    [ IsCollection and IsCompactLieGroupCCSsRep ],
    function( ccss )
      Print( PrintString( ccss ) );
    end
  );

# ***
  InstallMethod( ViewString,
    "view string of CCS list of CLG",
    [ IsCollection and IsCompactLieGroupCCSsRep ],
    function( ccss )
      local clg;

      clg := UnderlyingGroup( ccss );
      return Concatenation( "CCSs( ", ViewString( clg ), " )" );
    end
  );

# ***
  InstallMethod( ViewObj,
    "view CCS list of compact Lie group",
    [ IsCollection and IsCompactLieGroupCCSsRep ],
    function( ccss )
      Print( ViewString( ccss ) );
    end
  );

