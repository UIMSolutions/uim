/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.filesystems.mixins.folder;

import uim.filesystems;

@safe:
string folderThis(string name = null) {
  string fullName = name ~ "Folder";
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

template FolderThis(string name = null) {
  const char[] FolderThis = folderThis(name);
}

string folderCalls(string name) {
  string fullName = name ~ "Folder";
  return objCalls(fullName) ~
    `auto ` ~ fullName ~ `(string[] path, Json[string] initData = null) { return new D` ~ fullName ~ `(path, initData); };

auto `
    ~ fullName ~ `(IFilesystem filesystem, Json[string] initData = null) { return new D` ~ fullName ~ `(filesystem, initData); };
auto `
    ~ fullName ~ `(IFilesystem filesystem, string name, Json[string] initData = null) { return new D` ~ fullName ~ `(filesystem, name, initData); };
auto `
    ~ fullName ~ `(IFilesystem filesystem, string[] path, Json[string] initData = null) { return new D` ~ fullName ~ `(filesystem, path, initData); };
  `;
}

template FolderCalls(string shortName) {
  const char[] FolderCalls = folderCalls(shortName);
}
