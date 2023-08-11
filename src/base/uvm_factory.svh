//
//------------------------------------------------------------------------------
// Copyright 2007-2014 Mentor Graphics Corporation
// Copyright 2015 Analog Devices, Inc.
// Copyright 2014 Semifore
// Copyright 2017 Intel Corporation
// Copyright 2018 Qualcomm, Inc.
// Copyright 2011 Synopsys, Inc.
// Copyright 2007-2018 Cadence Design Systems, Inc.
// Copyright 2013 Verilab
// Copyright 2013-2018 NVIDIA Corporation
// Copyright 2017 Cisco Systems, Inc.
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


typedef class uvm_object;
typedef class uvm_component;
typedef class uvm_object_wrapper;
typedef class uvm_factory_override;
typedef struct {uvm_object_wrapper m_type;
                string             m_type_name;} m_uvm_factory_type_pair_t;
//Instance overrides by requested type lookup
class uvm_factory_queue_class;
  uvm_factory_override queue[$];
endclass

//------------------------------------------------------------------------------
// Title -- NODOCS -- UVM Factory
//
// This page covers the classes that define the UVM factory facility.
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
//
// CLASS -- NODOCS -- uvm_factory
//
//------------------------------------------------------------------------------
//
// As the name implies, uvm_factory is used to manufacture (create) UVM objects
// and components. Object and component types are registered
// with the factory using lightweight proxies to the actual objects and
// components being created. The <uvm_object_registry #(T,Tname)> and
// <uvm_component_registry #(T,Tname)> class are used to proxy <uvm_objects>
// and <uvm_components>.
//
// The factory provides both name-based and type-based interfaces.
//
// type-based - The type-based interface is far less prone to errors in usage.
//   When errors do occur, they are caught at compile-time.
//
// name-based - The name-based interface is dominated 
//   by string arguments that can be misspelled and provided in the wrong order.
//   Errors in name-based requests might only be caught at the time of the call,
//   if at all. Further, the name-based interface is not portable across
//   simulators when used with parameterized classes.
//
//
// The ~uvm_factory~ is an abstract class which declares many of its methods
// as ~pure virtual~.  The UVM uses the <uvm_default_factory> class
// as its default factory implementation.
//   
// See <uvm_default_factory::Usage> section for details on configuring and using the factory.
//
  
// @uvm-ieee 1800.2-2017 auto 8.3.1.1
virtual class uvm_factory;

  // Group -- NODOCS -- Retrieving the factory

 
         
  // @uvm-ieee 1800.2-2017 auto 8.3.1.2.1
  static function uvm_factory get();
	  	uvm_coreservice_t s;
	  	s = uvm_coreservice_t::get();
	  	return s.get_factory();
  endfunction	
  
  // @uvm-ieee 1800.2-2017 auto 8.3.1.2.2
  static function void set(uvm_factory f);
	  	uvm_coreservice_t s;
	  	s = uvm_coreservice_t::get();
	  	s.set_factory(f);
  endfunction	

  // Group -- NODOCS -- Registering Types

  // Function -- NODOCS -- register
  //
  // Registers the given proxy object, ~obj~, with the factory. The proxy object
  // is a lightweight substitute for the component or object it represents. When
  // the factory needs to create an object of a given type, it calls the proxy's
  // create_object or create_component method to do so.
  //
  // When doing name-based operations, the factory calls the proxy's
  // ~get_type_name~ method to match against the ~requested_type_name~ argument in
  // subsequent calls to <create_component_by_name> and <create_object_by_name>.
  // If the proxy object's ~get_type_name~ method returns the empty string,
  // name-based lookup is effectively disabled.

  // @uvm-ieee 1800.2-2017 auto 8.3.1.3
  pure virtual function void register (uvm_object_wrapper obj);


  // Group -- NODOCS -- Type & Instance Overrides

  // Function -- NODOCS -- set_inst_override_by_type

  pure virtual function
      // @uvm-ieee 1800.2-2017 auto 8.3.1.4.1
      void set_inst_override_by_type (uvm_object_wrapper original_type,
                                      uvm_object_wrapper override_type,
                                      string full_inst_path);

  // Function -- NODOCS -- set_inst_override_by_name
  //
  // Configures the factory to create an object of the override's type whenever
  // a request is made to create an object of the original type using a context
  // that matches ~full_inst_path~. The original type is typically a super class
  // of the override type.
  //
  // When overriding by type, the ~original_type~ and ~override_type~ are
  // handles to the types' proxy objects. Preregistration is not required.
  //
  // When overriding by name, the ~original_type_name~ typically refers to a
  // preregistered type in the factory. It may, however, be any arbitrary
  // string. Future calls to any of the ~create_*~ methods with the same string
  // and matching instance path will produce the type represented by
  // ~override_type_name~, which must be preregistered with the factory.
  //
  // The ~full_inst_path~ is matched against the concatenation of
  // {~parent_inst_path~, ".", ~name~} provided in future create requests. The
  // ~full_inst_path~ may include wildcards (* and ?) such that a single
  // instance override can be applied in multiple contexts. A ~full_inst_path~
  // of "*" is effectively a type override, as it will match all contexts.
  //
  // When the factory processes instance overrides, the instance queue is
  // processed in order of override registrations, and the first override
  // match prevails. Thus, more specific overrides should be registered
  // first, followed by more general overrides.

  pure virtual function
      // @uvm-ieee 1800.2-2017 auto 8.3.1.4.1
      void set_inst_override_by_name (string original_type_name,
                                      string override_type_name,
                                      string full_inst_path);


  // Function -- NODOCS -- set_type_override_by_type

  pure virtual function
      // @uvm-ieee 1800.2-2017 auto 8.3.1.4.2
      void set_type_override_by_type (uvm_object_wrapper original_type,
                                      uvm_object_wrapper override_type,
                                      bit replace=1);

  // Function -- NODOCS -- set_type_override_by_name
  //
  // Configures the factory to create an object of the override's type whenever
  // a request is made to create an object of the original type, provided no
  // instance override applies. The original type is typically a super class of
  // the override type.
  //
  // When overriding by type, the ~original_type~ and ~override_type~ are
  // handles to the types' proxy objects. Preregistration is not required.
  //
  // When overriding by name, the ~original_type_name~ typically refers to a
  // preregistered type in the factory. It may, however, be any arbitrary
  // string. Future calls to any of the ~create_*~ methods with the same string
  // and matching instance path will produce the type represented by
  // ~override_type_name~, which must be preregistered with the factory.
  //
  // When ~replace~ is 1, a previous override on ~original_type_name~ is
  // replaced, otherwise a previous override, if any, remains intact.

  pure virtual function
      // @uvm-ieee 1800.2-2017 auto 8.3.1.4.2
      void set_type_override_by_name (string original_type_name,
                                      string override_type_name,
                                      bit replace=1);


  // Group -- NODOCS -- Creation

  // Function -- NODOCS -- create_object_by_type

  pure virtual function
      // @uvm-ieee 1800.2-2017 auto 8.3.1.5
      uvm_object    create_object_by_type    (uvm_object_wrapper requested_type,  
                                              string parent_inst_path="",
                                              string name=""); 

  // Function -- NODOCS -- create_component_by_type

  pure virtual function
      // @uvm-ieee 1800.2-2017 auto 8.3.1.5
      uvm_component create_component_by_type (uvm_object_wrapper requested_type,  
                                              string parent_inst_path="",
                                              string name, 
                                              uvm_component parent);

  // Function -- NODOCS -- create_object_by_name

  pure virtual function
      // @uvm-ieee 1800.2-2017 auto 8.3.1.5
      uvm_object    create_object_by_name    (string requested_type_name,  
                                              string parent_inst_path="",
                                              string name=""); 

   // Function -- NODOCS -- is_type_name_registered
    
     pure virtual
        // @uvm-ieee 1800.2-2017 auto 8.3.1.7.3
        function bit is_type_name_registered  (string type_name);

 
   // Function -- NODOCS -- is_type_registered 

     pure virtual 
        // @uvm-ieee 1800.2-2017 auto 8.3.1.7.4
        function bit is_type_registered     (uvm_object_wrapper obj); 

    
  //
  // Creates and returns a component or object of the requested type, which may
  // be specified by type or by name. A requested component must be derived
  // from the <uvm_component> base class, and a requested object must be derived
  // from the <uvm_object> base class.
  //
  // When requesting by type, the ~requested_type~ is a handle to the type's
  // proxy object. Preregistration is not required.
  //
  // When requesting by name, the ~request_type_name~ is a string representing
  // the requested type, which must have been registered with the factory with
  // that name prior to the request. If the factory does not recognize the
  // ~requested_type_name~, an error is produced and a ~null~ handle returned.
  //
  // If the optional ~parent_inst_path~ is provided, then the concatenation,
  // {~parent_inst_path~, ".",~name~}, forms an instance path (context) that
  // is used to search for an instance override. The ~parent_inst_path~ is
  // typically obtained by calling the <uvm_component::get_full_name> on the
  // parent.
  //
  // If no instance override is found, the factory then searches for a type
  // override.
  //
  // Once the final override is found, an instance of that component or object
  // is returned in place of the requested type. New components will have the
  // given ~name~ and ~parent~. New objects will have the given ~name~, if
  // provided.
  //
  // Override searches are recursively applied, with instance overrides taking
  // precedence over type overrides. If ~foo~ overrides ~bar~, and ~xyz~
  // overrides ~foo~, then a request for ~bar~ will produce ~xyz~. Recursive
  // loops will result in an error, in which case the type returned will be
  // that which formed the loop. Using the previous example, if ~bar~
  // overrides ~xyz~, then ~bar~ is returned after the error is issued.

  pure virtual function
      // @uvm-ieee 1800.2-2017 auto 8.3.1.5
      uvm_component create_component_by_name (string requested_type_name,  
                                              string parent_inst_path="",
                                              string name, 
                                              uvm_component parent);

  // Group -- NODOCS -- Name Aliases
  
  // Function -- NODOCS -- set_type_alias
  pure virtual function
      // @uvm-ieee 1800.2-2017 auto 8.3.1.6.1
      void set_type_alias(string alias_type_name, 
                          uvm_object_wrapper original_type); 
  
  //Intended to allow overrides by type to use the alias_type_name as an additional name to refer to
  //original_type  
  
  // Function -- NODOCS -- set_inst_alias
  pure virtual function
      // @uvm-ieee 1800.2-2017 auto 8.3.1.6.2
      void set_inst_alias(string alias_type_name,
                          uvm_object_wrapper original_type, string full_inst_path);

  //Intended to allow overrides by name to use the alias_type_name as an additional name to refer to
  //original_type in the context referred to by full_inst_path.  


  // Group -- NODOCS -- Debug

  // Function -- NODOCS -- debug_create_by_type

  pure virtual function
      void debug_create_by_type (uvm_object_wrapper requested_type,
                                 string parent_inst_path="",
                                 string name="");

  // Function -- NODOCS -- debug_create_by_name
  //
  // These methods perform the same search algorithm as the ~create_*~ methods,
  // but they do not create new objects. Instead, they provide detailed
  // information about what type of object it would return, listing each
  // override that was applied to arrive at the result. Interpretation of the
  // arguments are exactly as with the ~create_*~ methods.

  pure virtual function
      void debug_create_by_name (string requested_type_name,
                                 string parent_inst_path="",
                                 string name="");

                   
  // Function -- NODOCS -- find_override_by_type

  pure virtual function
      // @uvm-ieee 1800.2-2017 auto 8.3.1.7.1
      uvm_object_wrapper find_override_by_type (uvm_object_wrapper requested_type,
                                                string full_inst_path);

  // Function -- NODOCS -- find_override_by_name
  //
  // These methods return the proxy to the object that would be created given
  // the arguments. The ~full_inst_path~ is typically derived from the parent's
  // instance path and the leaf name of the object to be created, i.e.
  // { parent.get_full_name(), ".", name }.

  pure virtual function
      // @uvm-ieee 1800.2-2017 auto 8.3.1.7.1
      uvm_object_wrapper find_override_by_name (string requested_type_name,
                                                string full_inst_path);

  // Function -- NODOCS -- find_wrapper_by_name
  //
  // This method returns the <uvm_object_wrapper> associated with a given
  // ~type_name~.  
  pure virtual 
    // @uvm-ieee 1800.2-2017 auto 8.3.1.7.2
    function uvm_object_wrapper find_wrapper_by_name            (string type_name);

  // Function -- NODOCS -- print
  //
  // Prints the state of the uvm_factory, including registered types, instance
  // overrides, and type overrides.
  //
  // When ~all_types~ is 0, only type and instance overrides are displayed. When
  // ~all_types~ is 1 (default), all registered user-defined types are printed as
  // well, provided they have names associated with them. When ~all_types~ is 2,
  // the UVM types (prefixed with uvm_) are included in the list of registered
  // types.

  // @uvm-ieee 1800.2-2017 auto 8.3.1.7.5
  pure  virtual function void print (int all_types=1);
endclass 
    
//------------------------------------------------------------------------------
//
// CLASS: uvm_default_factory
//
//------------------------------------------------------------------------------
//
// Default implementation of the UVM factory.  The library implements the
// following public API beyond what is documented in IEEE 1800.2.
   
// @uvm-ieee 1800.2-2017 auto 8.3.3
class uvm_default_factory extends uvm_factory;

  // Group --NODOCS-- Registering Types

  // Function --NODOCS-- register
  //
  // Registers the given proxy object, ~obj~, with the factory.
   
  extern virtual function void register (uvm_object_wrapper obj);


  // Group --NODOCS-- Type & Instance Overrides

  // Function --NODOCS-- set_inst_override_by_type

  extern virtual function
      void set_inst_override_by_type (uvm_object_wrapper original_type,
                                      uvm_object_wrapper override_type,
                                      string full_inst_path);

  // Function --NODOCS-- set_inst_override_by_name
  //
  // Configures the factory to create an object of the override's type whenever
  // a request is made to create an object of the original type using a context
  // that matches ~full_inst_path~. 
  // 
  // ~original_type_name~ may be the factory-registered type name or an aliased name
  // specified with <set_inst_alias> in the context of ~full_inst_path~.
  extern virtual function
      void set_inst_override_by_name (string original_type_name,
                                      string override_type_name,
                                      string full_inst_path);


  // Function --NODOCS-- set_type_override_by_type

  extern virtual function
      void set_type_override_by_type (uvm_object_wrapper original_type,
                                      uvm_object_wrapper override_type,
                                      bit replace=1);

  // Function --NODOCS-- set_type_override_by_name
  //
  // Configures the factory to create an object of the override's type whenever
  // a request is made to create an object of the original type, provided no
  // instance override applies.
  //
  // ~original_type_name~ may be the factory-registered type name or an aliased name
  // specified with <set_type_alias>.
   
  extern virtual function
      void set_type_override_by_name (string original_type_name,
                                      string override_type_name,
                                      bit replace=1);

  // Function --NODOCS-- set_type_alias
  //
  // Intended to allow overrides by type to use the alias_type_name as an additional name to refer to
  // original_type 
  
  extern virtual function
      void set_type_alias(string alias_type_name, 
                          uvm_object_wrapper original_type); 
  
  // Function --NODOCS-- set_inst_alias
  //
  // Intended to allow overrides by name to use the alias_type_name as an additional name to refer to
  // original_type in the context referred to by full_inst_path.  

  extern virtual function
      void set_inst_alias(string alias_type_name,
                          uvm_object_wrapper original_type, string full_inst_path);



  // Group --NODOCS-- Creation

  // Function --NODOCS-- create_object_by_type

  extern virtual function
      uvm_object    create_object_by_type    (uvm_object_wrapper requested_type,  
                                              string parent_inst_path="",
                                              string name=""); 

  // Function --NODOCS-- create_component_by_type

  extern virtual function
      uvm_component create_component_by_type (uvm_object_wrapper requested_type,  
                                              string parent_inst_path="",
                                              string name, 
                                              uvm_component parent);

  // Function --NODOCS-- create_object_by_name

  extern virtual function
      uvm_object    create_object_by_name    (string requested_type_name,  
                                              string parent_inst_path="",
                                              string name=""); 

  // Function --NODOCS-- create_component_by_name
  //
  // Creates and returns a component or object of the requested type, which may
  // be specified by type or by name.
   
  extern virtual function
      uvm_component create_component_by_name (string requested_type_name,  
                                              string parent_inst_path="",
                                              string name, 
                                              uvm_component parent);

  // Function --NODOCS-- is_type_name_registered
  //
  // silently check type with a given name was registered in the factory or not
 
  extern virtual
      function bit is_type_name_registered    (string type_name);

   
  // Function --NODOCS-- is_type_registered
  //
  // silently check type is registered in the factory or not
 
  extern virtual
      function bit is_type_registered    (uvm_object_wrapper obj);


  // Function: debug_create_by_type
  // Debug traces for ~create_*_by_type~ methods.
  //
  // This method performs the same search algorithm as the <create_object_by_type> and
  // <create_component_by_type> methods, however instead of creating the new object or component,
  // the method shall generate a report message detailing how the object or component would
  // have been constructed after all overrides are accounted for.
  //
  // @uvm-accellera The details of this API are specific to the Accellera implementation, and are not being considered for contribution to 1800.2
  extern virtual function
      void debug_create_by_type (uvm_object_wrapper requested_type,
                                 string parent_inst_path="",
                                 string name="");

  // Function: debug_create_by_name
  // Debug traces for ~create_*_by_name~ methods.
  //
  // This method performs the same search algorithm as the <create_object_by_name> and
  // <create_component_by_name> methods, however instead of creating the new object or component,
  // the method shall generate a report message detailing how the object or component would
  // have been constructed after all overrides are accounted for.
  //
  // @uvm-accellera The details of this API are specific to the Accellera implementation, and are not being considered for contribution to 1800.2
  extern virtual function
      void debug_create_by_name (string requested_type_name,
                                 string parent_inst_path="",
                                 string name="");

                   
  // Function --NODOCS-- find_override_by_type

  extern virtual function
      uvm_object_wrapper find_override_by_type (uvm_object_wrapper requested_type,
                                                string full_inst_path);

  // Function --NODOCS-- find_override_by_name
  //
  // These methods return the proxy to the object that would be created given
  // the arguments.
   
  extern virtual function
      uvm_object_wrapper find_override_by_name (string requested_type_name,
                                                string full_inst_path);

  extern virtual 
    function uvm_object_wrapper find_wrapper_by_name            (string type_name);

  // Function --NODOCS-- print
  //
  // Prints the state of the uvm_factory, including registered types, instance
  // overrides, and type overrides.
  //
  extern  virtual function void print (int all_types=1);


  //----------------------------------------------------------------------------
  // PRIVATE MEMBERS
  
  extern protected
      function void  m_debug_create (string requested_type_name,
                                     uvm_object_wrapper requested_type,
                                     string parent_inst_path,
                                     string name);
  
  extern protected
      function void  m_debug_display(string requested_type_name,
                                     uvm_object_wrapper result,
                                     string full_inst_path);

  extern  
      function uvm_object_wrapper m_resolve_type_name(string requested_type_name);
   
  extern  
      function uvm_object_wrapper m_resolve_type_name_by_inst(string requested_type_name,
                                                              string full_inst_path);   

  extern 
      function bit m_matches_type_pair(m_uvm_factory_type_pair_t match_type_pair,
                                       uvm_object_wrapper requested_type,
                                       string requested_type_name);
   
  extern 
      function bit m_matches_type_override(uvm_factory_override override,
                                           uvm_object_wrapper requested_type,
                                           string requested_type_name,
                                           string full_inst_path="",
                                           bit match_original_type = 1,
                                           bit resolve_null_type_by_inst=0);
  extern 
      function bit m_matches_inst_override(uvm_factory_override override,
                                           uvm_object_wrapper requested_type,
                                           string requested_type_name,
                                           string full_inst_path="");
   
  typedef struct  {
    m_uvm_factory_type_pair_t orig;
    string alias_type_name;
    string full_inst_path;
  } m_inst_typename_alias_t;
    
  protected bit                      m_types[uvm_object_wrapper];
  protected bit                      m_lookup_strs[string];
  protected uvm_object_wrapper       m_type_names[string];
  protected m_inst_typename_alias_t  m_inst_aliases[$];

  protected uvm_factory_override m_type_overrides[$];
  protected uvm_factory_override m_inst_overrides[$];


  local uvm_factory_override     m_override_info[$];
  local static bit m_debug_pass;


  extern function bit check_inst_override_exists
                                      (uvm_object_wrapper original_type,
                                       string original_type_name,
                                       uvm_object_wrapper override_type,
                                       string override_type_name,
                                       string full_inst_path);

endclass
virtual class uvm_object_wrapper;

  // Function -- NODOCS -- create_object
  //
  // Creates a new object with the optional ~name~.
  // An object proxy (e.g., <uvm_object_registry #(T,Tname)>) implements this
  // method to create an object of a specific type, T.

  // @uvm-ieee 1800.2-2017 auto 8.3.2.2.1
  virtual function uvm_object create_object (string name="");
    return null;
  endfunction


  // Function -- NODOCS -- create_component
  //
  // Creates a new component, passing to its constructor the given ~name~ and
  // ~parent~. A component proxy (e.g. <uvm_component_registry #(T,Tname)>)
  // implements this method to create a component of a specific type, T.

  // @uvm-ieee 1800.2-2017 auto 8.3.2.2.2
  virtual function uvm_component create_component (string name, 
                                                   uvm_component parent); 
    return null;
  endfunction


  // Function -- NODOCS -- get_type_name
  // 
  // Derived classes implement this method to return the type name of the object
  // created by <create_component> or <create_object>. The factory uses this
  // name when matching against the requested type in name-based lookups.

  // @uvm-ieee 1800.2-2017 auto 8.3.2.2.3
  pure virtual function string get_type_name();

  virtual function void initialize(); endfunction
endclass


//------------------------------------------------------------------------------
//
// CLASS- uvm_factory_override
//
// Internal class.
//------------------------------------------------------------------------------

class uvm_factory_override;
   
  string full_inst_path;
  m_uvm_factory_type_pair_t orig;
  m_uvm_factory_type_pair_t ovrd;
  bit replace;
  bit selected;
  int unsigned used;
  bit has_wildcard;
   
  function new (string full_inst_path="",
                string orig_type_name="",
                uvm_object_wrapper orig_type=null,
                uvm_object_wrapper ovrd_type,
                string ovrd_type_name="",
                bit replace=0);
      
    this.full_inst_path= full_inst_path;
    this.orig.m_type_name = orig_type_name;
    this.orig.m_type      = orig_type;
    this.ovrd.m_type_name = ovrd_type_name;
    this.ovrd.m_type      = ovrd_type;
    this.replace          = replace;
    this.has_wildcard     = m_has_wildcard(full_inst_path); 
  endfunction
  
  function bit m_has_wildcard(string nm);
    foreach (nm[i]) 
      if(nm[i] == "*" || nm[i] == "?") return 1;
    return 0;
  endfunction
  
  
endclass


//-----------------------------------------------------------------------------
// IMPLEMENTATION
//-----------------------------------------------------------------------------

// register
// --------

function void uvm_default_factory::register (uvm_object_wrapper obj);
   m_type_names[obj.get_type_name()] = obj;
endfunction


// set_type_override_by_type
// -------------------------

function void uvm_default_factory::set_type_override_by_type (uvm_object_wrapper original_type,
                                                      uvm_object_wrapper override_type,
                                                      bit replace=1);

endfunction


// set_type_override_by_name
// -------------------------

function void uvm_default_factory::set_type_override_by_name (string original_type_name,
                                                      string override_type_name,
                                                      bit replace=1);

endfunction


// check_inst_override_exists
// --------------------------
function bit uvm_default_factory::check_inst_override_exists (uvm_object_wrapper original_type,
                                      string original_type_name,
                                      uvm_object_wrapper override_type,
                                      string override_type_name,
                                      string full_inst_path);
  return 0;
endfunction

// set_inst_override_by_type
// -------------------------

function void uvm_default_factory::set_inst_override_by_type (uvm_object_wrapper original_type,
                                                      uvm_object_wrapper override_type,
                                                      string full_inst_path);
  

endfunction


// set_inst_override_by_name
// -------------------------

function void uvm_default_factory::set_inst_override_by_name (string original_type_name,
                                                      string override_type_name,
                                                      string full_inst_path);
endfunction

//set_type_alias
// ---------------------
  
function void uvm_default_factory::set_type_alias(string alias_type_name, 
                          uvm_object_wrapper original_type); 
endfunction

// set_inst_alias
// ---------------------

function void uvm_default_factory::set_inst_alias(string alias_type_name,
                          uvm_object_wrapper original_type, string full_inst_path);
    
endfunction




// create_object_by_name
// ---------------------

function uvm_object uvm_default_factory::create_object_by_name (string requested_type_name,  
                                                        string parent_inst_path="",  
                                                        string name=""); 

   return null;

endfunction


// create_object_by_type
// ---------------------

function uvm_object uvm_default_factory::create_object_by_type (uvm_object_wrapper requested_type,  
                                                        string parent_inst_path="",  
                                                        string name=""); 

endfunction

// is_type_name_registered
// ---------------------
function bit uvm_default_factory::is_type_name_registered (string type_name);
endfunction


// is_type_registered
// ---------------------
function bit uvm_default_factory::is_type_registered (uvm_object_wrapper obj);

endfunction



// create_component_by_name
// ------------------------

function uvm_component uvm_default_factory::create_component_by_name (string requested_type_name,  
                                                              string parent_inst_path="",  
                                                              string name, 
                                                              uvm_component parent);
endfunction


// create_component_by_type
// ------------------------

function uvm_component uvm_default_factory::create_component_by_type (uvm_object_wrapper requested_type,  
                                                            string parent_inst_path="",  
                                                            string name, 
                                                            uvm_component parent);
endfunction



// find_wrapper_by_name
// ------------

function uvm_object_wrapper uvm_default_factory::find_wrapper_by_name(string type_name);
endfunction


// find_override_by_name
// ---------------------

function uvm_object_wrapper uvm_default_factory::find_override_by_name (string requested_type_name,
                                                                string full_inst_path);
endfunction


// find_override_by_type
// ---------------------

function uvm_object_wrapper uvm_default_factory::find_override_by_type(uvm_object_wrapper requested_type,
                                                               string full_inst_path);

endfunction


// print
// -----

function void uvm_default_factory::print (int all_types=1);
endfunction


// debug_create_by_name
// --------------------

function void  uvm_default_factory::debug_create_by_name (string requested_type_name,
                                                  string parent_inst_path="",
                                                  string name="");

endfunction


// debug_create_by_type
// --------------------

function void  uvm_default_factory::debug_create_by_type (uvm_object_wrapper requested_type,
                                                  string parent_inst_path="",
                                                  string name="");

endfunction


// m_debug_create
// --------------

function void  uvm_default_factory::m_debug_create (string requested_type_name,
                                            uvm_object_wrapper requested_type,
                                            string parent_inst_path,
                                            string name);

endfunction


// m_debug_display
// ---------------

function void  uvm_default_factory::m_debug_display (string requested_type_name,
                                             uvm_object_wrapper result,
                                             string full_inst_path);

endfunction


// m_resolve_type_name
// --------------------

function uvm_object_wrapper uvm_default_factory::m_resolve_type_name(string requested_type_name);
endfunction

// m_resolve_type_name_by_inst
// --------------------

function uvm_object_wrapper uvm_default_factory::m_resolve_type_name_by_inst(string requested_type_name,
                                                                             string full_inst_path);
endfunction

// m_matches_type_pair
// --------------------

function bit uvm_default_factory::m_matches_type_pair(m_uvm_factory_type_pair_t match_type_pair,
                                                      uvm_object_wrapper requested_type,
                                                      string requested_type_name);
endfunction

// m_matches_inst_override
// --------------------

function bit uvm_default_factory::m_matches_inst_override(uvm_factory_override override,
                                                          uvm_object_wrapper requested_type,
                                                          string requested_type_name,
                                                          string full_inst_path="");
  m_uvm_factory_type_pair_t match_type_pair = override.orig ;
  if(match_type_pair.m_type == null) begin
    match_type_pair.m_type = m_resolve_type_name_by_inst(match_type_pair.m_type_name, full_inst_path);
  end
  if (m_matches_type_pair(.match_type_pair(match_type_pair),
                          .requested_type(requested_type),
                          .requested_type_name(requested_type_name))) begin
    if(override.has_wildcard) begin
      return (override.full_inst_path == "*" || 
              uvm_is_match(override.full_inst_path,full_inst_path)); 
    end
    else begin
      return (override.full_inst_path == full_inst_path);
    end
  end
  return 0;
endfunction

// m_matches_type_override
// --------------------

function bit uvm_default_factory::m_matches_type_override(uvm_factory_override override,
                                                          uvm_object_wrapper requested_type,
                                                          string requested_type_name,
                                                          string full_inst_path="",
                                                          bit match_original_type = 1,
                                                          bit resolve_null_type_by_inst=0);
  m_uvm_factory_type_pair_t match_type_pair = match_original_type ? override.orig : override.ovrd;
  if(match_type_pair.m_type == null) begin
    if(resolve_null_type_by_inst) begin
      match_type_pair.m_type = m_resolve_type_name_by_inst(match_type_pair.m_type_name,full_inst_path);
    end
    else begin
      match_type_pair.m_type = m_resolve_type_name(match_type_pair.m_type_name);
    end
  end
  return m_matches_type_pair(.match_type_pair(match_type_pair),
                             .requested_type(requested_type),
                             .requested_type_name(requested_type_name));
endfunction
