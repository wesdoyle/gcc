// { dg-do run }
// { dg-options "-pthread"  }
// { dg-require-effective-target c++11 }
// { dg-require-effective-target pthread }
// { dg-require-gthreads "" }

// Copyright (C) 2010-2020 Free Software Foundation, Inc.
//
// This file is part of the GNU ISO C++ Library.  This library is free
// software; you can redistribute it and/or modify it under the
// terms of the GNU General Public License as published by the
// Free Software Foundation; either version 3, or (at your option)
// any later version.

// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.

// You should have received a copy of the GNU General Public License along
// with this library; see the file COPYING3.  If not see
// <http://www.gnu.org/licenses/>.

// 30.6.7 Class template shared_future [futures.shared_future]

#include <future>
#include <testsuite_hooks.h>

// This test verifies behaviour which is encouraged by a non-normative note,
// but not required.
 
void
test01()
{
  std::shared_future<int> f;
  try
  {
    f.get();
    VERIFY( false );
  }
  catch (std::future_error& e)
  {
    VERIFY( e.code() == std::future_errc::no_state );
  }
}

void
test02()
{
  std::shared_future<int&> f;
  try
  {
    f.get();
    VERIFY( false );
  }
  catch (std::future_error& e)
  {
    VERIFY( e.code() == std::future_errc::no_state );
  }
}

void
test03()
{
  std::shared_future<void> f;
  try
  {
    f.get();
    VERIFY( false );
  }
  catch (std::future_error& e)
  {
    VERIFY( e.code() == std::future_errc::no_state );
  }
}

int main()
{
  test01();
  test02();
  test03();

  return 0;
}

