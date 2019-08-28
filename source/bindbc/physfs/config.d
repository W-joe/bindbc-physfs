
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.physfs.config;

enum PhysfsSupport {
    noLibrary,
    badLibrary,
    physfs200      = 200,
    physfs201      = 201,
    physfs202      = 202,
    physfs210      = 203,
    physfs211      = 211,
    physfs300      = 300,
    physfs301      = 301,
    physfs302      = 302,
}

version(Physfs_302) enum physfsSupport = PhysfsSupport.physfs302;
else version(Physfs_301) enum physfsSupport = PhysfsSupport.physfs301;
else version(Physfs_300) enum physfsSupport = PhysfsSupport.physfs300;
else version(Physfs_211) enum physfsSupport = PhysfsSupport.physfs211;
else version(Physfs_203) enum physfsSupport = PhysfsSupport.physfs203;
else version(Physfs_202) enum physfsSupport = PhysfsSupport.physfs202;
else version(Physfs_201) enum physfsSupport = PhysfsSupport.physfs201;
else enum physfsSupport = PhysfsSupport.physfs200;

enum expandEnum(EnumType, string fqnEnumType = EnumType.stringof) = (){
    string expandEnum = "enum {";
    foreach(m;__traits(allMembers, EnumType)) {
        expandEnum ~= m ~ " = " ~ fqnEnumType ~ "." ~ m ~ ",";
    }
    expandEnum  ~= "}";
    return expandEnum;
}();
