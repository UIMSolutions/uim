module uim.models.classes.data.mixins;

mixin template TDataConvert() {
  /* alias toJson = DData.toJson;
  override Json toJson() {
    if (isNull)
      return Json(null);
    return Json(value);
  }

  override string toString() {
    if (isNull)
      return null;
    return to!string(value);
  } */
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


