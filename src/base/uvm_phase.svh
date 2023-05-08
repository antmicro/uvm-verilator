//
//----------------------------------------------------------------------
// Copyright 2007-2014 Mentor Graphics Corporation
// Copyright 2014 Semifore
// Copyright 2010-2014 Synopsys, Inc.
// Copyright 2007-2018 Cadence Design Systems, Inc.
// Copyright 2011-2012 AMD
// Copyright 2013-2018 NVIDIA Corporation
// Copyright 2012-2017 Cisco Systems, Inc.
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

`ifdef UVM_ENABLE_DEPRECATED_API
  typedef class uvm_test_done_objection;
`endif



typedef class uvm_domain;
typedef class uvm_task_phase;

typedef class uvm_phase_cb;


   
//------------------------------------------------------------------------------
//
// Section -- NODOCS -- Phasing Definition classes
//
//------------------------------------------------------------------------------
//
// The following class are used to specify a phase and its implied functionality.
//
  
//------------------------------------------------------------------------------
//
// Class -- NODOCS -- uvm_phase
//
//------------------------------------------------------------------------------
//
// This base class defines everything about a phase: behavior, state, and context.
//
// To define behavior, it is extended by UVM or the user to create singleton
// objects which capture the definition of what the phase does and how it does it.
// These are then cloned to produce multiple nodes which are hooked up in a graph
// structure to provide context: which phases follow which, and to hold the state
// of the phase throughout its lifetime.
// UVM provides default extensions of this class for the standard runtime phases.
// VIP Providers can likewise extend this class to define the phase functor for a
// particular component context as required.
//
// This base class defines everything about a phase: behavior, state, and context.
//
// To define behavior, it is extended by UVM or the user to create singleton
// objects which capture the definition of what the phase does and how it does it.
// These are then cloned to produce multiple nodes which are hooked up in a graph
// structure to provide context: which phases follow which, and to hold the state
// of the phase throughout its lifetime.
// UVM provides default extensions of this class for the standard runtime phases.
// VIP Providers can likewise extend this class to define the phase functor for a
// particular component context as required.
//
// *Phase Definition*
//
// Singleton instances of those extensions are provided as package variables.
// These instances define the attributes of the phase (not what state it is in)
// They are then cloned into schedule nodes which point back to one of these
// implementations, and calls its virtual task or function methods on each
// participating component.
// It is the base class for phase functors, for both predefined and
// user-defined phases. Per-component overrides can use a customized imp.
//
// To create custom phases, do not extend uvm_phase directly: see the
// three predefined extended classes below which encapsulate behavior for
// different phase types: task, bottom-up function and top-down function.
//
// Extend the appropriate one of these to create a uvm_YOURNAME_phase class
// (or YOURPREFIX_NAME_phase class) for each phase, containing the default
// implementation of the new phase, which must be a uvm_component-compatible
// delegate, and which may be a ~null~ implementation. Instantiate a singleton
// instance of that class for your code to use when a phase handle is required.
// If your custom phase depends on methods that are not in uvm_component, but
// are within an extended class, then extend the base YOURPREFIX_NAME_phase
// class with parameterized component class context as required, to create a
// specialized functor which calls your extended component class methods.
// This scheme ensures compile-safety for your extended component classes while
// providing homogeneous base types for APIs and underlying data structures.
//
// *Phase Context*
//
// A schedule is a coherent group of one or mode phase/state nodes linked
// together by a graph structure, allowing arbitrary linear/parallel
// relationships to be specified, and executed by stepping through them in
// the graph order.
// Each schedule node points to a phase and holds the execution state of that
// phase, and has optional links to other nodes for synchronization.
//
// The main operations are: construct, add phases, and instantiate
// hierarchically within another schedule.
//
// Structure is a DAG (Directed Acyclic Graph). Each instance is a node
// connected to others to form the graph. Hierarchy is overlaid with m_parent.
// Each node in the graph has zero or more successors, and zero or more
// predecessors. No nodes are completely isolated from others. Exactly
// one node has zero predecessors. This is the root node. Also the graph
// is acyclic, meaning for all nodes in the graph, by following the forward
// arrows you will never end up back where you started but you will eventually
// reach a node that has no successors.
//
// *Phase State*
//
// A given phase may appear multiple times in the complete phase graph, due
// to the multiple independent domain feature, and the ability for different
// VIP to customize their own phase schedules perhaps reusing existing phases.
// Each node instance in the graph maintains its own state of execution.
//
// *Phase Handle*
//
// Handles of this type uvm_phase are used frequently in the API, both by
// the user, to access phasing-specific API, and also as a parameter to some
// APIs. In many cases, the singleton phase handles can be
// used (eg. <uvm_run_phase::get()>) in APIs. For those APIs that need to look
// up that phase in the graph, this is done automatically.

// @uvm-ieee 1800.2-2017 auto 9.3.1.2
class uvm_phase extends uvm_object;

endclass


//------------------------------------------------------------------------------
//
// Class -- NODOCS -- uvm_phase_state_change
//
//------------------------------------------------------------------------------
//
// Phase state transition descriptor.
// Used to describe the phase transition that caused a
// <uvm_phase_cb::phase_state_changed()> callback to be invoked.
//

// @uvm-ieee 1800.2-2017 auto 9.3.2.1
class uvm_phase_state_change extends uvm_object;

endclass


//------------------------------------------------------------------------------
//
// Class -- NODOCS -- uvm_phase_cb
//
//------------------------------------------------------------------------------
//
// This class defines a callback method that is invoked by the phaser
// during the execution of a specific node in the phase graph or all phase nodes.
// User-defined callback extensions can be used to integrate data types that
// are not natively phase-aware with the UVM phasing.
//

// @uvm-ieee 1800.2-2017 auto 9.3.3.1
class uvm_phase_cb;
endclass

//------------------------------------------------------------------------------
//
// Class -- NODOCS -- uvm_phase_cb_pool
//
//------------------------------------------------------------------------------
//
// Convenience type for the uvm_callbacks#(uvm_phase, uvm_phase_cb) class.
//



//------------------------------------------------------------------------------
//                               IMPLEMENTATION
//------------------------------------------------------------------------------
