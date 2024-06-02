/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.uuids.entities.account;

import uim.models;

@safe:
class DAccountIdAttribute : DEntityIdAttribute {
  mixin(AttributeThis!("AccountId"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("accountId");
    registerPath("accountId");

    return true;
  }
}

mixin(AttributeCalls!("AccountId"));

///
unittest {
  auto attribute = new DAccountIdAttribute;
  assert(attribute.name == "accountId");
  assert(attribute.registerPath == "accountId");

  DAttribute generalAttribute = attribute;
  assert(cast(DEntityIdAttribute) generalAttribute);
  assert(cast(DUUIDAttribute) generalAttribute);
  assert(!cast(DIntegerAttribute) generalAttribute);

  // Json value = attribute.createValue();
  // assert(cast(DUUIDData) value);
}
