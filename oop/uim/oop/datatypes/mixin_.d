module uim.oop.datatypes.mixin_;

string dataThis(string name) {
    string fullName = name ~ "Data";
    return `
    this() {
        super(); this.name("`
        ~ fullName ~ `");
    }
    `;
}

template DataThis(string name) {
    const char[] DataThis = dataThis(name);
}

string dataCalls(string name) {
    string fullName = name ~ "Data";
    return `
    auto `~ fullName ~ `() { return new D` ~ fullName ~ `();}
    `;
}

template DataCalls(string name) {
    const char[] DataCalls = dataCalls(name);
}

mixin template DataConvertTemplate() {
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
    if (newValue is null) {
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

string scalarDataOpEquals(string datatype) {
  return `
override bool opEquals(IData[string] checkData) {
  return isEqual(checkData);
}

override bool opEquals(IData checkValue) {
  return isEqual(checkValue);
}

override bool opEquals(Json checkValue) {
  return isEqual(checkValue);
}

override bool opEquals(string checkValue) {
  return isEqual(checkValue);
}`~
(datatype !is null ? `
bool opEquals(` ~ datatype ~ ` checkValue) {
  return isEqual(checkValue);
}` : null);
}

template ScalarDataOpEquals(string datatype) {
  const char[] ScalarDataOpEquals = scalarDataOpEquals(datatype);
}