# # GAP: Extended System Library
#
# Implementation file of libSys.g
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#

# ## Exception Handling
# ### Function(s)
  # clean all user defined variables
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



# ## I/O
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
