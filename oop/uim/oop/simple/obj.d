/*********************************************************************************************************
	Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
	License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
	Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.simple.obj;

import uim.oop;
@safe:

class DOOPSimpleObject : DOOPObject {
	this() { super(); }
}
auto OOPSimpleObject() { return new DOOPSimpleObject; }

version(test_uim_oop) { unittest { /// TODO 
	// TODO
}}
