/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.patterns.obj;

mixin(Version!"test_uim_oop");

import uim.oop;

@safe:

class UIMObject : IObject {
  mixin TConfigurable;

  this() {
    this.initialize;
    this.name(this.classname);
  }

  this(Json[string] initData) {
    this.initialize(initData);
    this.name(this.classname);
  }

  this(string newName, Json[string] initData = null) {
    this.initialize(initData);
    this.name(newName);
  }

  bool initialize(Json[string] initData = null) {
    name("Object");

    auto config = MemoryConfiguration;
    configuration(config);
    configuration.entries(initData is null ? new Json[string] : initData);

    return true;
  }

  mixin(TProperty!("string", "name"));

  string[] memberNames() {
    return [__traits(allMembers, typeof(this))];
  }

  bool hasAllMembers(string[] names) {
    return memberNames.hasAllValues(names);
  }

  bool hasAnyMembers(string[] names) {
    return memberNames.hasAnyValues(names);
  }

  bool hasMember(string name) {
    return memberNames.hasValue(name);
  }

/*   void opIndexAssign(T)(T value, string name) {
    switch(name) {
      case "name": this.name(value.toString);
      default: break;
    }
    return;
  } */

  /* Json opIndex(string name) {
    switch (name) {
    case "name":
      return name.toJson;
    case "classname":
      return this.classname.toJson;
    case "classFullname":
      return this.classFullname.toJson;
    case "memberNames":
      return memberNames.toJson;
    default:
      return Json(null);
    }
  } */

  Json toJson(string[] showKeys = null, string[] hideKeys = null) {
    Json json = Json.emptyObject;
    json
      .set("name", name)
      .set("classname", this.classname);

    return json;
  }

  Json[string] debugInfo(string[] showKeys = null, string[] hideKeys = null) {
    Json[string] info = null;
    info
      .set("name", name)
      .set("classname", this.classname)
      .set("classFullname", this.classFullname);
    return info;
  }
}

class Test : UIMObject {
  this() {
    super();
  }

  string newMethod() {
    return null;
  }

  override string[] memberNames() {
    return [__traits(allMembers, typeof(this))];
  }
}

unittest {
  // TODO 
}
