//----------------------------------------------------------------------
// Copyright 2010-2011 Paradigm Works
// Copyright 2010-2018 Mentor Graphics Corporation
// Copyright 2015 Analog Devices, Inc.
// Copyright 2014 Semifore
// Copyright 2017 Intel Corporation
// Copyright 2010-2014 Synopsys, Inc.
// Copyright 2010-2018 Cadence Design Systems, Inc.
// Copyright 2010-2011 AMD
// Copyright 2013-2018 NVIDIA Corporation
// Copyright 2017-2018 Cisco Systems, Inc.
// Copyright 2011-2012 Cypress Semiconductor Corp.
// Copyright 2017-2018 Verific
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
//----------------------------------------------------------------------




//----------------------------------------------------------------------
// Class - get_t
//
// Instances of get_t are stored in the history list as a record of each
// get.  Failed gets are indicated with rsrc set to ~null~.  This is part
// of the audit trail facility for resources.
//----------------------------------------------------------------------
class get_t;
  string name;
  string scope;
  uvm_resource_base rsrc;
  time t;
endclass

typedef class uvm_tree_printer ;

// Title: Resources

//----------------------------------------------------------------------
// Class -- NODOCS -- uvm_resource_pool
//
// The global (singleton) resource database.
//
// Each resource is stored both by primary name and by type handle.  The
// resource pool contains two associative arrays, one with name as the
// key and one with the type handle as the key.  Each associative array
// contains a queue of resources.  Each resource has a regular
// expression that represents the set of scopes over which it is visible.
//
//|  +------+------------+                          +------------+------+
//|  | name | rsrc queue |                          | rsrc queue | type |
//|  +------+------------+                          +------------+------+
//|  |      |            |                          |            |      |
//|  +------+------------+                  +-+-+   +------------+------+
//|  |      |            |                  | | |<--+---*        |  T   |
//|  +------+------------+   +-+-+          +-+-+   +------------+------+
//|  |  A   |        *---+-->| | |           |      |            |      |
//|  +------+------------+   +-+-+           |      +------------+------+
//|  |      |            |      |            |      |            |      |
//|  +------+------------+      +-------+  +-+      +------------+------+
//|  |      |            |              |  |        |            |      |
//|  +------+------------+              |  |        +------------+------+
//|  |      |            |              V  V        |            |      |
//|  +------+------------+            +------+      +------------+------+
//|  |      |            |            | rsrc |      |            |      |
//|  +------+------------+            +------+      +------------+------+
//
// The above diagrams illustrates how a resource whose name is A and
// type is T is stored in the pool.  The pool contains an entry in the
// type map for type T and an entry in the name map for name A.  The
// queues in each of the arrays each contain an entry for the resource A
// whose type is T.  The name map can contain in its queue other
// resources whose name is A which may or may not have the same type as
// our resource A.  Similarly, the type map can contain in its queue
// other resources whose type is T and whose name may or may not be A.
//
// Resources are added to the pool by calling <set>; they are retrieved
// from the pool by calling <get_by_name> or <get_by_type>.  When an object 
// creates a new resource and calls <set> the resource is made available to be
// retrieved by other objects outside of itself; an object gets a
// resource when it wants to access a resource not currently available
// in its scope.
//
// The scope is stored in the resource itself (not in the pool) so
// whether you get by name or by type the resource's visibility is
// the same.
//
// As an auditing capability, the pool contains a history of gets.  A
// record of each get, whether by <get_by_type> or <get_by_name>, is stored 
// in the audit record.  Both successful and failed gets are recorded. At
// the end of simulation, or any time for that matter, you can dump the
// history list.  This will tell which resources were successfully
// located and which were not.  You can use this information
// to determine if there is some error in name, type, or
// scope that has caused a resource to not be located or to be incorrectly
// located (i.e. the wrong resource is located).
//
//----------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto C.2.4.1
class uvm_resource_pool;

  uvm_resource_types::rsrc_q_t rtab [string];
  uvm_resource_types::rsrc_q_t ttab [uvm_resource_base];

  // struct for scope and precedence associated with each resource
  typedef struct { 
     string scope ;
     int unsigned precedence;
  } rsrc_info_t ;
  // table to set/get scope and precedence for resources
  static rsrc_info_t ri_tab [uvm_resource_base];

  get_t get_record [$];  // history of gets

  // @uvm-ieee 1800.2-2017 auto C.2.4.2.1
  function new();
  endfunction


  // Function -- NODOCS -- get
  //
  // Returns the singleton handle to the resource pool

  // @uvm-ieee 1800.2-2017 auto C.2.4.2.2
  static function uvm_resource_pool get(); endfunction


  // Function -- NODOCS -- spell_check
  //
  // Invokes the spell checker for a string s.  The universe of
  // correctly spelled strings -- i.e. the dictionary -- is the name
  // map.

  function bit spell_check(string s); endfunction

  //-----------
  // Group -- NODOCS -- Set
  //-----------

  // Function -- NODOCS -- set
  //
  // Add a new resource to the resource pool.  The resource is inserted
  // into both the name map and type map so it can be located by
  // either.
  //
  // An object creates a resources and ~sets~ it into the resource pool.
  // Later, other objects that want to access the resource must ~get~ it
  // from the pool
  //
  // Overrides can be specified using this interface.  Either a name
  // override, a type override or both can be specified.  If an
  // override is specified then the resource is entered at the front of
  // the queue instead of at the back.  It is not recommended that users
  // specify the override parameter directly, rather they use the
  // <set_override>, <set_name_override>, or <set_type_override>
  // functions.
  //
`ifdef UVM_ENABLE_DEPRECATED_API
  function void set (uvm_resource_base rsrc, 
                     uvm_resource_types::override_t override = 0); endfunction
`endif //UVM_ENABLE_DEPRECATED_API

  // @uvm-ieee 1800.2-2017 auto C.2.4.3.1
  function void set_scope (uvm_resource_base rsrc, string scope); endfunction


  // Function -- NODOCS -- set_override
  //
  // The resource provided as an argument will be entered into the pool
  // and will override both by name and type.
  // Default value to 'scope' argument is violating 1800.2-2017 LRM, but it
  // is added to make the routine backward compatible

  // @uvm-ieee 1800.2-2017 auto C.2.4.3.2
  function void set_override(uvm_resource_base rsrc, string scope = ""); endfunction


  // Function -- NODOCS -- set_name_override
  //
  // The resource provided as an argument will entered into the pool
  // using normal precedence in the type map and will override the name.
  // Default value to 'scope' argument is violating 1800.2-2017 LRM, but it
  // is added to make the routine backward compatible

  // @uvm-ieee 1800.2-2017 auto C.2.4.3.3
  function void set_name_override(uvm_resource_base rsrc, string scope = ""); endfunction


  // Function -- NODOCS -- set_type_override
  //
  // The resource provided as an argument will be entered into the pool
  // using normal precedence in the name map and will override the type.
  // Default value to 'scope' argument is violating 1800.2-2017 LRM, but it
  // is added to make the routine backward compatible

  // @uvm-ieee 1800.2-2017 auto C.2.4.3.4
  function void set_type_override(uvm_resource_base rsrc, string scope = ""); endfunction

  
  // @uvm-ieee 1800.2-2017 auto C.2.4.3.5
  virtual function bit get_scope(uvm_resource_base rsrc,
                                 output string scope); endfunction

  // Function -- NODOCS -- delete
  // 
  // If rsrc exists within the pool, then it is removed from all internal maps. If the rsrc is null, or does not exist
  // within the pool, then the request is silently ignored.

 
  // @uvm-ieee 1800.2-2017 auto C.2.4.3.6
  virtual function void delete ( uvm_resource_base rsrc ); endfunction


  // function - push_get_record
  //
  // Insert a new record into the get history list.

  function void push_get_record(string name, string scope,
                                  uvm_resource_base rsrc); endfunction

  // function - dump_get_records
  //
  // Format and print the get history list.

  function void dump_get_records(); endfunction

  //--------------
  // Group -- NODOCS -- Lookup
  //--------------
  //
  // This group of functions is for finding resources in the resource database.  
  //
  // <lookup_name> and <lookup_type> locate the set of resources that
  // matches the name or type (respectively) and is visible in the
  // current scope.  These functions return a queue of resources.
  //
  // <get_highest_precedence> traverse a queue of resources and
  // returns the one with the highest precedence -- i.e. the one whose
  // precedence member has the highest value.
  //
  // <get_by_name> and <get_by_type> use <lookup_name> and <lookup_type>
  // (respectively) and <get_highest_precedence> to find the resource with
  // the highest priority that matches the other search criteria.


  // Function -- NODOCS -- lookup_name
  //
  // Lookup resources by ~name~.  Returns a queue of resources that
  // match the ~name~, ~scope~, and ~type_handle~.  If no resources
  // match the queue is returned empty. If ~rpterr~ is set then a
  // warning is issued if no matches are found, and the spell checker is
  // invoked on ~name~.  If ~type_handle~ is ~null~ then a type check is
  // not made and resources are returned that match only ~name~ and
  // ~scope~.

  // @uvm-ieee 1800.2-2017 auto C.2.4.4.1
  function uvm_resource_types::rsrc_q_t lookup_name(string scope = "",
                                                    string name,
                                                    uvm_resource_base type_handle = null,
                                                    bit rpterr = 1); endfunction

  // Function -- NODOCS -- get_highest_precedence
  //
  // Traverse a queue, ~q~, of resources and return the one with the highest
  // precedence.  In the case where there exists more than one resource
  // with the highest precedence value, the first one that has that
  // precedence will be the one that is returned.

  // @uvm-ieee 1800.2-2017 auto C.2.4.4.2
  // @uvm-ieee 1800.2-2017 auto C.2.4.5.8
  static function uvm_resource_base get_highest_precedence(ref uvm_resource_types::rsrc_q_t q); endfunction

  // Function -- NODOCS -- sort_by_precedence
  //
  // Given a list of resources, obtained for example from <lookup_scope>,
  // sort the resources in  precedence order. The highest precedence
  // resource will be first in the list and the lowest precedence will
  // be last. Resources that have the same precedence and the same name
  // will be ordered by most recently set first.

  // @uvm-ieee 1800.2-2017 auto C.2.4.4.3
  static function void sort_by_precedence(ref uvm_resource_types::rsrc_q_t q); endfunction


  // Function -- NODOCS -- get_by_name
  //
  // Lookup a resource by ~name~, ~scope~, and ~type_handle~.  Whether
  // the get succeeds or fails, save a record of the get attempt.  The
  // ~rpterr~ flag indicates whether to report errors or not.
  // Essentially, it serves as a verbose flag.  If set then the spell
  // checker will be invoked and warnings about multiple resources will
  // be produced.

  // @uvm-ieee 1800.2-2017 auto C.2.4.4.4
  function uvm_resource_base get_by_name(string scope = "",
                                         string name,
                                         uvm_resource_base type_handle,
                                         bit rpterr = 1); endfunction


  // Function -- NODOCS -- lookup_type
  //
  // Lookup resources by type. Return a queue of resources that match
  // the ~type_handle~ and ~scope~.  If no resources match then the returned
  // queue is empty.

  // @uvm-ieee 1800.2-2017 auto C.2.4.4.5
  function uvm_resource_types::rsrc_q_t lookup_type(string scope = "",
                                                    uvm_resource_base type_handle); endfunction

  // Function -- NODOCS -- get_by_type
  //
  // Lookup a resource by ~type_handle~ and ~scope~.  Insert a record into
  // the get history list whether or not the get succeeded.

  // @uvm-ieee 1800.2-2017 auto C.2.4.4.6
  function uvm_resource_base get_by_type(string scope = "",
                                         uvm_resource_base type_handle); endfunction

  // Function -- NODOCS -- lookup_regex_names
  //
  // This utility function answers the question, for a given ~name~,
  // ~scope~, and ~type_handle~, what are all of the resources with requested name,
  // a matching scope (where the resource scope may be a
  // regular expression), and a matching type? 
  // ~name~ and ~scope~ are explicit values.

  function uvm_resource_types::rsrc_q_t lookup_regex_names(string scope,
                                                           string name,
                                                           uvm_resource_base type_handle = null); endfunction

  // Function -- NODOCS -- lookup_regex
  //
  // Looks for all the resources whose name matches the regular
  // expression argument and whose scope matches the current scope.

  // @uvm-ieee 1800.2-2017 auto C.2.4.4.7
  function uvm_resource_types::rsrc_q_t lookup_regex(string re, scope); endfunction

  // Function -- NODOCS -- lookup_scope
  //
  // This is a utility function that answers the question: For a given
  // ~scope~, what resources are visible to it?  Locate all the resources
  // that are visible to a particular scope.  This operation could be
  // quite expensive, as it has to traverse all of the resources in the
  // database.

  // @uvm-ieee 1800.2-2017 auto C.2.4.4.8
  function uvm_resource_types::rsrc_q_t lookup_scope(string scope); endfunction

  //--------------------
  // Group -- NODOCS -- Set Priority
  //--------------------
  //
  // Functions for altering the search priority of resources.  Resources
  // are stored in queues in the type and name maps.  When retrieving
  // resources, either by type or by name, the resource queue is search
  // from front to back.  The first one that matches the search criteria
  // is the one that is returned.  The ~set_priority~ functions let you
  // change the order in which resources are searched.  For any
  // particular resource, you can set its priority to UVM_HIGH, in which
  // case the resource is moved to the front of the queue, or to UVM_LOW in
  // which case the resource is moved to the back of the queue.

  // function- set_priority_queue
  //
  // This function handles the mechanics of moving a resource to either
  // the front or back of the queue.

  local function void set_priority_queue(uvm_resource_base rsrc,
                                         ref uvm_resource_types::rsrc_q_t q,
                                         uvm_resource_types::priority_e pri); endfunction


  // Function -- NODOCS -- set_priority_type
  //
  // Change the priority of the ~rsrc~ based on the value of ~pri~, the
  // priority enum argument.  This function changes the priority only in
  // the type map, leaving the name map untouched.

  // @uvm-ieee 1800.2-2017 auto C.2.4.5.1
  function void set_priority_type(uvm_resource_base rsrc,
                                  uvm_resource_types::priority_e pri); endfunction


  // Function -- NODOCS -- set_priority_name
  //
  // Change the priority of the ~rsrc~ based on the value of ~pri~, the
  // priority enum argument.  This function changes the priority only in
  // the name map, leaving the type map untouched.

  // @uvm-ieee 1800.2-2017 auto C.2.4.5.2
  function void set_priority_name(uvm_resource_base rsrc,
                                  uvm_resource_types::priority_e pri); endfunction


  // Function -- NODOCS -- set_priority
  //
  // Change the search priority of the ~rsrc~ based on the value of ~pri~,
  // the priority enum argument.  This function changes the priority in
  // both the name and type maps.

  // @uvm-ieee 1800.2-2017 auto C.2.4.5.3
  function void set_priority (uvm_resource_base rsrc,
                              uvm_resource_types::priority_e pri); endfunction


  // @uvm-ieee 1800.2-2017 auto C.2.4.5.4
  static function void set_default_precedence( int unsigned precedence); endfunction


  static function int unsigned get_default_precedence(); endfunction

  
  // @uvm-ieee 1800.2-2017 auto C.2.4.5.6
  virtual function void set_precedence(uvm_resource_base r,
                                       int unsigned p=uvm_resource_pool::get_default_precedence()); endfunction


  virtual function int unsigned get_precedence(uvm_resource_base r); endfunction


  //--------------------------------------------------------------------
  // Group -- NODOCS -- Debug
  //--------------------------------------------------------------------

`ifdef UVM_ENABLE_DEPRECATED_API
  // Function -- NODOCS -- find_unused_resources
  //
  // Locate all the resources that have at least one write and no reads

  function uvm_resource_types::rsrc_q_t find_unused_resources(); endfunction
`endif // UVM_ENABLE_DEPRECATED_API

  // Prints resouce queue into ~printer~, non-LRM
  function void m_print_resources(uvm_printer printer,
                                  uvm_resource_types::rsrc_q_t rq,
                                  bit audit = 0); endfunction : m_print_resources
                                  
  
  // Function -- NODOCS -- print_resources
  //
  // Print the resources that are in a single queue, ~rq~.  This is a utility
  // function that can be used to print any collection of resources
  // stored in a queue.  The ~audit~ flag determines whether or not the
  // audit trail is printed for each resource along with the name,
  // value, and scope regular expression.

  function void print_resources(uvm_resource_types::rsrc_q_t rq, bit audit = 0); endfunction


  // Function -- NODOCS -- dump
  //
  // dump the entire resource pool.  The resource pool is traversed and
  // each resource is printed.  The utility function print_resources()
  // is used to initiate the printing. If the ~audit~ bit is set then
  // the audit trail is dumped for each resource.

  function void dump(bit audit = 0, uvm_printer printer = null); endfunction
  
endclass

//----------------------------------------------------------------------
// Class: uvm_resource #(T)
// Implementation of uvm_resource#(T) as defined in section C.2.5.1 of
// 1800.2-2017.
//----------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto C.2.5.1
class uvm_resource #(type T=int) extends uvm_resource_base;

  typedef uvm_resource this_type;

  // singleton handle that represents the type of this resource
  static this_type my_type = get_type();

  // Can't be rand since things like rand strings are not legal.
  protected T val;

  // Because of uvm_resource#(T)::get_type, we can't use
  // the macros.  We need to do it all manually.
  typedef uvm_object_registry#(this_type) type_id;
  virtual function uvm_object_wrapper get_object_type(); endfunction : get_object_type
  virtual function uvm_object create (string name=""); endfunction : create
  `uvm_type_name_decl($sformatf("uvm_resource#(%s)", `uvm_typename(T)))
  
  
`ifdef UVM_ENABLE_DEPRECATED_API
  function new(string name="", scope=""); endfunction
`else
  // @uvm-ieee 1800.2-2017 auto C.2.5.2
  function new(string name=""); endfunction
`endif // UVM_ENABLE_DEPRECATED_API

  virtual function string m_value_type_name(); endfunction : m_value_type_name
                                    
  virtual function string m_value_as_string(); endfunction : m_value_as_string
                                    
  //----------------------
  // Group -- NODOCS -- Type Interface
  //----------------------
  //
  // Resources can be identified by type using a static type handle.
  // The parent class provides the virtual function interface
  // <get_type_handle>.  Here we implement it by returning the static type
  // handle.

  // Function -- NODOCS -- get_type
  //
  // Static function that returns the static type handle.  The return
  // type is this_type, which is the type of the parameterized class.

  static function this_type get_type(); endfunction

  // Function -- NODOCS -- get_type_handle
  //
  // Returns the static type handle of this resource in a polymorphic
  // fashion.  The return type of get_type_handle() is
  // uvm_resource_base.  This function is not static and therefore can
  // only be used by instances of a parameterized resource.

  // @uvm-ieee 1800.2-2017 auto C.2.5.3.2
  function uvm_resource_base get_type_handle(); endfunction

`ifdef UVM_ENABLE_DEPRECATED_API
  //-------------------------
  // Group -- NODOCS -- Set/Get Interface
  //-------------------------
  //
  // uvm_resource#(T) provides an interface for setting and getting a
  // resources.  Specifically, a resource can insert itself into the
  // resource pool.  It doesn't make sense for a resource to get itself,
  // since you can't call a function on a handle you don't have.
  // However, a static get interface is provided as a convenience.  This
  // obviates the need for the user to get a handle to the global
  // resource pool as this is done for him here.

  // Function -- NODOCS -- set
  //
  // Simply put this resource into the global resource pool

  function void set(); endfunction

  
  // Function -- NODOCS -- set_override
  //
  // Put a resource into the global resource pool as an override.  This
  // means it gets put at the head of the list and is searched before
  // other existing resources that occupy the same position in the name
  // map or the type map.  The default is to override both the name and
  // type maps.  However, using the ~override~ argument you can specify
  // that either the name map or type map is overridden.

  function void set_override(uvm_resource_types::override_t override = 2'b11); endfunction

  // Function -- NODOCS -- get_by_name
  //
  // looks up a resource by ~name~ in the name map. The first resource
  // with the specified name, whose type is the current type, and is
  // visible in the specified ~scope~ is returned, if one exists.  The
  // ~rpterr~ flag indicates whether or not an error should be reported
  // if the search fails.  If ~rpterr~ is set to one then a failure
  // message is issued, including suggested spelling alternatives, based
  // on resource names that exist in the database, gathered by the spell
  // checker.

  static function this_type get_by_name(string scope,
                                        string name,
                                        bit rpterr = 1); endfunction

  // Function -- NODOCS -- get_by_type
  //
  // looks up a resource by ~type_handle~ in the type map. The first resource
  // with the specified ~type_handle~ that is visible in the specified ~scope~ is
  // returned, if one exists. If there is no resource matching the specifications,
  // ~null~ is returned.

  static function this_type get_by_type(string scope = "",
                                        uvm_resource_base type_handle); endfunction
`endif // UVM_ENABLE_DEPRECATED_API
  
  //----------------------------
  // Group -- NODOCS -- Read/Write Interface
  //----------------------------
  //
  // <read> and <write> provide a type-safe interface for getting and
  // setting the object in the resource container.  The interface is
  // type safe because the value argument for <write> and the return
  // value of <read> are T, the type supplied in the class parameter.
  // If either of these functions is used in an incorrect type context
  // the compiler will complain.

  // Function: read
  //
  //| function T read(uvm_object accessor = null);
  //
  // This function is the implementation of the uvm_resource#(T)::read 
  // method detailed in IEEE1800.2-2017 section C.2.5.4.1
  //
  // It calls uvm_resource_base::record_read_access before returning the value.
  //
  // @uvm-accellera The details of this API are specific to the Accellera implementation, and are not being considered for contribution to 1800.2


  // @uvm-ieee 1800.2-2017 auto C.2.5.4.1
  function T read(uvm_object accessor = null); endfunction

  // Function: write
  //
  //| function void write(T t, uvm_object accessor = null);
  //
  // This function is the implementation of the uvm_resource#(T)::write 
  // method detailed in IEEE1800.2-2017 section C.2.5.4.2
  //
  // It calls uvm_resource_base::record_write_access before writing the value.
  //
  // @uvm-accellera The details of this API are specific to the Accellera implementation, and are not being considered for contribution to 1800.2


  // @uvm-ieee 1800.2-2017 auto C.2.5.4.2
  function void write(T t, uvm_object accessor = null); endfunction

`ifdef UVM_ENABLE_DEPRECATED_API
  //----------------
  // Group -- NODOCS -- Priority
  //----------------
  //
  // Functions for manipulating the search priority of resources.  These
  // implementations of the interface defined in the base class delegate
  // to the resource pool. 


  // Function -- NODOCS -- set priority
  //
  // Change the search priority of the resource based on the value of
  // the priority enum argument, ~pri~.

  function void set_priority (uvm_resource_types::priority_e pri); endfunction

`endif // UVM_ENABLE_DEPRECATED_API

  // Function -- NODOCS -- get_highest_precedence
  //
  // In a queue of resources, locate the first one with the highest
  // precedence whose type is T.  This function is static so that it can
  // be called from anywhere.

  static function this_type get_highest_precedence(ref uvm_resource_types::rsrc_q_t q); endfunction

endclass

