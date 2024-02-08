/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.values.maps.options;

import uim.models;

@safe:
class DOptions : DMapValue!string {
  // Constructors
  this() { initialize; }

	alias opEquals = DValue.opEquals;
}
auto Options() { return new DOptions; }

///
unittest {
}
