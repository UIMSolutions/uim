/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.core.io.file;

import std.file;
import uim.core;

@safe:
version (test_uim_core) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

version (linux) {
  bool copy(string fileName, string fromDir, string toDir, bool createMissingDirs = true, bool overwriteExistingFile = true) {
    if (fileName.length == 0) {
      return false;
    }
    if (fromDir.isEmpty || toDir.isEmpty) {
      return false;
    }

    string from = fromDir;
    if (!from.endsWith('/'))
      from ~= "/";

    if (!exists(from ~ fileName)) {
      return false;
    }

    string to = toDir;
    if (!to.endsWith("/"))
      to ~= "/";

    if (createMissingDirs) {
      if (!exists(from))
        mkdir(from);
      if (!exists(to))
        mkdir(to);
    } else {
      if (!exists(from) || !exists(to)) {
        return false;
      }
    }

    if (!overwriteExistingFile && exists(to ~ fileName)) {
      return false;
    }

    try {
      std.file.copy(from ~ fileName, to ~ fileName);
    } catch (Exception e) {
      return false;
    }

    return true;
  }
}

version (linux) {
  bool move(string fileName, string fromDir, string toDir, bool createMissingDirs = true, bool overwriteExistingFile = true) {
    if (fileName.isEmpty) {
      return false;
    }
    if (fromDir.isEmpty || toDir.isEmpty) {
      return false;
    }

    string from = fromDir;
    if (!from.endsWith("/"))
      from ~= "/";

    if (!exists(from ~ fileName)) {
      return false;
    }

    string to = toDir;
    if (!to.endsWith("/"))
      to ~= "/";

    if (createMissingDirs) {
      if (!exists(from))
        mkdir(from);
      if (!exists(to))
        mkdir(to);
    } else {
      if (!exists(from)) {
        return false;
      }
      if (!exists(to)) {
        return false;
      }
    }

    if (!overwriteExistingFile && exists(to ~ fileName)) {
      return false;
    }

    try {
      fileName.copy(from, to);
    } catch (Exception e) {
      return false;
    }

    try {
      std.file.remove(from ~ fileName);
    } catch (Exception e) {
      return false;
    }

    return true;
  }
}

unittest {
  // Todo
}

auto dirEntryInfos(string aPath) {
  debug writeln(__MODULE__ ~ " - dirEntryInfos(path: %s)".format(aPath));

  FileInfo[] results;
  /* bool dirEntryInfo(FileInfo info) { 
    debug writeln(__MODULE__~" - Info %s".format(info));
    results ~= info; return true; 
  }

  debug writeln(__MODULE__~" - listDirectory(aPath, &dirEntryInfo))");
  listDirectory(aPath, &dirEntryInfo);

  debug writeln(__MODULE__~" - Results %s)".format(results)); */
  return results;
}

// read directories (subfolders) in path 
auto dirNames(string aPath, bool aFullName = false) {
  debug writeln(__MODULE__ ~ " - dirNames(string %s, bool fullName = false)".format(aPath));

  string[] results;
  /* string[] results = dirEntryInfos(aPath).filter!(a => a.isDirectory).map!(a => a.name).array;
  if (aFullName) results = results.map!(a => aPath~"/"~a).array;
 */

  foreach (string name; dirEntries(aPath, SpanMode.breadth)) {
    writeln(name);
  }

  debug writeln(__MODULE__ ~ " - Results %s)".format(results));
  return results;
}

// read links in path 
auto linkNames(string path, bool aFullName = false) {
  string[] results = dirEntryInfos(path).filter!(a => a.isSymlink)
    .map!(a => a.name)
    .array;
  if (aFullName)
    results = results.map!(a => path ~ "/" ~ a).array;
  return results;
}

// read filenames in path 
auto fileNames(string aPath, bool aFullName = false) {
  string[] results = dirEntryInfos(aPath).filter!(a => a.isFile)
    .map!(a => a.name)
    .array;
  if (aFullName)
    results = results.map!(a => aPath ~ "/" ~ a).array;
  return results;
}

unittest {
  /*   debug writeln("1");  
  debug writeln(dirNames("."));
  debug writeln("2");  
  debug writeln(dirNames(".", true));
  debug writeln("3");   */
}
