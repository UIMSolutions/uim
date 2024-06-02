/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.json;

/* A JSON fragment contained within one string value

Inheritance
any <- char <- string <- json
Traits
is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.content.text.JSON
 */

import uim.models;

@safe:
class DJsonAttribute : DStringAttribute {
  mixin(AttributeThis!("Json"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("json");
    registerPath("json");

    return true;
  }
}

mixin(AttributeCalls!("Json"));

///
unittest {
  auto attribute = new DJsonAttribute;
  assert(attribute.name == "json");
  assert(attribute.registerPath == "json");

  DAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute) generalAttribute);
  assert(!cast(DIntegerAttribute) generalAttribute);

  // Json value = attribute.createValue();
  // assert(cast(DStringData) value);
}
