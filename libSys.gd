# # GAP: Extended System Library #
#
# Declaration file of libSys.g
#
# Author(s):
# Hao-pin Wu <psistwu@outlook.com>
#


# ## Exception Handling
# ### Global Variable(s)
  INFO_LEVEL := 1;


# ### Global Function(s)
  # clean all user-defined variables
  DeclareGlobalFunction( "Clean" );



# ## I/O
# ### Operation(s)
  DeclareOperation( "PEncStr", [ IsString ] );
  DeclareOperation( "BEncStr", [ IsString ] );
  DeclareOperation( "AEncStr", [ IsString ] );