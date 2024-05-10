/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.entities.slas.sla;

import uim.models;
@safe:

/* class DSlaAttribute : DEntityAttribute {
  mixin(AttributeThis!("Sla"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    this
      .name("sla")
      .registerPath("sla");
  }  
}
mixin(AttributeCalls!("Sla"));

version(test_uim_models) { unittest {
    testAttribute(new DSlaAttribute);
    testAttribute(SlaAttribute);
  }
}  */