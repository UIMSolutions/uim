/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.data.datetimes.timestamp;

import uim.models;

@safe:
class DTimestampValue : DLongValue {
  mixin(DataThis!("TimestampValue", "long"));  

  override IData copy() {
    return TimestampValue(attribute, toJson);
  }
  override IData dup() {
    return copy;
  }

  alias opEquals = DLongValue.opEquals;
}
mixin(ValueCalls!("TimestampValue", "long"));  

version(test_uim_models) { unittest {    
    // TODO
}} 