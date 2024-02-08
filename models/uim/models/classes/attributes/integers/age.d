/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.integers.age;

import uim.models;

@safe:
class DAgeAttribute : DIntegerAttribute {
  mixin(AttributeThis!("AgeAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    super.initialize(configData);

    //means.demographic.age
    //means.measurement.age
    this
      .name("age")
      .registerPath("age");    
  }
}
mixin(AttributeCalls!"AgeAttribute");

version(test_uim_models) { unittest {
    testAttribute(new DAgeAttribute);
    testAttribute(AgeAttribute);
  }
}