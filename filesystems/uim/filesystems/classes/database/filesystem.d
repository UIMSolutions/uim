/***********************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (UIManufaktur)										           * 
***********************************************************************************/
module uim.filesystems.classes.database.filesystem;

import uim.filesystems;

unittest { 
  version(testUimFilesystems) { 
    debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
  }
}

@safe:
class DDatabaseFilesystem : DFilesystem {
  mixin(FilesystemThis!("Database"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

		pathSeparator("/");
    return true;
  }
}
mixin(FilesystemCalls!("Database"));
