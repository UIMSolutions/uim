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
  this() { initialize; }

  // this(DOOPModel myModel) { this().model(myModel); }
  this(UUID myId) { this().id(myId).name(this.id.toString); }
  this(string myName) { this().name(myName); }
  this(UUID myId, string myName) { this(myId).name(myName); }

  this(Json aJson) { this();    
    if (aJson != Json(null)) this.fromJson(aJson); }

  // Initialize entity 
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false; }

    this
      .adDDatas([
        "description": StringAttribute,
        "pool": StringAttribute,
        "version": VersionElementAttribute              
      ]);

    this
      .className("Entity")
      .id(randomUUID)
      .etag(toTimestamp(now))
      .name(this.id.toString)     
      .createdOn(now)
      .lastAccessedOn(createdOn)
      .modifiedOn(createdOn)
      .hasVersions(false)
      .hasLanguages(false)
      .config(Json.emptyObject)
      .requestPrefix("entity_")
      // Initialize version
      .versionOn(this.createdOn)
      .versionNumber(1L) // Allways starts with version 1
      .versionBy(this.createdBy);
  }

  mixin(OProperty!("DEntityCollection", "collection"));
  mixin(OProperty!("string", "routingPath")); // required for routing

  mixin(ValueProperty!("string", "description"));  
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

  mixin(ValueProperty!("string", "pool"));
  /// 
  unittest {     
    auto entity = new DEntity;
    entity.pool = "newPool";
    assert(entity.pool == "newPool");
    assert(entity.pool != "noPool");

    assert(entity.pool("otherPool").pool == "otherPool");
    assert(entity.pool != "noPool"); 
  }

  mixin(LongValueProperty!("versionNumber", "version.number"));

///	Date and time when the entity was versioned.	
  mixin(TimeStampValueProperty!("versionOn", "version.on"));
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

  mixin(ValueProperty!("string", "versionDescription", "version.description")); 
  /// 
  unittest {
    auto entity = new DEntity;
    entity["version.description"] = "version with description";
    assert(entity["version.description"] == "version with description");
    
    entity.versionDescription = "version with new description";

    assert(entity.versionDescription == "version with new description");
    assert(entity.versionDescription != "noVersionDescription");

    assert(entity.versionDescription("version with other description").versionDescription == "version with other description");
    assert(entity.versionDescription != "noVersionDescription");
  }
  
  mixin(ValueProperty!("string", "versionDisplay", "version.display"));
  /// 
  unittest {
    auto entity = new DEntity;
    entity.versionDisplay = "newVersionDisplay";
    assert(entity.versionDisplay == "newVersionDisplay");
    assert(entity.versionDisplay != "noVersionDisplay");

    assert(entity.versionDisplay("otherVersionDisplay").versionDisplay == "otherVersionDisplay");
    assert(entity.versionDisplay != "noVersionDisplay");
  }

  mixin(ValueProperty!("string", "versionMode", "version.mode"));  
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
      "registerPath", "id", "etag", "name", "display", "createdOn", "createdBy", "modifiedOn", "modifiedBy", "lastAccessedOn", 
      "lastAccessBy", "description", "isLocked", "lockedOn", "lockedBy", "isDeleted", "deletedOn", "deletedBy", "versionNumber", 
      "versionDisplay", "versionMode", "versionOn", "versionBy", "versionDescription"]~
      /* attributes.keys~ */values.keys;
  }

  alias opEquals = Object.opEquals;
  bool opEquals(DEntity checkEntity) {
    return (id == checkEntity.id);
  }

  mixin(OProperty!("UUID", "id"));
  O id(this O)(string newValue) {
    if (newValue.isUUID) this.id(UUID(newValue));
    return cast(O)this;
  }

  mixin(OProperty!("long", "etag"));
  O etag(this O)(string newValue) { 
    this.etag(to!long(newValue)); 
    return cast(O)this; }

  // mixin(OProperty!("DEntityCollection", "collection"));
  mixin(OProperty!("string", "siteName"));
  // mixin(OProperty!("DOOPModel", "model"));
  mixin(OProperty!("Json", "config"));

/// Versioning
  

  O createVersion(this O)(string display = "", string description = "") {
    this.hasVersions = true;

    UUID user;
    auto result = new O(this.toJson);
    result.versionNumber = result.versionNumber + 1;
    result.versionDescription = description;
    result.versionOn(now);   
    result.modifiedOn(result.versionOn);   
    result.versionBy(user);   
    return cast(O)result;
  }

  O[] versions(this O)() {
    O[] results;

    if (model) {
      foreach(json; model.jsons([this.id])) {
        results ~= (new O(model)).fromJson(json);
      }
    }

    return result;
  }

/*
  O attribute(this O)(string name, string type) {
    if (type.strip.indexOf("{") == 0) {
      Json json = parseJsonString(type);
      this.attribute(name, json);
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
    return cast(O)this;
  }
  O attribute(this O)(string name, Json json) {
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
    return cast(O)this;
  }
  O attribute(this O)(string name, DOOPAttribute newAttribute) {
    _attributes[name] = newAttribute;  
    return cast(O)this; }
  // Every entity has a unique id as a primary key
  mixin(OProperty!("UUID", "id"));
  O id(this O)(string anUuid) { this.id(UUID(anUuid)); return cast(O)this; }
  version(test_uim_models) {
    unittest {
      auto id1 = randomUUID;
      assert(Entity.id(id1).id == id1);
      auto id2 = randomUUID;
      assert(Entity.id(id1).id(id2).id == id2);
    }
  } */

  /* O opDispatch(string name, this O)(string aValue){
    if (auto myValue = this.values[name]) {
      myValue.value(aValue);
    }
    else { writeln("Unknown value in "~this.className); }

    return cast(O)this;
  } */

/*   string opDispatch(string name)(){
    if (auto myValue = this.values[name]) {
      return myValue.toString;
    }
    else { 
      writeln("Unknown value in "~this.className); 
      return null;
    }
  } */

  void opDispatch(string name, UUID value)(UUID aValue){
    if (auto myValue = this.values[name]) {
      if (auto myUUIDData = cast(DUUIDData)myValue) {
        myUUIDData.value(aValue);
      }
    }
    else { writeln("Unknown value in "~this.className); }
  }
/*   O addAttributes(this O)(DAttribute[] newAttributes) {
    newAttributes.each!(newAttribute => addAttribute(newAttribute));
    return cast(O)this;
  }
  O addAttributes(this O)(DAttribute[string] newAttributes) {
    newAttributes.byKey.each!(key => this.values[key] = newAttributes[key].createValue);
    return cast(O)this;
  }
  O addAttributes(this O)(DData[string] newValues) {
    this.values.add(newValues);
    return cast(O)this;
  }

  O addAttribute(this O)(DAttribute newAttribute) {
    if (newAttribute) { this.values[newAttribute.name] = newAttribute.createValue; }
    return cast(O)this;
  }

  O addAttribute(this O)(string key, DData aValue) {
    this.values[key] = aValue; 
    return cast(O)this;
  } */
  /// 
  unittest {
    auto entity = new DEntity;

    entity.adDData("int", new DIntegerValue(10));
    assert(cast(DIntegerValue)entity.values["int"]);
    assert(entity["int"] == "10");
    assert((cast(DIntegerValue)entity.values["int"]).value == 10);

    entity.adDData(new DCityNameAttribute);  
    assert((cast(DStringData)entity.values["cityName"]));
  }

  // Display of entity 
  mixin(OProperty!("string", "display"));

  /// Date and time when the entity was created.
  mixin(OProperty!("long", "createdOn"));
  O createdOn(this O)(SysTime aTime) {
    this.createdOn(toTimestamp(aTime));
    return cast(O)this;
  }
  O createdOn(this O)(string aTime) {
    this.createdOn(to!long(aTime));
    return cast(O)this;
  }
  version(test_uim_models) {
    unittest {
/*     auto now1 = now; auto now2 = now;
    assert(Entity.createdOn(now1).createdOn == now1);
    assert(Entity.createdOn(now1).createdOn(now2).createdOn == now2);
 */  }
  }

  ///   createdBy	Unique identifier of the user who created the entity.	
  mixin(OProperty!("UUID", "createdBy"));
  O createdBy(this O)(string anUuid) { 
    if (anUuid.isUUID) this.createdBy(UUID(anUuid)); 
    else _createdBy = NULLUUID;
    return cast(O)this; }

  ///	Date and time when the entity was modified.	
  mixin(OProperty!("long", "modifiedOn"));
  O modifiedOn(this O)(SysTime aTime) {
    this.modifiedOn(toTimestamp(aTime));
    return cast(O)this;
  }
  O modifiedOn(this O)(string aTime) {
    this.modifiedOn(to!long(aTime));
    return cast(O)this;
  }

  ///	Unique identifier of the user who modified the entity.
  mixin(OProperty!("UUID", "modifiedBy"));
  O modifiedBy(this O)(string anUuid) { 
    if (anUuid.isUUID) this.modifiedBy(UUID(anUuid)); 
    else _modifiedBy = NULLUUID;
    return cast(O)this; }

  /// Date and time when the entity was created.
  mixin(OProperty!("long", "lastAccessedOn"));
  O lastAccessedOn(this O)(SysTime aTime) {
    this.lastAccessedOn(toTimestamp(aTime));
    return cast(O)this;
  }
  O lastAccessedOn(this O)(string aTime) {
    this.lastAccessedOn(to!long(aTime));
    return cast(O)this;
  }
  version(test_uim_models) {
    unittest {
/*     auto now1 = now; auto now2 = now;
    assert(Entity.createdOn(now1).createdOn == now1);
    assert(Entity.createdOn(now1).createdOn(now2).createdOn == now2);
 */  }
  }

  ///   lastAccessBy	Unique identifier of the user who accessed the entity.	
  mixin(OProperty!("UUID", "lastAccessBy"));
  O lastAccessBy(this O)(string anUuid) { 
    if (anUuid.isUUID) this.lastAccessBy(UUID(anUuid)); 
    else _lastAccessBy = NULLUUID;
    return cast(O)this; }

  ///	Entity has only one version. Version handling starts with EntityVersion	
  mixin(OProperty!("bool", "hasVersions"));
  O hasVersions(this O)(string newValue) {
    this.hasVersions(newValue == "true");
    return cast(O)this;
  }
  ///	entity has only one language. Language handling starts with EntityLanguage	
  mixin(OProperty!("bool", "hasLanguages"));
  O hasLanguages(this O)(string newValue) {
    this.hasLanguages(newValue == "true");
    return cast(O)this; }

  ///	Date and time when the entity is locked.	
  mixin(OProperty!("bool", "isLocked"));
  O isLocked(this O)(string newValue) {
    this.isLocked(newValue == "true");
    return cast(O)this; }
  ///	Date and time when the entity was locked.	
  mixin(OProperty!("long", "lockedOn"));
  O lockedOn(this O)(SysTime aTime) {
    this.lockedOn(toTimestamp(aTime));
    return cast(O)this; }
  O lockedOn(this O)(string aTime) {
    this.lockedOn(to!long(aTime));
    return cast(O)this; }

  ///	Unique identifier of the user who modified the entity.
  mixin(OProperty!("UUID", "lockedBy"));
  O lockedBy(this O)(string anUuid) { 
    this.lockedBy(UUID(anUuid)); 
    return cast(O)this; }

  ///	Date and time when the entity is deleted.	
  mixin(OProperty!("bool", "isDeleted"));
  O isDeleted(this O)(string newValue) {
    this.isDeleted(newValue == "true");
    return cast(O)this; }
  
  ///	Date and time when the entity was locked.	
  mixin(OProperty!("long", "deletedOn"));
  O deletedOn(this O)(SysTime aTime) {
    this.deletedOn(toTimestamp(aTime));
    return cast(O)this; }
  O deletedOn(this O)(string aTime) {
    this.deletedOn(to!long(aTime));
    return cast(O)this; }

  ///	Unique identifier of the user who deleted the entity.
  mixin(OProperty!("UUID", "deletedBy"));
  O deletedBy(this O)(string anUuid) { 
    this.deletedBy(UUID(anUuid)); 
    return cast(O)this; }
 
  override STRINGAA selector(STRINGAA parameters) {
    STRINGAA results;

    auto foundId = parameters.get("entity_id", parameters.get("id", ""));
    if (foundId.length > 0) results["id"] = foundId;               
    auto foundName = parameters.get("entity_name", parameters.get("name", ""));
    if (foundName.length > 0) results["name"] = foundName;               

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

    foreach(fName; fieldNames) {
      auto requestKey = "entity_"~fName;
      if (auto boolValue = cast(DBooleanValue)values[fName]) {
        boolValue.value(requestKey in requestValues ? true : false);
      }
      else {
        if (requestKey in requestValues) {
          this[fName] = requestValues[requestKey];
        }
      }
    }
  }

  // Converts entity property to string, which is HTML compatible
  override string opIndex(string key) {
    super.opIndex(key);

    switch(key) {
      case "registerPath": return this.registerPath;
      case "id": return this.id.toString;
      case "etag": return to!string(this.etag);
      case "name": return this.name;
      case "display": return this.display;
      case "createdOn": return to!string(this.createdOn); 
      case "createdBy": return this.createdBy.toString; 
      case "modifiedOn": return to!string(this.modifiedOn); 
      case "modifiedBy": return this.modifiedBy.toString; 
      case "lastAccessedOn": return to!string(this.lastAccessedOn); 
      case "lastAccessBy": return this.lastAccessBy.toString; 
      case "description": return this.description;
      case "isLocked": return this.isLocked ? "true" : "false";
      case "lockedOn": return to!string(this.lockedOn);
      case "lockedBy": return this.lockedBy.toString; 
      case "isDeleted": return this.isDeleted ? "true" : "false";
      case "deletedOn": return to!string(this.deletedOn);
      case "deletedBy": return this.deletedBy.toString; 
      case "versionNumber": return to!string(this.versionNumber);
      case "versionDisplay": return this.versionDisplay;
      case "versionMode": return this.versionMode;
/*       case "versionOn": return to!string(this.versionOn);
      case "versionBy": return to!string(this.versionBy); */
      case "versionDescription": return this.versionDescription;
      default:
        //if (key in attributes) { return attributes[key].StringData; }
        if (autvoid value = values[key]) { return value.toString; }
        auto keys = key.split(".");
        if (keys.length > 1) {
          if (auto subValue = values[keys[0]]) {
            if (auto entityValue = cast(DEntityValue)subValue) {
              return entityValue.value[keys[1..$].join(".")];
            }
            if (auto elementValue = cast(DElementValue)subValue) {
              return elementValue.value[keys[1..$].join(".")];
            }
          }
        }
        return null;
    }      
  }

  // X[index] = (string)value 
  alias opIndexAssign = DElement.opIndexAssign;
  override void opIndexAssign(string value, string key) {
    super.opIndexAssign(value, key);

    switch(key) {
      case "id": this.id(value); break;
      case "etag": this.etag(value); break;
      case "name": this.name(value); break;
      case "display": this.display(value); break;
      case "createdOn": this.createdOn(value); break;
      case "createdBy": this.createdBy(value); break;
      case "modifiedOn": this.modifiedOn(value); break; 
      case "modifiedBy": this.modifiedBy(value); break; 
      case "lastAccessedOn": this.lastAccessedOn(value); break; 
      case "lastAccessBy": this.lastAccessBy(value); break; 
      case "description": this.description(value); break;
      case "isLocked": this.isLocked(value); break;
      case "lockedOn": this.lockedOn(value); break;
      case "lockedBy": this.lockedBy(value); break; 
      case "isDeleted": this.isDeleted(value); break;
      case "deletedOn": this.deletedOn(value); break;
      case "deletedBy": this.deletedBy(value); break; 
      case "hasVersions": this.hasVersions(value); break;
      case "hasLanguages": this.hasLanguages(value); break;
      case "versionNumber": this.versionNumber(value); break;
      case "versionDisplay": this.versionDisplay(value); break;
      case "versionMode": this.versionMode(value); break;
/*       case "versionOn": this.versionOn(value); break;
      case "versionBy": this.versionBy(value); break; */
      case "versionDescription": this.versionDescription(value); break;
      default:
        // if (key in attributes) attributes[key].value(value); 
        if (values.containsKey(key)) { values[key] = value; }
        else {
          auto keys = key.split(".");
          if (keys.length > 1) {
            if (auto subValue = values[keys[0]]) {
              if (auto entityValue = cast(DEntityValue)subValue) {
                entityValue.value[keys[1..$].join(".")] = value;
              }
              if (auto elementValue = cast(DElementValue)subValue) {
                elementValue.value[keys[1..$].join(".")] = value;
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

    switch(key) {
      case "id": this.id(value); break;
      case "createdBy": this.createdBy(value); break;
      case "modifiedBy": this.modifiedBy(value); break; 
      case "lastAccessBy": this.lastAccessBy(value); break; 
      case "lockedBy": this.lockedBy(value); break; 
      case "deletedBy": this.deletedBy(value); break; 
/*       case "versionBy": this.versionBy(value); break; */
      default:
        /* if (key in attributes) {
          if (auto att = cast(DOOPUUIDAttribute)attributes[key]) att.value(value); 
        }  */
        values[key] = value;
        break;
    }      
  }

  override void opIndexAssign(long value, string key) {
    super.opIndexAssign( value, key); 

    switch(key) {
      case "createdOn": this.createdOn(value); break;
      case "modifiedOn": this.modifiedOn(value); break; 
      case "lastAccessedOn": this.lastAccessedOn(value); break; 
      case "lockedOn": this.lockedOn(value); break;
      case "deletedOn": this.deletedOn(value); break;
/*       case "versionOn": this.versionOn(value); break; */
      default:
        values[key] = value;
        break;
    }      
  } 

  override void opIndexAssign(bool value, string key) {
    super.opIndexAssign(value, key);

    switch(key) {
      case "isLocked": this.isLocked(value); break;
      case "isDeleted": this.isDeleted(value); break;
      case "hasVersions": this.hasVersions(value); break;      
      default:
        /* if (key in attributes) {
          if (auto att = cast(DOOPBooleanAttribute)attributes[key]) att.value(value); 
        }  */
        values[key] = value;
        break;
    }      
  }

  // Set field(key) if type Entity
  void opIndexAssign(DEntity value, string key) {
    switch(key) {
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
      targetOfCopy.fromJson(this.toJson);
      return targetOfCopy; }
    return null; }
  DEntity copyFrom(DEntity targetOfCopy) {
    if (targetOfCopy) {
      fromJson(targetOfCopy.toJson);
    }
    return this;
  } */

  override void fromJson(Json aJson) {
    if (aJson.isEmpty) { return; }
    super.fromJson(aJson);

    foreach (keyvalue; aJson.byKeyValue) {
      auto k = keyvalue.key;
      auto v = keyvalue.value;
      switch(k) {
        case "pool": this.pool(v.get!string); break;
        case "id": this.id(v.get!string); break;
        case "etag": this.etag(v.get!long); break;
        case "name": this.name(v.get!string); break;
        case "display": this.display(v.get!string); break;
        case "createdOn": this.createdOn(v.get!long); break;
        case "createdBy": this.createdBy(v.get!string); break;
        case "modifiedOn": this.modifiedOn(v.get!long); break;
        case "modifiedBy": this.modifiedBy(v.get!string); break;
        case "description": this.description(v.get!string); break;
        case "isLocked": this.isLocked(v.get!bool); break;
        case "lockedOn": this.lockedOn(v.get!long); break;
        case "lockedBy": this.lockedBy(v.get!string); break;
        case "isDeleted": this.isDeleted(v.get!bool); break;
        case "deletedOn": this.deletedOn(v.get!long); break;
        case "deletedBy": this.deletedBy(v.get!string); break;
/*         case "model": 
          auto id = v.get!string;
          if (id.isUUID) this.model(OOPModel(UUID(id)));
          else this.model(OOPModel(id));
          break; */
        case "hasVersions": this.hasVersions(v.get!bool); break;
        case "hasLanguages": this.hasLanguages(v.get!bool); break;
        case "parameters": 
          STRINGAA values;
          foreach (kv; v.byKeyValue) {
            values[kv.key] = kv.value.get!string;
          }
          this.parameters(values);
          break;
        case "config": this.config(v); break;
        case "versionNumber": this.versionNumber(v.get!long); break;
        case "versionDisplay": this.versionDisplay(v.get!string); break;
        case "versionMode": this.versionMode(v.get!string); break;
/*         case "versionOn": this.versionOn(v.get!long); break;
        case "versionBy": this.versionBy(v.get!string); break; */
        case "versionDescription": this.versionDescription(v.get!string); break;
        default: 
          /* if (k in _attributes) {
            // debug writeln("Found ", k);
            _attributes[k].value(v); 
          } */

          this.values[k].value(v);
          break;
      }            
    }
  }

  override Json toJson(string[] showFields = null, string[] hideFields = null) {
    auto result = super.toJson(showFields, hideFields);
    
    if (showFields.isEmpty && hideFields.isEmpty) {
      result = result.set(
        [ "registerPath": this.registerPath,
          "id": this.id.toString,
          "name": this.name,
          "display": this.display,
          "createdOn": this.createdOn,
          "createdBy": this.createdBy.toString,
          "modifiedOn": this.modifiedOn,
          "modifiedBy": this.modifiedBy.toString,
          "lastAccessedOn": this.lastAccessedOn,
          "lastAccessBy": this.lastAccessBy.toString,
          "description": this.description,
          "isLocked": this.isLocked,
          "lockedOn": this.lockedOn,
          "lockedBy": this.lockedBy.toString,
          "isDeleted": this.isDeleted,
          "deletedOn": this.deletedOn,
          "deletedBy": this.deletedBy.toString
        ]);

      /* if (this.model) {
        if (this.model.id.isNull) result["model"] = this.model.name;
        else result["model"] = this.model.id.toString;
      } */
      result = result.set(
        [ "hasVersions": this.hasVersions,
          "hasLanguages": this.hasLanguages]);

      auto parameterValues = Json.emptyObject.set(this.parameters);                       
      result["parameters"] = parameterValues;

      result["config"] = this.config;     

/*       foreach(k; _attributes.byKey) {
        if (!hideFields.exist(k)) result[k] = _attributes[k].jsonValue;
      } */
      values.keys
        .each!(key => result[key] = this.values[key].toJson);

    }
    else if (showFields.isEmpty && !hideFields.isEmpty) {
      if (!hideFields.exist("registerPath")) result["registerPath"] = this.registerPath;
      if (!hideFields.exist("id")) result["id"] = this.id.toString;
      if (!hideFields.exist("name")) result["name"] = this.name;
      if (!hideFields.exist("display")) result["display"] = this.display;
      if (!hideFields.exist("createdOn")) result["createdOn"] = this.createdOn;
      if (!hideFields.exist("createdBy")) result["createdBy"] = this.createdBy.toString;
      if (!hideFields.exist("modifiedOn")) result["modifiedOn"] = this.modifiedOn;
      if (!hideFields.exist("modifiedBy")) result["modifiedBy"] = this.modifiedBy.toString;
      if (!hideFields.exist("lastAccessedOn")) result["lastAccessedOn"] = this.lastAccessedOn;
      if (!hideFields.exist("lastAccessBy")) result["lastAccessBy"] = this.lastAccessBy.toString;
      if (!hideFields.exist("description")) result["description"] = this.description;
      if (!hideFields.exist("isLocked")) result["isLocked"] = this.isLocked;
      if (!hideFields.exist("lockedOn")) result["lockedOn"] = this.lockedOn;
      if (!hideFields.exist("lockedBy")) result["lockedBy"] = this.lockedBy.toString;
      if (!hideFields.exist("isDeleted")) result["isDeleted"] = this.isDeleted;
      if (!hideFields.exist("deletedOn")) result["deletedOn"] = this.deletedOn;
      if (!hideFields.exist("deletedBy")) result["deletedBy"] = this.deletedBy.toString;
      /* if (!hideFields.exist("model")) {
        if (this.model) {
          if (this.model.id.isNull) result["model"] = this.model.name;
          else result["model"] = this.model.id.toString;
        }
      } */
      if (!hideFields.exist("hasVersions")) result["hasVersions"] = this.hasVersions;
      if (!hideFields.exist("hasLanguages")) result["hasLanguages"] = this.hasLanguages;
      if (!hideFields.exist("parameters")) {       
        auto parameterValues = Json.emptyObject;
        foreach (kv; this.parameters.byKeyValue) {
          parameterValues[kv.key] = this.parameters[kv.value];                
        } 
        result["parameters"] = parameterValues;
      }
      if (!hideFields.exist("config")) result["config"] = this.config;     
    }
    else {
      if ((showFields.exist("registerPath")) && (!hideFields.exist("registerPath"))) result["registerPath"] = this.registerPath;
      if ((showFields.exist("id")) && (!hideFields.exist("id"))) result["id"] = this.id.toString;
      if ((showFields.exist("name")) && (!hideFields.exist("name"))) result["name"] = this.name;
      if ((showFields.exist("display")) && (!hideFields.exist("display"))) result["display"] = this.display;
      if ((showFields.exist("createdOn")) && (!hideFields.exist("createdOn"))) result["createdOn"] = this.createdOn;
      if ((showFields.exist("createdBy")) && (!hideFields.exist("createdBy"))) result["createdBy"] = this.createdBy.toString;
      if ((showFields.exist("modifiedOn")) && (!hideFields.exist("modifiedOn"))) result["modifiedOn"] = this.modifiedOn;
      if ((showFields.exist("modifiedBy")) && (!hideFields.exist("modifiedBy"))) result["modifiedBy"] = this.modifiedBy.toString;
      if ((showFields.exist("lastAccessedOn")) && (!hideFields.exist("lastAccessedOn"))) result["lastAccessedOn"] = this.lastAccessedOn;
      if ((showFields.exist("lastAccessBy")) && (!hideFields.exist("lastAccessBy"))) result["lastAccessBy"] = this.lastAccessBy.toString;
      if ((showFields.exist("description")) && (!hideFields.exist("description"))) result["description"] = this.description;
      if ((showFields.exist("isLocked")) && (!hideFields.exist("isLocked"))) result["isLocked"] = this.isLocked;
      if ((showFields.exist("lockedOn")) && (!hideFields.exist("lockedOn"))) result["lockedOn"] = this.lockedOn;
      if ((showFields.exist("lockedBy")) && (!hideFields.exist("lockedBy"))) result["lockedBy"] = this.lockedBy.toString;
      if ((showFields.exist("isDeleted")) && (!hideFields.exist("isDeleted"))) result["isDeleted"] = this.isDeleted;
      if ((showFields.exist("deletedOn")) && (!hideFields.exist("deletedOn"))) result["deletedOn"] = this.deletedOn;
      if ((showFields.exist("deletedBy")) && (!hideFields.exist("deletedBy"))) result["deletedBy"] = this.deletedBy.toString;
      /* if ((showFields.exist("model")) && (!hideFields.exist("model"))) {
        if (this.model) {
          if (this.model.id.isNull) result["model"] = this.model.name;
          else result["model"] = this.model.id.toString;
        }
      } */
      if ((showFields.exist("hasVersions")) && (!hideFields.exist("hasVersions"))) result["hasVersions"] = this.hasVersions;
      if ((showFields.exist("hasLanguages")) && (!hideFields.exist("hasLanguages"))) result["hasLanguages"] = this.hasLanguages;
      if ((showFields.exist("parameters")) && (!hideFields.exist("parameters"))) {       
        result["parameters"] = Json.emptyObject.set(this.parameters);   ;
      }
      if ((showFields.exist("config")) && (!hideFields.exist("config"))) result["config"] = this.config;
    }

    if (showFields.isEmpty) {
      foreach(k; this.values.keys) {
        if (!hideFields.exist(k)) result[k] = values[k].toJson;
      } 
    }
    else {
      foreach(k; this.values.keys) {
        if ((showFields.exist(k)) && (!hideFields.exist(k))) result[k] = values[k].toJson;
      } 
    }
    
    return result;
  }

  void load() {
    /* if (collection) fromJson(collection.findOne(id).toJson); */ }
  version(test_uim_models) { unittest {
      // TODO: Add Test
    }
  }

  DEntity save() {
    /* if (collection) {
      if (collection.findOne(this.id)) collection.updateOne(this); 
      else collection.insertOne(this); 
    } */
    
    return this;
  }
  version(test_uim_models) { unittest {
      // TODO: Add Test
    }
  }

  void remove(bool allVersions = false) {
    /* if (collection)
      collection.removeMany(this, allVersions); */ }

}
auto Entity() { return new DEntity; }
auto Entity(Json json) { return new DEntity(json); }

///
unittest {
  /* assert(Entity);

  assert(Entity.name("entity").name == "entity");
  
  auto entity = Entity;
  auto entityValue = EntityValue;
  entityValue.value = Entity.name("TestEntity");
  entity.values["entity"] = entityValue;

  assert(entity["entity.name"] == "TestEntity");
  assert(entity["entity.name"] != "_");

  entity["entity.name"] = "newEntityName";
  assert(entity["entity.name"] == "newEntityName");

  entityValue = cast(DEntityValue)entity.values["entity"];
  // writeln(entityValue.value["name"]);
  assert(entityValue.value["name"] == "newEntityName");

  auto elementValue = ElementValue; */
  /* elementValue.name("TestElement");
  entity.values["element"] = entityValue;

  assert(entity["element.name"] == "TestElement");
  assert(entity["element.name"] != "_");

  entity["element.name"] = "newElementName";
  assert(entity["element.name"] == "newElementName");

  elementValue = cast(DElementValue)entity.values["element"];
  assert(elementValue.value["name"] == "newElementName");  */


/*
  assert(Entity.id(randomuuid)
  assert(Entity.etag(totimestamp(now))
  assert(Entity.name(this.id.tostring) 
  assert(Entity.createdon(now)
  assert(Entity.lastaccessedon(createdon)
  assert(Entity.modifiedon(createdon)
  assert(Entity.hasversions(false)
  assert(Entity.haslanguages(false)
  assert(Entity.config(json.emptyobject)
  assert(Entity.values(values)
  assert(Entity.versionon(this.createdon)
  assert(Entity.versionnumber(1l) // allways starts with version 1
  assert(Entity.versionby(this.createdby); 

registerPath": return this.registerPath;
      case "id": return this.id.toString;
      case "etag": return to!string(this.etag);
      case "name": return this.name;
      case "display": return this.display;
      case "createdOn": return to!string(this.createdOn); 
      case "createdBy": return this.createdBy.toString; 
      case "modifiedOn": return to!string(this.modifiedOn); 
      case "modifiedBy": return this.modifiedBy.toString; 
      case "lastAccessedOn": return to!string(this.lastAccessedOn); 
      case "lastAccessBy": return this.lastAccessBy.toString; 
      case "description": return this.description;
      case "isLocked": return this.isLocked ? "true" : "false";
      case "lockedOn": return to!string(this.lockedOn);
      case "lockedBy": return this.lockedBy.toString; 
      case "isDeleted": return this.isDeleted ? "true" : "false";
      case "deletedOn": return to!string(this.deletedOn);
      case "deletedBy": return this.deletedBy.toString; 
      case "versionNumber": return to!string(this.versionNumber);
      case "versionDisplay": return this.versionDisplay;
      case "versionMode": return this.versionMode;
      case "versionOn": return to!string(this.versionOn);
      case "versionBy": return to!string(this.versionBy);
      case "versionDescription": return this.versionDescription;
      default:
        //if (key in attributes) { return attributes[key].StringData; }
        if (values.hasValue(key)) { return values[key].toString; }
        return null;
    }      
*/
}
