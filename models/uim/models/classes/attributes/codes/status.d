/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.codes.status;

import uim.models;

@safe:
class DStatusCodeAttribute : DIntegerStringAttribute {
  mixin(AttributeThis!("StatusCodeAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("statusCode")
      .display("Status Reason")
      .lookups([
        0: "Active",  
        1: "Inactive"
      ])
      .isNullable(true)
      .registerPath("statuscode");
  }
}
mixin(AttributeCalls!("StatusCodeAttribute"));

version(test_uim_models) { unittest {  
    // TODO tests
  }
}