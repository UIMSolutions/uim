/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.uuids.entities.businessunit;

import uim.models;

@safe:

// A unique identifier for entity instances

class DBusinessUnitIdAttribute : DEntityIdAttribute {
  mixin(AttributeThis!("BusinessUnitIdAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    name("businessUnitId");
    registerPath("businessUnitId");

    return true;
  }
}

mixin(AttributeCalls!("BusinessUnitIdAttribute"));

///
unittest {
  auto attribute = new DBusinessUnitIdAttribute;
  assert(attribute.name == "businessUnitId");
  assert(attribute.registerPath == "businessUnitId");

  DAttribute generalAttribute = attribute;
  assert(cast(DEntityIdAttribute) generalAttribute);
  assert(cast(DUUIDAttribute) generalAttribute);
  assert(!cast(DIntegerAttribute) generalAttribute);

  DData value = attribute.createValue();
  assert(cast(DUUIDData) value);
}
