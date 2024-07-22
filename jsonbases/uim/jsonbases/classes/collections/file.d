module uim.jsonbases.classes.collections.file;

import uim.jsonbases;

unittest { 
  version(testUimJsonbase) { 
    debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
  }
}

@safe:

class DFileJsonCollection : DJsonCollection {
  mixin(JsonCollectionThis!("FileJsonCollection"));
  this(IFolder aFolder) { this(); folder(aFolder); }
  
  mixin(TProperty!("IFolder", "folder"));

  // #region READ
    // #region findMany()
      alias findMany = DJsonCollection.findMany;

      // Find all (many) items in a collection. allVersions:false = find last versions, allVersion:true = find all versions
      override Json[] findMany(bool allVersions = false) {
        version(testUimJsonbase) { debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); }
        
        // Preconditions
        if (!folder || !folder.exists) { return null; }    

        // Body
        auto ids = folder.folders.map!(f => folder.name).filter!(id => id.isUUID).array; // get all valid ids

        // Final
        return ids.map!(id => findMany(UUID(id), allVersions)).join();
      }

      /// Find all (many) items in a collection with id. allVersions:false = find last version, allVersion:true = find all versions
      override Json[] findMany(UUID anId, bool allVersions = false) {
        version(testUimJsonbase) { debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); }

        if (!folder || !folder.exists) { return null; }  

        auto idFolder = folder.folder(anId.toString);
        if (idFolder is null) { return null; }  

        auto versionJsons = loadJsonsFromDirectory(idFolder.absolutePath);
        if (versionJsons.isEmpty)  { return null; }

        return allVersions ? versionJsons : [lastVersion(versionJsons)]; 
      }

      override Json[] findMany(STRINGAA select, bool allVersions = false) {
        version(testUimJsonbase) { debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); }

        return super.findMany(select, allVersions); 
      }

      /// find items by select - allVersions:false - last versions; allVersions:true - all versions
      override Json[] findMany(Json select, bool allVersions = false) {
        version(testUimJsonbase) { debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); }

        return super.findMany(select, allVersions); 
      }
    // #endregion findMany()

    // #region findOne()
      alias findOne = DJsonCollection.findOne;

      /// Find one item in a collection. allVersions:false = last version, allVersion:true = one version
      override Json findOne(UUID id, bool allVersions = false) {
        version(testUimJsonbase) { debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); }

        if (!folder || !folder.exists) { return Json(null); }  

        auto myIdFolder = idFolder(folder, id);
        if (myIdFolder is null) { return Json(null); }  

        auto versionJsons = loadJsonsFromDirectory(myIdFolder.absolutePath);
        if (versionJsons.isEmpty)  { return Json(null); }

        return allVersions ? versionJsons[0] : lastVersion(versionJsons); 
      }

      override Json findOne(UUID anId, size_t versionNumber) {
        version(testUimJsonbase) { debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); }

        if (!folder || !folder.exists) { return Json(null); } 

        auto myIdFolder = idFolder(folder, anId);
        if (myIdFolder is null) { return Json(null); }  

        auto versionFile = myIdFolder.file(to!string(versionNumber));
        if (versionFile is null) { return Json(null); }  

        return loadJson(versionFile.absolutePath); 
      }

      override Json findOne(STRINGAA select, bool allVersions = false) {
        version(testUimJsonbase) { debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); }

        if (!folder || !folder.exists) { return Json(null); }

        if (allVersions) {
          auto jsons = findMany(select, allVersions);
          return jsons ? jsons[0] : Json(null); 
        } 

        if ("id" !in select) { return Json(null); } 
        auto myId = UUID(select["id"]);

        auto myIdFolder = idFolder(folder, myId);
        if (myIdFolder is null) { return Json(null); }  

        auto result = Json(null); 
        if (!folder || !folder.exists) { return Json(null); } 

        return ("versionNumber" !in select 
          ? findOne(UUID(select["id"]), allVersions)
          : findOne(UUID(select["id"]), to!size_t(select["versionNumber"]))); 
      }

      override Json findOne(Json select, bool allVersions = false) {
        version(testUimJsonbase) { debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); }

        if (!folder || !folder.exists) { return Json(null); }

        if (allVersions) {
          auto jsons = findMany(select, allVersions);
          return jsons ? jsons[0] : Json(null); 
        }
        if ("id" !in select) { return Json(null); }

        auto idFolder = folder.folder(select["id"].get!string);
        if (idFolder is null) { return Json(null); }  

        if ("versionNumber" !in select) { return Json(null); }

        auto versionFile = folder.file(select["versionNumber"].get!string);
        if (versionFile is null) { return Json(null); }  

        return versionFile.readJson;
      }
    // #endregion findOne()
  // #endregion READ

  /// insert one item 
  alias insertOne = DJsonCollection.insertOne;

  override Json insertOne(Json newData) {
    version(testUimJsonbase) { debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); }

    // Preconditions
    if (!folder || !folder.exists) { return Json(null); }
    if (newData.isEmpty) return Json(null);

    // Body
    if ("id" !in newData) newData["id"] = randomUUID.toString;
    if ("versionNumber" !in newData) newData["versionNumber"] = 1;

    auto idFolder = folder.createFolder(newData["id"].get!string);
    if (idFolder is null) { return Json(null); }  
    
    auto versionFile = idFolder.createFile(newData["versionNumber"].get!string);
    if (versionFile is null) { return Json(null); }  

    versionFile.writeJson(newData);
    return findOne(newData); 
  }  

  // #region updateMany()
    override size_t updateMany(STRINGAA select, STRINGAA updateData) {
      version(testUimJsonbase) { debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); }
      
      // Preconditions
      if (!folder || !folder.exists) { return 0; }  

      // Body

      Json[] jsons = findMany(select)
        .filter!(j => updateOne(j, updateData))
        .array;

      // Final  
      return jsons.length; 
    }

    override size_t updateMany(Json select, Json updateData) {
      version(testUimJsonbase) { debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); }
      
      // Preconditions
      if (!folder || !folder.exists) { return 0; }  

      // Body
      auto jsons = findMany(select);
      jsons.each!(j => updateOne(j, updateData));

      // Final
      return jsons.length; 
    }
  // #endregion updateMany()

  // #region updateOne()
    alias updateOne = DJsonCollection.updateOne;
    override bool updateOne(Json select, Json updateData) {
      version(testUimJsonbase) { debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); }
      
      // Preconditions
      if (!folder || !folder.exists) { 
      return false; 
    }  

      // Body
      auto json = findOne(select);
      if (json.isEmpty) { 
      return false; 
    }

      updateData.byKeyValue.each!(kv => json[kv.key] = kv.value);

      auto myFolder = folder.folder(json["id"].get!string);
      if (myFolder is null) { 
      return false; 
    }

      auto myFile = myFolder.file(json["versionNumber"].get!string);
      if (myFile is null) { 
      return false; 
    }

      myFile.writeJson(json);

      // Final
      return true; 
    }
  // #endregion updateOne()

  // #region removeMany()
    /// Remove items from collections
    alias removeMany = DJsonCollection.removeMany;
    /// Remove items from collectionsby it. allVersions:false - remove lastVersion, allVersion:true / allVersions (complete)
    override size_t removeMany(UUID id, bool allVersions = false) {
      // Preconditions
      if (!folder || !folder.exists) { return 0; }  

      size_t counter;
      foreach(item; findMany(id, allVersions)) {
        counter++; 
        removeOne(item, allVersions); }

      return counter; 
    }

    override size_t removeMany(STRINGAA select, bool allVersions = false) {
      // Preconditions
      if (!folder || !folder.exists) { return 0; }  
      if (select.isEmpty) { return 0; }

      // Body
      size_t counter;
      findMany(select, allVersions).each!(j => counter += removeOne(j, allVersions));
      
      // Final
      return counter; 
    }

    override size_t removeMany(Json select, bool allVersions = false) {
      // Preconditions
      if (!folder || !folder.exists) { return 0; }  
      if (select.isEmpty) { return 0; }

      // Body
      size_t counter;
      findMany(select, allVersions).each!(json => counter += removeOne(json, allVersions));

      return counter;
    }
  // #endregion removeMany()

  // #region removeOne()
    /// Remove one item or one version from collection
    alias removeOne = DJsonCollection.removeOne;
    /// Remove one item from collection
    override bool removeOne(UUID anId, bool allVersions = false) {
      // Preconditions
      if (!folder || !folder.exists) { 
      return false; 
    }  

      // Body
      auto myFolder = folder.folder(anId.toString);
      if (myFolder is null) { 
      return false; 
    }
      
      if (allVersions) { return myFolder.remove; }

      auto myVersion = lastVersion(findMany(anId));
      return myVersion.isEmpty ? removeOne(anId, myVersion["versionNumber"].get!size_t) : false; 
    }

    override bool removeOne(UUID anId, size_t aVersionNumber = 0) {
      // Preconditions
      if (!folder || !folder.exists) { 
      return false; 
    }  
      
      // Get folder with version files
      auto myFolder = folder.folder(anId.toString);
      if (myFolder is null) { 
      return false; 
    }
      
      if (aVersionNumber == 0) { return myFolder.remove; }

      // Get a file with selected version or the current version (versionNumber is empty or "*")  
      auto myVersionFile = myFolder.file(to!string(aVersionNumber));
      if (myVersionFile is null) { 
      return false; 
    }

      myVersionFile.remove;
      if (myFolder.isEmpty) myFolder.remove;
          
      return (!myVersionFile.exists); 
    } 

    override bool removeOne(STRINGAA select, bool allVersions = false) {
      // Preconditions
      if (!folder || !folder.exists) { 
      return false; 
    }  
      if (select.isEmpty) { 
      return false; 
    }

      if (allVersions) { 
        auto myJson = findOne(select, allVersions); 
        if (myJson.isEmpty) { 
      return false; 
    } 
        
        return removeOne(myJson, false);
      }

      if ("id" !in select) { 
      return false; 
    }
      auto myId = UUID(select["id"]).toString;

      auto myFolder = folder.folder(myId);
      if (myFolder is null) { 
      return false; 
    } // Folder not found

      if (allVersions) { return myFolder.remove; }

      // Has select a version number?
      auto myVersionNumber = to!size_t(select.get("versionNumber", "0"));
      if (myVersionNumber == 0) { return myFolder.remove; }
      
      // Get a file with selected version or the current version (versionNumber is empty or "*")  
      auto myVersionFile = myFolder.file(to!string(myVersionNumber));
      if (myVersionFile is null) { 
      return false; 
    } // File not found

      myVersionFile.remove; 
      if (myFolder.isEmpty) { myFolder.remove; }

      return (!myVersionFile.exists);
    }

    override bool removeOne(Json select, bool allVersions = false) {
      // Preconditions
      if (select.isEmpty) { 
      return false; 
    }

      // Body
      if (allVersions) { 
        auto json = findOne(select, allVersions); 
        if (json.isEmpty) { 
      return false; 
    } 
        
        return removeOne(json, false);
      }

      if ("id" !in select) { 
      return false; 
    }
      auto myId = UUID(select["id"].get!string);

      IFolder idFolder = folder.folder(myId.toString);
      if (idFolder is null) { 
      return false; 
    }
      
      auto versionFile = idFolder.file("versionNumber" in select ? select["versionNumber"].get!string : "1");
      if (versionFile is null) { 
      return false; 
    }

      versionFile.remove; 
      if (idFolder.isEmpty) { idFolder.remove; }

      // Final
      return (!versionFile.exists);
    }
  // #endregion removeOne()
}
mixin(JsonCollectionCalls!("FileJsonCollection"));

unittest {
  version(testUimJsonbase) { 
    debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
  }
}