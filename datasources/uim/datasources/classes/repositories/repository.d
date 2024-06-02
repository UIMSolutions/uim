/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.datasources.repositories.repository;

@safe:
import uim.datasources;

class DDatasourceRepository {
  mixin TConfigurable;

  this() {
    initialize;
  }

  // Hook method
  bool initialize(Json[string] initData = null) {
    configuration(MemoryConfiguration);
    configuration.data(initData);

    return true;
  }
}
