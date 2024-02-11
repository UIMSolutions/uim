/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.codes.customersize;

import uim.models;

@safe:
class DCustomerSizeCodeAttribute : DIntegerStringAttribute {
  mixin(AttributeThis!("CustomerSizeCodeAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    name("customerSizeCode");
    display("Customer Size");
    lookups([
        0: "0-100 (small)",
        1: "100-1000 (middle)",
        2: "1000-10000 (large)"
      ]);
    isNullable(true);
    registerPath("customerSizeCode");

    return true;
  }
}

mixin(AttributeCalls!("CustomerSizeCodeAttribute"));

version (test_uim_models) {
  unittest {
    // TODO tests
  }
}
