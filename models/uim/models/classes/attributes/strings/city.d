/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.models.classes.attributes.strings.city;    

import uim.models;
@safe:

// means.location.city
class DCityNameAttribute : DStringAttribute {
  mixin(AttributeThis!("CityName"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    registerPath("attributes.cityname");

   return true;
  }
}
mixin(AttributeCalls!("CityName"));

///
unittest {
  auto attribute = new DCityNameAttribute;
  assert(attribute.name == "CityNameAttribute");
  assert(attribute.registerPath == "attributes.cityname");

  DAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  // Json value = attribute.createValue();
  // assert(cast(DStringData)value);
}