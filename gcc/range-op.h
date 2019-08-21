/* Header file for range operator class.
   Copyright (C) 2017-2019 Free Software Foundation, Inc.
   Contributed by Andrew MacLeod <amacleod@redhat.com>.

This file is part of GCC.

GCC is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free
Software Foundation; either version 3, or (at your option) any later
version.

GCC is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or
FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
 for more details.

You should have received a copy of the GNU General Public License
along with GCC; see the file COPYING3.  If not see
<http://www.gnu.org/licenses/>.  */

#ifndef GCC_RANGE_OP_H
#define GCC_RANGE_OP_H

// This class is implemented for each kind of operator that is supported by
// the range generator.  It serves dual purposes.
//
// 1 - Generates range information for the specific operation between
//     the 4 possible combinations of integers and ranges.
//     This provides the ability to fold ranges for an expression.
//
// 2 - Performs range algebra on the expression such that a range can be
//     adjusted in terms of one of the operands:
//       def = op1 + op2
//     Given a range for def, we can possibly adjust the range so its in
//     terms of either operand.
//     op1_adjust (def_range, op2) will adjust the range in place so its
//     in terms of op1.  since op1 = def - op2, it will subtract op2 from
//     each element of the range.
//
// 3 - Creates a range for an operand based on whether the result is 0 or
//     non-zero.  This is mostly for logical true false, but can serve other
//     purposes.
//       ie   0 = op1 - op2 implies op2 has the same range as op1.


class range_operator
{
public:
  // Set a range based on this operation between 2 operands.
  // TYPE is the expected type of the range.
  virtual irange fold_range (tree type, const irange &lh,
			     const irange &rh) const;

  // Set the range for op? in the general case. LHS is the range for
  // the LHS of the expression, OP[12]is the range for the other
  // TYPE is the expected type of the range.
  // operand, and the result is returned in R.
  // Return TRUE if the operation is performed and a valid range is available.
  // ie   [LHS] = ??? + OP2
  // is re-formed as  R = [LHS] - OP2.
  virtual bool op1_range (irange &r, tree type, const irange &lhs,
			  const irange &op2) const;
  virtual bool op2_range (irange &r, tree type, const irange &lhs,
			  const irange &op1) const;
protected:
  // Perform this operation on 2 sub ranges, return the result as a
  // range of TYPE.
  virtual irange wi_fold (tree type, const wide_int &lh_lb, const wide_int &lh_ub,
			  const wide_int &rh_lb, const wide_int &rh_ub) const;
};

extern range_operator *range_op_handler(enum tree_code code, tree type);

#endif // GCC_RANGE_OP_H
