/*
 *  Copyright 2008-2012 NVIDIA Corporation
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

#pragma once

#include <thrust/system/cpp/detail/tag.h>
#include <thrust/detail/raw_pointer_cast.h>

namespace thrust
{
namespace system
{
namespace cpp
{
namespace detail
{

template<typename System, typename Pointer1, typename Pointer2>
__host__ __device__
  void assign_value(thrust::system::cpp::detail::dispatchable<System> &, Pointer1 dst, Pointer2 src)
{
  *thrust::raw_pointer_cast(dst) = *thrust::raw_pointer_cast(src);
} // end assign_value()

} // end detail
} // end cpp
} // end system
} // end thrust
