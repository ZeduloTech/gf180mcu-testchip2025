// SPDX-FileCopyrightText: 2020 Efabless Corporation
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
// SPDX-License-Identifier: Apache-2.0

`default_nettype none

`ifndef __GLOBAL_DEFINE_H
// Global parameters
`define __GLOBAL_DEFINE_H

// These defines are mostly to make hardcoded parts of Caravel happy
`define MPRJ_IO_PADS_1 19   /* number of user GPIO pads on user1 side */
`define MPRJ_IO_PADS_2 19   /* number of user GPIO pads on user2 side */
`define MPRJ_IO_PADS (`MPRJ_IO_PADS_1 + `MPRJ_IO_PADS_2)

`define MPRJ_PWR_PADS 1

// Clock divisor default value
`define CLK_DIV 3'b010

// The actual number of Caravel pads.
// Connecting them to MPRJ_TO_CARAVEL_LO first and MPRJ_TO_CARAVEL_HI last mprj pad signals.
`define MPRJ_TO_CARAVEL_LO  7
`define MPRJ_TO_CARAVEL_HI  6
`define CARAVEL_IO_PADS     (`MPRJ_TO_CARAVEL_LO + `MPRJ_TO_CARAVEL_HI)

// Useful GPIO mode values.  These match the names used in defs.h.
`define GPIO_MODE_MGMT_STD_INPUT_NOPULL    10'h007
`define GPIO_MODE_MGMT_STD_INPUT_PULLDOWN  10'h047
`define GPIO_MODE_MGMT_STD_INPUT_PULLUP    10'h087
`define GPIO_MODE_MGMT_STD_OUTPUT          10'h00b
`define GPIO_MODE_MGMT_STD_BIDIRECTIONAL   10'h009

`define GPIO_MODE_USER_STD_INPUT_NOPULL    10'h006
`define GPIO_MODE_USER_STD_INPUT_PULLDOWN  10'h046
`define GPIO_MODE_USER_STD_INPUT_PULLUP    10'h086
`define GPIO_MODE_USER_STD_OUTPUT          10'h00a
`define GPIO_MODE_USER_STD_BIDIRECTIONAL   10'h008

`endif // __GLOBAL_DEFINE_H
