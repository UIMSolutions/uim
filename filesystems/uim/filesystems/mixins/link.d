/***********************************************************************************
*	Copyright: ©2015 - 2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.filesystems.mixins.link;

import uim.filesystems;

@safe:
string linkThis(string aName) {
  return `
this() { super(); this.name("`~aName~`"); }

this(IFilesystem aFilesystem) { this(); this.filesystem(aFilesystem); };
this(string aName) { this(); this.name(aName); };

this(IFilesystem aFilesystem, string aName) { this(aFilesystem); this.name(aName); };
  `;
}

template LinkThis(string aName) {
  const char[] LinkThis = linkThis(aName);
}

string linkCalls(string shortName, string className = null) {
  string clName = className.length > 0 ? className : "D"~shortName;
  return `
auto `~shortName~`() { return new `~clName~`; }

auto `~shortName~`(IFilesystem aFilesystem) { return new `~clName~`(aFilesystem); };
auto `~shortName~`(string aName) { return new `~clName~`(aName); };

auto `~shortName~`(IFilesystem aFilesystem, string aName) { return new `~clName~`(aFilesystem, aName); };
  `;
}

template LinkCalls(string shortName, string className = null) {
  const char[] LinkCalls = linkCalls(shortName, className);
}