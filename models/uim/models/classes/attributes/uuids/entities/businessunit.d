/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.uuids.entities.businessunit;

import uim.models;

@safe:

// A unique identifier for entity instances

class DBusinessUnitIdAttribute : DEntityIdAttribute {
  mixin(AttributeThis!("BusinessUnitId"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("businessUnitId");
    registerPath("businessUnitId");

    return true;
  }
}

mixin(AttributeCalls!("BusinessUnitId"));

///
unittest {
  auto attribute = new DBusinessUnitIdAttribute;
  assert(attribute.name == "businessUnitId");
  assert(attribute.registerPath == "businessUnitId");

  DAttribute generalAttribute = attribute;
  assert(cast(DEntityIdAttribute) generalAttribute);
  assert(cast(DUUIDAttribute) generalAttribute);
  assert(!cast(DIntegerAttribute) generalAttribute);

  // Json value = attribute.createValue();
  // assert(cast(DUUIDData) value);
}
