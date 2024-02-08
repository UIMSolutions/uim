/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.link;

import uim.models;

@safe:
class DLinkAttribute : DStringAttribute {
  mixin(AttributeThis!("LinkAttribute"));

  // Initialization hook method.
  override void initialize(IData[string] configSettings = null) {
    super.initialize(configSettings);

    this
      .name("link")
      .registerPath("link");
  }
}
mixin(AttributeCalls!("LinkAttribute"));

///
unittest {
  auto attribute = new DLinkAttribute;
  assert(attribute.name == "link");
  assert(attribute.registerPath == "link");

  DAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  DData value = attribute.createValue();
  assert(cast(DStringValue)value);
}