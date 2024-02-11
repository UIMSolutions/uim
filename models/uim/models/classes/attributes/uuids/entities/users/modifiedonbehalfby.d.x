/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.uuids.entities.users.modifiedonbehalfby;

import uim.models;

@safe:
class DModifiedOnBehalfByAttribute : DEntityIdAttribute {
  mixin(AttributeThis!("ModifiedOnBehalfByAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    name("modifiedOnBehalfBy");
    registerPath("modifiedOnBehalfBy");

    return true;
  }
}

mixin(AttributeCalls!("ModifiedOnBehalfByAttribute"));

///
unittest {
  auto attribute = new DModifiedOnBehalfByAttribute;
  assert(attribute.name == "modifiedOnBehalfBy");
  assert(attribute.registerPath == "modifiedOnBehalfBy");

  DAttribute generalAttribute = attribute;
  assert(cast(DEntityIdAttribute) generalAttribute);
  assert(cast(DUUIDAttribute) generalAttribute);
  assert(!cast(DIntegerAttribute) generalAttribute);

  // IData value = attribute.createValue();
  // assert(cast(DUUIDData) value);
}
