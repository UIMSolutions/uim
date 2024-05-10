/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.lookups.strings.integer;

import uim.models;

@safe:
class DStringIntegerAttribute : DLookupAttribute {
  mixin(AttributeThis!("StringInteger"));

  mixin(TProperty!("int[string]", "lookups"));

  /* override Json createData() {
    return LookupData!(string, int).isNullable(isNullable);
  } */
}
mixin(AttributeCalls!("StringInteger"));

version(test_uim_models) { unittest {  
    // TODO tests
  }
}