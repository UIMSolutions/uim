/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.gender;

import uim.models;

@safe:

/* is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.demographic.gender */
class DGenderAttribute : DStringAttribute {
  mixin(AttributeThis!("Gender"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("gender");
    registerPath("gender");

    return true;
  }
}

mixin(AttributeCalls!("Gender"));

///
unittest {
  auto attribute = new DGenderAttribute;
  assert(attribute.name == "gender");
  assert(attribute.registerPath == "gender");
}