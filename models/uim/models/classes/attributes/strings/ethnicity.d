/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
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
  override void initialize(IData[string] configSettings = null) {
    super.initialize(configSettings);

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