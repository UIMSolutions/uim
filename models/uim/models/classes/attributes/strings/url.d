/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.url;

import uim.models;

@safe:
class DUrlAttribute : DStringAttribute {
  mixin(AttributeThis!("Url"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) { return false; }

    registerPath("attributes.url");

   return true;

  }
}
mixin(AttributeCalls!("Url"));

///
unittest {
  auto attribute = new DUrlAttribute;
  assert(attribute.name == "UrlAttribute");
  assert(attribute.registerPath == "attributes.url");

  DAttribute generalAttribute = attribute;
  assert(cast(DUrlAttribute)generalAttribute);
  assert(cast(DStringAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  // Json value = attribute.createValue();
  // assert(cast(DStringData)value);
}