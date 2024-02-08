/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
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
  mixin(AttributeThis!("TimezoneAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configSettings = null) {
    super.initialize(configSettings);

    this
      .name("timezone")
      .registerPath("timezone");
  }
}
mixin(AttributeCalls!("TimezoneAttribute"));

///
unittest {
  auto attribute = new DTimezoneAttribute;
  assert(attribute.name == "timezone");
  assert(attribute.registerPath == "timezone");

  DAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  DData value = attribute.createValue();
  assert(cast(DStringValue)value);
}