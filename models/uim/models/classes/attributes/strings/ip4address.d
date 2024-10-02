/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.models.classes.attributes.strings.ip4address;    

/* Internet Protocol V4 Address of the form DDD.DDD.DDD.DDD

Inheritance
any <- char <- string <- IP4Address
Traits
is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.identity.IP4Address */

import uim.models;

@safe:
class DIP4AddressAttribute : DStringAttribute {
  mixin(AttributeThis!("IP4Address"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    registerPath("attributes.ip4address");

   return true;

  }
}
mixin(AttributeCalls!("IP4Address"));

///
unittest {
  auto attribute = new DIP4AddressAttribute;
  assert(attribute.name == "IP4AddressAttribute");
  assert(attribute.registerPath == "attributes.ip4address");

  DAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  // Json value = attribute.createValue();
  // assert(cast(DStringData)value);
}