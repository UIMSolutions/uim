/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.jsonbases.helpers.path;

import uim.jsonbases;

unittest { 
  version(test_uim_jsonbase) { 
    debug writeln("\n", __MODULE__~": "~__PRETTY_FUNCTION__); 
  }
}

@safe:
// #region folderPath()
  string folderPath(string path, Json json, string separator = "/") {
    if (json.isEmpty) return null;
    if ("id" !in json) return null;

    return folderPath(path, UUID(json["id"].get!string), separator);
  }

  string folderPath(string path, UUID id, string separator = "/") {
    return folderPath(path, id.toString, separator);
  }

  string folderPath(string path, string id, string separator = "/") {
    return path~separator~id;
  }

  string folderPath(Json json, string separator = "/") {
    if (json.isEmpty) return null;
    if ("id" !in json) return null;

    return separator~json["id"].get!string;
  }
// #endregion folderPath()

// #region versionPath()
  string versionPath(string[] path, UUID id, size_t versionNumber, string separator = "/") {
    return versionPath(path.join(separator), id, versionNumber, separator);
  }

  string versionPath(string path, UUID id, size_t versionNumber, string separator = "/") {
    return path~separator~versionPath(id, versionNumber, separator);
  }

  string versionPath(UUID id, size_t versionNumber, string separator = "/") {
    return id.toString~separator~separator~to!string(versionNumber > 0 ? versionNumber : 1)~".json";
  }

  string versionPath(string[] path, Json json, string separator = "/") {
    if (path.isEmpty || json.isEmpty) { return null; }
    
    return versionPath(path.join(separator), json, separator);
  }

  string versionPath(string path, Json json, string separator = "/") {
    if (path.isEmpty || json.isEmpty) { return null; }
    if ("id" !in json) return null;

    return path~separator~versionPath(json, separator);
  }

  string versionPath(Json json, string separator = "/") {
    if (json.isEmpty) { return null; }
    if ("id" !in json) return null;

    return folderPath(json, separator)~separator~
      ("versionNumber" in json && json["versionNumber"].get!size_t > 0 
        ? json["versionNumber"].get!string 
        : "1") 
      ~".json";
  }
// #endregion versionPath()

