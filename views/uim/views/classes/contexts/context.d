/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.views.classes.contexts.context;

import uim.views;

@safe:

version (test_uim_views) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

class DContext : UIMObject, IContext {
  mixin(ContextThis!());

  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    return true;
  }

  const string[] VALID_ATTRIBUTES = [
    "length", "precision", "comment", "null", "default"
  ];

  // Get the field names of the top level object in this context.
  string[] fieldNames() {
    return null;
  }

  Json[string] data() {
    // TODO 
    return null;
  }

  size_t maxLength(string fieldName) {
    // TODO 
    return 0;
  }

  string[] primaryKeys() {
    return null;
  }

  bool isCreate() {
    return false;
  }

  bool isPrimaryKey(string[] fieldPath) {
    /* return isPrimaryKey(fieldPath.strip.join(".")); */
    return false;
  }

  bool isPrimaryKey(string fieldName) {
    return false;
  }

  Json val(string fieldPath, Json[string] options = cast(Json[string]) null) {
    return Json(null);
  }

  bool isRequired(string[] fieldPath) {
    // return isRequired(fieldPath.strip.join("."));
    return false;
  }

  bool isRequired(string fieldName) {
    return false;
  }

  string getRequiredMessage(string fieldPath) {
    return null;
  }

  string type(string fieldPath) {
    return null;
  }

  bool hasError(string fieldPath) {
    return false;
  }
}
