/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
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
  mixin(AttributeThis!("JsonAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) { return false; }

    this
      .name("json")
      .registerPath("json");
  }
}
mixin(AttributeCalls!("JsonAttribute"));

///
unittest {
  auto attribute = new DJsonAttribute;
  assert(attribute.name == "json");
  assert(attribute.registerPath == "json");

  DAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute)generalAttribute);
  assert(!cast(DIntegerAttribute)generalAttribute);

  DData value = attribute.createValue();
  assert(cast(DStringData)value);
}