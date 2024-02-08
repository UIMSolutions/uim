/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.uuids.entities.contact;

import uim.models;

@safe:
class DContactIdAttribute : DEntityIdAttribute {
  mixin(AttributeThis!("ContactIdAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("contactId")
      .registerPath("contactId");
  }  
}
mixin(AttributeCalls!("ContactIdAttribute"));

///
unittest {
  auto attribute = new DContactIdAttribute;
  assert(attribute.name == "contactId");
  assert(attribute.registerPath == "contactId");

  DAttribute generalAttribute = attribute;
  assert(cast(DEntityIdAttribute)generalAttribute);
  assert(cast(DUUIDAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  DValue value = attribute.createValue();
  assert(cast(DUUIDValue)value);
}