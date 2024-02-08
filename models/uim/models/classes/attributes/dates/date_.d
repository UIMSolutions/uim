/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.dates.date_;

import uim.models;

@safe:
class DDateAttribute : DAttribute {
  mixin(AttributeThis!("DateAttribute"));

  // Initialization hook method.  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);
    // means.measurement.date

    this
      .name("date")
      .dataFormats(["date"])
      .registerPath("date");
  }

  override DValue createValue() {
    return DateValue(this); }
}
mixin(AttributeCalls!("DateAttribute"));

version(test_uim_models) { unittest {  
    // TODO tests
  }
}