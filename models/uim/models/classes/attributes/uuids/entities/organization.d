/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.uuids.entities.organization;

import uim.models;

@safe:
class DOrganizationIdAttribute : DEntityIdAttribute {
  mixin(AttributeThis!("OrganizationId"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("organizationId");
    registerPath("organizationId");

    return true;
  }
}

mixin(AttributeCalls!("OrganizationId"));

///
unittest {
  auto attribute = new DOrganizationIdAttribute;
  assert(attribute.name == "organizationId");
  assert(attribute.registerPath == "organizationId");

  DAttribute generalAttribute = attribute;
  assert(cast(DEntityIdAttribute) generalAttribute);
  assert(cast(DUUIDAttribute) generalAttribute);
  assert(!cast(DIntegerAttribute) generalAttribute);

  // Json value = attribute.createValue();
  // assert(cast(DUUIDData) value);
}
