/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.postalcode;

/* Traits
is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.location.postalCode */

import uim.models;

@safe:
class DPostalCodeAttribute : DStringAttribute {
  mixin(AttributeThis!("PostalCode"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    name("postalcode");
      registerPath("postalcode");

      return true;
  }
}
mixin(AttributeCalls!("PostalCode"));

///
unittest {
  auto attribute = new DPostalCodeAttribute;
  assert(attribute.name == "postalcode");
  assert(attribute.registerPath == "postalcode");

  DAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  // Json value = attribute.createValue();
  // assert(cast(DStringData)value);
}