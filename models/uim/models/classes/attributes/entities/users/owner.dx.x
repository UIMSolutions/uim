/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.entities.users.owner;

import uim.models;
@safe:

/* class DOwnerAttribute : DEntityAttribute {
  mixin(AttributeThis!("OwnerAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    this
      .name("owner")
      .registerPath("owner");
  }  
}
mixin(AttributeCalls!("OwnerAttribute"));

version(test_uim_models) { unittest {
  
    // TODO 
  }  
} */