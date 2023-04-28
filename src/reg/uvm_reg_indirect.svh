//
// -------------------------------------------------------------
// Copyright 2010-2011 Mentor Graphics Corporation
// Copyright 2010-2012 Synopsys, Inc.
// Copyright 2010-2018 Cadence Design Systems, Inc.
// Copyright 2010 AMD
// Copyright 2015-2018 NVIDIA Corporation
//    All Rights Reserved Worldwide
//
//    Licensed under the Apache License, Version 2.0 (the
//    "License"); you may not use this file except in
//    compliance with the License.  You may obtain a copy of
//    the License at
//
//        http://www.apache.org/licenses/LICENSE-2.0
//
//    Unless required by applicable law or agreed to in
//    writing, software distributed under the License is
//    distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR
//    CONDITIONS OF ANY KIND, either express or implied.  See
//    the License for the specific language governing
//    permissions and limitations under the License.
// -------------------------------------------------------------
//

typedef class uvm_reg_indirect_ftdr_seq;

//-----------------------------------------------------------------
// CLASS -- NODOCS -- uvm_reg_indirect_data
// Indirect data access abstraction class
//
// Models the behavior of a register used to indirectly access
// a register array, indexed by a second ~address~ register.
//
// This class should not be instantiated directly.
// A type-specific class extension should be used to
// provide a factory-enabled constructor and specify the
// ~n_bits~ and coverage models.
//-----------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto 18.7.1
class uvm_reg_indirect_data extends uvm_reg;

   protected uvm_reg m_idx;
   protected uvm_reg m_tbl[];


   // @uvm-ieee 1800.2-2017 auto 18.7.2.1
   function new(string name = "uvm_reg_indirect",
                int unsigned n_bits,
                int has_cover); endfunction: new

   virtual function void build();
   endfunction: build


   
   /*local*/ virtual function void add_map(uvm_reg_map map); endfunction
   
   
function void add_frontdoors(uvm_reg_map map); endfunction
   
   virtual function void do_predict (uvm_reg_item      rw,
                                     uvm_predict_e     kind = UVM_PREDICT_DIRECT,
                                     uvm_reg_byte_en_t be = -1); endfunction virtual function uvm_reg_map get_local_map(uvm_reg_map map); endfunction

   //
   // Just for good measure, to catch and short-circuit non-sensical uses
   //
   virtual function void add_field  (uvm_reg_field field); endfunction virtual function void set (uvm_reg_data_t  value,
                              string          fname = "",
                              int             lineno = 0); endfunction
   
   virtual function uvm_reg_data_t  get(string  fname = "",
                                        int     lineno = 0); endfunction
   
   virtual function uvm_reg get_indirect_reg(string  fname = "",
                                        int     lineno = 0); endfunction virtual function bit needs_update(); endfunction

   virtual task write(output uvm_status_e      status,
                      input  uvm_reg_data_t    value,
                      input  uvm_door_e        path = UVM_DEFAULT_DOOR,
                      input  uvm_reg_map       map = null,
                      input  uvm_sequence_base parent = null,
                      input  int               prior = -1,
                      input  uvm_object        extension = null,
                      input  string            fname = "",
                      input  int               lineno = 0); endtask

   virtual task read(output uvm_status_e      status,
                     output uvm_reg_data_t    value,
                     input  uvm_door_e        path = UVM_DEFAULT_DOOR,
                     input  uvm_reg_map       map = null,
                     input  uvm_sequence_base parent = null,
                     input  int               prior = -1,
                     input  uvm_object        extension = null,
                     input  string            fname = "",
                     input  int               lineno = 0); endtask

   virtual task poke(output uvm_status_e      status,
                     input  uvm_reg_data_t    value,
                     input  string            kind = "",
                     input  uvm_sequence_base parent = null,
                     input  uvm_object        extension = null,
                     input  string            fname = "",
                     input  int               lineno = 0); endtask

   virtual task peek(output uvm_status_e      status,
                     output uvm_reg_data_t    value,
                     input  string            kind = "",
                     input  uvm_sequence_base parent = null,
                     input  uvm_object        extension = null,
                     input  string            fname = "",
                     input  int               lineno = 0); endtask

   virtual task update(output uvm_status_e      status,
                       input  uvm_door_e        path = UVM_DEFAULT_DOOR,
                       input  uvm_reg_map       map = null,
                       input  uvm_sequence_base parent = null,
                       input  int               prior = -1,
                       input  uvm_object        extension = null,
                       input  string            fname = "",
                       input  int               lineno = 0); endtask
   
   virtual task mirror(output uvm_status_e      status,
                       input uvm_check_e        check  = UVM_NO_CHECK,
                       input uvm_door_e         path = UVM_DEFAULT_DOOR,
                       input uvm_reg_map        map = null,
                       input uvm_sequence_base  parent = null,
                       input int                prior = -1,
                       input  uvm_object        extension = null,
                       input string             fname = "",
                       input int                lineno = 0); endtask
   
endclass : uvm_reg_indirect_data


class uvm_reg_indirect_ftdr_seq extends uvm_reg_frontdoor;



   
   function new(uvm_reg addr_reg,
                int idx,
                uvm_reg data_reg); endfunction: new

   virtual task body(); endtask

endclass
