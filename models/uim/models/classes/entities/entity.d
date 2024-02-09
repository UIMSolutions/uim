/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.entities.entity;

import uim.models;

@safe:
class DEntity : DElement, IEntity /* : IRegistrable */ {
  // static namespace = moduleName!DEntity;

  // Constructors
  this() {
    initialize;
  }

  // this(DOOPModel myModel) { this().model(myModel); }
  this(UUID myId) {
    this().id(myId);
    name(id.toString);
  }

  this(string myName) {
    this().name(myName);
  }

  this(UUID myId, string myName) {
    this(myId).name(myName);
  }

  this(Json aJson) {
    this();
    if (aJson != Json(null))
      fromJson(aJson);
  }

  // Initialize entity 
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    /* addValues([
      "description": StringAttribute,
      "pool": StringAttribute,
      "version": VersionElementAttribute
    ]); */

    className("Entity");
    id(randomUUID);
    etag(toTimestamp(now));
    name(id.toString);
    createdOn(now);
    lastAccessedOn(createdOn);
    modifiedOn(createdOn);
    hasVersions(false);
    hasLanguages(false);
    config(Json.emptyObject);
    requestPrefix("entity_");
    // Initialize version
    versionOn(createdOn);
    versionNumber(1L); // Allways starts with version 1;
    versionBy(createdBy);

    return true;
  }

  // TODO mixin(TProperty!("DEntityCollection", "collection"));
  mixin(TProperty!("string", "routingPath")); // required for routing

  mixin(DataProperty!("string", "description"));
  /// 
  unittest {
    auto entity = new DEntity;
    writeln(entity);
    entity.description = "newDescription";
    assert(entity.description == "newDescription");
    assert(entity.description != "noDescription");

    assert(entity.description("otherDescription").description == "otherDescription");
    assert(entity.description != "noDescription");
  }

  mixin(DataProperty!("string", "pool"));
  /// 
  unittest {
    auto entity = new DEntity;
    entity.pool = "newPool";
    assert(entity.pool == "newPool");
    assert(entity.pool != "noPool");

    assert(entity.pool("otherPool").pool == "otherPool");
    assert(entity.pool != "noPool");
  }

  mixin(LongDataProperty!("versionNumber", "version.number"));

  ///	Date and time when the entity was versioned.	
  mixin(TimeStampDataProperty!("versionOn", "version.on"));
  /// 
  unittest {
    auto timestamp = toTimestamp(now);
    auto entity = new DEntity;

    entity.versionOn = timestamp;
    assert(entity.versionOn == timestamp);
    assert(entity.versionOn != 1);

    timestamp = toTimestamp(now);
    assert(entity.versionOn(timestamp).versionOn == timestamp);
    assert(entity.versionOn != 1);
  }

  // Who created version
  mixin(UUIDDataProperty!("versionBy", "version.by"));
  /// 
  unittest {
    auto id = randomUUID;
    auto entity = new DEntity;

    entity.versionBy = id;
    assert(entity.versionBy == id);
    assert(entity.versionBy != randomUUID);

    id = randomUUID;
    assert(entity.versionBy(id).versionBy == id);
    assert(entity.versionBy != randomUUID);
  }

  mixin(DataProperty!("string", "versionDescription", "version.description"));
  /// 
  unittest {
    auto entity = new DEntity;
    entity["version.description"] = "version with description";
    assert(entity["version.description"] == "version with description");

    entity.versionDescription = "version with new description";

    assert(entity.versionDescription == "version with new description");
    assert(entity.versionDescription != "noVersionDescription");

    assert(entity.versionDescription("version with other description")
        .versionDescription == "version with other description");
    assert(entity.versionDescription != "noVersionDescription");
  }

  mixin(DataProperty!("string", "versionDisplay", "version.display"));
  /// 
  unittest {
    auto entity = new DEntity;
    entity.versionDisplay = "newVersionDisplay";
    assert(entity.versionDisplay == "newVersionDisplay");
    assert(entity.versionDisplay != "noVersionDisplay");

    assert(entity.versionDisplay("otherVersionDisplay").versionDisplay == "otherVersionDisplay");
    assert(entity.versionDisplay != "noVersionDisplay");
  }

  mixin(DataProperty!("string", "versionMode", "version.mode"));
  /// 
  unittest {
    auto entity = new DEntity;
    entity.versionMode = "newVersionMode";
    assert(entity.versionMode == "newVersionMode");
    assert(entity.versionMode != "noVersionMode");

    assert(entity.versionMode("otherVersionMode").versionMode == "otherVersionMode");
    assert(entity.versionMode != "noVersionMode");
  }

  string[] fieldNames() {
    return [
      "registerPath", "id", "etag", "name", "display", "createdOn", "createdBy",
      "modifiedOn", "modifiedBy", "lastAccessedOn",
      "lastAccessBy", "description", "isLocked", "lockedOn", "lockedBy",
      "isDeleted", "deletedOn", "deletedBy", "versionNumber",
      "versionDisplay", "versionMode", "versionOn", "versionBy",
      "versionDescription"
    ] ~
       /* attributes.keys~ */
      values.keys;
  }

  alias opEquals = Object.opEquals;
  bool opEquals(DEntity checkEntity) {
    return (id == checkEntity.id);
  }

  mixin(TProperty!("UUID", "id"));
  @property void id(string newValue) {
    if (newValue.isUUID)
      id(UUID(newValue));

  }

  mixin(TProperty!("long", "etag"));
  @property void etag(string newValue) {
    etag(to!long(newValue));
  }

  // mixin(TProperty!("DEntityCollection", "collection"));
  mixin(TProperty!("string", "siteName"));
  // mixin(TProperty!("DOOPModel", "model"));
  mixin(TProperty!("Json", "config"));

  /// Versioning

  void createVersion(string display = "", string description = "") {
    hasVersions = true;

    UUID user;
    /* auto result = new O(toJson);
    result.versionNumber = result.versionNumber + 1;
    result.versionDescription = description;
    result.versionOn(now);
    result.modifiedOn(result.versionOn);
    result.versionBy(user);
    return cast(O) result; */
  }

  /* TODO [] versions() {
    O[] results;

    if (model) {
      foreach(json; model.jsons([id])) {
        results ~= (new O(model)).fromJson(json);
      }
    }

    return result;
  }*/

  /*
  void attribute(string name, string type) {
    if (type.strip.indexOf("{") == 0) {
      Json json = parseJsonString(type);
      attribute(name, json);
    }
    else {
      switch(type.toLower) {
        case "bool": _attributes[name] = OOPAttributeBool; break;
        case "long": _attributes[name] = OOPLongAttribute; break;
        case "double": _attributes[name] = OOPAttributeDouble; break;
        case "string": _attributes[name] = OOPStringAttribute; break;
        case "userid": _attributes[name] = OOPAttributeUserId; break;
        case "uuid": _attributes[name] = OOPUUIDAttribute; break;
        case "array": _attributes[name] = OOPArrayAttribute; break;
        case "object": _attributes[name] = OOPAttributeObject; break;
        default:
          _attributes[name] = OOPStringAttribute; break;  
      }}
    
  }
  void attribute(string name, Json json) {
    switch(json["datatype"].get!string.toLower) {
        case "bool": _attributes[name] = OOPAttributeBool.config(json); break;
        case "long": _attributes[name] = OOPLongAttribute.config(json); break;
        case "double": _attributes[name] = OOPAttributeDouble.config(json); break;
        case "string": _attributes[name] = OOPStringAttribute.config(json); break;
        case "userid": _attributes[name] = OOPAttributeUserId.config(json); break;
        case "uuid": _attributes[name] = OOPUUIDAttribute.config(json); break;
        case "array": _attributes[name] = OOPArrayAttribute.config(json); break;
        case "object": _attributes[name] = OOPAttributeObject.config(json); break;
      default:
        _attributes[name] = OOPStringAttribute.config(json); break;  
    }
    
  }
  void attribute(string name, DOOPAttribute newAttribute) {
    _attributes[name] = newAttribute;  
     }
  // Every entity has a unique id as a primary key
  mixin(TProperty!("UUID", "id"));
  void id(string anUuid) { id(UUID(anUuid));  }
  version(test_uim_models) {
    unittest {
      auto id1 = randomUUID;
      assert(Entity.id(id1).id == id1);
      auto id2 = randomUUID;
      assert(Entity.id(id1).id(id2).id == id2);
    }
  } */

  /* void opDispatch(string name, this O)(string aValue){
    if (auto myValue = values[name]) {
      myValue.value(aValue);
    }
    else { writeln("Unknown value in "~className); }

    
  } */

  /*   string opDispatch(string name)(){
    if (auto myValue = values[name]) {
      return myValue.toString;
    }
    else { 
      writeln("Unknown value in "~className); 
      return null;
    }
  } */

  void opDispatch(string name, UUID value)(UUID aValue) {
    if (auto myValue = values[name]) {
      if (auto myUUIDData = cast(DUUIDData) myValue) {
        myUUIDData.value(aValue);
      }
    } else {
      writeln("Unknown value in " ~ className);
    }
  }
  /*   void addAttributes(DAttribute[] newAttributes) {
    newAttributes.each!(newAttribute => addAttribute(newAttribute));
    
  }
  void addAttributes(DAttribute[string] newAttributes) {
    newAttributes.byKey.each!(key => values[key] = newAttributes[key].createValue);
    
  }
  void addAttributes(IData[string] newValues) {
    values.add(newValues);
    
  }

  void addAttribute(DAttribute newAttribute) {
    if (newAttribute) { values[newAttribute.name] = newAttribute.createValue; }
    
  }

  void addAttribute(string key, IData aValue) {
    values[key] = aValue; 
    
  } */
  /// 
  unittest {
    auto entity = new DEntity;

    entity.addData("int", new DIntegerData(10));
    assert(cast(DIntegerData) entity.values["int"]);
    assert(entity["int"] == "10");
    assert((cast(DIntegerData) entity.values["int"]).value == 10);

    entity.addData(new DCityNameAttribute);
    assert((cast(DStringData) entity.values["cityName"]));
  }

  // Display of entity 
  mixin(TProperty!("string", "display"));

  /// Date and time when the entity was created.
  mixin(TProperty!("long", "createdOn"));
  @property void createdOn(SysTime aTime) {
    createdOn(toTimestamp(aTime));

  }

  @property void createdOn(string aTime) {
    createdOn(to!long(aTime));

  }

  version (test_uim_models) {
    unittest {
      /*     auto now1 = now; auto now2 = now;
    assert(Entity.createdOn(now1).createdOn == now1);
    assert(Entity.createdOn(now1).createdOn(now2).createdOn == now2);
 */
    }
  }

  ///   createdBy	Unique identifier of the user who created the entity.	
  mixin(TProperty!("UUID", "createdBy"));
  @property void createdBy(string anUuid) {
    if (anUuid.isUUID)
      createdBy(UUID(anUuid));
    else
      _createdBy = NULLUUID;
  }

  ///	Date and time when the entity was modified.	
  mixin(TProperty!("long", "modifiedOn"));
  @property void modifiedOn(SysTime aTime) {
    modifiedOn(toTimestamp(aTime));

  }

  @property void modifiedOn(string aTime) {
    modifiedOn(to!long(aTime));

  }

  ///	Unique identifier of the user who modified the entity.
  mixin(TProperty!("UUID", "modifiedBy"));
  @property void modifiedBy(string anUuid) {
    if (anUuid.isUUID)
      modifiedBy(UUID(anUuid));
    else
      _modifiedBy = NULLUUID;
  }

  /// Date and time when the entity was created.
  mixin(TProperty!("long", "lastAccessedOn"));
  @property void lastAccessedOn(SysTime aTime) {
    lastAccessedOn(toTimestamp(aTime));

  }

  @property void lastAccessedOn(string aTime) {
    lastAccessedOn(to!long(aTime));

  }

  version (test_uim_models) {
    unittest {
      /*     auto now1 = now; auto now2 = now;
    assert(Entity.createdOn(now1).createdOn == now1);
    assert(Entity.createdOn(now1).createdOn(now2).createdOn == now2);
 */
    }
  }

  ///   lastAccessBy	Unique identifier of the user who accessed the entity.	
  mixin(TProperty!("UUID", "lastAccessBy"));
  @property void lastAccessBy(string anUuid) {
    if (anUuid.isUUID)
      lastAccessBy(UUID(anUuid));
    else
      _lastAccessBy = NULLUUID;
  }

  ///	Entity has only one version. Version handling starts with EntityVersion	
  mixin(TProperty!("bool", "hasVersions"));
  @property void hasVersions(string newValue) {
    hasVersions(newValue == "true");

  }
  ///	entity has only one language. Language handling starts with EntityLanguage	
  mixin(TProperty!("bool", "hasLanguages"));
  @property void hasLanguages(string newValue) {
    hasLanguages(newValue == "true");
  }

  ///	Date and time when the entity is locked.	
  mixin(TProperty!("bool", "isLocked"));
  @property void isLocked(string newValue) {
    isLocked(newValue == "true");
  }
  ///	Date and time when the entity was locked.	
  mixin(TProperty!("long", "lockedOn"));
  @property void lockedOn(SysTime aTime) {
    lockedOn(toTimestamp(aTime));
  }

  @property void lockedOn(string aTime) {
    lockedOn(to!long(aTime));
  }

  ///	Unique identifier of the user who modified the entity.
  mixin(TProperty!("UUID", "lockedBy"));
  @property void lockedBy(string anUuid) {
    lockedBy(UUID(anUuid));
  }

  ///	Date and time when the entity is deleted.	
  mixin(TProperty!("bool", "isDeleted"));
  @property void isDeleted(string newValue) {
    isDeleted(newValue == "true");
  }

  ///	Date and time when the entity was locked.	
  mixin(TProperty!("long", "deletedOn"));
  @property void deletedOn(SysTime aTime) {
    deletedOn(toTimestamp(aTime));
  }

  @property void deletedOn(string aTime) {
    deletedOn(to!long(aTime));
  }

  ///	Unique identifier of the user who deleted the entity.
  mixin(TProperty!("UUID", "deletedBy"));
  @property void deletedBy(string anUuid) {
    deletedBy(UUID(anUuid));
  }

  override STRINGAA selector(STRINGAA parameters) {
    STRINGAA results;

    auto foundId = parameters.get("entity_id", parameters.get("id", ""));
    if (foundId.length > 0)
      results["id"] = foundId;
    auto foundName = parameters.get("entity_name", parameters.get("name", ""));
    if (foundName.length > 0)
      results["name"] = foundName;

    return results;
  }

  // Read entity from STRINGAA
  override void readFromStringAA(STRINGAA reqParameters, bool usePrefix = false) {
    super.readFromStringAA(reqParameters);

    reqParameters.byKeyValue
      .each!(kv => this[kv.key] = kv.value);
  }

  override void readFromRequest(STRINGAA requestValues, bool usePrefix = true) {
    super.readFromRequest(requestValues, usePrefix);

    foreach (fName; fieldNames) {
      auto requestKey = "entity_" ~ fName;
      if (auto boolValue = cast(DBoolData) values[fName]) {
        boolValue.value(requestKey in requestValues ? true : false);
      } else {
        if (requestKey in requestValues) {
          this[fName] = requestValues[requestKey];
        }
      }
    }
  }

  // Converts entity property to string, which is HTML compatible
  override string opIndex(string key) {
    super.opIndex(key);

    switch (key) {
    case "registerPath":
      return registerPath;
    case "id":
      return id.toString;
    case "etag":
      return to!string(etag);
    case "name":
      return name;
    case "display":
      return display;
    case "createdOn":
      return to!string(createdOn);
    case "createdBy":
      return createdBy.toString;
    case "modifiedOn":
      return to!string(modifiedOn);
    case "modifiedBy":
      return modifiedBy.toString;
    case "lastAccessedOn":
      return to!string(lastAccessedOn);
    case "lastAccessBy":
      return lastAccessBy.toString;
    case "description":
      return description;
    case "isLocked":
      return isLocked ? "true" : "false";
    case "lockedOn":
      return to!string(lockedOn);
    case "lockedBy":
      return lockedBy.toString;
    case "isDeleted":
      return isDeleted ? "true" : "false";
    case "deletedOn":
      return to!string(deletedOn);
    case "deletedBy":
      return deletedBy.toString;
    case "versionNumber":
      return to!string(versionNumber);
    case "versionDisplay":
      return versionDisplay;
    case "versionMode":
      return versionMode;
      /*       case "versionOn": return to!string(versionOn);
      case "versionBy": return to!string(versionBy); */
    case "versionDescription":
      return versionDescription;
    default:
      //if (key in attributes) { return attributes[key].StringData; }
      /* if (void value = values[key]) {
        return value.toString;
      }
      auto keys = key.split(".");
      if (keys.length > 1) {
        if (auto subValue = values[keys[0]]) {
          if (auto entityValue = cast(DEntityData) subValue) {
            return entityValue.value[keys[1 .. $].join(".")];
          }
          if (auto ElementData = cast(DElementData) subValue) {
            return ElementData.value[keys[1 .. $].join(".")];
          }
        }
      } */
      return null;
    }
  }

  // X[index] = (string)value 
  alias opIndexAssign = DElement.opIndexAssign;
  override void opIndexAssign(string value, string key) {
    super.opIndexAssign(value, key);

    switch (key) {
    case "id":
      id(value);
      break;
    case "etag":
      etag(value);
      break;
    case "name":
      name(value);
      break;
    case "display":
      display(value);
      break;
    case "createdOn":
      createdOn(value);
      break;
    case "createdBy":
      createdBy(value);
      break;
    case "modifiedOn":
      modifiedOn(value);
      break;
    case "modifiedBy":
      modifiedBy(value);
      break;
    case "lastAccessedOn":
      lastAccessedOn(value);
      break;
    case "lastAccessBy":
      lastAccessBy(value);
      break;
    case "description":
      description(value);
      break;
    case "isLocked":
      isLocked(value);
      break;
    case "lockedOn":
      lockedOn(value);
      break;
    case "lockedBy":
      lockedBy(value);
      break;
    case "isDeleted":
      isDeleted(value);
      break;
    case "deletedOn":
      deletedOn(value);
      break;
    case "deletedBy":
      deletedBy(value);
      break;
    case "hasVersions":
      hasVersions(value);
      break;
    case "hasLanguages":
      hasLanguages(value);
      break;
    case "versionNumber":
      versionNumber(value);
      break;
    case "versionDisplay":
      versionDisplay(value);
      break;
    case "versionMode":
      versionMode(value);
      break;
      /*       case "versionOn": versionOn(value); break;
      case "versionBy": versionBy(value); break; */
    case "versionDescription":
      versionDescription(value);
      break;
    default:
      // if (key in attributes) attributes[key].value(value); 
      if (values.containsKey(key)) {
        // values[key] = value;
      } else {
        auto keys = key.split(".");
        if (keys.length > 1) {
          if (auto subValue = values[keys[0]]) {
            if (auto entityValue = cast(DEntityData) subValue) {
              entityValue.value[keys[1 .. $].join(".")] = value;
            }
            if (auto ElementData = cast(DElementData) subValue) {
              ElementData.value[keys[1 .. $].join(".")] = value;
            }
          }
        }
      }
      break;
    }
  }

  // Read HTML value and set entity value
  override void opIndexAssign(UUID value, string key) {
    super.opIndexAssign(value, key);

    switch (key) {
    case "id":
      id(value);
      break;
    case "createdBy":
      createdBy(value);
      break;
    case "modifiedBy":
      modifiedBy(value);
      break;
    case "lastAccessBy":
      lastAccessBy(value);
      break;
    case "lockedBy":
      lockedBy(value);
      break;
    case "deletedBy":
      deletedBy(value);
      break;
      /*       case "versionBy": versionBy(value); break; */
    default:
      /* if (key in attributes) {
          if (auto att = cast(DOOPUUIDAttribute)attributes[key]) att.value(value); 
        }  */
      // values[key] = value;
      break;
    }
  }

  override void opIndexAssign(long value, string key) {
    super.opIndexAssign(value, key);

    switch (key) {
    case "createdOn":
      createdOn(value);
      break;
    case "modifiedOn":
      modifiedOn(value);
      break;
    case "lastAccessedOn":
      lastAccessedOn(value);
      break;
    case "lockedOn":
      lockedOn(value);
      break;
    case "deletedOn":
      deletedOn(value);
      break;
      /*       case "versionOn": versionOn(value); break; */
    default:
      // values[key] = value;
      break;
    }
  }

  override void opIndexAssign(bool value, string key) {
    super.opIndexAssign(value, key);

    switch (key) {
    case "isLocked":
      isLocked(value);
      break;
    case "isDeleted":
      isDeleted(value);
      break;
    case "hasVersions":
      hasVersions(value);
      break;
    default:
      /* if (key in attributes) {
          if (auto att = cast(DOOPBooleanAttribute)attributes[key]) att.value(value); 
        }  */
      // values[key] = value;
      break;
    }
  }

  // Set field(key) if type Entity
  void opIndexAssign(DEntity value, string key) {
    switch (key) {
    default:
      /* if (key in attributes) {
          debug writeln("key %s in attributes %s".format(key, attributes[key].StringData));
          if (auto att = cast(DEntityAttribute)attributes[key]) att.value(value); 
        }  */
      break;
    }
  }

  /*   DEntity create() { return new DEntity; }
  DEntity create(Json data) {
    auto result = create;
    result.fromJson(data);   
    return result; }

  DEntity clone() { 
    auto result = create;
    result.fromJson(toJson); 
    return result; }
  DEntity clone(Json data) { 
    auto result = clone;
    result.fromJson(data);
    return result; } */

  /*   DEntity copyTo(DEntity targetOfCopy) {
    if (targetOfCopy) {
      targetOfCopy.fromJson(toJson);
      return targetOfCopy; }
    return null; }
  DEntity copyFrom(DEntity targetOfCopy) {
    if (targetOfCopy) {
      fromJson(targetOfCopy.toJson);
    }
    return this;
  } */

  override void fromJson(Json aJson) {
    if (aJson.isEmpty) {
      return;
    }
    super.fromJson(aJson);

    foreach (keyvalue; aJson.byKeyValue) {
      auto k = keyvalue.key;
      auto v = keyvalue.value;
      switch (k) {
      case "pool":
        pool(v.get!string);
        break;
      case "id":
        id(v.get!string);
        break;
      case "etag":
        etag(v.get!long);
        break;
      case "name":
        name(v.get!string);
        break;
      case "display":
        display(v.get!string);
        break;
      case "createdOn":
        createdOn(v.get!long);
        break;
      case "createdBy":
        createdBy(v.get!string);
        break;
      case "modifiedOn":
        modifiedOn(v.get!long);
        break;
      case "modifiedBy":
        modifiedBy(v.get!string);
        break;
      case "description":
        description(v.get!string);
        break;
      case "isLocked":
        isLocked(v.get!bool);
        break;
      case "lockedOn":
        lockedOn(v.get!long);
        break;
      case "lockedBy":
        lockedBy(v.get!string);
        break;
      case "isDeleted":
        isDeleted(v.get!bool);
        break;
      case "deletedOn":
        deletedOn(v.get!long);
        break;
      case "deletedBy":
        deletedBy(v.get!string);
        break;
        /*         case "model": 
          auto id = v.get!string;
          if (id.isUUID) model(OOPModel(UUID(id)));
          else model(OOPModel(id));
          break; */
      case "hasVersions":
        hasVersions(v.get!bool);
        break;
      case "hasLanguages":
        hasLanguages(v.get!bool);
        break;
      case "parameters":
        STRINGAA values;
        foreach (kv; v.byKeyValue) {
          values[kv.key] = kv.value.get!string;
        }
        parameters(values);
        break;
      case "config":
        config(v);
        break;
      case "versionNumber":
        versionNumber(v.get!long);
        break;
      case "versionDisplay":
        versionDisplay(v.get!string);
        break;
      case "versionMode":
        versionMode(v.get!string);
        break;
        /*         case "versionOn": versionOn(v.get!long); break;
        case "versionBy": versionBy(v.get!string); break; */
      case "versionDescription":
        versionDescription(v.get!string);
        break;
      default:
        /* if (k in _attributes) {
            // debug writeln("Found ", k);
            _attributes[k].value(v); 
          } */

        // values[k].value(v);
        break;
      }
    }
  }

  override Json toJson(string[] showFields = null, string[] hideFields = null) {
    auto result = super.toJson(showFields, hideFields);

    if (showFields.isEmpty && hideFields.isEmpty) {
      result = result.set(
        [
        "registerPath": registerPath,
        "id": id.toString,
        "name": name,
        "display": display,
        // "createdOn": createdOn,
        "createdBy": createdBy.toString,
        // "modifiedOn": modifiedOn,
        "modifiedBy": modifiedBy.toString,
        // "lastAccessedOn": lastAccessedOn,
        "lastAccessBy": lastAccessBy.toString,
        "description": description,
        // "isLocked": isLocked,
        // "lockedOn": lockedOn,
        "lockedBy": lockedBy.toString,
        // "isDeleted": isDeleted,
        // "deletedOn": deletedOn,
        "deletedBy": deletedBy.toString
      ]);

      /* if (model) {
        if (model.id.isNull) result["model"] = model.name;
        else result["model"] = model.id.toString;
      } */
      result = result.set(
        ["hasVersions": hasVersions,
          "hasLanguages": hasLanguages]);

      auto parameterValues = Json.emptyObject.set(parameters);
      result["parameters"] = parameterValues;

      result["config"] = config;

      /*       foreach(k; _attributes.byKey) {
        if (!hideFields.exist(k)) result[k] = _attributes[k].jsonValue;
      } */
      values.keys
        .each!(key => result[key] = values[key].toJson);

    } else if (showFields.isEmpty && !hideFields.isEmpty) {
      if (!hideFields.exist("registerPath"))
        result["registerPath"] = registerPath;
      if (!hideFields.exist("id"))
        result["id"] = id.toString;
      if (!hideFields.exist("name"))
        result["name"] = name;
      if (!hideFields.exist("display"))
        result["display"] = display;
      if (!hideFields.exist("createdOn"))
        result["createdOn"] = createdOn;
      if (!hideFields.exist("createdBy"))
        result["createdBy"] = createdBy.toString;
      if (!hideFields.exist("modifiedOn"))
        result["modifiedOn"] = modifiedOn;
      if (!hideFields.exist("modifiedBy"))
        result["modifiedBy"] = modifiedBy.toString;
      if (!hideFields.exist("lastAccessedOn"))
        result["lastAccessedOn"] = lastAccessedOn;
      if (!hideFields.exist("lastAccessBy"))
        result["lastAccessBy"] = lastAccessBy.toString;
      if (!hideFields.exist("description"))
        result["description"] = description;
      if (!hideFields.exist("isLocked"))
        result["isLocked"] = isLocked;
      if (!hideFields.exist("lockedOn"))
        result["lockedOn"] = lockedOn;
      if (!hideFields.exist("lockedBy"))
        result["lockedBy"] = lockedBy.toString;
      if (!hideFields.exist("isDeleted"))
        result["isDeleted"] = isDeleted;
      if (!hideFields.exist("deletedOn"))
        result["deletedOn"] = deletedOn;
      if (!hideFields.exist("deletedBy"))
        result["deletedBy"] = deletedBy.toString;
      /* if (!hideFields.exist("model")) {
        if (model) {
          if (model.id.isNull) result["model"] = model.name;
          else result["model"] = model.id.toString;
        }
      } */
      if (!hideFields.exist("hasVersions"))
        result["hasVersions"] = hasVersions;
      if (!hideFields.exist("hasLanguages"))
        result["hasLanguages"] = hasLanguages;
      if (!hideFields.exist("parameters")) {
        auto parameterValues = Json.emptyObject;
        foreach (kv; parameters.byKeyValue) {
          parameterValues[kv.key] = parameters[kv.value];
        }
        result["parameters"] = parameterValues;
      }
      if (!hideFields.exist("config"))
        result["config"] = config;
    } else {
      if ((showFields.exist("registerPath")) && (!hideFields.exist("registerPath")))
        result["registerPath"] = registerPath;
      if ((showFields.exist("id")) && (!hideFields.exist("id")))
        result["id"] = id.toString;
      if ((showFields.exist("name")) && (!hideFields.exist("name")))
        result["name"] = name;
      if ((showFields.exist("display")) && (!hideFields.exist("display")))
        result["display"] = display;
      if ((showFields.exist("createdOn")) && (!hideFields.exist("createdOn")))
        result["createdOn"] = createdOn;
      if ((showFields.exist("createdBy")) && (!hideFields.exist("createdBy")))
        result["createdBy"] = createdBy.toString;
      if ((showFields.exist("modifiedOn")) && (!hideFields.exist("modifiedOn")))
        result["modifiedOn"] = modifiedOn;
      if ((showFields.exist("modifiedBy")) && (!hideFields.exist("modifiedBy")))
        result["modifiedBy"] = modifiedBy.toString;
      if ((showFields.exist("lastAccessedOn")) && (!hideFields.exist("lastAccessedOn")))
        result["lastAccessedOn"] = lastAccessedOn;
      if ((showFields.exist("lastAccessBy")) && (!hideFields.exist("lastAccessBy")))
        result["lastAccessBy"] = lastAccessBy.toString;
      if ((showFields.exist("description")) && (!hideFields.exist("description")))
        result["description"] = description;
      if ((showFields.exist("isLocked")) && (!hideFields.exist("isLocked")))
        result["isLocked"] = isLocked;
      if ((showFields.exist("lockedOn")) && (!hideFields.exist("lockedOn")))
        result["lockedOn"] = lockedOn;
      if ((showFields.exist("lockedBy")) && (!hideFields.exist("lockedBy")))
        result["lockedBy"] = lockedBy.toString;
      if ((showFields.exist("isDeleted")) && (!hideFields.exist("isDeleted")))
        result["isDeleted"] = isDeleted;
      if ((showFields.exist("deletedOn")) && (!hideFields.exist("deletedOn")))
        result["deletedOn"] = deletedOn;
      if ((showFields.exist("deletedBy")) && (!hideFields.exist("deletedBy")))
        result["deletedBy"] = deletedBy.toString;
      /* if ((showFields.exist("model")) && (!hideFields.exist("model"))) {
        if (model) {
          if (model.id.isNull) result["model"] = model.name;
          else result["model"] = model.id.toString;
        }
      } */
      if ((showFields.exist("hasVersions")) && (!hideFields.exist("hasVersions")))
        result["hasVersions"] = hasVersions;
      if ((showFields.exist("hasLanguages")) && (!hideFields.exist("hasLanguages")))
        result["hasLanguages"] = hasLanguages;
      if ((showFields.exist("parameters")) && (!hideFields.exist("parameters"))) {
        result["parameters"] = Json.emptyObject.set(parameters);
        ;
      }
      if ((showFields.exist("config")) && (!hideFields.exist("config")))
        result["config"] = config;
    }

    if (showFields.isEmpty) {
      foreach (k; values.keys) {
        if (!hideFields.exist(k))
          result[k] = values[k].toJson;
      }
    } else {
      foreach (k; values.keys) {
        if ((showFields.exist(k)) && (!hideFields.exist(k)))
          result[k] = values[k].toJson;
      }
    }

    return result;
  }

  void load() {
    /* if (collection) fromJson(collection.findOne(id).toJson); */
  }

  version (test_uim_models) {
    unittest {
      // TODO: Add Test
    }
  }

  DEntity save() {
    /* if (collection) {
      if (collection.findOne(id)) collection.updateOne(this); 
      else collection.insertOne(this); 
    } */

    return this;
  }

  version (test_uim_models) {
    unittest {
      // TODO: Add Test
    }
  }

  void remove(bool allVersions = false) {
    /* if (collection)
      collection.removeMany(this, allVersions); */
  }

}

auto Entity() {
  return new DEntity;
}

auto Entity(Json json) {
  return new DEntity(json);
}

///
unittest {
  /* assert(Entity);

  assert(Entity.name("entity").name == "entity");
  
  auto entity = Entity;
  auto entityValue = EntityData;
  entityValue.value = Entity.name("TestEntity");
  entity.values["entity"] = entityValue;

  assert(entity["entity.name"] == "TestEntity");
  assert(entity["entity.name"] != "_");

  entity["entity.name"] = "newEntityName";
  assert(entity["entity.name"] == "newEntityName");

  entityValue = cast(DEntityData)entity.values["entity"];
  // writeln(entityValue.value["name"]);
  assert(entityValue.value["name"] == "newEntityName");

  auto ElementData = ElementData; */
  /* ElementData.name("TestElement");
  entity.values["element"] = entityValue;

  assert(entity["element.name"] == "TestElement");
  assert(entity["element.name"] != "_");

  entity["element.name"] = "newElementName";
  assert(entity["element.name"] == "newElementName");

  ElementData = cast(DElementData)entity.values["element"];
  assert(ElementData.value["name"] == "newElementName");  */

  /*
  assert(Entity.id(randomuuid)
  assert(Entity.etag(totimestamp(now))
  assert(Entity.name(id.tostring) 
  assert(Entity.createdon(now)
  assert(Entity.lastaccessedon(createdon)
  assert(Entity.modifiedon(createdon)
  assert(Entity.hasversions(false)
  assert(Entity.haslanguages(false)
  assert(Entity.config(json.emptyobject)
  assert(Entity.values(values)
  assert(Entity.versionon(createdon)
  assert(Entity.versionnumber(1l) // allways starts with version 1
  assert(Entity.versionby(createdby); 

registerPath": return registerPath;
      case "id": return id.toString;
      case "etag": return to!string(etag);
      case "name": return name;
      case "display": return display;
      case "createdOn": return to!string(createdOn); 
      case "createdBy": return createdBy.toString; 
      case "modifiedOn": return to!string(modifiedOn); 
      case "modifiedBy": return modifiedBy.toString; 
      case "lastAccessedOn": return to!string(lastAccessedOn); 
      case "lastAccessBy": return lastAccessBy.toString; 
      case "description": return description;
      case "isLocked": return isLocked ? "true" : "false";
      case "lockedOn": return to!string(lockedOn);
      case "lockedBy": return lockedBy.toString; 
      case "isDeleted": return isDeleted ? "true" : "false";
      case "deletedOn": return to!string(deletedOn);
      case "deletedBy": return deletedBy.toString; 
      case "versionNumber": return to!string(versionNumber);
      case "versionDisplay": return versionDisplay;
      case "versionMode": return versionMode;
      case "versionOn": return to!string(versionOn);
      case "versionBy": return to!string(versionBy);
      case "versionDescription": return versionDescription;
      default:
        //if (key in attributes) { return attributes[key].StringData; }
        if (values.hasValue(key)) { return values[key].toString; }
        return null;
    }      
*/
}
