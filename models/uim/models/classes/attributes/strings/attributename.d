/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.attributename;

// Type for trait parameters that take attribute names as values

import uim.models;

@safe:
class DAttributeNameAttribute : DStringAttribute {
  mixin(AttributeThis!("AttributeNameAttribute"));

  /*
attributeName
Description

Type for trait parameters that take attribute names as values

Inheritance
any <- char <- string <- attributeName
Traits
is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.attributeName

  */

  // Initialization hook method.
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

    this
      .name("attributeName")
      .registerPath("attributeName");
  }
}
mixin(AttributeCalls!("AttributeNameAttribute"));

///
unittest {
  auto attribute = new DAttributeNameAttribute;
  assert(attribute.name == "attributeName");
  assert(attribute.registerPath == "attributeName");

  DAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  DValue value = attribute.createValue();
  assert(cast(DStringValue)value);
}