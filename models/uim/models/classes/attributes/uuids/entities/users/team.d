/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.models.classes.attributes.uuids.entities.users.team;    

import uim.models;

@safe:
class DTeamIdAttribute : DEntityIdAttribute {
  mixin(AttributeThis!("TeamId"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

      registerPath("attributes.teamid");

      return true;

  }  
}
mixin(AttributeCalls!("TeamId"));

///
unittest {
  auto attribute = new DTeamIdAttribute;
  assert(attribute.name == "TeamIdAttribute");
  assert(attribute.registerPath == "attributes.teamid");

  DAttribute generalAttribute = attribute;
  assert(cast(DEntityIdAttribute)generalAttribute);
  assert(cast(DUUIDAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  // Json value = attribute.createValue();
  // assert(cast(DUUIDData)value);
}