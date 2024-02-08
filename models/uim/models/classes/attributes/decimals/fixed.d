/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.decimals.fixed;

import uim.models;
@safe:

// The 64 bit fixed (4) scale numbers used by PBI
class DFixedDecimalAttribute : DDecimalAttribute {
  mixin(AttributeThis!("FixedDecimalAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("fixedDecimal")
      .registerPath("fixedDecimal");
  }
}
mixin(AttributeCalls!"FixedDecimalAttribute");

version(test_uim_models) { unittest {
    testAttribute(new DFixedDecimalAttribute);
    testAttribute(FixedDecimalAttribute);
  }
}