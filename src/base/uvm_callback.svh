//----------------------------------------------------------------------
// Copyright 2007-2018 Cadence Design Systems, Inc.
// Copyright 2007-2011 Mentor Graphics Corporation
// Copyright 2010 AMD
// Copyright 2012-2018 NVIDIA Corporation
// Copyright 2014 Semifore
// Copyright 2012 Accellera Systems Initiative
// Copyright 2010-2014 Synopsys, Inc.
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

`include "uvm_macros.svh"

//------------------------------------------------------------------------------
// Title: Callbacks Classes
//
// This section defines the classes used for callback registration, management,
// and user-defined callbacks.
//------------------------------------------------------------------------------

typedef class uvm_root;
typedef class uvm_callback;
typedef class uvm_callbacks_base;


//------------------------------------------------------------------------------
//
// Class - uvm_typeid_base
//
//------------------------------------------------------------------------------
//
// Simple typeid interface. Need this to set up the base-super mapping.
// This is similar to the factory, but much simpler. The idea of this
// interface is that each object type T has a typeid that can be
// used for mapping type relationships. This is not a user visible class.

class uvm_typeid_base;
  static string typename;
  static uvm_callbacks_base typeid_map[uvm_typeid_base];
  static uvm_typeid_base type_map[uvm_callbacks_base];
endclass



//------------------------------------------------------------------------------
//
// Class - uvm_typeid#(T)
//
//------------------------------------------------------------------------------

class uvm_typeid#(type T=uvm_object) extends uvm_typeid_base;
  static uvm_typeid#(T) m_b_inst;
  static function uvm_typeid#(T) get();
    if(m_b_inst == null)
      m_b_inst = new;
    return m_b_inst;
  endfunction
endclass


class uvm_callbacks_base extends uvm_object;

  typedef uvm_callbacks_base this_type;

  /*protected*/ static bit m_tracing = 1;
  static this_type m_b_inst;

  static uvm_pool#(uvm_object,uvm_queue#(uvm_callback)) m_pool;

  static function this_type m_initialize();
    return m_b_inst;
  endfunction

  //Type checking interface
  this_type       m_this_type[$];     //one to many T->T/CB
  uvm_typeid_base m_super_type;       //one to one relation 
  uvm_typeid_base m_derived_types[$]; //one to many relation

  virtual function bit m_am_i_a(uvm_object obj);
    return 0;
  endfunction

  virtual function bit m_is_for_me(uvm_callback cb);
    return 0;
  endfunction

  virtual function bit m_is_registered(uvm_object obj, uvm_callback cb);
    return 0;
  endfunction

  virtual function uvm_queue#(uvm_callback) m_get_tw_cb_q(uvm_object obj);
    return null;
  endfunction

  virtual function void m_add_tw_cbs(uvm_callback cb, uvm_apprepend ordering);
  endfunction

  virtual function bit m_delete_tw_cbs(uvm_callback cb);
    return 0;
  endfunction

  //Check registration. To test registration, start at this class and
  //work down the class hierarchy. If any class returns true then
  //the pair is legal.
  function bit check_registration(uvm_object obj, uvm_callback cb);
    return 0;
  endfunction

endclass



class uvm_typed_callbacks#(type T=uvm_object) extends uvm_callbacks_base;

  static uvm_queue#(uvm_callback) m_tw_cb_q;
  static string m_typename;

  typedef uvm_typed_callbacks#(T) this_type;

  //The actual global object from the derivative class. Note that this is
  //just a reference to the object that is generated in the derived class.
  static this_type m_t_inst;

  static function this_type m_initialize();
    return m_t_inst;
  endfunction

  //Type checking interface: is given ~obj~ of type T?
  virtual function bit m_am_i_a(uvm_object obj);
     return 1;
  endfunction

  //Getting the typewide queue
  virtual function uvm_queue#(uvm_callback) m_get_tw_cb_q(uvm_object obj);
      return null;
  endfunction

  static function int m_cb_find(uvm_queue#(uvm_callback) q, uvm_callback cb);
    return -1;
  endfunction

  static function int m_cb_find_name(uvm_queue#(uvm_callback) q, string name, string where);
    return 0;
  endfunction

  //For a typewide callback, need to add to derivative types as well.
  virtual function void m_add_tw_cbs(uvm_callback cb, uvm_apprepend ordering);
    uvm_object obj;
  endfunction


  //For a typewide callback, need to remove from derivative types as well.
  virtual function bit m_delete_tw_cbs(uvm_callback cb);
     return 1;
  endfunction


  static function void display(T obj=null);
  endfunction

endclass

class uvm_pool1 #(type KEY=int, T=uvm_void);
  virtual function T get (KEY key);
      T default_value;
    return default_value;
  endfunction
endclass

class ToExtend;
   static uvm_pool1#(uvm_object,int) m_pool;
endclass

class uvm_typed_callbacks1 extends ToExtend;
  typedef uvm_typed_callbacks1 this_type;

  static this_type m_t_inst;

  virtual function void m_add_tw_cbs();
     uvm_object obj;
     int q = m_t_inst.m_pool.get(obj);
  endfunction
endclass


//------------------------------------------------------------------------------
//
// CLASS -- NODOCS -- uvm_callbacks #(T,CB)
//
// The ~uvm_callbacks~ class provides a base class for implementing callbacks,
// which are typically used to modify or augment component behavior without
// changing the component class. To work effectively, the developer of the
// component class defines a set of "hook" methods that enable users to
// customize certain behaviors of the component in a manner that is controlled
// by the component developer. The integrity of the component's overall behavior
// is intact, while still allowing certain customizable actions by the user.
// 
// To enable compile-time type-safety, the class is parameterized on both the
// user-defined callback interface implementation as well as the object type
// associated with the callback. The object type-callback type pair are
// associated together using the <`uvm_register_cb> macro to define
// a valid pairing; valid pairings are checked when a user attempts to add
// a callback to an object.
//
// To provide the most flexibility for end-user customization and reuse, it
// is recommended that the component developer also define a corresponding set
// of virtual method hooks in the component itself. This affords users the ability
// to customize via inheritance/factory overrides as well as callback object
// registration. The implementation of each virtual method would provide the
// default traversal algorithm for the particular callback being called. Being
// virtual, users can define subtypes that override the default algorithm,
// perform tasks before and/or after calling super.<method> to execute any
// registered callbacks, or to not call the base implementation, effectively
// disabling that particular hook. A demonstration of this methodology is
// provided in an example included in the kit.
//------------------------------------------------------------------------------

// Class: uvm_callbacks#(T, CB)
// Implementation of uvm_callbacks#(T,CB) class, as defined in
// section 10.7.2.1.
//
// | class uvm_callbacks #(type T=uvm_object, type CB=uvm_callback)
//
  
// @uvm-ieee 1800.2-2017 auto 10.7.2.1
class uvm_callbacks #(type T=uvm_object, type CB=uvm_callback)
    extends uvm_typed_callbacks#(int);

  // Parameter -- NODOCS -- T
  //
  // This type parameter specifies the base object type with which the
  // <CB> callback objects will be registered. This object must be
  // a derivative of ~uvm_object~.

  // Parameter -- NODOCS -- CB
  //
  // This type parameter specifies the base callback type that will be
  // managed by this callback class. The callback type is typically a
  // interface class, which defines one or more virtual method prototypes 
  // that users can override in subtypes. This type must be a derivative
  // of <uvm_callback>.
  
  typedef uvm_callbacks#(T,CB) this_type;


  // Singleton instance is used for type checking
  local static this_type m_inst;

  // typeinfo
  static uvm_typeid_base m_typeid;
  static uvm_typeid_base m_cb_typeid;

  static string m_typename;
  static string m_cb_typename;
  static uvm_callbacks#(T,uvm_callback) m_base_inst;

  bit m_registered;

  // get
  // ---

  static function this_type get();
    return null;
  endfunction



  // m_register_pair
  // -------------
  // Register valid callback type

  static function bit m_register_pair(string tname="", cbname="");
    return 1;
  endfunction

  virtual function bit m_is_registered(uvm_object obj, uvm_callback cb);
  endfunction

  //Does type check to see if the callback is valid for this type
  virtual function bit m_is_for_me(uvm_callback cb);
  endfunction

  // Group -- NODOCS -- Add/delete interface

  // Function -- NODOCS -- add
  //
  // Registers the given callback object, ~cb~, with the given
  // ~obj~ handle. The ~obj~ handle can be ~null~, which allows 
  // registration of callbacks without an object context. If
  // ~ordering~ is UVM_APPEND (default), the callback will be executed
  // after previously added callbacks, else  the callback
  // will be executed ahead of previously added callbacks. The ~cb~
  // is the callback handle; it must be non-~null~, and if the callback
  // has already been added to the object instance then a warning is
  // issued. Note that the CB parameter is optional. For example, the 
  // following are equivalent:
  //
  //| uvm_callbacks#(my_comp)::add(comp_a, cb);
  //| uvm_callbacks#(my_comp, my_callback)::add(comp_a,cb);

  // @uvm-ieee 1800.2-2017 auto 10.7.2.3.1
  static function void add(T obj, uvm_callback cb, uvm_apprepend ordering=UVM_APPEND);
  endfunction

  // Function -- NODOCS -- add_by_name
  //
  // Registers the given callback object, ~cb~, with one or more uvm_components.
  // The components must already exist and must be type T or a derivative. As
  // with <add> the CB parameter is optional. ~root~ specifies the location in
  // the component hierarchy to start the search for ~name~. See <uvm_root::find_all>
  // for more details on searching by name.

  // @uvm-ieee 1800.2-2017 auto 10.7.2.3.2
  static function void add_by_name(string name,
                                   uvm_callback cb,
                                   uvm_component root,
                                   uvm_apprepend ordering=UVM_APPEND);
  endfunction


  // Function -- NODOCS -- delete
  //
  // Deletes the given callback object, ~cb~, from the queue associated with
  //  the given ~obj~ handle. The ~obj~ handle can be ~null~, which allows
  // de-registration of callbacks without an object context. 
  // The ~cb~ is the callback handle; it must be non-~null~, and if the callback
  // has already been removed from the object instance then a warning is
  // issued. Note that the CB parameter is optional. For example, the 
  // following are equivalent:
  //
  //| uvm_callbacks#(my_comp)::delete(comp_a, cb);
  //| uvm_callbacks#(my_comp, my_callback)::delete(comp_a,cb);

  // @uvm-ieee 1800.2-2017 auto 10.7.2.3.3
  static function void delete(T obj, uvm_callback cb);
  endfunction


  // Function -- NODOCS -- delete_by_name
  //
  // Removes the given callback object, ~cb~, associated with one or more 
  // uvm_component callback queues. As with <delete> the CB parameter is 
  // optional. ~root~ specifies the location in the component hierarchy to start 
  // the search for ~name~. See <uvm_root::find_all> for more details on searching 
  // by name.

  // @uvm-ieee 1800.2-2017 auto 10.7.2.3.4
  static function void delete_by_name(string name, uvm_callback cb,
     uvm_component root);
  endfunction

  //--------------------------
  // Group -- NODOCS -- Iterator Interface
  //--------------------------
  //
  // This set of functions provide an iterator interface for callback queues. A facade
  // class, <uvm_callback_iter> is also available, and is the generally preferred way to
  // iterate over callback queues.

  static function void m_get_q (ref uvm_queue #(uvm_callback) q, input T obj);
  endfunction


  // Function -- NODOCS -- get_first
  //
  // Returns the first enabled callback of type CB which resides in the queue for ~obj~.
  // If ~obj~ is ~null~ then the typewide queue for T is searched. ~itr~ is the iterator;
  // it will be updated with a value that can be supplied to <get_next> to get the next
  // callback object.
  //
  // If the queue is empty then ~null~ is returned. 
  //
  // The iterator class <uvm_callback_iter> may be used as an alternative, simplified,
  // iterator interface.

  // @uvm-ieee 1800.2-2017 auto 10.7.2.4.1
  static function CB get_first (ref int itr, input T obj);
    return null;
  endfunction

  // Function -- NODOCS -- get_last
  //
  // Returns the last enabled callback of type CB which resides in the queue for ~obj~.
  // If ~obj~ is ~null~ then the typewide queue for T is searched. ~itr~ is the iterator;
  // it will be updated with a value that can be supplied to <get_prev> to get the previous
  // callback object.
  //
  // If the queue is empty then ~null~ is returned.
  //
  // The iterator class <uvm_callback_iter> may be used as an alternative, simplified,
  // iterator interface.

  // @uvm-ieee 1800.2-2017 auto 10.7.2.4.2
  static function CB get_last (ref int itr, input T obj);
    return null;
  endfunction


  // Function -- NODOCS -- get_next
  //
  // Returns the next enabled callback of type CB which resides in the queue for ~obj~,
  // using ~itr~ as the starting point. If ~obj~ is ~null~ then the typewide queue for T
  // is searched. ~itr~ is the iterator; it will be updated with a value that can be 
  // supplied to <get_next> to get the next callback object.
  //
  // If no more callbacks exist in the queue, then ~null~ is returned. <get_next> will
  // continue to return ~null~ in this case until <get_first> or <get_last> has been used to reset
  // the iterator.
  //
  // The iterator class <uvm_callback_iter> may be used as an alternative, simplified,
  // iterator interface.

  // @uvm-ieee 1800.2-2017 auto 10.7.2.4.3
  static function CB get_next (ref int itr, input T obj);
    return null;
  endfunction


  // Function -- NODOCS -- get_prev
  //
  // Returns the previous enabled callback of type CB which resides in the queue for ~obj~,
  // using ~itr~ as the starting point. If ~obj~ is ~null~ then the typewide queue for T
  // is searched. ~itr~ is the iterator; it will be updated with a value that can be 
  // supplied to <get_prev> to get the previous callback object.
  //
  // If no more callbacks exist in the queue, then ~null~ is returned. <get_prev> will
  // continue to return ~null~ in this case until <get_first> or <get_last> has been used to reset
  // the iterator.
  //
  // The iterator class <uvm_callback_iter> may be used as an alternative, simplified,
  // iterator interface.

  // @uvm-ieee 1800.2-2017 auto 10.7.2.4.4
  static function CB get_prev (ref int itr, input T obj);
    return null;
  endfunction


  // Function: get_all
  // Populates the end of the ~all_callbacks~ queue with the list of all registered callbacks
  // for ~obj~ (whether they are enabled or disabled).
  //
  // If ~obj~ is ~null~, then ~all_callbacks~ shall be populated with all registered typewide
  // callbacks.  If ~obj~ is not ~null~, then ~all_callbacks~ shall be populated with both
  // the typewide and instance callbacks (if any) registered for ~obj~.
  //
  // NOTE: This API contradicts the definition provided in section 10.7.2.5 of the P1800.2-2017
  //       LRM.  See DEVIATIONS.md for additional details.
  //
  //| static function void get_all( ref CB all_callbacks[$], input T obj=null );
  //
  // @uvm-contrib This API is being considered for potential contribution to 1800.2

  // @uvm-ieee 1800.2-2017 auto 10.7.2.5
  static function void get_all ( ref CB all_callbacks[$], input T obj=null );
  endfunction


  //-------------
  // Group -- NODOCS -- Debug
  //-------------

  // Function -- NODOCS -- display
  //
  // This function displays callback information for ~obj~. If ~obj~ is
  // ~null~, then it displays callback information for all objects
  // of type ~T~, including typewide callbacks.

  static function void display(T obj=null);
  endfunction

endclass



//------------------------------------------------------------------------------
//
// Class- uvm_derived_callbacks #(T,ST,CB)
//
//------------------------------------------------------------------------------
// This type is not really expected to be used directly by the user, instead they are 
// expected to use the macro `uvm_set_super_type. The sole purpose of this type is to
// allow for setting up of the derived_type/super_type mapping.
//------------------------------------------------------------------------------

class uvm_derived_callbacks#(type T=uvm_object, type ST=uvm_object, type CB=uvm_callback)
    extends uvm_callbacks#(T,CB);

  typedef uvm_derived_callbacks#(T,ST,CB) this_type;

  static this_type m_d_inst;

  static function this_type get();
    return m_d_inst;
  endfunction

  static function bit register_super_type(string tname="", sname="");
    return 1;
  endfunction

endclass


//------------------------------------------------------------------------------
//
// CLASS -- NODOCS -- uvm_callback_iter
//
//------------------------------------------------------------------------------
// The ~uvm_callback_iter~ class is an iterator class for iterating over
// callback queues of a specific callback type. The typical usage of
// the class is:
//
//| uvm_callback_iter#(mycomp,mycb) iter = new(this);
//| for(mycb cb = iter.first(); cb != null; cb = iter.next())
//|    cb.dosomething();
//
// The callback iteration macros, <`uvm_do_callbacks> and
// <`uvm_do_callbacks_exit_on> provide a simple method for iterating
// callbacks and executing the callback methods.
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto D.1.1
class uvm_callback_iter#(type T = uvm_object, type CB = uvm_callback);

   local int m_i;
   local T   m_obj;
   local CB  m_cb;

   // Function -- NODOCS -- new
   //
   // Creates a new callback iterator object. It is required that the object
   // context be provided.

   // @uvm-ieee 1800.2-2017 auto D.1.2.1
   function new(T obj);
   endfunction

   // Function -- NODOCS -- first
   //
   // Returns the first valid (enabled) callback of the callback type (or
   // a derivative) that is in the queue of the context object. If the
   // queue is empty then ~null~ is returned.

   // @uvm-ieee 1800.2-2017 auto D.1.2.2
   function CB first();
      return m_cb;
   endfunction

   // Function -- NODOCS -- last
   //
   // Returns the last valid (enabled) callback of the callback type (or
   // a derivative) that is in the queue of the context object. If the
   // queue is empty then ~null~ is returned.

   // @uvm-ieee 1800.2-2017 auto D.1.2.3
   function CB last();
      return m_cb;
   endfunction

   // Function -- NODOCS -- next
   //
   // Returns the next valid (enabled) callback of the callback type (or
   // a derivative) that is in the queue of the context object. If there
   // are no more valid callbacks in the queue, then ~null~ is returned.

   // @uvm-ieee 1800.2-2017 auto D.1.2.4
   function CB next();
      return m_cb;
   endfunction

   // Function -- NODOCS -- prev
   //
   // Returns the previous valid (enabled) callback of the callback type (or
   // a derivative) that is in the queue of the context object. If there
   // are no more valid callbacks in the queue, then ~null~ is returned.

   // @uvm-ieee 1800.2-2017 auto D.1.2.5
   function CB prev();
      return m_cb;
   endfunction

   // Function -- NODOCS -- get_cb
   //
   // Returns the last callback accessed via a first() or next()
   // call. 

   // @uvm-ieee 1800.2-2017 auto D.1.2.6
   function CB get_cb();
      return m_cb;
   endfunction
endclass

class uvm_callback extends uvm_object;
  protected bit m_enabled = 1;

  `uvm_object_utils(uvm_callback)
  
  // Function -- NODOCS -- new
  //
  // Creates a new uvm_callback object, giving it an optional ~name~.

  // @uvm-ieee 1800.2-2017 auto 10.7.1.2.1
  function new(string name="uvm_callback");
    super.new(name);
  endfunction


  // Function -- NODOCS -- callback_mode
  //
  // Enable/disable callbacks (modeled like rand_mode and constraint_mode).

  // @uvm-ieee 1800.2-2017 auto 10.7.1.2.2
  function bit callback_mode(int on=-1);
  endfunction


  // Function -- NODOCS -- is_enabled
  //
  // Returns 1 if the callback is enabled, 0 otherwise.

  // @uvm-ieee 1800.2-2017 auto 10.7.1.2.3
  function bit is_enabled();
    return callback_mode();
  endfunction

endclass

