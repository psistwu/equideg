# # GAP: Extended System Library
#
# Declaration file of libSys.g
#
# Author(s):
# Hao-pin Wu <psistwu@outlook.com>
#

# ## Part 1: I/O
# ### Attribute(s)
  DeclareAttribute( "LaTeXString", IsObject );


# ### Global Function(s)
  DeclareGlobalFunction( "Clean", "clean all user-defined variables" );
  DeclareGlobalFunction( "ListF",
      "procedure which applies function on each component of the given list" );


# ### Operation(s)
  DeclareOperation( "PEncStr", [ IsString ] );
  DeclareOperation( "BEncStr", [ IsString ] );
  DeclareOperation( "AEncStr", [ IsString ] );
  DeclareOperation( "LaTeXTypesetting", [ IsObject ] );



# ## Part 2: Exception Handling
# ### Global Variable(s)
  INFO_LEVEL := 1;

