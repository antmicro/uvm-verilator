//
//----------------------------------------------------------------------
// Copyright 2007-2011 Mentor Graphics Corporation
// Copyright 2014 Semifore
// Copyright 2010-2018 Synopsys, Inc.
// Copyright 2007-2018 Cadence Design Systems, Inc.
// Copyright 2014-2018 NVIDIA Corporation
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


//------------------------------------------------------------------------------
// Title -- NODOCS -- UVM TLM Channel Classes
//------------------------------------------------------------------------------
// This section defines built-in UVM TLM channel classes.
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
//
// CLASS -- NODOCS -- uvm_tlm_req_rsp_channel #(REQ,int)
//
// The uvm_tlm_req_rsp_channel contains a request FIFO of type ~REQ~ and a response
// FIFO of type ~int~. These FIFOs can be of any size. This channel is
// particularly useful for dealing with pipelined protocols where the request
// and response are not tightly coupled.
//
// Type parameters:
//
// REQ - Type of the request transactions conveyed by this channel.
// int - Type of the response transactions conveyed by this channel.
//
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto 12.2.9.1.1
class uvm_tlm_req_rsp_channel extends uvm_component;
  parameter type REQ=int, RSP=REQ;
  typedef uvm_tlm_req_rsp_channel this_type;

  `uvm_component_param_utils(uvm_tlm_req_rsp_channel)
  `uvm_type_name_decl("uvm_tlm_req_rsp_channel #(int,int)")

  // Port -- NODOCS -- put_request_export
  //
  // The put_export provides both the blocking and non-blocking put interface
  // methods to the request FIFO:
  //
  //|  task put (input T t);
  //|  function bit can_put ();
  //|  function bit try_put (input T t);
  //
  // Any put port variant can connect and send transactions to the request FIFO
  // via this export, provided the transaction types match.

  uvm_put_export #(REQ) put_request_export;


  // Port -- NODOCS -- get_peek_response_export
  //
  // The get_peek_response_export provides all the blocking and non-blocking get
  // and peek interface methods to the response FIFO:
  //
  //|  task get (output T t);
  //|  function bit can_get ();
  //|  function bit try_get (output T t);
  //|  task peek (output T t);
  //|  function bit can_peek ();
  //|  function bit try_peek (output T t);
  //
  // Any get or peek port variant can connect to and retrieve transactions from
  // the response FIFO via this export, provided the transaction types match.

  uvm_get_peek_export #(RSP) get_peek_response_export;


  // Port -- NODOCS -- get_peek_request_export
  //
  // The get_peek_export provides all the blocking and non-blocking get and peek
  // interface methods to the response FIFO:
  //
  //|  task get (output T t);
  //|  function bit can_get ();
  //|  function bit try_get (output T t);
  //|  task peek (output T t);
  //|  function bit can_peek ();
  //|  function bit try_peek (output T t);
  //
  // Any get or peek port variant can connect to and retrieve transactions from
  // the response FIFO via this export, provided the transaction types match.


  uvm_get_peek_export #(REQ) get_peek_request_export;


  // Port -- NODOCS -- put_response_export
  //
  // The put_export provides both the blocking and non-blocking put interface
  // methods to the response FIFO:
  //
  //|  task put (input T t);
  //|  function bit can_put ();
  //|  function bit try_put (input T t);
  //
  // Any put port variant can connect and send transactions to the response FIFO
  // via this export, provided the transaction types match.

  uvm_put_export #(RSP) put_response_export;


  // Port -- NODOCS -- request_ap
  //
  // Transactions passed via ~put~ or ~try_put~ (via any port connected to the
  // put_request_export) are sent out this port via its write method.
  //
  //|  function void write (T t);
  //
  // All connected analysis exports and imps will receive these transactions.

  uvm_analysis_port #(REQ) request_ap;


  // Port -- NODOCS -- response_ap
  //
  // Transactions passed via ~put~ or ~try_put~ (via any port connected to the
  // put_response_export) are sent out this port via its write method.
  //
  //|  function void write (T t);
  //
  // All connected analysis exports and imps will receive these transactions.

  uvm_analysis_port   #(RSP) response_ap;


  // Port -- NODOCS -- master_export
  //
  // Exports a single interface that allows a master to put requests and get or
  // peek responses. It is a combination of the put_request_export and
  // get_peek_response_export.

  uvm_master_imp #(REQ, RSP, this_type, uvm_tlm_fifo, uvm_tlm_fifo) master_export;


  // Port -- NODOCS -- slave_export
  //
  // Exports a single interface that allows a slave to get or peek requests and
  // to put responses. It is a combination of the get_peek_request_export
  // and put_response_export.

  uvm_slave_imp  #(REQ, RSP, this_type, uvm_tlm_fifo, uvm_tlm_fifo) slave_export;

  // port aliases for backward compatibility
  uvm_put_export      #(REQ) blocking_put_request_export,
                             nonblocking_put_request_export;
  uvm_get_peek_export #(REQ) get_request_export,
                             blocking_get_request_export,
                             nonblocking_get_request_export,
                             peek_request_export,
                             blocking_peek_request_export,
                             nonblocking_peek_request_export,
                             blocking_get_peek_request_export,
                             nonblocking_get_peek_request_export;

  uvm_put_export      #(RSP) blocking_put_response_export,
                             nonblocking_put_response_export;
  uvm_get_peek_export #(RSP) get_response_export,
                             blocking_get_response_export,
                             nonblocking_get_response_export,
                             peek_response_export,
                             blocking_peek_response_export,
                             nonblocking_peek_response_export,
                             blocking_get_peek_response_export,
                             nonblocking_get_peek_response_export;

  uvm_master_imp #(REQ, RSP, this_type, uvm_tlm_fifo, uvm_tlm_fifo)
                             blocking_master_export, 
                             nonblocking_master_export;

  uvm_slave_imp  #(REQ, RSP, this_type, uvm_tlm_fifo, uvm_tlm_fifo)
                             blocking_slave_export, 
                             nonblocking_slave_export;
  // internal fifos
  protected uvm_tlm_fifo m_request_fifo;
  protected uvm_tlm_fifo m_response_fifo;


  // Function -- NODOCS -- new
  //
  // The ~name~ and ~parent~ are the standard <uvm_component> constructor arguments.
  // The ~parent~ must be ~null~ if this component is defined within a static
  // component such as a module, program block, or interface. The last two
  // arguments specify the request and response FIFO sizes, which have default
  // values of 1.

  // @uvm-ieee 1800.2-2017 auto 12.2.9.1.11
  function new (string name, uvm_component parent=null, 
                int request_fifo_size=1,
                int response_fifo_size=1);

    super.new (name, parent);

    m_request_fifo  = new ("request_fifo",  this, request_fifo_size);
    m_response_fifo = new ("response_fifo", this, response_fifo_size);

    request_ap      = new ("request_ap",  this);
    response_ap     = new ("response_ap", this);
            
    put_request_export       = new ("put_request_export",       this);
    get_peek_request_export  = new ("get_peek_request_export",  this);

    put_response_export      = new ("put_response_export",      this); 
    get_peek_response_export = new ("get_peek_response_export", this);

    master_export   = new ("master_export", this, m_request_fifo, m_response_fifo);
    slave_export    = new ("slave_export",  this, m_request_fifo, m_response_fifo);

    create_aliased_exports();

    set_report_id_action_hier(s_connection_error_id, UVM_NO_ACTION);

  endfunction

  virtual function void connect_phase(uvm_phase phase);
    put_request_export.connect       (m_request_fifo.put_export);
    get_peek_request_export.connect  (m_request_fifo.get_peek_export);
    m_request_fifo.put_ap.connect    (request_ap);
    put_response_export.connect      (m_response_fifo.put_export);
    get_peek_response_export.connect (m_response_fifo.get_peek_export);
    m_response_fifo.put_ap.connect   (response_ap);
  endfunction

  function void create_aliased_exports();
    // request
    blocking_put_request_export         = put_request_export;
    nonblocking_put_request_export      = put_request_export;
    get_request_export                  = get_peek_request_export;
    blocking_get_request_export         = get_peek_request_export;
    nonblocking_get_request_export      = get_peek_request_export;
    peek_request_export                 = get_peek_request_export;
    blocking_peek_request_export        = get_peek_request_export;
    nonblocking_peek_request_export     = get_peek_request_export;
    blocking_get_peek_request_export    = get_peek_request_export;
    nonblocking_get_peek_request_export = get_peek_request_export;
  
    // response
    blocking_put_response_export         = put_response_export;
    nonblocking_put_response_export      = put_response_export;
    get_response_export                  = get_peek_response_export;
    blocking_get_response_export         = get_peek_response_export;
    nonblocking_get_response_export      = get_peek_response_export;
    peek_response_export                 = get_peek_response_export;
    blocking_peek_response_export        = get_peek_response_export;
    nonblocking_peek_response_export     = get_peek_response_export;
    blocking_get_peek_response_export    = get_peek_response_export;
    nonblocking_get_peek_response_export = get_peek_response_export;
  
    // master/slave
    blocking_master_export    = master_export; 
    nonblocking_master_export = master_export;
    blocking_slave_export     = slave_export;
    nonblocking_slave_export  = slave_export;
  endfunction
  
endclass


//------------------------------------------------------------------------------
//
// CLASS -- NODOCS -- uvm_tlm_transport_channel #(int,int)
//
// A uvm_tlm_transport_channel is a <uvm_tlm_req_rsp_channel #(int,int)> that implements
// the transport interface. It is useful when modeling a non-pipelined bus at
// the transaction level. Because the requests and responses have a tightly
// coupled one-to-one relationship, the request and response FIFO sizes are both
// set to one.
//
//------------------------------------------------------------------------------

// @uvm-ieee 1800.2-2017 auto 12.2.9.2.1
class uvm_tlm_transport_channel 
                                     extends uvm_tlm_req_rsp_channel;

  `uvm_component_param_utils(uvm_tlm_transport_channel)
  `uvm_type_name_decl("uvm_tlm_transport_channel #(int,int)")
  
  typedef uvm_tlm_transport_channel this_type;

  // Port -- NODOCS -- transport_export
  //
  // The put_export provides both the blocking and non-blocking transport
  // interface methods to the response FIFO:
  //
  //|  task transport(int request, output int response);
  //|  function bit nb_transport(int request, output int response);
  //
  // Any transport port variant can connect to and send requests and retrieve
  // responses via this export, provided the transaction types match. Upon
  // return, the response argument carries the response to the request.

  uvm_transport_imp #(REQ, RSP, this_type) transport_export;


  // Function -- NODOCS -- new
  //
  // The ~name~ and ~parent~ are the standard <uvm_component> constructor
  // arguments. The ~parent~ must be ~null~ if this component is defined within a
  // statically elaborated construct such as a module, program block, or
  // interface.

  // @uvm-ieee 1800.2-2017 auto 12.2.9.2.3
  function new (string name, uvm_component parent=null);
    super.new(name, parent, 1, 1);
    transport_export = new("transport_export", this);
  endfunction

  // @uvm-ieee 1800.2-2017 auto 12.2.9.2.2
  task transport (int request, output int response );
  endtask

  // @uvm-ieee 1800.2-2017 auto 12.2.9.2.2
  function bit nb_transport (int req, output int rsp );
      return 0;
  endfunction

endclass
