/*********************************************************************************************************
  Copyright: © 2015-2023 Ozan Nurettin Süel (Sicherheitsschmiede)                                        
  License: Subject to the terms of the Apache 2.0 license, as written in the included LICENSE.txt file.  
  Authors: Ozan Nurettin Süel (Sicherheitsschmiede)                                                      
**********************************************************************************************************/
module uim.oop.simple.templ;

import uim.oop;

class DOOPSimpleTempl(T) : DOOPSimpleObject {
	this() { super(); }
}
auto OOPSimpleTempl(T)() { return new DOOPSimpleTempl!T; }

version(test_uim_oop) { unittest {
	// TODO
}}