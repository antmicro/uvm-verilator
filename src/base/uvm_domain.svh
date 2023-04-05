//
//----------------------------------------------------------------------
// Copyright 2007-2018 Mentor Graphics Corporation
// Copyright 2007-2018 Cadence Design Systems, Inc.
// Copyright 2011 AMD
// Copyright 2015-2018 NVIDIA Corporation
// Copyright 2012 Accellera Systems Initiative
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

typedef class uvm_build_phase;
typedef class uvm_connect_phase;
typedef class uvm_end_of_elaboration_phase;
typedef class uvm_start_of_simulation_phase;
typedef class uvm_run_phase;
typedef class uvm_extract_phase;
typedef class uvm_check_phase;
typedef class uvm_report_phase;
typedef class uvm_final_phase;

typedef class uvm_pre_reset_phase;
typedef class uvm_reset_phase;
typedef class uvm_post_reset_phase;
typedef class uvm_pre_configure_phase;
typedef class uvm_configure_phase;
typedef class uvm_post_configure_phase;
typedef class uvm_pre_main_phase;
typedef class uvm_main_phase;
typedef class uvm_post_main_phase;
typedef class uvm_pre_shutdown_phase;
typedef class uvm_shutdown_phase;
typedef class uvm_post_shutdown_phase;

uvm_phase build_ph;
uvm_phase connect_ph;
uvm_phase end_of_elaboration_ph;
uvm_phase start_of_simulation_ph;
uvm_phase run_ph;
uvm_phase extract_ph;
uvm_phase check_ph;
uvm_phase report_ph;
   
//------------------------------------------------------------------------------
//
// Class -- NODOCS -- uvm_domain
//
//------------------------------------------------------------------------------
//
// Phasing schedule node representing an independent branch of the schedule.
// Handle used to assign domains to components or hierarchies in the testbench
//

// @uvm-ieee 1800.2-2017 auto 9.4.1
class uvm_domain extends uvm_phase;

  static local uvm_domain m_uvm_domain; // run-time phases
  static local uvm_domain m_domains[string];
  static local uvm_phase m_uvm_schedule;



  // @uvm-ieee 1800.2-2017 auto 9.4.2.2
  static function void get_domains(output uvm_domain domains[string]); endfunction 


  // Function -- NODOCS -- get_uvm_schedule
  //
  // Get the "UVM" schedule, which consists of the run-time phases that
  // all components execute when participating in the "UVM" domain.
  //
  static function uvm_phase get_uvm_schedule(); endfunction 


  // Function -- NODOCS -- get_common_domain
  //
  // Get the "common" domain, which consists of the common phases that
  // all components execute in sync with each other. Phases in the "common"
  // domain are build, connect, end_of_elaboration, start_of_simulation, run,
  // extract, check, report, and final.
  //
  static function uvm_domain get_common_domain();
  endfunction



  // @uvm-ieee 1800.2-2017 auto 9.4.2.3
  static function void add_uvm_phases(uvm_phase schedule); endfunction


  // Function -- NODOCS -- get_uvm_domain
  //
  // Get a handle to the singleton ~uvm~ domain
  //
  static function uvm_domain get_uvm_domain(); endfunction



  // @uvm-ieee 1800.2-2017 auto 9.4.2.1
  function new(string name=""); endfunction


  // @uvm-ieee 1800.2-2017 auto 9.4.2.4
  function void jump(uvm_phase phase); endfunction

// jump_all
// --------
  static function void jump_all(uvm_phase phase); endfunction
endclass
