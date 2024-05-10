/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.integers.age;

import uim.models;

@safe:
class DAgeAttribute : DIntegerAttribute {
  mixin(AttributeThis!("Age"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    //means.demographic.age
    //means.measurement.age
    name("age");
    registerPath("age");

    return true;
  }
}

mixin(AttributeCalls!"Age");

version (test_uim_models) {
  unittest {
    testAttribute(new DAgeAttribute);
    testAttribute(AgeAttribute);
  }
}
