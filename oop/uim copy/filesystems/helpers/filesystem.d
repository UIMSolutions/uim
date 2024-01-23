module uim.filesystems.helpers.filesystem;

import uim.filesystems;

unittest { 
  version(testUimFilesystems) { 
    debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); 
  }
}

@safe:
string workingDirectory() {
	return () @trusted { return std.file.getcwd(); }();
}

bool isNull(IFilesystem aFilesystem) {
	return (aFilesystem is null);
}