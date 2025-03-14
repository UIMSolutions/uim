module uim.core.convert.uuid;

import uim.core;

version (test_uim_core) {
  unittest {
    writeln("-----  ", __MODULE__, "\t  -----");
  }
}

UUID toUUID(Json value) {
  if (value.isNull) {
    return UUID();
  }
  return UUID(value.toString);
}
unittest {
  auto id = randomUUID;
  // assert(Json(id.toString).toUUID == id);
}