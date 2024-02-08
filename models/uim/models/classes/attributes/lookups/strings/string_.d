/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.lookups.strings.string_;

import uim.models;

@safe:
class DStringStringAttribute : DLookupAttribute {
  mixin(AttributeThis!("StringStringAttribute"));
  
  mixin(TProperty!("STRINGAA", "lookups"));

  /* override IData createValue() {
    return LookupValue!(string, string).isNullable(isNullable);
  } */
}
mixin(AttributeCalls!("StringStringAttribute"));

version(test_uim_models) { unittest {  
    // TODO tests
  }
}