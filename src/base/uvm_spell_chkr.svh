//
//------------------------------------------------------------------------------
// Copyright 2010-2011 Mentor Graphics Corporation
// Copyright 2010-2018 Cadence Design Systems, Inc.
// Copyright 2013 Verilab
// Copyright 2014 NVIDIA Corporation
//   All Rights Reserved Worldwide
//
//   Licensed under the Apache License, Version 2.0 (the
//   "License"); you may not use this file except in
//   compliance with the License.  You may obtain a copy of
//   the License at
//
//       http://www.apache.org/licenses/LICENSE-2.0
//
//   Unless required by applicable law or agreed to in
//   writing, software distributed under the License is
//   distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//   CONDITIONS OF ANY KIND, either express or implied.  See
//   the License for the specific language governing
//   permissions and limitations under the License.
//------------------------------------------------------------------------------



//----------------------------------------------------------------------
// class uvm_spell_chkr
//----------------------------------------------------------------------
class uvm_spell_chkr #(type T=int);

  typedef T tab_t[string];
  static const int unsigned max = '1;
   
  //--------------------------------------------------------------------
  // check
  //
  // primary interface to the spell checker.  The function takes two
  // arguments, a table of strings and a string to check.  The table is
  // organized as an associative array of type T.  E.g.
  //
  //    T strtab[string]
  //
  // It doesn't matter what T is since we are only concerned with the
  // string keys. However, we need T in order to make argument types
  // match.
  //
  // First, we do the simple thing and see if the string already is in
  // the string table by calling the ~exists()~ method.  If it does exist
  // then there is a match and we're done.  If the string doesn't exist
  // in the table then we invoke the spell checker algorithm to see if
  // our string is a misspelled variation on a string that does exist in
  // the table.
  //
  // The main loop traverses the string table computing the levenshtein
  // distance between each string and the string we are checking.  The
  // strings in the table with the minimum distance are considered
  // possible alternatives.  There may be more than one string in the
  // table with a minimum distance. So all the alternatives are stored
  // in a queue.
  //
  // Note: This is not a particularly efficient algorithm.  It requires
  // computing the levenshtein distance for every string in the string
  // table.  If that list were very large the run time could be long.
  // For the resources application in UVM probably the size of the
  // string table is not excessive and run times will be fast enough.
  // If, on average, that proves to be an invalid assumption then we'll
  // have to find ways to optimize this algorithm.
  //
  // note: strtab should not be modified inside check() 
  //--------------------------------------------------------------------
  static function bit check ( /* const */ ref tab_t strtab, input string s); endfunction


  //--------------------------------------------------------------------
  // levenshtein_distance
  //
  // Compute levenshtein distance between s and t
  // The Levenshtein distance is defined as The smallest number of
  // insertions, deletions, and substitutions required to change one
  // string into another.  There is a tremendous amount of information
  // available on Levenshtein distance on the internet.  Two good
  // sources are wikipedia and nist.gov.  A nice, simple explanation of
  // the algorithm is at
  // http://www.codeproject.com/KB/recipes/Levenshtein.aspx.  Use google
  // to find others.
  //
  // This implementation of the Levenshtein
  // distance computation algorithm is a SystemVerilog adaptation of the
  // C implementatiion located at http://www.merriampark.com/ldc.htm.
  //--------------------------------------------------------------------
  static local function int levenshtein_distance(string s, string t); endfunction

  //--------------------------------------------------------------------
  // Gets the minimum of three values
  //--------------------------------------------------------------------
  static local function int minimum(int a, int b, int c); endfunction

endclass
