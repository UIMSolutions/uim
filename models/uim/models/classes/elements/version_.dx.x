/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.elements.version_;

import uim.models;

@safe:
class DVersion : DElement {
  // static namespace = moduleName!DVersion;

  // Constructors
  this() {
    super();
  }

  this(string myName) {
    super(myName);
  }

  this(Json aJson) {
    this();
    if (aJson != Json(null))
      this.fromJson(aJson);
  }

  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    /* addValues([
        "description": StringAttribute,
        "by": UUIDAttribute,
        "display": StringAttribute,
        "mode": StringAttribute,
        "number": LongAttribute,
        "on": TimestampAttribute
      ]); */

    return true;
  }

  mixin(IntegerDataProperty!("number"));

  ///	Date and time when the entity was versioned.	
  mixin(TimeStampDataProperty!("on"));
  /// 
  unittest {
    auto timestamp = toTimestamp(now);
    auto element = new DVersion;
    element.on = timestamp;
    assert(element.on == timestamp);
    assert(element.on != 1);

    timestamp = toTimestamp(now);

    element.on(timestamp);
    assert(element.on == timestamp);
    assert(element.on != 1);
  }

  // Who created version
  mixin(UUIDDataProperty!("by"));
  /// 
  unittest {
    auto id = randomUUID;
    auto element = new DVersion;
    element.by = id;
    assert(element.by == id);
    assert(element.by != randomUUID);

    id = randomUUID;
    element.by(id);
    assert(element.by == id);
    assert(element.by != randomUUID);
  }

  mixin(DataProperty!("string", "description"));
  /// 
  unittest {
    auto element = new DVersion;
    element.description = "newDescription";
    assert(element.description == "newDescription");
    assert(element.description != "noDescription");

    element.description("otherDescription");
    assert(element.description == "otherDescription");
    assert(element.description != "noDescription");
  }

  mixin(DataProperty!("string", "display"));
  /// 
  unittest {
    auto element = new DVersion;
    element.display = "newDisplay";
    assert(element.display == "newDisplay");
    assert(element.display != "noDisplay");

    element.display("otherDisplay");
    assert(element.display == "otherDisplay");
    assert(element.display != "noDisplay");
  }

  mixin(DataProperty!("string", "mode"));
  /// 
  unittest {
    auto element = new DVersion;
    element.mode = "newMode";
    assert(element.mode == "newMode");
    assert(element.mode != "noMode");

    element.mode("otherMode");
    assert(element.mode == "otherMode");
    assert(element.mode != "noMode");
  }

  override DElement create() {
    return new DVersion;
  }
}

auto Version() {
  return new DVersion;
}

auto Version(string name) {
  return new DVersion(name);
}

auto Version(Json json) {
  return new DVersion(json);
}

version (test_uim_models) {
  unittest {
    assert(Version);
    
    auto vers = Version;
    vers.name("test");
    assert(vers.name == "test");
    vers.name("testName");
    assert(vers.name == "testname");
  }
}
