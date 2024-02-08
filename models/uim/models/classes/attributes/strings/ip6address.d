/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.ip6address;

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
  mixin(AttributeThis!("IP6AddressAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configSettings = null) {
    super.initialize(configSettings);

    this
      .name("ip6address")
      .registerPath("ip6address");
  }
}
mixin(AttributeCalls!("IP6AddressAttribute"));

///
unittest {
  auto attribute = new DIP6AddressAttribute;
  assert(attribute.name == "ip6address");
  assert(attribute.registerPath == "ip6address");

  DAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  DData value = attribute.createValue();
  assert(cast(DStringValue)value);
}