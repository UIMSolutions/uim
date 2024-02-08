/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
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
  mixin(AttributeThis!("IP4AddressAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false: }

    this
      .name("ip4address")
      .registerPath("ip4address");
  }
}
mixin(AttributeCalls!("IP4AddressAttribute"));

///
unittest {
  auto attribute = new DIP4AddressAttribute;
  assert(attribute.name == "ip4address");
  assert(attribute.registerPath == "ip4address");

  DAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  DData value = attribute.createValue();
  assert(cast(DStringData)value);
}