/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.integers.number;

import uim.models;

@safe:
class DNumberAttribute : DIntegerAttribute {
  mixin(AttributeThis!("Number"));
}
mixin(AttributeCalls!("Number"));

version(test_uim_models) { unittest {
    testAttribute(new DNumberAttribute);
    testAttribute(NumberAttribute);
  }
}