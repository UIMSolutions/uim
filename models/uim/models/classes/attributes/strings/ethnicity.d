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
  mixin(AttributeThis!("EthnicityAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false: }

    this
      .name("ethnicity")
      .registerPath("ethnicity");
  }
}
mixin(AttributeCalls!("EthnicityAttribute"));

///
unittest {
  assert(EthnicityAttribute.name == "ethnicity");
  assert(EthnicityAttribute.registerPath == "ethnicity");
}