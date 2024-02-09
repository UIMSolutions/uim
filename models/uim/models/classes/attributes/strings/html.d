/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.html;

/* A HTML fragment contained within one string value

Inheritance
any <- char <- string <- html
Traits
is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.content.text.HTML
 */

import uim.models;

@safe:
class DHtmlAttribute : DStringAttribute {
  mixin(AttributeThis!("HtmlAttribute"));

  // Initialization hook method.
  override bool initialize(IData[string] configData = null) {
    if (!super.initialize(configData)) {
      return false;
    }

    name("html");
    registerPath("html");

    return true;
  }
}

mixin(AttributeCalls!("HtmlAttribute"));

///
unittest {
  auto attribute = new DHtmlAttribute;
  assert(attribute.name == "html");
  assert(attribute.registerPath == "html");

  DAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute) generalAttribute);
  assert(!cast(DIntegerAttribute) generalAttribute);

  // IData value = attribute.createValue();
  // assert(cast(DStringData) value);
}
