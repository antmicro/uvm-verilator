//
// -------------------------------------------------------------
// Copyright 2010-2011 Mentor Graphics Corporation
// Copyright 2014 Semifore
// Copyright 2004-2018 Synopsys, Inc.
// Copyright 2010-2018 Cadence Design Systems, Inc.
// Copyright 2010 AMD
// Copyright 2014-2018 NVIDIA Corporation
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




// @uvm-ieee 1800.2-2017 auto 18.1.1
class uvm_reg_block extends uvm_object;


   `uvm_object_utils(uvm_reg_block)


   local uvm_reg_block  parent;

   local static bit     m_roots[uvm_reg_block];
   local static int unsigned m_root_names[string];

   local int unsigned   blks[uvm_reg_block];
   local int unsigned   regs[uvm_reg];
   local int unsigned   vregs[uvm_vreg];
   local int unsigned   mems[uvm_mem];
   local bit            maps[uvm_reg_map];

   // Variable -- NODOCS -- default_path
   // Default access path for the registers and memories in this block.
`ifdef UVM_ENABLE_DEPRECATED_API
   uvm_door_e      default_path = UVM_DEFAULT_DOOR;
`else
   local uvm_door_e default_path = UVM_DEFAULT_DOOR;
`endif

   local string         default_hdl_path = "RTL";
   local uvm_reg_backdoor backdoor;
   local uvm_object_string_pool #(uvm_queue #(string)) hdl_paths_pool;
   local string         root_hdl_paths[string];

   local bit            locked;

   local int            has_cover;
   local int            cover_on;
   local string         fname;
   local int            lineno;

   local event m_uvm_lock_model_complete;

   local static int id;

   //----------------------
   // Group -- NODOCS -- Initialization
   //----------------------

   // Function -- NODOCS -- new
   //
   // Create a new instance and type-specific configuration
   //
   // Creates an instance of a block abstraction class with the specified
   // name.
   //
   // ~has_coverage~ specifies which functional coverage models are present in
   // the extension of the block abstraction class.
   // Multiple functional coverage models may be specified by adding their
   // symbolic names, as defined by the <uvm_coverage_model_e> type.
   //
   extern function new(string name="", int has_coverage=UVM_NO_COVERAGE);


   // Function -- NODOCS -- configure
   //
   // Instance-specific configuration
   //
   // Specify the parent block of this block.
   // A block without parent is a root block.
   //
   // If the block file corresponds to a hierarchical RTL structure,
   // its contribution to the HDL path is specified as the ~hdl_path~.
   // Otherwise, the block does not correspond to a hierarchical RTL
   // structure (e.g. it is physically flattened) and does not contribute
   // to the hierarchical HDL path of any contained registers or memories.
   //
   extern function void configure(uvm_reg_block parent=null,
                                  string hdl_path="");


   // Function -- NODOCS -- create_map
   //
   // Create an address map in this block
   //
   // Create an address map with the specified ~name~, then
   // configures it with the following properties.
   //
   // base_addr - the base address for the map. All registers, memories,
   //             and sub-blocks within the map will be at offsets to this
   //             address
   //
   // n_bytes   - the byte-width of the bus on which this map is used
   //
   // endian    - the endian format. See <uvm_endianness_e> for possible
   //             values
   //
   // byte_addressing - specifies whether consecutive addresses refer are 1 byte
   //             apart (TRUE) or ~n_bytes~ apart (FALSE). Default is TRUE.
   //
   //| APB = create_map("APB", 0, 1, UVM_LITTLE_ENDIAN, 1);
   //
   extern virtual function uvm_reg_map create_map(string name,
                                                  uvm_reg_addr_t base_addr,
                                                  int unsigned n_bytes,
                                                  uvm_endianness_e endian,
                                                  bit byte_addressing = 1);


   // Function -- NODOCS -- check_data_width
   //
   // Check that the specified data width (in bits) is less than
   // or equal to the value of `UVM_REG_DATA_WIDTH
   //
   // This method is designed to be called by a static initializer
   //
   //| class my_blk extends uvm_reg_block;
   //|   local static bit m_data_width = check_data_width(356);
   //|   ...
   //| endclass
   //
   extern protected static function bit check_data_width(int unsigned width);



   // Function -- NODOCS -- set_default_map
   //
   // Defines the default address map
   //
   // Set the specified address map as the <default_map> for this
   // block. The address map must be a map of this address block.
   //
   extern function void set_default_map (uvm_reg_map map);


   // Variable -- NODOCS -- default_map
   //
   // Default address map
   //
   // Default address map for this block, to be used when no
   // address map is specified for a register operation and that
   // register is accessible from more than one address map.
   //
   // It is also the implicit address map for a block with a single,
   // unnamed address map because it has only one physical interface.
   //
   uvm_reg_map default_map;

   extern function uvm_reg_map get_default_map ();

   extern virtual function void set_parent(uvm_reg_block parent);

   /*local*/ extern function void add_block (uvm_reg_block blk);
   /*local*/ extern function void add_map   (uvm_reg_map map);
   /*local*/ extern function void add_reg   (uvm_reg  rg);
   /*local*/ extern function void add_vreg  (uvm_vreg vreg);
   /*local*/ extern function void add_mem   (uvm_mem  mem);


   // Function -- NODOCS -- lock_model
   //
   // Lock a model and build the address map.
   //
   // Recursively lock an entire register model
   // and build the address maps to enable the
   // <uvm_reg_map::get_reg_by_offset()> and
   // <uvm_reg_map::get_mem_by_offset()> methods.
   //
   // Once locked, no further structural changes,
   // such as adding registers or memories,
   // can be made.
   extern virtual function void lock_model();

	// brings back the register mode to a state before lock_model() so that a subsequent lock_model() can be issued
   virtual function void unlock_model(); endfunction

   virtual task wait_for_lock(); endtask


   // Function -- NODOCS -- is_locked
   //
   // Return TRUE if the model is locked.
   //
   extern function bit is_locked();


   //---------------------
   // Group -- NODOCS -- Introspection
   //---------------------


   // Function -- NODOCS -- get_name
   //
   // Get the simple name
   //
   // Return the simple object name of this block.
   //


   // Function -- NODOCS -- get_full_name
   //
   // Get the hierarchical name
   //
   // Return the hierarchal name of this block.
   // The base of the hierarchical name is the root block.
   //
   extern virtual function string get_full_name();


   // Function -- NODOCS -- get_parent
   //
   // Get the parent block
   //
   // If this a top-level block, returns ~null~.
   //
   extern virtual function uvm_reg_block get_parent();


   // Function -- NODOCS -- get_root_blocks
   //
   // Get the all root blocks
   //
   // Returns an array of all root blocks in the simulation.
   //
   extern static  function void get_root_blocks(ref uvm_reg_block blks[$]);


   // Function -- NODOCS -- find_blocks
   //
   // Find the blocks whose hierarchical names match the
   // specified ~name~ glob.
   // If a ~root~ block is specified, the name of the blocks are
   // relative to that block, otherwise they are absolute.
   //
   // Returns the number of blocks found.
   //
   extern static function int find_blocks(input string        name,
                                          ref   uvm_reg_block blks[$],
                                          input uvm_reg_block root = null,
                                          input uvm_object    accessor = null);


   // Function -- NODOCS -- find_block
   //
   // Find the first block whose hierarchical names match the
   // specified ~name~ glob.
   // If a ~root~ block is specified, the name of the blocks are
   // relative to that block, otherwise they are absolute.
   //
   // Returns the first block found or ~null~ otherwise.
   // A warning is issued if more than one block is found.
   //
   extern static function uvm_reg_block find_block(input string        name,
                                                   input uvm_reg_block root = null,
                                                   input uvm_object    accessor = null);


   // Function -- NODOCS -- get_blocks
   //
   // Get the sub-blocks
   //
   // Get the blocks instantiated in this blocks.
   // If ~hier~ is TRUE, recursively includes any sub-blocks.
   //
   extern virtual function void get_blocks (ref uvm_reg_block  blks[$],
                                            input uvm_hier_e hier=UVM_HIER);


   // Function -- NODOCS -- get_maps
   //
   // Get the address maps
   //
   // Get the address maps instantiated in this block.
   //
   extern virtual function void get_maps (ref uvm_reg_map maps[$]);


   // Function -- NODOCS -- get_registers
   //
   // Get the registers
   //
   // Get the registers instantiated in this block.
   // If ~hier~ is TRUE, recursively includes the registers
   // in the sub-blocks.
   //
   // Note that registers may be located in different and/or multiple
   // address maps. To get the registers in a specific address map,
   // use the <uvm_reg_map::get_registers()> method.
   //
   extern virtual function void get_registers (ref uvm_reg regs[$],
                                               input uvm_hier_e hier=UVM_HIER);


   // Function -- NODOCS -- get_fields
   //
   // Get the fields
   //
   // Get the fields in the registers instantiated in this block.
   // If ~hier~ is TRUE, recursively includes the fields of the registers
   // in the sub-blocks.
   //
   extern virtual function void get_fields (ref uvm_reg_field  fields[$],
                                            input uvm_hier_e hier=UVM_HIER);


   // Function -- NODOCS -- get_memories
   //
   // Get the memories
   //
   // Get the memories instantiated in this block.
   // If ~hier~ is TRUE, recursively includes the memories
   // in the sub-blocks.
   //
   // Note that memories may be located in different and/or multiple
   // address maps. To get the memories in a specific address map,
   // use the <uvm_reg_map::get_memories()> method.
   //
   extern virtual function void get_memories (ref uvm_mem mems[$],
                                              input uvm_hier_e hier=UVM_HIER);


   // Function -- NODOCS -- get_virtual_registers
   //
   // Get the virtual registers
   //
   // Get the virtual registers instantiated in this block.
   // If ~hier~ is TRUE, recursively includes the virtual registers
   // in the sub-blocks.
   //
   extern virtual function void get_virtual_registers(ref uvm_vreg regs[$],
                                                input uvm_hier_e hier=UVM_HIER);


   // Function -- NODOCS -- get_virtual_fields
   //
   // Get the virtual fields
   //
   // Get the virtual fields from the virtual registers instantiated
   // in this block.
   // If ~hier~ is TRUE, recursively includes the virtual fields
   // in the virtual registers in the sub-blocks.
   //
   extern virtual function void get_virtual_fields (ref uvm_vreg_field fields[$],
                                                 input uvm_hier_e hier=UVM_HIER);


   // Function -- NODOCS -- get_block_by_name
   //
   // Finds a sub-block with the specified simple name.
   //
   // The name is the simple name of the block, not a hierarchical name.
   // relative to this block.
   // If no block with that name is found in this block, the sub-blocks
   // are searched for a block of that name and the first one to be found
   // is returned.
   //
   // If no blocks are found, returns ~null~.
   //
   extern virtual function uvm_reg_block get_block_by_name (string name);


   // Function -- NODOCS -- get_map_by_name
   //
   // Finds an address map with the specified simple name.
   //
   // The name is the simple name of the address map, not a hierarchical name.
   // relative to this block.
   // If no map with that name is found in this block, the sub-blocks
   // are searched for a map of that name and the first one to be found
   // is returned.
   //
   // If no address maps are found, returns ~null~.
   //
   extern virtual function uvm_reg_map get_map_by_name (string name);


   // Function -- NODOCS -- get_reg_by_name
   //
   // Finds a register with the specified simple name.
   //
   // The name is the simple name of the register, not a hierarchical name.
   // relative to this block.
   // If no register with that name is found in this block, the sub-blocks
   // are searched for a register of that name and the first one to be found
   // is returned.
   //
   // If no registers are found, returns ~null~.
   //
   extern virtual function uvm_reg get_reg_by_name (string name);


   // Function -- NODOCS -- get_field_by_name
   //
   // Finds a field with the specified simple name.
   //
   // The name is the simple name of the field, not a hierarchical name.
   // relative to this block.
   // If no field with that name is found in this block, the sub-blocks
   // are searched for a field of that name and the first one to be found
   // is returned.
   //
   // If no fields are found, returns ~null~.
   //
   extern virtual function uvm_reg_field get_field_by_name (string name);


   // Function -- NODOCS -- get_mem_by_name
   //
   // Finds a memory with the specified simple name.
   //
   // The name is the simple name of the memory, not a hierarchical name.
   // relative to this block.
   // If no memory with that name is found in this block, the sub-blocks
   // are searched for a memory of that name and the first one to be found
   // is returned.
   //
   // If no memories are found, returns ~null~.
   //
   extern virtual function uvm_mem get_mem_by_name (string name);


   // Function -- NODOCS -- get_vreg_by_name
   //
   // Finds a virtual register with the specified simple name.
   //
   // The name is the simple name of the virtual register,
   // not a hierarchical name.
   // relative to this block.
   // If no virtual register with that name is found in this block,
   // the sub-blocks are searched for a virtual register of that name
   // and the first one to be found is returned.
   //
   // If no virtual registers are found, returns ~null~.
   //
   extern virtual function uvm_vreg get_vreg_by_name (string name);


   // Function -- NODOCS -- get_vfield_by_name
   //
   // Finds a virtual field with the specified simple name.
   //
   // The name is the simple name of the virtual field,
   // not a hierarchical name.
   // relative to this block.
   // If no virtual field with that name is found in this block,
   // the sub-blocks are searched for a virtual field of that name
   // and the first one to be found is returned.
   //
   // If no virtual fields are found, returns ~null~.
   //
   extern virtual function uvm_vreg_field get_vfield_by_name (string name);


   //----------------
   // Group -- NODOCS -- Coverage
   //----------------


   // Function -- NODOCS -- build_coverage
   //
   // Check if all of the specified coverage model must be built.
   //
   // Check which of the specified coverage model must be built
   // in this instance of the block abstraction class,
   // as specified by calls to <uvm_reg::include_coverage()>.
   //
   // Models are specified by adding the symbolic value of individual
   // coverage model as defined in <uvm_coverage_model_e>.
   // Returns the sum of all coverage models to be built in the
   // block model.
   //
   extern protected function uvm_reg_cvr_t build_coverage(uvm_reg_cvr_t models);


   // Function -- NODOCS -- add_coverage
   //
   // Specify that additional coverage models are available.
   //
   // Add the specified coverage model to the coverage models
   // available in this class.
   // Models are specified by adding the symbolic value of individual
   // coverage model as defined in <uvm_coverage_model_e>.
   //
   // This method shall be called only in the constructor of
   // subsequently derived classes.
   //
   extern virtual protected function void add_coverage(uvm_reg_cvr_t models);


   // Function -- NODOCS -- has_coverage
   //
   // Check if block has coverage model(s)
   //
   // Returns TRUE if the block abstraction class contains a coverage model
   // for all of the models specified.
   // Models are specified by adding the symbolic value of individual
   // coverage model as defined in <uvm_coverage_model_e>.
   //
   extern virtual function bit has_coverage(uvm_reg_cvr_t models);


   // Function -- NODOCS -- set_coverage
   //
   // Turns on coverage measurement.
   //
   // Turns the collection of functional coverage measurements on or off
   // for this block and all blocks, registers, fields and memories within it.
   // The functional coverage measurement is turned on for every
   // coverage model specified using <uvm_coverage_model_e> symbolic
   // identifiers.
   // Multiple functional coverage models can be specified by adding
   // the functional coverage model identifiers.
   // All other functional coverage models are turned off.
   // Returns the sum of all functional
   // coverage models whose measurements were previously on.
   //
   // This method can only control the measurement of functional
   // coverage models that are present in the various abstraction classes,
   // then enabled during construction.
   // See the <uvm_reg_block::has_coverage()> method to identify
   // the available functional coverage models.
   //
   extern virtual function uvm_reg_cvr_t set_coverage(uvm_reg_cvr_t is_on);


   // Function -- NODOCS -- get_coverage
   //
   // Check if coverage measurement is on.
   //
   // Returns TRUE if measurement for all of the specified functional
   // coverage models are currently on.
   // Multiple functional coverage models can be specified by adding the
   // functional coverage model identifiers.
   //
   // See <uvm_reg_block::set_coverage()> for more details.
   //
   extern virtual function bit get_coverage(uvm_reg_cvr_t is_on = UVM_CVR_ALL);


   // Function -- NODOCS -- sample
   //
   // Functional coverage measurement method
   //
   // This method is invoked by the block abstraction class
   // whenever an address within one of its address map
   // is successfully read or written.
   // The specified offset is the offset within the block,
   // not an absolute address.
   //
   // Empty by default, this method may be extended by the
   // abstraction class generator to perform the required sampling
   // in any provided functional coverage model.
   //
   protected virtual function void  sample(uvm_reg_addr_t offset,
                                           bit            is_read,
                                           uvm_reg_map    map);
   endfunction


   // Function -- NODOCS -- sample_values
   //
   // Functional coverage measurement method for field values
   //
   // This method is invoked by the user
   // or by the <uvm_reg_block::sample_values()> method of the parent block
   // to trigger the sampling
   // of the current field values in the
   // block-level functional coverage model.
   // It recursively invokes the <uvm_reg_block::sample_values()>
   // and <uvm_reg::sample_values()> methods
   // in the blocks and registers in this block.
   //
   // This method may be extended by the
   // abstraction class generator to perform the required sampling
   // in any provided field-value functional coverage model.
   // If this method is extended, it MUST call super.sample_values().
   //
   extern virtual function void sample_values();

   /*local*/ extern function void XsampleX(uvm_reg_addr_t addr,
                                           bit            is_read,
                                           uvm_reg_map    map);


   //--------------
   // Group -- NODOCS -- Access
   //--------------

   // Function -- NODOCS -- get_default_door

   extern virtual function uvm_door_e get_default_door();

   // Function -- NODOCS -- set_default_door

   extern virtual function void set_default_door(uvm_door_e door);

`ifdef UVM_ENABLE_DEPRECATED_API
   // Function -- NODOCS -- get_default_path
   //
   // Default access path
   //
   // Returns the default access path for this block.
   //
   extern virtual function uvm_path_e get_default_path();
`endif

   // Function -- NODOCS -- reset
   //
   // Reset the mirror for this block.
   //
   // Sets the mirror value of all registers in the block and sub-blocks
   // to the reset value corresponding to the specified reset event.
   // See <uvm_reg_field::reset()> for more details.
   // Does not actually set the value of the registers in the design,
   // only the values mirrored in their corresponding mirror.
   //
   extern virtual function void reset(string kind = "HARD");


   // Function -- NODOCS -- needs_update
   //
   // Check if DUT registers need to be written
   //
   // If a mirror value has been modified in the abstraction model
   // without actually updating the actual register
   // (either through randomization or via the <uvm_reg::set()> method,
   // the mirror and state of the registers are outdated.
   // The corresponding registers in the DUT need to be updated.
   //
   // This method returns TRUE if the state of at least one register in
   // the block or sub-blocks needs to be updated to match the mirrored
   // values.
   // The mirror values, or actual content of registers, are not modified.
   // For additional information, see <uvm_reg_block::update()> method.
   //
   extern virtual function bit needs_update();


   // Task -- NODOCS -- update
   //
   // Batch update of register.
   //
   // Using the minimum number of write operations, updates the registers
   // in the design to match the mirrored values in this block and sub-blocks.
   // The update can be performed using the physical
   // interfaces (front-door access) or back-door accesses.
   // This method performs the reverse operation of <uvm_reg_block::mirror()>.
   //
   extern virtual task update(output uvm_status_e       status,
                              input  uvm_door_e         path = UVM_DEFAULT_DOOR,
                              input  uvm_sequence_base  parent = null,
                              input  int                prior = -1,
                              input  uvm_object         extension = null,
                              input  string             fname = "",
                              input  int                lineno = 0);


   // Task -- NODOCS -- mirror
   //
   // Update the mirrored values
   //
   // Read all of the registers in this block and sub-blocks and update their
   // mirror values to match their corresponding values in the design.
   // The mirroring can be performed using the physical interfaces
   // (front-door access) or back-door accesses.
   // If the ~check~ argument is specified as <UVM_CHECK>,
   // an error message is issued if the current mirrored value
   // does not match the actual value in the design.
   // This method performs the reverse operation of <uvm_reg_block::update()>.
   //
   extern virtual task mirror(output uvm_status_e       status,
                              input  uvm_check_e        check = UVM_NO_CHECK,
                              input  uvm_door_e         path  = UVM_DEFAULT_DOOR,
                              input  uvm_sequence_base  parent = null,
                              input  int                prior = -1,
                              input  uvm_object         extension = null,
                              input  string             fname = "",
                              input  int                lineno = 0);


   // Task -- NODOCS -- write_reg_by_name
   //
   // Write the named register
   //
   // Equivalent to <get_reg_by_name()> followed by <uvm_reg::write()>
   //
   extern virtual task write_reg_by_name(
                              output uvm_status_e        status,
                              input  string              name,
                              input  uvm_reg_data_t      data,
                              input  uvm_door_e     path = UVM_DEFAULT_DOOR,
                              input  uvm_reg_map         map = null,
                              input  uvm_sequence_base   parent = null,
                              input  int                 prior = -1,
                              input  uvm_object          extension = null,
                              input  string              fname = "",
                              input  int                 lineno = 0);


   // Task -- NODOCS -- read_reg_by_name
   //
   // Read the named register
   //
   // Equivalent to <get_reg_by_name()> followed by <uvm_reg::read()>
   //
   extern virtual task read_reg_by_name(
                              output uvm_status_e       status,
                              input  string             name,
                              output uvm_reg_data_t     data,
                              input  uvm_door_e    path = UVM_DEFAULT_DOOR,
                              input  uvm_reg_map        map = null,
                              input  uvm_sequence_base  parent = null,
                              input  int                prior = -1,
                              input  uvm_object         extension = null,
                              input  string             fname = "",
                              input  int                lineno = 0);


   // Task -- NODOCS -- write_mem_by_name
   //
   // Write the named memory
   //
   // Equivalent to <get_mem_by_name()> followed by <uvm_mem::write()>
   //
   extern virtual task write_mem_by_name(
                              output uvm_status_e       status,
                              input  string             name,
                              input  uvm_reg_addr_t     offset,
                              input  uvm_reg_data_t     data,
                              input  uvm_door_e    path = UVM_DEFAULT_DOOR,
                              input  uvm_reg_map        map = null,
                              input  uvm_sequence_base  parent = null,
                              input  int                prior = -1,
                              input  uvm_object         extension = null,
                              input  string             fname = "",
                              input  int                lineno = 0);


   // Task -- NODOCS -- read_mem_by_name
   //
   // Read the named memory
   //
   // Equivalent to <get_mem_by_name()> followed by <uvm_mem::read()>
   //
   extern virtual task read_mem_by_name(
                              output uvm_status_e       status,
                              input  string             name,
                              input  uvm_reg_addr_t     offset,
                              output uvm_reg_data_t     data,
                              input  uvm_door_e    path = UVM_DEFAULT_DOOR,
                              input  uvm_reg_map        map = null,
                              input  uvm_sequence_base  parent = null,
                              input  int                prior = -1,
                              input  uvm_object         extension = null,
                              input  string             fname = "",
                              input  int                lineno = 0);


   extern virtual task readmemh(string filename);
   extern virtual task writememh(string filename);



   //----------------
   // Group -- NODOCS -- Backdoor
   //----------------

   // Function -- NODOCS -- get_backdoor
   //
   // Get the user-defined backdoor for all registers in this block
   //
   // Return the user-defined backdoor for all register in this
   // block and all sub-blocks -- unless overridden by a backdoor set
   // in a lower-level block or in the register itself.
   //
   // If ~inherited~ is TRUE, returns the backdoor of the parent block
   // if none have been specified for this block.
   //
   extern function uvm_reg_backdoor get_backdoor(bit inherited = 1);


   // Function -- NODOCS -- set_backdoor
   //
   // Set the user-defined backdoor for all registers in this block
   //
   // Defines the backdoor mechanism for all registers instantiated
   // in this block and sub-blocks, unless overridden by a definition
   // in a lower-level block or register.
   //
   extern function void set_backdoor (uvm_reg_backdoor bkdr,
                                      string fname = "",
                                      int lineno = 0);


   // Function -- NODOCS --  clear_hdl_path
   //
   // Delete HDL paths
   //
   // Remove any previously specified HDL path to the block instance
   // for the specified design abstraction.
   //
   extern function void clear_hdl_path (string kind = "RTL");


   // Function -- NODOCS --  add_hdl_path
   //
   // Add an HDL path
   //
   // Add the specified HDL path to the block instance for the specified
   // design abstraction. This method may be called more than once for the
   // same design abstraction if the block is physically duplicated
   // in the design abstraction
   //
   extern function void add_hdl_path (string path, string kind = "RTL");


   // Function -- NODOCS --   has_hdl_path
   //
   // Check if a HDL path is specified
   //
   // Returns TRUE if the block instance has a HDL path defined for the
   // specified design abstraction. If no design abstraction is specified,
   // uses the default design abstraction specified for this block or
   // the nearest block ancestor with a specified default design abstraction.
   //
   extern function bit has_hdl_path (string kind = "");


   // Function -- NODOCS --  get_hdl_path
   //
   // Get the incremental HDL path(s)
   //
   // Returns the HDL path(s) defined for the specified design abstraction
   // in the block instance.
   // Returns only the component of the HDL paths that corresponds to
   // the block, not a full hierarchical path
   //
   // If no design abstraction is specified, the default design abstraction
   // for this block is used.
   //
   extern function void get_hdl_path (ref string paths[$], input string kind = "");


   // Function -- NODOCS --  get_full_hdl_path
   //
   // Get the full hierarchical HDL path(s)
   //
   // Returns the full hierarchical HDL path(s) defined for the specified
   // design abstraction in the block instance.
   // There may be more than one path returned even
   // if only one path was defined for the block instance, if any of the
   // parent components have more than one path defined for the same design
   // abstraction
   //
   // If no design abstraction is specified, the default design abstraction
   // for each ancestor block is used to get each incremental path.
   //
   extern function void get_full_hdl_path (ref string paths[$],
                                           input string kind = "",
                                           string separator = ".");


   // Function -- NODOCS -- set_default_hdl_path
   //
   // Set the default design abstraction
   //
   // Set the default design abstraction for this block instance.
   //
   extern function void   set_default_hdl_path (string kind);


   // Function -- NODOCS --  get_default_hdl_path
   //
   // Get the default design abstraction
   //
   // Returns the default design abstraction for this block instance.
   // If a default design abstraction has not been explicitly set for this
   // block instance, returns the default design abstraction for the
   // nearest block ancestor.
   // Returns "" if no default design abstraction has been specified.
   //
   extern function string get_default_hdl_path ();


   // Function -- NODOCS -- set_hdl_path_root
   //
   // Specify a root HDL path
   //
   // Set the specified path as the absolute HDL path to the block instance
   // for the specified design abstraction.
   // This absolute root path is prepended to all hierarchical paths
   // under this block. The HDL path of any ancestor block is ignored.
   // This method overrides any incremental path for the
   // same design abstraction specified using <add_hdl_path>.
   //
   extern function void set_hdl_path_root (string path, string kind = "RTL");


   // Function -- NODOCS -- is_hdl_path_root
   //
   // Check if this block has an absolute path
   //
   // Returns TRUE if an absolute HDL path to the block instance
   // for the specified design abstraction has been defined.
   // If no design abstraction is specified, the default design abstraction
   // for this block is used.
   //
   extern function bit is_hdl_path_root (string kind = "");


   extern virtual function void   do_print      (uvm_printer printer);
   extern virtual function void   do_copy       (uvm_object rhs);
   extern virtual function bit    do_compare    (uvm_object  rhs,
                                                 uvm_comparer comparer);
   extern virtual function void   do_pack       (uvm_packer packer);
   extern virtual function void   do_unpack     (uvm_packer packer);
   extern virtual function string convert2string ();
   extern virtual function uvm_object clone();

   extern local function void Xinit_address_mapsX();


   virtual function void set_lock(bit v); endfunction

   // remove all knowledge of map m and all regs|mems|vregs contained in m from the block
   virtual function void unregister(uvm_reg_map m); endfunction
endclass: uvm_reg_block

//------------------------------------------------------------------------


//---------------
// Initialization
//---------------

// check_data_width

function bit uvm_reg_block::check_data_width(int unsigned width); endfunction


// new

function uvm_reg_block::new(string name="", int has_coverage=UVM_NO_COVERAGE); endfunction: new


// configure

function void uvm_reg_block::configure(uvm_reg_block parent=null, string hdl_path=""); endfunction


// add_block

function void uvm_reg_block::add_block (uvm_reg_block blk); endfunction


// add_reg

function void uvm_reg_block::add_reg(uvm_reg rg); endfunction: add_reg


// add_vreg

function void uvm_reg_block::add_vreg(uvm_vreg vreg); endfunction: add_vreg


// add_mem

function void uvm_reg_block::add_mem(uvm_mem mem); endfunction: add_mem


// set_parent

function void uvm_reg_block::set_parent(uvm_reg_block parent); endfunction


// is_locked

function bit uvm_reg_block::is_locked(); endfunction: is_locked


// lock_model

function void uvm_reg_block::lock_model(); endfunction



//--------------------------
// Get Hierarchical Elements
//--------------------------

function string uvm_reg_block::get_full_name(); endfunction: get_full_name


// get_fields

function void uvm_reg_block::get_fields(ref uvm_reg_field fields[$],
                                        input uvm_hier_e hier=UVM_HIER); endfunction: get_fields


// get_virtual_fields

function void uvm_reg_block::get_virtual_fields(ref uvm_vreg_field fields[$],
                                                input uvm_hier_e hier=UVM_HIER); endfunction: get_virtual_fields


// get_registers

function void uvm_reg_block::get_registers(ref uvm_reg regs[$],
                                           input uvm_hier_e hier=UVM_HIER); endfunction: get_registers


// get_virtual_registers

function void uvm_reg_block::get_virtual_registers(ref uvm_vreg regs[$],
                                                   input uvm_hier_e hier=UVM_HIER); endfunction: get_virtual_registers


// get_memories

function void uvm_reg_block::get_memories(ref uvm_mem mems[$],
                                          input uvm_hier_e hier=UVM_HIER); endfunction: get_memories


// get_blocks

function void uvm_reg_block::get_blocks(ref uvm_reg_block blks[$],
                                        input uvm_hier_e hier=UVM_HIER); endfunction: get_blocks


// get_root_blocks

function void uvm_reg_block::get_root_blocks(ref uvm_reg_block blks[$]); endfunction


// find_blocks
function int uvm_reg_block::find_blocks(input string        name,
                                        ref   uvm_reg_block blks[$],
                                        input uvm_reg_block root = null,
                                        input uvm_object    accessor = null); endfunction




function uvm_reg_block uvm_reg_block::find_block(input string        name,
                                                 input uvm_reg_block root = null,
                                                 input uvm_object    accessor = null); endfunction


// get_maps

function void uvm_reg_block::get_maps(ref uvm_reg_map maps[$]); endfunction


// get_parent

function uvm_reg_block uvm_reg_block::get_parent(); endfunction: get_parent


//------------
// Get-By-Name
//------------

// get_block_by_name

function uvm_reg_block uvm_reg_block::get_block_by_name(string name); endfunction: get_block_by_name


// get_reg_by_name

function uvm_reg uvm_reg_block::get_reg_by_name(string name); endfunction: get_reg_by_name


// get_vreg_by_name

function uvm_vreg uvm_reg_block::get_vreg_by_name(string name); endfunction: get_vreg_by_name


// get_mem_by_name

function uvm_mem uvm_reg_block::get_mem_by_name(string name); endfunction: get_mem_by_name


// get_field_by_name

function uvm_reg_field uvm_reg_block::get_field_by_name(string name); endfunction: get_field_by_name


// get_vfield_by_name

function uvm_vreg_field uvm_reg_block::get_vfield_by_name(string name); endfunction: get_vfield_by_name



//-------------
// Coverage API
//-------------

// set_coverage

function uvm_reg_cvr_t uvm_reg_block::set_coverage(uvm_reg_cvr_t is_on); endfunction: set_coverage


// sample_values

function void uvm_reg_block::sample_values(); endfunction


// XsampleX

function void uvm_reg_block::XsampleX(uvm_reg_addr_t addr,
                                      bit            is_read,
                                      uvm_reg_map    map); endfunction


function uvm_reg_cvr_t uvm_reg_block::build_coverage(uvm_reg_cvr_t models); endfunction: build_coverage


// add_coverage

function void uvm_reg_block::add_coverage(uvm_reg_cvr_t models); endfunction: add_coverage


// has_coverage

function bit uvm_reg_block::has_coverage(uvm_reg_cvr_t models); endfunction: has_coverage


// get_coverage

function bit uvm_reg_block::get_coverage(uvm_reg_cvr_t is_on = UVM_CVR_ALL); endfunction: get_coverage


//----------------
// Run-Time Access
//----------------


// reset

function void uvm_reg_block::reset(string kind = "HARD"); endfunction


// needs_update

function bit uvm_reg_block::needs_update(); endfunction: needs_update


// update

task uvm_reg_block::update(output uvm_status_e  status,
                           input  uvm_door_e    path = UVM_DEFAULT_DOOR,
                           input  uvm_sequence_base  parent = null,
                           input  int                prior = -1,
                           input  uvm_object         extension = null,
                           input  string             fname = "",
                           input  int                lineno = 0); endtask: update


// mirror

task uvm_reg_block::mirror(output uvm_status_e       status,
                           input  uvm_check_e        check = UVM_NO_CHECK,
                           input  uvm_door_e         path = UVM_DEFAULT_DOOR,
                           input  uvm_sequence_base  parent = null,
                           input  int                prior = -1,
                           input  uvm_object         extension = null,
                           input  string             fname = "",
                           input  int                lineno = 0); endtask: mirror


// write_reg_by_name

task uvm_reg_block::write_reg_by_name(output uvm_status_e   status,
                                      input  string              name,
                                      input  uvm_reg_data_t      data,
                                      input  uvm_door_e     path = UVM_DEFAULT_DOOR,
                                      input  uvm_reg_map      map = null,
                                      input  uvm_sequence_base   parent = null,
                                      input  int                 prior = -1,
                                      input  uvm_object          extension = null,
                                      input  string              fname = "",
                                      input  int                 lineno = 0); endtask: write_reg_by_name


// read_reg_by_name

task uvm_reg_block::read_reg_by_name(output uvm_status_e  status,
                                     input  string             name,
                                     output uvm_reg_data_t     data,
                                     input  uvm_door_e    path = UVM_DEFAULT_DOOR,
                                     input  uvm_reg_map     map = null,
                                     input  uvm_sequence_base  parent = null,
                                     input  int                prior = -1,
                                     input  uvm_object         extension = null,
                                     input  string             fname = "",
                                     input  int                lineno = 0); endtask: read_reg_by_name


// write_mem_by_name

task uvm_reg_block::write_mem_by_name(output uvm_status_e  status,
                                          input  string             name,
                                          input  uvm_reg_addr_t     offset,
                                          input  uvm_reg_data_t     data,
                                          input  uvm_door_e    path = UVM_DEFAULT_DOOR,
                                          input  uvm_reg_map     map = null,
                                          input  uvm_sequence_base  parent = null,
                                          input  int                prior = -1,
                                          input  uvm_object         extension = null,
                                          input  string             fname = "",
                                          input  int                lineno = 0); endtask: write_mem_by_name


// read_mem_by_name

task uvm_reg_block::read_mem_by_name(output uvm_status_e  status,
                                         input  string             name,
                                         input  uvm_reg_addr_t     offset,
                                         output uvm_reg_data_t     data,
                                         input  uvm_door_e    path = UVM_DEFAULT_DOOR,
                                         input  uvm_reg_map     map = null,
                                         input  uvm_sequence_base  parent = null,
                                         input  int                prior = -1,
                                         input  uvm_object         extension = null,
                                         input  string             fname = "",
                                         input  int                lineno = 0); endtask: read_mem_by_name


// readmemh

task uvm_reg_block::readmemh(string filename); endtask: readmemh


// writememh

task uvm_reg_block::writememh(string filename); endtask: writememh


//---------------
// Map Management
//---------------

// create_map

function uvm_reg_map uvm_reg_block::create_map(string name,
                                               uvm_reg_addr_t base_addr,
                                               int unsigned n_bytes,
                                               uvm_endianness_e endian,
                                               bit byte_addressing=1); endfunction


// add_map

function void uvm_reg_block::add_map(uvm_reg_map map); endfunction: add_map


// get_map_by_name

function uvm_reg_map uvm_reg_block::get_map_by_name(string name); endfunction


// set_default_map

function void uvm_reg_block::set_default_map(uvm_reg_map map); endfunction


// get_default_map

function uvm_reg_map uvm_reg_block::get_default_map(); endfunction

`ifdef UVM_ENABLE_DEPRECATED_API
function uvm_path_e uvm_reg_block::get_default_path(); endfunction : get_default_path
`endif

// get_default_door

function uvm_door_e uvm_reg_block::get_default_door(); endfunction

// set_default_door

function void uvm_reg_block::set_default_door(uvm_door_e door); endfunction

// Xinit_address_mapsX

function void uvm_reg_block::Xinit_address_mapsX(); endfunction


//----------------
// Group- Backdoor
//----------------

// set_backdoor

function void uvm_reg_block::set_backdoor(uvm_reg_backdoor bkdr,
                                          string               fname = "",
                                          int                  lineno = 0); endfunction: set_backdoor


// get_backdoor

function uvm_reg_backdoor uvm_reg_block::get_backdoor(bit inherited = 1); endfunction: get_backdoor



// clear_hdl_path

function void uvm_reg_block::clear_hdl_path(string kind = "RTL"); endfunction


// add_hdl_path

function void uvm_reg_block::add_hdl_path(string path, string kind = "RTL"); endfunction


// has_hdl_path

function bit  uvm_reg_block::has_hdl_path(string kind = ""); endfunction


// get_hdl_path

function void uvm_reg_block::get_hdl_path(ref string paths[$], input string kind = ""); endfunction


// get_full_hdl_path

function void uvm_reg_block::get_full_hdl_path(ref string paths[$],
                                               input string kind = "",
                                               string separator = "."); endfunction


// get_default_hdl_path

function string uvm_reg_block::get_default_hdl_path(); endfunction


// set_default_hdl_path

function void uvm_reg_block::set_default_hdl_path(string kind); endfunction


// set_hdl_path_root

function void uvm_reg_block::set_hdl_path_root (string path, string kind = "RTL"); endfunction


// is_hdl_path_root

function bit  uvm_reg_block::is_hdl_path_root (string kind = ""); endfunction


//----------------------------------
// Group- Basic Object Operations
//----------------------------------

// do_print
function void uvm_reg_block::do_print (uvm_printer printer); endfunction



// clone

function uvm_object uvm_reg_block::clone(); endfunction

// do_copy

function void uvm_reg_block::do_copy(uvm_object rhs); endfunction


// do_compare

function bit uvm_reg_block::do_compare (uvm_object  rhs,
                                        uvm_comparer comparer); endfunction


// do_pack

function void uvm_reg_block::do_pack (uvm_packer packer); endfunction


// do_unpack

function void uvm_reg_block::do_unpack (uvm_packer packer); endfunction


// convert2string

function string uvm_reg_block::convert2string(); endfunction: convert2string
