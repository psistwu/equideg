# # GAP: Extended System Library
#
# Implementation file of libSys.g
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#

# ## Part 1: I/O
# ### Global Function(s)
# ***
  InstallGlobalFunction( Clean,
    function( )
      local gvar_name;    # name of a global variable

      Print( "Cleaning all user-defined variables.... " );

      for gvar_name in NamesUserGVars( ) do
        if IsReadOnlyGlobal( gvar_name ) then
          MakeReadWriteGlobal( gvar_name );
        fi;
        UnbindGlobal( gvar_name );
      od;

      Print( "Done!\n\n" );
    end
  );

# ***
  InstallGlobalFunction( ListF,
    function ( args... )
      local num,
            func,
            len,
            i,
            argsin;

      func := Remove( args );
      num := Length( args );
      len := Length( args[1] );

      if not IsFunction( func ) then
        Error( "Last argument must be a function" );
      elif ForAny( args,
          function ( a )
            return not IsList( a ) or Length( a ) <> len;
          end ) then
        Error( "<arg1>, ..., <argn> must be lists of the same length" );
      fi;

      for i in [ 1 .. len ] do
        argsin := List( args, arg -> arg[ i ] );
        CallFuncListWrap( func, argsin );
      od;
    end
  );


# ### Operation(s)
# ***
  InstallMethod( PEncStr,
    "return string enclosed by parantheses",
    [ IsString ],
    function( str )
      return Concatenation( "(", str, ")" );
    end
  );

# ***
  InstallMethod( BEncStr,
    "return string enclosed by parantheses",
    [ IsString ],
    function( str )
      return Concatenation( "[", str, "]" );
    end
  );

# ***
  InstallMethod( AEncStr,
    "return string enclosed by parantheses",
    [ IsString ],
    function( str )
      return Concatenation( "<", str, ">" );
    end
  );

# ***
  InstallMethod( LaTeXTypesetting,
    "return LaTeX typesetting of an object",
    [ IsObject ],
    function( obj )
      if HasLaTeXString( obj ) then
        return LaTeXString( obj );
      else
        Info( InfoWarning, INFO_LEVEL, "LaTeXString of the object is not defined." );
        return "";
      fi;
    end
  );



# ## Part 2: Exception Handling
