/***********************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (UIManufaktur)										           * 
***********************************************************************************/
module uim.filesystems.tests.filesystem;

import uim.filesystems;

@safe:
// #region Entries Tests
// #endregion Entries Tests

// #region Folders Tests
  void testFilesystem_CreateFolders(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testFilesystem_CreateFolders'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath    = ", strPath, "\t arrPath  = ", arrPath);
    }
  }

  void testFilesystem_ReadFolders(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testFilesystem_ReadFolders'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath    = ", strPath, "\t arrPath  = ", arrPath);
    }

		assert(fs.existsFolders(strPath), "\tERROR IN %s: (1) Folder %s not detected".format(moduleName, strPath));
		auto myFolders = fs.folders(strPath);
		assert(fs.countFolders(strPath) == myFolders.length, "\tERROR IN %s: (1) Folders size %s not equal".format(moduleName, strPath));

		assert(fs.existsFolders(arrPath), "\tERROR IN %s: (2) Folder %s not detected".format(moduleName, strPath));
		myFolders = fs.folders(arrPath);
		assert(fs.countFolders(arrPath) == myFolders.length, "\tERROR IN %s: (2) Folders size %s not equal".format(moduleName, strPath));
  }

  void testFilesystem_UpdateFolders(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testFilesystem_UpdateFolders'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath    = ", strPath, "\t arrPath  = ", arrPath);
    }
  }

  void testFilesystem_RemoveFolders(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testFilesystem_RemoveFolders'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath    = ", strPath, "\t arrPath  = ", arrPath);
    }
  }
// #endregion Folders Tests

// #region Folder Tests
  void testFilesystem_IsFolder(string moduleName, IFilesystem fs, string strPath, string aPath, string[] fullPath, string[] arrPath, string aFolderName) {
    version(testUimFilesystems) { debug writeln("INFO in %s: Running test 'testFilesystem_IsFolder'...".format(moduleName)); }

    // Positive tests
    assert(fs.isFolder(strPath), "\tERROR IN %s: (1) Folder %s not detected".format(moduleName, strPath));
    assert(fs.isFolder(aPath, aFolderName), "\tERROR IN %s: (2) Folder %s/%s not detected".format(moduleName, strPath, aFolderName));
    assert(fs.isFolder(fullPath), "\tERROR IN %s: (3) Folder %s not detected".format(moduleName, fullPath));
    assert(fs.isFolder(arrPath, aFolderName), "\tERROR IN %s: (4) Folder %s/%s not detected".format(moduleName, arrPath, aFolderName));

    // Negative tests
    assert(!fs.isFile(strPath), "\tERROR IN %s: Folder %s not detected - not file".format(moduleName, strPath));
  }

  void testFilesystem_IsFile(string moduleName, IFilesystem fs, string strPath, string aPath, string[] fullPath, string[] arrPath, string aFileName) {
    version(testUimFilesystems) { debug writeln("Running test 'testFilesystem_IsFile'..."); }

    // Positive tests
    assert(fs.isFile(strPath), "\tERROR IN %s: (1) File %s not detected".format(moduleName, strPath));
    assert(fs.isFile(aPath, aFileName), "\tERROR IN %s: (2) File %s/%s not detected".format(moduleName, strPath, aFileName));
    assert(fs.isFile(fullPath), "\tERROR IN %s: (3) File %s not detected".format(moduleName, fullPath));
    assert(fs.isFile(arrPath, aFileName), "\tERROR IN %s: (4) File %s/%s not detected".format(moduleName, arrPath, aFileName));

    // Negative tests
    assert(!fs.isFolder(strPath), "\tERROR IN %s: File %s not detected - not file".format(moduleName, strPath));
  }

  void testFilesystem_IsLink(string moduleName, IFilesystem fs, string strPath, string aPath, string[] fullPath, string[] arrPath, string aLinkName) {
    version(testUimFilesystems) { debug writeln("Running test 'testFilesystem_IsLink'..."); }

    // Positive tests
    assert(fs.isLink(strPath), "\tERROR IN %s: (1) Link %s not detected".format(moduleName, strPath));
    assert(fs.isLink(aPath, aLinkName), "\tERROR IN %s: (2) Link %s/%s not detected".format(moduleName, strPath, aLinkName));
    assert(fs.isLink(fullPath), "\tERROR IN %s: (3) Link %s not detected".format(moduleName, fullPath));
    assert(fs.isLink(arrPath, aLinkName), "\tERROR IN %s: (4) Link %s/%s not detected".format(moduleName, arrPath, aLinkName));
  }

  void testFilesystem_IsLinkToFile(string moduleName, IFilesystem fs, string strPath, string aPath, string[] fullPath, string[] arrPath, string aLinkName) {
    version(testUimFilesystems) { debug writeln("Running test 'testFilesystem_IsLinkToFile'..."); }

    testFilesystem_IsLink(moduleName, fs, strPath, aPath, fullPath, arrPath, aLinkName);
    testFilesystem_IsFile(moduleName, fs, strPath, aPath, fullPath, arrPath, aLinkName);
  }

  void testFilesystem_IsLinkToFolder(string moduleName, IFilesystem fs, string strPath, string aPath, string[] fullPath, string[] arrPath, string aLinkName) {
    version(testUimFilesystems) { debug writeln("Running test 'testFilesystem_IsLinkToFolder'..."); }

    testFilesystem_IsLink(moduleName, fs, strPath, aPath, fullPath, arrPath, aLinkName);
    testFilesystem_IsFolder(moduleName, fs, strPath, aPath, fullPath, arrPath, aLinkName);
  }

  void testFilesystem_CreateFolder(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testFilesystem_CreateFolder'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath    = ", strPath, "\t arrPath  = ", arrPath);
    }

    auto newFolderName = "folder"~to!string(uniform(0, 1000));
    fs.createFolder(strPath~"/"~newFolderName);
    assert(fs.existsFolder(strPath~"/"~newFolderName), "\tERROR in %s (1): Folder %s / %s missing".format(moduleName, strPath, newFolderName));

    newFolderName = "folder"~to!string(uniform(0, 1000));
    fs.createFolder(strPath, newFolderName);
    assert(fs.existsFolder(strPath, newFolderName), "\tERROR in %s (2): Folder %s / %s missing".format(moduleName, strPath, newFolderName));

    newFolderName = "folder"~to!string(uniform(0, 1000));
    fs.createFolder(arrPath~newFolderName);
    assert(fs.existsFolder(arrPath~newFolderName), "\tERROR in %s (3): Folder %s / %s missing".format(moduleName, arrPath, newFolderName));

    newFolderName = "folder"~to!string(uniform(0, 1000));
    fs.createFolder(arrPath, newFolderName);
    assert(fs.existsFolder(arrPath, newFolderName), "\tERROR in %s (4): Folder %s / %s missing".format(moduleName, arrPath, newFolderName));
  }

  void testFilesystem_ReadFolder(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testFilesystem_ReadFolder'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath    = ", strPath, "\t arrPath  = ", arrPath);
    }

    auto aFolderName = "folder"~to!string(uniform(0, 1000));
    fs.createFolder(strPath~fs.pathSeparator~aFolderName);
    assert(fs.folder(strPath~fs.pathSeparator~aFolderName),  "\tERROR IN %s: (1) Folder %s / %s not found".format(moduleName, strPath, aFolderName));
    assert(fs.folder(strPath, aFolderName), "\tERROR IN %s: (2) Folder %s / %s not found".format(moduleName, strPath, aFolderName));

    aFolderName = "folder"~to!string(uniform(0, 1000));
    fs.createFolder(arrPath, aFolderName);
    assert(fs.folder(arrPath~aFolderName), "\tERROR IN %s: (3) Folder %s not found".format(moduleName, arrPath~aFolderName));
    assert(fs.folder(arrPath, aFolderName), "\tERROR IN %s: (4) Folder %s - %s not found".format(moduleName, arrPath, aFolderName));
  }

  void testFilesystem_UpdateFolder(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testFilesystem_UpdateFolder'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath    = ", strPath, "\t arrPath  = ", arrPath);
    }

    auto oldFolderName = "oldFolder"~to!string(uniform(0, 1000));
    auto newFolderName = "newFolder"~to!string(uniform(0, 1000));
    fs.createFolder(strPath~"/"~oldFolderName);
    fs.renameFolder(strPath~"/"~oldFolderName, newFolderName);
    assert(fs.existsFolder(strPath~"/"~newFolderName), "\tERROR IN %s: (1) No Rename of folder %s to %s".format(moduleName, oldFolderName, newFolderName));

    oldFolderName = "oldFolder"~to!string(uniform(0, 1000));
    newFolderName = "newFolder"~to!string(uniform(0, 1000));
    fs.createFolder(strPath, oldFolderName);
    fs.renameFolder(strPath, oldFolderName, newFolderName);
    assert(fs.existsFolder(strPath, newFolderName), "\tERROR IN %s: (2) No Rename of folder %s to %s".format(moduleName, oldFolderName, newFolderName));

    oldFolderName = "oldFolder"~to!string(uniform(0, 1000));
    newFolderName = "newFolder"~to!string(uniform(0, 1000));
    fs.createFolder(arrPath~oldFolderName);
    fs.renameFolder(arrPath~oldFolderName, newFolderName);
    assert(fs.existsFolder(arrPath~newFolderName), "\tERROR IN %s: (3) No Rename of folder %s to %s".format(moduleName, oldFolderName, newFolderName));

    oldFolderName = "oldFolder"~to!string(uniform(0, 1000));
    newFolderName = "newFolder"~to!string(uniform(0, 1000));
    fs.createFolder(arrPath, oldFolderName);
    fs.renameFolder(arrPath, oldFolderName, newFolderName);
    assert(fs.existsFolder(arrPath, newFolderName), "\tERROR IN %s: (4) No Rename of folder %s to %s".format(moduleName, oldFolderName, newFolderName));
  }

  void testFilesystem_RemoveFolder(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testFilesystem_RemoveFolder'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath    = ", strPath, "\t arrPath  = ", arrPath);
    }

    auto newFolderName = "folder"~to!string(uniform(0, 1000));
    fs.createFolder(strPath~"/"~newFolderName);
    assert(fs.existsFolder(strPath~"/"~newFolderName), "\tERROR (1) in %s: Folder %s - %s missing".format(moduleName, strPath, newFolderName));
    fs.createFolder(strPath~"/"~newFolderName);

    newFolderName = "folder"~to!string(uniform(0, 1000));
    fs.createFolder(strPath, newFolderName);
    assert(fs.existsFolder(strPath, newFolderName), "\tERROR (2) in %s: Folder %s - %s missing".format(moduleName, strPath, newFolderName));
    fs.createFolder(strPath, newFolderName);

    newFolderName = "folder"~to!string(uniform(0, 1000));
    fs.createFolder(arrPath~newFolderName);
    assert(fs.existsFolder(arrPath~newFolderName), "\tERROR (3) in %s: Folder %s - %s missing".format(moduleName, arrPath, newFolderName));
    fs.createFolder(arrPath~newFolderName);

    newFolderName = "folder"~to!string(uniform(0, 1000));
    fs.createFolder(arrPath, newFolderName);
    assert(fs.existsFolder(arrPath, newFolderName), "\tERROR (4) in %s: Folder %s - %s missing".format(moduleName, arrPath, newFolderName));
    fs.createFolder(arrPath, newFolderName);
  }
// #endregion Folder tests

// #region Files Tests
  void testFilesystem_CreateFiles(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testFilesystem_CreateFiles'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath    = ", strPath, "\t arrPath  = ", arrPath);
    }

  }

  void testFilesystem_ReadFiles(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testFilesystem_ReadFiles'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath    = ", strPath, "\t arrPath  = ", arrPath);
    }
  }

  void testFilesystem_UpdateFiles(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testFilesystem_UpdateFiles'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath    = ", strPath, "\t arrPath  = ", arrPath);
    }
  }

  void testFilesystem_RemoveFiles(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testFilesystem_RemoveLinks'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath    = ", strPath, "\t arrPath  = ", arrPath);
    }
  }
// #endregion Files Tests

// #region File Tests
  void testFilesystem_CreateFile(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testFilesystem_CreateFile'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath    = ", strPath, "\t arrPath  = ", arrPath);
    }

    auto newFileName = "file"~to!string(uniform(0, 1000));
    fs.createFile(strPath~"/"~newFileName);
    assert(fs.existsFile(strPath~"/"~newFileName), "\tERROR in %s (1): File %s / %s missing".format(moduleName, strPath, newFileName));

    newFileName = "file"~to!string(uniform(0, 1000));
    fs.createFile(strPath, newFileName);
    assert(fs.existsFile(strPath, newFileName), "\tERROR in %s (2): File %s / %s missing".format(moduleName, strPath, newFileName));

    newFileName = "file"~to!string(uniform(0, 1000));
    fs.createFile(arrPath~newFileName);
    assert(fs.existsFile(arrPath~newFileName), "\tERROR in %s (3): File %s / %s missing".format(moduleName, arrPath, newFileName));

    newFileName = "file"~to!string(uniform(0, 1000));
    fs.createFile(arrPath, newFileName);
    assert(fs.existsFile(arrPath, newFileName), "\tERROR in %s (4): File %s / %s missing".format(moduleName, arrPath, newFileName));
  }

  void testFilesystem_ReadFile(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { debug writeln("Running test 'testFilesystem_ReadFile'..."); }

    version(testUimFilesystems) { 
      debug writeln("Running test 'testFilesystem_ReadFolder'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath    = ", strPath, "\t arrPath  = ", arrPath);
    }

    auto aFileName = "file"~to!string(uniform(0, 1000));
    fs.createFile(strPath~fs.pathSeparator~aFileName);
    assert(fs.file(strPath~fs.pathSeparator~aFileName),  "\tERROR IN %s: (1) File %s / %s not found".format(moduleName, strPath, aFileName));
    assert(fs.file(strPath, aFileName), "\tERROR IN %s: (2) File %s / %s not found".format(moduleName, strPath, aFileName));

    aFileName = "file"~to!string(uniform(0, 1000));
    fs.createFile(arrPath, aFileName);
    assert(fs.file(arrPath~aFileName), "\tERROR IN %s: (3) File %s not found".format(moduleName, arrPath~aFileName));
    assert(fs.file(arrPath, aFileName), "\tERROR IN %s: (4) File %s - %s not found".format(moduleName, arrPath, aFileName));
  }

  void testFilesystem_UpdateFile(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testFilesystem_UpdateFile'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath    = ", strPath, "\t arrPath  = ", arrPath);
    }

    auto oldFileName = "oldFile"~to!string(uniform(0, 1000));
    auto newFileName = "newFile"~to!string(uniform(0, 1000));
    fs.createFile(strPath~"/"~oldFileName);
    fs.renameFile(strPath~"/"~oldFileName, newFileName);
    assert(fs.existsFile(strPath~"/"~newFileName), "\tERROR IN %s: (1) No Rename of file %s to %s".format(moduleName, oldFileName, newFileName));

    oldFileName = "oldFile"~to!string(uniform(0, 1000));
    newFileName = "newFile"~to!string(uniform(0, 1000));
    fs.createFile(strPath, oldFileName);
    fs.renameFile(strPath, oldFileName, newFileName);
    assert(fs.existsFile(strPath, newFileName), "\tERROR IN %s: (2) No Rename of file %s to %s".format(moduleName, oldFileName, newFileName));

    oldFileName = "oldFile"~to!string(uniform(0, 1000));
    newFileName = "newFile"~to!string(uniform(0, 1000));
    fs.createFile(arrPath~oldFileName);
    fs.renameFile(arrPath~oldFileName, newFileName);
    assert(fs.existsFile(arrPath~newFileName), "\tERROR IN %s: (3) No Rename of file %s to %s".format(moduleName, oldFileName, newFileName));

    oldFileName = "oldFile"~to!string(uniform(0, 1000));
    newFileName = "newFile"~to!string(uniform(0, 1000));
    fs.createFile(arrPath, oldFileName);
    fs.renameFile(arrPath, oldFileName, newFileName);
    assert(fs.existsFile(arrPath, newFileName), "\tERROR IN %s: (4) No Rename of file %s to %s".format(moduleName, oldFileName, newFileName));

    // Update content
    auto aFileName = "file"~to!string(now);
    auto aText = "aText"~to!string(now.toTimestamp);
    fs.createFile(arrPath, aFileName);
    fs.writeTextToFile(arrPath, aFileName, aText);
    assert(fs.readTextFromFile(arrPath, aFileName) == aText, "\tERROR IN %s: (4) No Rename of file %s to %s".format(moduleName, oldFileName, newFileName));
  }

  void testFilesystem_removeFile(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
  version(testUimFilesystems) { 
      debug writeln("Running test 'testFilesystem_RemoveFile'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath    = ", strPath, "\t arrPath  = ", arrPath);
    }

    auto newFileName = "file"~to!string(now);
    fs.createFile(strPath~"/"~newFileName);
    assert(fs.existsFile(strPath~"/"~newFileName), "\tERROR (1) in %s: File %s - %s missing".format(moduleName, strPath, newFileName));
    fs.createFile(strPath~"/"~newFileName);

    newFileName = "file"~to!string(uniform(0, 1000));
    fs.createFile(strPath, newFileName);
    assert(fs.existsFile(strPath, newFileName), "\tERROR (2) in %s: File %s - %s missing".format(moduleName, strPath, newFileName));
    fs.createFile(strPath, newFileName);

    newFileName = "file"~to!string(uniform(0, 1000));
    fs.createFile(arrPath~newFileName);
    assert(fs.existsFile(arrPath~newFileName), "\tERROR (3) in %s: File %s - %s missing".format(moduleName, arrPath, newFileName));
    fs.createFile(arrPath~newFileName);

    newFileName = "file"~to!string(uniform(0, 1000));
    fs.createFile(arrPath, newFileName);
    assert(fs.existsFile(arrPath, newFileName), "\tERROR (4) in %s: File %s - %s missing".format(moduleName, arrPath, newFileName));
    fs.createFile(arrPath, newFileName);
  }
// #endregion File Tests

// #region Links Tests
  void testFilesystem_CreateLinks(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testFilesystem_CreateLinks'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath    = ", strPath, "\t arrPath  = ", arrPath);
    }

  }

  void testFilesystem_ReadLinks(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testFilesystem_ReadLinks'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath    = ", strPath, "\t arrPath  = ", arrPath);
    }
  }

  void testFilesystem_UpdateLinks(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testFilesystem_UpdateLinks'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath    = ", strPath, "\t arrPath  = ", arrPath);
    }
  }

  void testFilesystem_RemoveLinks(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testFilesystem_RemoveLinks'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath    = ", strPath, "\t arrPath  = ", arrPath);
    }
  }
// #endregion Links Tests

// #region Link Tests
  void testFilesystem_CreateLink(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testFilesystem_CreateLink'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath    = ", strPath, "\t arrPath  = ", arrPath);
    }

  }

  void testFilesystem_ReadLink(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testFilesystem_ReadLink'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath    = ", strPath, "\t arrPath  = ", arrPath);
    }
  }

  void testFilesystem_UpdateLink(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testFilesystem_UpdateLink'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath    = ", strPath, "\t arrPath  = ", arrPath);
    }
  }

  void testFilesystem_RemoveLink(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testFilesystem_RemoveLink'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath    = ", strPath, "\t arrPath  = ", arrPath);
    }
  }
// #endregion Link Tests