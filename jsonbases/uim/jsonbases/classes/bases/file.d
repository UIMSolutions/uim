/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.jsonbases.classes.bases.file;

import uim.jsonbases;

unittest { 
  version(test_uim_jsonbase) { 
    debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
  }
}

@safe:
class DFileJsonBase : DJsonBase {
  mixin(JsonBaseThis!("File"));

/* this(string newRootPath) {
    this(); this.rootPath(newRootPath); 
  } */

  mixin(TProperty!("string", "rootPath"));

/* void load() {
    IFilesystem myFilesystem;
    version(Windows) {
      myFilesystem = WindowsFilesystem;
    }
    version(linux) {
      myFilesystem = LinuxFilesystem;
    }

    if (auto rootFolder = myFilesystem.folder(rootPath)) {
      auto folders = rootFolder.folders;
      folders.each!(f => writeln(f.name)); */
/*     auto dirs = dirNames(rootPath);  
      debug writeln(__MODULE__~" - found dirs ", dirs);

      foreach(myDir; dirs) {
        debug writeln(__MODULE__~" - Read "~myDir);
        _tenants[myDir] = FileJsonTenant(rootPath~"/"~myDir);
      }      
 */    
/*   }
  } */

  // Create
  override IJsonTenant createTenant(string aName) {
    return (addTenant(aName, FileJsonTenant(aName)) ? tenant(aName) : null);
  }
}
mixin(JsonBaseCalls!("File"));
// auto FileJsonBase(string newRootPath) { return new DFileJsonBase(newRootPath); }

unittest {
  version(test_uim_jsonbase) { 
    debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
  }
}