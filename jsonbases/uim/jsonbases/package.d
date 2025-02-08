/****************************************************************************************************************
* Copyright: © 2017-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.jsonbases;

mixin(ImportPhobos!());

// Dub
public {
  import vibe.d;
}

public {
  import uim.core;
  import uim.oop;
  import uim.errors;
  import uim.filesystems;

  // import uim.logging;
}

public {
  import uim.jsonbases.classes;
  import uim.jsonbases.exceptions;
  import uim.jsonbases.helpers;
  import uim.jsonbases.interfaces;
  import uim.jsonbases.mixins;
  import uim.jsonbases.tests;
}

@safe:
string filePath(Json json, string sep = "/", string extension = ".json") {
  if (json.isNull)
    return null;

  if ("id" in json && "versionNumber" in json) {
    return json["id"].get!string ~ sep ~ "1" ~ extension;
  }

  return json.hasKey("id") ?
    json["id"].get!string ~ sep ~ to!string(json.getLong("versionNumber")) ~ ".json" : "";
}

/* string jsonFilePath(Json json, string sep = "/") {
  if (json is null) return null;
 
  if ("id" in json && "versionNumber" in json) return json["id"].get!string~sep~"1.json";

  return ("id" in json) ? 
    json["id"].get!string~sep~to!string(json["versionNumber"].get!size_t)~".json" : "";
} */

/* string jsonFilePath(string startPath, Json json, string sep = "/") {
  if (json is null) return null;
  return startPath~sep~jsonFilePath(json, sep);
} */

string dirPath(string path, UUID id, string separator = "/") {
  return path ~ dirPath(id, separator);
}

string dirPath(UUID id, string separator = "/") {
  return separator ~ id.toString;
}

string dirPath(string path, Json json, string separator = "/") {
  if (json.isNull || !json.hasKey("id")) {
    return null;
  }

  return path ~ dirPath(json, separator);
}

string dirPath(Json json, string separator = "/") {
  if (json.isNull || !json.hasKey("id")) {
    return null;
  }

  return separator ~ json["id"].get!string;
}

string filePath(string path, UUID id, size_t versionNumber, string separator = "/") {
  return path ~ filePath(id, versionNumber, separator);
}

string filePath(UUID id, size_t versionNumber, string separator = "/") {
  return dirPath(id, separator) ~ separator ~ to!string(versionNumber > 0 ? versionNumber : 1) ~ ".json";
}

string filePath(string path, Json json, string separator = "/") {
  if (json.isNull || !json.hasKey("id")) {
    return null;
  }

  return path ~ filePath(json, separator);
}

string filePath(Json json, string separator = "/") {
  if (json.isNull || !json.hasKey("id")) {
    return null;
  }

  return dirPath(json, separator) ~ separator ~ ("versionNumber" in json ?
      to!string(json["versionNumber"].get!long > 0 ? json["versionNumber"].get!long : 1) : "1") ~ ".json";
}

Json lastVersion(Json[] jsons) {
  Json result = Json(null);

  if (jsons.length > 0) {
    foreach (json; jsons) {
      if (result.isNull && json.hasKey("versionNumber")) {
        result = json;
      }
    }

    if (!result.isNull) {
      foreach (json; jsons) {
        if (json.hasKey("versionNumber") && json.getLong(
            "versionNumber") > result.getLong("versionNumber")) {
          result = json;
        }
      }
    }
  }

  return result;
}

Json lastVersion(Json[size_t] jsons) {
  Json result = Json(null);

  if (jsons.length > 0) {
    foreach (k, json; jsons) {
      if (result.isNull && "versionNumber" in json)
        result = json;
    }

    if (!result.isNull) {
      foreach (k, json; jsons) {
        if ("versionNumber" in json && json["versionNumber"].get!size_t > result["versionNumber"]
          .get!size_t)
          result = json;
      }
    }
  }

  return result;
}

Json oneVersion(Json[] jsons) {
  return jsonWithMaxVersion(jsons);
}

Json oneVersion(Json[size_t] jsons) {
  return jsonWithMaxVersion(jsons.byValue.array);
}
