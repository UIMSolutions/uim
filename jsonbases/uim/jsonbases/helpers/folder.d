module uim.jsonbases.helpers.folder;

import uim.jsonbases;

unittest { 
  version(testUimJsonbase) { 
    debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
  }
}

@safe:
bool folderhasKey(IFolder aFolder) {
  return (aFolder !is null && aFolder.exists);
}

bool subfolderhasKey(IFolder aFolder, string aName) {
  return folderhasKey(aFolder)
    ? aFolder.folder(aName) !is null
    : false;
}