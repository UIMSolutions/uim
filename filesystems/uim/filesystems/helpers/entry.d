module uim.filesystems.helpers.entry;

import uim.filesystems;

unittest { 
  version(testUimFilesystems) { 
    debug writeln("\n", __MODULE__~":"~__PRETTY_FUNCTION__); 
  }
}

@safe:

string debugInfo(IFilesystemEntry anEntry) {
  if (anEntry is null) { return "entry is missing (null)."; }

  return `
-----------
Filesystem entry info:
\tName =\t%s
\tPath =\t%s
-----------`.format(anEntry.name, anEntry.path);
}