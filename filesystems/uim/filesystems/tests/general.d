/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.filesystems.tests.general;

import uim.filesystems;

@safe:
bool testFilesystem(IFilesystem aFilesystem) {
  if (aFilesystem is null) { return false; }

   if (!aFilesystem.existsFolder("testFolder")) {
    assert(aFilesystem.createFolder("testFolder"), "testFilesystem: Couldn't create testFolder");
    return false;
  }
  assert(aFilesystem.existsFolder("testFolder"), "testFilesystem: testFolder missing");

  if (auto myFolder = aFilesystem.folder("testFolder")) {
    // debug writeln(myFolder.debugInfo);    
    assert(myFolder.exists(), "testFilesystem: FolderObj testFolder missing");
  }
  else {
    assert(false, "testFilesystem: FolderObj missing");
  }

  return true;
}