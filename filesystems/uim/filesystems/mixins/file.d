/***********************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (UIManufaktur)										           * 
***********************************************************************************/
module uim.filesystems.mixins.file;

import uim.filesystems;
@safe:
string fileThis(string name = null) {
  string fullName = `"` ~ name ~ "File" ~ `"`;
    return objThis(fullName)
    ~
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

template FileThis(string name = null) {
  const char[] FileThis = fileThis(name);
}

string fileCalls(string name) {
  string fullName = name ~ "File";
  return objCalls(fullName)~
  `
auto `
    ~ fullName ~ `(string[] path, Json[string] initData = null) { return new D` ~ fullName ~ `(path, initData); };

auto `
    ~ fullName ~ `(IFilesystem filesystem, Json[string] initData = null) { return new D` ~ fullName ~ `(filesystem, initData); };
auto `
    ~ fullName ~ `(IFilesystem filesystem, string name, Json[string] initData = null) { return new D` ~ fullName ~ `(filesystem, name, initData); };
auto `
    ~ fullName ~ `(IFilesystem filesystem, string[] path, Json[string] initData = null) { return new D` ~ fullName ~ `(filesystem, path, initData); };
  `;
}

template FileCalls(string shortName) {
  const char[] FileCalls = fileCalls(shortName);
}
