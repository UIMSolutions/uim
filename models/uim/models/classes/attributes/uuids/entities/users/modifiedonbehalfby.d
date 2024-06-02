/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.uuids.entities.users.modifiedonbehalfby;

import uim.models;

@safe:
class DModifiedOnBehalfByAttribute : DEntityIdAttribute {
  mixin(AttributeThis!("ModifiedOnBehalfBy"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("modifiedOnBehalfBy");
    registerPath("modifiedOnBehalfBy");

    return true;
  }
}

mixin(AttributeCalls!("ModifiedOnBehalfBy"));

///
unittest {
  auto attribute = new DModifiedOnBehalfByAttribute;
  assert(attribute.name == "modifiedOnBehalfBy");
  assert(attribute.registerPath == "modifiedOnBehalfBy");

  DAttribute generalAttribute = attribute;
  assert(cast(DEntityIdAttribute) generalAttribute);
  assert(cast(DUUIDAttribute) generalAttribute);
  assert(!cast(DIntegerAttribute) generalAttribute);

  // Json value = attribute.createValue();
  // assert(cast(DUUIDData) value);
}
