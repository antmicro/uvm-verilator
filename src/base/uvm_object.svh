//
//-----------------------------------------------------------------------------
// Copyright 2007-2014 Mentor Graphics Corporation
// Copyright 2014 Semifore
// Copyright 2010-2018 Synopsys, Inc.
// Copyright 2007-2018 Cadence Design Systems, Inc.
// Copyright 2010-2012 AMD
// Copyright 2013-2018 NVIDIA Corporation
// Copyright 2017-2018 Cisco Systems, Inc.
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
//-----------------------------------------------------------------------------



typedef class uvm_object_wrapper;
typedef class uvm_objection;
typedef class uvm_component;
typedef class uvm_resource_base;
typedef class uvm_resource;
typedef class uvm_field_op;

//------------------------------------------------------------------------------
//
// CLASS -- NODOCS -- uvm_object
//
// The uvm_object class is the base class for all UVM data and hierarchical 
// classes. Its primary role is to define a set of methods for such common
// operations as <create>, <copy>, <compare>, <print>, and <record>. Classes
// deriving from uvm_object must implement the pure virtual methods such as 
// <create> and <get_type_name>.
//
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto 5.3.1
virtual class uvm_object extends uvm_void;


  // Function -- NODOCS -- new
endclass
