/***********************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (UIManufaktur)										           * 
***********************************************************************************/
module uim.filesystems.classes.database.file;

import uim.filesystems;

unittest {
  writeln("-----  ", __MODULE__ , "\t  -----");
}

@safe:
class DDatabaseFile : DFile {
  mixin(FileThis!("Database"));

  override Json[string] debugInfo() {
    return super.debugInfo();
  }
}
mixin(FileCalls!("Database"));