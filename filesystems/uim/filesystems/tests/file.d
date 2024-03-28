/***********************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.filesystems.tests.file;

import uim.filesystems;

@safe:
// #region Files Tests
  void testFile_CreateFiles(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testFile_CreateFiles'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath    = ", strPath, "\t arrPath  = ", arrPath);
    }
  }

  void testFile_ReadFiles(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testFile_ReadFiles'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath    = ", strPath, "\t arrPath  = ", arrPath);
    }
  }

  void testFile_UpdateFiles(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testFile_UpdateFiles'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath    = ", strPath, "\t arrPath  = ", arrPath);
    }
  }

  void testFile_RemoveFiles(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testFile_RemoveFiles'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath    = ", strPath, "\t arrPath  = ", arrPath);
    }
  }
// #endregion Files Tests

// #region File Tests
  void testFile_CreateFile(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testFile_CreateFile'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath    = ", strPath, "\t arrPath  = ", arrPath);
    }
  }

  void testFile_ReadFile(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testFile_ReadFile'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath    = ", strPath, "\t arrPath  = ", arrPath);
    }
  }

  void testFile_UpdateFile(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testFile_UpdateFile'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath    = ", strPath, "\t arrPath  = ", arrPath);
    }
  }

  void testFile_RemoveFile(string moduleName, IFilesystem fs, string strPath, string[] arrPath) {
    version(testUimFilesystems) { 
      debug writeln("Running test 'testFile_RemoveFile'..."); 
      debug writeln("ModuleName = ", moduleName, "\t strPath    = ", strPath, "\t arrPath  = ", arrPath);
    }
  }
// #endregion File Tests
