/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.strings.tickersymbol;

/* any <- char <- string <- tickerSymbol
Traits
is.dataFormat.character
is.dataFormat.big
is.dataFormat.array
means.identity.tickerSymbol */

import uim.models;

@safe:
class DTickerSymbolAttribute : DStringAttribute {
  mixin(AttributeThis!("TickerSymbol"));

  // Initialization hook method.
  override bool initialize(Json[string] initData = null) {
    if (!super.initialize(initData)) {
      return false;
    }

    registerPath("attributes.tickersymbol");

    return true;
  }
}

mixin(AttributeCalls!("TickerSymbol"));

///
unittest {
  auto attribute = new DTickerSymbolAttribute;
  assert(attribute.name == "TickerSymbolAttributes");
  assert(attribute.registerPath == "attributes.tickersymbol");

  DAttribute generalAttribute = attribute;
  assert(cast(DStringAttribute) generalAttribute);
  assert(!cast(DIntegerAttribute) generalAttribute);

  // Json value = attribute.createValue();
  // assert(cast(DStringData) value);
}
