/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.uuids.entities.users.user;

/* The identifier of a system user

Inheritance
any <- char <- string <- guid <- entityId <- userId
Traits
is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
is.dataFormat.guid
means.identity.entityId
means.userId */

import uim.models;

@safe:
class DUserIdAttribute : DEntityIdAttribute {
  mixin(AttributeThis!("UserId"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    name("userId");
     registerPath("userId");

      return true;
  }  
}
mixin(AttributeCalls!("UserId"));

///
unittest {
  auto attribute = new DUserIdAttribute;
  assert(attribute.name == "userId");
  assert(attribute.registerPath == "userId");

  DAttribute generalAttribute = attribute;
  assert(cast(DEntityIdAttribute)generalAttribute);
  assert(cast(DUUIDAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  // Json value = attribute.createValue();
  // assert(cast(DUUIDData)value);
}