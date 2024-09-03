/***********************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (UIManufaktur)										           * 
***********************************************************************************/
module uim.filesystems.mixins.link;

import uim.filesystems;

@safe:
string linkThis(string name = null) {
  string fullName = shortName ~ "Link";

  return `
    this() {
        super("`~ fullName ~ `");
    }
    this(Json[string] initData) {
        super("`~ fullName ~ `", initData);
    }
    this(string name, Json[string] initData = null) {
        super(name, initData);
    }

this(IFilesystem aFilesystem) { this(); this.filesystem(aFilesystem); };

this(IFilesystem aFilesystem, string aName) { this(aFilesystem); this.name(aName); };
  `;
}

template LinkThis(string name = null) {
  const char[] LinkThis = linkThis(name);
}

string linkCalls(string name) {
  string fullName = name ~ "Link";

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
