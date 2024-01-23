/***********************************************************************************
*	Copyright: ©2015-2023 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.filesystems.classes.memory.filesystem;

import uim.filesystems;

unittest { 
  version(testUimFilesystems) { 
    debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); 
  }
}

@safe:
class DMemoryFilesystem : DFilesystem {
  mixin(FilesystemThis!("MemoryFilesystem"));

  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

		pathSeparator("/");
  }

  protected IFilesystemEntry[string] _entries;

	// #region isFolder
    override bool isFolder(string aPath, string aFileName) {
      version(testUimFilesystems) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }
      if (aFileName.isEmpty) { return isFolder(aPath); }

      return isFolder(aPath~pathSeparator~aFileName);
    }

    override bool isFolder(string aPath) {
      version(testUimFilesystems) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }
      if (aPath.isEmpty) { return false; } 

      string myPath = correctPath(aPath);
			return myPath in _entries ? cast(IFolder)_entries[myPath] !is null : false;
    }
    
    override bool isFolder(string[] aPath, string aFileName) {
      version(testUimFilesystems) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }
      if (aFileName.isEmpty) { return isFolder(aPath); }

      string myPath = correctPath((aPath~aFileName).join(pathSeparator));
			return myPath in _entries ? cast(IFolder)_entries[myPath] !is null : false;
    }

    override bool isFolder(string[] aPath) {
      version(testUimFilesystems) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }
      if (aPath.isEmpty) { return false; } 

      string myPath = correctPath(aPath.join(pathSeparator));
			return myPath in _entries ? cast(IFolder)_entries[myPath] !is null : false;
    }

	// #endregion isFolder

	// #region isFile
    override bool isFile(string aPath, string aFileName) {
      version(testUimFilesystems) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }
      if (aFileName.isEmpty) { return isFile(aPath); }

      return isFile(aPath~pathSeparator~aFileName);
    }

    override bool isFile(string aPath) {
      version(testUimFilesystems) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }
      if (aPath.isEmpty) { return false; } 

      string myPath = correctPath(aPath);
			return myPath in _entries ? cast(IFile)_entries[myPath] !is null : false;
    }
    
    override bool isFile(string[] aPath, string aFileName) {
      version(testUimFilesystems) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }
      if (aFileName.isEmpty) { return isFile(aPath); }

      string myPath = correctPath((aPath~aFileName).join(pathSeparator));
			return myPath in _entries ? cast(IFile)_entries[myPath] !is null : false;
    }

    override bool isFile(string[] aPath) {
      version(testUimFilesystems) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }
      if (aPath.isEmpty) { return false; } 

      string myPath = correctPath(aPath.join(pathSeparator));
			return myPath in _entries ? cast(IFile)_entries[myPath] !is null : false;
    }

	// #endregion isFile

	// #region isLink
    override bool isLink(string aPath, string aFileName) {
      version(testUimFilesystems) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }
      if (aFileName.isEmpty) { return isLink(aPath); }

      return isLink(aPath~pathSeparator~aFileName);
    }

    override bool isLink(string aPath) {
      version(testUimFilesystems) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }
      if (aPath.isEmpty) { return false; } 

      string myPath = correctPath(aPath);
			return myPath in _entries ? cast(ILink)_entries[myPath] !is null : false;
    }
    
    override bool isLink(string[] aPath, string aFileName) {
      version(testUimFilesystems) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }
      if (aFileName.isEmpty) { return isLink(aPath); }

      string myPath = correctPath((aPath~aFileName).join(pathSeparator));
			return myPath in _entries ? cast(ILink)_entries[myPath] !is null : false;
    }

    override bool isLink(string[] aPath) {
      version(testUimFilesystems) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }
      if (aPath.isEmpty) { return false; } 

      string myPath = correctPath(aPath.join(pathSeparator));
			return myPath in _entries ? cast(ILink)_entries[myPath] !is null : false;
    }

	// #endregion isLink

  void opIndexAssign(IFilesystemEntry anEntry, string aPath) {
    if (aPath.isEmpty) { return; }

    string myPath = correctPath(aPath);
    _entries[myPath] = anEntry;
  }

  string correctPath(string aPath) {
    if (aPath.isEmpty) { return null; }

    return aPath.split(pathSeparator)
      .map!(item => item.strip)
      .filter!(item => !item.isEmpty)
      .join(pathSeparator);    
  }

  // #region Folders
    override IFolder[] folders() {
      return _entries.byKeyValue
        .filter!(kv => kv.value.isFolder)
        .map!(kv => cast(IFolder)kv.value)
        .array;
    }
  // #endregion Folders

  // #region Files
    override IFile[] files() {
      return _entries.byKeyValue
        .filter!(kv => kv.value.isFile)
        .map!(kv => cast(IFile)kv.value)
        .array;
    }
  // #endregion Files

  // #region Links
    ILink[] links() {
      return _entries.byKeyValue
        .filter!(kv => kv.value.isLink)
        .map!(kv => cast(ILink)kv.value)
        .array;
    }
  // #endregion Links
}
mixin(FilesystemCalls!("MemoryFilesystem"));

unittest {
  auto fs = MemoryFilesystem;
  fs["/test/two"] = MemoryFolder;
  fs["/test/two/foc.xls"] = MemoryFile;
  fs["/test/two/link.xls"] = MemoryLink;

  // #region test isFolder
    assert(fs.isFolder("/test/two"));
    assert(fs.isFolder("test", "two"));
    assert(fs.isFolder(["test", "two"]));
    assert(fs.isFolder(["test"], "two"));
  // #endregion test isFolder

  // #region test isFile
    assert(fs.isFile("/test/two/foc.xls"));
    assert(fs.isFile("test/two", "foc.xls"));
    assert(fs.isFile(["test", "two", "foc.xls"]));
    assert(fs.isFile(["test", "two"], "foc.xls"));
  // #endregion test isFile

  // #region test isLink
    assert(fs.isLink("/test/two/link.xls"));
    assert(fs.isLink("test/two", "link.xls"));
    assert(fs.isLink(["test", "two", "link.xls"]));
    assert(fs.isLink(["test", "two"], "link.xls"));
  // #endregion test isLink
}
