/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
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
  override void initialize(IData[string] configSettings = null) {
    super.initialize(configSettings);

    this
      .name("postalcode")
      .registerPath("postalcode");
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

  DData value = attribute.createValue();
  assert(cast(DStringValue)value);
}