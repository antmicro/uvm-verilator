//
//------------------------------------------------------------------------------
// Copyright 2007-2011 Mentor Graphics Corporation
// Copyright 2014 Semifore
// Copyright 2010-2018 Synopsys, Inc.
// Copyright 2007-2018 Cadence Design Systems, Inc.
// Copyright 2010-2012 AMD
// Copyright 2012-2018 NVIDIA Corporation
// Copyright 2012-2018 Cisco Systems, Inc.
// Copyright 2012 Accellera Systems Initiative
// Copyright 2017 Verific
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


//------------------------------------------------------------------------------
//
// CLASS -- NODOCS -- uvm_root
//
// The ~uvm_root~ class serves as the implicit top-level and phase controller for
// all UVM components. Users do not directly instantiate ~uvm_root~. The UVM
// automatically creates a single instance of <uvm_root> that users can
// access via the global (uvm_pkg-scope) variable, ~uvm_top~.
//
// (see uvm_ref_root.gif)
//
// The ~uvm_top~ instance of ~uvm_root~ plays several key roles in the UVM.
//
// Implicit top-level - The ~uvm_top~ serves as an implicit top-level component.
// Any component whose parent is specified as ~null~ becomes a child of ~uvm_top~.
// Thus, all UVM components in simulation are descendants of ~uvm_top~.
//
// Phase control - ~uvm_top~ manages the phasing for all components.
//
// Search - Use ~uvm_top~ to search for components based on their
// hierarchical name. See <find> and <find_all>.
//
// Report configuration - Use ~uvm_top~ to globally configure
// report verbosity, log files, and actions. For example,
// ~uvm_top.set_report_verbosity_level_hier(UVM_FULL)~ would set
// full verbosity for all components in simulation.
//
// Global reporter - Because ~uvm_top~ is globally accessible (in uvm_pkg
// scope), UVM's reporting mechanism is accessible from anywhere
// outside ~uvm_component~, such as in modules and sequences.
// See <uvm_report_error>, <uvm_report_warning>, and other global
// methods.
//
//
// The ~uvm_top~ instance checks during the end_of_elaboration phase if any errors have
// been generated so far. If errors are found a UVM_FATAL error is being generated as result
// so that the simulation will not continue to the start_of_simulation_phase.
//

//------------------------------------------------------------------------------

typedef class uvm_cmdline_processor;
typedef class uvm_component_proxy;
typedef class uvm_top_down_visitor_adapter;
typedef class uvm_report_message;
typedef class uvm_report_object;
typedef class uvm_report_handler;
typedef class uvm_default_report_server;
  
// Class: uvm_root
// 
//| class uvm_root extends uvm_component
//
// Implementation of the uvm_root class, as defined
// in 1800.2-2017 Section F.7

//@uvm-ieee 1800.2-2017 manual F.7
class uvm_root extends uvm_component;

	// Function -- NODOCS -- get()
	// Static accessor for <uvm_root>.
	//
	// The static accessor is provided as a convenience wrapper
	// around retrieving the root via the <uvm_coreservice_t::get_root>
	// method.
	//
	// | // Using the uvm_coreservice_t:
	// | uvm_coreservice_t cs;
	// | uvm_root r;
	// | cs = uvm_coreservice_t::get();
	// | r = cs.get_root();
	// |
	// | // Not using the uvm_coreservice_t:
	// | uvm_root r;
	// | r = uvm_root::get();
	//

	extern static function uvm_root get();

	uvm_cmdline_processor clp;

	virtual function string get_type_name(); endfunction


	//----------------------------------------------------------------------------
	// Group -- NODOCS -- Simulation Control
	//----------------------------------------------------------------------------


	// Task -- NODOCS -- run_test
	//
	// Phases all components through all registered phases. If the optional
	// test_name argument is provided, or if a command-line plusarg,
	// +UVM_TESTNAME=TEST_NAME, is found, then the specified component is created
	// just prior to phasing. The test may contain new verification components or
	// the entire testbench, in which case the test and testbench can be chosen from
	// the command line without forcing recompilation. If the global (package)
	// variable, finish_on_completion, is set, then $finish is called after
	// phasing completes.

	extern virtual task run_test (string test_name="");


	// Function -- NODOCS -- die
	//
	// This method is called by the report server if a report reaches the maximum
	// quit count or has a UVM_EXIT action associated with it, e.g., as with
	// fatal errors.
	//
	// Calls the <uvm_component::pre_abort()> method
	// on the entire <uvm_component> hierarchy in a bottom-up fashion.
	// It then calls <uvm_report_server::report_summarize> and terminates the simulation
	// with ~$finish~.

	virtual function void die(); endfunction


	// Function -- NODOCS -- set_timeout
	//
	// Specifies the timeout for the simulation. Default is <`UVM_DEFAULT_TIMEOUT>
	//
	// The timeout is simply the maximum absolute simulation time allowed before a
	// ~FATAL~ occurs.  If the timeout is set to 20ns, then the simulation must end
	// before 20ns, or a ~FATAL~ timeout will occur.
	//
	// This is provided so that the user can prevent the simulation from potentially
	// consuming too many resources (Disk, Memory, CPU, etc) when the testbench is
	// essentially hung.
	//
	//

	extern function void set_timeout(time timeout, bit overridable=1);

	// Variable -- NODOCS -- finish_on_completion
	//
	// If set, then run_test will call $finish after all phases are executed.

`ifdef UVM_ENABLE_DEPRECATED_API
  bit finish_on_completion = 1;
`else

`endif

  // Function -- NODOCS -- get_finish_on_completion
  
  virtual  function bit get_finish_on_completion(); endfunction : get_finish_on_completion

  // Function -- NODOCS -- set_finish_on_completion

  virtual  function void set_finish_on_completion(bit f); endfunction : set_finish_on_completion
   
//----------------------------------------------------------------------------
// Group -- NODOCS -- Topology
//----------------------------------------------------------------------------

`ifdef UVM_ENABLE_DEPRECATED_API
	// Variable -- NODOCS -- top_levels
	//
	// This variable is a list of all of the top level components in UVM. It
	// includes the uvm_test_top component that is created by <run_test> as
	// well as any other top level components that have been instantiated
	// anywhere in the hierarchy.

	uvm_component top_levels[$];
`endif // UVM_ENABLE_DEPRECATED_API

	// Function -- NODOCS -- find

	extern function uvm_component find (string comp_match);

	// Function -- NODOCS -- find_all
	//
	// Returns the component handle (find) or list of components handles
	// (find_all) matching a given string. The string may contain the wildcards,
	// * and ?. Strings beginning with '.' are absolute path names. If the optional
	// argument comp is provided, then search begins from that component down
	// (default=all components).

	extern function void find_all (string comp_match,
		ref uvm_component comps[$],
		input uvm_component comp=null);


	// Function -- NODOCS -- print_topology
	//
	// Print the verification environment's component topology. The
	// ~printer~ is a <uvm_printer> object that controls the format
	// of the topology printout; a ~null~ printer prints with the
	// default output.

	extern function void print_topology  (uvm_printer printer=null);


	// Variable -- NODOCS -- enable_print_topology
	//
	// If set, then the entire testbench topology is printed just after completion
	// of the end_of_elaboration phase.

	bit  enable_print_topology = 0;

    
	// Function: set_enable_print_topology
	//
	//| function void set_enable_print_topology (bit enable)
	//
	// Sets the variable to enable printing the entire testbench topology just after completion
	// of the end_of_elaboration phase.
        //
        // @uvm-accellera The details of this API are specific to the Accellera implementation, and are not being considered for contribution to 1800.2

	extern function void set_enable_print_topology  (bit enable);
		
	// Function: get_enable_print_topology
	//
	//| function bit get_enable_print_topology()
	//
	// Gets the variable to enable printing the entire testbench topology just after completion.
        //
        // @uvm-accellera The details of this API are specific to the Accellera implementation, and are not being considered for contribution to 1800.2

	extern function bit get_enable_print_topology  ();


	// Variable- phase_timeout
	//
	// Specifies the timeout for the run phase. Default is `UVM_DEFAULT_TIMEOUT


	time phase_timeout = `UVM_DEFAULT_TIMEOUT;


	// PRIVATE members
	extern function void m_find_all_recurse(string comp_match,
		ref uvm_component comps[$],
		input uvm_component comp=null);

	extern protected function new ();
	extern protected virtual function bit m_add_child (uvm_component child);
	extern function void build_phase(uvm_phase phase);
	extern local function void m_do_verbosity_settings();
	extern local function void m_do_timeout_settings();
	extern local function void m_do_factory_settings();
	extern local function void m_process_inst_override(string ovr);
	extern local function void m_process_type_override(string ovr);
	extern local function void m_do_config_settings();
	extern local function void m_do_max_quit_settings();
	extern local function void m_do_dump_args();
	extern local function void m_process_config(string cfg, bit is_int);
	extern local function void m_process_default_sequence(string cfg);
	extern function void m_check_verbosity();
	extern function void m_check_uvm_field_flag_size();
	extern virtual function void report_header(UVM_FILE file = 0);
	// singleton handle
	static local uvm_root m_inst;

	// For error checking
	extern virtual task run_phase (uvm_phase phase);


	// phase_started
	// -------------
	// At end of elab phase we need to do tlm binding resolution.
	function void phase_started(uvm_phase phase);
	endfunction

	bit m_phase_all_done;

        extern static function uvm_root m_uvm_get_root();
          

	static local bit m_relnotes_done=0;

	function void end_of_elaboration_phase(uvm_phase phase);
	endfunction

endclass

`ifdef UVM_ENABLE_DEPRECATED_API
   uvm_root uvm_top ; //Note this is no longer const as we assign it in uvm_root::new() to avoid static init races
`endif


//-----------------------------------------------------------------------------
// IMPLEMENTATION
//-----------------------------------------------------------------------------

// get
// ---

function uvm_root uvm_root::get(); endfunction

// new
// ---

function uvm_root::new(); endfunction

// m_uvm_get_root
// internal function not to be used
// get the initialized singleton instance of uvm_root
function uvm_root uvm_root::m_uvm_get_root(); endfunction

  
function void uvm_root::report_header(UVM_FILE file = 0); endfunction



// run_test
// --------

task uvm_root::run_test(string test_name=""); endtask


// find_all
// --------

function void uvm_root::find_all(string comp_match, ref uvm_component comps[$],
		input uvm_component comp=null); endfunction


// find
// ----

function uvm_component uvm_root::find (string comp_match); endfunction


// print_topology
// --------------

function void uvm_root::print_topology(uvm_printer printer=null); endfunction


// set_timeout
// -----------

function void uvm_root::set_timeout(time timeout, bit overridable=1); endfunction



// m_find_all_recurse
// ------------------

function void uvm_root::m_find_all_recurse(string comp_match, ref uvm_component comps[$],
		input uvm_component comp=null); endfunction


// m_add_child
// -----------

// Add to the top levels array
function bit uvm_root::m_add_child (uvm_component child); endfunction


// build_phase
// -----

function void uvm_root::build_phase(uvm_phase phase); endfunction


// m_do_verbosity_settings
// -----------------------

function void uvm_root::m_do_verbosity_settings(); endfunction


// m_do_timeout_settings
// ---------------------

function void uvm_root::m_do_timeout_settings(); endfunction


// m_do_factory_settings
// ---------------------

function void uvm_root::m_do_factory_settings(); endfunction


// m_process_inst_override
// -----------------------

function void uvm_root::m_process_inst_override(string ovr); endfunction


// m_process_type_override
// -----------------------

function void uvm_root::m_process_type_override(string ovr); endfunction


// m_process_config
// ----------------

function void uvm_root::m_process_config(string cfg, bit is_int); endfunction

// m_process_default_sequence
// ----------------

function void uvm_root::m_process_default_sequence(string cfg); endfunction : m_process_default_sequence


// m_do_config_settings
// --------------------

function void uvm_root::m_do_config_settings(); endfunction


// m_do_max_quit_settings
// ----------------------

function void uvm_root::m_do_max_quit_settings(); endfunction


// m_do_dump_args
// --------------

function void uvm_root::m_do_dump_args(); endfunction


// m_check_verbosity
// ----------------

function void uvm_root::m_check_verbosity(); endfunction

function void uvm_root::m_check_uvm_field_flag_size(); endfunction

// It is required that the run phase start at simulation time 0
// TBD this looks wrong - taking advantage of uvm_root not doing anything else?
// TBD move to phase_started callback?
task uvm_root::run_phase (uvm_phase phase); endtask


// Debug accessor methods to access enable_print_topology
function void uvm_root::set_enable_print_topology  (bit enable); endfunction

// Debug accessor methods to access enable_print_topology
function bit uvm_root::get_enable_print_topology(); endfunction
