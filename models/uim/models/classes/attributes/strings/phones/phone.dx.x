/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.phones.phone;

/* any <- char <- string <- phone
Traits
is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.identity.service.phone */

import uim.models;

@safe:
class DPhoneAttribute : DStringAttribute {
  mixin(AttributeThis!("Phone"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

      name("phone");
      registerPath("phone");

      return true;
  }
}
mixin(AttributeCalls!("Phone"));

version(test_uim_models) { unittest {
    // TODO
  }
}
