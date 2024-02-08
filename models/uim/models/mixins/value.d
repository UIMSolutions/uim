module uim.models.mixins.value;

import uim.models;
@safe:

auto valueGetter(string name, string datatype, string valueClass, string path) {
  string newPath = (path ? path : name);
  return `
    @property `~datatype~` `~name~`() {
      if (auto myValue = cast(`~valueClass~`)valueOfKey("`~newPath~`")) {
        return myValue.value;
      }
      
      return null;       
    }`;
}

auto valueSetter(string name, string datatype, string valueClass, string path) {
  string newPath = (path ? path : name);
  return `
    @property O `~name~`(this O)(`~datatype~` newValue) { 
      if (auto myValue = cast(`~valueClass~`)valueOfKey("`~newPath~`")) {
        myValue.value(newValue);
        return cast(O)this;
      }
      return cast(O)this;
    }`;
} 

string valueProperty(string datatype, string name, string path = null, string valueClass = "DStringValue") {
  auto newPath = (path ? path : name);
  return
    // Getter
    valueGetter(name, datatype, valueClass, newPath)~
    // Setter
    valueSetter(name, datatype, valueClass, newPath)~
    valueSetter(name, "Json", valueClass, newPath)~
    (datatype != "string" ? valueSetter(name, "string", valueClass, newPath) : "");
} 

template ValueProperty(string datatype, string name, string path = null, string valueClass = "DStringValue") {
  const char[] ValueProperty = valueProperty(datatype, name, path, valueClass);
} 

template StringValueProperty(string name, string path = null) {
  const char[] StringValueProperty = valueProperty("string", name, path, "DStringValue");
} 

template BooleanValueProperty(string name, string path = null) {
  const char[] BooleanValueProperty = valueProperty("bool", name, path, "DBooleanValue");
} 

template UUIDDataProperty(string name, string path = null) {
  const char[] newPath = (path ? path : name);
  const char[] UUIDDataProperty = `
    @property UUID `~name~`() {
      if (auto myValue = cast(DUUIDData)valueOfKey("`~(path ? path : name)~`")) {
        return myValue.value;
      }
      return UUID();       
    }`~
    // Setter
    valueSetter(name, "UUID", "DUUIDData", path)~
    valueSetter(name, "Json", "DUUIDData", path)~
    valueSetter(name, "string", "DUUIDData", path);
} 

template TimeStampValueProperty(string name, string path = null) {
  const char[] TimeStampValueProperty = `
    @property long `~name~`() {
      if (auto myValue = cast(DTimestampValue)valueOfKey("`~(path ? path : name)~`")) {
        return myValue.value;
      }
      return 0;       
    }`~
    // Setter
    valueSetter(name, "long", "DTimestampValue", path)~
    valueSetter(name, "Json", "DTimestampValue", path)~
    valueSetter(name, "string", "DTimestampValue", path);
} 

template LongValueProperty(string name, string path = null) {
  const char[] LongValueProperty = `
    @property long `~name~`() {
      if (auto myValue = cast(DLongValue)valueOfKey("`~(path ? path : name)~`")) {
        return myValue.value;
      }
      return 0;       
    }`~
    // Setter
    valueSetter(name, "long", "DLongValue", path)~
    valueSetter(name, "Json", "DLongValue", path)~
    valueSetter(name, "string", "DLongValue", path);
} 