/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.data.datetimes.timestamp;

import uim.models;

@safe:
class DTimestampData : DLongData {
  mixin(DataThis!("TimestampData", "long"));  

  override IData clone() {
    return TimestampData(attribute, toJson);
  }

  alias opEquals = DLongData.opEquals;
}
mixin(ValueCalls!("TimestampData", "long"));  

version(test_uim_models) { unittest {    
    // TODO
}} 