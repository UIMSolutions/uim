/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.elements.element;

import uim.models;

@safe:
class DElement : IElement {
  // // static namespace = moduleName!DElement;

  // Constructors
  this() { initialize; }

  this(string myName) { 
    this().name(myName); }

  this(Json aJson) { 
    this();    
    if (aJson != Json(null)) this.fromJson(aJson); }

  void initialize(Json configSettings = Json(null)) {
    this  
      .values(StringValueMap);

    this  
      .requestPrefix("element_");
  }

  mixin(OProperty!("DStringValueMap", "values"));
  mixin ValueMapWrapper;

  mixin(OProperty!("bool", "isStatic"));

  mixin(OProperty!("string", "className"));
  /// 
  unittest {
    auto element = new DElement;
    element.className = "newClassName";
    assert(element.className == "newClassName");
    assert(element.className != "noClassName");

    assert(element.className("otherClassName").className == "otherClassName");
    assert(element.className != "noClassName");
  }

  mixin(OProperty!("string", "registerPath"));
  /// 
  unittest {
    auto element = new DElement;
    element.registerPath = "newRegisterPath";
    assert(element.registerPath == "newRegisterPath");
    assert(element.registerPath != "noRegisterPath");

    assert(element.registerPath("otherRegisterPath").registerPath == "otherRegisterPath");
    assert(element.registerPath != "noRegisterPath");
  }

  mixin(OProperty!("string", "requestPrefix")); 
  /// 
  unittest {
    auto element = new DElement;
    element.requestPrefix = "newRequestPrefix";
    assert(element.requestPrefix == "newRequestPrefix");
    assert(element.requestPrefix != "noRequestPrefix");

    assert(element.requestPrefix("otherRequestPrefix").requestPrefix == "otherRequestPrefix");
    assert(element.requestPrefix != "noRequestPrefix");
  }

  // Every element can have a name like an identifier. 
  string _name;
  O name(this O)(string  newName) { _name = newName.strip.replace(" ", "_"); return cast(O)this; }
  string name() { return _name; }
  version(test_uim_models) {
    unittest {
      assert(Entity.name("name1").name == "name1");
      assert(Entity.name("name1").name("name2").name == "name2");
      assert(Entity.name("name name").name == "name_name");
    }
  }

  mixin(OProperty!("STRINGAA", "parameters"));

/*   // Display of entity 
  mixin(OProperty!("string", "display"));

  //	Description about the entity and more
  mixin(OProperty!("string", "description")); */
    
  STRINGAA selector(STRINGAA parameters) {
    STRINGAA results;

    foreach(key, val; parameters) {
      if (key.indexOf(requestPrefix) == 0) {
        results[key.replace(requestPrefix, "")] = val;
      } else {
        results[key] = val;
      }
    }

    return results;
  }
  ///
  unittest {
    auto element = new DElement;
    assert(element.selector(["x":"y", "element_id": "1234"]) == ["id":"1234", "x":"y"]);
  }

  // Read data from STRINGAA
  void readFromStringAA(STRINGAA reqParameters, bool usePrefix = false) {
    foreach(k, v; reqParameters) this[k] = v; 
  }

  // Read data from request
  void readFromRequest(STRINGAA requestValues, bool usePrefix = true) {
    auto myData = selector(requestValues);
    foreach(key, value; myData) {
      this[key] = value;
    } 
  }

  // Returns data in string format (HTML compatible)
  string opIndex(string key) {
    switch(key) {
      case "className": return className;
      case "requestPrefix": return requestPrefix;
      case "registerPath": return registerPath;
      default:
        if (auto value = valueOfKey(key)) { 
          return value.toString;
        } break;      
    }
    return null;
  }

  // Set data 
  void opIndexAssign(DValue newValue, string key) {
    if (!isStatic) { // can add new values and change datatypes
      values[key] = newValue;  
    } else { // Not dynamic
      if (auto myValue = valueOfKey(key)) {
        myValue.value(newValue.toJson);
      }
    }
  }
  ///
  unittest {
    auto value = (new DStringAttribute).createValue;
    value.set("aValue");
    assert(value.toString == "aValue");

    auto element = new DElement;
    element["test"] = value;

    assert(element["test"] == "aValue");
  } 

  // Set data 
  void opIndexAssign(Json newValue, string key) {
    if (auto myValue = valueOfKey(key)) {
      // TODO myValue.set(newValue);
      return;
    }

/*     if (!isStatic) { // can add new values
      switch(newValue.type) {
        case Json.Type.string: 
          this.value(newValue.get!string); 
        break;

              auto myValue = StringAttribute.createValue;
      myValue.set(newValue);
      values[key] = myValue;
    }
 */  }
  ///
  unittest {
    auto element = new DElement;
    element.addValues(["test":StringAttribute]);
    element["test"] = "something";
    assert(element["test"] == "something");
    assert(element["test"] != "a thing");
  } 

  // Set data 
  void opIndexAssign(string newValue, string key) {
    switch(key) {
      case "className": this.className(newValue); break;
      case "name": this.name(newValue); break;
      case "requestPrefix": this.requestPrefix(newValue); break;
      case "registerPath": this.registerPath(newValue); break;
      default:
        if (auto myValue = valueOfKey(key)) {
          myValue.set(newValue);
          return;
        }

        if (!isStatic) { // can add new values
          auto myValue = StringAttribute.createValue;
          myValue.set(newValue);
          values[key] = myValue;
        } 
        break;
    }
  }
  ///
  unittest {
    auto element = new DElement;
    element.addValues(["test":StringAttribute]);
    element["test"] = "something";
    assert(element["test"] == "something");
    assert(element["test"] != "a thing");
  } 

  DValue valueOfKey(string key) {
    if (auto myValue = values[key]) {
      return myValue;
    }

    if (auto keys = key.split(".")) {
      if (keys.length == 1) { return values[key]; }

      DValue myValue = values[keys[0]];
      if (auto myElementValue = cast(DElementValue)myValue) {
        myValue = myElementValue.value.valueOfKey(keys[1..].join("."));
      }
      return myValue;
    }

    return null;
  }
  ///
  unittest{
    auto element2 = new DElement;
    element2.addValues(["level2": StringAttribute]);
    element2["level2"] = "valueLevel2";

    auto value2 = new DElementValue;
    value2.set(element2);

    auto element1 = new DElement;
    element1["level1"] = value2;

    assert(element1["level1.level2"] == "valueLevel2");
  }

  // Set UUID value
  void opIndexAssign(UUID value, string key) {
    if (auto myValue = cast(DUUIDValue)valueOfKey(key)) { 
      // values[key] exists and value of DUUIDValue
      myValue.value = value;
    }
  }

  // Set long value
  void opIndexAssign(long value, string key) {
    if (auto myValue = cast(DLongValue)valueOfKey(key)) { 
      // values[key] exists and value of DLongValue
      myValue.value = value;
    }     
  } 

  // Set bool value
  void opIndexAssign(bool value, string key) {
    if (auto myValue = cast(DBooleanValue)valueOfKey(key)) { 
      // values[key] exists and value of DBooleanValue
      myValue.value = value;
    }    
  }

  // Set field(key) if type Entity
  void opIndexAssign(DElement value, string key) {
    if (auto myValue = cast(DElementValue)valueOfKey(key)) { 
      // values[key] exists and value of DElementValue
      myValue.value = value;
    }   
  }

  DElement create() { return new DElement; }
  DElement create(Json data) { auto myElement = create; myElement.fromJson(data); return myElement; }

  DElement clone() { return create(toJson); }
  DElement clone(Json data) { auto myElement = create(toJson); myElement.fromJson(data); return myElement; }
  
  DElement copyTo(DElement targetOfCopy) {
    if (targetOfCopy) {
      targetOfCopy.fromJson(this.toJson);
    }
    return targetOfCopy; }
  DElement copyFrom(DElement targetOfCopy) {
    if (targetOfCopy) {
      fromJson(targetOfCopy.toJson);
    }
    return this;
  } 

  Bson toBson() { return Bson(toJson); }

  void fromJson(Json aJson) {
    if (aJson.isEmpty) return;
    
    foreach (keyvalue; aJson.byKeyValue) {
      auto k = keyvalue.key;
      auto v = keyvalue.value;
      switch(k) {
        case "className": this.className(v.get!string); break;
        case "name": this.name(v.get!string); break;
        case "requestPrefix": this.requestPrefix(v.get!string); break;
        case "registerPath": this.registerPath(v.get!string); break;
        default: 
          this.values[k].value(v);
          break;
      }            
    }
  }

  Json toJson(string[] showFields = null, string[] hideFields = null) {
    auto result = Json.emptyObject;
    
    result["name"] = this.name;

    values.keys.each!(k => result[k] = this.values[k].toJson);
  
    return result;
  }

  override string toString() {
    return toJson.toString;
  }
}
auto Element() { return new DElement; }
auto Element(string name) { return new DElement(name); }
auto Element(Json json) { return new DElement(json); }

version(test_uim_models) { unittest {
  assert(Element);
  assert(Element.name("test").name == "test");
  assert(Element.name("testName").name == "testname");
}}

