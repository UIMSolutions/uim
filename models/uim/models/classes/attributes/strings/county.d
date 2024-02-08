/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.county;

import uim.models;
@safe:

// means.location.county
class DCountyAttribute : DStringAttribute {
  mixin(AttributeThis!("CountyAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("county")
      .registerPath("county");
  }
}
mixin(AttributeCalls!("CountyAttribute"));

///
unittest {
  auto attribute = new DCountyAttribute;
  assert(attribute.name == "county");
  assert(attribute.registerPath == "county");

  DAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  DData value = attribute.createValue();
  assert(cast(DStringValue)value);
}