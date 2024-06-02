/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.decimals.decimal;

import uim.models;

@safe:
class DDecimalAttribute : DAttribute {
  mixin(AttributeThis!("Decimal"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    dataFormats(["numeric.shaped"]);
    name("decimal");
    registerPath("decimal");

    return true;
  }
}

mixin(AttributeCalls!"Decimal");

version (test_uim_models) {
  unittest {
    testAttribute(new DDecimalAttribute);
    testAttribute(DecimalAttribute);
  }
}
