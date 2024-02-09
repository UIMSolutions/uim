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
  mixin(AttributeThis!("PostalCodeAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false; }

    name("postalcode");
      registerPath("postalcode");

      return true;
  }
}
mixin(AttributeCalls!("PostalCodeAttribute"));

///
unittest {
  auto attribute = new DPostalCodeAttribute;
  assert(attribute.name == "postalcode");
  assert(attribute.registerPath == "postalcode");

  DAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  // IData value = attribute.createValue();
  // assert(cast(DStringData)value);
}