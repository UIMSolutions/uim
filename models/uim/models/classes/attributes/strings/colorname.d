/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.colorname;

import uim.models;
@safe:

// means.measurement.color
class DColorNameAttribute : DStringAttribute {
  mixin(AttributeThis!("ColorNameAttribute"));

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("colorName")
      .registerPath("colorName");
  }
}
mixin(AttributeCalls!("ColorNameAttribute"));

///
unittest {
  auto attribute = new DColorNameAttribute;
  assert(attribute.name == "colorName");
  assert(attribute.registerPath == "colorName");

  DAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  DValue value = attribute.createValue();
  assert(cast(DStringValue)value);
}