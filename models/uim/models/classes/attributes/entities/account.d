/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.entities.account;

import uim.models;
@safe:

/* class DAccountAttribute : DEntityAttribute {
  mixin(AttributeThis!("AccountAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false: }

    this
      .name("account")
      .registerPath("account");
  }  
}
mixin(AttributeCalls!("AccountAttribute"));

version(test_uim_models) { unittest {
    testAttribute(new DAccountAttribute);
    testAttribute(AccountAttribute);
  }
} */