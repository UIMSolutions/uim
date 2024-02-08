/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.names.first;

import uim.models;
@safe:

/* is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.identity.person.firstName */
class DFirstNameAttribute : DStringAttribute {
  mixin(AttributeThis!("FirstNameAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    super.initialize(configData);

    this
      .name("firstName")
      .registerPath("firstname");
  }
}
mixin(AttributeCalls!("FirstNameAttribute"));

version(test_uim_models) { unittest {
    // TODO
  }
}