/*********************************************************************************************************
  Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.lookups.booleans.boolean;

import uim.models;

@safe:
class DBooleanBooleanAttribute : DLookupAttribute {
  mixin(AttributeThis!("BooleanBoolean"));

  mixin(TProperty!("bool[bool]", "lookups"));
  // TODO
  /* override Json createData() {
    return LookupData!(bool, bool)(this).isNullable(isNullable);
  } */
}
mixin(AttributeCalls!("BooleanBoolean"));

///
unittest {  
  auto lookupAttribute = BooleanBooleanAttribute;
  lookupAttribute.lookups[true] = false;
  lookupAttribute.lookups[false] = true;
  assert(!lookupAttribute.isNullable);

  lookupAttribute.isNullable(true);
  assert(lookupAttribute.isNullable);

  auto LookupData = lookupAttribute.createValue;
}