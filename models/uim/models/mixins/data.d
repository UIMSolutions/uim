module uim.models.mixins.data;

import uim.models;

@safe:

template DataThis(string name, string datatype = null) { // Name for future releases
  const char[] DataThis = `  
    this() { super(); }`;
    /*
    this(DAttribute theAttribute) { this().attribute(theAttribute); }
    this(string theValue) { this().set(theValue); }
    this(Json theValue) { this().set(theValue); }
    this(DAttribute theAttribute, string theValue) { this(theAttribute).set(theValue); }
    this(DAttribute theAttribute, Json theValue) { this(theAttribute).set(theValue); }`
    ~
    (
      datatype ?
        ` this(` ~ datatype ~ ` theValue) { this().set(theValue); }
      this(DAttribute theAttribute, `
        ~ datatype ~ ` theValue) { this(theAttribute).set(theValue); }` : "");*/
}

template DataCalls(string name, string datatype = null) {
  const char[] DataCalls = `  
    auto `
    ~ name ~ `() { return new D` ~ name ~ `; }`;
    /* auto `
    ~ name ~ `(DAttribute theAttribute) { return new D` ~ name ~ `(theAttribute); }
    auto `
    ~ name ~ `(string theValue) { return new D` ~ name ~ `(theValue); }
    auto `
    ~ name ~ `(Json theValue) { return new D` ~ name ~ `(theValue); }
    auto `
    ~ name ~ `(DAttribute theAttribute, string theValue) { return new D` ~ name ~ `(theAttribute, theValue); }
    auto `
    ~ name ~ `(DAttribute theAttribute, Json theValue) { return new D` ~ name ~ `(theAttribute, theValue); }
  `
    ~
    (datatype ?
        ` auto ` ~ name ~ `(` ~ datatype ~ ` theValue) { return new D` ~ name ~ `(theValue); }
    auto `
        ~ name ~ `(DAttribute theAttribute, ` ~ datatype ~ ` theValue) { return new D` ~ name ~ `(theAttribute, theValue); }` : ""); */
}

/* template DataProperty!(string name) {
  const char[] EntityCalls = `
    auto `~name~`() { return this.values[`~name~`]; } 
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
  return  // Getter
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

template BoolDataProperty(string name, string path = null) {
  const char[] BoolDataProperty = dataProperty("bool", name, path, "DBoolData");
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

template LongDataProperty(string name, string path = null) {
  const char[] LongDataProperty = `
    @property long `
    ~ name ~ `() {
      // if (auto myData = cast(DLongData)dataOfKey("`
    ~ (path ? path : name) ~ `")) {
      //   return myData.data;
      // }
      return 0;       
    }`
    ~
     // Setter
    dataSetter(name, "long", "DLongData", path) ~
    dataSetter(name, "Json", "DLongData", path) ~
    dataSetter(name, "string", "DLongData", path);
}

mixin template DataConvertTemplate() {
  alias toJson = DData.toJson;
  override Json toJson() {
    if (isNull)
      return Json(null);
    return Json(get);
  }

  override string toString() {
    if (isNull)
      return null;
    return to!string(get);
  }
}

mixin template DataGetSetTemplate(alias defaultValue, alias dataType) {
  dataType opCall() {
    return get();
  }

  void opCall(dataType newValue) {
    set(newValue);
  }

  override void set(string newValue) {
    if (newValue is null) {
      isNull(isNullable ? true : false);
      set(defaultValue);
    } else {
      isNull(false);
      set(to!dataType(newValue));
    }
  }

  override void set(Json newValue) {
    if (newValue.isEmpty) {
      set(defaultValue);
      isNull(isNullable ? true : false);
    } else {
      set(newValue.get!dataType);
      isNull(false);
    }
  }
}
