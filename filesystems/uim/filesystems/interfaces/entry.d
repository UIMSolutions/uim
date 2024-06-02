/***********************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (UIManufaktur)										           * 
***********************************************************************************/
module uim.filesystems.interfaces.entry;

import uim.filesystems;

@safe:
interface IFilesystemEntry {
  bool hasFilesystem();
  IFilesystem filesystem();

  // Sets or returns the name of a specified entry.
  string name();
  void name(string newName);

  // Sets or returns the path of a specified entry.
  string[] path();
  void path(string[] aPath);

  // Returns the folder object for the parent of the specified file.
  IFolder parentFolder();
  void parentFolder(IFolder aFolder);

  // Name of class

  // Returns the size of a specified folder.
  size_t size();

  // Rename entry
  bool rename(string newName);

  // Check if filesystem entry is hidden
 	bool exists(); 

  // Check if filesystem entry is hidden
  bool isHidden();

  // Check if filesystem entry is folder
  bool isFolder();

  // Check if filesystem entry is file
  bool isFile();

  // Check if filesystem entry is link
  bool isLink();

  string relPath(string aPath); 
  string relPath(string[] aPath = null); 

  string absolutePath(string aPath); 
  string absolutePath(string[] aPath = null); 

  string toString();
}