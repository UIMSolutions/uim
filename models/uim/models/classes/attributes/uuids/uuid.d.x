/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.uuids.uuid;

import uim.models;

@safe:
class DUUIDAttribute : DAttribute {
  mixin(AttributeThis!("UUIDAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false; }

    name("uuid");
      dataFormats(["uuid"]);
registerPath("uuid");

      return true;
  }

  /* override IData createData() {
    return UUIDData(this); } */
}
mixin(AttributeCalls!("UUIDAttribute"));

///
unittest {
  auto attribute = new DUUIDAttribute;
  assert(attribute.name == "uuid");
  assert(attribute.registerPath == "uuid");

  DAttribute generalAttribute = attribute;
  assert(!cast(DIntegerAttribute)generalAttribute);

  // IData value = attribute.createValue();
  // assert(cast(DUUIDData)value);
}