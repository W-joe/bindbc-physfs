
//          Copyright Michael D. Parker 2018.
// Distributed under the Boost Software License, Version 1.0.
//    (See accompanying file LICENSE_1_0.txt or copy at
//          http://www.boost.org/LICENSE_1_0.txt)

module bindbc.physfs.dynload;

version(BindPhysfs_Static) {}
else:

import bindbc.loader;
import bindbc.physfs.config,
       bindbc.physfs.bind;

private {
    SharedLib lib;
    PhysfsSupport loadedVersion;
}

void unloadPhysfs()
{
    if(lib != invalidHandle) {
        lib.unload();
    }
}

PhysfsSupport loadedPhysfsVersion() { return loadedVersion; }

bool isPhysfsLoaded()
{
    return  lib != invalidHandle;
}

PhysfsSupport loadPhysfs()
{
    // #1778 prevents me from using static arrays here :(
    version(Windows) {
        const(char)[][2] libNames = ["libphysfs.dll", "physfs.dll"];
    }
    else version(OSX) {
        const(char)[][2] libNames = [
            "libphysfs.dylib",
            "/usr/local/lib/libphysfs.dylib"
        ];
    }
    else version(Posix) {
        const(char)[][5] libNames = [
            "libphysfs.so",
            "/usr/lib64/libphysfs.so",
            "/usr/local/lib64/libphysfs.so",
            "/usr/lib/libphysfs.so",
            "/usr/local/lib/libphysfs.so",
        ];
    }
    else static assert(0, "bindbc-physfs is not yet supported on this platform.");

    PhysfsSupport ret;
    foreach(name; libNames) {
        ret = loadPhysfs(name.ptr);
        if(ret != PhysfsSupport.noLibrary) break;
    }
    return ret;
}

PhysfsSupport loadPhysfs(const(char)* libName)
{
    lib = load(libName);
    if(lib == invalidHandle) {
        return PhysfsSupport.noLibrary;
    }

    auto errCount = errorCount();
    loadedVersion = PhysfsSupport.badLibrary;

    lib.bindSymbol(cast(void**)&PHYSFS_getLinkedVersion, "PHYSFS_getLinkedVersion");
    lib.bindSymbol(cast(void**)&PHYSFS_init, "PHYSFS_init");
    lib.bindSymbol(cast(void**)&PHYSFS_deinit, "PHYSFS_deinit");
    lib.bindSymbol(cast(void**)&PHYSFS_supportedArchiveTypes, "PHYSFS_supportedArchiveTypes");
    lib.bindSymbol(cast(void**)&PHYSFS_freeList, "PHYSFS_freeList");
    lib.bindSymbol(cast(void**)&PHYSFS_getLastError, "PHYSFS_getLastError");
    lib.bindSymbol(cast(void**)&PHYSFS_getDirSeparator, "PHYSFS_getDirSeparator");
    lib.bindSymbol(cast(void**)&PHYSFS_permitSymbolicLinks, "PHYSFS_permitSymbolicLinks");
    lib.bindSymbol(cast(void**)&PHYSFS_getCdRomDirs, "PHYSFS_getCdRomDirs");
    lib.bindSymbol(cast(void**)&PHYSFS_getBaseDir, "PHYSFS_getBaseDir");
    lib.bindSymbol(cast(void**)&PHYSFS_getUserDir, "PHYSFS_getUserDir");
    lib.bindSymbol(cast(void**)&PHYSFS_getWriteDir, "PHYSFS_getWriteDir");
    lib.bindSymbol(cast(void**)&PHYSFS_setWriteDir, "PHYSFS_setWriteDir");
    lib.bindSymbol(cast(void**)&PHYSFS_addToSearchPath, "PHYSFS_addToSearchPath");
    lib.bindSymbol(cast(void**)&PHYSFS_removeFromSearchPath, "PHYSFS_removeFromSearchPath");
    lib.bindSymbol(cast(void**)&PHYSFS_getSearchPath, "PHYSFS_getSearchPath");
    lib.bindSymbol(cast(void**)&PHYSFS_setSaneConfig, "PHYSFS_setSaneConfig");
    lib.bindSymbol(cast(void**)&PHYSFS_mkdir, "PHYSFS_mkdir");
    lib.bindSymbol(cast(void**)&PHYSFS_delete, "PHYSFS_delete");
    lib.bindSymbol(cast(void**)&PHYSFS_getRealDir, "PHYSFS_getRealDir");
    lib.bindSymbol(cast(void**)&PHYSFS_enumerateFiles, "PHYSFS_enumerateFiles");
    lib.bindSymbol(cast(void**)&PHYSFS_exists, "PHYSFS_exists");
    lib.bindSymbol(cast(void**)&PHYSFS_isDirectory, "PHYSFS_isDirectory");
    lib.bindSymbol(cast(void**)&PHYSFS_isSymbolicLink, "PHYSFS_isSymbolicLink");
    lib.bindSymbol(cast(void**)&PHYSFS_getLastModTime, "PHYSFS_getLastModTime");
    lib.bindSymbol(cast(void**)&PHYSFS_openWrite, "PHYSFS_openWrite");
    lib.bindSymbol(cast(void**)&PHYSFS_openAppend, "PHYSFS_openAppend");
    lib.bindSymbol(cast(void**)&PHYSFS_openRead, "PHYSFS_openRead");
    lib.bindSymbol(cast(void**)&PHYSFS_close, "PHYSFS_close");
    lib.bindSymbol(cast(void**)&PHYSFS_read, "PHYSFS_read");
    lib.bindSymbol(cast(void**)&PHYSFS_write, "PHYSFS_write");
    lib.bindSymbol(cast(void**)&PHYSFS_eof, "PHYSFS_eof");
    lib.bindSymbol(cast(void**)&PHYSFS_tell, "PHYSFS_tell");
    lib.bindSymbol(cast(void**)&PHYSFS_seek, "PHYSFS_seek");
    lib.bindSymbol(cast(void**)&PHYSFS_fileLength, "PHYSFS_fileLength");
    lib.bindSymbol(cast(void**)&PHYSFS_setBuffer, "PHYSFS_setBuffer");
    lib.bindSymbol(cast(void**)&PHYSFS_flush, "PHYSFS_flush");
    lib.bindSymbol(cast(void**)&PHYSFS_swapSLE16, "PHYSFS_swapSLE16");
    lib.bindSymbol(cast(void**)&PHYSFS_swapULE16, "PHYSFS_swapULE16");
    lib.bindSymbol(cast(void**)&PHYSFS_swapSLE32, "PHYSFS_swapSLE32");
    lib.bindSymbol(cast(void**)&PHYSFS_swapULE32, "PHYSFS_swapULE32");
    lib.bindSymbol(cast(void**)&PHYSFS_swapSLE64, "PHYSFS_swapSLE64");
    lib.bindSymbol(cast(void**)&PHYSFS_swapULE64, "PHYSFS_swapULE64");
    lib.bindSymbol(cast(void**)&PHYSFS_swapSBE16, "PHYSFS_swapSBE16");
    lib.bindSymbol(cast(void**)&PHYSFS_swapUBE16, "PHYSFS_swapUBE16");
    lib.bindSymbol(cast(void**)&PHYSFS_swapSBE32, "PHYSFS_swapSBE32");
    lib.bindSymbol(cast(void**)&PHYSFS_swapUBE32, "PHYSFS_swapUBE32");
    lib.bindSymbol(cast(void**)&PHYSFS_swapSBE64, "PHYSFS_swapSBE64");
    lib.bindSymbol(cast(void**)&PHYSFS_swapUBE64, "PHYSFS_swapUBE64");
    lib.bindSymbol(cast(void**)&PHYSFS_readSLE16, "PHYSFS_readSLE16");
    lib.bindSymbol(cast(void**)&PHYSFS_readULE16, "PHYSFS_readULE16");
    lib.bindSymbol(cast(void**)&PHYSFS_readSLE32, "PHYSFS_readSLE32");
    lib.bindSymbol(cast(void**)&PHYSFS_readULE32, "PHYSFS_readULE32");
    lib.bindSymbol(cast(void**)&PHYSFS_readSLE64, "PHYSFS_readSLE64");
    lib.bindSymbol(cast(void**)&PHYSFS_readULE64, "PHYSFS_readULE64");
    lib.bindSymbol(cast(void**)&PHYSFS_readSBE16, "PHYSFS_readSBE16");
    lib.bindSymbol(cast(void**)&PHYSFS_readUBE16, "PHYSFS_readUBE16");
    lib.bindSymbol(cast(void**)&PHYSFS_readSBE32, "PHYSFS_readSBE32");
    lib.bindSymbol(cast(void**)&PHYSFS_readUBE32, "PHYSFS_readUBE32");
    lib.bindSymbol(cast(void**)&PHYSFS_readSBE64, "PHYSFS_readSBE64");
    lib.bindSymbol(cast(void**)&PHYSFS_readUBE64, "PHYSFS_readUBE64");
    lib.bindSymbol(cast(void**)&PHYSFS_writeSLE16, "PHYSFS_writeSLE16");
    lib.bindSymbol(cast(void**)&PHYSFS_writeULE16, "PHYSFS_writeULE16");
    lib.bindSymbol(cast(void**)&PHYSFS_writeSLE32, "PHYSFS_writeSLE32");
    lib.bindSymbol(cast(void**)&PHYSFS_writeULE32, "PHYSFS_writeULE32");
    lib.bindSymbol(cast(void**)&PHYSFS_writeSLE64, "PHYSFS_writeSLE64");
    lib.bindSymbol(cast(void**)&PHYSFS_writeULE64, "PHYSFS_writeULE64");
    lib.bindSymbol(cast(void**)&PHYSFS_writeSBE16, "PHYSFS_writeSBE16");
    lib.bindSymbol(cast(void**)&PHYSFS_writeUBE16, "PHYSFS_writeUBE16");
    lib.bindSymbol(cast(void**)&PHYSFS_writeSBE32, "PHYSFS_writeSBE32");
    lib.bindSymbol(cast(void**)&PHYSFS_writeUBE32, "PHYSFS_writeUBE32");
    lib.bindSymbol(cast(void**)&PHYSFS_writeSBE64, "PHYSFS_writeSBE64");
    lib.bindSymbol(cast(void**)&PHYSFS_writeUBE64, "PHYSFS_writeUBE64");
    lib.bindSymbol(cast(void**)&PHYSFS_isInit, "PHYSFS_isInit");
    lib.bindSymbol(cast(void**)&PHYSFS_symbolicLinksPermitted, "PHYSFS_symbolicLinksPermitted");
    lib.bindSymbol(cast(void**)&PHYSFS_setAllocator, "PHYSFS_setAllocator");
    lib.bindSymbol(cast(void**)&PHYSFS_mount, "PHYSFS_mount");
    lib.bindSymbol(cast(void**)&PHYSFS_getMountPoint, "PHYSFS_getMountPoint");
    lib.bindSymbol(cast(void**)&PHYSFS_getCdRomDirsCallback, "PHYSFS_getCdRomDirsCallback");
    lib.bindSymbol(cast(void**)&PHYSFS_getSearchPathCallback, "PHYSFS_getSearchPathCallback");
    lib.bindSymbol(cast(void**)&PHYSFS_enumerateFilesCallback, "PHYSFS_enumerateFilesCallback");
    lib.bindSymbol(cast(void**)&PHYSFS_utf8FromUcs4, "PHYSFS_utf8FromUcs4");
    lib.bindSymbol(cast(void**)&PHYSFS_utf8ToUcs4, "PHYSFS_utf8ToUcs4");
    lib.bindSymbol(cast(void**)&PHYSFS_utf8FromUcs2, "PHYSFS_utf8FromUcs2");
    lib.bindSymbol(cast(void**)&PHYSFS_utf8ToUcs2, "PHYSFS_utf8ToUcs2");
    lib.bindSymbol(cast(void**)&PHYSFS_utf8FromLatin1, "PHYSFS_utf8FromLatin1");

    loadedVersion = PhysfsSupport.physfs200;

    static if(physfsSupport >= PhysfsSupport.physfs211) {
        lib.bindSymbol(cast(void**)&PHYSFS_unmount, "PHYSFS_unmount");
        lib.bindSymbol(cast(void**)&PHYSFS_getAllocator, "PHYSFS_getAllocator");
        lib.bindSymbol(cast(void**)&PHYSFS_stat, "PHYSFS_stat");
        lib.bindSymbol(cast(void**)&PHYSFS_utf8FromUtf16, "PHYSFS_utf8FromUtf16");
        lib.bindSymbol(cast(void**)&PHYSFS_utf8ToUtf16, "PHYSFS_utf8ToUtf16");
        lib.bindSymbol(cast(void**)&PHYSFS_readBytes, "PHYSFS_readBytes");
        lib.bindSymbol(cast(void**)&PHYSFS_writeBytes, "PHYSFS_writeBytes");
        lib.bindSymbol(cast(void**)&PHYSFS_mountIo, "PHYSFS_mountIo");
        lib.bindSymbol(cast(void**)&PHYSFS_mountMemory, "PHYSFS_mountMemory");
        lib.bindSymbol(cast(void**)&PHYSFS_mountHandle, "PHYSFS_mountHandle");
        lib.bindSymbol(cast(void**)&PHYSFS_getLastErrorCode, "PHYSFS_getLastErrorCode");
        lib.bindSymbol(cast(void**)&PHYSFS_getErrorByCode, "PHYSFS_getErrorByCode");
        lib.bindSymbol(cast(void**)&PHYSFS_setErrorCode, "PHYSFS_setErrorCode");
        lib.bindSymbol(cast(void**)&PHYSFS_getPrefDir, "PHYSFS_getPrefDir");
        lib.bindSymbol(cast(void**)&PHYSFS_registerArchiver, "PHYSFS_registerArchiver");
        lib.bindSymbol(cast(void**)&PHYSFS_deregisterArchiver, "PHYSFS_deregisterArchiver");
        lib.bindSymbol(cast(void**)&PHYSFS_enumerate, "PHYSFS_enumerate");

        loadedVersion = PhysfsSupport.physfs211;
    }


    if(errorCount() != errCount) return PhysfsSupport.badLibrary;

    return loadedVersion;
}
