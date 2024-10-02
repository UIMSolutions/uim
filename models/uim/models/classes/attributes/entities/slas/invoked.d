/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.models.classes.attributes.entities.slas.invoked;    

import uim.models;
@safe:

/* class DSLAInvokedAttribute : DEntityAttribute {
  mixin(AttributeThis!("SLAInvoked"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    this
      .name("slaInvoked")
      .registerPath("slaInvoked");
  }  
}
mixin(AttributeCalls!("SLAInvoked"));

version(test_uim_models) { unittest {
    testAttribute(new DSLAInvokedAttribute);
    testAttribute(SLAInvokedAttribute);
  }
}  */