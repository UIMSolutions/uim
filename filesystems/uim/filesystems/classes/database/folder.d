/***********************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (UIManufaktur)										           * 
***********************************************************************************/
module uim.filesystems.classes.database.folder;

import uim.filesystems;

unittest {
  writeln("-----  ", __MODULE__ , "\t  -----");
}

@safe:
class DDatabaseFolder : DFolder {
  mixin(FolderThis!("Database"));
}
mixin(FolderCalls!("Database"));
