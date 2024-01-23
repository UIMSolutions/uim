/***********************************************************************************
*	Copyright: ©2015-2023 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.filesystems.interfaces.folder;

import uim.filesystems;
@safe:

interface IFolder : IFilesystemEntry, IFolderManager, IFileManager, ILinkManager {
  // Sets or returns the attributes of a specified folder.
  long attributes();
  void attributes(long newAttributes);

  // Returns the date and time when a specified folder was created.
  long createdOn();

  // Returns the date and time when a specified folder was last accessed.
  long accessedOn();

  // Returns the date and time when a specified folder was last modified.
  long modifiedOn();

  // Returns the drive letter of the drive where the specified folder resides.
  IDrive drive();

  bool hasEntries();
  bool isEmpty();

  // Returns True if a folder is the root folder and False if not.
  bool isRootFolder();

  // Returns the type of a specified folder. */
  string type(); 

  // Deletes file.
	bool remove();
}
