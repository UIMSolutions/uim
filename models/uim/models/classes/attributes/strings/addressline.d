/****************************************************************************************************************
* Copyright: © 2017-2024 Ozan Nurettin Süel (aka UIManufaktur)                                                  *
* License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.         *
* Authors: Ozan Nurettin Süel (aka UIManufaktur)                                                                *
*****************************************************************************************************************/
module uim.models.classes.attributes.strings.addressline;

import uim.models;

@safe:
/** 
 * is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.location.address
 */
class DAddressLineAttribute : DStringAttribute {
  mixin(AttributeThis!"AddressLine");

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    // means.location.address
    registerPath("attributes.addressline");

    return true;
  }
}

mixin(AttributeCalls!"AddressLine");

///
unittest {
  auto attribute = new DAddressLineAttribute;
  assert(attribute.name == "AddressLineAttribute");
  assert(attribute.registerPath == "attributes.addressline");

  DAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute) generalAttribute);
  assert(!cast(DIntegerAttribute) generalAttribute);

  // Json value = attribute.createValue();
  // assert(cast(DStringData)value);
}
