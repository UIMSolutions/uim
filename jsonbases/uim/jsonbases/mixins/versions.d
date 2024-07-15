module uim.jsonbases.mixins.versions;

import uim.jsonbases;

@safe:
template FolderByIdAndFileByNumber() {
/* IFolder idFolder = folder.folder(myId);
  if (idFolder.isNull) { 
      return false; 
    }

  if ("versionNumber" !in select) { 
      return false; 
    }
  auto versionNumber = select["versionNumber"].get!size_t;
  
  auto versionFile = idFolder(versionNumber);
  if (versionFile.isNull) { 
      return false; 
    }
}