/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (UIManufaktur)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (UIManufaktur)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.registry;

import uim.models;

@safe:
class DAttributeRegistry : DObjectRegistry!DAttribute {
}

auto AttributeRegistry() { // Singleton
  return DAttributeRegistry.instance;
}