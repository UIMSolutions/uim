/***********************************************************************************************************************
*	Copyright: © 2015 - 2024 Ozan Nurettin Süel (sicherheitsschmiede) / 2022 Ozan Nurettin Süel (sicherheitsschmiede)                              *
*	License: Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt]                                       *
*	Authors: Ozan Nurettin Süel (sicherheitsschmiede) Team, Ozan Nurettin Süel (Sicherheitsschmiede)										                         * 
***********************************************************************************************************************/
module uim.filesystems.interfaces.filemanager;

import uim.filesystems;

@safe:
interface IFileManager {
  bool hasFiles(string aPathOrName);
  bool hasFiles(string aPath, string aFileName);
  bool hasFiles(string[] aPath);
  bool hasFiles(string[] aPath, string aFileName);

  size_t countFiles(string aPathOrName);
  size_t countFiles(string aPath, string aFileName);
  size_t countFiles(string[] aPath);
  size_t countFiles(string[] aPath, string aFileName);

  IFile[] files();
  IFile[] files(string aPathOrName);
  IFile[] files(string aPath, string aFileName);
  IFile[] files(string[] aPath);
  IFile[] files(string[] aPath, string aFileName);

  // Returns a File object for a specified path.
  IFile file(string aPathOrName);
  IFile file(string aPath, string aFileName);
  IFile file(string[] aPath);
  IFile file(string[] aPath, string aFileName);

  bool existsFile(string aPathOrName);
  bool existsFile(string aPath, string aFileName);
  bool existsFile(string[] aPath);
  bool existsFile(string[] aPath, string aFileName);

  bool addFile(IFile aFile);

  IFile createFile(string aPathOrName);
  IFile createFile(string aPath, string aFileName);
  IFile createFile(string[] aPath);
  IFile createFile(string[] aPath, string aFileName);

  bool renameFile(string oldPathAndName, string newName);
  bool renameFile(string aPath, string oldName, string newName);
  bool renameFile(string[] oldPathAndName, string newName);
  bool renameFile(string[] aPath, string oldName, string newName);

  // Copies file from one location to another.
  bool copyFile(string fromPath, string toPath);
  bool copyFile(string[] fromPath, string[] toPath);

  // Moves one or more files from one location to another.
  bool moveFile(string fromPath, string toPath);
  bool moveFile(string[] fromPath, string[] toPath);

  // Checks if a specified file exists.
  final bool filesExists(IFile[] someFiles) {
    if (someFiles.isEmpty) { return false; }

    foreach(myFile; someFiles) {
      if (!myFile.exists) { return false; }
    }

    return true;
  }

  bool removeFile(string aPath);
  bool removeFile(string aPath, string aFolderName);
  bool removeFile(string[] aPath);
  bool removeFile(string[] aPath, string aFolderName);
}