# # GAP: Compact Lie Group Library
#
# Implementation file of libCompactLieGroup.g
#
# Author:
# Haopin Wu <psistwu@outlook.com>
#


# ### constructor(s)
# ***
  InstallMethod( NewCompactLieGroup,
    "return a compact Lie group",
    [ IsOrthogonalGroupOverReal and IsSpecialOrthogonalGroupOverReal and IsCompactLieGroupRep, IsPosInt ],
    function( filter, d )
      local one,                # identity of (special) orthogonal group
            fam_grp,            # family of the group
            grp;                # (special) orthogonal group

      # generate the identity of the (special) orthogonal group
      # which is a d-by-d identity matrix
      one := One( List( [ 1 .. d ], i -> List( [ 1 .. d ], j -> 0 ) ) );

      # define the family of the group
      fam_grp := CollectionsFamily( FamilyObj( one ) );

      # objectify the (special) orthogonal group
      grp := Objectify( NewType( fam_grp, filter ), rec() );

      # setup properties of the (special) orthogonal group
      SetOneImmutable( grp, one );            # identity
      SetDimension( grp, d*(d-1)/2 );         # dimension of the (special) orthogonal group
      SetDimensionOfMatrixGroup( grp, d );    # dimension of matrices in the (special) orthogonal group
      SetIsFinite( grp, false );              # order of the (special) orthogonal group

      return grp;
    end
  );

# ***
  InstallMethod( OrthogonalGroupOverReal,
    "generate an orthogonal group over real numbers",
    [ IsPosInt ],
    function( d )
      local grp;              # the orthogonal group

      # objectify the group
      grp := NewCompactLieGroup( IsOrthogonalGroupOverReal and IsCompactLieGroupRep, d );

      # setup property(s) and attribute(s) of the group
      SetIsAbelian( grp, false );

      return grp;
    end
  );

# ***
  InstallMethod( SpecialOrthogonalGroupOverReal,
    "generate a special orthogonal group over real numbers",
    [ IsPosInt ],
    function( d )
      local grp;              # the special orthogonal group

      # objectify the group
      grp := NewCompactLieGroup( IsSpecialOrthogonalGroupOverReal and IsCompactLieGroupRep, d );

      # setup property(s) and attribute(s) of the group
      SetIsAbelian( grp, true );

      return grp;
    end
  );

# ***
  InstallMethod( NewCCS,
    "return a CCS of a compact Lie group",
    [ IsCompactLieGroupCCSRep, IsRecord, IsInt ],
    function( filter, ccs_class, mode )
      local d,
            ccs,
            subg,
            normalizer,
            fam_ccs,
            cat_ccs;

      if ( mode < 0 ) or ( ccs_class.is_zero_mode <> ( mode = 0 ) ) then
        Error( "Illegel mode for the selected CCS class." );
      fi;

      d := DimensionOfMatrixGroup( ccs_class.group );

      # find representative subgroup and its normalizer
      if ccs_class.is_zero_mode then
        if ( ccs_class.type = 1 ) then
          subg := SpecialOrthogonalGroupOverReal( d );
          normalizer := ccs_class.group;
        elif ( ccs_class.type = 2 ) then
          subg := OrthogonalGroupOverReal( d );
          normalizer := ccs_class.group;
        else
          return fail;
        fi;
      else
        if ( ccs_class.type = 1 ) then
          subg := mCyclicGroup( mode );
          normalizer := ccs_class.group;
        elif ( ccs_class.type = 2 ) then
          subg := mDihedralGroup( mode );
          normalizer := mDihedralGroup( 2*mode );
        else
          return fail;
        fi;
      fi;

      # objectify the CCS
      fam_ccs := CollectionsFamily( FamilyObj( ccs_class.group ) );
      cat_ccs := CategoryCollections( IsMatrixGroup );
      ccs := Objectify( NewType( fam_ccs, cat_ccs and filter ), rec( ) );

      # setup attributes of CCS
      SetParentAttr( subg, ccs_class.group );
      SetNormalizerInParent( subg, normalizer );
      SetOrderOfWeylGroup( subg, ccs_class.order_of_weyl_group );
      SetIsZeroModeCCS( ccs, ccs_class.is_zero_mode );
      SetActingDomain( ccs, ccs_class.group );
      SetStabilizerOfExternalSet( ccs, normalizer );
      SetOrderOfWeylGroup( ccs, ccs_class.order_of_weyl_group );
      SetRepresentative( ccs, subg );
      SetIdCCS( ccs, [ ccs_class.type, mode ] );

      return ccs;
    end
  );


# ### Attribute(s)
# ***
  InstallMethod( ConjugacyClassesSubgroups,
    "CCSs of O(2)",
    [ IsOrthogonalGroupOverReal and IsCompactLieGroupRep ],
    function( grp )
      local d,
            fam_ccs,
            fam_ccss,
            cat_ccs,
            cat_ccss,
            ccss,
            make_ccs_classes;

      # it works only for O(2)
      d := DimensionOfMatrixGroup( grp );
      if not ( d = 2 ) then
        TryNextMethod( );
      fi;

      # define families and collections
      fam_ccs := CollectionsFamily( FamilyObj( grp ) );
      fam_ccss := CollectionsFamily( fam_ccs );
      cat_ccs := CategoryCollections( IsMatrixGroup );
      cat_ccss := CategoryCollections( cat_ccs );

      # objectify CCSs of the group
      ccss := Objectify( NewType( fam_ccss, cat_ccss and IsCompactLieGroupCCSsRep ), rec( ) );
      SetUnderlyingGroup( ccss, grp );
      SetIsFinite( ccss, false );

      # setup CCS classes
      make_ccs_classes := function( )
        local ccs_classes;

        ccs_classes := [ ];
        # add SO(2)
        Add( ccs_classes, rec(
          group := grp,
          is_zero_mode := true,
          type := 1,
          order_of_weyl_group := [ 2, 0 ],
        ) );
        # add O(2)
        Add( ccs_classes, rec(
          group := grp,
          is_zero_mode := true,
          type := 2,
          order_of_weyl_group := [ 1, 0 ],
        ) );
        # add Z_m
        Add( ccs_classes, rec(
          group := grp,
          is_zero_mode := false,
          type := 1,
          order_of_weyl_group := [ 2, 1 ],
        ) );
        # add D_m
        Add( ccs_classes, rec(
          group := grp,
          is_zero_mode := false,
          type := 2,
          order_of_weyl_group := [ 2, 0 ],
        ) );

        return ccs_classes;
      end;
      SetCCSClasses( ccss, make_ccs_classes( ) );

      return ccss;
    end
  );

# ***
  InstallMethod( ConjugacyClassesSubgroups,
    "CCSs of SO(2)",
    [ IsSpecialOrthogonalGroupOverReal and IsCompactLieGroupRep ],
    function( grp )
      local d,
            fam_ccs,
            fam_ccss,
            cat_ccs,
            cat_ccss,
            ccss,
            make_ccs_classes;

      # it works only for SO(2)
      d := DimensionOfMatrixGroup( grp );
      if not ( d = 2 ) then
        TryNextMethod( );
      fi;

      # define families and collections
      fam_ccs := CollectionsFamily( FamilyObj( grp ) );
      fam_ccss := CollectionsFamily( fam_ccs );
      cat_ccs := CategoryCollections( IsMatrixGroup );
      cat_ccss := CategoryCollections( cat_ccs );

      # objectify CCSs of the group
      ccss := Objectify( NewType( fam_ccss, cat_ccss and IsCompactLieGroupCCSsRep ), rec( ) );
      SetUnderlyingGroup( ccss, grp );
      SetIsFinite( ccss, false );

      # setup CCS types
      make_ccs_classes := function( )
        local ccs_classes;

        ccs_classes := [ ];
        # add SO(2)
        Add( ccs_classes, rec(
          group := grp,
          is_zero_mode := true,
          type := 1,
          order_of_weyl_group := [ 1, 0 ],
        ) );
        # add Z_m
        Add( ccs_classes, rec(
          group := grp,
          is_zero_mode := false,
          type := 1,
          order_of_weyl_group := [ 1, 1 ],
        ) );

        return ccs_classes;
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
      local nu,
            term,
            d,
            mode,
            ccs_classes;

      ccs_classes := CCSClasses( ccss );
      nu := 0;

      while not IsEmpty( args ) do
        term := Remove( args, 1 );
        nu := nu+1;

        if ( term = "nonzero_mode" ) then
          ccs_classes := Filtered( ccs_classes, cl -> not cl.is_zero_mode );
          mode := 1;
        elif ( term = "zero_mode" ) then
          ccs_classes := Filtered( ccs_classes, cl -> cl.is_zero_mode );
          mode := 0;
        elif ( term = "with_m-dim_weyl_group" ) then
          d := Remove( args, 1 );
          if not IsInt( d ) or ( d < 0 ) then
            Error( "Valid dimension is required for ", nu, "-th filter term." );
          fi;
          ccs_classes := Filtered( ccs_classes, cl -> ( cl.order_of_weyl_group[ 2 ] = d ) );
        else
          Error( nu, "-th filter term is invalid." );
        fi;
      od;

      Sort( ccs_classes,
        function( cl1, cl2 )
          local ccs1, ccs2;

          ccs1 := NewCCS( IsCompactLieGroupCCSRep, cl1, mode );
          ccs2 := NewCCS( IsCompactLieGroupCCSRep, cl2, mode );

          return ccs1 < ccs2;
        end
      );

      return ccs_classes;
    end
  );

# ***
  InstallMethod( CCSId,
    "return CCSId attribute of a compact Lie group CCS list",
    [ IsCompactLieGroupCCSsRep ],
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

      ccs := NewCCS( IsCompactLieGroupCCSRep, ccs_class, id[ 2 ] );
      SetIdCCS( ccs, id );

      return ccs;
    end
  );

# ### Operation(s)
# ***
  InstallMethod( \in,
    "Membership test for O(n)",
    [ IsObject, IsOrthogonalGroupOverReal ],
    function( obj, grp )
      if IsIdenticalObj( CollectionsFamily( FamilyObj( obj ) ), FamilyObj( grp ) ) and ( TransposedMat( obj ) * obj = One( grp ) ) then
        return true;
      else
        return false;
      fi;
    end
  );

# ***
  InstallMethod( \in,
    "Membership test for SO(n)",
    [ IsObject, IsSpecialOrthogonalGroupOverReal ],
    function( obj, grp )
      if IsIdenticalObj( CollectionsFamily( FamilyObj( obj ) ), FamilyObj( grp ) ) and ( TransposedMat( obj ) * obj = One( grp ) ) and ( Determinant( obj ) = 1 ) then
        return true;
      else
        return false;
      fi;
    end
  );

# ***
  InstallMethod( IsSubset,
    "Test if a finite group is a subgroup of a compact Lie group",
    IsIdenticalObj,
    [ IsCompactLieGroup, IsGroup ],
    function( grp, subg )
      local elmt;

      if not IsFinite( subg ) then
        TryNextMethod( );
      fi;

      for elmt in List( subg ) do
        if not ( elmt in grp ) then
          return false;
        fi;
      od;

      return true;
    end
  );

# ***
  InstallMethod( IsSubset,
    "Test if a compact Lie group is a subgroup of a finite group",
    IsIdenticalObj,
    [ IsGroup, IsCompactLieGroup ],
    function( grp, subg )
      if IsFinite( grp ) then
        return false;
      else
        TryNextMethod( );
      fi;
    end
  );

# ***
  InstallMethod( IsSubset,
    "Test if a compact Lie group is a subset of another compact Lie group",
    IsIdenticalObj,
    [ IsOrthogonalGroupOverReal, IsSpecialOrthogonalGroupOverReal ],
    function( on, son )
      return ( DimensionOfMatrixGroup( on ) = DimensionOfMatrixGroup( son ) );
    end
  );

# ***
  InstallMethod( IsSubset,
    "Test if a compact Lie group is a subset of another compact Lie group",
    IsIdenticalObj,
    [ IsSpecialOrthogonalGroupOverReal, IsSpecialOrthogonalGroupOverReal ],
    function( on, son )
      return ( DimensionOfMatrixGroup( on ) = DimensionOfMatrixGroup( son ) );
    end
  );

# ***
  InstallMethod( IsSubset,
    "Test if a compact Lie group is a subset of another compact Lie group",
    IsIdenticalObj,
    [ IsOrthogonalGroupOverReal, IsOrthogonalGroupOverReal ],
    function( on, son )
      return ( DimensionOfMatrixGroup( on ) = DimensionOfMatrixGroup( son ) );
    end
  );

# ***
  InstallMethod( \=,
    "the equivalence relation of the conjugacy classes of subgroups of a compact Lie group",
    IsIdenticalObj,
    [ IsCompactLieGroupCCSRep, IsCompactLieGroupCCSRep ],
    function( ccs1, ccs2 )
      if not ( ActingDomain( ccs1 ) = ActingDomain( ccs2 ) ) then
        return false;
      else
        return IdCCS( ccs1 ) = IdCCS( ccs2 );
      fi;
    end
  );

# ***
  InstallMethod( \<,
    "the partial order oe the conjugacy classes of subgroups of a compact Lie group",
    IsIdenticalObj,
    [ IsCompactLieGroupCCSRep, IsCompactLieGroupCCSRep ],
    function( ccs1, ccs2 )
      return nLHnumber( ccs1, ccs2 ) > 0;
    end
  );

# ***
  InstallMethod( nLHnumber,
    "return n(L,H) number for subgroups of compact Lie group",
    IsIdenticalObj,
    [ IsCompactLieGroupCCSRep, IsCompactLieGroupCCSRep ],
    function( ccs1, ccs2 )
      local id1, id2;

      if not ( ActingDomain( ccs1 ) = ActingDomain( ccs2 ) ) then
        Error( "ccs1 and ccs2 must be from the same group.");
      fi;

      id1 := IdCCS( ccs1 );
      id2 := IdCCS( ccs2 );

      if IsZero( id1[ 2 ] ) and IsZero( id2[ 2 ] ) and ( id1[ 1 ] <= id2[ 1 ] ) then
        return 1;
      elif IsPosInt( id1[ 2 ] ) and IsZero( id2 mod id1 ) then
        if ( id1[ 1 ] = 1 ) and ( id2[ 1 ] = 2 ) and IsPosInt( id2[ 2 ] ) then
          return infinity;
        else
          return 1;
        fi;
      else
        return 0;
      fi;
    end
  );


# ## global function(s)


# ### print, view and display
# ***
  InstallMethod( String,
    "print string of orthogonal groups",
    [ IsOrthogonalGroupOverReal ],
    function( grp )
      local d;    # dimension of matrices

      d := String( DimensionOfMatrixGroup( grp ) );
      return Concatenation( "OrthogonalGroupOverReal(", d, ")" );
    end
  );

# ***
  InstallMethod( PrintObj,
    "print orthogonal groups",
    [ IsOrthogonalGroupOverReal ],
    10,
    function( grp )
      Print( String( grp ) );
    end
  );

# ***
  InstallMethod( ViewString,
    "view string of orthogonal groups",
    [ IsOrthogonalGroupOverReal ],
    function( grp )
      local d;        # dimension of matrices

      d := String( DimensionOfMatrixGroup( grp ) );
      return Concatenation( "O(", d, ")" );
    end
  );

# ***
  InstallMethod( ViewObj,
    "print orthogonal groups",
    [ IsOrthogonalGroupOverReal ],
    10,
    function( grp )
      Print( ViewString( grp ) );
    end
  );

# ***
  InstallMethod( DisplayString,
    "display string of orthogonal groups",
    [ IsOrthogonalGroupOverReal ],
    function( grp )
      local d;        # dimension of matrices

      d := String( DimensionOfMatrixGroup( grp ) );
      return Concatenation( "<group of ", d, "x", d, " orthogonal matrices over real>" );
    end
  );

# ***
  InstallMethod( Display,
    "display orthogonal groups",
    [ IsOrthogonalGroupOverReal ],
    function( grp )
      Print( DisplayString( grp ) );
    end
  );

# ***
  InstallMethod( String,
    "print string of special orthogonal groups",
    [ IsSpecialOrthogonalGroupOverReal ],
    function( grp )
      local d;    # dimension of matrices

      d := String( DimensionOfMatrixGroup( grp ) );
      return Concatenation( "SpecialOrthogonalGroupOverReal(", d, ")" );
    end
  );

# ***
  InstallMethod( PrintObj,
    "print special orthogonal groups",
    [ IsSpecialOrthogonalGroupOverReal ],
    10,
    function( grp )
      Print( String( grp ) );
    end
  );

# ***
  InstallMethod( ViewString,
    "view string of special orthogonal groups",
    [ IsSpecialOrthogonalGroupOverReal ],
    function( grp )
      local d;    # dimension of matrices

      d := String( DimensionOfMatrixGroup( grp ) );
      return Concatenation( "SO(", d, ")" );
    end
  );

# ***
  InstallMethod( ViewObj,
    "view special orthogonal groups",
    [ IsSpecialOrthogonalGroupOverReal ],
    10,
    function( grp )
      Print( ViewString( grp ) );
    end
  );

# ***
  InstallMethod( DisplayString,
    "display string of orthogonal groups",
    [ IsSpecialOrthogonalGroupOverReal ],
    function( grp )
      local d;        # dimension of matrices

      d := String( DimensionOfMatrixGroup( grp ) );
      return Concatenation( "<group of ", d, "x", d, " special orthogonal matrices over real>" );
    end
  );

# ***
  InstallMethod( Display,
    "display orthogonal groups",
    [ IsSpecialOrthogonalGroupOverReal ],
    function( grp )
      Print( DisplayString( grp ) );
    end
  );

# ***
  InstallMethod( PrintString,
    "print string of CCS list of compact Lie group",
    [ IsCollection and IsCompactLieGroupCCSsRep ],
    function( ccs_list )
      local grp;

      grp := UnderlyingGroup( ccs_list );
      return Concatenation( "ConjugacyClassesSubgroups( ", String(grp), " )" );
    end
  );

# ***
  InstallMethod( PrintObj,
    "print CCS list of compact Lie group",
    [ IsCollection and IsCompactLieGroupCCSsRep ],
    function( ccs_list )
      Print( PrintString( ccs_list ) );
    end
  );

# ***
  InstallMethod( ViewString,
    "view string of CCS list of compact Lie group",
    [ IsCollection and IsCompactLieGroupCCSsRep ],
    function( ccs_list )
      local grp;

      grp := UnderlyingGroup( ccs_list );
      return Concatenation( "CCSs( ", ViewString(grp), " )" );
    end
  );

# ***
  InstallMethod( ViewObj,
    "view CCS list of compact Lie group",
    [ IsCollection and IsCompactLieGroupCCSsRep ],
    function( ccs_list )
      Print( ViewString( ccs_list ) );
    end
  );

