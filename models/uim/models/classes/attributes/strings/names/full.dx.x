/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.names.full;

/* is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.identity.person.fullName */

import uim.models;

@safe:
class DFullNameAttribute : DStringAttribute {
  mixin(AttributeThis!("FullNameAttribute"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("fullName");
    registerPath("fullName");

    return true;
  }
}

mixin(AttributeCalls!("FullNameAttribute"));

version (test_uim_models) {
  unittest {
    // TODO
  }
}
