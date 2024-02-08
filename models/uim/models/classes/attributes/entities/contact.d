/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module  source.uim.models.classes.attributes.entities.contact;

import uim.models;
@safe:

/* class DContactAttribute : DEntityAttribute {
  mixin(AttributeThis!("ContactAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("contact")
      .registerPath("contact");
  }  
}
mixin(AttributeCalls!("ContactAttribute"));

version(test_uim_models) { unittest {
    testAttribute(new DContactAttribute);
    testAttribute(ContactAttribute);
  }
} */