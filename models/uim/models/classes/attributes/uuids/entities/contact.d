/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.uuids.entities.contact;

import uim.models;

@safe:
class DContactIdAttribute : DEntityIdAttribute {
  mixin(AttributeThis!("ContactId"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("contactId");
    registerPath("contactId");

    return true;

  }
}

mixin(AttributeCalls!("ContactId"));

///
unittest {
  auto attribute = new DContactIdAttribute;
  assert(attribute.name == "contactId");
  assert(attribute.registerPath == "contactId");

  DAttribute generalAttribute = attribute;
  assert(cast(DEntityIdAttribute) generalAttribute);
  assert(cast(DUUIDAttribute) generalAttribute);
  assert(!cast(DIntegerAttribute) generalAttribute);

  // Json value = attribute.createValue();
  // assert(cast(DUUIDData) value);
}