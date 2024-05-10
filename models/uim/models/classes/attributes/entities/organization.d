/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.entities.organization;

import uim.models;
@safe:

/* class DOrganizationAttribute : DEntityAttribute {
  mixin(AttributeThis!("Organization"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    this
      .name("organization")
      .registerPath("organization");
  }  
}
mixin(AttributeCalls!("Organization"));

version(test_uim_models) { unittest {
    testAttribute(new DOrganizationAttribute);
    testAttribute(OrganizationAttribute);
  }
} */