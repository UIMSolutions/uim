/***********************************************************************************
*	Copyright: ©2015-2023 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.filesystems.tests.folder;

import uim.filesystems;

@safe:
// #region Folders Tests
  void testFolder_CreateFolders(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testFolder_CreateFolders'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath    = ", strPath, "\t arrPath  = ", arrPath);
    }
  }

  void testFolder_ReadFolders(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testFolder_ReadFolders'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath    = ", strPath, "\t arrPath  = ", arrPath);
    }
  }

  void testFolder_UpdateFolders(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testFolder_UpdateFolders'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath    = ", strPath, "\t arrPath  = ", arrPath);
    }
  }

  void testFolder_RemoveFolders(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testFolder_RemoveFolders'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath    = ", strPath, "\t arrPath  = ", arrPath);
    }
  }
// #endregion Folders Tests

// #region Test Folder
  void testFolder_CreateFolder(string moduleName, IFolder aFolder, string strPath, string[] pathItems) {
    version(testUimFilesystems) { debug writeln("Running test 'testFolder_CreateFolder'..."); }

    auto newFolderName = "folder"~to!string(uniform(0, 1000));
    aFolder.createFolder(strPath~"/"~newFolderName);
    assert(aFolder.existsFolder(strPath~"/"~newFolderName), "\tERROR (1) IN %s: Folder %s/%s missing".format(moduleName, strPath, newFolderName));

    newFolderName = "folder"~to!string(uniform(0, 1000));
    aFolder.createFolder(strPath, newFolderName);
    assert(aFolder.existsFolder(strPath, newFolderName), "\tERROR (2) IN %s: Folder %s / %s missing".format(moduleName, strPath, newFolderName));

    newFolderName = "folder"~to!string(uniform(0, 1000));
    aFolder.createFolder(pathItems~newFolderName);
    assert(aFolder.existsFolder(pathItems~[newFolderName]), "\tERROR (3) IN %s: Folder %s %s missing".format(moduleName, pathItems, newFolderName));

    newFolderName = "folder"~to!string(uniform(0, 1000));
    aFolder.createFolder(pathItems, newFolderName);
    assert(aFolder.existsFolder(pathItems, newFolderName), "\tERROR (4) IN %s: Folder %s %s missing".format(moduleName, pathItems, newFolderName));
  }

  void testFolder_ReadFolder(string moduleName, IFolder aFolder, string strPath, string[] pathItems) {
    version(testUimFilesystems) { debug writeln("Running test 'testFolder_ReadFolder'..."); }

    auto aFolderName = "folder"~to!string(uniform(0, 1000));
    aFolder.createFolder(strPath~aFolder.filesystem.pathSeparator~aFolderName);
    assert(aFolder.folder(strPath~aFolder.filesystem.pathSeparator~aFolderName),  "\tERROR IN %s: (1) Folder '%s' not found".format(moduleName, strPath));
    assert(aFolder.folder(strPath, aFolderName), "\tERROR IN %s: (2) Folder %s/%s not found".format(moduleName, strPath, aFolderName));

    aFolderName = "folder"~to!string(uniform(0, 1000));
    aFolder.createFolder(pathItems, aFolderName);
    assert(aFolder.folder(pathItems~aFolderName), "\tERROR IN %s: (3) Folder %s not found".format(moduleName, pathItems~aFolderName));
    assert(aFolder.folder(pathItems, aFolderName), "\tERROR IN %s: (4) Folder %s/%s not found".format(moduleName, pathItems, aFolderName));
  }

  void testFolder_UpdateFolder(string moduleName, IFolder aFolder, string strPath, string[] pathItems) {
    version(testUimFilesystems) { debug writeln("Running test 'testFolder_UpdateFolder'..."); }

    auto oldFolderName = "oldFolder"~to!string(uniform(0, 1000));
    auto newFolderName = "newFolder"~to!string(uniform(0, 1000));
    aFolder.createFolder(strPath~"/"~oldFolderName);
    aFolder.renameFolder(strPath~"/"~oldFolderName, newFolderName);
    assert(aFolder.existsFolder(strPath~"/"~newFolderName), "\tERROR IN %s: (1) No Rename of folder %s to %s".format(moduleName, oldFolderName, newFolderName));

    oldFolderName = "oldFolder"~to!string(uniform(0, 1000));
    newFolderName = "newFolder"~to!string(uniform(0, 1000));
    aFolder.createFolder(strPath, oldFolderName);
    aFolder.renameFolder(strPath, oldFolderName, newFolderName);
    assert(aFolder.existsFolder(strPath, newFolderName), "\tERROR IN %s: (2) No Rename of folder %s to %s".format(moduleName, oldFolderName, newFolderName));

    oldFolderName = "oldFolder"~to!string(uniform(0, 1000));
    newFolderName = "newFolder"~to!string(uniform(0, 1000));
    aFolder.createFolder(pathItems~oldFolderName);
    aFolder.renameFolder(pathItems~oldFolderName, newFolderName);
    assert(aFolder.existsFolder(pathItems~newFolderName), "\tERROR IN %s: (3) No Rename of folder %s to %s".format(moduleName, oldFolderName, newFolderName));

    oldFolderName = "oldFolder"~to!string(uniform(0, 1000));
    newFolderName = "newFolder"~to!string(uniform(0, 1000));
    aFolder.createFolder(pathItems, oldFolderName);
    aFolder.renameFolder(pathItems, oldFolderName, newFolderName);
    assert(aFolder.existsFolder(pathItems, newFolderName), "\tERROR IN %s: (4) No Rename of folder %s to %s".format(moduleName, oldFolderName, newFolderName));
  }

  void testFolder_RemoveFolder(string moduleName, IFolder aFolder, string strPath, string[] pathItems) {
    version(testUimFilesystems) { debug writeln("Running test 'testFolder_RemoveFolder'..."); }

    auto newFolderName = "folder"~to!string(uniform(0, 1000));
    aFolder.createFolder(strPath~"/"~newFolderName);
    assert(aFolder.existsFolder(strPath~"/"~newFolderName), "\tERROR: Folder "~strPath~"/"~newFolderName~" missing");
    aFolder.createFolder(strPath~"/"~newFolderName);

    newFolderName = "folder"~to!string(uniform(0, 1000));
    aFolder.createFolder(strPath, newFolderName);
    assert(aFolder.existsFolder(strPath, newFolderName), "\tERROR: Folder "~strPath~"/"~newFolderName~" missing");
    aFolder.createFolder(strPath, newFolderName);

    newFolderName = "folder"~to!string(uniform(0, 1000));
    aFolder.createFolder(pathItems~newFolderName);
    assert(aFolder.existsFolder(pathItems~newFolderName), "\tERROR: Folder "~newFolderName~" missing");
    aFolder.createFolder(pathItems~newFolderName);

    newFolderName = "folder"~to!string(uniform(0, 1000));
    aFolder.createFolder(pathItems, newFolderName);
    assert(aFolder.existsFolder(pathItems, newFolderName), "\tERROR: Folder "~newFolderName~" missing");
    aFolder.createFolder(pathItems, newFolderName);
  } 
// #endregion Test Folder

// #region Test File
  void testFolder_CreateFile(string moduleName, IFolder workFolder, string strPath, string[] pathItems) {
    version(testUimFilesystems) { debug writeln("Running test 'testFolder_CreateFile'...string %s, string[] %s".format(strPath, pathItems)); }
    if (workFolder is null) { 
      version(testUimFilesystems) { debug writeln("No Workfolder for testFolder_CreateFile"); }
      return; 
    }

    auto newFileName = "file"~to!string(uniform(0, 1000));
    workFolder.createFile(strPath~"/"~newFileName);
    assert(workFolder.existsFile(strPath~"/"~newFileName), "\tERROR (1) IN %s: File %s/%s missing".format(moduleName, strPath, newFileName));

    newFileName = "file"~to!string(uniform(0, 1000));
    workFolder.createFile(strPath, newFileName);
    assert(workFolder.existsFile(strPath, newFileName), "\tERROR (2) IN %s: File %s / %s missing".format(moduleName, strPath, newFileName));

    newFileName = "file"~to!string(uniform(0, 1000));
    workFolder.createFile(pathItems~newFileName);
    assert(workFolder.existsFile(pathItems~[newFileName]), "\tERROR (3) IN %s: File %s %s missing".format(moduleName, pathItems, newFileName));

    newFileName = "file"~to!string(uniform(0, 1000));
    workFolder.createFile(pathItems, newFileName);
    assert(workFolder.existsFile(pathItems, newFileName), "\tERROR (4) IN %s: File %s %s missing".format(moduleName, pathItems, newFileName));

  }

  void testFolder_ReadFile(string moduleName, IFolder workFolder, string strPath, string[] pathItems) {
    version(testUimFilesystems) { debug writeln("Running test 'testFolder_ReadFile'..."); }
    if (workFolder is null) { 
      version(testUimFilesystems) { debug writeln("No Workfolder for testFolder_ReadFile"); }
      return; 
    }

    auto aFileName = "file"~to!string(uniform(0, 1000));
    workFolder.createFile(strPath~workFolder.filesystem.pathSeparator~aFileName);
    assert(workFolder.file(strPath~workFolder.filesystem.pathSeparator~aFileName),  "\tERROR IN %s: (1) File '%s' not found".format(moduleName, strPath));
    assert(workFolder.file(strPath, aFileName), "\tERROR IN %s: (2) File %s/%s not found".format(moduleName, strPath, aFileName));

    aFileName = "file"~to!string(uniform(0, 1000));
    workFolder.createFile(pathItems, aFileName);
    assert(workFolder.file(pathItems~aFileName), "\tERROR IN %s: (3) File %s not found".format(moduleName, pathItems~aFileName));
    assert(workFolder.file(pathItems, aFileName), "\tERROR IN %s: (4) File %s/%s not found".format(moduleName, pathItems, aFileName));
  }

  void testFolder_UpdateFile(string moduleName, IFolder workFolder, string strPath, string[] pathItems) {
    version(testUimFilesystems) { debug writeln("Running test 'testFolder_UpdateFile'..."); }
    if (workFolder is null) { 
      version(testUimFilesystems) { debug writeln("No Workfolder for testFolder_UpdateFile"); }
      return; 
    }

    auto oldFileName = "oldFile"~to!string(uniform(0, 1000));
    auto newFileName = "newFile"~to!string(uniform(0, 1000));
    workFolder.createFile(strPath~"/"~oldFileName);
    workFolder.renameFile(strPath~"/"~oldFileName, newFileName);
    assert(workFolder.existsFile(strPath~"/"~newFileName), "\tERROR IN %s: (1) No Rename of file %s to %s".format(moduleName, oldFileName, newFileName));

    oldFileName = "oldFile"~to!string(uniform(0, 1000));
    newFileName = "newFile"~to!string(uniform(0, 1000));
    workFolder.createFile(strPath, oldFileName);
    workFolder.renameFile(strPath, oldFileName, newFileName);
    assert(workFolder.existsFile(strPath, newFileName), "\tERROR IN %s: (2) No Rename of file %s to %s".format(moduleName, oldFileName, newFileName));

    oldFileName = "oldFile"~to!string(uniform(0, 1000));
    newFileName = "newFile"~to!string(uniform(0, 1000));
    workFolder.createFile(pathItems~oldFileName);
    workFolder.renameFile(pathItems~oldFileName, newFileName);
    assert(workFolder.existsFile(pathItems~newFileName), "\tERROR IN %s: (3) No Rename of file %s to %s".format(moduleName, oldFileName, newFileName));

    oldFileName = "oldFile"~to!string(uniform(0, 1000));
    newFileName = "newFile"~to!string(uniform(0, 1000));
    workFolder.createFile(pathItems, oldFileName);
    workFolder.renameFile(pathItems, oldFileName, newFileName);
    assert(workFolder.existsFile(pathItems, newFileName), "\tERROR IN %s: (4) No Rename of file %s to %s".format(moduleName, oldFileName, newFileName));
  }

  void testFolder_removeFile(string moduleName, IFolder workFolder, string strPath, string[] pathItems) {
    version(testUimFilesystems) { debug writeln("Running test 'testFolder_removeFile'..."); }
    if (workFolder is null) { 
      version(testUimFilesystems) { debug writeln("No Workfolder for testFolder_removeFile"); }
      return; 
    }
  }
// #endregion Test File
