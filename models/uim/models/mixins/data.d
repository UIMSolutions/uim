module uim.models.mixins.data;

import uim.models;

@safe:

string dataThis(string name, string datatype = null) { // Name for future releases
  return `  
    this() { super(); }
    this(string newValue) { this(); set(newValue); }
    this(Json newValue) { this(); set(newValue); } `;
  // ~ datatype !is null ? ` this(` ~ datatype ~ ` newzValue) { this(); set(newzValue); }`: null;

  /*      this(DAttribute theAttribute, `
        ~ datatype ~ ` newValue) { this(theAttribute).set(newValue); }` : "");

    /*
    this(DAttribute theAttribute) { this().attribute(theAttribute); }
    this(DAttribute theAttribute, string newValue) { this(theAttribute).set(newValue); }
    this(DAttribute theAttribute, Json newValue) { this(theAttribute).set(newValue); }` */
}

unittest {
  writeln(dataThis("name", "datatype"));
}

template DataThis(string name, string datatype = null) { // Name for future releases
  const char[] DataThis = dataThis(name, datatype);
}

template DataCalls(string name, string datatype = null) {
  const char[] DataCalls = `  
    auto `
    ~ name ~ `() { return new D` ~ name ~ `; }
    auto `
    ~ name ~ `(string newValue) { return new D` ~ name ~ `(newValue); }
    auto `
    ~ name ~ `(Json newValue) { return new D` ~ name ~ `(newValue); } `;
  // ~ datatype !is null ? `auto ` ~ name ~ `(` ~ datatype ~ ` newzValue) { return new D` ~ name ~ `(newzValue); }`: null;

  /* auto `
    ~ name ~ `(DAttribute theAttribute) { return new D` ~ name ~ `(theAttribute); }
    auto `
    auto `
    ~ name ~ `(DAttribute theAttribute, string newValue) { return new D` ~ name ~ `(theAttribute, newValue); }
    auto `
    ~ name ~ `(DAttribute theAttribute, Json newValue) { return new D` ~ name ~ `(theAttribute, newValue); }
  `
    ~
    (datatype ?
    auto `
        ~ name ~ `(DAttribute theAttribute, ` ~ datatype ~ ` newValue) { return new D` ~ name ~ `(theAttribute, newValue); }` : ""); */
}

/* template DataProperty!(string name) {
  const char[] EntityCalls = `
    auto `~name~`() { return _values[`~name~`]; } 
    void `~name~`(string newValue) { this.values[`~name~`].set(newValue);  } 
    void `~name~`(Json newValue) { this.values[`~name~`].set(newValue);   } 
  `;
} */

string dataGetter(string name, string datatype, string dataClass, string path) {
  string newPath = (path ? path : name);
  return `
    @property `
    ~ datatype ~ ` ` ~ name ~ `() {
      // if (auto myData = cast(`
    ~ dataClass ~ `)dataOfKey("` ~ newPath ~ `")) {
      //   return myData.data;
      // }
      
      return null;       
    }`;
}

string dataSetter(string name, string datatype, string dataClass, string path) {
  string newPath = (path ? path : name);
  return `
    @property void `
    ~ name ~ `(` ~ datatype ~ ` newData) { 
      // if (auto myData = cast(`
    ~ dataClass ~ `)dataOfKey("` ~ newPath ~ `")) {
      //   myData.data(newData);
      //   
      // }
      
    }`;
}

string dataProperty(string datatype, string name, string path = null, string dataClass = "DStringData") {
  auto newPath = (path ? path : name);
  return // Getter
  dataGetter(name, datatype, dataClass, newPath) ~
     // Setter
    dataSetter(name, datatype, dataClass, newPath) ~
    dataSetter(name, "Json", dataClass, newPath) ~
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
    @property UUID `
    ~ name ~ `() {
      // if (auto myData = cast(DUUIDData)dataOfKey("`
    ~ (path ? path : name) ~ `")) {
      //   return myData.data;
      // }
      return UUID();       
    }`
    ~
     // Setter
    dataSetter(name, "UUID", "DUUIDData", path) ~
    dataSetter(name, "Json", "DUUIDData", path) ~
    dataSetter(name, "string", "DUUIDData", path);
}

template TimeStampDataProperty(string name, string path = null) {
  const char[] TimeStampDataProperty = `
    @property long `
    ~ name ~ `() {
      // if (auto myData = cast(DTimestampData)dataOfKey("`
    ~ (path ? path : name) ~ `")) {
      //   return myData.data;
      // }
      return 0;       
    }`
    ~
     // Setter
    dataSetter(name, "long", "DTimestampData", path) ~
    dataSetter(name, "Json", "DTimestampData", path) ~
    dataSetter(name, "string", "DTimestampData", path);
}

template IntegerDataProperty(string name, string path = null) {
  const char[] IntegerDataProperty = `
    @property long `
    ~ name ~ `() {
      // if (auto myData = cast(DIntegerData)dataOfKey("`
    ~ (path ? path : name) ~ `")) {
      //   return myData.data;
      // }
      return 0;       
    }`
    ~
     // Setter
    dataSetter(name, "long", "DIntegerData", path) ~
    dataSetter(name, "Json", "DIntegerData", path) ~
    dataSetter(name, "string", "DIntegerData", path);
}







