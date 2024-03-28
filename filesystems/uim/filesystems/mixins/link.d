/***********************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.filesystems.mixins.link;

import uim.filesystems;

@safe:
string linkThis(string shortName) {
  string fullName = shortName ~ "Link";

  return `
this() { super(); this.name("`
    ~ fullName ~ `"); }

this(IFilesystem aFilesystem) { this(); this.filesystem(aFilesystem); };
this(string aName) { this(); this.name(aName); };

this(IFilesystem aFilesystem, string aName) { this(aFilesystem); this.name(aName); };
  `;
}

template LinkThis(string shortName) {
  const char[] LinkThis = linkThis(shortName);
}

string linkCalls(string shortName) {
  string fullName = shortName ~ "Link";

  return `
auto `
    ~ fullName ~ `() { return new D` ~ fullName ~ `; }

auto `
    ~ fullName ~ `(IFilesystem aFilesystem) { return new D` ~ fullName ~ `(aFilesystem); };
auto `
    ~ fullName ~ `(string aName) { return new D` ~ fullName ~ `(aName); };

auto `
    ~ fullName ~ `(IFilesystem aFilesystem, string aName) { return new D` ~ fullName ~ `(aFilesystem, aName); };
  `;
}

template LinkCalls(string shortName) {
  const char[] LinkCalls = linkCalls(shortName);
}
