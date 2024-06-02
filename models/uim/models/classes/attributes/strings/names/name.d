/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.names.name;

/* any <- char <- string <- name
Traits
is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.identity.name */

import uim.models;

@safe:
class DNameAttribute : DStringAttribute {
  mixin(AttributeThis!("Name"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("name");
    registerPath("name");
    
    return true;
  }
}

mixin(AttributeCalls!("Name"));

version (test_uim_models) {
  unittest {
    // TODO
  }
}
