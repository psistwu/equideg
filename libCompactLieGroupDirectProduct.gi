# # GAP: Compact Lie Group Library
#
# Implementation file of libCompactLieGroupDirectProduct.g
#
# Author:
# Haopin Wu <psistwu@outlook.com>
#

# ### Operation(s)
  InstallMethod( DirectProductOp,
    "Direct Product of O(2) and a finite group",
    [ IsList, IsOrthogonalGroupOverReal ],
    function( list, o2 )
      local truncated_list,        # the group list without the first group
            prod_grp,              # the product group
            elmt_fam_list,         # list of elements family of each group in the group list
            one_list,              # list of identities of groups
            prod_grp_fam;          # the family of the product group

      truncated_list := ShallowCopy( list );
      Remove( truncated_list, 1 );

      if not ForAll( truncated_list, IsFinite ) then
        TryNextMethod( );
      fi;

      if not ( DimensionOfMatrixGroup( o2 ) = 2 ) then
        TryNextMethod( );
      fi;

      # generate direct product of all finite groups in the list
      prod_grp := DirectProduct( truncated_list );

      # generate direct product with O(2)
      elmt_fam_list := List( list, grp -> ElementsFamily( FamilyObj( grp ) ) );
      prod_grp_fam := CollectionsFamily( DirectProductElementsFamily( elmt_fam_list ) );
      prod_grp := Objectify( NewType( prod_grp_fam, IsDirectProductWithOrthogonalGroupOverReal and IsCompactLieGroupRep ), rec() );

      # setup property(s) and attribute(s) of the product group
      SetDirectProductInfo( prod_grp, rec(
          groups := list,
          embeddings := [ ],
          projections := [ ]
      ) );
      one_list := List( list, One );
      SetOneImmutable( prod_grp, DirectProductElement( one_list ) );

      return prod_grp;
    end
  );


# ### Print, View and Display
  InstallMethod( String,
    "print string of direct product with Lie group",
    [ IsDirectProductWithCompactLieGroup ],
    function( grp )
      local info,            # direct product info
            g,               # direct product component
            str;             # return string

      str := "DirectProduct(";
      info := DirectProductInfo( grp );
      for g in info.groups do
        Append( str, " " );
        Append( str, String( g ) );
        Append( str, "," );
      od;
      Remove( str );
      Append( str, " )" );

      return str;
    end
  );

# ***
  InstallMethod( PrintObj,
    "print direct product with compact Lie group",
    [ IsDirectProductWithCompactLieGroup ],
    function( grp )
      Print( String( grp ) );
    end
  );

# ***
  InstallMethod( ViewString,
    "view string of direct product with compact Lie group",
    [ IsDirectProductWithCompactLieGroup ],
    function( grp )
      local info,            # direct product info
            g,               # direct product component
            str;             # return string

      str := "DirectProduct(";
      info := DirectProductInfo( grp );
      for g in info.groups do
        Append( str, " " );
        Append( str, ViewString( g ) );
        Append( str, "," );
      od;
      Remove( str );
      Append( str, " )" );

      return str;
    end
  );

# ***
  InstallMethod( ViewObj,
    "view direct product with comapct Lie group",
    [ IsDirectProductWithCompactLieGroup ],
    function( grp )
      Print( ViewString( grp ) );
    end
  );