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
virtual class uvm_component;
endclass : uvm_component


