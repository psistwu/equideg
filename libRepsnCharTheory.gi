#-------
# GAP: Representation and Character Theory Library
#-------
# Implementation filw of libRepresentationCharacterTheory.g
#
# Author: Hao-pin Wu <hxw132130@utdallas.edu>
# Last update: 2016-11-28
#-------

#-----
# attribute(s)
#-----

#---
# SchurIndicator
#---
  InstallMethod( SchurIndicator,
    "the Schur indicator of a irreducible representation",
    [ IsIrreducibleCharacter ],
    function( chi )

      local G,		# the underlying group
            cc_list,	# the list of conjugacy classes of g
            indicator,	# the Schur indicator
            i,		# index
            e,		# element in g
            tr;		# trace

      G := UnderlyingGroup( chi );
      cc_list := ConjugacyClasses( G );

      indicator := 0;
      for i in [ 1..Size(cc_list) ] do
        e := Representative( cc_list[i] );
        tr := chi[ PositionProperty( cc_list, cc -> e^2 in cc ) ];
        indicator := indicator + Size( cc_list[ i ] ) * tr;
      od;
      indicator := indicator / Order( G );

      return indicator;

    end
  );
#---

#-----
# property(s)
#-----

#-----
# method(s)
#-----

#-----
# function(s)
#-----

