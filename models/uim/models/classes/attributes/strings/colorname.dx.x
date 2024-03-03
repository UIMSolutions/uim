/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
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
  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("colorName");
    registerPath("colorName");

    return true;
  }
}

mixin(AttributeCalls!("ColorNameAttribute"));

///
unittest {
  auto attribute = new DColorNameAttribute;
  assert(attribute.name == "colorName");
  assert(attribute.registerPath == "colorName");

  DAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute) generalAttribute);
  assert(!cast(DIntegerAttribute) generalAttribute);

  // IData value = attribute.createValue();
  // assert(cast(DStringData) value);
}
