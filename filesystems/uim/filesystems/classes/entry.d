/***********************************************************************************
*	Copyright: © 2015-2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (UIManufaktur)										           * 
***********************************************************************************/
module uim.filesystems.classes.entry;

import uim.filesystems;

unittest {
	version (testUimFilesystems) {
		debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
	}
}

@safe:
class DFilesystemEntry : IFilesystemEntry {
    mixin TConfigurable; 

	this() {
		initialize;
	}

	this(IFilesystem aFilesystem) {
		this();
		this.filesystem(aFilesystem);
	};
	this(string[] aPath) {
		this();
		this.path(aPath);
	};
	this(string aName) {
		this();
		this.name(aName);
	};

	this(IFilesystem aFilesystem, string[] aPath) {
		this(aFilesystem);
		this.path(aPath);
	};
	this(IFilesystem aFilesystem, string aName) {
		this(aFilesystem);
		this.name(aName);
	};

	this(IFilesystem aFilesystem, string[] aPath, string aName) {
		this(aFilesystem, aPath);
		this.name(aName);
	};

	bool initialize(Json[string] initData = null) { // Hook
		configuration(MemoryConfiguration);
		configuration.data(initData);
		return true;
	}

	// Owning Filesystem
	bool hasFilesystem() {
		return (filesystem !is null);
	}

	mixin(TProperty!("IFilesystem", "filesystem"));

	// Get name of entry
	mixin(TProperty!("string", "name"));
	mixin(TProperty!("string[]", "path"));

	size_t size() {
		return 0;
	}

	void parentFolder(IFolder aFolder) {
	}

	IFolder parentFolder() {
		return null;
	}

	bool exists() { // TODO
		return (hasFilesystem ? filesystem.existsFolder(name) : false);
	}

	// #region path
	// Path starting from filesystem TODO: required?
	string relPath(string aPath) {
		version (testUimFilesystems) {
			debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
			debug writeln("aPath = %s".format(aPath));
		}

		return (filesystem ? filesystem.relPath(aPath) : null);
	}

	string relPath(string[] pathItems = null) {
		version (testUimFilesystems) {
			debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
			debug writeln("pathItems = %s".format(pathItems));
		}

		return (filesystem ? filesystem.relPath(pathItems) : null);
	}

	// Path starting from rootpath
	string absolutePath(string aPath) {
		version (testUimFilesystems) {
			debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
			debug writeln("aPath = %s".format(aPath));
		}

		return (filesystem ? filesystem.absolutePath(aPath) : null);
	}

	string absolutePath(string[] pathItems = null) {
		version (testUimFilesystems) {
			debug writeln("\n", __MODULE__ ~ ": " ~ __PRETTY_FUNCTION__);
			debug writeln("pathItems = %s".format(pathItems));
		}

		return (filesystem ? filesystem.absolutePath(pathItems) : null);
	}
	// #endregion path

	// Rename entry
	bool rename(string newName) {
		return false;
	}

	// Check if entry is hidden
	bool isHidden() {
		return false;
	}

	// #region isFolder
	bool isFolder() {
		return false;
	}
	// #endregion isFolder

	// #region isFile
	bool isFile() {
		return false;
	}
	// #endregion isFile

	// #region isLink
	bool isLink() {
		return false;
	}
	// #endregion isLink

	override string toString() {
		return this.classname ~ ": " ~ name;
	}

	string debugInfo() {
		return `-----
classname:    %s
Name: 		    %s
relPath: %s
absolutePath: %s
-----`.format(this.classname, name, "relPath", "absolutePath");
	}
}

auto FilesystemEntry() {
	return new DFilesystemEntry();
}

unittest {
	// TODO add tests
}
