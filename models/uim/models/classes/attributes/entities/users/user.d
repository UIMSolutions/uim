/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.entities.users.user;

/* The identifier of a system user

Inheritance
any <- char <- string <- guid <- entityId <- userId
Traits
is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
is.dataFormat.guid
means.identity.entityId
means.userId */

import uim.models;
@safe:

/* class DUserAttribute : DEntityAttribute {
  mixin(AttributeThis!("UserAttribute"));

  // Initialization hook method.
  override void initialize(IData[string] configSettings = null) {
    super.initialize(configSettings);

    this
      .name("user")
      .registerPath("user");
  }  
}
mixin(AttributeCalls!("UserAttribute"));

version(test_uim_models) { unittest {
  
    // TODO 
  }  
} */