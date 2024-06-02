/***********************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (UIManufaktur)										           * 
***********************************************************************************/
module uim.filesystems.classes.virtual.folder;

import uim.filesystems;

unittest { 
  version(testUimFilesystems) { 
    debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
  }
}

@safe:

class DVirtualFolder : DFolder {
	mixin(FolderThis!("Virtual"));

	// #region files
	protected IFile[string] _files;

	alias files = DFolder.files;
	override IFile[] files(string arelPath = null) {
		return _files.values.dup;
	}

	bool addFiles(IFile[] someFiles...) {
		return addFiles(someFiles.dup);
	}

	bool addFiles(IFile[] someFiles) {
		if (someFiles.isEmpty) { return false; }

		foreach(myFile; someFiles) {
			if (!addFile(myFile)) { return false; }
		}
		return true;
	}

	override bool addFile(IFile aFile) {
		if (aFile) {
			aFile.parentFolder(this);
			_files[aFile.name] = aFile; 
			return true;
		} 
		return false;
	}
	// #endregion files

	protected IFolder _parentFolder;
	override IFolder parentFolder() {
		return _parentFolder;
	}

	// # region Folders
	alias folders = DFolder.folders;
	protected IFolder[string] _folders;

/* 	/* override */ IFolder[] folders(bool includingHiddenFolders = false) {
		if (includingHiddenFolders) {
			return _folders.values.dup;
		}
		// Without hidden folders
		return _folders.values.filter!(f => !f.isHidden("")).array;
	}

	override bool addFolder(IFolder aFolder) {
		return (aFolder ? (){ _folders[aFolder.name] = aFolder; return true; }() : false);
	}

	bool removeFolder() {
		return false;
	} */
	// #endregion Folders
}
mixin(FolderCalls!("Virtual"));