/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.uuids.entities.account;

import uim.models;

@safe:
class DAccountIdAttribute : DEntityIdAttribute {
  mixin(AttributeThis!("AccountIdAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("accountId")
      .registerPath("accountId");
  }  
}
mixin(AttributeCalls!("AccountIdAttribute"));

///
unittest {
  auto attribute = new DAccountIdAttribute;
  assert(attribute.name == "accountId");
  assert(attribute.registerPath == "accountId");

  DAttribute generalAttribute = attribute;
  assert(cast(DEntityIdAttribute)generalAttribute);
  assert(cast(DUUIDAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  DValue value = attribute.createValue();
  assert(cast(DUUIDValue)value);
}