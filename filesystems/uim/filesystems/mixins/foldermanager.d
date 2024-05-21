/***********************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.filesystems.mixins.foldermanager;

import uim.filesystems;

@safe:
mixin template TFolderManager() {
  // #region Folders
    // #region existsFolders() 
      bool existsFolders(string aPath) {
        version(testUimFilesystems) { 
          debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
          debug writeln("aPath = ", aPath); } 

        // IN Check
        if (aPath.isEmpty) { return false; } 

        return existsFolders(toPathItems(aPath, pathSeparator)); 
      }
      
      bool existsFolders(string aPath, string aFolderName) {
        version(testUimFilesystems) { 
          debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
          debug writeln("aPath = ", aPath, "\t aFolderName = ", aFolderName); } 
        
        // IN Check
        if (aPath.isEmpty || aFolderName.isEmpty) { return false; } 

        return existsFolders(toPathItems(aPath, pathSeparator), aFolderName); 
      }

      bool existsFolders(string[] aPath) {
        version(testUimFilesystems) { 
          debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
          debug writeln("aPath = ", aPath); } 
          
        // IN Check
        if (aPath.isEmpty) { return false; } 

        string[] aNullArray;
        return (aPath.length > 1 
          ? existsFolders(aPath[0..$-1], aPath[$-1])
          : existsFolders(aNullArray, aPath[$-1]));
      }

      bool existsFolders(string[] aPath, string aFolderName) {
        return false;
      }
    // #endregion existsFolders() 
  
    // #region folders() 
      IFolder[] folders() {
        return null;
      }
      
      IFolder[] folders(string aPath) {
        version(testUimFilesystems) { 
          debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
          debug writeln("aPath = ", aPath); } 

        if (aPath.isEmpty) return null; 

        return folders(toPathItems(aPath, pathSeparator)); 
      }
      
      IFolder[] folders(string aPath, string aFolderName) {
        version(testUimFilesystems) { 
          debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
          debug writeln("aPath = ", aPath, "\t aFolderName = ", aFolderName); } 

        if (aPath.isEmpty || aFolderName.isEmpty) return null; 

        return folders(toPathItems(aPath, pathSeparator), aFolderName); 
      }

      IFolder[] folders(string[] aPath) {
        version(testUimFilesystems) { 
          debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
          debug writeln("aPath = ", aPath); } 

        if (aPath.isEmpty) return null; 

        string[] aNullArray;
        return (aPath.length > 1 
          ? folders(aPath[0..$-1], aPath[$-1])
          : folders(aNullArray, aPath[$-1]));
      }

      IFolder[] folders(string[] aPath, string aFolderName) {
        version(testUimFilesystems) { 
          debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
          debug writeln("aPath = ", aPath, "\t aFolderName = ", aFolderName); } 

        return null;
      }
    // #endregion folders() 

    // #region countFolders() 
      size_t countFolders(string aPath) {
        version(testUimFilesystems) { 
          debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
          debug writeln("aPath = ", aPath); } 

        if (aPath.isEmpty) return 0; 

        return countFolders(toPathItems(aPath, pathSeparator));    
      }

      size_t countFolders(string aPath, string aFolderName) {
        version(testUimFilesystems) { 
          debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
          debug writeln("aPath = ", aPath, "\t aFolderName = ", aFolderName); } 

        if (aPath.isEmpty || aFolderName.isEmpty) return 0; 

        return countFolders(toPathItems(aPath, pathSeparator), aFolderName);    
      }

      size_t countFolders(string[] aPath) {
        version(testUimFilesystems) { 
          debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
          debug writeln("aPath = ", aPath); } 

        if (aPath.isEmpty) return 0; 
        
        string[] aNullArray;
        return (aPath.length > 1 
          ? countFolders(aPath[0..$-1], aPath[$-1])
          : countFolders(aNullArray, aPath[$-1]));
      }

      size_t countFolders(string[] aPath, string aFolderName) {
        version(testUimFilesystems) { 
          debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
          debug writeln("aPath = ", aPath, "\t aFolderName = ", aFolderName); } 

        return 0;
      }
    // #endregion countFolders() 
  // #endregion Folders

  // #region Folder
    // #region Create
      // #region createFolder()
        IFolder createFolder(string aPath) {
        version(testUimFilesystems) { 
          debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
          debug writeln("aPath = ", aPath); } 

          // IN Check
          if (aPath.isEmpty) return null; 

          return createFolder(toPathItems(aPath, pathSeparator));
        }

        IFolder createFolder(string aPath, string aFolderName) {
        version(testUimFilesystems) { 
          debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
          debug writeln("aPath = ", aPath, "\t aFolderName = ", aFolderName); } 
          
          // IN Check
          if (aPath.isEmpty || aFolderName.isEmpty) return null; 

          return createFolder(toPathItems(aPath, pathSeparator), aFolderName);
        }

        IFolder createFolder(string[] aPath) {
          version(testUimFilesystems) { 
            debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
            debug writeln("aPath = ", aPath); }           
          
          // IN Check
          if (aPath.isEmpty) return null; 

          string[] aNullArray;
          return (aPath.length > 1 
            ? createFolder(aPath[0..$-1], aPath[$-1])
            : createFolder(aNullArray, aPath[$-1]));
        }

        IFolder createFolder(string[] aPath, string aFolderName) {
          version(testUimFilesystems) { 
            debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
            debug writeln("aPath = ", aPath, "\t aFolderName = ", aFolderName); } 
          
          return null;
        }
      // #endregion createFolder()

      // #region createIfNotExistsFolder()
        IFolder createIfNotExistsFolder(string aPath) {
        version(testUimFilesystems) { 
          debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
          debug writeln("aPath = ", aPath); } 

          // IN Check
          if (aPath.isEmpty) return null; 

          return createIfNotExistsFolder(toPathItems(aPath, pathSeparator));
        }

        IFolder createIfNotExistsFolder(string aPath, string aFolderName) {
        version(testUimFilesystems) { 
          debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
          debug writeln("aPath = ", aPath, "\t aFolderName = ", aFolderName); } 
          
          // IN Check
          if (aPath.isEmpty || aFolderName.isEmpty) return null; 

          return createIfNotExistsFolder(toPathItems(aPath, pathSeparator), aFolderName);
        }

        IFolder createIfNotExistsFolder(string[] aPath) {
          version(testUimFilesystems) { 
            debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
            debug writeln("aPath = ", aPath); }           
          
          // IN Check
          if (aPath.isEmpty) return null; 

          string[] aNullArray;
          return (aPath.length > 1 
            ? createIfNotExistsFolder(aPath[0..$-1], aPath[$-1])
            : createIfNotExistsFolder(aNullArray, aPath[$-1]));
        }

        IFolder createIfNotExistsFolder(string[] aPath, string aFolderName) {
          version(testUimFilesystems) { 
            debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
            debug writeln("aPath = ", aPath, "\t aFolderName = ", aFolderName); } 
          
          return !existsFolder(aPath, aFolderName) 
            ? createFolder(aPath, aFolderName)
            : folder(aPath, aFolderName);
        }
      // #endregion createIfNotExistsFolder()

      // #region copyFolder()
        bool copyFolder(string fromPath, string toPath) {
          version(testUimFilesystems) { 
            debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
            debug writeln("FromPath = ", fromPath, "\t toPath = ", toPath); }

          // IN Check
          if (fromPath.isEmpty || toPath.isEmpty) { return false; }

          return copyFolder(toPathItems(fromPath, pathSeparator), toPathItems(toPath, pathSeparator));
        }

        bool copyFolder(string[] fromPath, string toPath) {
          version(testUimFilesystems) { 
            debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
            debug writeln("FromPath = ", fromPath, "\t toPath = ", toPath); 
          }

          // IN Check
          if (fromPath.isEmpty || toPath.isEmpty) { return false; }

          return copyFolder(fromPath, toPathItems(toPath, pathSeparator));
        } 

        bool copyFolder(string fromPath, string[] toPath) {
          version(testUimFilesystems) { 
            debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
            debug writeln("FromPath = ", fromPath, "\t toPath = ", toPath); }

          // IN Check
          if (fromPath.isEmpty || toPath.isEmpty) { return false; }

          return copyFolder(toPathItems(fromPath, pathSeparator), toPath);
        }

        bool copyFolder(string[] fromPath, string[] toPath) {
          version(testUimFilesystems) { 
            debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
            debug writeln("FromPath = ", fromPath, "\t toPath = ", toPath); }

          // IN Check
          if (fromPath.isEmpty || toPath.isEmpty) { 
            return false; 
          }

          return false;
        }

        bool copyFolder(IFolder aFolder, string[] toPath) {
          return false;
        }

        bool copyFolder(IFolder aFolder, IFolder toFolder) {
          return false;
        }        
      // #endregion copyFolder()
    // #endregion Create

    // #region Read 
      // #region existsFolder() 
        bool existsFolder(string aPath) {
          version(testUimFilesystems) { 
            debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
            debug writeln("aPath = ", aPath); } 
          
          // IN Check
          if (aPath.isEmpty) { return false; }

          return existsFolder(toPathItems(aPath, pathSeparator));
        }
        
        bool existsFolder(string aPath, string aFolderName) {
          version(testUimFilesystems) { 
            debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
            debug writeln("aPath = ", aPath, "\t aFolderName = ", aFolderName); } 

          // IN Check
          if (aPath.isEmpty || aFolderName.isEmpty) { return false; }

          return existsFolder(toPathItems(aPath, pathSeparator), aFolderName);
        }

        bool existsFolder(string[] aPath) {
          version(testUimFilesystems) { 
            debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
            debug writeln("aPath = ", aPath); } 
            
          // IN Check
          if (aPath.isEmpty) { return false; } 

          string[] aNullArray;
          return (aPath.length > 1 
            ? existsFolder(aPath[0..$-1], aPath[$-1])
            : existsFolder(aNullArray, aPath[$-1]));
        }

        bool existsFolder(string[] aPath, string aFolderName) {
          version(testUimFilesystems) { 
            debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
            debug writeln("aPath = ", aPath, "\t aFolderName = ", aFolderName); } 

          return false;
        }
      // #endregion existsFolder() 

      // #region folder()
        IFolder folder(string aPath) {
          version(testUimFilesystems) { 
            debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
            debug writeln("aPath = ", aPath); } 

          // IN Check
          if (aPath.isNull) { return null; } 

          return folder(toPathItems(aPath, pathSeparator));
        }

        IFolder folder(string aPath, string aFolderName) {
          version(testUimFilesystems) { 
            debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
            debug writeln("aPath = ", aPath, "\t aFolderName = ", aFolderName); } 

          // IN Check
          if (aPath.isEmpty || aFolderName.isEmpty) { return null; }

          return folder(toPathItems(aPath, pathSeparator), aFolderName);
        }
        
        IFolder folder(string[] aPath) {
          version(testUimFilesystems) { 
            debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
            debug writeln("aPath = ", aPath); } 

          // IN Check
          if (aPath.isEmpty) return null; 

          string[] aNullArray;
          return (aPath.length > 1 
            ? folder(aPath[0..$-1], aPath[$-1])
            : folder(aNullArray, aPath[$-1]));
        }

        IFolder folder(string[] aPath, string aFolderName) {
          version(testUimFilesystems) { 
            debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
            debug writeln("aPath = ", aPath, "\t aFolderName = ", aFolderName); } 

          return null; 
        };
      // #endregion folder()
    // #endregion Read 

    // #region Update
      // #region renameFolder
        bool renameFolder(string oldPathAndName, string newName) {
          // IN Check
          if (oldPathAndName is null || newName.isNull) { return false; } 

          return renameFolder(toPathItems(oldPathAndName, pathSeparator), newName);
        }

        bool renameFolder(string aPath, string oldName, string newName) {
          // IN Check
          if (aPath.isEmpty || oldName.isEmpty || newName.isEmpty) { return false; } 
          
          return renameFolder(toPathItems(aPath, pathSeparator), oldName, newName);
        }
        
        bool renameFolder(string[] oldPathAndName, string newName) {
          // IN Check
          if (oldPathAndName.isEmpty) { return false; } 

          // BODY
          string[] aNullArray;
          string oldName = oldPathAndName[$-1];
          return (oldPathAndName.length > 1 
            ? renameFolder(oldPathAndName[0..$-1], oldName, newName)
            : renameFolder(aNullArray, oldName, newName));
        }
        
        bool renameFolder(string[] aPath, string oldName, string newName) {
          return false;
        }
      // #endregion renameFolder

    // #region MoveFolder
      bool moveFolder(string fromPath, string toPath) {
        version(testUimFilesystems) { 
          debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
          debug writeln("FromPath = ", fromPath, "\t toPath = ", toPath); 
        }

        // IN Check
        if (fromPath.isEmpty || toPath.isEmpty) { return false; }

        return moveFolder(toPathItems(fromPath, pathSeparator), toPathItems(toPath, pathSeparator));
      }

      bool moveFolder(string[] fromPath, string toPath) {
        version(testUimFilesystems) { 
          debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
          debug writeln("FromPath = ", fromPath, "\t toPath = ", toPath); 
        }

        // IN Check
        if (fromPath.isEmpty || toPath.isEmpty) { return false; }

        return moveFolder(fromPath, toPathItems(toPath, pathSeparator));
      } 

      bool moveFolder(string fromPath, string[] toPath) {
        version(testUimFilesystems) { 
          debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
          debug writeln("FromPath = ", fromPath, "\t toPath = ", toPath); 
        }
        
        // IN Check
        if (fromPath.isEmpty || toPath.isEmpty) { return false; }

        return moveFolder(toPathItems(fromPath, pathSeparator), toPath);
      }

      bool moveFolder(string[] fromPath, string[] toPath) {
        version(testUimFilesystems) { 
          debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
          debug writeln("FromPath = ", fromPath, "\t toPath = ", toPath); 
        }
        
        // IN Check
        if (fromPath.isEmpty || toPath.isEmpty) { return false; }

        return false;
      }

      bool moveFolder(IFolder aFolder, string[] toPath) {
        return false;
      }

      bool moveFolder(IFolder aFolder, IFolder toFolder) {
        return false;
      }  
    // #endregion MoveFolder

    // #endregion Update

    // #region Delete
      // #region removeFolder()
        bool removeFolder(string aPath) {
          version(testUimFilesystems) { 
            debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
            debug writeln("aPath = ", aPath); } 

          return removeFolder(toPathItems(aPath, pathSeparator));
        }
        
        bool removeFolder(string aPath, string aFolderName) {
          version(testUimFilesystems) { 
            debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
            debug writeln("aPath = ", aPath, "\t aFolderName = ", aFolderName); } 

          return removeFolder(aPath, aFolderName);
        }

        bool removeFolder(string[] aPath) {
          version(testUimFilesystems) { 
            debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
            debug writeln("aPath = ", aPath); } 

          // IN Check
          if (aPath.isEmpty) { return false; } 

          string[] aNullArray;
          return (aPath.length > 1 
            ? removeFolder(aPath[0..$-1], aPath[$-1])
            : removeFolder(aNullArray, aPath[$-1]));
        }

        bool removeFolder(string[] aPath, string aFolderName) {
          version(testUimFilesystems) { 
            debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
            debug writeln("aPath = ", aPath, "\t aFolderName = ", aFolderName); } 

          return false;
        }
      // #endregion removeFolder()
    // #endregion Delete
    bool addFolder(IFolder aFolder) {
      return false;
    }

    
  // #endregion Folder

/*  IFolder folder(string[] aPath);

  // Returns a Folders collection consisting of all Folder objects contained in the specified folder, including those with hidden and system folder attributes set.
  IFolder[] folders(string relativPath = null);

  // Checks if a specified folder exists.

  // Creates folder 
  bool createFolder(string aNameOrrelPath);
  bool createFolder(string[] aNameOrrelPath);

  // Add folder from one location to another.
  final bool addFolders(IFolder[] someFolders...) {
		return addFolders(someFolders.dup);
	}

  final bool addFolders(IFolder[] someFolders) {
    if (someFolders.isEmpty) { return false; }

    foreach(myFolder; someFolders) {
      if (!addFolder(myFolder)) { return false; }
    }

    return true;
  }

  bool addFolder(IFolder aFolder);

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

  // Deletes folder.
  bool removeFolder(string aPath);
  bool removeFolder(string[] aPath); */
}

string existsFolderMixin() {
  return "
  "; 
}

string folderMixin() {
  return "";
    
}

string existsFoldersMixin() {
  return "

  ";
}

string countFoldersMixin() {
  return "

  ";
}

string copyFoldersMixin() {
  return "
  ";
}

string moveFoldersMixin() {
  return "
  ";
}

string removeFoldersMixin() {
  return "
  ";
}

string createFolderMixin() {
  return "";
}

string copyFolderMixin() {
  return "
  ";
}

string moveFolderMixin() {
  return "
  ";
}

string removeFolderMixin() {
  return "
  ";
}

template FolderManagerMixin()  {
  const char[] FolderManagerMixin = 
    // Folders
    existsFoldersMixin~
    countFoldersMixin~
    removeFoldersMixin~
    // Folder
    existsFolderMixin~
    folderMixin~
    createFolderMixin~
    removeFolderMixin;
}