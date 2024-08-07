/***********************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (UIManufaktur)										           * 
***********************************************************************************/
module uim.filesystems.mixins.folder;

import uim.filesystems;

@safe:
string folderThis(string shortName) {
  string fullName = shortName~"Folder";

  return `
this() { super(); this.name("`~fullName~`"); }

this(IFilesystem aFilesystem) { this(); this.filesystem(aFilesystem); };
this(string[] aPath) { this(); this.path(aPath); };
this(string aName) { this(); this.name(aName); };

this(IFilesystem aFilesystem, string[] aPath) { this(aFilesystem); this.path(aPath); };
this(IFilesystem aFilesystem, string aName) { this(aFilesystem); this.name(aName); };

this(IFilesystem aFilesystem, string[] aPath, string aName) { this(aFilesystem, aPath); this.name(aName); };
  `;
}

template FolderThis(string shortName) {
  const char[] FolderThis = folderThis(shortName);
}

string folderCalls(string shortName) {
  string fullName = shortName~"Folder";

  return `
auto `~fullName~`() { return new D`~fullName~`; }

auto `~fullName~`(IFilesystem aFilesystem) { return new D`~fullName~`(aFilesystem); };
auto `~fullName~`(string[] aPath) { return new D`~fullName~`(aPath); };
auto `~fullName~`(string aName) { return new D`~fullName~`(aName); };

auto `~fullName~`(IFilesystem aFilesystem, string[] aPath) { return new D`~fullName~`(aFilesystem, aPath); };
auto `~fullName~`(IFilesystem aFilesystem, string aName) { return new D`~fullName~`(aFilesystem, aName); };

auto `~fullName~`(IFilesystem aFilesystem, string[] aPath, string aName) { return new D`~fullName~`(aFilesystem, aPath, aName); };
  `;
}

template FolderCalls(string shortName) {
  const char[] FolderCalls = folderCalls(shortName);
}