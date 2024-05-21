module uim.jsonbases.helpers.filecollection;

import uim.jsonbases;

unittest { 
  version(testUimJsonbase) { 
    debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
  }
}

@safe:
IFolder idFolder(IFolder aFolder, UUID anId) {
  version(testUimJsonbase) { debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); }

  return idFolder(aFolder, anId.toString);
}

IFolder idFolder(IFolder aFolder, string anId) {
  version(testUimJsonbase) { debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); }

  // Preconditions
  if (aFolder is null || // Empty parameter 
      !aFolder.exists || // Folder not found
      !anId.isUUID) // Wrong UUID-Format 
      { return null; }

  return aFolder.folder(anId);
}

IFile[] versionFiles(IFolder aFolder, string anId) {
  version(testUimJsonbase) { debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); }

  auto idFolder = idFolder(aFolder, anId);
  if (idFolder.isNull) { return null; }

  return idFolder.files();
}

IFile versionFile(IFolder aFolder, string anId, string aVersionNumber = null) {
  version(testUimJsonbase) { debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); }

  auto idFolder = idFolder(aFolder, anId);
  if (idFolder.isNull) { return null; } // Folder not found

  auto versionFile = idFolder.file(aVersionNumber); // TODO not working
  return (versionFile? versionFile : null);
}

unittest {
  version(testUimJsonbase) { 
    debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
  }
}