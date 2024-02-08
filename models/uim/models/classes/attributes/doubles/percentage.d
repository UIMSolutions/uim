/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.doubles.percentage;

import uim.models;

@safe:
class DPercentageAttribute : DDoubleAttribute {
  mixin(AttributeThis!("PercentageAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false: }

    this
      .name("percentage")
      .registerPath("percentage");
  }
}
mixin(AttributeCalls!("PercentageAttribute"));

version(test_uim_models) { unittest {  
    // TODO tests
  }
}