/*********************************************************************************************************
	Copyright: © 2015-2024 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.models.classes.elements.configuration;

import uim.models;

@safe:
class DConfigurationElement : DElement {
  // Constructors
  this() { initialize; }
}
auto ConfigurationElement() { return new DConfigurationElement; }
/* auto Configuration(string name) { return new DConfiguration(name); }
auto Configuration(Json json) { return new DConfiguration(json); } */

///
unittest {
  auto element = new DConfigurationElement;
  element.name("test");
  assert(element.name == "test");
  element.name("testName");
  assert(element.name == "testName");
}
