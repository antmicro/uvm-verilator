// -------------------------------------------------------------
// Copyright 2010-2018 Mentor Graphics Corporation
// Copyright 2014 Semifore
// Copyright 2014-2017 Intel Corporation
// Copyright 2004-2018 Synopsys, Inc.
// Copyright 2010-2018 Cadence Design Systems, Inc.
// Copyright 2010 AMD
// Copyright 2014-2018 NVIDIA Corporation
// Copyright 2017 Cisco Systems, Inc.
// Copyright 2012 Accellera Systems Initiative
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

// Class -- NODOCS -- uvm_reg_transaction_order_policy
// Not in LRM.
class uvm_reg_map_info;
   uvm_reg_addr_t         offset;
   string                 rights;
   bit                    unmapped;
   uvm_reg_addr_t         addr[];
   uvm_reg_frontdoor      frontdoor;
   uvm_reg_map_addr_range mem_range; 
   
   // if set marks the uvm_reg_map_info as initialized, prevents using an uninitialized map (for instance if the model 
   // has not been locked accidently and the maps have not been computed before)
   bit                    is_initialized;
endclass


// Class -- NODOCS -- uvm_reg_transaction_order_policy
virtual class uvm_reg_transaction_order_policy extends uvm_object;
    function new(string name = "policy"); endfunction

    // Function -- NODOCS -- order
    // the order() function may reorder the sequence of bus transactions
    // produced by a single uvm_reg transaction (read/write).
    // This can be used in scenarios when the register width differs from
    // the bus width and one register access results in a series of bus transactions.
    // the first item (0) of the queue will be the first bus transaction (the last($)
    // will be the final transaction
    pure virtual function void order(ref uvm_reg_bus_op q[$]);
endclass

// Extends virtual class uvm_sequence_base so that it can be constructed:
class uvm_reg_seq_base extends uvm_sequence_base;
 
   `uvm_object_utils(uvm_reg_seq_base)


function new(string name = "uvm_reg_seq_base"); endfunction  

endclass


//------------------------------------------------------------------------------
//
// Class -- NODOCS -- uvm_reg_map
//
// :Address map abstraction class
//
// This class represents an address map.
// An address map is a collection of registers and memories
// accessible via a specific physical interface.
// Address maps can be composed into higher-level address maps.
//
// Address maps are created using the <uvm_reg_block::create_map()>
// method.
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto 18.2.1
class uvm_reg_map extends uvm_object;

   `uvm_object_utils(uvm_reg_map)
   
   // info that is valid only if top-level map
   local uvm_reg_addr_t     m_base_addr;
   local int unsigned       m_n_bytes;
   local uvm_endianness_e   m_endian;
   local bit                m_byte_addressing;
   local uvm_object_wrapper m_sequence_wrapper;
   local uvm_reg_adapter    m_adapter;
   local uvm_sequencer_base m_sequencer;
   local bit                m_auto_predict;
   local bit                m_check_on_read;

   local uvm_reg_block      m_parent;

   local int unsigned       m_system_n_bytes;

   local uvm_reg_map        m_parent_map;
   local uvm_reg_addr_t     m_submaps[uvm_reg_map];       // value=offset of submap at this level
   local string             m_submap_rights[uvm_reg_map]; // value=rights of submap at this level

   local uvm_reg_map_info   m_regs_info[uvm_reg];
   local uvm_reg_map_info   m_mems_info[uvm_mem];

   local uvm_reg            m_regs_by_offset[uvm_reg_addr_t];
                            // Use only in addition to above if a RO and a WO
                            // register share the same address.
   local uvm_reg            m_regs_by_offset_wo[uvm_reg_addr_t]; 
   local uvm_mem            m_mems_by_offset[uvm_reg_map_addr_range];

   local uvm_reg_transaction_order_policy policy;

   extern /*local*/ function void Xinit_address_mapX();

   static local uvm_reg_map   m_backdoor;


   // @uvm-ieee 1800.2-2017 auto 18.2.2
   static function uvm_reg_map backdoor(); endfunction


   //----------------------
   // Group -- NODOCS -- Initialization
   //----------------------



   // @uvm-ieee 1800.2-2017 auto 18.2.3.1
   extern function new(string name="uvm_reg_map");



   // @uvm-ieee 1800.2-2017 auto 18.2.3.2
   extern function void configure(uvm_reg_block     parent,
                                  uvm_reg_addr_t    base_addr,
                                  int unsigned      n_bytes,
                                  uvm_endianness_e  endian,
                                  bit byte_addressing = 1);


   // @uvm-ieee 1800.2-2017 auto 18.2.3.3
   extern virtual function void add_reg (uvm_reg           rg,
                                         uvm_reg_addr_t    offset,
                                         string            rights = "RW",
                                         bit               unmapped=0,
                                         uvm_reg_frontdoor frontdoor=null);



   // @uvm-ieee 1800.2-2017 auto 18.2.3.4
   extern virtual function void add_mem (uvm_mem        mem,
                                         uvm_reg_addr_t offset,
                                         string         rights = "RW",
                                         bit            unmapped=0,
                                         uvm_reg_frontdoor frontdoor=null);

   

   // NOTE THIS isnt really true because one can add a map only to another map if the 
   // map parent blocks are either the same or the maps parent is an ancestor of the submaps parent
   // also AddressUnitBits needs to match which means essentially that within a block there can only be one 
   // AddressUnitBits
   
   // @uvm-ieee 1800.2-2017 auto 18.2.3.5
   extern virtual function void add_submap (uvm_reg_map    child_map,
                                            uvm_reg_addr_t offset);


   // Function -- NODOCS -- set_sequencer
   //
   // Set the sequencer and adapter associated with this map. This method
   // ~must~ be called before starting any sequences based on uvm_reg_sequence.

   // @uvm-ieee 1800.2-2017 auto 18.2.3.6
   extern virtual function void set_sequencer (uvm_sequencer_base sequencer,
                                               uvm_reg_adapter    adapter=null);



   // Function -- NODOCS -- set_submap_offset
   //
   // Set the offset of the given ~submap~ to ~offset~.

   // @uvm-ieee 1800.2-2017 auto 18.2.3.8
   extern virtual function void set_submap_offset (uvm_reg_map submap,
                                                   uvm_reg_addr_t offset);


   // Function -- NODOCS -- get_submap_offset
   //
   // Return the offset of the given ~submap~.

   // @uvm-ieee 1800.2-2017 auto 18.2.3.7
   extern virtual function uvm_reg_addr_t get_submap_offset (uvm_reg_map submap);


   // Function -- NODOCS -- set_base_addr
   //
   // Set the base address of this map.

   // @uvm-ieee 1800.2-2017 auto 18.2.3.9
   extern virtual function void   set_base_addr (uvm_reg_addr_t  offset);



   // @uvm-ieee 1800.2-2017 auto 18.2.3.10
   extern virtual function void reset(string kind = "SOFT");


   /*local*/ extern virtual function void add_parent_map(uvm_reg_map  parent_map,
                                                         uvm_reg_addr_t offset);

   /*local*/ extern virtual function void Xverify_map_configX();

   /*local*/ extern virtual function void m_set_reg_offset(uvm_reg   rg,
                                                           uvm_reg_addr_t offset,
                                                           bit unmapped);

   /*local*/ extern virtual function void m_set_mem_offset(uvm_mem mem,
                                                           uvm_reg_addr_t offset,
                                                           bit unmapped);


   //---------------------
   // Group -- NODOCS -- Introspection
   //---------------------

   // Function -- NODOCS -- get_name
   //
   // Get the simple name
   //
   // Return the simple object name of this address map.
   //

   // Function -- NODOCS -- get_full_name
   //
   // Get the hierarchical name
   //
   // Return the hierarchal name of this address map.
   // The base of the hierarchical name is the root block.
   //
   extern virtual function string get_full_name();



   // @uvm-ieee 1800.2-2017 auto 18.2.4.1
   extern virtual function uvm_reg_map get_root_map();



   // @uvm-ieee 1800.2-2017 auto 18.2.4.2
   extern virtual function uvm_reg_block get_parent();



   // @uvm-ieee 1800.2-2017 auto 18.2.4.3
   extern virtual function uvm_reg_map           get_parent_map();



   // @uvm-ieee 1800.2-2017 auto 18.2.4.4
   extern virtual function uvm_reg_addr_t get_base_addr (uvm_hier_e hier=UVM_HIER);


   // Function -- NODOCS -- get_n_bytes
   //
   // Get the width in bytes of the bus associated with this map. If ~hier~
   // is ~UVM_HIER~, then gets the effective bus width relative to the system
   // level. The effective bus width is the narrowest bus width from this
   // map to the top-level root map. Each bus access will be limited to this
   // bus width.
   //
   extern virtual function int unsigned get_n_bytes (uvm_hier_e hier=UVM_HIER);


   // Function -- NODOCS -- get_addr_unit_bytes
   //
   // Get the number of bytes in the smallest addressable unit in the map.
   // Returns 1 if the address map was configured using byte-level addressing.
   // Returns <get_n_bytes()> otherwise.
   //
   extern virtual function int unsigned get_addr_unit_bytes();



   // @uvm-ieee 1800.2-2017 auto 18.2.4.7
   extern virtual function uvm_endianness_e get_endian (uvm_hier_e hier=UVM_HIER);



   // @uvm-ieee 1800.2-2017 auto 18.2.4.8
   extern virtual function uvm_sequencer_base get_sequencer (uvm_hier_e hier=UVM_HIER);



   // @uvm-ieee 1800.2-2017 auto 18.2.4.9
   extern virtual function uvm_reg_adapter get_adapter (uvm_hier_e hier=UVM_HIER);



   // @uvm-ieee 1800.2-2017 auto 18.2.4.10
   extern virtual function void  get_submaps (ref uvm_reg_map maps[$],
                                              input uvm_hier_e hier=UVM_HIER);



   // @uvm-ieee 1800.2-2017 auto 18.2.4.11
   extern virtual function void  get_registers (ref uvm_reg regs[$],
                                                input uvm_hier_e hier=UVM_HIER);



   // @uvm-ieee 1800.2-2017 auto 18.2.4.12
   extern virtual function void  get_fields (ref uvm_reg_field fields[$],
                                             input uvm_hier_e hier=UVM_HIER);

   

   // @uvm-ieee 1800.2-2017 auto 18.2.4.13
   extern virtual function void  get_memories (ref uvm_mem mems[$],
                                               input uvm_hier_e hier=UVM_HIER);



   // @uvm-ieee 1800.2-2017 auto 18.2.4.14
   extern virtual function void  get_virtual_registers (ref uvm_vreg regs[$],
                                                        input uvm_hier_e hier=UVM_HIER);



   // @uvm-ieee 1800.2-2017 auto 18.2.4.15
   extern virtual function void  get_virtual_fields (ref uvm_vreg_field fields[$],
                                                     input uvm_hier_e hier=UVM_HIER);


   extern virtual function uvm_reg_map_info get_reg_map_info(uvm_reg rg,  bit error=1);
   extern virtual function uvm_reg_map_info get_mem_map_info(uvm_mem mem, bit error=1);
   extern virtual function int unsigned get_size();


   // @uvm-ieee 1800.2-2017 auto 18.2.4.16
   extern virtual function int get_physical_addresses(uvm_reg_addr_t        base_addr,
                                                      uvm_reg_addr_t        mem_offset,
                                                      int unsigned          n_bytes,
                                                      ref uvm_reg_addr_t    addr[]);
   


   // @uvm-ieee 1800.2-2017 auto 18.2.4.17
   extern virtual function uvm_reg get_reg_by_offset(uvm_reg_addr_t offset,
                                                     bit            read = 1);


   // @uvm-ieee 1800.2-2017 auto 18.2.4.18
   extern virtual function uvm_mem    get_mem_by_offset(uvm_reg_addr_t offset);


   //------------------
   // Group -- NODOCS -- Bus Access
   //------------------

 
   // @uvm-ieee 1800.2-2017 auto 18.2.5.2
   function void set_auto_predict(bit on=1); endfunction


 
   // @uvm-ieee 1800.2-2017 auto 18.2.5.1
   function bit  get_auto_predict(); endfunction


 
   // @uvm-ieee 1800.2-2017 auto 18.2.5.3
   function void set_check_on_read(bit on=1); endfunction


   // Function -- NODOCS -- get_check_on_read
   //
   // Gets the check-on-read mode setting for this map.
   // 
   function bit  get_check_on_read(); endfunction


   
   // Task -- NODOCS -- do_bus_write
   //
   // Perform a bus write operation.
   //
   extern virtual task do_bus_write (uvm_reg_item rw,
                                     uvm_sequencer_base sequencer,
                                     uvm_reg_adapter adapter);


   // Task -- NODOCS -- do_bus_read
   //
   // Perform a bus read operation.
   //
   extern virtual task do_bus_read (uvm_reg_item rw,
                                    uvm_sequencer_base sequencer,
                                    uvm_reg_adapter adapter);


   // Task -- NODOCS -- do_write
   //
   // Perform a write operation.
   //
   extern virtual task do_write(uvm_reg_item rw);


   // Task -- NODOCS -- do_read
   //
   // Perform a read operation.
   //
   extern virtual task do_read(uvm_reg_item rw);

   extern function void Xget_bus_infoX (uvm_reg_item rw,
                                        output uvm_reg_map_info map_info,
                                        output int size,
                                        output int lsb,
                                        output int addr_skip);

   extern virtual function string      convert2string();
   extern virtual function uvm_object  clone();
   extern virtual function void        do_print (uvm_printer printer);
   extern virtual function void        do_copy   (uvm_object rhs);
   //extern virtual function bit       do_compare (uvm_object rhs, uvm_comparer comparer);
   //extern virtual function void      do_pack (uvm_packer packer);
   //extern virtual function void      do_unpack (uvm_packer packer);



    // @uvm-ieee 1800.2-2017 auto 18.2.5.5
    function void set_transaction_order_policy(uvm_reg_transaction_order_policy pol); endfunction
    

    // @uvm-ieee 1800.2-2017 auto 18.2.5.4
    function uvm_reg_transaction_order_policy get_transaction_order_policy(); endfunction    
   
// ceil() function
local function automatic int unsigned ceil(int unsigned a, int unsigned b); endfunction
  
 /*
  * translates an access from the current map ~this~ to an address ~base_addr~ (within the current map) with a 
  * length of ~n_bytes~ into an access from map ~parent_map~. 
  * if ~mem~ and ~mem_offset~ are supplied then a memory access is assumed 
  * results: ~addr~ contains the set of addresses and ~byte_offset~ holds the number of bytes the data stream needs to be shifted 
  * 
  * this implementation assumes a packed data access
  */ 
 extern virtual function int get_physical_addresses_to_map(uvm_reg_addr_t     base_addr,
		uvm_reg_addr_t     mem_offset,
		int unsigned       n_bytes,  // number of bytes
		ref uvm_reg_addr_t addr[], // array of addresses 
		input uvm_reg_map parent_map, // translate till parent_map is the parent of the actual map or NULL if this is a root_map
		ref int unsigned byte_offset,
		input uvm_mem mem =null
	 );

// performs all bus operations ~accesses~ generated from ~rw~ via adapter ~adapter~ on sequencer ~sequencer~
extern task perform_accesses(ref uvm_reg_bus_op    accesses[$],
		input uvm_reg_item rw,
		input uvm_reg_adapter adapter,
		input  uvm_sequencer_base sequencer);

// performs all necessary bus accesses defined by ~rw~ on the sequencer ~sequencer~ utilizing the adapter ~adapter~
extern task do_bus_access (uvm_reg_item rw,
                               uvm_sequencer_base sequencer,
                               uvm_reg_adapter adapter);
  
    // unregisters all content from this map recursively
    // it is NOT expected that this leads to a fresh new map 
    // it rather removes all knowledge of this map from other objects 
    // so that they can be reused with a fresh map instance
	// @uvm-ieee 1800.2-2017 auto 18.2.3.11
	virtual function void unregister(); endfunction

	virtual function uvm_reg_map clone_and_update(string rights); endfunction
endclass: uvm_reg_map
   


//---------------
// Initialization
//---------------

// new

function uvm_reg_map::new(string name = "uvm_reg_map"); endfunction


// configure

function void uvm_reg_map::configure(uvm_reg_block    parent,
                                     uvm_reg_addr_t   base_addr,
                                     int unsigned     n_bytes,
                                     uvm_endianness_e endian,
                                     bit              byte_addressing=1); endfunction: configure


// add_reg

function void uvm_reg_map::add_reg(uvm_reg rg, 
                                   uvm_reg_addr_t offset,
                                   string rights = "RW",
                                   bit unmapped=0,
                                   uvm_reg_frontdoor frontdoor=null); endfunction


// m_set_reg_offset

function void uvm_reg_map::m_set_reg_offset(uvm_reg rg, 
                                            uvm_reg_addr_t offset,
                                            bit unmapped); endfunction


// add_mem

function void uvm_reg_map::add_mem(uvm_mem mem,
                                   uvm_reg_addr_t offset,
                                   string rights = "RW",
                                   bit unmapped=0,
                                   uvm_reg_frontdoor frontdoor=null); endfunction: add_mem



// m_set_mem_offset

function void uvm_reg_map::m_set_mem_offset(uvm_mem mem, 
                                            uvm_reg_addr_t offset,
                                            bit unmapped); endfunction


// add_submap

function void uvm_reg_map::add_submap (uvm_reg_map child_map,
                                       uvm_reg_addr_t offset); endfunction: add_submap


// reset

function void uvm_reg_map::reset(string kind = "SOFT"); endfunction


// add_parent_map

function void uvm_reg_map::add_parent_map(uvm_reg_map parent_map, uvm_reg_addr_t offset); endfunction: add_parent_map


// set_sequencer

function void uvm_reg_map::set_sequencer(uvm_sequencer_base sequencer,
                                         uvm_reg_adapter adapter=null); endfunction



//------------
// get methods
//------------

// get_parent

function uvm_reg_block uvm_reg_map::get_parent(); endfunction


// get_parent_map

function uvm_reg_map uvm_reg_map::get_parent_map(); endfunction


// get_root_map

function uvm_reg_map uvm_reg_map::get_root_map(); endfunction: get_root_map


// get_base_addr

function uvm_reg_addr_t  uvm_reg_map::get_base_addr(uvm_hier_e hier=UVM_HIER); endfunction


// get_n_bytes

function int unsigned uvm_reg_map::get_n_bytes(uvm_hier_e hier=UVM_HIER); endfunction


// get_addr_unit_bytes

function int unsigned uvm_reg_map::get_addr_unit_bytes(); endfunction


// get_endian

function uvm_endianness_e uvm_reg_map::get_endian(uvm_hier_e hier=UVM_HIER); endfunction


// get_sequencer

function uvm_sequencer_base uvm_reg_map::get_sequencer(uvm_hier_e hier=UVM_HIER); endfunction


// get_adapter

function uvm_reg_adapter uvm_reg_map::get_adapter(uvm_hier_e hier=UVM_HIER); endfunction


// get_submaps

function void uvm_reg_map::get_submaps(ref uvm_reg_map maps[$], input uvm_hier_e hier=UVM_HIER); endfunction


// get_registers

function void uvm_reg_map::get_registers(ref uvm_reg regs[$], input uvm_hier_e hier=UVM_HIER); endfunction


// get_fields

function void uvm_reg_map::get_fields(ref uvm_reg_field fields[$], input uvm_hier_e hier=UVM_HIER); endfunction


// get_memories

function void uvm_reg_map::get_memories(ref uvm_mem mems[$], input uvm_hier_e hier=UVM_HIER); endfunction


// get_virtual_registers

function void uvm_reg_map::get_virtual_registers(ref uvm_vreg regs[$], input uvm_hier_e hier=UVM_HIER); endfunction


// get_virtual_fields

function void uvm_reg_map::get_virtual_fields(ref uvm_vreg_field fields[$], input uvm_hier_e hier=UVM_HIER); endfunction



// get_full_name

function string uvm_reg_map::get_full_name(); endfunction


// get_mem_map_info

function uvm_reg_map_info uvm_reg_map::get_mem_map_info(uvm_mem mem, bit error=1); endfunction


// get_reg_map_info

function uvm_reg_map_info uvm_reg_map::get_reg_map_info(uvm_reg rg, bit error=1); endfunction


//----------
// Size and Overlap Detection
//---------

// set_base_addr

function void uvm_reg_map::set_base_addr(uvm_reg_addr_t offset); endfunction


// get_size

function int unsigned uvm_reg_map::get_size(); endfunction



function void uvm_reg_map::Xverify_map_configX(); endfunction

// NOTE: if multiple memory addresses would fall into one bus word then the memory is addressed 'unpacked'
// ie. every memory location will get an own bus address (and bits on the bus larger than the memory width are discarded
// otherwise the memory access is 'packed' 
// 
// same as get_physical_addresses() but stops at the specified map
function int uvm_reg_map::get_physical_addresses_to_map(
		uvm_reg_addr_t     base_addr, // in terms of the local map aub
		uvm_reg_addr_t     mem_offset, // in terms of memory words
		int unsigned       n_bytes,  // number of bytes for the memory stream
		ref uvm_reg_addr_t addr[], // out: set of addresses required for memory stream in local map aub
		input uvm_reg_map parent_map, // desired target map
		ref int unsigned byte_offset, // leading byte offset (due to shifting within address words)
		input uvm_mem mem=null
		); endfunction

// NOTE the map argument could be made an arg with a default value. didnt do that to present the function signature
function int uvm_reg_map::get_physical_addresses(uvm_reg_addr_t     base_addr,
		uvm_reg_addr_t     mem_offset,
		int unsigned       n_bytes,  // number of bytes
		ref uvm_reg_addr_t addr[]); endfunction


//--------------
// Get-By-Offset
//--------------


// set_submap_offset

function void uvm_reg_map::set_submap_offset(uvm_reg_map submap, uvm_reg_addr_t offset); endfunction


// get_submap_offset

function uvm_reg_addr_t uvm_reg_map::get_submap_offset(uvm_reg_map submap); endfunction


// get_reg_by_offset

function uvm_reg uvm_reg_map::get_reg_by_offset(uvm_reg_addr_t offset,
                                                bit            read = 1); endfunction


// get_mem_by_offset

function uvm_mem uvm_reg_map::get_mem_by_offset(uvm_reg_addr_t offset); endfunction


// Xinit_address_mapX

function void uvm_reg_map::Xinit_address_mapX(); endfunction


//-----------
// Bus Access
//-----------

function void uvm_reg_map::Xget_bus_infoX(uvm_reg_item rw,
                                          output uvm_reg_map_info map_info,
                                          output int size,
                                          output int lsb,
                                          output int addr_skip); endfunction




// do_write(uvm_reg_item rw)

task uvm_reg_map::do_write(uvm_reg_item rw);
endtask


// do_read(uvm_reg_item rw)

task uvm_reg_map::do_read(uvm_reg_item rw);
endtask


// do_bus_write

task uvm_reg_map::do_bus_write (uvm_reg_item rw,
                                uvm_sequencer_base sequencer,
                                uvm_reg_adapter adapter); endtask

task uvm_reg_map::perform_accesses(ref uvm_reg_bus_op    accesses[$],
		input uvm_reg_item rw,
		input uvm_reg_adapter adapter,
		input  uvm_sequencer_base sequencer);
endtask

// do_bus_read

task uvm_reg_map::do_bus_access (uvm_reg_item rw,
                               uvm_sequencer_base sequencer,
                               uvm_reg_adapter adapter); endtask

task uvm_reg_map::do_bus_read (uvm_reg_item rw,
                               uvm_sequencer_base sequencer,
                               uvm_reg_adapter adapter); endtask: do_bus_read



//-------------
// Standard Ops
//-------------

// do_print

function void uvm_reg_map::do_print (uvm_printer printer); endfunction

// convert2string

function string uvm_reg_map::convert2string(); endfunction


// clone

function uvm_object uvm_reg_map::clone(); endfunction


// do_copy

function void uvm_reg_map::do_copy (uvm_object rhs);
  //uvm_reg_map rhs_;
  //if (!$cast(seq, o))
  //  `uvm_fatal(...)

  //rhs_.regs = regs;
  //rhs_.mems = mems;
  //rhs_.vregs = vregs;
  //rhs_.blks = blks;
  //... and so on
endfunction

