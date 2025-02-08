/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.filesystems.classes.os.linux.filesystem;

import uim.filesystems;

@safe:
class DLinuxFilesystem : DFilesystem {
  mixin(FilesystemThis!("Linux"));

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    pathSeparator("/");
    return true;
  }

  override size_t availableDiskSpace() {
    return getAvailableDiskSpace(rootPath);
  }

  // #region isFolder
  override bool isFolder(string[] aPath, string aFolderName) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
    }
    if (aPath.length == 0 && aFolderName.length == 0) {
      return false;
    }

    auto myPath = (aPath.length > 0
        ? (aFolderName.length > 0 ? absolutePath(aPath ~ aFolderName) : absolutePath(aPath)) : absolutePath(
          aFolderName));

    return (myPath.exists ? myPath.isDir : false);
  }
  // #endregion isFolder

  // #region Folders
  // #region Create
  // #endregion Create

  // #region Read
  // #region existsFolders() 
  alias existsFolders = DFilesystem.existsFolders;
  override bool existsFolders(string[] aPath, string aFolderName) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
      debug writeln("aPath = \t", aPath, "\taFolderName = \t", aFolderName);
    }
    auto myFolderPath = (!aPath.isEmpty || !aFolderName.isEmpty ? absolutePath(aPath ~ aFolderName)
        : rootPath);

    // debug writeln("myFolderPath = ", myFolderPath);
    bool result = false;
    () @trusted {
      result = std.file.dirEntries(myFolderPath, SpanMode.shallow).array.length > 0;
    }();
    return result;
  }
  // #endregion existsFolders() 

  // #region folders()
  alias folders = DFilesystem.folders;
  override IFolder[] folders(string[] aPath, string aFolderName) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
      debug writeln("aPath = \t", aPath, "\t aFolderName = \t", aFolderName);
    }
    auto myFolderPath = (!aPath.isEmpty || !aFolderName.isEmpty ? absolutePath(aPath ~ aFolderName)
        : rootPath);

    // debug writeln("myFolderPath = ", myFolderPath);
    IFolder[] results;
    () @trusted {
      foreach (std.file.DirEntry entry; std.file.dirEntries(myFolderPath, SpanMode.shallow)
        .filter!(entry => entry.isDir)
        .array
        ) {
        auto pathItems = toPathItems(entry.name[rootPath.length .. $]);
        results ~= LinuxFolder(this, aPath ~ aFolderName);
      }
    }();

    return results;
  }
  // #endregion folders()

  // #region countFolders() 
  alias countFolders = DFilesystem.countFolders;
  override size_t countFolders(string[] aPath, string aFolderName) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
      debug writeln("aPath = ", aPath, "\t aFolderName = ", aFolderName);
    }
    auto myFolderPath = (!aPath.isEmpty || !aFolderName.isEmpty ? absolutePath(aPath ~ aFolderName)
        : rootPath);

    // debug writeln("myFolderPath = ", myFolderPath);
    size_t result = false;
    () @trusted {
      result = std.file.dirEntries(myFolderPath, SpanMode.shallow).array.length;
    }();
    return result;
  }
  // #endregion countFolders()   
  // #endregion Read

  // #region Update
  // #endregion Update

  // #region Delete
  // #endregion Delete
  // #endregion Folders

  // #region Folder
  // #region Create
  alias createFolder = DFilesystem.createFolder;
  override IFolder createFolder(string[] aPath, string aFolderName) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
      debug writeln("aPath = \t", aPath);
      debug writeln("aFolderName = \t", aFolderName);
    }
    if (existsFolder(aPath, aFolderName)) {
      return null;
    } // A Folder exists

    std.file.mkdir(absolutePath(aPath ~ aFolderName));

    return folder(aPath, aFolderName);
  }
  // #endregion Create

  // #region Read
  // #region existsFolder()
  alias existsFolder = DFilesystem.existsFolder;
  override bool existsFolder(string[] aPath, string aFolderName) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
      debug writeln("aPath = \t", aPath);
      debug writeln("aFolderName = \t", aFolderName);
    }
    return (std.file.exists(absolutePath(aPath ~ aFolderName)) && std.file.isDir(
        absolutePath(aPath ~ aFolderName)));
  }
  // #endregion existsFolder()

  // #region folder()
  alias folder = DFilesystem.folder;
  override IFolder folder(string[] aPath, string aFolderName) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
      debug writeln("aPath = \t", aPath);
      debug writeln("aFolderName = \t", aFolderName);
    }
    if (!existsFolder(aPath, aFolderName)) {
      return null;
    }

    return LinuxFolder(this, aPath ~ aFolderName);
  }
  // #endregion folder()
  // #endregion Read

  // #region Update
  alias renameFolder = DFilesystem.renameFolder;
  override bool renameFolder(string[] aPath, string oldName, string newName) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
      debug writeln("aPath = \t", aPath);
      debug writeln("oldName = \t", oldName, " \tnewName = \t", newName);
    }
    if (!existsFolder(aPath, oldName) || newName is null) {
      return false;
    }

    std.file.rename(absolutePath(aPath ~ oldName), absolutePath(aPath ~ newName));
    return existsFolder(aPath, newName);
  }
  // #endregion Update

  // #region Delete
  alias removeFolder = DFilesystem.removeFolder;
  override bool removeFolder(string[] aPath, string aFolderName) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
    }
    if (!existsFolder(aPath)) {
      return false;
    } // Folder missing

    debug writeln("absolutePath(aPath) -> ", absolutePath(aPath ~ aFolderName));
    std.file.rmdir(absolutePath(aPath ~ aFolderName));

    return !existsFolder(aPath, aFolderName);
  }
  // #endregion Delete
  // #endregion Folder

  // #region Files
  // #region Create

  // #endregion Create

  // #region Read

  // #endregion Read

  // #region Update
  // #endregion Update

  // #region Delete
  // #endregion Delete
  // #endregion Files

  // #region File
  // #region Create
  alias createFile = DFilesystem.createFile;
  override IFile createFile(string[] aPath, string aFileName) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
      debug writeln("aPath = \t", aPath, "\taFileName = \t", aFileName);
    }
    if (aPath.isEmpty || aFileName.length == 0) {
      return null;
    }
    if (existsFile(aPath, aFileName)) {
      return null;
    }

    auto myFile = std.stdio.File(absolutePath(aPath ~ aFileName), "w");
    myFile.close;

    return file(aPath, aFileName);
  }
  // #endregion Create

  // #region Read
  alias existsFile = DFilesystem.existsFile;
  override bool existsFile(string[] aPath, string aFileName) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
      debug writeln("aPath = \t", aPath, "\taFileName = \t", aFileName);
    }
    string myabsolutePath = absolutePath(aPath ~ aFileName);
    return std.file.exists(myabsolutePath) && std.file.isFile(myabsolutePath);
  }

  alias file = DFilesystem.file;
  override IFile file(string[] aPath, string aFileName) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
    }
    string myabsolutePath = absolutePath(aPath ~ aFileName);
    if (!std.file.exists(myabsolutePath) || !std.file.isFile(myabsolutePath)) {
      return null;
    }

    return LinuxFile(this, aPath ~ aFileName);
  }
  // #endregion Read

  // #region Update
  alias renameFile = DFilesystem.renameFile;
  override bool renameFile(string[] aPath, string oldFileName, string newFileName) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
      debug writeln("aPath = \t", aPath);
      debug writeln("oldFileName = \t", oldFileName, " \newFileName = \t", newFileName);
    }
    if (!existsFile(aPath, oldFileName) || newFileName is null) {
      return false;
    }

    // version(testUimFilesystems) { debug writeln("From ", absolutePath(aPath~oldName), " to", absolutePath(aPath~newName)); 
    std.file.rename(absolutePath(aPath ~ oldFileName), absolutePath(aPath ~ newFileName));
    return existsFile(aPath, newFileName);
  }
  // #endregion Update

  // #region Delete
  alias removeFile = DFilesystem.removeFile;
  override bool removeFile(string[] aPath, string aFileName) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
    }
    if (!existsFile(aPath, aFileName)) {
      return false;
    }

    remove(absolutePath(aPath ~ aFileName));

    return !existsFile(aPath, aFileName);
  }
  // #endregion Delete
  // #endregion File

  // #region Links
  // #region Create
  // #endregion Create

  // #region Read
  // #endregion Read

  // #region Update
  // #endregion Update

  // #region Delete
  // #endregion Delete
  // #endregion Links

  // #region Link
  // #region Create
  // #endregion Create

  // #region Read
  // #endregion Read

  // #region Update
  // #endregion Update

  // #region Delete
  // #endregion Delete
  // #endregion Link

  override bool isFile(string[] aPath, string aFileName) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
      debug writeln("aPath = \t", aPath, "\t aFileName = \t", aFileName);
    }
    if (aPath.length == 0 && aFileName.length == 0) {
      return false;
    }

    auto myPath = (aPath.length > 0
        ? (aFileName.length > 0 ? absolutePath(aPath ~ aFileName) : absolutePath(aPath)) : absolutePath(
          aFileName));

    return (myPath.exists ? myPath.isFile : false);
  }

  override bool isLink(string[] aPath, string aLinkName) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
      debug writeln("aPath = \t", aPath, "\t aLinkName = \t", aLinkName);
    }
    if (aPath.isEmpty && aLinkName.isEmpty) {
      return false;
    }

    auto myPath = (aPath.length > 0
        ? (aLinkName.length > 0 ? absolutePath(aPath ~ aLinkName) : absolutePath(aPath)) : absolutePath(
          aLinkName));

    return (myPath.exists ? myPath.isSymlink : false);
  }
  // #endregion Folder

  // #region Filemanager
  override IFile[] files(string[] aPath) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
      debug writeln("aPath = \t", aPath);
    }
    auto myFolderPath = aPath ? absolutePath(aPath) : rootPath;

    IFile[] results;
    () @trusted {
      results = std.file.dirEntries(myFolderPath, SpanMode.shallow)
        .filter!(entry => entry.isFile)
        .map!(entry => cast(IFile) LinuxFile(this, entry.name[rootPath.length .. $]))
        .array;
    }();

    return results;
  }

  override void[] readFromFile(string[] aPath, string aFileName, size_t numberOfBytes = size_t.max) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
      debug writeln("aPath    = \t", aPath);
      debug writeln("aFileName = \t", aFileName);
    }

    return null;
  }

  override void writeToFile(string[] aPath, string aFileName, const void[] data) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
      debug writeln("aPath    = \t", aPath);
      debug writeln("aFileName = \t", aFileName);
    }

    std.file.write(absolutePath(aPath ~ aFileName), data);
  }

  override void appendToFile(string[] aPath, string aFileName, const void[] data) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
      debug writeln("aPath    = \t", aPath);
      debug writeln("aFileName = \t", aFileName);
    }

    std.file.append(absolutePath(aPath ~ aFileName), data);
  }

  override string readTextFromFile(string[] aPath, string aFileName) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
      debug writeln("aPath    = \t", aPath);
      debug writeln("aFileName = \t", aFileName);
    }

    return std.file.readText(absolutePath(aPath ~ aFileName));
  }

  override void writeTextToFile(string[] aPath, string aFileName, string aText) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
      debug writeln("aPath    = \t", aPath);
      debug writeln("aFileName = \t", aFileName);
    }

    std.file.write(absolutePath(aPath ~ aFileName), aText);
  }

  override void appendTextToFile(string[] aPath, string aFileName, string aText) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
      debug writeln("aPath    = \t", aPath);
      debug writeln("aFileName = \t", aFileName);
    }

    std.file.append(absolutePath(aPath ~ aFileName), aText);
  }

  override string[] readLines(string[] aPath, string aFileName) {
    version (testUimFilesystems) {
      debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
      debug writeln("aPath    = \t", aPath);
      debug writeln("aFileName = \t", aFileName);
    }

    return null;
  }

  // #endregion Filemanager
  /*
  // #region LinkManagement
    override ILink[] links(string aPath = null) {
      auto myFolderPath = aPath ? absolutePath(aPath) : rootPath;

      ILink[] results;
      () @trusted { 
        foreach (std.file.DirEntry entry;  std.file.dirEntries(myFolderPath, SpanMode.shallow)) {
          if (entry.isSymlink) results~=LinuxLink(this, entry.name[rootPath.length..$]);
        }  
      } ();

      return results;
    }*/
  override ILink createLink(string[] aPath) {
    if (!existsLink(aPath)) {
      return null;
    }

    return null;
  }
  // #endregion LinkManagement */
}

mixin(FilesystemCalls!("Linux"));

version (testUimFilesystems) {
  unittest {
    version (testUimFilesystems) {
      debug writeln(StyledString("\nStart tests in " ~ __MODULE__)
          .setBackground(AnsiColor.yellow).setForeground(AnsiColor.black));
    }

    auto fs = LinuxFilesystem("TestFS");
    fs.rootPath("./for_testing");
    assert(fs.rootPath == "./for_testing");

    fs.createIfNotExistsFolder("LinuxFilesystem");
    fs.createIfNotExistsFolder(["LinuxFilesystem"], "filesystems");

    // debug writeln(fs.availableDiskSpace(), "Bytes available");

    IFilesystem myFileSystem = fs;
    assert(myFileSystem.rootPath == "./for_testing");

    // debug writeln("start tests");
    testFilesystem(myFileSystem);

    //debug writeln("Test Identify type");
    assert(!myFileSystem.isFolder(""), "\tERROR: No Folder detected");

    // #region Test Folder
    myFileSystem.createIfNotExistsFolder("LinuxFilesystem/folders");
    myFileSystem.createIfNotExistsFolder("LinuxFilesystem/folders/creatingFolders");

    testFilesystem_CreateFolders(__MODULE__, myFileSystem, "LinuxFilesystem/folders/creatingFolders", [
        "LinuxFilesystem", "folders", "creatingFolders"
      ]);

    myFileSystem.createIfNotExistsFolder("LinuxFilesystem/folders/readFolders");
    testFilesystem_ReadFolders(__MODULE__, myFileSystem, "LinuxFilesystem/folders/readFolders", [
        "LinuxFilesystem", "folders", "readFolders"
      ]);

    myFileSystem.createIfNotExistsFolder("LinuxFilesystem/folders/updateFolders");
    testFilesystem_UpdateFolders(__MODULE__, myFileSystem, "LinuxFilesystem/folders/updateFolders", [
        "LinuxFilesystem", "folders", "updateFolders"
      ]);

    if (!myFileSystem.existsFolder("LinuxFilesystem/folders/removeFolders")) {
      myFileSystem.createFolder("LinuxFilesystem/folders/removeFolders");
    }
    testFilesystem_RemoveFolders(__MODULE__, myFileSystem, "LinuxFilesystem/folders/removeFolders", [
        "LinuxFilesystem", "folders", "removeFolders"
      ]);
    // #endregion Test Folder

    // #region Test Folder
    if (!myFileSystem.existsFolder("LinuxFilesystem/folder")) {
      myFileSystem.createFolder("LinuxFilesystem/folder");
    }

    if (!myFileSystem.existsFolder("LinuxFilesystem/folder/creatingFolders")) {
      myFileSystem.createFolder("LinuxFilesystem/folder/creatingFolders");
    }
    testFilesystem_CreateFolder(__MODULE__, myFileSystem, "LinuxFilesystem/folder/creatingFolders", [
        "LinuxFilesystem", "folder", "creatingFolders"
      ]);

    if (!myFileSystem.existsFolder("LinuxFilesystem/folder/readFolders")) {
      myFileSystem.createFolder("LinuxFilesystem/folder/readFolders");
    }
    testFilesystem_ReadFolder(__MODULE__, myFileSystem, "LinuxFilesystem/folder/readFolders", [
        "LinuxFilesystem", "folder", "readFolders"
      ]);

    if (!myFileSystem.existsFolder("LinuxFilesystem/folder/updateFolders")) {
      myFileSystem.createFolder("LinuxFilesystem/folder/updateFolders");
    }
    testFilesystem_UpdateFolder(__MODULE__, myFileSystem, "LinuxFilesystem/folder/updateFolders", [
        "LinuxFilesystem", "folder", "updateFolders"
      ]);

    if (!myFileSystem.existsFolder("LinuxFilesystem/folder/removeFolders")) {
      myFileSystem.createFolder("LinuxFilesystem/folder/removeFolders");
    }
    testFilesystem_RemoveFolder(__MODULE__, myFileSystem, "LinuxFilesystem/folder/removeFolders", [
        "LinuxFilesystem", "folder", "removeFolders"
      ]);
    // #endregion Test Folder

    // #region Test Files
    if (!myFileSystem.existsFolder("LinuxFilesystem/files")) {
      myFileSystem.createFolder("LinuxFilesystem/files");
    }

    if (!myFileSystem.existsFolder("LinuxFilesystem/files/creatingFiles")) {
      myFileSystem.createFolder("LinuxFilesystem/files/creatingFiles");
    }
    testFilesystem_CreateFiles(__MODULE__, myFileSystem, "LinuxFilesystem/files/creatingFiles", [
        "LinuxFilesystem", "files", "creatingFiles"
      ]);

    if (!myFileSystem.existsFolder("LinuxFilesystem/files/readFiles")) {
      myFileSystem.createFolder("LinuxFilesystem/files/readFiles");
    }
    testFilesystem_ReadFiles(__MODULE__, myFileSystem, "LinuxFilesystem/files/readFiles", [
        "LinuxFilesystem", "files", "readFiles"
      ]);

    if (!myFileSystem.existsFolder("LinuxFilesystem/files/updateFiles")) {
      myFileSystem.createFolder("LinuxFilesystem/files/updateFiles");
    }
    testFilesystem_UpdateFiles(__MODULE__, myFileSystem, "LinuxFilesystem/files/updateFiles", [
        "LinuxFilesystem", "files", "updateFiles"
      ]);

    if (!myFileSystem.existsFolder("LinuxFilesystem/files/removeFiles")) {
      myFileSystem.createFolder("LinuxFilesystem/files/removeFiles");
    }
    testFilesystem_RemoveFiles(__MODULE__, myFileSystem, "LinuxFilesystem/files/removeFiles", [
        "LinuxFilesystem", "files", "removeFiles"
      ]);
    // #endregion Test Files

    // #region Test File
    if (!myFileSystem.existsFolder("LinuxFilesystem/file")) {
      myFileSystem.createFolder("LinuxFilesystem/file");
    }

    if (!myFileSystem.existsFolder("LinuxFilesystem/files/creatingFiles")) {
      myFileSystem.createFolder("LinuxFilesystem/files/creatingFiles");
    }
    testFilesystem_CreateFile(__MODULE__, myFileSystem, "LinuxFilesystem/files/creatingFiles", [
        "LinuxFilesystem", "files", "creatingFiles"
      ]);

    if (!myFileSystem.existsFolder("LinuxFilesystem/files/readFiles")) {
      myFileSystem.createFolder("LinuxFilesystem/files/readFiles");
    }
    testFilesystem_ReadFile(__MODULE__, myFileSystem, "LinuxFilesystem/files/readFiles", [
        "LinuxFilesystem", "files", "readFiles"
      ]);

    if (!myFileSystem.existsFolder("LinuxFilesystem/files/updateFiles")) {
      myFileSystem.createFolder("LinuxFilesystem/files/updateFiles");
    }
    testFilesystem_UpdateFile(__MODULE__, myFileSystem, "LinuxFilesystem/files/updateFiles", [
        "LinuxFilesystem", "files", "updateFiles"
      ]);

    if (!myFileSystem.existsFolder("LinuxFilesystem/files/removeFiles")) {
      myFileSystem.createFolder("LinuxFilesystem/files/removeFiles");
    }
    testFilesystem_removeFile(__MODULE__, myFileSystem, "LinuxFilesystem/files/removeFiles", [
        "LinuxFilesystem", "files", "removeFiles"
      ]);
    // #endregion Test File

    // #region Test Links
    if (!myFileSystem.existsFolder("LinuxFilesystem/links")) {
      myFileSystem.createFolder("LinuxFilesystem/links");
    }

    if (!myFileSystem.existsFolder("LinuxFilesystem/links/creatingLinks")) {
      myFileSystem.createFolder("LinuxFilesystem/links/creatingLinks");
    }
    testFilesystem_CreateLinks(__MODULE__, myFileSystem, "LinuxFilesystem/links/creatingLinks", [
        "LinuxFilesystem", "links", "creatingLinks"
      ]);

    if (!myFileSystem.existsFolder("LinuxFilesystem/links/readLinks")) {
      myFileSystem.createFolder("LinuxFilesystem/links/readLinks");
    }
    testFilesystem_ReadLinks(__MODULE__, myFileSystem, "LinuxFilesystem/links/readLinks", [
        "LinuxFilesystem", "links", "readLinks"
      ]);

    if (!myFileSystem.existsFolder("LinuxFilesystem/links/updateLinks")) {
      myFileSystem.createFolder("LinuxFilesystem/links/updateLinks");
    }
    testFilesystem_UpdateLinks(__MODULE__, myFileSystem, "LinuxFilesystem/links/updateLinks", [
        "LinuxFilesystem", "links", "updateLinks"
      ]);

    if (!myFileSystem.existsFolder("LinuxFilesystem/links/removeLinks")) {
      myFileSystem.createFolder("LinuxFilesystem/links/removeLinks");
    }
    testFilesystem_RemoveLinks(__MODULE__, myFileSystem, "LinuxFilesystem/links/removeLinks", [
        "LinuxFilesystem", "links", "removeLinks"
      ]);
    // #endregion Test Links

    // #region Test Link
    if (!myFileSystem.existsFolder("LinuxFilesystem/link")) {
      myFileSystem.createFolder("LinuxFilesystem/link");
    }

    if (!myFileSystem.existsFolder("LinuxFilesystem/links/creatingLinks")) {
      myFileSystem.createFolder("LinuxFilesystem/links/creatingLinks");
    }
    testFilesystem_CreateLink(__MODULE__, myFileSystem, "LinuxFilesystem/links/creatingLinks", [
        "LinuxFilesystem", "links", "creatingLinks"
      ]);

    if (!myFileSystem.existsFolder("LinuxFilesystem/links/readLinks")) {
      myFileSystem.createFolder("LinuxFilesystem/links/readLinks");
    }
    testFilesystem_ReadLink(__MODULE__, myFileSystem, "LinuxFilesystem/links/readLinks", [
        "LinuxFilesystem", "links", "readLinks"
      ]);

    if (!myFileSystem.existsFolder("LinuxFilesystem/links/updateLinks")) {
      myFileSystem.createFolder("LinuxFilesystem/links/updateLinks");
    }
    testFilesystem_UpdateLink(__MODULE__, myFileSystem, "LinuxFilesystem/links/updateLinks", [
        "LinuxFilesystem", "links", "updateLinks"
      ]);

    if (!myFileSystem.existsFolder("LinuxFilesystem/links/removeLinks")) {
      myFileSystem.createFolder("LinuxFilesystem/links/removeLinks");
    }
    testFilesystem_RemoveLink(__MODULE__, myFileSystem, "LinuxFilesystem/links/removeLinks", [
        "LinuxFilesystem", "links", "removeLinks"
      ]);
    // #endregion Test Link
    version (testUimFilesystems) {
      debug writeln(StyledString("End tests in " ~ __MODULE__)
          .setBackground(AnsiColor.white).setForeground(AnsiColor.black));
    }
  }
}
