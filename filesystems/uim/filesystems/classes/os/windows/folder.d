/***********************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.filesystems.classes.os.windows.folder;

import uim.filesystems;

unittest { 
  version(testUimFilesystems) { 
    debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
  }
}

@safe:
class DWindowsFolder : DFolder {
  mixin(FolderThis!("Windows"));
}
mixin(FolderCalls!("Windows"));
