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
            make_ccs_types,
            ccs_id;

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

      # setup CCS types
      make_ccs_types := function( )
        local ccs_types;

        ccs_types := [ ];
        # add SO(2)
        Add( ccs_types, rec(
          mode := 0,
          type := 1,
          order_of_weyl_group := [ 2, 0 ],
        ) );
        # add O(2)
        Add( ccs_types, rec(
          mode := 0,
          type := 2,
          order_of_weyl_group := [ 1, 0 ],
        ) );
        # add Z_m
        Add( ccs_types, rec(
          mode := 1,
          type := 1,
          order_of_weyl_group := [ 2, 1 ],
        ) );
        # add D_m
        Add( ccs_types, rec(
          mode := 1,
          type := 2,
          order_of_weyl_group := [ 2, 0 ],
        ) );

        return ccs_types;
      end;
      SetCCSTypes( ccss, make_ccs_types( ) );

      # setup CCSId
      ccs_id := function( id )
        local ccs,
              subg,
              ccs_info;

        if not ( Size( id ) = 2 ) then
          return fail;
        fi;

        if IsZero( id[ 2 ] ) and IsInt( id[ 2 ] ) then
          ccs_info := CCSTypesFiltered( ccss, rec( term := "zero_mode" ) )[ id[ 1 ] ];
          if ( id[ 1 ] = 1 ) then
            subg := SpecialOrthogonalGroupOverReal( d );
          elif ( id[ 1 ] = 2 ) then
            subg := grp;
          fi;
        elif IsPosInt( id[ 2 ] ) then
          ccs_info := CCSTypesFiltered( ccss, rec( term := "nonzero_mode" ) )[ id [ 1 ] ];
          if ( id[ 1 ] = 1 ) then
            subg := mCyclicGroup( id[ 2 ] );
          elif ( id[ 1 ] = 2 ) then
            subg := mDihedralGroup( id[ 2 ] );
          fi;
        else
          return fail;
        fi;

        ccs := Objectify( NewType( fam_ccs, cat_ccs and IsCompactLieGroupCCSRep ), rec( ccs_info := ccs_info ) );
        SetParentAttr( subg, grp );
        SetOrderOfWeylGroup( subg, ccs_info.order_of_weyl_group );
        SetIdCCS( ccs, id );
        SetRepresentative( ccs, subg );
        SetActingDomain( ccs, grp );
        SetOrderOfWeylGroup( ccs, ccs_info.order_of_weyl_group );

        return ccs;
      end;
      SetCCSId( ccss, ccs_id );

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
            make_ccs_types,
            ccs_id;

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
      make_ccs_types := function( )
        local ccs_types;

        ccs_types := [ ];
        # add SO(2)
        Add( ccs_types, rec(
          mode := 0,
          type := 1,
          order_of_weyl_group := [ 1, 0 ],
        ) );
        # add Z_m
        Add( ccs_types, rec(
          mode := 1,
          type := 1,
          order_of_weyl_group := [ 1, 1 ],
        ) );

        return ccs_types;
      end;
      SetCCSTypes( ccss, make_ccs_types( ) );

      # setup CCSId
      ccs_id := function( id )
        local ccs,
              subg,
              ccs_info;

        if not ( Size( id ) = 2 ) then
          return fail;
        fi;

        ccs := Objectify( NewType( fam_ccs, cat_ccs and IsCompactLieGroupCCSRep ), rec( ) );

        if IsZero( id[ 2 ] ) and IsInt( id[ 2 ] ) then
          ccs_info := CCSTypesFiltered( ccss, rec( term := "zero_mode" ) )[ id[ 1 ] ];
          subg := grp;
        elif IsPosInt( id[ 2 ] ) then
          ccs_info := CCSTypesFiltered( ccss, rec( term := "nonzero_mode" ) )[ id [ 1 ] ];
          subg := mCyclicGroup( id[ 2 ] );
        else
          return fail;
        fi;

        SetParentAttr( subg, grp );
        SetOrderOfWeylGroup( subg, ccs_info.order_of_weyl_group );
        SetIdCCS( ccs, id );
        SetRepresentative( ccs, subg );
        SetActingDomain( ccs, grp );
        SetOrderOfWeylGroup( ccs, ccs_info.order_of_weyl_group );

        return ccs;
      end;
      SetCCSId( ccss, ccs_id );

      return ccss;
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


# ## global function(s)
# ***
  InstallGlobalFunction( CCSTypesFiltered,
    function( ccss_grp, filters... )
      local ccs_types,
            filter;

      ccs_types := CCSTypes( ccss_grp );

      for filter in filters do
        if ( filter.term = "nonzero_mode" ) then
          ccs_types := Filtered( ccs_types, t -> IsPosInt( t.mode ) );
        elif ( filter.term = "zero_mode" ) then
          ccs_types := Filtered( ccs_types, t -> IsZero( t.mode ) and IsInt( t.mode ) );
        elif ( filter.term = "with_k_dim_weyl_group" ) then
          ccs_types := Filtered( ccs_types, t -> ( t.order_of_weyl_group[ 2 ] = filter.dim ) );
        else
          Error( "Invalid filter type" );
        fi;
      od;

      return ccs_types;
    end
  );


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

