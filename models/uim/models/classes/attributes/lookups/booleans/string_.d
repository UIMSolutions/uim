/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.lookups.booleans.string_;

import uim.models;

@safe:
class DBooleanStringAttribute : DAttribute {
  mixin(AttributeThis!("BooleanString"));

  mixin(TProperty!("string[bool]", "lookups"));

  /* override Json createData() {
    return LookupData!(bool, string)(this).isNullable(isNullable);
  } */
}
mixin(AttributeCalls!("BooleanString"));

version(test_uim_models) { unittest {  
    // TODO tests
  }
}