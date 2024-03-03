/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.uuids.entities.users.team;

import uim.models;

@safe:
class DTeamIdAttribute : DEntityIdAttribute {
  mixin(AttributeThis!("TeamIdAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    name("teamId");
      registerPath("teamId");

      return true;

  }  
}
mixin(AttributeCalls!("TeamIdAttribute"));

///
unittest {
  auto attribute = new DTeamIdAttribute;
  assert(attribute.name == "teamId");
  assert(attribute.registerPath == "teamId");

  DAttribute generalAttribute = attribute;
  assert(cast(DEntityIdAttribute)generalAttribute);
  assert(cast(DUUIDAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  // IData value = attribute.createValue();
  // assert(cast(DUUIDData)value);
}