module uim.models.mixins.data;

import uim.models;
@safe:

string dataGetter(string name, string datatype, string dataClass, string path) {
  string newPath = (path ? path : name);
  return `
    @property `~datatype~` `~name~`() {
      if (auto myData = cast(`~dataClass~`)dataOfKey("`~newPath~`")) {
        return myData.data;
      }
      
      return null;       
    }`;
}

string dataSetter(string name, string datatype, string dataClass, string path) {
  string newPath = (path ? path : name);
  return `
    @property O `~name~`(this O)(`~datatype~` newData) { 
      if (auto myData = cast(`~dataClass~`)dataOfKey("`~newPath~`")) {
        myData.data(newData);
        return cast(O)this;
      }
      return cast(O)this;
    }`;
} 

string dataProperty(string datatype, string name, string path = null, string dataClass = "DStringData") {
  auto newPath = (path ? path : name);
  return
    // Getter
    dataGetter(name, datatype, dataClass, newPath)~
    // Setter
    dataSetter(name, datatype, dataClass, newPath)~
    dataSetter(name, "Json", dataClass, newPath)~
    (datatype != "string" ? dataSetter(name, "string", dataClass, newPath) : "");
} 

template DataProperty(string datatype, string name, string path = null, string dataClass = "DStringData") {
  const char[] DataProperty = dataProperty(datatype, name, path, dataClass);
} 

template StringDataProperty(string name, string path = null) {
  const char[] StringDataProperty = dataProperty("string", name, path, "DStringData");
} 

template BooleanDataProperty(string name, string path = null) {
  const char[] BooleanDataProperty = dataProperty("bool", name, path, "DBooleanData");
} 

template UUIDDataProperty(string name, string path = null) {
  const char[] newPath = (path ? path : name);
  const char[] UUIDDataProperty = `
    @property UUID `~name~`() {
      if (auto myData = cast(DUUIDData)dataOfKey("`~(path ? path : name)~`")) {
        return myData.data;
      }
      return UUID();       
    }`~
    // Setter
    dataSetter(name, "UUID", "DUUIDData", path)~
    dataSetter(name, "Json", "DUUIDData", path)~
    dataSetter(name, "string", "DUUIDData", path);
} 

template TimeStampDataProperty(string name, string path = null) {
  const char[] TimeStampDataProperty = `
    @property long `~name~`() {
      if (auto myData = cast(DTimestampData)dataOfKey("`~(path ? path : name)~`")) {
        return myData.data;
      }
      return 0;       
    }`~
    // Setter
    dataSetter(name, "long", "DTimestampData", path)~
    dataSetter(name, "Json", "DTimestampData", path)~
    dataSetter(name, "string", "DTimestampData", path);
} 

template LongDataProperty(string name, string path = null) {
  const char[] LongDataProperty = `
    @property long `~name~`() {
      if (auto myData = cast(DLongData)dataOfKey("`~(path ? path : name)~`")) {
        return myData.data;
      }
      return 0;       
    }`~
    // Setter
    dataSetter(name, "long", "DLongData", path)~
    dataSetter(name, "Json", "DLongData", path)~
    dataSetter(name, "string", "DLongData", path);
} 