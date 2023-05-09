//
//------------------------------------------------------------------------------
// Copyright 2007-2014 Mentor Graphics Corporation
// Copyright 2018 Qualcomm, Inc.
// Copyright 2014 Intel Corporation
// Copyright 2011-2014 Synopsys, Inc.
// Copyright 2007-2018 Cadence Design Systems, Inc.
// Copyright 2011 AMD
// Copyright 2014-2018 NVIDIA Corporation
// Copyright 2018 Cisco Systems, Inc.
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

`ifndef UVM_REGISTRY_SVH
`define UVM_REGISTRY_SVH

//------------------------------------------------------------------------------
// Title: Factory Component and Object Wrappers
//
// This section defines the proxy component and object classes used by the
// factory. 
//------------------------------------------------------------------------------

typedef class uvm_registry_common;
typedef class uvm_registry_component_creator;
typedef class uvm_registry_object_creator;

// Class: uvm_component_registry#(T,Tname)
// Implementation of uvm_component_registry#(T,Tname), as defined by section


// Class: uvm_object_registry#(T,Tname)
// Implementation of uvm_object_registry#(T,Tname), as defined by section
// 8.2.4.1 of 1800.2-2017.

// @uvm-ieee 1800.2-2017 auto 8.2.4.1

class uvm_object_registry #(type T=uvm_object, string Tname="<unknown>");
  typedef uvm_object_registry #(T) this_type;
  typedef uvm_registry_common#(this_type) common_type;

endclass

class uvm_registry_common #( type Tregistry=int, type Tcreator=int, type Tcreated=int, string Tname="<unknown>" );

  typedef uvm_registry_common#(Tregistry) this_type;

endclass

class uvm_line_printer1;
   typedef uvm_object_registry#(uvm_line_printer1) type_id;
endclass

class uvm_tree_printer1;
   typedef uvm_object_registry#(uvm_tree_printer1) type_id;
endclass
// Class: uvm_abstract_component_registry#(T,Tname)
// Implementation of uvm_abstract_component_registry#(T,Tname), as defined by section
// 8.2.5.1.1 of 1800.2-2017.

// @uvm-ieee 1800.2-2017 auto 8.2.5.1.1
class uvm_abstract_component_registry #(type T=uvm_component, string Tname="<unknown>")
                                           extends uvm_object_wrapper;
  typedef uvm_abstract_component_registry #(T,Tname) this_type;

  // Function -- NODOCS -- create_component
  //
  // Creates a component of type T having the provided ~name~ and ~parent~.
  // This is an override of the method in <uvm_object_wrapper>. It is
  // called by the factory after determining the type of object to create.
  // You should not call this method directly. Call <create> instead.

  // @uvm-ieee 1800.2-2017 auto 8.2.5.1.2
  virtual function uvm_component create_component (string name,
                                                   uvm_component parent); endfunction static function string type_name(); endfunction : type_name

  // Function -- NODOCS -- get_type_name
  //
  // Returns the value given by the string parameter, ~Tname~. This method
  // overrides the method in <uvm_object_wrapper>.

  virtual function string get_type_name(); endfunction


  // Function -- NODOCS -- get
  //
  // Returns the singleton instance of this type. Type-based factory operation
  // depends on there being a single proxy instance for each registered type.

  static function this_type get(); endfunction


  // Function -- NODOCS -- create
  //
  // Returns an instance of the component type, ~T~, represented by this proxy,
  // subject to any factory overrides based on the context provided by the
  // ~parent~'s full name. The ~contxt~ argument, if supplied, supersedes the
  // ~parent~'s context. The new instance will have the given leaf ~name~
  // and ~parent~.

  static function T create(string name, uvm_component parent, string contxt=""); endfunction


  // Function -- NODOCS -- set_type_override
  //
  // Configures the factory to create an object of the type represented by
  // ~override_type~ whenever a request is made to create an object of the type,
  // ~T~, represented by this proxy, provided no instance override applies. The
  // original type, ~T~, is typically a super class of the override type.

  static function void set_type_override (uvm_object_wrapper override_type,
                                          bit replace=1); endfunction


  // Function -- NODOCS -- set_inst_override
  //
  // Configures the factory to create a component of the type represented by
  // ~override_type~ whenever a request is made to create an object of the type,
  // ~T~, represented by this proxy,  with matching instance paths. The original
  // type, ~T~, is typically a super class of the override type.
  //
  // If ~parent~ is not specified, ~inst_path~ is interpreted as an absolute
  // instance path, which enables instance overrides to be set from outside
  // component classes. If ~parent~ is specified, ~inst_path~ is interpreted
  // as being relative to the ~parent~'s hierarchical instance path, i.e.
  // ~{parent.get_full_name(),".",inst_path}~ is the instance path that is
  // registered with the override. The ~inst_path~ may contain wildcards for
  // matching against multiple contexts.

  static function void set_inst_override(uvm_object_wrapper override_type,
                                         string inst_path,
                                         uvm_component parent=null); endfunction

  // Function: set_type_alias
  // Sets a type alias for this wrapper in the default factory.
  //
  // If this wrapper is not yet registered with a factory (see <uvm_factory::register>),
  // then the alias is deferred until registration occurs.
  //
  // @uvm-contrib This API is being considered for potential contribution to 1800.2
  static function bit set_type_alias(string alias_name); endfunction

  virtual function void initialize(); endfunction
endclass


// Class: uvm_abstract_object_registry#(T,Tname)
// Implementation of uvm_abstract_object_registry#(T,Tname), as defined by section
// 8.2.5.2.1 of 1800.2-2017.

// @uvm-ieee 1800.2-2017 auto 8.2.5.2.1
class uvm_abstract_object_registry #(type T=uvm_object, string Tname="<unknown>")
                                        extends uvm_object_wrapper;
  typedef uvm_abstract_object_registry #(T,Tname) this_type;


  // Function -- NODOCS -- create_object
  //
  // Creates an object of type ~T~ and returns it as a handle to a
  // <uvm_object>. This is an override of the method in <uvm_object_wrapper>.
  // It is called by the factory after determining the type of object to create.
  // You should not call this method directly. Call <create> instead.

  // @uvm-ieee 1800.2-2017 auto 8.2.5.2.2
  virtual function uvm_object create_object(string name=""); endfunction

  static function string type_name(); endfunction : type_name

  // Function -- NODOCS -- get_type_name
  //
  // Returns the value given by the string parameter, ~Tname~. This method
  // overrides the method in <uvm_object_wrapper>.

  virtual function string get_type_name(); endfunction

  // Function -- NODOCS -- get
  //
  // Returns the singleton instance of this type. Type-based factory operation
  // depends on there being a single proxy instance for each registered type.

  static function this_type get(); endfunction


  // Function -- NODOCS -- create
  //
  // Returns an instance of the object type, ~T~, represented by this proxy,
  // subject to any factory overrides based on the context provided by the
  // ~parent~'s full name. The ~contxt~ argument, if supplied, supersedes the
  // ~parent~'s context. The new instance will have the given leaf ~name~,
  // if provided.

  static function T create (string name="", uvm_component parent=null,
                            string contxt=""); endfunction


  // Function -- NODOCS -- set_type_override
  //
  // Configures the factory to create an object of the type represented by
  // ~override_type~ whenever a request is made to create an object of the type
  // represented by this proxy, provided no instance override applies. The
  // original type, ~T~, is typically a super class of the override type.

  static function void set_type_override (uvm_object_wrapper override_type,
                                          bit replace=1); endfunction


  // Function -- NODOCS -- set_inst_override
  //
  // Configures the factory to create an object of the type represented by
  // ~override_type~ whenever a request is made to create an object of the type
  // represented by this proxy, with matching instance paths. The original
  // type, ~T~, is typically a super class of the override type.
  //
  // If ~parent~ is not specified, ~inst_path~ is interpreted as an absolute
  // instance path, which enables instance overrides to be set from outside
  // component classes. If ~parent~ is specified, ~inst_path~ is interpreted
  // as being relative to the ~parent~'s hierarchical instance path, i.e.
  // ~{parent.get_full_name(),".",inst_path}~ is the instance path that is
  // registered with the override. The ~inst_path~ may contain wildcards for
  // matching against multiple contexts.

  static function void set_inst_override(uvm_object_wrapper override_type,
                                         string inst_path,
                                         uvm_component parent=null); endfunction

  // Function: set_type_alias
  // Sets a type alias for this wrapper in the default factory.
  //
  // If this wrapper is not yet registered with a factory (see <uvm_factory::register>),
  // then the alias is deferred until registration occurs.
  //
  // @uvm-contrib This API is being considered for potential contribution to 1800.2
  static function bit set_type_alias(string alias_name); endfunction

  virtual function void initialize(); endfunction
endclass


//------------------------------------------------------------------------------
//
// CLASS -- NODOCS -- uvm_registry_common #(T,Tname)
//
// This is a helper class which implements the functioanlity that is identical
// between uvm_component_registry and uvm_abstract_component_registry.
//
//------------------------------------------------------------------------------



//------------------------------------------------------------------------------
//
// The next two classes are helper classes passed as type parameters to
// uvm_registry_common.  They abstract away the function calls
// uvm_factory::create_component_by_type  and
// uvm_factory::create_object_by_type.  Choosing between the two is handled at
// compile time..
//
//------------------------------------------------------------------------------

virtual class uvm_registry_component_creator;
endclass

virtual class uvm_registry_object_creator;
endclass



// Group -- NODOCS -- Usage
//
// This section describes usage for the uvm_*_registry classes.
//
// The wrapper classes are used to register lightweight proxies of objects and
// components.
//
// To register a particular component type, you need only typedef a
// specialization of its proxy class, which is typically done inside the class.
//
// For example, to register a UVM component of type ~mycomp~
//
//|  class mycomp extends uvm_component;
//|    typedef uvm_component_registry #(mycomp,"mycomp") type_id;
//|  endclass
//
// However, because of differences between simulators, it is necessary to use a
// macro to ensure vendor interoperability with factory registration. To
// register a UVM component of type ~mycomp~ in a vendor-independent way, you
// would write instead:
//
//|  class mycomp extends uvm_component;
//|    `uvm_component_utils(mycomp)
//|    ...
//|  endclass
//
// The <`uvm_component_utils> macro is for non-parameterized classes. In this
// example, the typedef underlying the macro specifies the ~Tname~
// parameter as "mycomp", and ~mycomp~'s get_type_name() is defined to return
// the same. With ~Tname~ defined, you can use the factory's name-based methods to
// set overrides and create objects and components of non-parameterized types.
//
// For parameterized types, the type name changes with each specialization, so
// you cannot specify a ~Tname~ inside a parameterized class and get the behavior
// you want; the same type name string would be registered for all
// specializations of the class! (The factory would produce warnings for each
// specialization beyond the first.) To avoid the warnings and simulator
// interoperability issues with parameterized classes, you must register
// parameterized classes with a different macro.
//
// For example, to register a UVM component of type driver #(T), you
// would write:
//
//|  class driver #(type T=int) extends uvm_component;
//|    `uvm_component_param_utils(driver #(T))
//|    ...
//|  endclass
//
// The <`uvm_component_param_utils> and <`uvm_object_param_utils> macros are used
// to register parameterized classes with the factory. Unlike the non-param
// versions, these macros do not specify the ~Tname~ parameter in the underlying
// uvm_component_registry typedef, and they do not define the get_type_name
// method for the user class. Consequently, you will not be able to use the
// factory's name-based methods for parameterized classes.
//
// The primary purpose for adding the factory's type-based methods was to
// accommodate registration of parameterized types and eliminate the many sources
// of errors associated with string-based factory usage. Thus, use of name-based
// lookup in <uvm_factory> is no longer recommended.

`endif // UVM_REGISTRY_SVH
