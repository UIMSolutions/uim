/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.uuids.entities.contact;

import uim.models;

@safe:
class DContactIdAttribute : DEntityIdAttribute {
  mixin(AttributeThis!("ContactIdAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    super.initialize(configData);

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

  DData value = attribute.createValue();
  assert(cast(DUUIDData)value);
}