//-----------------------------------------------------------------------------
// Copyright 2007-2018 Cadence Design Systems, Inc.
// Copyright 2007-2014 Mentor Graphics Corporation
// Copyright 2013-2018 NVIDIA Corporation
// Copyright 2017-2018 Cisco Systems, Inc.
// Copyright 2018 Qualcomm, Inc.
// Copyright 2014 Intel Corporation
// Copyright 2013-2018 Synopsys, Inc.
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

//------------------------------------------------------------------------------
//
// CLASS -- NODOCS -- uvm_comparer
//
// The uvm_comparer class provides a policy object for doing comparisons. The
// policies determine how miscompares are treated and counted. Results of a
// comparison are stored in the comparer object. The <uvm_object::compare>
// and <uvm_object::do_compare> methods are passed a uvm_comparer policy
// object.
//
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto 16.3.1
class uvm_comparer extends uvm_policy;

endclass
