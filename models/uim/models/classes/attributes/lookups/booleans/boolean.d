/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.lookups.booleans.boolean;

import uim.models;

@safe:
class DBooleanBooleanAttribute : DLookupAttribute {
  mixin(AttributeThis!("BooleanBooleanAttribute"));

  mixin(TProperty!("bool[bool]", "lookups"));

  /* override IData createValue() {
    return LookupValue!(bool, bool)(this).isNullable(isNullable);
  } */
}
mixin(AttributeCalls!("BooleanBooleanAttribute"));

///
unittest {  
  auto lookupAttribute = BooleanBooleanAttribute;
  lookupAttribute.lookups[true] = false;
  lookupAttribute.lookups[false] = true;
  assert(!lookupAttribute.isNullable);

  lookupAttribute.isNullable(true);
  assert(lookupAttribute.isNullable);

  auto lookupValue = lookupAttribute.createValue;
}