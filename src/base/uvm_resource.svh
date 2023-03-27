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


  // struct for scope and precedence associated with each resource
  get_t get_record [$];  // history of gets

  // @uvm-ieee 1800.2-2017 auto C.2.4.2.1
  function new();
  endfunction


  // Function -- NODOCS -- get
  //
  // Returns the singleton handle to the resource pool

  // @uvm-ieee 1800.2-2017 auto C.2.4.2.2
  static function uvm_resource_pool get();
    uvm_resource_pool t_rp;
    uvm_coreservice_t cs = uvm_coreservice_t::get();
    t_rp = cs.get_resource_pool();
    return t_rp;
  endfunction


  // Function -- NODOCS -- spell_check
  //
  // Invokes the spell checker for a string s.  The universe of
  // correctly spelled strings -- i.e. the dictionary -- is the name
  // map.

  function bit spell_check(string s);
     return 1;
  endfunction

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
                     uvm_resource_types::override_t override = 0);

    // If resource handle is ~null~ then there is nothing to do.
    if (rsrc == null) return ;
    if (override) 
        set_override(rsrc, rsrc.get_scope()) ;
    else
        set_scope(rsrc, rsrc.get_scope()) ; 

  endfunction
`endif //UVM_ENABLE_DEPRECATED_API

  // @uvm-ieee 1800.2-2017 auto C.2.4.3.1
  function void set_scope (uvm_resource_base rsrc, string scope); 


    string name;
    uvm_resource_base type_handle;
    uvm_resource_base r;
    int unsigned i;

    // If resource handle is ~null~ then there is nothing to do.
    if(rsrc == null) begin
      uvm_report_warning("NULLRASRC", "attempting to set scope of a null resource");
      return;
    end

    // Insert into the name map.  Resources with empty names are
    // anonymous resources and are not entered into the name map
    name = rsrc.get_name();

    // Insert into the type map
    type_handle = rsrc.get_type_handle();
  endfunction


  // Function -- NODOCS -- set_override
  //
  // The resource provided as an argument will be entered into the pool
  // and will override both by name and type.
  // Default value to 'scope' argument is violating 1800.2-2017 LRM, but it
  // is added to make the routine backward compatible

  // @uvm-ieee 1800.2-2017 auto C.2.4.3.2
  function void set_override(uvm_resource_base rsrc, string scope = "");
     string s = scope;
`ifdef UVM_ENABLE_DEPRECATED_API
     if ((scope == "") && (rsrc != null)) s = rsrc.get_scope();
`endif //UVM_ENABLE_DEPRECATED_API
     set_scope(rsrc, s);
     set_priority(rsrc, uvm_resource_types::PRI_HIGH);
  endfunction


  // Function -- NODOCS -- set_name_override
  //
  // The resource provided as an argument will entered into the pool
  // using normal precedence in the type map and will override the name.
  // Default value to 'scope' argument is violating 1800.2-2017 LRM, but it
  // is added to make the routine backward compatible

  // @uvm-ieee 1800.2-2017 auto C.2.4.3.3
  function void set_name_override(uvm_resource_base rsrc, string scope = "");
    string s = scope;
`ifdef UVM_ENABLE_DEPRECATED_API
    if ((scope == "") && (rsrc != null)) s = rsrc.get_scope();
`endif //UVM_ENABLE_DEPRECATED_API
    set_scope(rsrc, s);
    set_priority_name(rsrc, uvm_resource_types::PRI_HIGH);
  endfunction


  // Function -- NODOCS -- set_type_override
  //
  // The resource provided as an argument will be entered into the pool
  // using normal precedence in the name map and will override the type.
  // Default value to 'scope' argument is violating 1800.2-2017 LRM, but it
  // is added to make the routine backward compatible

  // @uvm-ieee 1800.2-2017 auto C.2.4.3.4
  function void set_type_override(uvm_resource_base rsrc, string scope = "");
    string s = scope;
`ifdef UVM_ENABLE_DEPRECATED_API
    if ((scope == "") && (rsrc != null)) s = rsrc.get_scope();
`endif //UVM_ENABLE_DEPRECATED_API
    set_scope(rsrc, s);
    set_priority_type(rsrc, uvm_resource_types::PRI_HIGH);
  endfunction

  
  // @uvm-ieee 1800.2-2017 auto C.2.4.3.5
  virtual function bit get_scope(uvm_resource_base rsrc,
                                 output string scope);

    return 0;

  endfunction

  // Function -- NODOCS -- delete
  // 
  // If rsrc exists within the pool, then it is removed from all internal maps. If the rsrc is null, or does not exist
  // within the pool, then the request is silently ignored.

 
  // @uvm-ieee 1800.2-2017 auto C.2.4.3.6
  virtual function void delete ( uvm_resource_base rsrc );
    string name;
    uvm_resource_base type_handle;

    if (rsrc != null) begin
      name = rsrc.get_name();
      if(name != "") begin
      end
      
      type_handle = rsrc.get_type_handle();

    end    
  endfunction


  // function - push_get_record
  //
  // Insert a new record into the get history list.

  function void push_get_record(string name, string scope,
                                  uvm_resource_base rsrc);
    get_t impt;

    // if auditing is turned off then there is no reason
    // to save a get record
    if(!uvm_resource_options::is_auditing())
      return;

    impt = new();

    impt.name  = name;
    impt.scope = scope;
    impt.rsrc  = rsrc;
    impt.t     = $realtime;

    get_record.push_back(impt);
  endfunction

  // function - dump_get_records
  //
  // Format and print the get history list.

  function void dump_get_records();

    get_t record;
    bit success;
    string qs[$];

    qs.push_back("--- resource get records ---\n");
    foreach (get_record[i]) begin
      record = get_record[i];
      success = (record.rsrc != null);
      qs.push_back($sformatf("get: name=%s  scope=%s  %s @ %0t\n",
               record.name, record.scope,
               ((success)?"success":"fail"),
               record.t));
    end
    `uvm_info("UVM/RESOURCE/GETRECORD",`UVM_STRING_QUEUE_STREAMING_PACK(qs),UVM_NONE)
  endfunction

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

  // Function -- NODOCS -- get_highest_precedence
  //
  // Traverse a queue, ~q~, of resources and return the one with the highest
  // precedence.  In the case where there exists more than one resource
  // with the highest precedence value, the first one that has that
  // precedence will be the one that is returned.

  // @uvm-ieee 1800.2-2017 auto C.2.4.4.2
  // @uvm-ieee 1800.2-2017 auto C.2.4.5.8

  // Function -- NODOCS -- set_priority_type
  //
  // Change the priority of the ~rsrc~ based on the value of ~pri~, the
  // priority enum argument.  This function changes the priority only in
  // the type map, leaving the name map untouched.

  // @uvm-ieee 1800.2-2017 auto C.2.4.5.1
  function void set_priority_type(uvm_resource_base rsrc,
                                  uvm_resource_types::priority_e pri);

    uvm_resource_base type_handle;
    string msg;


    if(rsrc == null) begin
      uvm_report_warning("NULLRASRC", "attempting to change the serach priority of a null resource");
      return;
    end

    type_handle = rsrc.get_type_handle();



  endfunction


  // Function -- NODOCS -- set_priority_name
  //
  // Change the priority of the ~rsrc~ based on the value of ~pri~, the
  // priority enum argument.  This function changes the priority only in
  // the name map, leaving the type map untouched.

  // @uvm-ieee 1800.2-2017 auto C.2.4.5.2
  function void set_priority_name(uvm_resource_base rsrc,
                                  uvm_resource_types::priority_e pri);

    string name;
    string msg;


    if(rsrc == null) begin
      uvm_report_warning("NULLRASRC", "attempting to change the serach priority of a null resource");
      return;
    end

    name = rsrc.get_name();




  endfunction


  // Function -- NODOCS -- set_priority
  //
  // Change the search priority of the ~rsrc~ based on the value of ~pri~,
  // the priority enum argument.  This function changes the priority in
  // both the name and type maps.

  // @uvm-ieee 1800.2-2017 auto C.2.4.5.3
  function void set_priority (uvm_resource_base rsrc,
                              uvm_resource_types::priority_e pri);
    set_priority_type(rsrc, pri);
    set_priority_name(rsrc, pri);
  endfunction


  // @uvm-ieee 1800.2-2017 auto C.2.4.5.4
  static function void set_default_precedence( int unsigned precedence);
    uvm_coreservice_t cs = uvm_coreservice_t::get();
    cs.set_resource_pool_default_precedence(precedence);
  endfunction


  static function int unsigned get_default_precedence();
    uvm_coreservice_t cs = uvm_coreservice_t::get();
    return cs.get_resource_pool_default_precedence(); 
  endfunction

  
  // @uvm-ieee 1800.2-2017 auto C.2.4.5.6
  virtual function void set_precedence(uvm_resource_base r,
                                       int unsigned p=1);

  endfunction


  virtual function int unsigned get_precedence(uvm_resource_base r);

     return 1;


  endfunction


  //--------------------------------------------------------------------
  // Group -- NODOCS -- Debug
  //--------------------------------------------------------------------

`ifdef UVM_ENABLE_DEPRECATED_API
  // Function -- NODOCS -- find_unused_resources
  //
  // Locate all the resources that have at least one write and no reads

  function uvm_resource_types::rsrc_q_t find_unused_resources();

    uvm_resource_types::rsrc_q_t rq;
    uvm_resource_types::rsrc_q_t q = new;
    int unsigned i;
    uvm_resource_base r;
    uvm_resource_types::access_t a;
    int reads;
    int writes;

    foreach (rtab[name]) begin
      rq = rtab[name];
      for(int i=0; i<rq.size(); ++i) begin
        r = rq.get(i);
        reads = 0;
        writes = 0;
        foreach(r.access[str]) begin
          a = r.access[str];
          reads += a.read_count;
          writes += a.write_count;
        end
        if(writes > 0 && reads == 0)
          q.push_back(r);
      end
    end

    return q;

  endfunction
`endif // UVM_ENABLE_DEPRECATED_API

  // Prints resouce queue into ~printer~, non-LRM
                                  
  
  // Function -- NODOCS -- print_resources
  //
  // Print the resources that are in a single queue, ~rq~.  This is a utility
  // function that can be used to print any collection of resources
  // stored in a queue.  The ~audit~ flag determines whether or not the
  // audit trail is printed for each resource along with the name,
  // value, and scope regular expression.

  function void print_resources(uvm_void rq, bit audit = 0);

    int unsigned i;
    string id;


    // Basically this is full implementation of something
    // like uvm_object::print, but we're interleaving
    // scope data, so it's all manual.
  endfunction


  // Function -- NODOCS -- dump
  //
  // dump the entire resource pool.  The resource pool is traversed and
  // each resource is printed.  The utility function print_resources()
  // is used to initiate the printing. If the ~audit~ bit is set then
  // the audit trail is dumped for each resource.

  function void dump(bit audit = 0, uvm_printer printer = null);

    string name;
  endfunction
  
endclass

//----------------------------------------------------------------------
// Class: uvm_resource #(T)
// Implementation of uvm_resource#(T) as defined in section C.2.5.1 of
// 1800.2-2017.
//----------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto C.2.5.1
class uvm_resource #(type T=int) extends uvm_resource_base;

  typedef uvm_resource#(T) this_type;

  // singleton handle that represents the type of this resource
  static this_type my_type = get_type();

  // Can't be since things like strings are not legal.
  protected T val;

  // Because of uvm_resource#(T)::get_type, we can't use
  // the macros.  We need to do it all manually.
  typedef uvm_object_registry#(this_type) type_id;
  virtual function uvm_object_wrapper get_object_type();
    return type_id::get();
  endfunction : get_object_type
  virtual function uvm_object create (string name="");
    this_type tmp;
    if (name=="") tmp = new();
    else tmp = new(name);
    return tmp;
  endfunction : create
  `uvm_type_name_decl($sformatf("uvm_resource#(%s)", `uvm_typename(T)))
  
  
`ifdef UVM_ENABLE_DEPRECATED_API
  function new(string name="", scope="");
    super.new(name, scope);
  endfunction
`else
  // @uvm-ieee 1800.2-2017 auto C.2.5.2
  function new(string name="");
    super.new(name);
  endfunction
`endif // UVM_ENABLE_DEPRECATED_API

  virtual function string m_value_type_name();
    return `uvm_typename(T);
  endfunction : m_value_type_name
                                    
  virtual function string m_value_as_string();
    return $sformatf("%0p", val);
  endfunction : m_value_as_string
                                    
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

  static function this_type get_type();
    if(my_type == null)
      my_type = new();
    return my_type;
  endfunction

  // Function -- NODOCS -- get_type_handle
  //
  // Returns the static type handle of this resource in a polymorphic
  // fashion.  The return type of get_type_handle() is
  // uvm_resource_base.  This function is not static and therefore can
  // only be used by instances of a parameterized resource.

  // @uvm-ieee 1800.2-2017 auto C.2.5.3.2
  function uvm_resource_base get_type_handle();
    return get_type();
  endfunction

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

  function void set();
    uvm_resource_pool rp = uvm_resource_pool::get();
    rp.set_scope(this, get_scope());
  endfunction

  
  // Function -- NODOCS -- set_override
  //
  // Put a resource into the global resource pool as an override.  This
  // means it gets put at the head of the list and is searched before
  // other existing resources that occupy the same position in the name
  // map or the type map.  The default is to override both the name and
  // type maps.  However, using the ~override~ argument you can specify
  // that either the name map or type map is overridden.

  function void set_override(uvm_resource_types::override_t override = 2'b11);
    uvm_resource_pool rp = uvm_resource_pool::get();
    if(override)
      rp.set_override(this, get_scope());
    else
      rp.set_scope(this, get_scope());
  endfunction

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
                                        bit rpterr = 1);

    uvm_resource_pool rp = uvm_resource_pool::get();
    uvm_resource_base rsrc_base;
    this_type rsrc;
    string msg;

    rsrc_base = rp.get_by_name(scope, name, my_type, rpterr);
    if(rsrc_base == null)
      return null;

    if(!$cast(rsrc, rsrc_base)) begin
      if(rpterr) begin
        $sformat(msg, "Resource with name %s in scope %s has incorrect type", name, scope);
        `uvm_warning("RSRCTYPE", msg)
      end
      return null;
    end

    return rsrc;
    
  endfunction

  // Function -- NODOCS -- get_by_type
  //
  // looks up a resource by ~type_handle~ in the type map. The first resource
  // with the specified ~type_handle~ that is visible in the specified ~scope~ is
  // returned, if one exists. If there is no resource matching the specifications,
  // ~null~ is returned.

  static function this_type get_by_type(string scope = "",
                                        uvm_resource_base type_handle);

    uvm_resource_pool rp = uvm_resource_pool::get();
    uvm_resource_base rsrc_base;
    this_type rsrc;
    string msg;

    if(type_handle == null)
      return null;

    rsrc_base = rp.get_by_type(scope, type_handle);
    if(rsrc_base == null)
      return null;

    if(!$cast(rsrc, rsrc_base)) begin
      $sformat(msg, "Resource with specified type handle in scope %s was not located", scope);
      `uvm_warning("RSRCNF", msg)
      return null;
    end

    return rsrc;

  endfunction
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
  function T read(uvm_object accessor = null);
    record_read_access(accessor);
    return val;
  endfunction

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
  function void write(T t, uvm_object accessor = null);

    if(is_read_only()) begin
      uvm_report_error("resource", $sformatf("resource %s is read only -- cannot modify", get_name()));
      return;
    end

    // Set the modified bit and record the transaction only if the value
    // has actually changed.
    if(val == t)
      return;

    record_write_access(accessor);

    // set the value and set the dirty bit
    val = t;
    modified = 1;
  endfunction

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

  function void set_priority (uvm_resource_types::priority_e pri);
    uvm_resource_pool rp = uvm_resource_pool::get();
    rp.set_priority(this, pri);
  endfunction

`endif // UVM_ENABLE_DEPRECATED_API

  // Function -- NODOCS -- get_highest_precedence
  //
  // In a queue of resources, locate the first one with the highest
  // precedence whose type is T.  This function is static so that it can
  // be called from anywhere.

endclass

