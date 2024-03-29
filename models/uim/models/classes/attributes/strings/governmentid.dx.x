/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.governmentid;

import uim.models;

@safe:

/* is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.identity.governmentID */
class DGovernmentIdAttribute : DStringAttribute {
  mixin(AttributeThis!("GovernmentIdAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("governmentId");
    registerPath("governmentId");

    return true;
  }
}

mixin(AttributeCalls!("GovernmentIdAttribute"));

///
unittest {
  assert(GovernmentIdAttribute.name == "governmentId");
  assert(GovernmentIdAttribute.registerPath == "governmentId");
}
