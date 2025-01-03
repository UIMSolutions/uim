/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.filesystems.mixins.filemanager;

import uim.filesystems;

@safe:
mixin template TFileManager() {
  // #region files
  // #region READ
  // #region hasFiles()
  bool hasFiles(string aPath) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
      debug writeln("aPath = %s".format(aPath));
    }

    return hasFiles(toPathItems(aPath, pathSeparator));
  }

  bool hasFiles(string aPath, string aFolderName) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
      debug writeln("aPath = %s \t aFolderName = %s".format(aPath, aFolderName));
    }

    return hasFiles(toPathItems(aPath, pathSeparator), aFolderName);
  }

  bool hasFiles(string[] aPath) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
      debug writeln("aPath = %s".format(aPath));
    }

    // Preconditions
    if (aPath.isEmpty) {
      return false;
    }

    // Body
    string[] aNullArray;
    return (aPath.length > 1
        ? hasFiles(aPath[0 .. $ - 1], aPath[$ - 1]) : hasFiles(aNullArray, aPath[$ - 1]));
  }

  bool hasFiles(string[] aPath, string aFolderName) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
      debug writeln("aPath = %s \t aFolderName = %s".format(aPath, aFolderName));
    }

    return false;
  }
  // #endregion hasFiles()

  // #region countFiles()
  size_t countFiles(string aPath) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
      debug writeln("aPath = %s".format(aPath));
    }

    if (aPath.isEmpty)
      return 0;

    return this.countFiles(toPathItems(aPath, pathSeparator));
  }

  size_t countFiles(string aPath, string aFolderName) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
      debug writeln("aPath = %s \t aFolderName = %s".format(aPath, aFolderName));
    }

    if (aPath.isEmpty)
      return 0;

    return this.countFiles(toPathItems(aPath, pathSeparator), aFolderName);
  }

  size_t countFiles(string[] aPath) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
      debug writeln("aPath = %s".format(aPath));
    }

    // Preconditions
    if (aPath.isEmpty)
      return 0;

    // Body
    string[] aNullArray;
    return (aPath.length > 1
        ? countFiles(aPath[0 .. $ - 1], aPath[$ - 1]) : countFiles(aNullArray, aPath[$ - 1]));
  }

  size_t countFiles(string[] aPath, string aFolderName) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
      debug writeln("aPath = %s \t aFolderName = %s".format(aPath, aFolderName));
    }

    return 0;
  }
  // #endregion countFiles()

  // #region files()
  IFile[] files() {
    return null;
  }

  IFile[] files(string aPath) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
      debug writeln("aPath = %s".format(aPath));
    }

    if (aPath.isEmpty)
      return null;

    return files(toPathItems(aPath, pathSeparator));
  }

  IFile[] files(string aPath, string aFolderName) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
      debug writeln("aPath = %s \t aFolderName = %s".format(aPath, aFolderName));
    }

    if (aPath.isEmpty || aFolderName.isEmpty)
      return null;

    return files(toPathItems(aPath, pathSeparator), aFolderName);
  }

  IFile[] files(string[] aPath) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
      debug writeln("aPath = %s".format(aPath));
    }

    // Preconditions
    if (aPath.isEmpty)
      return null;

    // Body
    string[] aNullArray;
    return (aPath.length > 1
        ? files(aPath[0 .. $ - 1], aPath[$ - 1]) : files(aNullArray, aPath[$ - 1]));
  }

  IFile[] files(string[] aPath, string aFolderName) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
      debug writeln("aPath = %s \t aFolderName = %s".format(aPath, aFolderName));
    }

    return null;
  }
  // #endregion files()
  // #endregion READ
  // #endregion files

  // #region File
  // #region CREATE
  // #region createFile
  IFile createFile(string aPath) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
    }

    return createFile(toPathItems(aPath, pathSeparator));
  }

  IFile createFile(string aPath, string aFileName) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
    }

    return createFile(toPathItems(aPath, pathSeparator), aFileName);
  }

  IFile createFile(string[] aPath) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
    }

    if (aPath.isEmpty)
      return null;

    string[] aNullArray;
    return (aPath.length > 1
        ? createFile(aPath[0 .. $ - 1], aPath[$ - 1]) : createFile(aNullArray, aPath[$ - 1]));
  }

  IFile createFile(string[] aPath, string fileName) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
    }

    return null;
  }
  // #endregion createFile

  //#region copyFile()
  bool copyFile(string fromPath, string toPath) {
    return this.copyFile(toPathItems(fromPath, pathSeparator), toPathItems(toPath, pathSeparator));
  }

  bool copyFile(string[] fromPath, string toPath) {
    return this.copyFile(fromPath, toPathItems(toPath, pathSeparator));
  }

  bool copyFile(string fromPath, string[] toPath) {
    return this.copyFile(toPathItems(fromPath, pathSeparator), toPath);
  }

  bool copyFile(string[] fromPath, string[] toPath) {
    return false;
  }
  //#endregion 
  // #endregion CREATE

  // #region READ
  // #region existsFile
  bool existsFile(string aPath) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
    }

    return existsFile(toPathItems(aPath, pathSeparator));
  }

  bool existsFile(string aPath, string aFileName) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
    }

    return existsFile(toPathItems(aPath, pathSeparator), aFileName);
  }

  bool existsFile(string[] aPath) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
    }

    if (aPath.isEmpty) {
      return false;
    }

    string[] aNullArray;
    return (aPath.length > 1
        ? existsFile(aPath[0 .. $ - 1], aPath[$ - 1]) : existsFile(aNullArray, aPath[$ - 1]));
  }

  bool existsFile(string[] aPath, string fileName) {
    return false;
  }
  // #endregion existsFile

  // #region file
  IFile file(string aPath) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
    }

    return file(toPathItems(aPath, pathSeparator));
  }

  IFile file(string aPath, string aFileName) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
    }

    return file(toPathItems(aPath, pathSeparator), aFileName);
  }

  IFile file(string[] aPath) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
    }
    if (aPath.isEmpty)
      return null;

    string[] aNullArray;
    return (aPath.length > 1
        ? file(aPath[0 .. $ - 1], aPath[$ - 1]) : file(aNullArray, aPath[$ - 1]));
  }

  IFile file(string[] aPath, string fileName) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
    }

    return null;
  }
  // #endregion file
  // #endregion READ

  // #region UPDATE
  // #region renameFile
  bool renameFile(string oldPathAndName, string newName) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
    }

    if (oldPathAndName is null || newName is null) {
      return false;
    }
    return renameFile(toPathItems(oldPathAndName, pathSeparator), newName);
  }

  bool renameFile(string aPath, string oldName, string newName) {
    if (aPath is null || oldName is null || newName is null) {
      return false;
    }
    return renameFile(toPathItems(aPath, pathSeparator), oldName, newName);
  }

  bool renameFile(string[] oldPathAndName, string newName) {
    if (oldPathAndName.isEmpty) {
      return false;
    }

    string[] aNullArray;
    string oldName = oldPathAndName[$ - 1];
    return (oldPathAndName.length > 1
        ? renameFile(oldPathAndName[0 .. $ - 1], oldName, newName) : renameFile(aNullArray, oldName, newName));
  }

  bool renameFile(string[] aPath, string oldName, string newName) {
    return false;
  }
  // #endregion renameFile
  // #endregion UPDATE

  // #region DELETE
  // #region removeFile
  bool removeFile(string aPath) {
    return removeFile(toPathItems(aPath, pathSeparator));
  }

  bool removeFile(string aPath, string aFileName) {
    return removeFile(toPathItems(aPath, pathSeparator), aFileName);
  }

  bool removeFile(string[] aPath) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": IFile removeFile(string[] aPath)");
    }
    if (aPath.isEmpty) {
      return false;
    }

    string[] aNullArray;
    return (aPath.length > 1
        ? removeFile(aPath[0 .. $ - 1], aPath[$ - 1]) : removeFile(aNullArray, aPath[$ - 1]));
  }

  bool removeFile(string[] aPath, string fileName) {
    return false;
  }
  // #endregion removeFile
  // #endregion DELETE

  // Move File
  bool moveFile(string fromPath, string toPath) {
    return this.moveFile(toPathItems(fromPath, pathSeparator), toPathItems(toPath, pathSeparator));
  }

  bool moveFile(string[] fromPath, string toPath) {
    return this.moveFile(fromPath, toPathItems(toPath, pathSeparator));
  }

  bool moveFile(string fromPath, string[] toPath) {
    return moveFile(toPathItems(fromPath, pathSeparator), toPath);
  }

  bool moveFile(string[] fromPath, string[] toPath) {
    return false;
  }

  bool addFile(IFile aFile) {
    return false;
  }
}
