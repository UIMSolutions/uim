module uim.jsonbase.helpers.folder;

import uim.jsonbase;

unittest { 
  version(testUimJsonbase) { 
    debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); 
  }
}

@safe:
bool folderExists(IFolder aFolder) {
  return (aFolder !is null && aFolder.exists);
}

bool subfolderExists(IFolder aFolder, string aName) {
  return folderExists(aFolder)
    ? aFolder.folder(aName) !is null
    : false;
}