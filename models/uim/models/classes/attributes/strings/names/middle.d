/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.names.middle;

/* any <- char <- string <- middleName
Traits
is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.identity.person.middleName */

import uim.models;

@safe:
class DMiddleNameAttribute : DStringAttribute {
  mixin(AttributeThis!("MiddleName"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("middleName");
    registerPath("middleName");

    return true;
  }
}

mixin(AttributeCalls!("MiddleName"));

version (test_uim_models) {
  unittest {
    // TODO
  }
}