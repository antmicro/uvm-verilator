//----------------------------------------------------------------------
// Copyright 2010-2012 Mentor Graphics Corporation
// Copyright 2014 Semifore
// Copyright 2010-2018 Synopsys, Inc.
// Copyright 2010-2018 Cadence Design Systems, Inc.
// Copyright 2013-2018 NVIDIA Corporation
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

//----------------------------------------------------------------------
// Title -- NODOCS -- UVM TLM Generic Payload & Extensions
//----------------------------------------------------------------------
// The Generic Payload transaction represents a generic 
// bus read/write access. It is used as the default transaction in
// TLM2 blocking and nonblocking transport interfaces.
//----------------------------------------------------------------------


//---------------
// Group -- NODOCS -- Globals
//---------------
//
// Defines, Constants, enums.


// Enum -- NODOCS -- uvm_tlm_command_e
//
// Command attribute type definition
//
// UVM_TLM_READ_COMMAND      - Bus read operation
//
// UVM_TLM_WRITE_COMMAND     - Bus write operation
//
// UVM_TLM_IGNORE_COMMAND    - No bus operation.

typedef enum
{
    UVM_TLM_READ_COMMAND,
    UVM_TLM_WRITE_COMMAND,
    UVM_TLM_IGNORE_COMMAND
} uvm_tlm_command_e;


// Enum -- NODOCS -- uvm_tlm_response_status_e
//
// Response status attribute type definition
//
// UVM_TLM_OK_RESPONSE                - Bus operation completed successfully
//
// UVM_TLM_INCOMPLETE_RESPONSE        - Transaction was not delivered to target
//
// UVM_TLM_GENERIC_ERROR_RESPONSE     - Bus operation had an error
//
// UVM_TLM_ADDRESS_ERROR_RESPONSE     - Invalid address specified
//
// UVM_TLM_COMMAND_ERROR_RESPONSE     - Invalid command specified
//
// UVM_TLM_BURST_ERROR_RESPONSE       - Invalid burst specified
//
// UVM_TLM_BYTE_ENABLE_ERROR_RESPONSE - Invalid byte enabling specified
//

typedef enum
{
    UVM_TLM_OK_RESPONSE = 1,
    UVM_TLM_INCOMPLETE_RESPONSE = 0,
    UVM_TLM_GENERIC_ERROR_RESPONSE = -1,
    UVM_TLM_ADDRESS_ERROR_RESPONSE = -2,
    UVM_TLM_COMMAND_ERROR_RESPONSE = -3,
    UVM_TLM_BURST_ERROR_RESPONSE = -4,
    UVM_TLM_BYTE_ENABLE_ERROR_RESPONSE = -5
} uvm_tlm_response_status_e;


typedef class uvm_tlm_extension_base;


//-----------------------
// Group -- NODOCS -- Generic Payload
//-----------------------

//----------------------------------------------------------------------
// Class: uvm_tlm_generic_payload
//
// Implementation of uvm_tlm_generic_payload, as described in
// section 12.3.4.2.1 of 1800.2-2017.
//----------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto 12.3.4.2.1
class uvm_tlm_generic_payload extends uvm_sequence_item;
   
   // Variable -- NODOCS -- m_address
   //
   // Address for the bus operation.
   // Should be set or read using the <set_address> and <get_address>
   // methods. The variable should be used only when constraining.
   //
   // For a read command or a write command, the target shall
   // interpret the current value of the address attribute as the start
   // address in the system memory map of the contiguous block of data
   // being read or written.
   // The address associated with any given byte in the data array is
   // dependent upon the address attribute, the array index, the
   // streaming width attribute, the endianness and the width of the physical bus.
   //
   // If the target is unable to execute the transaction with
   // the given address attribute (because the address is out-of-range,
   // for example) it shall generate a standard error response. The
   // recommended response status is ~UVM_TLM_ADDRESS_ERROR_RESPONSE~.
   //
   rand bit [63:0]             m_address;

 
   // Variable -- NODOCS -- m_command
   //
   // Bus operation type.
   // Should be set using the <set_command>, <set_read> or <set_write> methods
   // and read using the <get_command>, <is_read> or <is_write> methods.
   // The variable should be used only when constraining.
   //
   // If the target is unable to execute a read or write command, it
   // shall generate a standard error response. The
   // recommended response status is UVM_TLM_COMMAND_ERROR_RESPONSE.
   //
   // On receipt of a generic payload transaction with the command
   // attribute equal to UVM_TLM_IGNORE_COMMAND, the target shall not execute
   // a write command or a read command not modify any data.
   // The target may, however, use the value of any attribute in
   // the generic payload, including any extensions.
   //
   // The command attribute shall be set by the initiator, and shall
   // not be overwritten by any interconnect
   //
   rand uvm_tlm_command_e          m_command;

   
   // Variable -- NODOCS -- m_data
   //
   // Data read or to be written.
   // Should be set and read using the <set_data> or <get_data> methods
   // The variable should be used only when constraining.
   //
   // For a read command or a write command, the target shall copy data
   // to or from the data array, respectively, honoring the semantics of
   // the remaining attributes of the generic payload.
   //
   // For a write command or UVM_TLM_IGNORE_COMMAND, the contents of the
   // data array shall be set by the initiator, and shall not be
   // overwritten by any interconnect component or target. For a read
   // command, the contents of the data array shall be overwritten by the
   // target (honoring the semantics of the byte enable) but by no other
   // component.
   //
   // Unlike the OSCI TLM-2.0 LRM, there is no requirement on the endiannes
   // of multi-byte data in the generic payload to match the host endianness.
   // Unlike C++, it is not possible in SystemVerilog to cast an arbitrary
   // data type as an array of bytes. Therefore, matching the host
   // endianness is not necessary. In contrast, arbitrary data types may be
   // converted to and from a byte array using the streaming operator and
   // <uvm_object> objects may be further converted using the
   // <uvm_object::pack_bytes()> and <uvm_object::unpack_bytes()> methods.
   // All that is required is that a consistent mechanism is used to
   // fill the payload data array and later extract data from it.
   //
   // Should a generic payload be transferred to/from a SystemC model,
   // it will be necessary for any multi-byte data in that generic payload
   // to use/be interpreted using the host endianness.
   // However, this process is currently outside the scope of this standard.
   //
   rand byte unsigned             m_data[];


   // Variable -- NODOCS -- m_length
   //
   // The number of bytes to be copied to or from the <m_data> array,
   // inclusive of any bytes disabled by the <m_byte_enable> attribute.
   //
   // The data length attribute shall be set by the initiator,
   // and shall not be overwritten by any interconnect component or target.
   //
   // The data length attribute shall not be set to 0.
   // In order to transfer zero bytes, the <m_command> attribute
   // should be set to <UVM_TLM_IGNORE_COMMAND>.
   //
   rand int unsigned           m_length;
   

   // Variable -- NODOCS -- m_response_status
   //
   // Status of the bus operation.
   // Should be set using the <set_response_status> method
   // and read using the <get_response_status>, <get_response_string>,
   // <is_response_ok> or <is_response_error> methods.
   // The variable should be used only when constraining.
   //
   // The response status attribute shall be set to
   // UVM_TLM_INCOMPLETE_RESPONSE by the initiator, and may
   // be overwritten by the target. The response status attribute
   // should not be overwritten by any interconnect
   // component, because the default value UVM_TLM_INCOMPLETE_RESPONSE
   // indicates that the transaction was not delivered to the target.
   //
   // The target may set the response status attribute to UVM_TLM_OK_RESPONSE
   // to indicate that it was able to execute the command
   // successfully, or to one of the five error responses
   // to indicate an error. The target should choose the appropriate
   // error response depending on the cause of the error.
   // If a target detects an error but is unable to select a specific
   // error response, it may set the response status to
   // UVM_TLM_GENERIC_ERROR_RESPONSE.
   //
   // The target shall be responsible for setting the response status
   // attribute at the appropriate point in the
   // lifetime of the transaction. In the case of the blocking
   // transport interface, this means before returning
   // control from b_transport. In the case of the non-blocking
   // transport interface and the base protocol, this
   // means before sending the BEGIN_RESP phase or returning a value of UVM_TLM_COMPLETED.
   //
   // It is recommended that the initiator should always check the
   // response status attribute on receiving a
   // transition to the BEGIN_RESP phase or after the completion of
   // the transaction. An initiator may choose
   // to ignore the response status if it is known in advance that the
   // value will be UVM_TLM_OK_RESPONSE,
   // perhaps because it is known in advance that the initiator is
   // only connected to targets that always return
   // UVM_TLM_OK_RESPONSE, but in general this will not be the case. In
   // other words, the initiator ignores the
   // response status at its own risk.
   //
   rand uvm_tlm_response_status_e  m_response_status;


   // Variable -- NODOCS -- m_dmi
   //
   // DMI mode is not yet supported in the UVM TLM2 subset.
   // This variable is provided for completeness and interoperability
   // with SystemC.
   //
   bit m_dmi;
   

   // Variable -- NODOCS -- m_byte_enable
   //
   // Indicates valid <m_data> array elements.
   // Should be set and read using the <set_byte_enable> or <get_byte_enable> methods
   // The variable should be used only when constraining.
   //
   // The elements in the byte enable array shall be interpreted as
   // follows. A value of 8'h00 shall indicate that that
   // corresponding byte is disabled, and a value of 8'hFF shall
   // indicate that the corresponding byte is enabled.
   //
   // Byte enables may be used to create burst transfers where the
   // address increment between each beat is
   // greater than the number of significant bytes transferred on each
   // beat, or to place words in selected byte
   // lanes of a bus. At a more abstract level, byte enables may be
   // used to create "lacy bursts" where the data array of the generic
   // payload has an arbitrary pattern of holes punched in it.
   //
   // The byte enable mask may be defined by a small pattern applied
   // repeatedly or by a large pattern covering the whole data array.
   // The byte enable array may be empty, in which case byte enables
   // shall not be used for the current transaction.
   //
   // The byte enable array shall be set by the initiator and shall
   // not be overwritten by any interconnect component or target.
   //
   // If the byte enable pointer is not empty, the target shall either
   // implement the semantics of the byte enable as defined below or
   // shall generate a standard error response. The recommended response
   // status is UVM_TLM_BYTE_ENABLE_ERROR_RESPONSE.
   //
   // In the case of a write command, any interconnect component or
   // target should ignore the values of any disabled bytes in the
   // <m_data> array. In the case of a read command, any interconnect
   // component or target should not modify the values of disabled
   // bytes in the <m_data> array.
   //
   rand byte unsigned          m_byte_enable[];


   // Variable -- NODOCS -- m_byte_enable_length
   //
   // The number of elements in the <m_byte_enable> array.
   //
   // It shall be set by the initiator, and shall not be overwritten
   // by any interconnect component or target.
   //
   rand int unsigned m_byte_enable_length;


   // Variable -- NODOCS -- m_streaming_width
   //    
   // Number of bytes transferred on each beat.
   // Should be set and read using the <set_streaming_width> or
   // <get_streaming_width> methods
   // The variable should be used only when constraining.
   //
   // Streaming affects the way a component should interpret the data
   // array. A stream consists of a sequence of data transfers occurring
   // on successive notional beats, each beat having the same start
   // address as given by the generic payload address attribute. The
   // streaming width attribute shall determine the width of the stream,
   // that is, the number of bytes transferred on each beat. In other
   // words, streaming affects the local address associated with each
   // byte in the data array. In all other respects, the organization of
   // the data array is unaffected by streaming.
   //
   // The bytes within the data array have a corresponding sequence of
   // local addresses within the component accessing the generic payload
   // transaction. The lowest address is given by the value of the
   // address attribute. The highest address is given by the formula
   // address_attribute + streaming_width - 1. The address to or from
   // which each byte is being copied in the target shall be set to the
   // value of the address attribute at the start of each beat.
   //
   // With respect to the interpretation of the data array, a single
   // transaction with a streaming width shall be functionally equivalent
   // to a sequence of transactions each having the same address as the
   // original transaction, each having a data length attribute equal to
   // the streaming width of the original, and each with a data array
   // that is a different subset of the original data array on each
   // beat. This subset effectively steps down the original data array
   // maintaining the sequence of bytes.
   //
   // A streaming width of 0 indicates that a streaming transfer
   // is not required. it is equivalent to a streaming width 
   // value greater than or equal to the size of the <m_data> array.
   //
   // Streaming may be used in conjunction with byte enables, in which
   // case the streaming width would typically be equal to the byte
   // enable length. It would also make sense to have the streaming width
   // a multiple of the byte enable length. Having the byte enable length
   // a multiple of the streaming width would imply that different bytes
   // were enabled on each beat.
   //
   // If the target is unable to execute the transaction with the
   // given streaming width, it shall generate a standard error
   // response. The recommended response status is
   // TLM_BURST_ERROR_RESPONSE.
   //
   rand int unsigned m_streaming_width;

   protected uvm_tlm_extension_base m_extensions [uvm_tlm_extension_base];
   local rand uvm_tlm_extension_base m_rand_exts[];


   `uvm_object_utils(uvm_tlm_generic_payload)


  // Function -- NODOCS -- new
  //
  // Create a new instance of the generic payload.  Initialize all the
  // members to their default values.

  // @uvm-ieee 1800.2-2017 auto 12.3.4.2.3
  function new(string name=""); endfunction


  // Function- do_print
  //
  function void do_print(uvm_printer printer); endfunction


  // Function- do_copy
  //
  function void do_copy(uvm_object rhs); endfunction
   
`define m_uvm_tlm_fast_compare_int(VALUE,RADIX,NAME="") \
  if ( (!comparer.get_threshold() || (comparer.get_result() < comparer.get_threshold())) && \
      ((VALUE) != (gp.VALUE)) ) begin \
     string name = (NAME == "") ? `"VALUE`" : NAME; \
        void'(comparer.compare_field_int(name , VALUE, gp.VALUE, $bits(VALUE), RADIX)); \
  end 

`define m_uvm_tlm_fast_compare_enum(VALUE,TYPE,NAME="") \
  if ( (!comparer.get_threshold() || (comparer.get_result() < comparer.get_threshold())) && \
      ((VALUE) != (gp.VALUE)) ) begin \
        string name = (NAME == "") ? `"VALUE`" : NAME; \
        void'( comparer.compare_string(name, \
				$sformatf("%s'(%s)", `"TYPE`", VALUE.name()), \
				$sformatf("%s'(%s)", `"TYPE`", gp.VALUE.name())) ); \
  end 

  // Function: do_compare
  // Compares this generic payload to ~rhs~.
  //
  // The <do_compare> method compares the fields of this instance to
  // to those of ~rhs~.  All fields are compared, however if byte 
  // enables are being used, then non-enabled bytes of data are
  // skipped.
  //
  // @uvm-contrib This API is being considered for potential contribution to 1800.2
  
  function bit do_compare(uvm_object rhs, uvm_comparer comparer); endfunction

`undef m_uvm_tlm_fast_compare_int
`undef m_uvm_tlm_fast_compare_enum

  // Function: do_pack
  // Packs the fields of the payload in ~packer~.
  //
  // Fields are packed in the following order:
  // - <m_address>
  // - <m_command>
  // - <m_length>
  // - <m_dmi>
  // - <m_data> (if <m_length> is greater than 0)
  // - <m_response_status>
  // - <m_byte_enable_length>
  // - <m_byte_enable> (if <m_byte_enable_length> is greater than 0)
  // - <m_streaming_width>
  //
  // Only <m_length> bytes of the <m_data> array are packed,
  // and a fatal message is generated if ~m_data.size()~ is less
  // than <m_length>.  The same is true for <m_byte_enable_length>
  // and <m_byte_enable>.
  //
  // Note: The extensions are not packed.
  //
  // @uvm-contrib This API is being considered for potential contribution to 1800.2
  
  function void do_pack(uvm_packer packer); endfunction


  // Function: do_unpack
  // Unpacks the fields of the payload from ~packer~.
  // 
  // The <m_data>/<m_byte_enable> arrays are reallocated if the
  // new size is greater than their current size; otherwise the
  // existing array allocations are kept.
  //
  // Note: The extensions are not unpacked.
  //
  // @uvm-contrib This API is being considered for potential contribution to 1800.2
  function void do_unpack(uvm_packer packer); endfunction


  // Function- do_record
  //
  function void do_record(uvm_recorder recorder); endfunction


  // Function- convert2string
  //
  function string convert2string(); endfunction


  //--------------------------------------------------------------------
  // Group -- NODOCS -- Accessors
  //
  // The accessor functions let you set and get each of the members of the 
  // generic payload. All of the accessor methods are virtual. This implies 
  // a slightly different use model for the generic payload than 
  // in SystemC. The way the generic payload is defined in SystemC does 
  // not encourage you to create new transaction types derived from 
  // uvm_tlm_generic_payload. Instead, you would use the extensions mechanism. 
  // Thus in SystemC none of the accessors are virtual.
  //--------------------------------------------------------------------

   // Function -- NODOCS -- get_command
   //
   // Get the value of the <m_command> variable

  // @uvm-ieee 1800.2-2017 auto 12.3.4.2.13
  virtual function uvm_tlm_command_e get_command(); endfunction

   // Function -- NODOCS -- set_command
   //
   // Set the value of the <m_command> variable
   
  // @uvm-ieee 1800.2-2017 auto 12.3.4.2.14
  virtual function void set_command(uvm_tlm_command_e command); endfunction

   // Function -- NODOCS -- is_read
   //
   // Returns true if the current value of the <m_command> variable
   // is ~UVM_TLM_READ_COMMAND~.
   
  // @uvm-ieee 1800.2-2017 auto 12.3.4.2.15
  virtual function bit is_read(); endfunction
 
   // Function -- NODOCS -- set_read
   //
   // Set the current value of the <m_command> variable
   // to ~UVM_TLM_READ_COMMAND~.
   
  // @uvm-ieee 1800.2-2017 auto 12.3.4.2.16
  virtual function void set_read(); endfunction

   // Function -- NODOCS -- is_write
   //
   // Returns true if the current value of the <m_command> variable
   // is ~UVM_TLM_WRITE_COMMAND~.
 
  // @uvm-ieee 1800.2-2017 auto 12.3.4.2.17
  virtual function bit is_write(); endfunction
 
   // Function -- NODOCS -- set_write
   //
   // Set the current value of the <m_command> variable
   // to ~UVM_TLM_WRITE_COMMAND~.

  // @uvm-ieee 1800.2-2017 auto 12.3.4.2.18
  virtual function void set_write(); endfunction
  

  // @uvm-ieee 1800.2-2017 auto 12.3.4.2.20
  virtual function void set_address(bit [63:0] addr); endfunction

   // Function -- NODOCS -- get_address
   //
   // Get the value of the <m_address> variable
 
  virtual function bit [63:0] get_address(); endfunction

   // Function -- NODOCS -- get_data
   //
   // Return the value of the <m_data> array
 
  // @uvm-ieee 1800.2-2017 auto 12.3.4.2.21
  virtual function void get_data (output byte unsigned p []); endfunction

   // Function -- NODOCS -- set_data
   //
   // Set the value of the <m_data> array  

  // @uvm-ieee 1800.2-2017 auto 12.3.4.2.22
  virtual function void set_data(ref byte unsigned p []); endfunction 
  
   // Function -- NODOCS -- get_data_length
   //
   // Return the current size of the <m_data> array
   
  virtual function int unsigned get_data_length(); endfunction

  // Function -- NODOCS -- set_data_length
  // Set the value of the <m_length>
   
   // @uvm-ieee 1800.2-2017 auto 12.3.4.2.24
   virtual function void set_data_length(int unsigned length); endfunction

   // Function -- NODOCS -- get_streaming_width
   //
   // Get the value of the <m_streaming_width> array
  
  virtual function int unsigned get_streaming_width(); endfunction

 
   // Function -- NODOCS -- set_streaming_width
   //
   // Set the value of the <m_streaming_width> array
   
  // @uvm-ieee 1800.2-2017 auto 12.3.4.2.26
  virtual function void set_streaming_width(int unsigned width); endfunction


  // @uvm-ieee 1800.2-2017 auto 12.3.4.2.27
  virtual function void get_byte_enable(output byte unsigned p[]); endfunction

   // Function -- NODOCS -- set_byte_enable
   //
   // Set the value of the <m_byte_enable> array
   
  // @uvm-ieee 1800.2-2017 auto 12.3.4.2.28
  virtual function void set_byte_enable(ref byte unsigned p[]); endfunction

   // Function -- NODOCS -- get_byte_enable_length
   //
   // Return the current size of the <m_byte_enable> array
   
  virtual function int unsigned get_byte_enable_length(); endfunction

   // Function -- NODOCS -- set_byte_enable_length
   //
   // Set the size <m_byte_enable_length> of the <m_byte_enable> array
   // i.e.  <m_byte_enable>.size()
   
 // @uvm-ieee 1800.2-2017 auto 12.3.4.2.30
 virtual function void set_byte_enable_length(int unsigned length); endfunction

   // Function -- NODOCS -- set_dmi_allowed
   //
   // DMI hint. Set the internal flag <m_dmi> to allow dmi access
   
  // @uvm-ieee 1800.2-2017 auto 12.3.4.2.31
  virtual function void set_dmi_allowed(bit dmi); endfunction
   
   // Function -- NODOCS -- is_dmi_allowed
   //
   // DMI hint. Query the internal flag <m_dmi> if allowed dmi access 

 // @uvm-ieee 1800.2-2017 auto 12.3.4.2.32
 virtual function bit is_dmi_allowed(); endfunction

   // Function -- NODOCS -- get_response_status
   //
   // Return the current value of the <m_response_status> variable
   
  // @uvm-ieee 1800.2-2017 auto 12.3.4.2.33
  virtual function uvm_tlm_response_status_e get_response_status(); endfunction

   // Function -- NODOCS -- set_response_status
   //
   // Set the current value of the <m_response_status> variable

  // @uvm-ieee 1800.2-2017 auto 12.3.4.2.34
  virtual function void set_response_status(uvm_tlm_response_status_e status); endfunction

   // Function -- NODOCS -- is_response_ok
   //
   // Return TRUE if the current value of the <m_response_status> variable
   // is ~UVM_TLM_OK_RESPONSE~

  // @uvm-ieee 1800.2-2017 auto 12.3.4.2.35
  virtual function bit is_response_ok(); endfunction

   // Function -- NODOCS -- is_response_error
   //
   // Return TRUE if the current value of the <m_response_status> variable
   // is not ~UVM_TLM_OK_RESPONSE~

  // @uvm-ieee 1800.2-2017 auto 12.3.4.2.36
  virtual function bit is_response_error(); endfunction

   // Function -- NODOCS -- get_response_string
   //
   // Return the current value of the <m_response_status> variable
   // as a string

  // @uvm-ieee 1800.2-2017 auto 12.3.4.2.37
  virtual function string get_response_string(); endfunction

  //--------------------------------------------------------------------
  // Group -- NODOCS -- Extensions Mechanism
  //
  //--------------------------------------------------------------------

  // Function -- NODOCS -- set_extension
  //
  // Add an instance-specific extension. Only one instance of any given
  // extension type is allowed. If there is an existing extension
  // instance of the type of ~ext~, ~ext~ replaces it and its handle
  // is returned. Otherwise, ~null~ is returned.
   
  // @uvm-ieee 1800.2-2017 auto 12.3.4.2.41
  function uvm_tlm_extension_base set_extension(uvm_tlm_extension_base ext); endfunction


  // Function -- NODOCS -- get_num_extensions
  //
  // Return the current number of instance specific extensions.
   
  // @uvm-ieee 1800.2-2017 auto 12.3.4.2.39
  function int get_num_extensions(); endfunction: get_num_extensions
   

  // Function -- NODOCS -- get_extension
  //
  // Return the instance specific extension bound under the specified key.
  // If no extension is bound under that key, ~null~ is returned.
   
  // @uvm-ieee 1800.2-2017 auto 12.3.4.2.40
  function uvm_tlm_extension_base get_extension(uvm_tlm_extension_base ext_handle); endfunction
   

  // Function -- NODOCS -- clear_extension
  //
  // Remove the instance-specific extension bound under the specified key.
   
  // @uvm-ieee 1800.2-2017 auto 12.3.4.2.42
  function void clear_extension(uvm_tlm_extension_base ext_handle); endfunction


  // Function -- NODOCS -- clear_extensions
  //
  // Remove all instance-specific extensions
   
  // @uvm-ieee 1800.2-2017 auto 12.3.4.2.43
  function void clear_extensions(); endfunction


  // Function -- NODOCS -- pre_randomize()
  // Prepare this class instance for randomization
  //
  function void pre_randomize(); endfunction

  // Function -- NODOCS -- post_randomize()
  // Clean-up this class instance after randomization
  //
  function void post_randomize(); endfunction
endclass

//----------------------------------------------------------------------
// Class -- NODOCS -- uvm_tlm_gp
//
// This typedef provides a short, more convenient name for the
// <uvm_tlm_generic_payload> type.
//----------------------------------------------------------------------

typedef uvm_tlm_generic_payload uvm_tlm_gp;



// @uvm-ieee 1800.2-2017 auto 12.3.4.4.1
virtual class uvm_tlm_extension_base extends uvm_object;


  // @uvm-ieee 1800.2-2017 auto 12.3.4.4.3
  function new(string name = ""); endfunction

  // Function -- NODOCS -- get_type_handle
  //
  // An interface to polymorphically retrieve a handle that uniquely
  // identifies the type of the sub-class

  // @uvm-ieee 1800.2-2017 auto 12.3.4.4.4
  pure virtual function uvm_tlm_extension_base get_type_handle();

  // Function -- NODOCS -- get_type_handle_name
  //
  // An interface to polymorphically retrieve the name that uniquely
  // identifies the type of the sub-class

  // @uvm-ieee 1800.2-2017 auto 12.3.4.4.5
  pure virtual function string get_type_handle_name();

  virtual function void do_copy(uvm_object rhs); endfunction

  // Function -- NODOCS -- create
  //
   
  virtual function uvm_object create (string name=""); endfunction

endclass


//----------------------------------------------------------------------
// Class -- NODOCS -- uvm_tlm_extension
//
// UVM TLM extension class. The class is parameterized with arbitrary type
// which represents the type of the extension. An instance of the
// generic payload can contain one extension object of each type; it
// cannot contain two instances of the same extension type.
//
// The extension type can be identified using the <ID()>
// method.
//
// To implement a generic payload extension, simply derive a new class
// from this class and specify the name of the derived class as the
// extension parameter.
//
//|
//| class my_ID extends uvm_tlm_extension#(my_ID);
//|   int ID;
//|
//|   `uvm_object_utils_begin(my_ID)
//|      `uvm_field_int(ID, UVM_ALL_ON)
//|   `uvm_object_utils_end
//|
//|   function new(string name = "my_ID");
//|      super.new(name);
//|   endfunction
//| endclass
//|

// @uvm-ieee 1800.2-2017 auto 12.3.4.5.1
class uvm_tlm_extension #(type T=int) extends uvm_tlm_extension_base;

   typedef uvm_tlm_extension#(T) this_type;

   local static this_type m_my_tlm_ext_type = ID();

   // Function -- NODOCS -- new
   //
   // creates a new extension object.

   // @uvm-ieee 1800.2-2017 auto 12.3.4.5.3
   function new(string name=""); endfunction

   // Function -- NODOCS -- ID()
   //
   // Return the unique ID of this UVM TLM extension type.
   // This method is used to identify the type of the extension to retrieve
   // from a <uvm_tlm_generic_payload> instance,
   // using the <uvm_tlm_generic_payload::get_extension()> method.
   //
  static function this_type ID(); endfunction

  virtual function uvm_tlm_extension_base get_type_handle(); endfunction

  virtual function string get_type_handle_name(); endfunction

  virtual function uvm_object create (string name=""); endfunction

endclass
