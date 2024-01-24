/***********************************************************************************
*	Copyright: ©2015 - 2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
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
  mixin(FilesystemThis!("VirtualFilesystem"));

  override bool initialize(IConfigData[string] configData = null) { // Hook
		super.initialize(configData);
    _rootFolder = VirtualFolder(this);
  }
}
mixin(FilesystemCalls!("VirtualFilesystem"));
