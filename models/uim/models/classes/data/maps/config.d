/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.data.maps.config;

import uim.models;

@safe:
class DxConfigurationValue : DMapValue!string {
  // Constructors
  this() { initialize; }
}
auto ConfigurationValue() { return new DxConfigurationValue; }

///
unittest {
}
