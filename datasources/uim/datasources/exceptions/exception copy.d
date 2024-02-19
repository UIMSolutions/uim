/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.datasources.uim.datasources.exceptions.exception copy;

import uim.datasources;

@safe:
// General exception of uim.datasources
class DatasourceException {
  this() {
    initialize;
  }

  // Hook for object initialization
  void initialize() {
  }
}

auto DSOException() {
  return DatasourceException;
}
