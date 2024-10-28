/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.filesystems.classes.os.windows.link;import uim.filesystems;unittest {  version (testUimFilesystems) {    debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);  }}@safe:class DWindowsLink : DLink {  mixin(LinkThis!("Windows"));}mixin(LinkCalls!("Windows"));