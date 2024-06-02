/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.uuids.entities.users.createdonbehalfby;

import uim.models;

@safe:
class DCreatedOnBehalfByAttribute : DEntityIdAttribute {
  mixin(AttributeThis!("CreatedOnBehalfBy"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("createdOnBehalfBy");
    registerPath("createdOnBehalfBy");

    return true;
  }
}

mixin(AttributeCalls!("CreatedOnBehalfBy"));

///
unittest {
  auto attribute = new DCreatedOnBehalfByAttribute;
  assert(attribute.name == "createdOnBehalfBy");
  assert(attribute.registerPath == "createdOnBehalfBy");

  DAttribute generalAttribute = attribute;
  assert(cast(DEntityIdAttribute) generalAttribute);
  assert(cast(DUUIDAttribute) generalAttribute);
  assert(!cast(DIntegerAttribute) generalAttribute);

  // Json value = attribute.createValue();
  // assert(cast(DUUIDData) value);
}
