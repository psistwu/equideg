#############################################################################
##
#W  Group.gi		GAP Package `EquiDeg'			    Haopin Wu
##
#Y  Copyright (C) 2017-2019, Haopin Wu
#Y  Department of Mathematics, National Tsing Hua University, Taiwan
##
##  This file contains implementations for procedures
##  related to polynomial.
##

#############################################################################
##
#A  LowestDegree( <lpol> )
##
  InstallMethod( LowestDegree,
    "",
    [ IsLaurentPolynomial ],
    function( lpol )
      if IsZero( lpol ) then
        return -infinity;
      else
        return -DegreeOfLaurentPolynomial(
               DenominatorOfRationalFunction( lpol ) );
      fi;
    end
  );

#############################################################################
##
#O  Coefficient( <lpol>, <n> )
##
  InstallMethod( Coefficient,
    "",
    [ IsLaurentPolynomial, IsInt ],
    function( lpol, n )
      local l, h,
            coeffs;

      l := LowestDegree( lpol );
      h := DegreeOfLaurentPolynomial( lpol );

      if IsZero( lpol ) then
        return 0;
      elif ( n > h ) or ( n < l ) then
	return 0;
      else
        coeffs := CoefficientsOfLaurentPolynomial( lpol );
        return coeffs[ 1 ][ n - l + 1 ];
      fi;
    end
  );


#############################################################################
##
#E  Group.gi . . . . . . . . . . . . . . . . . . . . . . . . . . .  ends here
