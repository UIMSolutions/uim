/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.city;

import uim.models;
@safe:

// means.location.city
class DCityNameAttribute : DStringAttribute {
  mixin(AttributeThis!("CityName"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    name("cityName");
    registerPath("cityName");

   return true;
  }
}
mixin(AttributeCalls!("CityName"));

///
unittest {
  auto attribute = new DCityNameAttribute;
  assert(attribute.name == "cityName");
  assert(attribute.registerPath == "cityName");

  DAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  // Json value = attribute.createValue();
  // assert(cast(DStringData)value);
}