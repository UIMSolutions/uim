/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.entities.businessunit;

import uim.models;
@safe:

// A unique identifier for entity instances

/* class DBusinessUnitAttribute : DEntityAttribute {
  mixin(AttributeThis!("BusinessUnitAttribute"));

  // Initialization hook method.
  override void initialize(IData[string] configSettings = null) {
    super.initialize(configSettings);

    this
      .name("businessUnit")
      .registerPath("businessunit");
  }  
}
mixin(AttributeCalls!("BusinessUnitAttribute"));

version(test_uim_models) { unittest {
    testAttribute(new DBusinessUnitAttribute);
    testAttribute(BusinessUnitAttribute);
  }
} */