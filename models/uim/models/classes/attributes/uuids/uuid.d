/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.uuids.uuid;

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
  assert(attribute.registerPath == "attribute.uuid");

  DAttribute generalAttribute = attribute;
  assert(!cast(DIntegerAttribute)generalAttribute);

  // Json value = attribute.createValue();
  // assert(cast(DUUIDData)value);
}