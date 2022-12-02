#############################################################################
##
##  EulerRing.gi	GAP Package `EquiDeg'			    Haopin Wu
##
#Y  Copyright (C) 2017-2022, Haopin Wu
##
##  This file contains implementations for procedures
##  related to Euler ring.
##

##  Part 1: Euler ring element

#############################################################################
##
#U  NewEulerRingElement( <filt>, <r> )
##
  InstallMethod( NewEulerRingElement,
    "constructs Euler ring element",
    [ IsEulerRingByCompactLieGroupElement,
      IsRecord ],
    function( filt, r )
      local fam,
            cat,
            rep;

            fam := r.fam;
            cat := filt;
            rep := IsEulerRingElementRep;

      return Objectify( NewType( fam, cat and rep ),
        rec( ccsList	:= r.ccs_list,
             ccsIdList	:= r.ccs_id_list,
             coeffList	:= r.coeff_list   )
      );
    end
  );

#############################################################################
##
#A  String( <a> )
##
  InstallMethod( String,
    "string of a Euler ring element",
    [ IsEulerRingElement ],
    function( a )
      local i,		# index
            ccs,
            ccs_id,	# id of CCS
            coeff,	# coefficient
            ccs_name,	# name of CCS
            str;	# name string

      str := "";
      for i in [ 1 .. Length( a ) ] do
        coeff	:= a!.coeffList[ i ];
        ccs_id	:= a!.ccsIdList[ i ];
        ccs	:= a!.ccsList[ i ];

        ccs_name := StringFormatted(
          "({})",
          JoinStringsWithSeparator( Flat( [ ccs_id ] ), "," )
        );

        # append coefficient and name of CCS
        if ( i > 1 ) and ( coeff > 0 ) then
          Append( str, "+" );
        fi;
        Append( str, String( coeff ) );
        Append( str, ccs_name );
      od;

      return StringFormatted( "<{}>", str );
    end
  );

#############################################################################
##
#O  ViewString( <a> )
##
  InstallMethod( ViewString,
    "view string of a Euler ring element",
    [ IsEulerRingElement ],
    function( a )
      local A;     # the Euler ring

      A := FamilyObj( a )!.EulerRing;

      return Concatenation( String( a ), " in ", ViewString( A ) );
    end
  );

#############################################################################
##
#O  PrintObj( <a> )
##
  InstallMethod( PrintObj,
    "display a Euler ring element",
    [ IsEulerRingElement ],
    function( a )
      local i,			# index
            ccs,
            ccs_id,		# id of CCS
            ccs_id_formatted,	# id of CCS
            coeff,		# coefficient
            ccs_name,		# name of CCS
            str;		# name string

      Print( ViewString( FamilyObj( a )!.EulerRing ), " element:\n" );
      for i in [ 1 .. Length( a ) ] do
        coeff	:= a!.coeffList[ i ];
        ccs_id	:= a!.ccsIdList[ i ];
        ccs_id_formatted := StringFormatted(
          "({})",
          JoinStringsWithSeparator( Flat( [ ccs_id ] ), "," )
        );
        ccs	:= a!.ccsList[ i ];

        # determine the name of CCS
        if HasAbbrv( ccs ) then
          ccs_name := Concatenation( ccs_id_formatted, "\t", Abbrv( ccs ) );
        else
          ccs_name := ccs_id_formatted;
        fi;

        # append coefficient and name of CCS
        Print( StringFormatted( "{}\t{}\n", coeff, ccs_name ) );
      od;
    end
  );

#############################################################################
##
#O  LaTeXTypesetting( <a> )
##
  InstallMethod( LaTeXTypesetting,
    "return LaTeX typesetting of an element in the Euler ring",
    [ IsEulerRingElement ],
    function( a )
      local i,		# index
            coeff,	# coefficient
            ccs_id,	# id of CCS
            ccs_list,	# CCSs of the underlying group
            ccs_name,	# name of CCS
            str;	# name string

      ccs_list := FamilyObj( a )!.CCSs;
      str := "";
      for i in [ 1 .. Length( a ) ] do
        coeff     := a!.coeffList[ i ];
        ccs_id := a!.ccsIdList[ i ];

        # determine the name of CCS
        if HasLaTeXString( ccs_list[ ccs_id ] ) then
          ccs_name := LaTeXString( ccs_list[ ccs_id ] );
        else
          ccs_name := StringFormatted(
            "({})",
            JoinStringsWithSeparator( Flat( [ ccs_id ] ), "," )
          );
        fi;

        # append coefficient and name of CCS
        if ( i > 1 ) and ( coeff > 0 ) then
          Append( str, "+" );
        fi;
        Append( str, String( coeff ) );
        Append( str, StringFormatted( "({})", ccs_name ) );
      od;

      return str;
    end
  );

#############################################################################
##
#A  Length( <a> )
##
  InstallMethod( Length,
    "length of a Euler ring element",
    [ IsEulerRingElement ],
    a -> Length( a!.ccsList )
  );

#############################################################################
##
#O  ToSparseList( <a> )
##
  InstallMethod( ToSparseList,
    "convert a Euler ring element to a sparse list",
    [ IsEulerRingElement ],
    a -> ListN( a!.ccsIdList, a!.coeffList, { x, y } -> [ x, y ] )
  );
