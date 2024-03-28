/***********************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.filesystems.classes.virtual.filesystem;

import uim.filesystems;

unittest { 
  version(testUimFilesystems) { 
    debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); 
  }
}

@safe:
class DVirtualFilesystem : DFilesystem {
  mixin(FilesystemThis!("Virtual"));

  override bool initialize(IData[string] initData = null) { // Hook
		if (!super.initialize(initData)) {
			return false;
		}
    _rootFolder = VirtualFolder(this);
		return true;
  }
}
mixin(FilesystemCalls!("Virtual"));
