module uim.models.helpers.data;

import uim.models;

@safe:

/// Converts Json data to IData
/// Returns: IData
IData jsonToData(Json json) {
  switch (json.type) {
    case (Json.Type.array):
        return ArrayData(json);
    case (Json.Type.bigInt):
        return IntegerData(json);
    case (Json.Type.bool_):
        return BooleanData(json);
    case (Json.Type.float_):
        return DoubleData(json);
    case (Json.Type.int_):
        return IntegerData(json);
    case (Json.Type.null_):
        return NullData(json);
    case (Json.Type.object):
        return MapData(json);
    case (Json.Type.string):
        return StringData(json);
    default:
        return null;
  }
}
///
unittest {
  assert(cast(DArrayData)jsonToData(Json.emptyArray));
}

IData[] toDataArray(Json json) {
  if (!json.isArray) { return null; }

  IData[] result; 
  for (size_t i = 0; i < json.length; i++) {
    result ~= jsonToData(json[i]);
  } 
  return result; 
}
///
unittest {
  Json json = parseJsonString(`[1, [2]]`);
  assert(toDataArray(json).length == 2);
  writeln(toDataArray(json));
}