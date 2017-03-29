#-------
# GAP: Group Direct Product Library
#-------
# Implementation file of libGroupDirectProduct.g
#-------

#-----
# attribute(s)
#-----

#---
# SubgroupDirectProecuctInfo
#---
  InstallMethod( SubgroupDirectProductInfo,
    "find the direct product info of a subgroup of a direct prodcut group",
    [ IsGroup and HasParentAttr ],
    function( obj )

      local g,		# the parent group g=g1xg2
	    proj1,		# projection to G1
	    proj2,		# projection to G2
	    embed1,		# embedding from G1
	    embed2,		# embedding from G2
	    h1, h2, k1, k2;

      g := ParentAttr( obj );

      if not ( Size( DirectProductInfo( g ).groups ) = 2 ) then
        Info( ERROR, MSGLEVEL, "The given subgroup has to be a subgroup of the direct product of TWO groups." );
        Error();
      fi;

      proj1 := Projection( g, 1 );
      proj2 := Projection( g, 2 );
      embed1 := Embedding( g, 1 );
      embed2 := Embedding( g, 2 );

      h1 := Image( proj1, obj );
      k1 := Image( proj1, Intersection( Image( embed1 ), obj ) );
      h2 := Image( proj2, obj );
      k2 := Image( proj2, Intersection( Image( embed2 ), obj ) );

      return rec( h1 := h1, k1 := k1, h2 := h2, k2 := k2 );

    end
  );
#---

#-----
# property(s)
#-----

#-----
# operation(s)
#-----

#-----
# function(s)
#-----

