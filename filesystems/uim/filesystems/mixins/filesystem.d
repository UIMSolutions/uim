/***********************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (UIManufaktur)										           * 
***********************************************************************************/
module uim.filesystems.mixins.filesystem;

string filesystemThis(string name = null) {
  string fullName = `"` ~ name ~ "Filesystem"~ `"`;

  string mainPart = return objThis(fullName);


  if (name !is null) {
    mainPart ~= `this(string[] path, Json[string] initData = null) { super(path, initData); }`;
  }
  return mainPart;
}

template FilesystemThis(string name = null) {
  const char[] FilesystemThis = filesystemThis(name);
}

string filesystemCalls(string name) {
  string fullName = name ~ "Filesystem";

  return `
auto `
    ~ fullName ~ `() { return new D` ~ fullName ~ `; }
auto `
    ~ fullName ~ `(Json[string] initData) { return new D` ~ fullName ~ `(initData); };
auto `
    ~ fullName ~ `(string name, Json[string] initData = null) { return new D` ~ fullName ~ `(name, initData); };
auto `
    ~ fullName ~ `(string[] path, Json[string] initData = null) { return new D` ~ fullName ~ `(path, initData); };
  `;
}

template FilesystemCalls(string name) {
  const char[] FilesystemCalls = filesystemCalls(name);
}
