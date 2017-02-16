#-------
# GAP: Extended System Library
#-------
# Implementation file of libSys.g
#
# Author: Hao-pin Wu <hxw132130@utdallas.edu>
# Last update:  2016-11-24
#-------

#-----
# attribute(s)
#-----

#-----
# property(s)
#-----

#-----
# method(s)
#-----

#-----
# function(s)
#-----

#---
  setMsgLevel := function(level)
#---
#setMsgLevel(level) sets up MSGLEVEL.
#	It follows the standard of Log4j Log Levels:
#		6 -> off
#		  The highest possible rank and is intended to turn off logging.
#		5 -> FATAL
#		  Severe errors that cause premature termination.
#		  Expect these to be immediately visible on a status console.
#		4 -> ERROR
#		  Other runtime errors or unexpected conditions.
#		  Expect these to be immediately visible on a status console.
#		3 -> WARN
#		  Use of deprecated APIs, poor use of API,
#		  'almost' errors, other runtime situations
#		  that are undesirable or unexpected,
#		  but not necessarily "wrong". Expect these
#		  to be immediately visible on a status console.
#		2 -> INFO
#		  Interesting runtime events (startup/shutdown).
#		  Expect these to be immediately visible on a console,
#		  so be conservative and keep to a minimum.
#		1 -> DEBUG
#		  Detailed information on the flow through the system.
#		  Expect these to be written to logs only.
#		  Generally speaking, most lines logged by your
#		  application should be written as DEBUG.
#		0 -> TRACE
#		  Most detailed information.
#-
# input(s):
#	level
#-
# output(s):
#	none
#-

  if IsReadOnlyGlobal( "MSGLEVEL" ) then
    MakeReadWriteGlobal( "MSGLEVEL" );
  fi;

  MSGLEVEL := level;
  MakeReadOnlyGlobal( "MSGLEVEL" );

#---
  end;
#---

#-----
# new info class(es)
#-----

#---
# MyInfoHandler
#---
  if IsBound( MyInfoHandler ) then
    Unbind( MyInfoHandler );
  fi;
#---
  myInfoHandler := function( infoclass, level, list )
#---
#myInfoHandler(infoclass, level, arg) defines
#	info handler for the custom info classes
#-
# input(s):
#	infoclass
#	level
#	arg
#-
# output(s):
#	none
#-

  # local variable(s)
  local cl, out, fun, s;

  # get current info output
  cl := InfoData.LastClass![1];
  if IsBound(InfoData.Output[cl]) then
    out := InfoData.Output[cl];
  else
    out := DefaultInfoOutput;
  fi;

  # set output function
  if out = "*Print*"  then
    fun := Print;
  else
    fun := x -> AppendTo(out, x);
  fi;

  # export the info to the output
  fun(infoclass, ": ");
  for s in list do
    fun(s);
  od;
  fun("\n");

  end;
#---

#---
  DeclareInfoClass( "FATAL" );
  SetInfoLevel(FATAL, 5);
  SetInfoHandler(FATAL, myInfoHandler);
#---

#---
  DeclareInfoClass( "ERROR" );
  SetInfoLevel(ERROR, 4);
  SetInfoHandler(ERROR, myInfoHandler);
#---

#---
  DeclareInfoClass( "WARN" );
  SetInfoLevel(WARN, 3);
  SetInfoHandler(WARN, myInfoHandler);
#---

#---
  DeclareInfoClass("INFO");
  SetInfoLevel(INFO, 2);
  SetInfoHandler(INFO, myInfoHandler);
#---

#---
  DeclareInfoClass("DEBUG");
  SetInfoLevel(DEBUG, 1);
  SetInfoHandler(DEBUG, myInfoHandler);
#---

#---
  DeclareInfoClass("TRACE");
  SetInfoLevel(TRACE, 0);
  SetInfoHandler(TRACE, myInfoHandler);
#---

#---
# Unbind temporary variables and functions
#---
  Unbind(myInfoHandler);
#---

#-----

