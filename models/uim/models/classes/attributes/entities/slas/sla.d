/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.entities.slas.sla;

import uim.models;
@safe:

/* class DSlaAttribute : DEntityAttribute {
  mixin(AttributeThis!("SlaAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    super.initialize(configData);

    this
      .name("sla")
      .registerPath("sla");
  }  
}
mixin(AttributeCalls!("SlaAttribute"));

version(test_uim_models) { unittest {
    testAttribute(new DSlaAttribute);
    testAttribute(SlaAttribute);
  }
}  */