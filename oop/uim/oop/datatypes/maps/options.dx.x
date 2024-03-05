/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.classes.data.maps.options;

import uim.oop;

@safe:
class DOptions : DMapData!string {
  // Constructors
  this() { initialize; }

	alias opEquals = DData.opEquals;
}
auto Options() { return new DOptions; }

///
unittest {
}
