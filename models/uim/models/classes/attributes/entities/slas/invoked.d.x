/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.entities.slas.invoked;

import uim.models;
@safe:

/* class DSLAInvokedAttribute : DEntityAttribute {
  mixin(AttributeThis!("SLAInvokedAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false; }

    this
      .name("slaInvoked")
      .registerPath("slaInvoked");
  }  
}
mixin(AttributeCalls!("SLAInvokedAttribute"));

version(test_uim_models) { unittest {
    testAttribute(new DSLAInvokedAttribute);
    testAttribute(SLAInvokedAttribute);
  }
}  */