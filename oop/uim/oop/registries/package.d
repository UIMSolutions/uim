/*********************************************************************************************************
	Copyright: © 2015 -2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.registries;

import uim.oop;
@safe:


/* class DOOPObjclassRegistry : DRegistry!DOOPObjclass {
  static DOOPObjclassRegistry registry;
}
auto ObjclassRegistry() {
  if (DOOPObjclassRegistry.registry.isNull) {
    DOOPObjclassRegistry.registry = new DOOPObjclassRegistry;
  }
  return DOOPObjclassRegistry.registry;
}

class DOOPAttclassRegistry : DRegistry!DAttribute {
  static DOOPAttclassRegistry registry;
}
auto AttributeRegistry() {
  if (DOOPAttclassRegistry.registry.isNull) {
    DOOPAttclassRegistry.registry = new DOOPAttclassRegistry;
  }
  return DOOPAttclassRegistry.registry;
} */

/* class DOOPAttributeRegistry : DRegistry!DOOPAttribute {
  static DOOPAttributeRegistry registry;
}
auto AttributeRegistry() {
  if (DOOPAttributeRegistry.registry.isNull) {
    DOOPAttributeRegistry.registry = new DOOPAttributeRegistry;
  }
  return DOOPAttributeRegistry.registry;
} */

interface IRegistrable {
  // #region registerPath
    // Setter registerPath
    O registerPath(this O)(string path);
    // Getter registerPath
    string registerPath();
  // #endregion registerPath
}