/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.models.classes.attributes.strings.timezone;    

/* any <- char <- string <- timezone
Traits
is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.location.timezone */

import uim.models;

@safe:
class DTimezoneAttribute : DStringAttribute {
  mixin(AttributeThis!("Timezone"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

   name("timezone");
      registerPath("attributes.timezone");

      return true;
  }
}
mixin(AttributeCalls!("Timezone"));

///
unittest {
  auto attribute = new DTimezoneAttribute;
  assert(attribute.name == "TimezoneAttribute");
  assert(attribute.registerPath == "attributes.timezone");

  DAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  // Json value = attribute.createValue();
  // assert(cast(DStringData)value);
}