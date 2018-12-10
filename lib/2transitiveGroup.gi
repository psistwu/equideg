#-------
# GAP: 2-transitive Group Library
#-------
# Implementation file of lib2transitiveGroup.g
#
# Author: Hao-pin Wu <hxw132130@utdallas.edu>
#-------

#-----
# attribute(s)
#-----

#---
# 2transitivity
#---
  InstallMethod( 2transitivity,
    "2-transitivity of a given group",
    [ IsGroup and IsFinite ],
    function( G )
      local ccs,
            chtbl,
            2trans,
            rho,
            c,
            H,
            rho_H,
            tri_H;

      ccs := ConjugacyClassesSubgroups( G );
      chtbl := CharacterTable( G );
      2trans := [ ];

      for rho in Irr( chtbl ) do
        if rho = TrivialCharacter( chtbl ) then
          continue;
        fi;

        for c in ccs do
          H := Representative( c );
          if ( Index( G, H ) = DegreeOfCharacter( rho ) + 1 ) then
            rho_H := RestrictedClassFunction( rho, H );
            tri_H := TrivialCharacter( H );
            if ( ScalarProduct( rho_H, tri_H ) > 0 ) then
              Add( 2trans, [ rho, c ] );
              break;
            fi;
          fi;
        od;
      od;
      return 2trans;
    end
  );

#-----
# property(s)
#-----

#---
# Is2transitiveGroup
#---
  InstallMethod( Is2transitiveGroup,
    "2transitivity of a given group",
    [ IsGroup and IsFinite ],
    function( G )
    end
  );

#-----
# method(s)
#-----

#-----
# function(s)
#-----

