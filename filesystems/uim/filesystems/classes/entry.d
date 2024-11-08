/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.filesystems.classes.entry;

import uim.filesystems;

unittest {
  version (testUimFilesystems) {
    debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
  }
}

@safe:
class DFilesystemEntry : UIMObject, IFilesystemEntry {
  this() {
    super("FilesystemEntry");
  }

  this(Json[string] initData) {
    super("FilesystemEntry", initData);
  }

  this(string name, Json[string] initData = null) {
    super(name, initData);
  }

  this(string[] path, Json[string] initData = null) {
    this(initData);
    this.path(path);
  }

  this(IFilesystem filesystem, Json[string] initData = null) {
    this(initData);
    this.filesystem(filesystem);
  }

  this(IFilesystem filesystem, string name, Json[string] initData = null) {
    this(name, initData);
    this.filesystem(filesystem);
  }

  this(IFilesystem filesystem, string[] path, Json[string] initData = null) {
    this(name, initData);
    this.filesystem(filesystem);
  }

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    return true;
  }

  // Owning Filesystem
  bool hasFilesystem() {
    return (filesystem !is null);
  }

  mixin(TProperty!("IFilesystem", "filesystem"));

  // Get name of entry
  mixin(TProperty!("string[]", "path"));

  size_t size() {
    return 0;
  }

  void parentFolder(IFolder aFolder) {
  }

  IFolder parentFolder() {
    return null;
  }

  bool exists() { // TODO
    return (hasFilesystem ? filesystem.existsFolder(name) : false);
  }

  // #region path
  // Path starting from filesystem TODO: required?
  string relPath(string aPath) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
      debug writeln("aPath = %s".format(aPath));
    }

    return (filesystem ? filesystem.relPath(aPath) : null);
  }

  string relPath(string[] pathItems = null) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
      debug writeln("pathItems = %s".format(pathItems));
    }

    return (filesystem ? filesystem.relPath(pathItems) : null);
  }

  // Path starting from rootpath
  string absolutePath(string aPath) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
      debug writeln("aPath = %s".format(aPath));
    }

    return (filesystem ? filesystem.absolutePath(aPath) : null);
  }

  string absolutePath(string[] pathItems = null) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
      debug writeln("pathItems = %s".format(pathItems));
    }

    return (filesystem ? filesystem.absolutePath(pathItems) : null);
  }
  // #endregion path

  // Rename entry
  bool rename(string newName) {
    return false;
  }

  // Check if entry is hidden
  bool isHidden() {
    return false;
  }

  // #region isFolder
  bool isFolder() {
    return false;
  }
  // #endregion isFolder

  // #region isFile
  bool isFile() {
    return false;
  }
  // #endregion isFile

  // #region isLink
  bool isLink() {
    return false;
  }
  // #endregion isLink

  override string toString() {
    return this.classname ~ ": " ~ name;
  }

  override Json[string] debugInfo() {
    return super.debugInfo()
      .set("relPath", relPath)
      .set("absolutePath", absolutePath);
  }
}

auto FilesystemEntry() {
  return new DFilesystemEntry();
}

unittest {
  // TODO add tests
}
