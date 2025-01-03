/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.filesystems.interfaces.filesystem;

import uim.filesystems;

@safe:

interface IFilesystem : IFolderManager, IFileManager, ILinkManager {
  // #region Properties
  // Returns rootPath of filesystem
  string rootPath();

  // Sets or returns the path of the filesystem
  string[] path();
  void path(string[] path);

  // Returns information about type of filsystem
  string type();

  // Returns the size, in bytes, of the filesystem
  size_t size();

  // Returns the size, in bytes, of the filesystem
  size_t capacity();

  IFolder rootFolder();
  IFilesystem filesystem();
  string pathSeparator();
  size_t availableDiskSpace();

  bool isHidden(string aPath);
  bool isHidden(string aPath, string aFolderName);
  bool isHidden(string[] aPath);
  bool isHidden(string[] aPath, string aFolderName);

  string relPath(string aPath);
  string relPath(string[] aPath);

  string absolutePath(string aPath);
  string absolutePath(string[] aPath);
  // #endregion Properties

  bool isFolder(string aPath);
  bool isFolder(string aPath, string aFolderName);
  bool isFolder(string[] aPath);
  bool isFolder(string[] aPath, string aFolderName);

  // Check if entry is file
  bool isFile(string aPath);
  bool isFile(string aPath, string aFolderName);
  bool isFile(string[] aPath);
  bool isFile(string[] aPath, string aFolderName);

  void[] readFromFile(string[] aPath, string aFileName, size_t numberOfBytes = size_t.max);

  void writeToFile(string[] aPath, string aFileName, const void[] buffer);

  void appendToFile(string[] aPath, string aFileName, const void[] buffer);

  string readTextFromFile(string[] aPath, string aFileName);

  void writeTextToFile(string[] aPath, string aFileName, string aText);

  void appendTextToFile(string[] aPath, string aFileName, string aText);

  string[] readLines(string[] aPath, string aFileName);

  // Check if entry is link
  bool isLink(string aPath);
  bool isLink(string aPath, string aFolderName);
  bool isLink(string[] aPath);
  bool isLink(string[] aPath, string aFolderName);
}
