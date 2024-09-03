/***********************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (UIManufaktur)										           * 
***********************************************************************************/
module uim.filesystems.mixins.link;

import uim.filesystems;

@safe:
string linkThis(string name = null) {
  string fullName = `"`~ name ~ "Link" ~ `"`;

  return `
    this() {
        super(`~ fullName ~ `);
    }
    this(Json[string] initData) {
        super(`~ fullName ~ `, initData);
    }
    this(string name, Json[string] initData = null) {
        super(name, initData);
    }`~
    (name !is null
    ? `this(string[] path, Json[string] initData = null) {
        this(initData); this.path(path);
      }
      this(IFilesystem filesystem, Json[string] initData = null) {
          this(initData); this.filesystem(filesystem);
      }
      this(IFilesystem filesystem, string name, Json[string] initData = null) {
          this(name, initData); this.filesystem(filesystem);
      }
      this(IFilesystem filesystem, string[] path, Json[string] initData = null) {
          this(name, initData); this.filesystem(filesystem);
      }` : ``);
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

template LinkCalls(string name) {
  const char[] LinkCalls = linkCalls(name);
}
