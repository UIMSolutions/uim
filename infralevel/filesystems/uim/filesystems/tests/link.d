/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.filesystems.tests.link;

mixin(Version!"test_uim_filesystems");

import uim.filesystems;
@safe:

// #region Links Tests
  void testLink_CreateLinks(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testLink_CreateLinks'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath   = ", strPath, "\t arrPath = ", arrPath);
    }
  }

  void testLink_ReadLinks(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testLink_ReadLinks'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath   = ", strPath, "\t arrPath = ", arrPath);
    }
  }

  void testLink_UpdateLinks(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testLink_UpdateLinks'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath   = ", strPath, "\t arrPath = ", arrPath);
    }
  }

  void testLink_RemoveLinks(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testLink_RemoveLinks'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath   = ", strPath, "\t arrPath = ", arrPath);
    }
  }
// #endregion Links Tests

// #region Link Tests
  void testLink_CreateLink(string moduleName, IFolder workFolder, string strPath, string[] pathItems) {
    version(testUimFilesystems) { debug writeln("Running test 'testLink_CreateLink'..."); }
    if (workFolder is null) { 
      version(testUimFilesystems) { debug writeln("No Workfolder for testLink_CreateLink"); }
      return; 
    }
  }

  void testLink_ReadLink(string moduleName, IFolder workFolder, string strPath, string[] pathItems) {
    version(testUimFilesystems) { debug writeln("Running test 'testLink_ReadLink'..."); }
    if (workFolder is null) { 
      version(testUimFilesystems) { debug writeln("No Workfolder for testFile_ReadFile"); }
      return; 
    }
  }

  void testLink_UpdateLink(string moduleName, IFolder workFolder, string strPath, string[] pathItems) {
    version(testUimFilesystems) { debug writeln("Running test 'testLink_UpdateLink'..."); }
    if (workFolder is null) { 
      version(testUimFilesystems) { debug writeln("No Workfolder for testLink_UpdateLink"); }
      return; 
    }
  }

  void testLink_RemoveLink(string moduleName, IFolder workFolder, string strPath, string[] pathItems) {
    version(testUimFilesystems) { debug writeln("Running test 'testLink_RemoveLink'..."); }
    if (workFolder is null) { 
      version(testUimFilesystems) { debug writeln("No Workfolder for testLink_RemoveLink"); }
      return; 
    }
  }
// #endregion Link Tests
