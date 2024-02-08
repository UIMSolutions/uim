/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.decimals.decimal;

import uim.models;

@safe:
class DDecimalAttribute : DAttribute {
  mixin(AttributeThis!("DecimalAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    super.initialize(configData);

    this
      .dataFormats(["numeric.shaped"])
      .name("decimal")
      .registerPath("decimal");
  }
}
mixin(AttributeCalls!"DecimalAttribute");

version(test_uim_models) { unittest {
    testAttribute(new DDecimalAttribute);
    testAttribute(DecimalAttribute);
  }
}