/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.lookups.strings.string_;

import uim.models;

@safe:
class DStringStringAttribute : DLookupAttribute {
  mixin(AttributeThis!("StringString"));
  
  mixin(TProperty!("STRINGAA", "lookups"));

  /* override Json createData() {
    return LookupData!(string, string).isNullable(isNullable);
  } */
}
mixin(AttributeCalls!("StringString"));

version(test_uim_models) { unittest {  
    // TODO tests
  }
}