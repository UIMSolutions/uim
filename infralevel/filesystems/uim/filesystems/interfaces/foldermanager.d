/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.filesystems.interfaces.foldermanager;

mixin(Version!"test_uim_filesystems");

import uim.filesystems;
@safe:

interface IFolderManager {
  IFolder folder(string aPath);
  IFolder folder(string aPath, string aFolderName);
  IFolder folder(string[] aPath);
  IFolder folder(string[] aPath, string aFolderName);

  // Returns a Folders collection consisting of all Folder objects contained in the specified folder, including those with hidden and system folder attributes set.
  bool existsFolders(string aPath);
  bool existsFolders(string aPath, string aFolderName);
  bool existsFolders(string[] aPath);
  bool existsFolders(string[] aPath, string aFolderName);

  size_t countFolders(string aPath);
  size_t countFolders(string aPath, string aFolderName);
  size_t countFolders(string[] aPath);
  size_t countFolders(string[] aPath, string aFolderName);

  IFolder[] folders();
  IFolder[] folders(string aPath);
  IFolder[] folders(string aPath, string aFolderName);
  IFolder[] folders(string[] aPath);
  IFolder[] folders(string[] aPath, string aFolderName);

  // Checks if a specified folder exists.
  bool existsFolder(string aPath);
  bool existsFolder(string aPath, string aFolderName);
  bool existsFolder(string[] aPath);
  bool existsFolder(string[] aPath, string aFolderName);

  // Creates folder 
  IFolder createFolder(string aPath);
  IFolder createFolder(string aPath, string aFolderName);
  IFolder createFolder(string[] aPath);
  IFolder createFolder(string[] aPath, string aFolderName);

  // Creates folder if not exits
  IFolder createIfNotExistsFolder(string aPath);
  IFolder createIfNotExistsFolder(string aPath, string aFolderName);
  IFolder createIfNotExistsFolder(string[] aPath);
  IFolder createIfNotExistsFolder(string[] aPath, string aFolderName);

  // Add folder from one location to another.
  final bool addFolders(IFolder[] someFolders...) {
    return addFolders(someFolders.dup);
  }

  final bool addFolders(IFolder[] someFolders) {
    if (someFolders.isEmpty) {
      return false;
    }

    foreach (myFolder; someFolders) {
      if (!addFolder(myFolder)) {
        return false;
      }
    }

    return true;
  }

  bool addFolder(IFolder aFolder);

  bool renameFolder(string oldPathAndName, string newName);
  bool renameFolder(string aPath, string oldName, string newName);
  bool renameFolder(string[] oldPathAndName, string newName);
  bool renameFolder(string[] aPath, string oldName, string newName);

  // Copies folder from one location to another.
  bool copyFolder(string fromPath, string toPath);
  bool copyFolder(string[] fromPath, string[] toPath);
  bool copyFolder(IFolder aFolder, string[] toPath);
  bool copyFolder(IFolder aFolder, IFolder toFolder);

  // Moves folder from one location to another.
  bool moveFolder(string fromPath, string toPath);
  bool moveFolder(string[] fromPath, string[] toPath);
  bool moveFolder(IFolder aFolder, string[] toPath);
  bool moveFolder(IFolder aFolder, IFolder toFolder);

  bool removeFolder(string aPath);
  bool removeFolder(string aPath, string aFolderName);
  bool removeFolder(string[] aPath);
  bool removeFolder(string[] aPath, string aFolderName);
}
