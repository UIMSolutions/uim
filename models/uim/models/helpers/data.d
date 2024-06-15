module uim.models.helpers.data;

import uim.models;

@safe:

/// Converts Json data to Json
/// Returns: Json
/*
Json jsonToData(Json json) {
  switch (json.type) {
    case (Json.Type.array):
        return ArrayData(json);
    case (Json.Type.bigInt):
        return IntegerData(json);
    case (Json.Type.bool_):
        return BooleanData(json);
    case (Json.Type.float_):
        return NumberData(json);
    case (Json.Type.int_):
        return IntegerData(json);
    // case (Json.Type.null_):
    //     return NullData(json);
    case (Json.Type.object):
        return MapData(json);
    case (Json.Type.string):
        return StringData(json);
    default:
        return null;
  }
} */
///
unittest {
  // TODO assert(cast(DArrayData)jsonToData(Json.emptyArray));
}

/*
Json[] toArray(Json json) {
  if (!json.isArray) { return null; }

  Json[] result; 
  for (size_t i = 0; i < json.length; i++) {
    result ~= jsonToData(json[i]);
  } 
  return result; 
}

Json[] toJsonArray(Json json) {
  if (!json.isArray) { return null; }

  for (size_t i = 0; i < json.length; i++) {
    result ~= jsonToData(json[i]);
  } 
  return result; 
}
*/
///
unittest {
  Json json = parseJsonString(`[1, [2]]`);
  assert(toArray(json).length == 2);
  writeln(toArray(json));
}