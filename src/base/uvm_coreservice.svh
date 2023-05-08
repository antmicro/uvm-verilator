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
