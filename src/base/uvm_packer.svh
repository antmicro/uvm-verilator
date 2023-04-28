//
//------------------------------------------------------------------------------
// Copyright 2007-2014 Mentor Graphics Corporation
// Copyright 2014 Semifore
// Copyright 2018 Qualcomm, Inc.
// Copyright 2014 Intel Corporation
// Copyright 2018 Synopsys, Inc.
// Copyright 2007-2018 Cadence Design Systems, Inc.
// Copyright 2013-2018 NVIDIA Corporation
// Copyright 2017-2018 Cisco Systems, Inc.
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
// CLASS -- NODOCS -- uvm_packer
//
// The uvm_packer class provides a policy object for packing and unpacking
// uvm_objects. The policies determine how packing and unpacking should be done.
// Packing an object causes the object to be placed into a bit (byte or int)
// array. If the `uvm_field_* macro are used to implement pack and unpack,
// by default no metadata information is stored for the packing of dynamic
// objects (strings, arrays, class objects).
//
//-------------------------------------------------------------------------------

typedef bit signed [(`UVM_PACKER_MAX_BYTES*8)-1:0] uvm_pack_bitstream_t;

// Class: uvm_packer
// Implementation of uvm_packer, as defined in section
// 16.5.1 of 1800.2-2017

// @uvm-ieee 1800.2-2017 auto 16.5.1
class uvm_packer extends uvm_policy;

   // @uvm-ieee 1800.2-2017 auto 16.5.2.3
   `uvm_object_utils(uvm_packer)

    uvm_factory m_factory;



  // Function: set_packed_*
  // Implementation of P1800.2 16.5.3.1
  //
  // The LRM specifies the set_packed_* methods as being
  // signed, whereas the <uvm_object::unpack> methods are specified
  // as unsigned.  This is being tracked in Mantis 6423.
  //
  // The reference implementation has implemented these methods
  // as unsigned so as to remain consistent.
  //
  //| virtual function void set_packed_bits( ref bit unsigned stream[] );
  //| virtual function void set_packed_bytes( ref byte unsigned stream[] );
  //| virtual function void set_packed_ints( ref int unsigned stream[] );
  //| virtual function void set_packed_longints( ref longint unsigned stream[] );
  //
  // @uvm-contrib This API is being considered for potential contribution to 1800.2

  // @uvm-ieee 1800.2-2017 auto 16.5.3.1
  extern virtual function void set_packed_bits (ref bit unsigned stream[]);

  // @uvm-ieee 1800.2-2017 auto 16.5.3.1
  extern virtual function void set_packed_bytes (ref byte unsigned stream[]);

  // @uvm-ieee 1800.2-2017 auto 16.5.3.1
  extern virtual function void set_packed_ints (ref int unsigned stream[]);

  // @uvm-ieee 1800.2-2017 auto 16.5.3.1
  extern virtual function void set_packed_longints (ref longint unsigned stream[]);

  // Function: get_packed_*
  // Implementation of P1800.2 16.5.3.2
  //
  // The LRM specifies the get_packed_* methods as being
  // signed, whereas the <uvm_object::pack> methods are specified
  // as unsigned.  This is being tracked in Mantis 6423.
  //
  // The reference implementation has implemented these methods
  // as unsigned so as to remain consistent.
  //
  //| virtual function void get_packed_bits( ref bit unsigned stream[] );
  //| virtual function void get_packed_bytes( ref byte unsigned stream[] );
  //| virtual function void get_packed_ints( ref int unsigned stream[] );
  //| virtual function void get_packed_longints( ref longint unsigned stream[] );
  //
  // @uvm-contrib This API is being considered for potential contribution to 1800.2

  // @uvm-ieee 1800.2-2017 auto 16.5.3.2
  extern virtual function void get_packed_bits (ref bit unsigned stream[]);

  // @uvm-ieee 1800.2-2017 auto 16.5.3.2
  extern virtual function void get_packed_bytes (ref byte unsigned stream[]);

  // @uvm-ieee 1800.2-2017 auto 16.5.3.2
  extern virtual function void get_packed_ints (ref int unsigned stream[]);

  // @uvm-ieee 1800.2-2017 auto 16.5.3.2
  extern virtual function void get_packed_longints (ref longint unsigned stream[]);

  //----------------//
  // Group -- NODOCS -- Packing //
  //----------------//

  // @uvm-ieee 1800.2-2017 auto 16.5.2.4
  static function void set_default (uvm_packer packer) ;
  endfunction

  // @uvm-ieee 1800.2-2017 auto 16.5.2.5
  static function uvm_packer get_default () ;
  endfunction


  // @uvm-ieee 1800.2-2017 auto 16.5.2.2
  extern virtual function void flush ();
  // Function -- NODOCS -- pack_field
  //
  // Packs an integral value (less than or equal to 4096 bits) into the
  // packed array. ~size~ is the number of bits of ~value~ to pack.

  // @uvm-ieee 1800.2-2017 auto 16.5.4.8
  extern virtual function void pack_field (uvm_bitstream_t value, int size);


  // Function -- NODOCS -- pack_field_int
  //
  // Packs the integral value (less than or equal to 64 bits) into the
  // pack array.  The ~size~ is the number of bits to pack, usually obtained by
  // ~$bits~. This optimized version of <pack_field> is useful for sizes up
  // to 64 bits.

  // @uvm-ieee 1800.2-2017 auto 16.5.2.1
  extern function new(string name="");

  // @uvm-ieee 1800.2-2017 auto 16.5.4.9
  extern virtual function void pack_field_int (uvm_integral_t value, int size);


  // @uvm-ieee 1800.2-2017 auto 16.5.4.1
  extern virtual function void pack_bits(ref bit value[], input int size = -1);


  // @uvm-ieee 1800.2-2017 auto 16.5.4.10
  extern virtual function void pack_bytes(ref byte value[], input int size = -1);


  // @uvm-ieee 1800.2-2017 auto 16.5.4.11
  extern virtual function void pack_ints(ref int value[], input int size = -1);

  // recursion functions



  // Function -- NODOCS -- pack_string
  //
  // Packs a string value into the pack array.
  //
  // When the metadata flag is set, the packed string is terminated by a ~null~
  // character to mark the end of the string.
  //
  // This is useful for mixed language communication where unpacking may occur
  // outside of SystemVerilog UVM.

  // @uvm-ieee 1800.2-2017 auto 16.5.4.5
  extern virtual function void pack_string (string value);


  // Function -- NODOCS -- pack_time
  //
  // Packs a time ~value~ as 64 bits into the pack array.

  // @uvm-ieee 1800.2-2017 auto 16.5.4.6
  extern virtual function void pack_time (time value);


  // Function -- NODOCS -- pack_real
  //
  // Packs a real ~value~ as 64 bits into the pack array.
  //
  // The real ~value~ is converted to a 6-bit scalar value using the function
  // $real2bits before it is packed into the array.

  // @uvm-ieee 1800.2-2017 auto 16.5.4.7
  extern virtual function void pack_real (real value);


  // Function -- NODOCS -- pack_object
  //
  // Packs an object value into the pack array.
  //
  // A 4-bit header is inserted ahead of the string to indicate the number of
  // bits that was packed. If a ~null~ object was packed, then this header will
  // be 0.
  //
  // This is useful for mixed-language communication where unpacking may occur
  // outside of SystemVerilog UVM.

  // @uvm-ieee 1800.2-2017 auto 16.5.4.2
  extern virtual function void pack_object (uvm_object value);

  extern virtual function void pack_object_with_meta (uvm_object value);

  extern virtual function void pack_object_wrapper (uvm_object_wrapper value);


  //------------------//
  // Group -- NODOCS -- Unpacking //
  //------------------//

  // Function -- NODOCS -- is_null
  //
  // This method is used during unpack operations to peek at the next 4-bit
  // chunk of the pack data and determine if it is 0.
  //
  // If the next four bits are all 0, then the return value is a 1; otherwise
  // it is 0.
  //
  // This is useful when unpacking objects, to decide whether a new object
  // needs to be allocated or not.

  // @uvm-ieee 1800.2-2017 auto 16.5.4.3
  extern virtual function bit is_null ();


  extern virtual function bit is_object_wrapper();
  // Function -- NODOCS -- unpack_field
  //
  // Unpacks bits from the pack array and returns the bit-stream that was
  // unpacked. ~size~ is the number of bits to unpack; the maximum is 4096 bits.

  // @uvm-ieee 1800.2-2017 auto 16.5.4.16
  extern virtual function uvm_bitstream_t unpack_field (int size);

  // Function -- NODOCS -- unpack_field_int
  //
  // Unpacks bits from the pack array and returns the bit-stream that was
  // unpacked.
  //
  // ~size~ is the number of bits to unpack; the maximum is 64 bits.
  // This is a more efficient variant than unpack_field when unpacking into
  // smaller vectors.

  // @uvm-ieee 1800.2-2017 auto 16.5.4.17
  extern virtual function uvm_integral_t unpack_field_int (int size);


  // @uvm-ieee 1800.2-2017 auto 16.5.4.18
  extern virtual function void unpack_bits(ref bit value[], input int size = -1);


  // @uvm-ieee 1800.2-2017 auto 16.5.4.19
  extern virtual function void unpack_bytes(ref byte value[], input int size = -1);


  // @uvm-ieee 1800.2-2017 auto 16.5.4.12
  extern virtual function void unpack_ints(ref int value[], input int size = -1);


  // Function -- NODOCS -- unpack_string
  //
  // Unpacks a string.
  //
  // num_chars bytes are unpacked into a string. If num_chars is -1 then
  // unpacking stops on at the first ~null~ character that is encountered.

  // @uvm-ieee 1800.2-2017 auto 16.5.4.13
  extern virtual function string unpack_string ();


  // Function -- NODOCS -- unpack_time
  //
  // Unpacks the next 64 bits of the pack array and places them into a
  // time variable.

  // @uvm-ieee 1800.2-2017 auto 16.5.4.14
  extern virtual function time unpack_time ();


  // Function -- NODOCS -- unpack_real
  //
  // Unpacks the next 64 bits of the pack array and places them into a
  // real variable.
  //
  // The 64 bits of packed data are converted to a real using the $bits2real
  // system function.

  // @uvm-ieee 1800.2-2017 auto 16.5.4.15
  extern virtual function real unpack_real ();


  // Function -- NODOCS -- unpack_object
  //
  // Unpacks an object and stores the result into ~value~.
  //
  // ~value~ must be an allocated object that has enough space for the data
  // being unpacked. The first four bits of packed data are used to determine
  // if a ~null~ object was packed into the array.
  //
  // The <is_null> function can be used to peek at the next four bits in
  // the pack array before calling this method.

  // @uvm-ieee 1800.2-2017 auto 16.5.4.4
  extern virtual function void unpack_object (uvm_object value);

  extern virtual function void unpack_object_with_meta (inout uvm_object value);

  extern virtual function uvm_object_wrapper unpack_object_wrapper();


  // Function -- NODOCS -- get_packed_size
  //
  // Returns the number of bits that were packed.

  // @uvm-ieee 1800.2-2017 auto 16.5.3.3
  extern virtual function int get_packed_size();


  //------------------//
  // Group -- NODOCS -- Variables //
  //------------------//

`ifdef UVM_ENABLE_DEPRECATED_API
  // Variable -- NODOCS -- physical
  //
  // This bit provides a filtering mechanism for fields.
  //
  // The <abstract> and physical settings allow an object to distinguish between
  // two different classes of fields. It is up to you, in the
  // <uvm_object::do_pack> and <uvm_object::do_unpack> methods, to test the
  // setting of this field if you want to use it as a filter.

  bit physical = 1;


  // Variable -- NODOCS -- abstract
  //
  // This bit provides a filtering mechanism for fields.
  //
  // The abstract and physical settings allow an object to distinguish between
  // two different classes of fields. It is up to you, in the
  // <uvm_object::do_pack> and <uvm_object::do_unpack> routines, to test the
  // setting of this field if you want to use it as a filter.

  bit abstract;


  // Variable -- NODOCS -- big_endian
  //
  // This bit determines the order that integral data is packed (using
  // <pack_field>, <pack_field_int>, <pack_time>, or <pack_real>) and how the
  // data is unpacked from the pack array (using <unpack_field>,
  // <unpack_field_int>, <unpack_time>, or <unpack_real>). When the bit is set,
  // data is associated msb to lsb; otherwise, it is associated lsb to msb.
  //
  // The following code illustrates how data can be associated msb to lsb and
  // lsb to msb:
  //
  //|  class mydata extends uvm_object;
  //|
  //|    logic[15:0] value = 'h1234;
  //|
  //|    function void do_pack (uvm_packer packer);
  //|      packer.pack_field_int(value, 16);
  //|    endfunction
  //|
  //|    function void do_unpack (uvm_packer packer);
  //|      value = packer.unpack_field_int(16);
  //|    endfunction
  //|  endclass
  //|
  //|  mydata d = new;
  //|  bit bits[];
  //|
  //|  initial begin
  //|    d.pack(bits);  // 'b0001001000110100
  //|    uvm_default_packer.big_endian = 0;
  //|    d.pack(bits);  // 'b0010110001001000
  //|  end

  bit big_endian = 0;
`endif

  // variables and methods primarily for internal use

  static bit bitstream[];   // local bits for (un)pack_bytes
  static bit fabitstream[]; // field automation bits for (un)pack_bytes
  int        m_pack_iter; // Used to track the bit of the next pack
  int        m_unpack_iter; // Used to track the bit of the next unpack

  bit   reverse_order;      //flip the bit order around
  byte  byte_size     = 8;  //set up bytesize for endianess
  int   word_size     = 16; //set up worksize for endianess
  bit   nopack;             //only count packable bits

  uvm_pack_bitstream_t m_bits;


`ifdef UVM_ENABLE_DEPRECATED_API
  extern virtual function bit  unsigned get_bit  (int unsigned index);
  extern virtual function byte unsigned get_byte (int unsigned index);
  extern virtual function int  unsigned get_int  (int unsigned index);

  extern virtual function void get_bits (ref bit unsigned bits[]);
  extern virtual function void get_bytes(ref byte unsigned bytes[]);
  extern virtual function void get_ints (ref int unsigned ints[]);

  extern virtual function void put_bits (ref bit unsigned bitstream[]);
  extern virtual function void put_bytes(ref byte unsigned bytestream[]);
  extern virtual function void put_ints (ref int unsigned intstream[]);

  extern virtual function void set_packed_size();
`endif

  extern function void index_error(int index, string id, int sz);
  extern function bit enough_bits(int needed, string id);

`ifdef UVM_ENABLE_DEPRECATED_API
  extern function void reset();
`endif

endclass



//------------------------------------------------------------------------------
// IMPLEMENTATION
//------------------------------------------------------------------------------

// NOTE- max size limited to BITSTREAM bits parameter (default: 4096)


// index_ok
// --------

function void uvm_packer::index_error(int index, string id, int sz); endfunction


// enough_bits
// -----------

function bit uvm_packer::enough_bits(int needed, string id); endfunction


// get_packed_size
// ---------------

function int uvm_packer::get_packed_size(); endfunction


`ifdef UVM_ENABLE_DEPRECATED_API
// set_packed_size
// ---------------

function void uvm_packer::set_packed_size();
  /* doesn't actually do anything now */
endfunction

// reset
// -----

function void uvm_packer::reset(); endfunction

function void uvm_packer::get_bits( ref bit bits [] ); endfunction
function void uvm_packer::get_bytes( ref byte unsigned bytes [] ); endfunction
function void uvm_packer::get_ints( ref int unsigned ints [] ); endfunction
`endif

function void uvm_packer::flush(); endfunction : flush

// get_packed_bits
// --------

function void uvm_packer::get_packed_bits(ref bit unsigned stream[]); endfunction

`ifdef UVM_ENABLE_DEPRECATED_API
// When deprecated, we support big_endian
`define M__UVM_GET_PACKED(T) \
function void uvm_packer::get_packed_``T``s (ref T unsigned stream[] ); endfunction 
`else // !`ifdef UVM_ENABLE_DEPRECATED_API
`define M__UVM_GET_PACKED(T) \
function void uvm_packer::get_packed_``T``s (ref T unsigned stream[] ); endfunction 
`endif // !`ifdef UVM_ENABLE_DEPRECATED_API

`M__UVM_GET_PACKED(byte)
`M__UVM_GET_PACKED(int)
`M__UVM_GET_PACKED(longint)

`undef M__UVM_GET_PACKED

`ifdef UVM_ENABLE_DEPRECATED_API
function void uvm_packer::put_bits( ref bit bitstream [] ); endfunction
function void uvm_packer::put_bytes( ref byte unsigned bytestream [] ); endfunction
function void uvm_packer::put_ints( ref int unsigned intstream [] ); endfunction
`endif

// set_packed_bits
// --------

function void uvm_packer::set_packed_bits (ref bit stream []); endfunction

`ifdef UVM_ENABLE_DEPRECATED_API
// In deprecated mode we support big_endian
`define M__UVM_SET_PACKED(T) \
function void uvm_packer::set_packed_``T``s (ref T unsigned stream []); endfunction 
`else // !`ifdef UVM_ENABLE_DEPRECATED_API
`define M__UVM_SET_PACKED(T) \
function void uvm_packer::set_packed_``T``s (ref T unsigned stream []); endfunction 
`endif

`M__UVM_SET_PACKED(byte)
`M__UVM_SET_PACKED(int)
`M__UVM_SET_PACKED(longint)

`undef M__UVM_SET_PACKED

`ifdef UVM_ENABLE_DEPRECATED_API
// get_bit
// -------

function bit unsigned uvm_packer::get_bit(int unsigned index); endfunction


// get_byte
// --------

function byte unsigned uvm_packer::get_byte(int unsigned index); endfunction


// get_int
// -------

function int unsigned uvm_packer::get_int(int unsigned index); endfunction
`endif

// PACK


// pack_object
// ---------

function void uvm_packer::pack_object(uvm_object value); endfunction

// Function: pack_object_with_meta
// Packs ~obj~ into the packer data stream, such that
// it can be unpacked via an associated <unpack_object_with_meta>
// call.
//
// Unlike <pack_object>, the pack_object_with_meta method keeps track
// of what objects have already been packed in this call chain.  The
// first time an object is passed to pack_object_with_meta after a
// call to <flush>, the object is assigned a unique id.  Subsequent
// calls to pack_object_with_meta will only add the unique id to the
// stream.  This allows structural information to be maintained through
// pack/unpack operations.
//
// Note: pack_object_with_meta is not compatible with <unpack_object>
// and <is_null>.  The object can only be unpacked via 
// <unpack_object_with_meta>.
//
// @uvm-contrib This API is being considered for potential contribution to 1800.2
function void uvm_packer::pack_object_with_meta(uvm_object value); endfunction


function void uvm_packer::pack_object_wrapper(uvm_object_wrapper value); endfunction   
// pack_real
// ---------

function void uvm_packer::pack_real(real value); endfunction
  

// pack_time
// ---------

function void uvm_packer::pack_time(time value); endfunction
  

// pack_field
// ----------

function void uvm_packer::pack_field(uvm_bitstream_t value, int size); endfunction
  

// pack_field_int
// --------------

function void uvm_packer::pack_field_int(uvm_integral_t value, int size); endfunction
  
// pack_bits
// -----------------

function void uvm_packer::pack_bits(ref bit value[], input int size = -1); endfunction 

// pack_bytes
// -----------------

function void uvm_packer::pack_bytes(ref byte value[], input int size = -1); endfunction 

// pack_ints
// -----------------

function void uvm_packer::pack_ints(ref int value[], input int size = -1); endfunction 


// pack_string
// -----------

function void uvm_packer::pack_string(string value); endfunction 


// UNPACK


// is_null
// -------

function bit uvm_packer::is_null(); endfunction


function bit uvm_packer::is_object_wrapper(); endfunction
// unpack_object
// -------------

function void uvm_packer::unpack_object(uvm_object value); endfunction

// Function: unpack_object_with_meta
// Unpacks an object which was packed into the packer data
// stream using <pack_object_with_meta>.
//
// Unlike <unpack_object>, the unpack_object_with_meta method keeps track
// of what objects have already been unpacked in this call chain.  If the
// packed object was null, then ~value~ is set to null.  Otherwise, if this
// is the first time the object's unique id  
// has been encountered since a call to <flush>,
// then unpack_object_with_meta checks ~value~ to determine if it is the
// correct type.  If it is not the correct type, or if ~value~ is null, 
// then the packer shall create a new object instance for the unpack operation, 
// using the data provided by <pack_object_with_meta>. If ~value~ is of the 
// correct type, then it is used as the object instance for the unpack operation.
// Subsequent calls to unpack_object_with_meta for this unique id shall
// simply set ~value~ to this object instance.
//
// Note: unpack_object_with_meta is not compatible with <pack_object>
// or <is_null>.  The object must have been packed via
// <pack_object_with_meta>.
//
// @uvm-contrib This API is being considered for potential contribution to 1800.2
function void uvm_packer::unpack_object_with_meta(inout uvm_object value); endfunction


function uvm_object_wrapper uvm_packer::unpack_object_wrapper(); endfunction
  
// unpack_real
// -----------

function real uvm_packer::unpack_real(); endfunction
  

// unpack_time
// -----------

function time uvm_packer::unpack_time(); endfunction
  

// unpack_field
// ------------

function uvm_bitstream_t uvm_packer::unpack_field(int size); endfunction
  

// unpack_field_int
// ----------------

function uvm_integral_t uvm_packer::unpack_field_int(int size); endfunction
  
// unpack_bits
// -------------------

function void uvm_packer::unpack_bits(ref bit value[], input int size = -1); endfunction

// unpack_bytes
// -------------------

function void uvm_packer::unpack_bytes(ref byte value[], input int size = -1); endfunction

// unpack_ints
// -------------------

function void uvm_packer::unpack_ints(ref int value[], input int size = -1); endfunction


// unpack_string
// -------------

// If num_chars is not -1, then the user only wants to unpack a
// specific number of bytes into the string.
function string uvm_packer::unpack_string(); endfunction 


// Constructor implementation
function uvm_packer::new(string name=""); endfunction


