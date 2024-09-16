/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.models.classes.attributes.uuids.uuid;    if (!super.initialize(initData)) {
      return false;
    }

import uim.models;

@safe:
class DUUIDAttribute : DAttribute {
  mixin(AttributeThis!("UUID"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

      dataFormats(["uuid"]);
registerPath("attributes.uuid");

      return true;
  }

  /* override Json createData() {
    return UUIDData(this); } */
}
mixin(AttributeCalls!("UUID"));

///
unittest {
  auto attribute = new DUUIDAttribute;
  assert(attribute.name == "UUIDAttribute");
  assert(attribute.registerPath == "attributes.uuid");

  DAttribute generalAttribute = attribute;
  assert(!cast(DIntegerAttribute)generalAttribute);

  // Json value = attribute.createValue();
  // assert(cast(DUUIDData)value);
}