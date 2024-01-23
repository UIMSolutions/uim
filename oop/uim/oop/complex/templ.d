/***********************************************************************************
*	Copyright: ©2015 -2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.complex.templ;

import uim.oop;

class DOOPComplexTempl(T) : DOOPComplexObj {
	this() { super(); }
}
auto OOPComplexTempl(T)() { return new DOOPComplexTempl!T; }

version(test_uim_oop) { unittest {
		/// TODO
	}}
