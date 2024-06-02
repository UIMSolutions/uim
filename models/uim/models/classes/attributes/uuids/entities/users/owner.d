/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.uuids.entities.users.owner;

import uim.models;

@safe:
class DOwnerIdAttribute : DEntityIdAttribute {
  mixin(AttributeThis!("OwnerId"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    name("ownerId");
    registerPath("ownerId");

  return true;
  }  
}
mixin(AttributeCalls!("OwnerId"));

///
unittest {
  auto attribute = new DOwnerIdAttribute;
  assert(attribute.name == "ownerId");
  assert(attribute.registerPath == "ownerId");

  DAttribute generalAttribute = attribute;
  assert(cast(DEntityIdAttribute)generalAttribute);
  assert(cast(DUUIDAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  // Json value = attribute.createValue();
  // assert(cast(DUUIDData)value);
}