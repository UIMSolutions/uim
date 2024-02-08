/***********************************************************************************
*	Copyright: ©2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.filesystems.classes.os.linux.folder;

import uim.filesystems;

@safe:
class DLinuxFolder : DFolder {
  mixin(FolderThis!("LinuxFolder"));

	override bool exists() {
    version(testUimFilesystems) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }

		if (filesystem.isNull) { return false; }

		if (path.isEmpty && name.isEmpty) { return false; }

		auto myPath = !path.isEmpty
			? (!name.isEmpty ? absolutePath(path~name) : absolutePath(path)) 
			: absolutePath(name);

	  version(testUimFilesystems) { 
			debug writeln("\n", __MODULE__~":name = ", name); 
	  	debug writeln("\n", __MODULE__~":path = ", path); 
	  	debug writeln("\n", __MODULE__~":myPath = ", myPath);
		} 
		return (myPath.exists ? myPath.isDir : false);
	}

	override long createdOn() {
		return (exists ? 0 : 0); // TODO
	}

  // Returns the date and time when a specified folder was last accessed.
  override long accessedOn() {
    version(testUimFilesystems) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }
		return (exists ? 0 /* toTimestamp(timeLastAccessed(absolutePath)) */ : 0); 
	}

  // Returns the date and time when a specified folder was last modified.
  override long modifiedOn() {
    version(testUimFilesystems) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }
		return (exists ? toTimestamp(timeLastModified(absolutePath)) : 0); 
	}

	override ILink[] links(string[] aPath) {
    version(testUimFilesystems) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }
		return (exists ? filesystem.links(aPath) : null); 
	}

  // #region Folders
    // #region existsFolders() 
			alias existsFolders = DFolder.existsFolders;
      override bool existsFolders(string[] aPath, string aFolderName) {
	      version(testUimFilesystems) { 
					debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); 
	      	debug writeln("Path = \t", path, "\tName = \t", name); 
	      	debug writeln("aPath = \t", aPath, "\taFolderName = \t", aFolderName); }
				if (!hasFilesystem) { return false; }
				
				return filesystem.existsFolders(chain(path, [name], aPath).array, aFolderName);
      }
    // #endregion existsFolders() 
  
    // #region folders() 
			alias folders = DFolder.folders;
			override IFolder[] folders() {
        version(testUimFilesystems) { 
          debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); } 
				if (!hasFilesystem) { 
					return null; 
				}

       	return filesystem.folders(chain(path, [name]).array);
			}

      override IFolder[] folders(string[] aPath, string aFolderName) {
        version(testUimFilesystems) { 
          debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); 
          debug writeln("aPath = ", aPath, "\t aFolderName = ", aFolderName); } 

				if (!hasFilesystem) { 
					return null;
				}

       return filesystem.folders(chain(path, [name], aPath).array, aFolderName);
      }
    // #endregion folders() 

    // #region countFolders() 
			alias countFolders = DFolder.countFolders;
      override size_t countFolders(string[] aPath, string aFolderName) {
        version(testUimFilesystems) { 
          debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); 
          debug writeln("aPath = ", aPath, "\t aFolderName = ", aFolderName); } 
				if (!hasFilesystem) { 
					return 0;
				}

        return filesystem.countFolders(chain(path, [name], aPath).array, aFolderName);
      }
    // #endregion countFolders() 
  // #endregion Folders

	// #region Folder
		// #region Create
			alias createFolder = DFolder.createFolder;
			override IFolder createFolder(string[] aPath, string aFolderName) {
	      version(testUimFilesystems) { 
					debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); 
	      	debug writeln("Path = \t", path, "\tName = \t", name); 
	      	debug writeln("aPath = \t", aPath, "\taFolderName = \t", aFolderName); }

				// In Check	
				if (!hasFilesystem) { 
					return null; 
				}

				// Body
				auto result = filesystem.createFolder(chain(path, [name], aPath).array, aFolderName); 

				return result;
			}	
		// #endregion Create

		// #region Read
			// #region existsFolder()
				alias existsFolder = DFolder.existsFolder;
				override bool existsFolder(string[] aPath, string aFolderName) {
					version(testUimFilesystems) { 
						debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); 
						debug writeln("Path = \t", path, "\tName = \t", name); 
						debug writeln("aPath = \t", aPath, "\taFolderName = \t", aFolderName); }

					// In Check	
					if (!hasFilesystem) { 
						return false; 
					}
	
					return filesystem.existsFolder(chain(path, [name], aPath).array, aFolderName); 
				}
			// #endregion existsFolder()
			
			// #region folder()
				alias folder = DFolder.folder;
				override IFolder folder(string[] aPath, string aFolderName) {
					version(testUimFilesystems) { 
						debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); 
						debug writeln("Path = \t", path, "\tName = \t", name); 
						debug writeln("aPath = \t", aPath, "\taFolderName = \t", aFolderName); }
					if (!hasFilesystem) { return null; }

					return filesystem.folder(chain(path, [name], aPath).array, aFolderName);
				}			
			// #endregion folder()
		// #endregion Read

		// #region Update
			alias renameFolder = DFolder.renameFolder;
		  override bool renameFolder(string[] aPath, string oldName, string newName) {
      	version(testUimFilesystems) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }
				if (!hasFilesystem) { return false; }

				return filesystem.renameFolder(chain(path, [name], aPath).array, oldName, newName);
      }
		// #endregion Update

		// #region Delete
			alias removeFolder = DFolder.removeFolder;
			override bool removeFolder(string[] aPath, string aFolderName) {
				version(testUimFilesystems) { 
					debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); 
					debug writeln("Path = \t", path, "\tName = \t", name); 
					debug writeln("aPath = \t", aPath, "\taFolderName = \t", aFolderName); }
				if (!hasFilesystem) { return false; }

				return filesystem.removeFolder(chain(path, [name], aPath).array, aFolderName);
			}
		// #endregion Delete
	// #endregion Folder

	// #region File
		// #region Create
			alias createFile = DFolder.createFile;
			override IFile createFile(string[] aPath, string aFileName) {
				version(testUimFilesystems) { 
					debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); 
					debug writeln("Path = \t", path, "\tName = \t", name); 
					debug writeln("aPath = \t", aPath, "\taFileName = \t", aFileName); }
				if (!hasFilesystem) { return null; }

				return filesystem.createFile(chain(path, [name], aPath).array, aFileName);
			} 
		// #endregion Create

		// #region Read
			alias existsFile = DFolder.existsFile;
			override bool existsFile(string[] aPath, string aFileName) {
				version(testUimFilesystems) { 
					debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); 
					debug writeln("Path = \t", path, "\tName = \t", name); 
					debug writeln("aPath = \t", aPath, "\taFileName = \t", aFileName); }
				if (!hasFilesystem) { return false; }

				return filesystem.existsFile(chain(path, [name], aPath).array, aFileName);
			} 

			alias file = DFolder.file;
			override IFile file(string[] aPath, string aFileName) {
				version(testUimFilesystems) { 
					debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); 
					debug writeln("Path = \t", path, "\tName = \t", name); 
					debug writeln("aPath = \t", aPath, "\taFileName = \t", aFileName); }
				if (!hasFilesystem) { return null; }

				return filesystem.file(chain(path, [name], aPath).array, aFileName);
			} 
		// #endregion Read

		// #region Update
			alias renameFile = DFolder.renameFile;
			override bool renameFile(string[] aPath, string oldName, string newName) {
				version(testUimFilesystems) { 
					debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); 
					debug writeln("Path = \t", path, "\tName = \t", name); 
					debug writeln("aPath = \t", aPath, "\toldName = \t", oldName, " \tnewName = \t", newName); }
				if (!hasFilesystem) { return false; }

				return filesystem.renameFile(chain(path, [name], aPath).array, oldName, newName);
			}
		// #endregion Update

		// #region Delete
			alias removeFile = DFolder.removeFile;
			override bool removeFile(string[] aPath, string aFileName) {
        version(testUimFilesystems) { debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); }
				if (!hasFilesystem) { return false; }

				return filesystem.removeFile(chain(path, [name], aPath).array, aFileName);
			} 
		// #endregion Delete
	// #region File
}
mixin(FolderCalls!("LinuxFolder"));

version(testUimFilesystems) { 
unittest {
	version(testUimFilesystems) { debug writeln (StyledString("\nStart tests in "~__MODULE__).setBackground(AnsiColor.yellow).setForeground(AnsiColor.black)); }

	auto fs = LinuxFilesystem("TestFS");
	fs.rootPath("for_testing");
	if (!fs.existsFolder("LinuxFolder")) { fs.createFolder("LinuxFolder"); }
	if (!fs.existsFolder(["LinuxFolder"], "folders")) { fs.createFolder(["LinuxFolder"], "folders"); }
	if (!fs.existsFolder(["LinuxFolder"], "folder")) { fs.createFolder(["LinuxFolder"], "folder"); }

	IFolder myFolder = fs.folder(["LinuxFolder"], "folder");

	version(testUimFilesystems) { debug writeln (StyledString("Part 1 - Test folder").setBackground(AnsiColor.blue).setForeground(AnsiColor.black)); }
	// #region Test Folder
		if (!myFolder.existsFolder("createFolder"))  { myFolder.createFolder("createFolder"); }
		testFolder_CreateFolder(__MODULE__, myFolder, "createFolder", ["createFolder"]);

		if (!myFolder.existsFolder("readFolder"))  { myFolder.createFolder("readFolder"); }
		testFolder_ReadFolder(__MODULE__, myFolder, "readFolder", ["readFolder"]);

		if (!myFolder.existsFolder("updateFolder"))  { myFolder.createFolder("updateFolder"); }
		testFolder_UpdateFolder(__MODULE__, myFolder, "updateFolder", ["updateFolder"]);

		if (!myFolder.existsFolder("removeFolder"))  { myFolder.createFolder("removeFolder"); }
		testFolder_RemoveFolder(__MODULE__, myFolder, "removeFolder", ["removeFolder"]);
	// #endregion Test Folder

	if (!fs.existsFolder(["LinuxFolder"], "files")) { fs.createFolder(["LinuxFolder"], "files"); }
	myFolder = fs.folder(["LinuxFolder"], "files");

	version(testUimFilesystems) { debug writeln (StyledString("Part 2 - Test file").setBackground(AnsiColor.blue).setForeground(AnsiColor.black)); }
	// #region Test File
		if (!myFolder.existsFolder("creatingFiles")) { myFolder.createFolder("creatingFiles"); }
		testFolder_CreateFile(__MODULE__, myFolder, "creatingFiles", ["creatingFiles"]);

		if (!myFolder.existsFolder("readFiles")) { myFolder.createFolder("readFiles"); }
		testFolder_ReadFile(__MODULE__, myFolder, "readFiles", ["readFiles"]);

		if (!myFolder.existsFolder("updateFiles")) { myFolder.createFolder("updateFiles"); }
		testFolder_UpdateFile(__MODULE__, myFolder, "updateFiles", ["updateFiles"]);

		if (!myFolder.existsFolder("removeFiles")) { myFolder.createFolder("removeFiles"); }
		testFolder_removeFile(__MODULE__, myFolder, "removeFiles", ["removeFiles"]); 
	// #endregion Test File

	version(testUimFilesystems) { debug writeln (StyledString("End tests in "~__MODULE__).setBackground(AnsiColor.white).setForeground(AnsiColor.black)); }
} 
}
