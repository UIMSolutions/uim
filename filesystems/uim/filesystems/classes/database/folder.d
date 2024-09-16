/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.filesystems.classes.database.folder;import uim.filesystems;unittest {  writeln("-----  ", __MODULE__ , "\t  -----");}@safe:class DDatabaseFolder : DFolder {  mixin(FolderThis!("Database"));  override Json[string] debugInfo() {    return super.debugInfo();  }}mixin(FolderCalls!("Database"));