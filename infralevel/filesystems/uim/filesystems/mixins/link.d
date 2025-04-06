/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.filesystems.mixins.link;

mixin(Version!"test_uim_filesystems");

import uim.filesystems;
@safe:

string linkThis(string name = null) {
  string fullName = name ~ "Link";
  return objThis(fullName) ~
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
