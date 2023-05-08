//----------------------------------------------------------------------
// Copyright 2014-2018 Mentor Graphics Corporation
// Copyright 2015 Analog Devices, Inc.
// Copyright 2014 Semifore
// Copyright 2018 Intel Corporation
// Copyright 2018 Synopsys, Inc.
// Copyright 2010-2018 Cadence Design Systems, Inc.
// Copyright 2013-2018 NVIDIA Corporation
// Copyright 2014-2017 Cisco Systems, Inc.
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
//----------------------------------------------------------------------
typedef class uvm_factory;
typedef class uvm_default_factory;
typedef class uvm_root;
typedef class uvm_visitor;
typedef class uvm_component_name_check_visitor;
typedef class uvm_component;
typedef class uvm_comparer;
typedef class uvm_copier;
typedef class uvm_packer;
typedef class uvm_printer;
typedef class uvm_table_printer;

typedef class uvm_tr_database;
typedef class uvm_text_tr_database;
typedef class uvm_resource_pool;
`ifdef UVM_ENABLE_DEPRECATED_API
typedef class uvm_object;
`endif


typedef class uvm_default_coreservice_t;

// Title: Core Service

  
// 
// Class: uvm_coreservice_t
//
// The library implements the following public API in addition to what
// is documented in IEEE 1800.2.
//

// @uvm-ieee 1800.2-2017 auto F.4.1.1
virtual class uvm_coreservice_t;
endclass

// Class: uvm_default_coreservice_t
// Implementation of the uvm_default_coreservice_t as defined in
// section F.4.2.1 of 1800.2-2017.
//
//| class uvm_default_coreservice_t extends uvm_coreservice_t
//
 
// @uvm-ieee 1800.2-2017 auto F.4.2.1
class uvm_default_coreservice_t extends uvm_coreservice_t;
endclass
