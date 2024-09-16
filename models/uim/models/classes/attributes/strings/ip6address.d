/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.models.classes.attributes.strings.ip6address;    if (!super.initialize(initData)) {
      return false;
    }

/* Internet Protocol V6 Address of the form XXXX:XXXX:XXXX:XXXX:XXXX:XXXX:XXXX:XXXX

Inheritance
any <- char <- string <- IP6Address
Traits
is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.identity.IP6Address */

import uim.models;

@safe:
class DIP6AddressAttribute : DStringAttribute {
  mixin(AttributeThis!("IP6Address"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    registerPath("attributes.ip6address");

      return true;

  }
}
mixin(AttributeCalls!("IP6Address"));

///
unittest {
  auto attribute = new DIP6AddressAttribute;
  assert(attribute.name == "IP6AddressAttribute");
  assert(attribute.registerPath == "attributes.ip6address");

  DAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  // Json value = attribute.createValue();
  // assert(cast(DStringData)value);
}