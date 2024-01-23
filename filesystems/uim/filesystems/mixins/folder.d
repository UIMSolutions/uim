/***********************************************************************************
*	Copyright: ©2015 - 2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.filesystems.mixins.folder;

import uim.filesystems;

@safe:
string folderThis(string aName) {
  return `
this() { super(); this.className("`~aName~`"); }

this(IFilesystem aFilesystem) { this(); this.filesystem(aFilesystem); };
this(string[] aPath) { this(); this.path(aPath); };
this(string aName) { this(); this.name(aName); };

this(IFilesystem aFilesystem, string[] aPath) { this(aFilesystem); this.path(aPath); };
this(IFilesystem aFilesystem, string aName) { this(aFilesystem); this.name(aName); };

this(IFilesystem aFilesystem, string[] aPath, string aName) { this(aFilesystem, aPath); this.name(aName); };
  `;
}

template FolderThis(string aName) {
  const char[] FolderThis = folderThis(aName);
}

string folderCalls(string shortName, string className = null) {
  string clName = className.length > 0 ? className : "D"~shortName;
  return `
auto `~shortName~`() { return new `~clName~`; }

auto `~shortName~`(IFilesystem aFilesystem) { return new `~clName~`(aFilesystem); };
auto `~shortName~`(string[] aPath) { return new `~clName~`(aPath); };
auto `~shortName~`(string aName) { return new `~clName~`(aName); };

auto `~shortName~`(IFilesystem aFilesystem, string[] aPath) { return new `~clName~`(aFilesystem, aPath); };
auto `~shortName~`(IFilesystem aFilesystem, string aName) { return new `~clName~`(aFilesystem, aName); };

auto `~shortName~`(IFilesystem aFilesystem, string[] aPath, string aName) { return new `~clName~`(aFilesystem, aPath, aName); };
  `;
}

template FolderCalls(string shortName, string className = null) {
  const char[] FolderCalls = folderCalls(shortName, className);
}