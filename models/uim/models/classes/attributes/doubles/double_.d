/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.double_;

import uim.models;

@safe:
class DDoubleAttribute : DAttribute {
  mixin(AttributeThis!("DoubleAttribute"));

  // Initialization hook method.
  override void initialize(IData[string] configSettings = null) {
    super.initialize(configSettings);

    this
      .dataFormats(["floatingPoint", "big"])
      .isDouble(true)
      .name("double")
      .registerPath("double");
  }
}
mixin(AttributeCalls!("DoubleAttribute"));

///
unittest {}