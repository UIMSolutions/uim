/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.filesystems.classes.folder;

import uim.filesystems;

unittest { 
  version(testUimFilesystems) { 
    debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); 
  }
}

@safe:
class DFolder : DFilesystemEntry, IFolder, IFolderManager, IFileManager, ILinkManager {
  mixin(FolderThis!("Folder"));

  override bool initialize(IData[string] configData = null) { // Hook
		if (!super.initialize(configData)) {
			return false;
		} 
		return true;
		 }

  protected string _pathSeparator;
  void pathSeparator(string newSeparator) {
    _pathSeparator = newSeparator;
  }
  string pathSeparator() {
    return (hasFilesystem ? filesystem.pathSeparator : null);
  }

	override bool exists() {
		return (hasFilesystem ? filesystem.existsFolder(path, name) : false);
	}

	override bool isFolder() {
		return exists;
	}

	// Sets or returns the attributes of a specified folder.
  long attributes() {
		// TODO
		return 0;		
	}
  void attributes(long newAttributes) {
		// TODO
	}

  // Returns the date and time when a specified folder was created.
  long createdOn() {
		// TODO
		return 0;		
	}

  // Returns the date and time when a specified folder was last accessed.
  long accessedOn() {
		// TODO
		return 0;		
	}
  // Returns the date and time when a specified folder was last modified.
  long modifiedOn() {
		// TODO
		return 0;		
	}
  // Returns the drive letter of the drive where the specified folder resides.
  IDrive drive() {
		// TODO
		return null;		
	}

  bool hasEntries() {
		// TODO
		return false;		
	}

  bool isEmpty() {
		// TODO
		return true;		
	}

  // Returns True if a folder is the root folder and False if not.
  bool isRootFolder() {
		// TODO
		return false;		
	}

  // Returns the type of a specified folder. */
  string type() {
		// TODO
		return null;		
	} 

	// #region Methods
		// Deletes file.
		bool remove() {
			return false;
		}
	// #endregion Methods

  mixin FolderManagerTemplate!();    
  mixin FileManagerTemplate!();
  mixin LinkManagerTemplate!();

  override string toString() {
    return this.className~": "~name;
  }
}
mixin(FolderCalls!("Folder"));

unittest {
	assert(Folder(), "Could not create file object");
}
