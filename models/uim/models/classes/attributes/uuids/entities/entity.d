/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.uuids.entities.entity;

import uim.models;

@safe:

// A unique identifier for entity instances

class DEntityIdAttribute : DUUIDAttribute {
  mixin(AttributeThis!("EntityId"));

  /*  is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
is.dataFormat.guid
means.identity.entityId */

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

  registerPath("attributes.entityid");

      return true;
  }  
}

mixin(AttributeCalls!("EntityId"));

///
unittest {
  auto attribute = new DEntityIdAttribute;
  assert(attribute.name == "EntityIdAttribute");
  assert(attribute.registerPath == "attributes.entityid");

  DAttribute generalAttribute = attribute;
  assert(cast(DUUIDAttribute) generalAttribute);
  assert(!cast(DIntegerAttribute) generalAttribute);

  // Json value = attribute.createValue();
  // assert(cast(DUUIDData)value);
}
