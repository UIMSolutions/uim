/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.entityname;

import uim.models;

@safe:

/* Type for mixin template parameters that take entity names as values
is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.entityName
means.entityName */
class DEntityNameAttribute : DStringAttribute {
  mixin(AttributeThis!("EntityName"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    name("entityname");
    registerPath("entityName");

    return true;
  }
}

mixin(AttributeCalls!("EntityName"));

///
unittest {
  auto attribute = new DEntityNameAttribute;
  assert(attribute.name == "entityname");
  assert(attribute.registerPath == "entityName");
}
