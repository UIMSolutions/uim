/***********************************************************************************
*	Copyright: ©2015- 2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.filesystems.classes.os.windows.filesystem;

import uim.filesystems;

unittest { 
  version(testUimFilesystems) { 
    debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); 
  }
}

@safe:
class DWindowsFilesystem : DFilesystem {
  mixin(FilesystemThis!("WindowsFilesystem"));

  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

		pathSeparator("\\");
  }
}
mixin(FilesystemCalls!("WindowsFilesystem"));
