/***********************************************************************************
*	Copyright: ©2015 - 2024 Ozan Nurettin Süel (sicherheitsschmiede)                   *
*	License  : Licensed under Apache 2 [https://apache.org/licenses/LICENSE-2.0.txt] *
*	Author   : Ozan Nurettin Süel (Sicherheitsschmiede)										           * 
***********************************************************************************/
module uim.oop.complex.obj;

import uim.oop;

class DOOPComplexObj : DOOPObject {
	this() { super(); }
}
auto OOPComplexObj() { return new DOOPComplexObj; }

version(test_uim_oop) { unittest {
		/// TODO
	}}

