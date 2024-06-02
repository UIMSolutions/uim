/***********************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (UIManufaktur)										           * 
***********************************************************************************/
module uim.filesystems.mixins.filesystem;

string filesystemThis(string shortName) {
string fullName = shortName~"Filesystem";

  return `
this() { super(); this.name("`~fullName~`"); }

this(string aName) { this(); this.name(aName); };
  `;
}

template FilesystemThis(string shortName) {
  const char[] FilesystemThis = filesystemThis(shortName);
}

string filesystemCalls(string shortName) {
  string fullName = shortName~"Filesystem";

  return `
auto `~fullName~`() { return new D`~fullName~`; }

auto `~fullName~`(string aName) { return new D`~fullName~`(aName); };
  `;
}

template FilesystemCalls(string shortName) {
  const char[] FilesystemCalls = filesystemCalls(shortName);
}