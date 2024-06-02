module uim.models.classes.data.mixin_;

string dataThis(string name) {
  string fullName = name ~ "Data";
  return `
    this() {
      super(); 
      this.name("`
    ~ fullName ~ `");
    }
    /* this(string newValue) {
      this();
      set(newValue);
    }

    this(Json newValue) {
      this();
      set(newValue);
    } */
  `; 
}

template DataThis(string name) {
  const char[] DataThis = dataThis(name);
}

string dataCalls(string name) {
  string fullName = name ~ "Data";
  return `
    auto ` ~ fullName ~ `() { return new D` ~ fullName ~ `(); }
    // auto ` ~ fullName ~ `(string newValue) { return new D` ~ fullName ~ `(newValue); }
    // auto ` ~ fullName ~ `(Json newValue) { return new D` ~ fullName ~ `(newValue); }
  `;
}

template DataCalls(string name) {
  const char[] DataCalls = dataCalls(name);
}

mixin template TDataConvert() {
  alias toJson = DData.toJson;
  override Json toJson() {
    if (isNull)
      return Json(null);
    return Json(value);
  }

  override string toString() {
    if (isNull)
      return null;
    return to!string(value);
  }
}

string dataGetSetTemplate(string nullValue, string dataType, string jsonType = null) {
  auto jType = jsonType is null ? dataType : jsonType;
  return `
  protected `
    ~ dataType ~ ` _value;
  `
    ~ dataType ~ ` opCall() {
    return get();
  }

  void opCall(`
    ~ dataType ~ ` newValue) {
    set(newValue);
  }

  override void set(string newValue) {
    if (newValue.isNull) {
      isNull(isNullable ? true : false);
      set(`
    ~ nullValue ~ `);
    } else {
      isNull(false);
      set(to!`
    ~ dataType ~ `(newValue));
    }
  }

  override void set(Json newValue) {
    if (newValue.isEmpty) {
      set(`
    ~ nullValue ~ `);
      isNull(isNullable ? true : false);
    } else {
      set(newValue.get!`
    ~ jType ~ `);
      isNull(false);
    }
  }`;
}

template DataGetSetTemplate(string nullValue, string dataType, string jsonType = null) {
  auto jType = jsonType is null ? dataType : jsonType;
  const char[] DataGetSetTemplate = dataGetSetTemplate(nullValue, dataType, jsonType);
}


