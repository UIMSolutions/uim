/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.ethnicity;

import uim.models;

@safe:

/* 
is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.demographic.ethnicity */
class DEthnicityAttribute : DStringAttribute {
  mixin(AttributeThis!("Ethnicity"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("ethnicity");
    registerPath("ethnicity");

    return true;

  }
}

mixin(AttributeCalls!("Ethnicity"));

///
unittest {
  assert(EthnicityAttribute.name == "ethnicity");
  assert(EthnicityAttribute.registerPath == "ethnicity");
}