/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.url;

import uim.models;

@safe:
class DUrlAttribute : DStringAttribute {
  mixin(AttributeThis!("UrlAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    name("url");
      registerPath("url");

   return true;

  }
}
mixin(AttributeCalls!("UrlAttribute"));

///
unittest {
  auto attribute = new DUrlAttribute;
  assert(attribute.name == "url");
  assert(attribute.registerPath == "url");

  DAttribute generalAttribute = attribute;
  assert(cast(DUrlAttribute)generalAttribute);
  assert(cast(DStringAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  // IData value = attribute.createValue();
  // assert(cast(DStringData)value);
}