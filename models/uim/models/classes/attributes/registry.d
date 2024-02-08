/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.attributes.registry;

import uim.models;

@safe:
class DAttributeRegistry : DRegistry!DAttribute {
  static DAttributeRegistry registry;
}

auto AttributeRegistry() { // SIngleton
  if (DAttributeRegistry.registry is null) {
    DAttributeRegistry.registry = new DAttributeRegistry;
  }
  return DAttributeRegistry.registry;
}