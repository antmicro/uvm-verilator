//
//------------------------------------------------------------------------------
// Copyright 2010 Paradigm Works
// Copyright 2007-2017 Mentor Graphics Corporation
// Copyright 2014 Semifore
// Copyright 2018 Intel Corporation
// Copyright 2010-2014 Synopsys, Inc.
// Copyright 2007-2018 Cadence Design Systems, Inc.
// Copyright 2011-2018 AMD
// Copyright 2012-2018 Cisco Systems, Inc.
// Copyright 2013-2018 NVIDIA Corporation
// Copyright 2012 Accellera Systems Initiative
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
//------------------------------------------------------------------------------

typedef class uvm_objection;

//------------------------------------------------------------------------------
//
// CLASS -- NODOCS -- uvm_component
//
// The uvm_component class is the root base class for UVM components. In
// addition to the features inherited from <uvm_object> and <uvm_report_object>,
// uvm_component provides the following interfaces:
//
// Hierarchy - provides methods for searching and traversing the component
//     hierarchy.
//
// Phasing - defines a phased test flow that all components follow, with a
//     group of standard phase methods and an API for custom phases and
//     multiple independent phasing domains to mirror DUT behavior e.g. power
//
// Reporting - provides a convenience interface to the <uvm_report_handler>. All
//     messages, warnings, and errors are processed through this interface.
//
// Transaction recording - provides methods for recording the transactions
//     produced or consumed by the component to a transaction database (vendor
//     specific). 
//
// Factory - provides a convenience interface to the <uvm_factory>. The factory
//     is used to create new components and other objects based on type-wide and
//     instance-specific configuration.
//
// The uvm_component is automatically seeded during construction using UVM
// seeding, if enabled. All other objects must be manually reseeded, if
// appropriate. See <uvm_object::reseed> for more information.
//
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto 13.1.1
virtual class uvm_component extends uvm_report_object;

  // Function -- NODOCS -- new
  //
  // Creates a new component with the given leaf instance ~name~ and handle
  // to its ~parent~.  If the component is a top-level component (i.e. it is
  // created in a static module or interface), ~parent~ should be ~null~.
  //
  // The component will be inserted as a child of the ~parent~ object, if any.
  // If ~parent~ already has a child by the given ~name~, an error is produced.
  //
  // If ~parent~ is ~null~, then the component will become a child of the
  // implicit top-level component, ~uvm_top~.
  //
  // All classes derived from uvm_component must call super.new(name,parent).

  // @uvm-ieee 1800.2-2017 auto 13.1.2.1
  extern function new (string name="", uvm_component parent=null);


  //----------------------------------------------------------------------------
  // Group -- NODOCS -- Hierarchy Interface
  //----------------------------------------------------------------------------
  //
  // These methods provide user access to information about the component
  // hierarchy, i.e., topology.
  //
  //----------------------------------------------------------------------------

  // Function -- NODOCS -- get_parent
  //
  // Returns a handle to this component's parent, or ~null~ if it has no parent.

  // @uvm-ieee 1800.2-2017 auto 13.1.3.1
  extern virtual function uvm_component get_parent ();


  // Function -- NODOCS -- get_full_name
  //
  // Returns the full hierarchical name of this object. The default
  // implementation concatenates the hierarchical name of the parent, if any,
  // with the leaf name of this object, as given by <uvm_object::get_name>.

  // @uvm-ieee 1800.2-2017 auto 13.1.3.2
  extern virtual function string get_full_name ();


  // Function -- NODOCS -- get_children
  //
  // This function populates the end of the ~children~ array with the
  // list of this component's children.
  //
  //|   uvm_component array[$];
  //|   my_comp.get_children(array);
  //|   foreach(array[i])
  //|     do_something(array[i]);

  // @uvm-ieee 1800.2-2017 auto 13.1.3.3
  extern function void get_children(ref uvm_component children[$]);



  // @uvm-ieee 1800.2-2017 auto 13.1.3.4
  extern function uvm_component get_child (string name);


  // @uvm-ieee 1800.2-2017 auto 13.1.3.4
  extern function int get_next_child (ref string name);

  // Function -- NODOCS -- get_first_child
  //
  // These methods are used to iterate through this component's children, if
  // any. For example, given a component with an object handle, ~comp~, the
  // following code calls <uvm_object::print> for each child:
  //
  //|    string name;
  //|    uvm_component child;
  //|    if (comp.get_first_child(name))
  //|      do begin
  //|        child = comp.get_child(name);
  //|        child.print();
  //|      end while (comp.get_next_child(name));

  // @uvm-ieee 1800.2-2017 auto 13.1.3.4
  extern function int get_first_child (ref string name);


  // Function -- NODOCS -- get_num_children
  //
  // Returns the number of this component's children.

  // @uvm-ieee 1800.2-2017 auto 13.1.3.5
  extern function int get_num_children ();


  // Function -- NODOCS -- has_child
  //
  // Returns 1 if this component has a child with the given ~name~, 0 otherwise.

  // @uvm-ieee 1800.2-2017 auto 13.1.3.6
  extern function int has_child (string name);


  // Function - set_name
  //
  // Renames this component to ~name~ and recalculates all descendants'
  // full names. This is an internal function for now.

  extern virtual function void set_name (string name);


  // Function -- NODOCS -- lookup
  //
  // Looks for a component with the given hierarchical ~name~ relative to this
  // component. If the given ~name~ is preceded with a '.' (dot), then the search
  // begins relative to the top level (absolute lookup). The handle of the
  // matching component is returned, else ~null~. The name must not contain
  // wildcards.

  // @uvm-ieee 1800.2-2017 auto 13.1.3.7
  extern function uvm_component lookup (string name);


  // Function -- NODOCS -- get_depth
  //
  // Returns the component's depth from the root level. uvm_top has a
  // depth of 0. The test and any other top level components have a depth
  // of 1, and so on.

  extern function int unsigned get_depth();


  //----------------------------------------------------------------------------
  // Group -- NODOCS -- Phasing Interface
  //----------------------------------------------------------------------------
  //
  // These methods implement an interface which allows all components to step
  // through a standard schedule of phases, or a customized schedule, and
  // also an API to allow independent phase domains which can jump like state
  // machines to reflect behavior e.g. power domains on the DUT in different
  // portions of the testbench. The phase tasks and functions are the phase
  // name with the _phase suffix. For example, the build phase function is
  // <build_phase>.
  //
  // All processes associated with a task-based phase are killed when the phase
  // ends. See <uvm_task_phase> for more details.
  //----------------------------------------------------------------------------


  // Function -- NODOCS -- build_phase
  //
  // The <uvm_build_phase> phase implementation method.
  //
  // Any override should call super.build_phase(phase) to execute the automatic
  // configuration of fields registered in the component by calling
  // <apply_config_settings>.
  // To turn off automatic configuration for a component,
  // do not call super.build_phase(phase).
  //
  // This method should never be called directly.

  // @uvm-ieee 1800.2-2017 auto 13.1.4.1.1
  extern virtual function void build_phase(uvm_phase phase);

  // Function -- NODOCS -- connect_phase
  //
  // The <uvm_connect_phase> phase implementation method.
  //
  // This method should never be called directly.

  // @uvm-ieee 1800.2-2017 auto 13.1.4.1.2
  extern virtual function void connect_phase(uvm_phase phase);

  // Function -- NODOCS -- end_of_elaboration_phase
  //
  // The <uvm_end_of_elaboration_phase> phase implementation method.
  //
  // This method should never be called directly.

  // @uvm-ieee 1800.2-2017 auto 13.1.4.1.3
  extern virtual function void end_of_elaboration_phase(uvm_phase phase);

  // Function -- NODOCS -- start_of_simulation_phase
  //
  // The <uvm_start_of_simulation_phase> phase implementation method.
  //
  // This method should never be called directly.

  // @uvm-ieee 1800.2-2017 auto 13.1.4.1.4
  extern virtual function void start_of_simulation_phase(uvm_phase phase);

  // Task -- NODOCS -- run_phase
  //
  // The <uvm_run_phase> phase implementation method.
  //
  // This task returning or not does not indicate the end
  // or persistence of this phase.
  // Thus the phase will automatically
  // end once all objections are dropped using ~phase.drop_objection()~.
  //
  // Any processes forked by this task continue to run
  // after the task returns,
  // but they will be killed once the phase ends.
  //
  // The run_phase task should never be called directly.

  // @uvm-ieee 1800.2-2017 auto 13.1.4.1.5
  extern virtual task run_phase(uvm_phase phase);

  // Task -- NODOCS -- pre_reset_phase
  //
  // The <uvm_pre_reset_phase> phase implementation method.
  //
  // This task returning or not does not indicate the end
  // or persistence of this phase.
  // It is necessary to raise an objection
  // using ~phase.raise_objection()~ to cause the phase to persist.
  // Once all components have dropped their respective objection
  // using ~phase.drop_objection()~, or if no components raises an
  // objection, the phase is ended.
  //
  // Any processes forked by this task continue to run
  // after the task returns,
  // but they will be killed once the phase ends.
  //
  // This method should not be called directly.

  // @uvm-ieee 1800.2-2017 auto 13.1.4.2.1
  extern virtual task pre_reset_phase(uvm_phase phase);

  // Task -- NODOCS -- reset_phase
  //
  // The <uvm_reset_phase> phase implementation method.
  //
  // This task returning or not does not indicate the end
  // or persistence of this phase.
  // It is necessary to raise an objection
  // using ~phase.raise_objection()~ to cause the phase to persist.
  // Once all components have dropped their respective objection
  // using ~phase.drop_objection()~, or if no components raises an
  // objection, the phase is ended.
  //
  // Any processes forked by this task continue to run
  // after the task returns,
  // but they will be killed once the phase ends.
  //
  // This method should not be called directly.

  // @uvm-ieee 1800.2-2017 auto 13.1.4.2.2
  extern virtual task reset_phase(uvm_phase phase);

  // Task -- NODOCS -- post_reset_phase
  //
  // The <uvm_post_reset_phase> phase implementation method.
  //
  // This task returning or not does not indicate the end
  // or persistence of this phase.
  // It is necessary to raise an objection
  // using ~phase.raise_objection()~ to cause the phase to persist.
  // Once all components have dropped their respective objection
  // using ~phase.drop_objection()~, or if no components raises an
  // objection, the phase is ended.
  //
  // Any processes forked by this task continue to run
  // after the task returns,
  // but they will be killed once the phase ends.
  //
  // This method should not be called directly.

  // @uvm-ieee 1800.2-2017 auto 13.1.4.2.3
  extern virtual task post_reset_phase(uvm_phase phase);

  // Task -- NODOCS -- pre_configure_phase
  //
  // The <uvm_pre_configure_phase> phase implementation method.
  //
  // This task returning or not does not indicate the end
  // or persistence of this phase.
  // It is necessary to raise an objection
  // using ~phase.raise_objection()~ to cause the phase to persist.
  // Once all components have dropped their respective objection
  // using ~phase.drop_objection()~, or if no components raises an
  // objection, the phase is ended.
  //
  // Any processes forked by this task continue to run
  // after the task returns,
  // but they will be killed once the phase ends.
  //
  // This method should not be called directly.

  // @uvm-ieee 1800.2-2017 auto 13.1.4.2.4
  extern virtual task pre_configure_phase(uvm_phase phase);

  // Task -- NODOCS -- configure_phase
  //
  // The <uvm_configure_phase> phase implementation method.
  //
  // This task returning or not does not indicate the end
  // or persistence of this phase.
  // It is necessary to raise an objection
  // using ~phase.raise_objection()~ to cause the phase to persist.
  // Once all components have dropped their respective objection
  // using ~phase.drop_objection()~, or if no components raises an
  // objection, the phase is ended.
  //
  // Any processes forked by this task continue to run
  // after the task returns,
  // but they will be killed once the phase ends.
  //
  // This method should not be called directly.

  // @uvm-ieee 1800.2-2017 auto 13.1.4.2.5
  extern virtual task configure_phase(uvm_phase phase);

  // Task -- NODOCS -- post_configure_phase
  //
  // The <uvm_post_configure_phase> phase implementation method.
  //
  // This task returning or not does not indicate the end
  // or persistence of this phase.
  // It is necessary to raise an objection
  // using ~phase.raise_objection()~ to cause the phase to persist.
  // Once all components have dropped their respective objection
  // using ~phase.drop_objection()~, or if no components raises an
  // objection, the phase is ended.
  //
  // Any processes forked by this task continue to run
  // after the task returns,
  // but they will be killed once the phase ends.
  //
  // This method should not be called directly.

  // @uvm-ieee 1800.2-2017 auto 13.1.4.2.6
  extern virtual task post_configure_phase(uvm_phase phase);

  // Task -- NODOCS -- pre_main_phase
  //
  // The <uvm_pre_main_phase> phase implementation method.
  //
  // This task returning or not does not indicate the end
  // or persistence of this phase.
  // It is necessary to raise an objection
  // using ~phase.raise_objection()~ to cause the phase to persist.
  // Once all components have dropped their respective objection
  // using ~phase.drop_objection()~, or if no components raises an
  // objection, the phase is ended.
  //
  // Any processes forked by this task continue to run
  // after the task returns,
  // but they will be killed once the phase ends.
  //
  // This method should not be called directly.

  // @uvm-ieee 1800.2-2017 auto 13.1.4.2.7
  extern virtual task pre_main_phase(uvm_phase phase);

  // Task -- NODOCS -- main_phase
  //
  // The <uvm_main_phase> phase implementation method.
  //
  // This task returning or not does not indicate the end
  // or persistence of this phase.
  // It is necessary to raise an objection
  // using ~phase.raise_objection()~ to cause the phase to persist.
  // Once all components have dropped their respective objection
  // using ~phase.drop_objection()~, or if no components raises an
  // objection, the phase is ended.
  //
  // Any processes forked by this task continue to run
  // after the task returns,
  // but they will be killed once the phase ends.
  //
  // This method should not be called directly.

  // @uvm-ieee 1800.2-2017 auto 13.1.4.2.8
  extern virtual task main_phase(uvm_phase phase);

  // Task -- NODOCS -- post_main_phase
  //
  // The <uvm_post_main_phase> phase implementation method.
  //
  // This task returning or not does not indicate the end
  // or persistence of this phase.
  // It is necessary to raise an objection
  // using ~phase.raise_objection()~ to cause the phase to persist.
  // Once all components have dropped their respective objection
  // using ~phase.drop_objection()~, or if no components raises an
  // objection, the phase is ended.
  //
  // Any processes forked by this task continue to run
  // after the task returns,
  // but they will be killed once the phase ends.
  //
  // This method should not be called directly.

  // @uvm-ieee 1800.2-2017 auto 13.1.4.2.9
  extern virtual task post_main_phase(uvm_phase phase);

  // Task -- NODOCS -- pre_shutdown_phase
  //
  // The <uvm_pre_shutdown_phase> phase implementation method.
  //
  // This task returning or not does not indicate the end
  // or persistence of this phase.
  // It is necessary to raise an objection
  // using ~phase.raise_objection()~ to cause the phase to persist.
  // Once all components have dropped their respective objection
  // using ~phase.drop_objection()~, or if no components raises an
  // objection, the phase is ended.
  //
  // Any processes forked by this task continue to run
  // after the task returns,
  // but they will be killed once the phase ends.
  //
  // This method should not be called directly.

  // @uvm-ieee 1800.2-2017 auto 13.1.4.2.10
  extern virtual task pre_shutdown_phase(uvm_phase phase);

  // Task -- NODOCS -- shutdown_phase
  //
  // The <uvm_shutdown_phase> phase implementation method.
  //
  // This task returning or not does not indicate the end
  // or persistence of this phase.
  // It is necessary to raise an objection
  // using ~phase.raise_objection()~ to cause the phase to persist.
  // Once all components have dropped their respective objection
  // using ~phase.drop_objection()~, or if no components raises an
  // objection, the phase is ended.
  //
  // Any processes forked by this task continue to run
  // after the task returns,
  // but they will be killed once the phase ends.
  //
  // This method should not be called directly.

  // @uvm-ieee 1800.2-2017 auto 13.1.4.2.11
  extern virtual task shutdown_phase(uvm_phase phase);

  // Task -- NODOCS -- post_shutdown_phase
  //
  // The <uvm_post_shutdown_phase> phase implementation method.
  //
  // This task returning or not does not indicate the end
  // or persistence of this phase.
  // It is necessary to raise an objection
  // using ~phase.raise_objection()~ to cause the phase to persist.
  // Once all components have dropped their respective objection
  // using ~phase.drop_objection()~, or if no components raises an
  // objection, the phase is ended.
  //
  // Any processes forked by this task continue to run
  // after the task returns,
  // but they will be killed once the phase ends.
  //
  // This method should not be called directly.

  // @uvm-ieee 1800.2-2017 auto 13.1.4.2.12
  extern virtual task post_shutdown_phase(uvm_phase phase);

  // Function -- NODOCS -- extract_phase
  //
  // The <uvm_extract_phase> phase implementation method.
  //
  // This method should never be called directly.

  // @uvm-ieee 1800.2-2017 auto 13.1.4.1.6
  extern virtual function void extract_phase(uvm_phase phase);



  // Function -- NODOCS -- check_phase
  //
  // The <uvm_check_phase> phase implementation method.
  //
  // This method should never be called directly.

  // @uvm-ieee 1800.2-2017 auto 13.1.4.1.7
  extern virtual function void check_phase(uvm_phase phase);

  // Function -- NODOCS -- report_phase
  //
  // The <uvm_report_phase> phase implementation method.
  //
  // This method should never be called directly.

  // @uvm-ieee 1800.2-2017 auto 13.1.4.1.8
  extern virtual function void report_phase(uvm_phase phase);

  // Function -- NODOCS -- final_phase
  //
  // The <uvm_final_phase> phase implementation method.
  //
  // This method should never be called directly.

  // @uvm-ieee 1800.2-2017 auto 13.1.4.1.9
  extern virtual function void final_phase(uvm_phase phase);

`ifdef UVM_ENABLE_DEPRECATED_API
  // For backward compatibility the base <build_phase> method calls <build>.
  extern virtual function void build();

  // For backward compatibility the base connect_phase method calls connect.
  extern virtual function void connect();

  // For backward compatibility the base <end_of_elaboration_phase> method calls <end_of_elaboration>.
  extern virtual function void end_of_elaboration();

  // For backward compatibility the base <start_of_simulation_phase> method calls <start_of_simulation>.
  extern virtual function void start_of_simulation();

  // For backward compatibility the base <run_phase> method calls <run>.
  extern virtual task run();

  // For backward compatibility the base extract_phase method calls extract.
  extern virtual function void extract();

  // For backward compatibility the base check_phase method calls check.
  extern virtual function void check();

  // For backward compatibility the base report_phase method calls report.
  extern virtual function void report();
`endif // UVM_ENABLE_DEPRECATED_API

  // Function -- NODOCS -- phase_started
  //
  // Invoked at the start of each phase. The ~phase~ argument specifies
  // the phase being started. Any threads spawned in this callback are
  // not affected when the phase ends.

  // @uvm-ieee 1800.2-2017 auto 13.1.4.3.1
  extern virtual function void phase_started (uvm_phase phase);

  // Function -- NODOCS -- phase_ready_to_end
  //
  // Invoked when all objections to ending the given ~phase~ and all
  // sibling phases have been dropped, thus indicating that ~phase~ is
  // ready to begin a clean exit. Sibling phases are any phases that
  // have a common successor phase in the schedule plus any phases that
  // sync'd to the current phase. Components needing to consume delta
  // cycles or advance time to perform a clean exit from the phase
  // may raise the phase's objection.
  //
  // |phase.raise_objection(this,"Reason");
  //
  // It is the responsibility of this component to drop the objection
  // once it is ready for this phase to end (and processes killed).
  // If no objection to the given ~phase~ or sibling phases are raised,
  // then phase_ended() is called after a delta cycle.  If any objection
  // is raised, then when all objections to ending the given ~phase~
  // and siblings are dropped, another iteration of phase_ready_to_end
  // is called.  To prevent endless iterations due to coding error,
  // after 20 iterations, phase_ended() is called regardless of whether
  // previous iteration had any objections raised.

  // @uvm-ieee 1800.2-2017 auto 13.1.4.3.2
  extern virtual function void phase_ready_to_end (uvm_phase phase);


  // Function -- NODOCS -- phase_ended
  //
  // Invoked at the end of each phase. The ~phase~ argument specifies
  // the phase that is ending.  Any threads spawned in this callback are
  // not affected when the phase ends.

  // @uvm-ieee 1800.2-2017 auto 13.1.4.3.3
  extern virtual function void phase_ended (uvm_phase phase);


  //--------------------------------------------------------------------
  // phase / schedule / domain API
  //--------------------------------------------------------------------


  // Function -- NODOCS -- set_domain
  //
  // Apply a phase domain to this component and, if ~hier~ is set,
  // recursively to all its children.
  //
  // Calls the virtual <define_domain> method, which derived components can
  // override to augment or replace the domain definition of its base class.
  //

  // @uvm-ieee 1800.2-2017 auto 13.1.4.4.1
  extern function void set_domain(uvm_domain domain, int hier=1);


  // Function -- NODOCS -- get_domain
  //
  // Return handle to the phase domain set on this component

  // @uvm-ieee 1800.2-2017 auto 13.1.4.4.2
  extern function uvm_domain get_domain();


  // Function -- NODOCS -- define_domain
  //
  // Builds custom phase schedules into the provided ~domain~ handle.
  //
  // This method is called by <set_domain>, which integrators use to specify
  // this component belongs in a domain apart from the default 'uvm' domain.
  //
  // Custom component base classes requiring a custom phasing schedule can
  // augment or replace the domain definition they inherit by overriding
  // their ~defined_domain~. To augment, overrides would call super.define_domain().
  // To replace, overrides would not call super.define_domain().
  //
  // The default implementation adds a copy of the ~uvm~ phasing schedule to
  // the given ~domain~, if one doesn't already exist, and only if the domain
  // is currently empty.
  //
  // Calling <set_domain>
  // with the default ~uvm~ domain (i.e. <uvm_domain::get_uvm_domain> ) on
  // a component with no ~define_domain~ override effectively reverts the
  // that component to using the default ~uvm~ domain. This may be useful
  // if a branch of the testbench hierarchy defines a custom domain, but
  // some child sub-branch should remain in the default ~uvm~ domain,
  // call <set_domain> with a new domain instance handle with ~hier~ set.
  // Then, in the sub-branch, call <set_domain> with the default ~uvm~ domain handle,
  // obtained via <uvm_domain::get_uvm_domain>.
  //
  // Alternatively, the integrator may define the graph in a new domain externally,
  // then call <set_domain> to apply it to a component.


  // @uvm-ieee 1800.2-2017 auto 13.1.4.4.3
  extern virtual protected function void define_domain(uvm_domain domain);

`ifdef UVM_ENABLE_DEPRECATED_API
  // Function -- NODOCS -- set_phase_imp
  //
  // Override the default implementation for a phase on this component (tree) with a
  // custom one, which must be created as a singleton object extending the default
  // one and implementing required behavior in exec and traverse methods
  //
  // The ~hier~ specifies whether to apply the custom functor to the whole tree or
  // just this component.

  extern function void set_phase_imp(uvm_phase phase, uvm_phase imp, int hier=1);
`endif

  // Task -- NODOCS -- suspend
  //
  // Suspend this component.
  //
  // This method must be implemented by the user to suspend the
  // component according to the protocol and functionality it implements.
  // A suspended component can be subsequently resumed using <resume()>.

  // @uvm-ieee 1800.2-2017 auto 13.1.4.5.1
  extern virtual task suspend ();


  // Task -- NODOCS -- resume
  //
  // Resume this component.
  //
  // This method must be implemented by the user to resume a component
  // that was previously suspended using <suspend()>.
  // Some component may start in the suspended state and
  // may need to be explicitly resumed.

  // @uvm-ieee 1800.2-2017 auto 13.1.4.5.2
  extern virtual task resume ();


  // Function -- NODOCS -- resolve_bindings
  //
  // Processes all port, export, and imp connections. Checks whether each port's
  // min and max connection requirements are met.
  //
  // It is called just before the end_of_elaboration phase.
  //
  // Users should not call directly.

  extern virtual function void resolve_bindings ();

  extern function string massage_scope(string scope);


  //----------------------------------------------------------------------------
  // Group -- NODOCS -- Configuration Interface
  //----------------------------------------------------------------------------
  //
  // Components can be designed to be user-configurable in terms of its
  // topology (the type and number of children it has), mode of operation, and
  // run-time parameters (knobs). The configuration interface accommodates
  // this common need, allowing component composition and state to be modified
  // without having to derive new classes or new class hierarchies for
  // every configuration scenario.
  //
  //----------------------------------------------------------------------------

`ifdef UVM_ENABLE_DEPRECATED_API
  // Function -- NODOCS -- check_config_usage
  //
  // Check all configuration settings in a components configuration table
  // to determine if the setting has been used, overridden or not used.
  // When ~recurse~ is 1 (default), configuration for this and all child
  // components are recursively checked. This function is automatically
  // called in the check phase, but can be manually called at any time.
  //
  // To get all configuration information prior to the run phase, do something
  // like this in your top object:
  //|  function void start_of_simulation_phase(uvm_phase phase);
  //|    check_config_usage();
  //|  endfunction

  extern function void check_config_usage (bit recurse=1);
`endif // UVM_ENABLE_DEPRECATED_API

  // Function -- NODOCS -- apply_config_settings
  //
  // Searches for all config settings matching this component's instance path.
  // For each match, the appropriate set_*_local method is called using the
  // matching config setting's field_name and value. Provided the set_*_local
  // method is implemented, the component property associated with the
  // field_name is assigned the given value.
  //
  // This function is called by <uvm_component::build_phase>.
  //
  // The apply_config_settings method determines all the configuration
  // settings targeting this component and calls the appropriate set_*_local
  // method to set each one. To work, you must override one or more set_*_local
  // methods to accommodate setting of your component's specific properties.
  // Any properties registered with the optional `uvm_*_field macros do not
  // require special handling by the set_*_local methods; the macros provide
  // the set_*_local functionality for you.
  //
  // If you do not want apply_config_settings to be called for a component,
  // then the build_phase() method should be overloaded and you should not call
  // super.build_phase(phase). Likewise, apply_config_settings can be overloaded to
  // customize automated configuration.
  //
  // When the ~verbose~ bit is set, all overrides are printed as they are
  // applied. If the component's <print_config_matches> property is set, then
  // apply_config_settings is automatically called with ~verbose~ = 1.

  // @uvm-ieee 1800.2-2017 auto 13.1.5.1
  extern virtual function void apply_config_settings (bit verbose = 0);

  // Function -- NODOCS -- use_automatic_config
  //
  // Returns 1 if the component should call <apply_config_settings> in the <build_phase>;
  // otherwise, returns 0.
  //
  // @uvm-ieee 1800.2-2017 auto 13.1.5.2
  extern virtual function bit use_automatic_config();

`ifdef UVM_ENABLE_DEPRECATED_API
  // Function -- NODOCS -- print_config_settings
  //
  // Called without arguments, print_config_settings prints all configuration
  // information for this component, as set by previous calls to <uvm_config_db::set()>.
  // The settings are printing in the order of their precedence.
  //
  // If ~field~ is specified and non-empty, then only configuration settings
  // matching that field, if any, are printed. The field may not contain
  // wildcards.
  //
  // If ~comp~ is specified and non-~null~, then the configuration for that
  // component is printed.
  //
  // If ~recurse~ is set, then configuration information for all ~comp~'s
  // children and below are printed as well.
  //
  // This function has been deprecated.  Use print_config instead.

  extern function void print_config_settings (string field="",
                                              uvm_component comp=null,
                                              bit recurse=0);
`endif // UVM_ENABLE_DEPRECATED_API

  // Function: print_config
  //
  // Print_config prints all configuration information for this
  // component, as set by previous calls to <uvm_config_db::set()> and exports to
  // the resources pool.  The settings are printed in the order of
  // their precedence.
  //
  // If ~recurse~ is set, then configuration information for all
  // children and below are printed as well.
  //
  // if ~audit~ is set then the audit trail for each resource is printed
  // along with the resource name and value
  //
  // @uvm-accellera The details of this API are specific to the Accellera implementation, and are not being considered for contribution to 1800.2

  extern function void print_config(bit recurse = 0, bit audit = 0);

  // Function -- NODOCS -- print_config_with_audit
  //
  // Operates the same as print_config except that the audit bit is
  // forced to 1.  This interface makes user code a bit more readable as
  // it avoids multiple arbitrary bit settings in the argument list.
  //
  // If ~recurse~ is set, then configuration information for all
  // children and below are printed as well.

  extern function void print_config_with_audit(bit recurse = 0);

  // Variable: print_config_matches
  //
  // Setting this static variable causes uvm_config_db::get() to print info about
  // matching configuration settings as they are being applied.
  //
  // @uvm-accellera The details of this API are specific to the Accellera implementation, and are not being considered for contribution to 1800.2


  static bit print_config_matches;

  //----------------------------------------------------------------------------
  // Group -- NODOCS -- Objection Interface
  //----------------------------------------------------------------------------
  //
  // These methods provide object level hooks into the <uvm_objection>
  // mechanism.
  //
  //----------------------------------------------------------------------------


  // Function -- NODOCS -- raised
  //
  // The ~raised~ callback is called when this or a descendant of this component
  // instance raises the specified ~objection~. The ~source_obj~ is the object
  // that originally raised the objection.
  // The ~description~ is optionally provided by the ~source_obj~ to give a
  // reason for raising the objection. The ~count~ indicates the number of
  // objections raised by the ~source_obj~.

  // @uvm-ieee 1800.2-2017 auto 13.1.5.4
  virtual function void raised (uvm_objection objection, uvm_object source_obj,
      string description, int count);
  endfunction


  // Function -- NODOCS -- dropped
  //
  // The ~dropped~ callback is called when this or a descendant of this component
  // instance drops the specified ~objection~. The ~source_obj~ is the object
  // that originally dropped the objection.
  // The ~description~ is optionally provided by the ~source_obj~ to give a
  // reason for dropping the objection. The ~count~ indicates the number of
  // objections dropped by the ~source_obj~.

  // @uvm-ieee 1800.2-2017 auto 13.1.5.5
  virtual function void dropped (uvm_objection objection, uvm_object source_obj,
      string description, int count);
  endfunction


  // Task -- NODOCS -- all_dropped
  //
  // The ~all_droppped~ callback is called when all objections have been
  // dropped by this component and all its descendants.  The ~source_obj~ is the
  // object that dropped the last objection.
  // The ~description~ is optionally provided by the ~source_obj~ to give a
  // reason for raising the objection. The ~count~ indicates the number of
  // objections dropped by the ~source_obj~.

  // @uvm-ieee 1800.2-2017 auto 13.1.5.6
  virtual task all_dropped (uvm_objection objection, uvm_object source_obj,
      string description, int count);
  endtask


  //----------------------------------------------------------------------------
  // Group -- NODOCS -- Factory Interface
  //----------------------------------------------------------------------------
  //
  // The factory interface provides convenient access to a portion of UVM's
  // <uvm_factory> interface. For creating new objects and components, the
  // preferred method of accessing the factory is via the object or component
  // wrapper (see <uvm_component_registry #(T,Tname)> and
  // <uvm_object_registry #(T,Tname)>). The wrapper also provides functions
  // for setting type and instance overrides.
  //
  //----------------------------------------------------------------------------

  // Function -- NODOCS -- create_component
  //
  // A convenience function for <uvm_factory::create_component_by_name>,
  // this method calls upon the factory to create a new child component
  // whose type corresponds to the preregistered type name, ~requested_type_name~,
  // and instance name, ~name~. This method is equivalent to:
  //
  //|  factory.create_component_by_name(requested_type_name,
  //|                                   get_full_name(), name, this);
  //
  // If the factory determines that a type or instance override exists, the type
  // of the component created may be different than the requested type. See
  // <set_type_override> and <set_inst_override>. See also <uvm_factory> for
  // details on factory operation.

  extern function uvm_component create_component (string requested_type_name,
                                                  string name);


  // Function -- NODOCS -- create_object
  //
  // A convenience function for <uvm_factory::create_object_by_name>,
  // this method calls upon the factory to create a new object
  // whose type corresponds to the preregistered type name,
  // ~requested_type_name~, and instance name, ~name~. This method is
  // equivalent to:
  //
  //|  factory.create_object_by_name(requested_type_name,
  //|                                get_full_name(), name);
  //
  // If the factory determines that a type or instance override exists, the
  // type of the object created may be different than the requested type.  See
  // <uvm_factory> for details on factory operation.

  extern function uvm_object create_object (string requested_type_name,
                                            string name="");


  // Function -- NODOCS -- set_type_override_by_type
  //
  // A convenience function for <uvm_factory::set_type_override_by_type>, this
  // method registers a factory override for components and objects created at
  // this level of hierarchy or below. This method is equivalent to:
  //
  //|  factory.set_type_override_by_type(original_type, override_type,replace);
  //
  // The ~relative_inst_path~ is relative to this component and may include
  // wildcards. The ~original_type~ represents the type that is being overridden.
  // In subsequent calls to <uvm_factory::create_object_by_type> or
  // <uvm_factory::create_component_by_type>, if the requested_type matches the
  // ~original_type~ and the instance paths match, the factory will produce
  // the ~override_type~.
  //
  // The original and override type arguments are lightweight proxies to the
  // types they represent. See <set_inst_override_by_type> for information
  // on usage.

  extern static function void set_type_override_by_type
                                             (uvm_object_wrapper original_type,
                                              uvm_object_wrapper override_type,
                                              bit replace=1);


  // Function -- NODOCS -- set_inst_override_by_type
  //
  // A convenience function for <uvm_factory::set_inst_override_by_type>, this
  // method registers a factory override for components and objects created at
  // this level of hierarchy or below. In typical usage, this method is
  // equivalent to:
  //
  //|  factory.set_inst_override_by_type( original_type,
  //|                                     override_type,
  //|                                     {get_full_name(),".",
  //|                                      relative_inst_path});
  //
  // The ~relative_inst_path~ is relative to this component and may include
  // wildcards. The ~original_type~ represents the type that is being overridden.
  // In subsequent calls to <uvm_factory::create_object_by_type> or
  // <uvm_factory::create_component_by_type>, if the requested_type matches the
  // ~original_type~ and the instance paths match, the factory will produce the
  // ~override_type~.
  //
  // The original and override types are lightweight proxies to the types they
  // represent. They can be obtained by calling ~type::get_type()~, if
  // implemented by ~type~, or by directly calling ~type::type_id::get()~, where
  // ~type~ is the user type and ~type_id~ is the name of the typedef to
  // <uvm_object_registry #(T,Tname)> or <uvm_component_registry #(T,Tname)>.
  //
  // If you are employing the `uvm_*_utils macros, the typedef and the get_type
  // method will be implemented for you. For details on the utils macros
  // refer to <Utility and Field Macros for Components and Objects>.
  //
  // The following example shows `uvm_*_utils usage:
  //
  //|  class comp extends uvm_component;
  //|    `uvm_component_utils(comp)
  //|    ...
  //|  endclass
  //|
  //|  class mycomp extends uvm_component;
  //|    `uvm_component_utils(mycomp)
  //|    ...
  //|  endclass
  //|
  //|  class block extends uvm_component;
  //|    `uvm_component_utils(block)
  //|    comp c_inst;
  //|    virtual function void build_phase(uvm_phase phase);
  //|      set_inst_override_by_type("c_inst",comp::get_type(),
  //|                                         mycomp::get_type());
  //|    endfunction
  //|    ...
  //|  endclass

  extern function void set_inst_override_by_type(string relative_inst_path,
                                                 uvm_object_wrapper original_type,
                                                 uvm_object_wrapper override_type);


  // Function -- NODOCS -- set_type_override
  //
  // A convenience function for <uvm_factory::set_type_override_by_name>,
  // this method configures the factory to create an object of type
  // ~override_type_name~ whenever the factory is asked to produce a type
  // represented by ~original_type_name~.  This method is equivalent to:
  //
  //|  factory.set_type_override_by_name(original_type_name,
  //|                                    override_type_name, replace);
  //
  // The ~original_type_name~ typically refers to a preregistered type in the
  // factory. It may, however, be any arbitrary string. Subsequent calls to
  // create_component or create_object with the same string and matching
  // instance path will produce the type represented by override_type_name.
  // The ~override_type_name~ must refer to a preregistered type in the factory.

  extern static function void set_type_override(string original_type_name,
                                                string override_type_name,
                                                bit    replace=1);


  // Function -- NODOCS -- set_inst_override
  //
  // A convenience function for <uvm_factory::set_inst_override_by_name>, this
  // method registers a factory override for components created at this level
  // of hierarchy or below. In typical usage, this method is equivalent to:
  //
  //|  factory.set_inst_override_by_name(original_type_name,
  //|                                    override_type_name,
  //|                                    {get_full_name(),".",
  //|                                     relative_inst_path}
  //|                                     );
  //
  // The ~relative_inst_path~ is relative to this component and may include
  // wildcards. The ~original_type_name~ typically refers to a preregistered type
  // in the factory. It may, however, be any arbitrary string. Subsequent calls
  // to create_component or create_object with the same string and matching
  // instance path will produce the type represented by ~override_type_name~.
  // The ~override_type_name~ must refer to a preregistered type in the factory.

  extern function void set_inst_override(string relative_inst_path,
                                         string original_type_name,
                                         string override_type_name);


  // Function -- NODOCS -- print_override_info
  //
  // This factory debug method performs the same lookup process as create_object
  // and create_component, but instead of creating an object, it prints
  // information about what type of object would be created given the
  // provided arguments.

  extern function void print_override_info(string requested_type_name,
                                           string name="");


  //----------------------------------------------------------------------------
  // Group -- NODOCS -- Hierarchical Reporting Interface
  //----------------------------------------------------------------------------
  //
  // This interface provides versions of the set_report_* methods in the
  // <uvm_report_object> base class that are applied recursively to this
  // component and all its children.
  //
  // When a report is issued and its associated action has the LOG bit set, the
  // report will be sent to its associated FILE descriptor.
  //----------------------------------------------------------------------------

  // Function -- NODOCS -- set_report_id_verbosity_hier

  extern function void set_report_id_verbosity_hier (string id,
                                                  int verbosity);

  // Function -- NODOCS -- set_report_severity_id_verbosity_hier
  //
  // These methods recursively associate the specified verbosity with reports of
  // the given ~severity~, ~id~, or ~severity-id~ pair. A verbosity associated
  // with a particular severity-id pair takes precedence over a verbosity
  // associated with id, which takes precedence over a verbosity associated
  // with a severity.
  //
  // For a list of severities and their default verbosities, refer to
  // <uvm_report_handler>.

  extern function void set_report_severity_id_verbosity_hier(uvm_severity severity,
                                                          string id,
                                                          int verbosity);


  // Function -- NODOCS -- set_report_severity_action_hier

  extern function void set_report_severity_action_hier (uvm_severity severity,
                                                        uvm_action action);


  // Function -- NODOCS -- set_report_id_action_hier

  extern function void set_report_id_action_hier (string id,
                                                  uvm_action action);

  // Function -- NODOCS -- set_report_severity_id_action_hier
  //
  // These methods recursively associate the specified action with reports of
  // the given ~severity~, ~id~, or ~severity-id~ pair. An action associated
  // with a particular severity-id pair takes precedence over an action
  // associated with id, which takes precedence over an action associated
  // with a severity.
  //
  // For a list of severities and their default actions, refer to
  // <uvm_report_handler>.

  extern function void set_report_severity_id_action_hier(uvm_severity severity,
                                                          string id,
                                                          uvm_action action);



  // Function -- NODOCS -- set_report_default_file_hier

  extern function void set_report_default_file_hier (UVM_FILE file);

  // Function -- NODOCS -- set_report_severity_file_hier

  extern function void set_report_severity_file_hier (uvm_severity severity,
                                                      UVM_FILE file);

  // Function -- NODOCS -- set_report_id_file_hier

  extern function void set_report_id_file_hier (string id,
                                                UVM_FILE file);

  // Function -- NODOCS -- set_report_severity_id_file_hier
  //
  // These methods recursively associate the specified FILE descriptor with
  // reports of the given ~severity~, ~id~, or ~severity-id~ pair. A FILE
  // associated with a particular severity-id pair takes precedence over a FILE
  // associated with id, which take precedence over an a FILE associated with a
  // severity, which takes precedence over the default FILE descriptor.
  //
  // For a list of severities and other information related to the report
  // mechanism, refer to <uvm_report_handler>.

  extern function void set_report_severity_id_file_hier(uvm_severity severity,
                                                        string id,
                                                        UVM_FILE file);


  // Function -- NODOCS -- set_report_verbosity_level_hier
  //
  // This method recursively sets the maximum verbosity level for reports for
  // this component and all those below it. Any report from this component
  // subtree whose verbosity exceeds this maximum will be ignored.
  //
  // See <uvm_report_handler> for a list of predefined message verbosity levels
  // and their meaning.

    extern function void set_report_verbosity_level_hier (int verbosity);


  // Function -- NODOCS -- pre_abort
  //
  // This callback is executed when the message system is executing a
  // <UVM_EXIT> action. The exit action causes an immediate termination of
  // the simulation, but the pre_abort callback hook gives components an
  // opportunity to provide additional information to the user before
  // the termination happens. For example, a test may want to executed
  // the report function of a particular component even when an error
  // condition has happened to force a premature termination you would
  // write a function like:
  //
  //| function void mycomponent::pre_abort();
  //|   report();
  //| endfunction
  //
  // The pre_abort() callback hooks are called in a bottom-up fashion.

  // @uvm-ieee 1800.2-2017 auto 13.1.4.6
  virtual function void pre_abort;
  endfunction

  //----------------------------------------------------------------------------
  // Group -- NODOCS -- Recording Interface
  //----------------------------------------------------------------------------
  // These methods comprise the component-based transaction recording
  // interface. The methods can be used to record the transactions that
  // this component "sees", i.e. produces or consumes.
  //
  // The API and implementation are subject to change once a vendor-independent
  // use-model is determined.
  //----------------------------------------------------------------------------

  // Function -- NODOCS -- accept_tr
  //
  // This function marks the acceptance of a transaction, ~tr~, by this
  // component. Specifically, it performs the following actions:
  //
  // - Calls the ~tr~'s <uvm_transaction::accept_tr> method, passing to it the
  //   ~accept_time~ argument.
  //
  // - Calls this component's <do_accept_tr> method to allow for any post-begin
  //   action in derived classes.
  //
  // - Triggers the component's internal accept_tr event. Any processes waiting
  //   on this event will resume in the next delta cycle.

  // @uvm-ieee 1800.2-2017 auto 13.1.6.1
  extern function void accept_tr (uvm_transaction tr, time accept_time = 0);


  // Function -- NODOCS -- do_accept_tr
  //
  // The <accept_tr> method calls this function to accommodate any user-defined
  // post-accept action. Implementations should call super.do_accept_tr to
  // ensure correct operation.

  // @uvm-ieee 1800.2-2017 auto 13.1.6.2
  extern virtual protected function void do_accept_tr (uvm_transaction tr);


  // Function -- NODOCS -- begin_tr
  //
  // This function marks the start of a transaction, ~tr~, by this component.
  // Specifically, it performs the following actions:
  //
  // - Calls ~tr~'s <uvm_transaction::begin_tr> method, passing to it the
  //   ~begin_time~ argument. The ~begin_time~ should be greater than or equal
  //   to the accept time. By default, when ~begin_time~ = 0, the current
  //   simulation time is used.
  //
  //   If recording is enabled (recording_detail != UVM_OFF), then a new
  //   database-transaction is started on the component's transaction stream
  //   given by the stream argument. No transaction properties are recorded at
  //   this time.
  //
  // - Calls the component's <do_begin_tr> method to allow for any post-begin
  //   action in derived classes.
  //
  // - Triggers the component's internal begin_tr event. Any processes waiting
  //   on this event will resume in the next delta cycle.
  //
  // A handle to the transaction is returned. The meaning of this handle, as
  // well as the interpretation of the arguments ~stream_name~, ~label~, and
  // ~desc~ are vendor specific.

   // @uvm-ieee 1800.2-2017 auto 13.1.6.3
   extern function int begin_tr (uvm_transaction tr,
                                     string stream_name="main",
                                     string label="",
                                     string desc="",
                                     time begin_time=0,
                                     int parent_handle=0);

`ifdef UVM_ENABLE_DEPRECATED_API
  // Function -- NODOCS -- begin_child_tr
  //
  // This function marks the start of a child transaction, ~tr~, by this
  // component. Its operation is identical to that of <begin_tr>, except that
  // an association is made between this transaction and the provided parent
  // transaction. This association is vendor-specific.
  //
  // This function is deprecated

  extern function int begin_child_tr (uvm_transaction tr,
                                          int parent_handle=0,
                                          string stream_name="main",
                                          string label="",
                                          string desc="",
                                          time begin_time=0);
`endif //UVM_ENABLE_DEPRECATED_API

  // Function -- NODOCS -- do_begin_tr
  //
  // The <begin_tr> and <begin_child_tr> methods call this function to
  // accommodate any user-defined post-begin action. Implementations should call
  // super.do_begin_tr to ensure correct operation.

  extern virtual protected
    // @uvm-ieee 1800.2-2017 auto 13.1.6.4
    function void do_begin_tr (uvm_transaction tr,
                               string stream_name,
                               int tr_handle);


  // Function -- NODOCS -- end_tr
  //
  // This function marks the end of a transaction, ~tr~, by this component.
  // Specifically, it performs the following actions:
  //
  // - Calls ~tr~'s <uvm_transaction::end_tr> method, passing to it the
  //   ~end_time~ argument. The ~end_time~ must at least be greater than the
  //   begin time. By default, when ~end_time~ = 0, the current simulation time
  //   is used.
  //
  //   The transaction's properties are recorded to the database-transaction on
  //   which it was started, and then the transaction is ended. Only those
  //   properties handled by the transaction's do_record method (and optional
  //   `uvm_*_field macros) are recorded.
  //
  // - Calls the component's <do_end_tr> method to accommodate any post-end
  //   action in derived classes.
  //
  // - Triggers the component's internal end_tr event. Any processes waiting on
  //   this event will resume in the next delta cycle.
  //
  // The ~free_handle~ bit indicates that this transaction is no longer needed.
  // The implementation of free_handle is vendor-specific.

  // @uvm-ieee 1800.2-2017 auto 13.1.6.5
  extern function void end_tr (uvm_transaction tr,
                               time end_time=0,
                               bit free_handle=1);


  // Function -- NODOCS -- do_end_tr
  //
  // The <end_tr> method calls this function to accommodate any user-defined
  // post-end action. Implementations should call super.do_end_tr to ensure
  // correct operation.

  // @uvm-ieee 1800.2-2017 auto 13.1.6.6
  extern virtual protected function void do_end_tr (uvm_transaction tr,
                                                    int tr_handle);


  // Function -- NODOCS -- record_error_tr
  //
  // This function marks an error transaction by a component. Properties of the
  // given uvm_object, ~info~, as implemented in its <uvm_object::do_record> method,
  // are recorded to the transaction database.
  //
  // An ~error_time~ of 0 indicates to use the current simulation time. The
  // ~keep_active~ bit determines if the handle should remain active. If 0,
  // then a zero-length error transaction is recorded. A handle to the
  // database-transaction is returned.
  //
  // Interpretation of this handle, as well as the strings ~stream_name~,
  // ~label~, and ~desc~, are vendor-specific.

  // @uvm-ieee 1800.2-2017 auto 13.1.6.7
  extern function int record_error_tr (string stream_name="main",
                                           uvm_object info=null,
                                           string label="error_tr",
                                           string desc="",
                                           time   error_time=0,
                                           bit    keep_active=0);


  // Function -- NODOCS -- record_event_tr
  //
  // This function marks an event transaction by a component.
  //
  // An ~event_time~ of 0 indicates to use the current simulation time.
  //
  // A handle to the transaction is returned. The ~keep_active~ bit determines
  // if the handle may be used for other vendor-specific purposes.
  //
  // The strings for ~stream_name~, ~label~, and ~desc~ are vendor-specific
  // identifiers for the transaction.

  // @uvm-ieee 1800.2-2017 auto 13.1.6.8
  extern function int record_event_tr (string stream_name="main",
                                           uvm_object info=null,
                                           string label="event_tr",
                                           string desc="",
                                           time   event_time=0,
                                           bit    keep_active=0);


  // @uvm-ieee 1800.2-2017 auto 13.1.6.9
  extern virtual function uvm_tr_stream get_tr_stream(string name,
                                                      string stream_type_name="");


  // @uvm-ieee 1800.2-2017 auto 13.1.6.10
  extern virtual function void free_tr_stream(uvm_tr_stream stream);

  // Variable -- NODOCS -- print_enabled
  //
  // This bit determines if this component should automatically be printed as a
  // child of its parent object.
  //
  // By default, all children are printed. However, this bit allows a parent
  // component to disable the printing of specific children.

  bit print_enabled = 1;

  // Variable -- NODOCS -- tr_database
  //
  // Specifies the <uvm_tr_database> object to use for <begin_tr>
  // and other methods in the <Recording Interface>.
  // Default is <uvm_coreservice_t::get_default_tr_database>.
  uvm_tr_database tr_database;

  `ifdef UVM_ENABLE_DEPRECATED_API
  extern virtual function uvm_tr_database m_get_tr_database();
  `endif // UVM_ENABLE_DEPRECATED_API

  // @uvm-ieee 1800.2-2017 auto 13.1.6.12
  extern virtual function uvm_tr_database get_tr_database();

  // @uvm-ieee 1800.2-2017 auto 13.1.6.11
  extern virtual function void set_tr_database(uvm_tr_database db);


  //----------------------------------------------------------------------------
  //                     PRIVATE or PSUEDO-PRIVATE members
  //                      *** Do not call directly ***
  //         Implementation and even existence are subject to change.
  //----------------------------------------------------------------------------
  // Most local methods are prefixed with m_, indicating they are not
  // user-level methods. SystemVerilog does not support friend classes,
  // which forces some otherwise internal methods to be exposed (i.e. not
  // be protected via 'local' keyword). These methods are also prefixed
  // with m_ to indicate they are not intended for public use.
  //
  // Internal methods will not be documented, although their implementa-
  // tions are freely available via the open-source license.
  //----------------------------------------------------------------------------

  protected uvm_domain m_domain;    // set_domain stores our domain handle

  /*protected*/ uvm_phase  m_phase_imps[uvm_phase];    // functors to override ovm_root defaults

  //TND review protected, provide read-only accessor.
  uvm_phase            m_current_phase;            // the most recently executed phase
  protected process    m_phase_process;

  /*protected*/ bit  m_build_done;
  /*protected*/ int  m_phasing_active;

`ifdef UVM_ENABLE_DEPRECATED_API
  extern                   function void set_int_local(string field_name,
                                                       uvm_bitstream_t value,
                                                       bit recurse=1);
`endif // UVM_ENABLE_DEPRECATED_API
  extern                   function void set_local(uvm_resource_base rsrc) ;

  /*protected*/ uvm_component m_parent;
  protected     uvm_component m_children[string];
  protected     uvm_component m_children_by_handle[uvm_component];
  extern protected virtual function bit  m_add_child(uvm_component child);
  extern local     virtual function void m_set_full_name();

  extern                   function void do_resolve_bindings();
  extern                   function void do_flush();

  extern virtual           function void flush ();

  extern local             function void m_extract_name(string name ,
                                                        output string leaf ,
                                                        output string remainder );

  // overridden to disable
  extern virtual function uvm_object create (string name="");
  extern virtual function uvm_object clone  ();

  local uvm_tr_stream m_streams[string][string];
  local uvm_recorder m_tr_h[uvm_transaction];
  extern protected function int m_begin_tr (uvm_transaction tr,
                                                int parent_handle=0,
                                                string stream_name="main", string label="",
                                                string desc="", time begin_time=0);

  string m_name;

  typedef uvm_abstract_component_registry#(uvm_component, "uvm_component") type_id;
  `uvm_type_name_decl("uvm_component")

  protected uvm_event_pool event_pool;

  int unsigned recording_detail = UVM_NONE;
  extern         function void   do_print(uvm_printer printer);

  // Internal methods for setting up command line messaging stuff
  extern function void m_set_cl_msg_args;
  extern function void m_set_cl_verb;
  extern function void m_set_cl_action;
  extern function void m_set_cl_sev;
  extern function void m_apply_verbosity_settings(uvm_phase phase);

  // The verbosity settings may have a specific phase to start at.
  // We will do this work in the phase_started callback.

  typedef struct {
    string comp;
    string phase;
    time   offset;
    uvm_verbosity verbosity;
    string id;
  } m_verbosity_setting;

  m_verbosity_setting m_verbosity_settings[$];
  static m_verbosity_setting m_time_settings[$];

  // does the pre abort callback hierarchically
  extern /*local*/ function void m_do_pre_abort;

  // produce message for unsupported types from apply_config_settings
  uvm_resource_base m_unsupported_resource_base = null;
  extern function void m_unsupported_set_local(uvm_resource_base rsrc);

typedef struct  {
	string arg;
	string args[$];
	int unsigned used;
} uvm_cmdline_parsed_arg_t;

static uvm_cmdline_parsed_arg_t m_uvm_applied_cl_action[$];
static uvm_cmdline_parsed_arg_t m_uvm_applied_cl_sev[$];

endclass : uvm_component

`include "base/uvm_root.svh"

//------------------------------------------------------------------------------
// IMPLEMENTATION
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//
// CLASS- uvm_component
//
//------------------------------------------------------------------------------


// new
// ---

function uvm_component::new (string name="", uvm_component parent=null); endfunction


// m_add_child
// -----------

function bit uvm_component::m_add_child(uvm_component child); endfunction



//------------------------------------------------------------------------------
//
// Hierarchy Methods
// 
//------------------------------------------------------------------------------


// get_children
// ------------

function void uvm_component::get_children(ref uvm_component children[$]); endfunction


// get_first_child
// ---------------

function int uvm_component::get_first_child(ref string name); endfunction


// get_next_child
// --------------

function int uvm_component::get_next_child(ref string name); endfunction


// get_child
// ---------

function uvm_component uvm_component::get_child(string name); endfunction


// has_child
// ---------

function int uvm_component::has_child(string name); endfunction


// get_num_children
// ----------------

function int uvm_component::get_num_children(); endfunction


// get_full_name
// -------------

function string uvm_component::get_full_name (); endfunction


// get_parent
// ----------

function uvm_component uvm_component::get_parent (); endfunction


// set_name
// --------

function void uvm_component::set_name (string name); endfunction


// m_set_full_name
// ---------------

function void uvm_component::m_set_full_name(); endfunction


// lookup
// ------

function uvm_component uvm_component::lookup( string name ); endfunction


// get_depth
// ---------

function int unsigned uvm_component::get_depth(); endfunction


// m_extract_name
// --------------

function void uvm_component::m_extract_name(input string name ,
                                            output string leaf ,
                                            output string remainder ); endfunction
  

// flush
// -----

function void uvm_component::flush(); endfunction


// do_flush  (flush_hier?)
// --------

function void uvm_component::do_flush(); endfunction
  


//------------------------------------------------------------------------------
//
// Factory Methods
// 
//------------------------------------------------------------------------------


// create
// ------

function uvm_object  uvm_component::create (string name =""); endfunction


// clone
// ------

function uvm_object  uvm_component::clone (); endfunction


// print_override_info
// -------------------

function void  uvm_component::print_override_info (string requested_type_name, 
                                                   string name=""); endfunction


// create_component
// ----------------

function uvm_component uvm_component::create_component (string requested_type_name,
                                                        string name); endfunction


// create_object
// -------------

function uvm_object uvm_component::create_object (string requested_type_name,
                                                  string name=""); endfunction


// set_type_override (static)
// -----------------

function void uvm_component::set_type_override (string original_type_name,
                                                string override_type_name,
                                                bit    replace=1); endfunction 


// set_type_override_by_type (static)
// -------------------------

function void uvm_component::set_type_override_by_type (uvm_object_wrapper original_type,
                                                        uvm_object_wrapper override_type,
                                                        bit    replace=1); endfunction 


// set_inst_override
// -----------------

function void  uvm_component::set_inst_override (string relative_inst_path,  
                                                 string original_type_name,
                                                 string override_type_name); endfunction 


// set_inst_override_by_type
// -------------------------

function void uvm_component::set_inst_override_by_type (string relative_inst_path,  
                                                        uvm_object_wrapper original_type,
                                                        uvm_object_wrapper override_type); endfunction



//------------------------------------------------------------------------------
//
// Hierarchical report configuration interface
//
//------------------------------------------------------------------------------

// set_report_id_verbosity_hier
// -------------------------

function void uvm_component::set_report_id_verbosity_hier( string id, int verbosity); endfunction


// set_report_severity_id_verbosity_hier
// ----------------------------------

function void uvm_component::set_report_severity_id_verbosity_hier( uvm_severity severity,
                                                                 string id,
                                                                 int verbosity); endfunction


// set_report_severity_action_hier
// -------------------------

function void uvm_component::set_report_severity_action_hier( uvm_severity severity, 
                                                           uvm_action action); endfunction


// set_report_id_action_hier
// -------------------------

function void uvm_component::set_report_id_action_hier( string id, uvm_action action); endfunction


// set_report_severity_id_action_hier
// ----------------------------------

function void uvm_component::set_report_severity_id_action_hier( uvm_severity severity,
                                                                 string id,
                                                                 uvm_action action); endfunction


// set_report_severity_file_hier
// -----------------------------

function void uvm_component::set_report_severity_file_hier( uvm_severity severity,
                                                            UVM_FILE file); endfunction


// set_report_default_file_hier
// ----------------------------

function void uvm_component::set_report_default_file_hier( UVM_FILE file); endfunction


// set_report_id_file_hier
// -----------------------
  
function void uvm_component::set_report_id_file_hier( string id, UVM_FILE file); endfunction


// set_report_severity_id_file_hier
// --------------------------------

function void uvm_component::set_report_severity_id_file_hier ( uvm_severity severity,
                                                                string id,
                                                                UVM_FILE file); endfunction


// set_report_verbosity_level_hier
// -------------------------------

function void uvm_component::set_report_verbosity_level_hier(int verbosity); endfunction  



//------------------------------------------------------------------------------
//
// Phase interface 
//
//------------------------------------------------------------------------------


// phase methods
//--------------
// these are prototypes for the methods to be implemented in user components
// build_phase() has a default implementation, the others have an empty default

`ifdef UVM_ENABLE_DEPRECATED_API
  `define M_UVM_OVM_PHASE_WARN_AND_CALL(NAME) \
    begin \
      static bit warned; \
      if (!warned) \
        `uvm_warning("UVM/DEPRECATED/COMP/OVM_PHASES", {"The library is calling the deprecated uvm_component::", `"NAME`", " method because UVM_ENABLE_DEPRECATED_API is defined.  Usage of this deprecated method by the user may lead to unexpected behavior.  Users should use uvm_component::", `"NAME`", "_phase()."}) \
      warned = 1; \
      NAME(); \
    end
`endif // UVM_ENABLE_DEPRECATED_API

function void uvm_component::build_phase(uvm_phase phase); endfunction

`ifdef UVM_ENABLE_DEPRECATED_API
// Backward compatibility build function

function void uvm_component::build(); endfunction // build
`endif // UVM_ENABLE_DEPRECATED_API

// these phase methods are common to all components in UVM. For backward
// compatibility, they call the old style name (without the _phse)

function void uvm_component::connect_phase(uvm_phase phase); endfunction

function void uvm_component::start_of_simulation_phase(uvm_phase phase); endfunction

function void uvm_component::end_of_elaboration_phase(uvm_phase phase);
`ifdef UVM_ENABLE_DEPRECATED_API
  `M_UVM_OVM_PHASE_WARN_AND_CALL(end_of_elaboration)
`endif // UVM_ENABLE_DEPRECATED_API
  return; 
endfunction

task uvm_component::run_phase(uvm_phase phase); endtask

function void uvm_component::extract_phase(uvm_phase phase); endfunction

function void uvm_component::check_phase(uvm_phase phase); endfunction

function void uvm_component::report_phase(uvm_phase phase); endfunction

`ifdef UVM_ENABLE_DEPRECATED_API
  `undef M_UVM_OVM_PHASE_WARN_AND_CALL
`endif

function void uvm_component::final_phase(uvm_phase phase); endfunction

`ifdef UVM_ENABLE_DEPRECATED_API
// These are the old style phase names. In order for runtime phase names
// to not conflict with user names, the _phase postfix was added.

function void uvm_component::connect(); endfunction
function void uvm_component::start_of_simulation(); endfunction
function void uvm_component::end_of_elaboration();  return; endfunction
task uvm_component::run(); endtask
function void uvm_component::extract(); endfunction
function void uvm_component::check(); endfunction
function void uvm_component::report(); endfunction
`endif // UVM_ENABLE_DEPRECATED_API

// these runtime phase methods are only called if a set_domain() is done

task uvm_component::pre_reset_phase(uvm_phase phase); endtask
task uvm_component::reset_phase(uvm_phase phase); endtask
task uvm_component::post_reset_phase(uvm_phase phase); endtask
task uvm_component::pre_configure_phase(uvm_phase phase); endtask
task uvm_component::configure_phase(uvm_phase phase); endtask
task uvm_component::post_configure_phase(uvm_phase phase); endtask
task uvm_component::pre_main_phase(uvm_phase phase); endtask
task uvm_component::main_phase(uvm_phase phase); endtask
task uvm_component::post_main_phase(uvm_phase phase); endtask
task uvm_component::pre_shutdown_phase(uvm_phase phase); endtask
task uvm_component::shutdown_phase(uvm_phase phase); endtask
task uvm_component::post_shutdown_phase(uvm_phase phase); endtask


//------------------------------
// current phase convenience API
//------------------------------


// phase_started
// -------------
// phase_started() and phase_ended() are extra callbacks called at the
// beginning and end of each phase, respectively.  Since they are
// called for all phases the phase is passed in as an argument so the
// extender can decide what to do, if anything, for each phase.

function void uvm_component::phase_started(uvm_phase phase);
endfunction

// phase_ended
// -----------

function void uvm_component::phase_ended(uvm_phase phase);
endfunction


// phase_ready_to_end
// ------------------

function void uvm_component::phase_ready_to_end (uvm_phase phase);
endfunction

//------------------------------
// phase / schedule / domain API
//------------------------------
// methods for VIP creators and integrators to use to set up schedule domains
// - a schedule is a named, organized group of phases for a component base type
// - a domain is a named instance of a schedule in the master phasing schedule


// define_domain
// -------------

function void uvm_component::define_domain(uvm_domain domain); endfunction


// set_domain
// ----------
// assigns this component [tree] to a domain. adds required schedules into graph
// If called from build, ~hier~ won't recurse into all chilren (which don't exist yet)
// If we have components inherit their parent's domain by default, then ~hier~
// isn't needed and we need a way to prevent children from inheriting this component's domain

function void uvm_component::set_domain(uvm_domain domain, int hier=1); endfunction

// get_domain
// ----------
//
function uvm_domain uvm_component::get_domain(); endfunction

`ifdef UVM_ENABLE_DEPRECATED_API
// set_phase_imp
// -------------

function void uvm_component::set_phase_imp(uvm_phase phase, uvm_phase imp, int hier=1); endfunction
`endif

//--------------------------
// phase runtime control API
//--------------------------

// suspend
// -------

task uvm_component::suspend(); endtask


// resume
// ------

task uvm_component::resume(); endtask


// resolve_bindings
// ----------------

function void uvm_component::resolve_bindings(); endfunction


// do_resolve_bindings
// -------------------

function void uvm_component::do_resolve_bindings(); endfunction



//------------------------------------------------------------------------------
//
// Recording interface
//
//------------------------------------------------------------------------------

// accept_tr
// ---------

function void uvm_component::accept_tr (uvm_transaction tr,
                                        time accept_time=0); endfunction

// begin_tr
// --------

function int uvm_component::begin_tr (uvm_transaction tr,
                                          string stream_name="main",
                                          string label="",
                                          string desc="",
                                          time begin_time=0,
                                          int parent_handle=0); endfunction

`ifdef UVM_ENABLE_DEPRECATED_API
// begin_child_tr
// --------------

function int uvm_component::begin_child_tr (uvm_transaction tr,
                                                int parent_handle=0,
                                                string stream_name="main",
                                                string label="",
                                                string desc="",
                                                time begin_time=0);
  static bit have_been_warned;
  if(!have_been_warned) begin
    uvm_report_warning("UVM/DEPRECATED/COMP/BCT", "The deprecated uvm_component::begin_child_tr method has been called.  Attempting to compile without UVM_ENABLE_DEPRECATED_API defined will fail. Use begin_tr instead");
    have_been_warned = 1;
  end
                                                
  return m_begin_tr(tr, parent_handle, stream_name, label, desc, begin_time);
endfunction
`endif // UVM_ENABLE_DEPRECATED_API

`ifdef UVM_ENABLE_DEPRECATED_API     
// m_get_tr_database
// ---------------------
   function uvm_tr_database uvm_component::m_get_tr_database(); endfunction : m_get_tr_database
`endif // UVM_ENABLE_DEPRECATED_API  

// get_tr_database
// ---------------------
   function uvm_tr_database uvm_component::get_tr_database(); endfunction : get_tr_database

// set_tr_database
// ---------------------
   function void uvm_component::set_tr_database(uvm_tr_database db); endfunction : set_tr_database
 
   
// get_tr_stream
// ------------
function uvm_tr_stream uvm_component::get_tr_stream( string name,
                                                      string stream_type_name="" ); endfunction : get_tr_stream

// free_tr_stream
// --------------
function void uvm_component::free_tr_stream(uvm_tr_stream stream); endfunction : free_tr_stream
   
// m_begin_tr
// ----------

function int uvm_component::m_begin_tr (uvm_transaction tr,
                                            int parent_handle=0,
                                            string stream_name="main",
                                            string label="",
                                            string desc="",
                                            time begin_time=0);
endfunction


// end_tr
// ------

function void uvm_component::end_tr (uvm_transaction tr,
                                     time end_time=0,
                                     bit free_handle=1);
endfunction


// record_error_tr
// ---------------

function int uvm_component::record_error_tr (string stream_name="main",
                                                 uvm_object info=null,
                                                 string label="error_tr",
                                                 string desc="",
                                                 time   error_time=0,
                                                 bit    keep_active=0); endfunction


// record_event_tr
// ---------------

function int uvm_component::record_event_tr (string stream_name="main",
                                                 uvm_object info=null,
                                                 string label="event_tr",
                                                 string desc="",
                                                 time   event_time=0,
                                                 bit    keep_active=0); endfunction

// do_accept_tr
// ------------

function void uvm_component::do_accept_tr (uvm_transaction tr); endfunction


// do_begin_tr
// -----------

function void uvm_component::do_begin_tr (uvm_transaction tr,
                                          string stream_name,
                                          int tr_handle); endfunction


// do_end_tr
// ---------

function void uvm_component::do_end_tr (uvm_transaction tr,
                                        int tr_handle); endfunction


//------------------------------------------------------------------------------
//
// Configuration interface
//
//------------------------------------------------------------------------------


function string uvm_component::massage_scope(string scope); endfunction


`ifdef UVM_ENABLE_DEPRECATED_API
// check_config_usage
// ------------------

function void uvm_component::check_config_usage ( bit recurse=1 ); endfunction
`endif // UVM_ENABLE_DEPRECATED_API

// use_automatic_config
// --------------------
function bit uvm_component::use_automatic_config(); endfunction      
   
// apply_config_settings
// ---------------------

function void uvm_component::apply_config_settings (bit verbose=0); endfunction


// print_config
// ------------

function void uvm_component::print_config(bit recurse = 0, audit = 0); endfunction

`ifdef UVM_ENABLE_DEPRECATED_API
// print_config_settings
// ---------------------

function void uvm_component::print_config_settings (string field="",
                                                    uvm_component comp=null,
                                                    bit recurse=0); endfunction
`endif // UVM_ENABLE_DEPRECATED_API

// print_config_with_audit
// -----------------------

function void uvm_component::print_config_with_audit(bit recurse = 0); endfunction


// do_print (override)
// --------

function void uvm_component::do_print(uvm_printer printer); endfunction


`ifdef UVM_ENABLE_DEPRECATED_API
// set_int_local (override)
// -------------

function void uvm_component::set_int_local (string field_name,
                             uvm_bitstream_t value,
                             bit recurse=1); endfunction

`endif // UVM_ENABLE_DEPRECATED_API


// set_local (override)
// ---------

function void uvm_component::set_local(uvm_resource_base rsrc) ; endfunction


// m_unsupported_set_local (override)
// ----------------------

function void uvm_component::m_unsupported_set_local(uvm_resource_base rsrc); endfunction


// Internal methods for setting messagin parameters from command line switches

typedef class uvm_cmdline_processor;


// m_set_cl_msg_args
// -----------------

function void uvm_component::m_set_cl_msg_args; endfunction


// m_set_cl_verb
// -------------
function void uvm_component::m_set_cl_verb; endfunction

// m_set_cl_action
// ---------------

function void uvm_component::m_set_cl_action; endfunction


// m_set_cl_sev
// ------------

function void uvm_component::m_set_cl_sev; endfunction


// m_apply_verbosity_settings
// --------------------------

function void uvm_component::m_apply_verbosity_settings(uvm_phase phase); endfunction


// m_do_pre_abort
// --------------

function void uvm_component::m_do_pre_abort; endfunction
