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
            fam,                # family of element
            collfam,            # family of (sub)group
            grp,                # (special) orthogonal group
            i, j, k;            # indices

      # generate the identity of the (special) orthogonal group
      # which is a d-by-d identity matrix
      one := One( List( [ 1 .. d ], i -> List( [ 1 .. d ], j -> 0 ) ) );

      # define families
      fam := FamilyObj( one );
      collfam := CollectionsFamily( fam );

      # objectify the (special) orthogonal group
      grp := Objectify( NewType( collfam, filter ), rec() );

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
      local grp,              # the orthogonal group
            fam,              # the family of (sub)group
            collfam,          # the family of CCS
            collcollfam,      # the family of CCS list
            cat,              # the category of (sub)group
            collcat,          # the category of CCS
            collcollcat,      # the category of CCS list
            ccs_list;         # the CCS list

      # objectify the group
      grp := NewCompactLieGroup( IsOrthogonalGroupOverReal and IsCompactLieGroupRep, d );

      # setup families
      fam := FamilyObj( grp );
      collfam := CollectionsFamily( fam );
      collcollfam := CollectionsFamily( collfam );
      cat := IsGroup;
      collcat := CategoryCollections( cat );
      collcollcat := CategoryCollections( collcat );

      # setup the CCS list
      ccs_list := Objectify( NewType( collcollfam, IsOrthogonalGroupOverRealCCSs and collcollcat and IsCompactLieGroupCCSsRep ), rec( ) );

      SetUnderlyingGroup( ccs_list, grp );
      SetIsFinite( ccs_list, false );
      SetConjugacyClassesSubgroups( grp, ccs_list );

      return grp;
    end
  );

# ***
  InstallMethod( SpecialOrthogonalGroupOverReal,
    "generate a special orthogonal group over real numbers",
    [ IsPosInt ],
    function( d )
      local grp,              # the orthogonal group
            fam,              # the family of (sub)group
            collfam,          # the family of CCS
            collcollfam,      # the family of CCS list
            cat,              # the category of (sub)group
            collcat,          # the category of CCS
            collcollcat,      # the category of CCS list
            ccs_list;         # the CCS list

      # objectify the group
      grp := NewCompactLieGroup( IsSpecialOrthogonalGroupOverReal and IsCompactLieGroupRep, d );

      # setup families
      fam := FamilyObj( grp );
      collfam := CollectionsFamily( fam );
      collcollfam := CollectionsFamily( collfam );
      cat := IsGroup;
      collcat := CategoryCollections( cat );
      collcollcat := CategoryCollections( collcat );

      # setup the CCS list
      ccs_list := Objectify( NewType( collcollfam, IsSpecialOrthogonalGroupOverRealCCSs and collcollcat and IsCompactLieGroupCCSsRep ), rec( ) );

      SetUnderlyingGroup( ccs_list, grp );
      SetIsFinite( ccs_list, false );
      SetConjugacyClassesSubgroups( grp, ccs_list );

      return grp;
    end
  );


# ### operation(s)
# ***
  InstallMethod( \[\],
    "Element access of CCS list of O(2)",
    [ IsOrthogonalGroupOverRealCCSs and IsCompactLieGroupCCSsRep, IsPosInt ],
    function( ccs_list, n )
      local d,            # dimension of the matrices in the group
            grp,          # the orthogonal group
            ccs,          # CCS
            subg,         # representative of the CCS
            fam,          # family of (sub)group
            collfam,      # family of CCS
            cat,          # category of (sub)group
            collcat,      # category of CCS
            normalizer,   # normalizer of subg
            k;            # fourier mode

      grp := UnderlyingGroup( ccs_list );
      d := DimensionOfMatrixGroup( grp );
      fam := FamilyObj( grp );
      collfam := CollectionsFamily( fam );
      cat := IsGroup;
      collcat := CategoryCollections( cat );
      ccs := Objectify( NewType( collfam, collcat and IsConjugacyClassSubgroupsRep ), rec( ) );

      if ( d = 2 ) then
        if ( n = 1 ) then
          subg := SpecialOrthogonalGroupOverReal( 2 );
          normalizer := grp;
        elif ( n = 2 ) then
          subg := OrthogonalGroupOverReal( 2 );
          normalizer := grp;
        elif IsOddInt( n ) then
          k := (n-1)/2;
          subg := mCyclicGroup( k );
          normalizer := grp;
        elif IsEvenInt( n ) then
          k := (n-2)/2;
          subg := mDihedralGroup( k );
          normalizer := mDihedralGroup( 2*k );
        fi;
      else
        TryNextMethod( );
      fi;

      SetParentAttr( subg, grp );
      SetRepresentative( ccs, subg );
      SetActingDomain( ccs, grp );
      SetStabilizerOfExternalSet( ccs, normalizer );

      return ccs;
    end
  );

# ***
  InstallMethod( \[\],
    "Element access of CCS list of O(2)",
    [ IsSpecialOrthogonalGroupOverRealCCSs and IsCompactLieGroupCCSsRep, IsPosInt ],
    function( ccs_list, n )
      local d,            # dimension of the matrices in the group
            grp,          # the orthogonal group
            ccs,          # CCS
            subg,         # representative of the CCS
            fam,          # family of (sub)group
            collfam,      # family of CCS
            cat,          # category of (sub)group
            collcat,      # category of CCS
            normalizer,   # normalizer of subg
            k;            # fourier mode

      grp := UnderlyingGroup( ccs_list );
      d := DimensionOfMatrixGroup( grp );
      fam := FamilyObj( grp );
      collfam := CollectionsFamily( fam );
      cat := IsGroup;
      collcat := CategoryCollections( cat );
      ccs := Objectify( NewType( collfam, collcat and IsConjugacyClassSubgroupsRep ), rec( ) );

      if ( d = 2 ) then
        if ( n = 1 ) then
          subg := SpecialOrthogonalGroupOverReal( 2 );
          normalizer := grp;
        else
          k := n-1;
          subg := mCyclicGroup( k );
          normalizer := grp;
        fi;
      else
        TryNextMethod( );
      fi;

      SetParentAttr( subg, grp );
      SetRepresentative( ccs, subg );
      SetActingDomain( ccs, grp );
      SetStabilizerOfExternalSet( ccs, normalizer );

      return ccs;
    end
  );

# ***
  InstallMethod( IdCCS,
    "CCS accessor by Id",
    [ IsCompactLieGroupCCSsRep, IsList ],
    function( ccs_list, id )
      if not ( Size( id ) = 2 ) then
        TryNextMethod( );
      fi;

      if IsOrthogonalGroupOverRealCCSs( ccs_list ) and ( id[ 1 ] in [ 1, 2 ] ) then
        return ccs_list[ id[ 1 ] + 2*id[ 2 ] ];
      elif IsSpecialOrthogonalGroupOverRealCCSs( ccs_list ) and ( id[ 1 ] = 1 ) then
        if id[ 1 ] = 1 then
          return ccs_list[ 1 + id[ 2 ] ];
        else
          return fail;
        fi;
      else
        return fail;
      fi;
    end
  );

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

# ???
# InstallMethod( Position,
#   "Position for CCS list of a compact Lie group",
#   [ IsCompactLieGroupCCSsRep, IsObject ],
#   function( ccs_list, ccs )
#     local grp1,
#           grp2;

#     Print( "hi\n" );

#     if not IsIdenticalObj( FamilyObj( ccs ), ElementsFamily( FamilyObj( ccs_list ) ) ) then
#       return fail;
#     fi;

#     if not IsConjugacyClassSubgroupsRep( ccs ) then
#       return fail;
#     fi;

#     grp1 := UnderlyingGroup( ccs_list );
#     grp2 := ActingDomain( ccs );
#   end
# );


# ### print, view and display
# ***
  InstallMethod( PrintString,
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
      Print( PrintString( grp ) );
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
  InstallMethod( PrintString,
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
      Print( PrintString( grp ) );
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
      return Concatenation( "ConjugacyClassesSubgroups( ", PrintString(grp), " )" );
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

