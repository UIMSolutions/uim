/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.filesystems.classes.filesystem;

import uim.filesystems;

unittest {
  version (testUimFilesystems) {
    debug writeln("\n", __MODULE__ ~ ":" ~ __PRETTY_FUNCTION__);
  }
}

@safe:
class DFilesystem : IFilesystem, IFolderManager, IFileManager, ILinkManager {
  this() {
    initialize;
  }

  this(string aRootPath) {
    this();
    this.rootPath(aRootPath);
  }

  bool initialize(IData[string] initData = null) { // Hook
    configuration(new DConfiguration);
    configuration.data(initData);
    
    pathSeparator("/");
    return true;
  }

  // #region Properties
  bool hasFilesystem() {
    return (filesystem !is null);
  }

  mixin(TProperty!("IFilesystem", "filesystem"));

  mixin(TProperty!("string", "className"));
  mixin(TProperty!("string", "rootPath"));
  mixin(TProperty!("string", "invalidCharacters"));
  mixin(TProperty!("string", "pathSeparator"));

  protected IFolder _rootFolder;
  IFolder rootFolder() {
    return _rootFolder;
  }

  // Sets or returns the name of the filesystem
  protected string _name;
  string name() {
    return _name;
  }

  void name(string newName) {
    _name = strip(newName);
  }

  // Returns information about the type of the filesystem
  string type() {
    return null;
  }

  size_t availableDiskSpace() {
    return 0;
  }

  // Returns the size, in bytes, of the filesystem
  size_t size() {
    return 0;
  }

  // Returns the size, in bytes, of the filesystem
  size_t capacity() {
    return 0;
  }
  // #endregion Properties

  // #region path
  // Path starting from filesystem TODO: required?
  string relPath(string aPath) {
    return relPath(toPathItems(aPath, pathSeparator));
  }

  string relPath(string[] pathItems = null) {
    return (pathItems).join(pathSeparator);
  }

  // Path starting from rootpath
  string absolutePath(string aPath) {
    return absolutePath(toPathItems(aPath, pathSeparator));
  }

  string absolutePath(string[] pathItems = null) {
    return (rootPath ~ pathItems).join(pathSeparator);
  }
  // #endregion path

  // #region isFolder
  bool isFolder(string aPath) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ":" ~ __PRETTY_FUNCTION__);
    }
    if (aPath is null) {
      return false;
    }
    return isFolder(toPathItems(aPath, pathSeparator));
  }

  bool isFolder(string aPath, string aFileName) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ":" ~ __PRETTY_FUNCTION__);
    }
    return isFolder(toPathItems(aPath, pathSeparator), aFileName);
  }

  bool isFolder(string[] aPath) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ":" ~ __PRETTY_FUNCTION__);
    }
    if (aPath.length == 0) {
      return false;
    }

    string[] aNullArray;
    return (aPath.length > 1
        ? isFolder(aPath[0 .. $ - 1], aPath[$ - 1]) : isFolder(aNullArray, aPath[$ - 1]));
  }

  bool isFolder(string[] aPath, string aFileName) {
    return false;
  }
  // #endregion isFolder

  // #region isFile
  bool isFile(string aPath) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ":" ~ __PRETTY_FUNCTION__);
    }
    if (aPath is null) {
      return false;
    }
    return isFile(toPathItems(aPath, pathSeparator));
  }

  bool isFile(string aPath, string aFileName) {
    return isFile(toPathItems(aPath, pathSeparator), aFileName);
  }

  bool isFile(string[] aPath) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ":" ~ __PRETTY_FUNCTION__);
    }
    if (aPath.length == 0) {
      return false;
    }

    string[] aNullArray;
    return (aPath.length > 1
        ? isFile(aPath[0 .. $ - 1], aPath[$ - 1]) : isFile(aNullArray, aPath[$ - 1]));
  }

  bool isFile(string[] aPath, string aFileName) {
    return false;
  }
  // #endregion isFile

  // #region isLink
  bool isLink(string aPath) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ":" ~ __PRETTY_FUNCTION__);
    }

    // IN check
    if (aPath.isEmpty) {
      return false;
    }

    // Body
    return isLink(toPathItems(aPath, pathSeparator));
  }

  bool isLink(string aPath, string aLinkName) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ":" ~ __PRETTY_FUNCTION__);
    }

    return isLink(toPathItems(aPath, pathSeparator), aLinkName);
  }

  bool isLink(string[] aPath) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ":" ~ __PRETTY_FUNCTION__);
    }

    // IN Check
    if (aPath.isEmpty) {
      return false;
    }

    string[] aNullArray;
    return (aPath.length > 1
        ? isLink(aPath[0 .. $ - 1], aPath[$ - 1]) : isLink(aNullArray, aPath[$ - 1]));
  }

  bool isLink(string[] aPath, string aLinkName) {
    return false;
  }
  // #endregion isLink

  // #region Entry Management
  mixin EntryManagerTemplate!();

  bool isHidden(string aPath) {
    if (aPath.isEmpty) {
      return false;
    }

    return isHidden(toPathItems(aPath, pathSeparator));
  }

  bool isHidden(string aPath, string aLinkName) {
    return isHidden(toPathItems(aPath, pathSeparator), aLinkName);
  }

  bool isHidden(string[] aPath) {
    if (aPath.isEmpty) {
      return false;
    }

    string[] aNullArray;
    return (aPath.length > 1
        ? isHidden(aPath[0 .. $ - 1], aPath[$ - 1]) : isHidden(aNullArray, aPath[$ - 1]));
  }

  bool isHidden(string[] aPath, string aLinkName) {
    return false;
  }
  // #endregion Entry Management

  mixin FolderManagerTemplate!();
  mixin FileManagerTemplate!();

  void[] readFromFile(string[] aPath, string aFileName, size_t numberOfBytes = size_t.max) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ":" ~ __PRETTY_FUNCTION__);
      debug writeln("aPath     = \t", aPath);
      debug writeln("aFileName = \t", aFileName);
    }

    return null;
  }

  void writeToFile(string[] aPath, string aFileName, const void[] buffer) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ":" ~ __PRETTY_FUNCTION__);
      debug writeln("aPath     = \t", aPath);
      debug writeln("aFileName = \t", aFileName);
    }
  }

  void appendToFile(string[] aPath, string aFileName, const void[] buffer) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ":" ~ __PRETTY_FUNCTION__);
      debug writeln("aPath     = \t", aPath);
      debug writeln("aFileName = \t", aFileName);
    }
  }

  string readTextFromFile(string[] aPath, string aFileName) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ":" ~ __PRETTY_FUNCTION__);
      debug writeln("aPath     = \t", aPath);
      debug writeln("aFileName = \t", aFileName);
    }

    return null;
  }

  void writeTextToFile(string[] aPath, string aFileName, string aText) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ":" ~ __PRETTY_FUNCTION__);
      debug writeln("aPath     = \t", aPath);
      debug writeln("aFileName = \t", aFileName);
    }
  }

  void appendTextToFile(string[] aPath, string aFileName, string aText) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ":" ~ __PRETTY_FUNCTION__);
      debug writeln("aPath     = \t", aPath);
      debug writeln("aFileName = \t", aFileName);
    }
  }

  string[] readLines(string[] aPath, string aFileName) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ":" ~ __PRETTY_FUNCTION__);
      debug writeln("aPath     = \t", aPath);
      debug writeln("aFileName = \t", aFileName);
    }

    return null;
  }

  mixin LinkManagerTemplate!();
}

mixin(FilesystemCalls!("Filesystem"));

unittest {
  assert(Filesystem, "Could not create Filesystem");
}
