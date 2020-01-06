/* Copyright (C) 2007-2020 Free Software Foundation, Inc.

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free
Software Foundation; either version 3, or (at your option) any later
version.

GCC is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
for more details.

Under Section 7 of GPL version 3, you are granted additional
permissions described in the GCC Runtime Library Exception, version
3.1, as published by the Free Software Foundation.

You should have received a copy of the GNU General Public License and
a copy of the GCC Runtime Library Exception along with this program;
see the files COPYING3 and COPYING.RUNTIME respectively.  If not, see
<http://www.gnu.org/licenses/>.  */

#include "bid_conf.h"
#include "bid_functions.h"
#include "bid_gcc_intrinsics.h"

_Decimal32
__bid_addsd3 (_Decimal32 x, _Decimal32 y) {
  UINT64 x64, y64, res64;
  union decimal32 ux, uy, res;

  ux.d = x;
  uy.d = y;
  x64 = __bid32_to_bid64 (ux.i);
  y64 = __bid32_to_bid64 (uy.i);
  res64 = __bid64_add (x64, y64);
  res.i = __bid64_to_bid32 (res64);
  return (res.d);
}

_Decimal32
__bid_subsd3 (_Decimal32 x, _Decimal32 y) {
  UINT64 x64, y64, res64;
  union decimal32 ux, uy, res;

  ux.d = x;
  uy.d = y;
  x64 = __bid32_to_bid64 (ux.i);
  y64 = __bid32_to_bid64 (uy.i);
  res64 = __bid64_sub (x64, y64);
  res.i = __bid64_to_bid32 (res64);
  return (res.d);
}
