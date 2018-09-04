# # GAP: Extended System Library
#
# Implementation file of libSys.g
#
# Author(s):
# Haopin Wu <psistwu@outlook.com>
#

# ### function(s)
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
