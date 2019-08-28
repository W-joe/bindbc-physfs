
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.physfs;

public import bindbc.physfs.config,
              bindbc.physfs.bind;

version(BindPhysfs_Static) {}
else public import bindbc.physfs.dynload;

