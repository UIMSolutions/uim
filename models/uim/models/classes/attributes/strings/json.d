/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
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
  override void initialize(Json configSettings = Json(null)) {
    super.initialize(configSettings);

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

  DValue value = attribute.createValue();
  assert(cast(DStringValue)value);
}