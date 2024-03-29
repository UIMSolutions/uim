/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.lookups.strings.boolean;

import uim.models;

@safe:
class DStringBooleanAttribute : DLookupAttribute {
  mixin(AttributeThis!("StringBooleanAttribute"));

  mixin(TProperty!("bool[string]", "lookups"));

  /* override IData createData() {
    return LookupData!(string, bool)(this).isNullable(isNullable);
  } */
}

mixin(AttributeCalls!("StringBooleanAttribute"));

version (test_uim_models) {
  unittest {
    // TODO tests
  }
}
