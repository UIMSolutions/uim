/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
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
  override void initialize(IData[string] configSettings = null) {
    super.initialize(configSettings);

    this
      .name("country")
      .registerPath("country");
  }
}
mixin(AttributeCalls!("CountryAttribute"));

///
unittest {
  auto attribute = new DCountryAttribute;
  assert(attribute.name == "country");
  assert(attribute.registerPath == "country");

  DAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  DData value = attribute.createValue();
  assert(cast(DStringValue)value);
}