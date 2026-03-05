//----------------------------------------------------------------------
// Copyright 2007-2023 Cadence Design Systems, Inc.
// Copyright 2009-2011 Mentor Graphics Corporation
// Copyright 2013-2024 NVIDIA Corporation
// Copyright 2010-2011 Synopsys, Inc.
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
// Git details (see DEVELOPMENT.md):
//
// $File$
// $Rev$
// $Hash$
//
//----------------------------------------------------------------------

#include "svdpi.h"
#include "vpi_user.h"

/*
 * Given a path, look the path name up using the PLI
 * and return its 'value'.
 */
static int uvm_hdl_get_vlog(char *path, p_vpi_vecval value, PLI_INT32 flag, int partsel) {
  static int s_maxsize = -1;
  int i, size, chunks;
  vpiHandle r;
  s_vpi_value value_s;
  int is_partsel, hi, lo;

  r = uvm_hdl_handle_by_name_partsel(path, &is_partsel, &hi, &lo);
  if (r == 0) {
    m_uvm_error("UVM/DPI/VLOG_GET",
                "unable to locate hdl path (%s)\n Either the name is incorrect, or you "
                "may not have PLI/ACC visibility to that name",
                path);
    return 0;
  }

  if (s_maxsize == -1) s_maxsize = uvm_hdl_max_width();
  size = vpi_get(vpiSize, r);
  if (size > s_maxsize) {
    m_uvm_error("UVM/DPI/VLOG_GET",
                "hdl path '%s' is %0d bits, but the maximum size is %0d.  "
                "You can increase the maximum via a compile-time flag: "
                "+define+UVM_HDL_MAX_WIDTH=<value>",
                path, size, s_maxsize);
    vpi_release_handle(r);
    return 0;
  }

  chunks = (size - 1) / 32 + 1;

  value_s.format = vpiVectorVal;
  vpi_get_value(r, &value_s);
  // Note upper bits are not cleared, other simulators do likewise
  if (!is_partsel) {
    // Keep as separate branch as subroutine can potentially inline and highly optimize
    for (i = 0; i < chunks; ++i) {
      value[i].aval = value_s.value.vector[i].aval;
      value[i].bval = value_s.value.vector[i].bval;
    }
  } else {
    // Verilator supports > 32 bit widths, which is an extension to IEEE DPI
    svGetPartselLogic(value, value_s.value.vector, lo, hi - lo + 1);
  }
  // vpi_printf((PLI_BYTE8 *)"uvm_hdl_get_vlog(%s,%0x)\n", path, value[0].aval);
  vpi_release_handle(r);

  return 1;
}

/*
 * Given a path, look the path name up using the PLI
 * or the FLI, and set it to 'value'.
 */
int uvm_hdl_force(char *path, p_vpi_vecval value) {
  return uvm_hdl_set_vlog(path, value, vpiForceFlag);
}
