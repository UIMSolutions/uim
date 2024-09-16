/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.filesystems.classes.memory.file;import uim.filesystems;unittest {  version (testUimFilesystems) {    debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);  }}@safe:class DMemoryFile : DFile {  mixin(FileThis!("Memory"));  override Json[string] debugInfo() {    return super.debugInfo();  }}mixin(FileCalls!("Memory"));