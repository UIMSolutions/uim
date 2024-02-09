/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.country;

import uim.models;

@safe:

// means.location.country
class DCountryAttribute : DStringAttribute {
  mixin(AttributeThis!("CountryAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    name("country");
    registerPath("country");

    return true;
  }
}

mixin(AttributeCalls!("CountryAttribute"));

///
unittest {
  auto attribute = new DCountryAttribute;
  assert(attribute.name == "country");
  assert(attribute.registerPath == "country");

  DAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute) generalAttribute);
  assert(!cast(DIntegerAttribute) generalAttribute);

  // IData value = attribute.createValue();
  assert(cast(DStringData) value);
}
