/***********************************************************************************
*	Copyright: ©2015-2023 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.filesystems.mixins.filesystem;

string filesystemThis(string aName) {
  return `
this() { super(); this.className("`~aName~`"); }

this(string aName) { this(); this.name(aName); };
  `;
}

template FilesystemThis(string aName) {
  const char[] FilesystemThis = filesystemThis(aName);
}

string filesystemCalls(string shortName, string className = null) {
  string clName = className.length > 0 ? className : "D"~shortName;
  return `
auto `~shortName~`() { return new `~clName~`; }

auto `~shortName~`(string aName) { return new `~clName~`(aName); };
  `;
}

template FilesystemCalls(string shortName, string className = null) {
  const char[] FilesystemCalls = filesystemCalls(shortName, className);
}