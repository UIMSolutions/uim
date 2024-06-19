/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.governmentid;

import uim.models;

@safe:

/* is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.identity.governmentID */
class DGovernmentIdAttribute : DStringAttribute {
  mixin(AttributeThis!("GovernmentId"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    registerPath("attributes.governmentid");

    return true;
  }
}

mixin(AttributeCalls!("GovernmentId"));

///
unittest {
  assert(GovernmentIdAttribute.name == "GovernmentIdAttribute");
  assert(GovernmentIdAttribute.registerPath == "attributes.governmentid");
}
