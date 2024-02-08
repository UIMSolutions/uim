/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.lookups.booleans.string_;

import uim.models;

@safe:
class DBooleanStringAttribute : DAttribute {
  mixin(AttributeThis!("BooleanStringAttribute"));

  mixin(OProperty!("string[bool]", "lookups"));

  override IData createValue() {
    return LookupValue!(bool, string)(this).isNullable(isNullable);
  }
}
mixin(AttributeCalls!("BooleanStringAttribute"));

version(test_uim_models) { unittest {  
    // TODO tests
  }
}