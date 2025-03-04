/****************************************************************************************************************
* Copyright: © 2018-2025 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.oop.mixins.properties.property;

import std.string;

template PropertyDefinition(string datatype, string fieldName, string propertyName, bool get = true, bool set = true, string defaultValue = null, string condition = null) {
  const char[] fieldDefinition = datatype~" "~fieldName~(defaultValue.length>0?"="~defaultValue:"")~"; ";
  const char[] getDefinition = get ? "@safe @property "~datatype~" "~propertyName~"() { return "~fieldName~"; } ": "";
  const char[] setDefinition = set ? "@safe @property O "~propertyName~"(this O)("~datatype~" value) { "~(condition.length>0?"if ("~condition~")": "")~fieldName~"=value; return cast(O)this; } ": "";
  const char[] PropertyDefinition = fieldDefinition~getDefinition~setDefinition;
}

template PropertyDefinition(string datatype, string propertyName, bool get = true, bool set = true, string defaultValue = null, string condition = null) {
  const char[] fieldDefinition = datatype~" _"~propertyName~(defaultValue.length>0?"="~defaultValue:"")~"; ";
  const char[] getDefinition = get ? "@safe @property "~datatype~" "~propertyName~"() { return _"~propertyName~"; } ": "";
  const char[] setDefinition = set ? "@safe @property O "~propertyName~"(this O)("~datatype~" value) { "~(condition.length>0?"if ("~condition~")": "")~"_"~propertyName~"=value; return cast(O)this; } ": "";
  const char[] PropertyDefinition = fieldDefinition~getDefinition~setDefinition;
}

/*

template OProperty(string dataType, string propertyName, string defaultValue = null, string get = null, string set = null) {
  const char[] getFkt = (get.length > 0) ? get : "return _"~propertyName~";";
  const char[] setFkt = (set.length > 0) ? set : "_"~propertyName~" = newValue; return cast(O)this;";
  
  const char[] OProperty = "
  protected "~dataType~" _"~propertyName~(defaultValue.length > 0 ? " = "~defaultValue : "")~";
  protected "~dataType~" _default"~propertyName~(defaultValue.length > 0 ? " = "~defaultValue : "")~";
  
  auto "~propertyName~"Default() { return _default"~propertyName~"; }
  O "~propertyName~"Reset(this O)() { _"~propertyName~" = _default"~propertyName~"; }
  O "~propertyName~"Default(this O)("~dataType~" v) { _default"~propertyName~" = v; }
  bool "~propertyName~"IsDefault() { return (_"~propertyName~" == _default"~propertyName~"); }

    @property "~dataType~" "~propertyName~"() { "~getFkt~" }
    @property O "~propertyName~"(this O)("~dataType~" newValue) { "~setFkt~" }";
}
*/

auto PROPERTYPREFIX(string dataType, string propertyName, string defaultValue = null) {
  return "
protected "~dataType~" _"~propertyName~(defaultValue.length > 0 ? " = "~defaultValue : "")~";
protected "~dataType~" _default"~propertyName~(defaultValue.length > 0 ? " = "~defaultValue : "")~";

auto "~propertyName~"Default() { return _default"~propertyName~"; }
void before"~propertyName.capitalize~" { }
void after"~propertyName.capitalize~" { }
void "~propertyName~"Reset() { _"~propertyName~" = _default"~propertyName~"; }
void "~propertyName~"Default("~dataType~" value) { _default"~propertyName~" = value; }
bool "~propertyName~"IsDefault() { return (_"~propertyName~" == _default"~propertyName~"); }";
}

template OProperty_set(string dataType, string propertyName, string defaultValue = null) {
  const char[] OProperty_set = PROPERTYPREFIX(dataType, propertyName, defaultValue) ~"
@property O "~propertyName~"(this O)("~dataType~" value) { _"~propertyName~" = value; }";
}

string propertySet(string dataType, string propertyName, string beforeSetCode = "", string afterSetCode = "") {
  auto myPropertyName = propertyName.capitalize;
  return 
  `void _beforeSet`~myPropertyName~`() { `~beforeSetCode~` }
void _afterSet`~myPropertyName~`() { `~afterSetCode~` }
void _set`~myPropertyName~`(`~dataType~` new`~myPropertyName~`) { 
  _beforeSet`~myPropertyName~`(); 
  _`~propertyName~` = new`~myPropertyName~`; 
  _afterSet`~myPropertyName~`(); 
}
@property O `~propertyName~`(this O)(`~dataType~` newValue) { _set`~myPropertyName~`(newValue); return cast(O)this; }`;
}
version(test_uim_oop) { unittest {
  /* assert(propertySet("string", "prop") ==
`void _beforeSetProp() {  }
void _afterSetProp() {  }
void _setProp(string newProp) { 
  _beforeSetProp(); 
  _prop = newProp; 
  _afterSetProp;
}
@property O prop(this O)(string newValue) { _setProp(newValue); return cast(O)this; }`
  ); */
}}

string propertyGet(string dataType, string propertyName, string beforeGetCode = "") {
  auto myPropertyName = propertyName.capitalize;
  return 
`void beforeGet`~myPropertyName~`() { `~beforeGetCode~` }
`~dataType~` get`~myPropertyName~`() { beforeGet`~myPropertyName~`(); 
  return _`~propertyName~`; 
}
@property `~dataType~` `~propertyName~`() { return get`~myPropertyName~`(); }`;
}
version(test_uim_oop) { unittest {
  assert(propertyGet("string", "test") ==
`void beforeGetTest() {  }
string getTest() { beforeGetTest(); 
  return _test; 
}
@property string test() { return getTest(); }`
  );
}}

// Only Getter
/* template OProperty_get(string dataType, string propertyName, string defaultValue = null) {
  const char[] OProperty_get = PROPERTYPREFIX(dataType, propertyName, defaultValue) ~"
@property "~dataType~" "~propertyName~"() { return _"~propertyName~"; }";
} */

template OPropertyGet(string dataType, string propertyName, string defaultValue = null, string beforeSetCode = "") {
  const char[] OPropertyGet = "protected "~dataType~" _"~propertyName~(defaultValue.length > 0 ? " = "~defaultValue : "")~";"~
    propertyGet(dataType, propertyName, beforeSetCode);
}

// Getter and Setter
template OProperty(string dataType, string propertyName, string defaultValue = null, bool getter = true, bool   setter = true, string beforeSetCode = "", string afterSetCode = "", string beforeGetCode = "") {
  const char[] myPropertyName = propertyName.capitalize;
  const char[] getFkt = getter ? propertyGet(dataType, propertyName, beforeGetCode) : " ";
  const char[] setFkt = setter ? propertySet(dataType, propertyName, beforeSetCode, afterSetCode) : " "; 
  
  const char[] OProperty = "
  protected "~dataType~" _"~propertyName~(defaultValue.length > 0 ? " = "~defaultValue : "")~";"
  ~getFkt~setFkt;
}  
version(test_uim_oop) { unittest {
  class DTest {mixin(OProperty!("string", "name", "`someThing`"));}
  assert((new DTest).name == "someThing");
  assert((new DTest).name("test").name == "test");
  assert((new DTest).name("test").name("test2").name == "test2");
}}
// mixins for Template based properties

template TProperty(string dataType, string propertyName, string defaultValue = null, string get = null, string set = null) {
  const char[] getFkt = (get.length > 0) ? get : "return _"~propertyName~";";
  const char[] setFkt = (set.length > 0) ? set : "_"~propertyName~" = newValue;";
  
  const char[] TProperty = "
  protected "~dataType~" _"~propertyName~(defaultValue.length > 0 ? " = "~defaultValue : "")~";
    
  @property "~dataType~" "~propertyName~"() { "~getFkt~" }
  @property void "~propertyName~"("~dataType~" newValue) { "~setFkt~" }";
}

template TPropertyAA(string keyDataType, string valueDataType, string propertyName, string defaultValue = null, string get = null, string set = null) {
  const char[] getFkt = (get.length > 0) ? get : "return _"~propertyName~";";
  const char[] setFkt = (set.length > 0) ? set : "_"~propertyName~" = newValue;";
  const char[] aaDataType = valueDataType~"["~keyDataType~"]";
  
  const char[] TPropertyAA = "
  protected "~aaDataType~" _"~propertyName~(defaultValue.length > 0 ? " = "~defaultValue : "")~";
  protected "~aaDataType~" _default"~propertyName~(defaultValue.length > 0 ? " = "~defaultValue : "")~";
  
  @safe @property "~aaDataType~" "~propertyName~"(this O)() { "~getFkt~" }
  @safe @property O "~propertyName~"(this O)("~aaDataType~" newValue) { "~setFkt~" return cast(O)this; }
  O "~propertyName~"(this O)("~keyDataType~" key, "~valueDataType~" value) { _"~propertyName~"[key] = value; return cast(O)this; }
  O "~propertyName~"Add(this O)("~aaDataType~" values) { foreach(k,v;values) _"~propertyName~"[k] = v; return cast(O)this; }";
}

// mixins for Extended Template based properties

template TXProperty_get(string dataType, string propertyName, string defaultValue = null, string get = null) {
  const char[] getFkt = (get.length > 0) ? get : "return _"~propertyName~";";

  const char[] TXProperty_get = "
  protected "~dataType~" _"~propertyName~(defaultValue.length > 0 ? " = "~defaultValue : "")~";
  protected "~dataType~" _default"~propertyName~(defaultValue.length > 0 ? " = "~defaultValue : "")~";
  
  O "~propertyName~"Reset(this O)() { _"~propertyName~" = _default"~propertyName~"; return cast(O)this;}
  auto "~propertyName~"Default() { return _default"~propertyName~"; }
  O "~propertyName~"Default(this O)("~dataType~" newValue) { _default"~propertyName~" = newValue; return cast(O)this; }
  bool "~propertyName~"IsDefault() { return (this._"~propertyName~" == _default"~propertyName~"); }

  @property "~dataType~" "~propertyName~"(this O)() { "~getFkt~" }";
}

template TXProperty(string dataType, string propertyName, string defaultValue = null, string get = null, string set = null) {
  const char[] getFkt = (get.length > 0) ? get : "return _"~propertyName~";";
  const char[] setFkt = (set.length > 0) ? set : "_"~propertyName~" ~= newValue;";
  
  const char[] TXProperty = "
  protected "~dataType~" _"~propertyName~(defaultValue.length > 0 ? " = "~defaultValue : "")~";
  protected "~dataType~" _default"~propertyName~(defaultValue.length > 0 ? " = "~defaultValue : "")~";
  
  O "~propertyName~"Reset(this O)() { _"~propertyName~" = _default"~propertyName~"; return cast(O)this;}
  auto "~propertyName~"Default() { return _default"~propertyName~"; }
  O "~propertyName~"Default(this O)("~dataType~" newValue) { _default"~propertyName~" = newValue; return cast(O)this; }
  bool "~propertyName~"IsDefault() { return (this._"~propertyName~" == _default"~propertyName~"); }

  @property "~dataType~" "~propertyName~"(this O)() { "~getFkt~" }
  @property O "~propertyName~"(this O)("~dataType~" newValue) { "~setFkt~" return cast(O)this; }";
}

version(test_uim_oop) { unittest {

}}

string iProperty(string dataType, string propertyName, bool get = true, bool set = true) {
  return   (get ? dataType~" "~propertyName~"();" : null) ~
      (set ? "void "~propertyName~"("~dataType~" newValue);" : null);
}
template IProperty(string dataType, string propertyName, bool get = true, bool set = true) {
  const char[] IProperty = iProperty(dataType, propertyName, get, set);
}