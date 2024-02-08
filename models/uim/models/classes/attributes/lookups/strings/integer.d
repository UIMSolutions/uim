/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.lookups.strings.integer;

import uim.models;

@safe:
class DStringIntegerAttribute : DLookupAttribute {
  mixin(AttributeThis!("StringIntegerAttribute"));

  mixin(OProperty!("int[string]", "lookups"));

  override DData createValue() {
    return LookupValue!(string, int).isNullable(isNullable);
  }
}
mixin(AttributeCalls!("StringIntegerAttribute"));

version(test_uim_models) { unittest {  
    // TODO tests
  }
}